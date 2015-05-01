package com.qiyi.player.core.video.render {
	import com.qiyi.player.base.pub.EnumItem;
	import com.qiyi.player.core.video.def.VideoAccEnum;
	import com.qiyi.player.core.video.events.RenderEvent;
	import com.qiyi.player.core.model.impls.pub.Settings;
	import com.qiyi.player.core.video.engine.IEngine;
	import com.qiyi.player.core.video.decoder.IDecoder;
	import com.qiyi.player.core.model.IMovie;
	import flash.net.NetStream;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.events.Event;
	import com.qiyi.player.core.player.coreplayer.ICorePlayer;
	import flash.display.Sprite;
	
	public class StageVideoRender extends Render {
		
		public function StageVideoRender(param1:ICorePlayer, param2:Sprite) {
			super(param1,param2);
			StageVideoManager.instance.addEventListener(StageVideoManager.AVAILABILITY,this.onStageVideoAvailability);
			Settings.instance.addEventListener(Settings.Evt_UseGPU,this.onUseGPUChanged);
		}
		
		private var _stageVideoInUse:Boolean = false;
		
		private var _stageVideo:Object = null;
		
		private var _stageVideoStatus:String = "unknown";
		
		private var _decoderUpdate:Boolean = false;
		
		override public function get accStatus() : EnumItem {
			if(this._stageVideoInUse) {
				switch(this._stageVideoStatus) {
					case "accelerated":
						return VideoAccEnum.GPU_ACCELERATED;
					case "software":
						return VideoAccEnum.GPU_RENDERING;
				}
			}
			return super.accStatus;
		}
		
		override public function setVideoDisplaySettings(param1:int, param2:int) : void {
			super.setVideoDisplaySettings(param1,param2);
			this.tryUseGPU();
		}
		
		override public function releaseBind() : void {
			super.releaseBind();
			if(this._stageVideo) {
				this._stageVideo.removeEventListener(RenderEvent.Evt_RenderState,this.onStageVideoRenderStateEvent);
				this._stageVideo.attachNetStream(null);
				StageVideoManager.instance.release(this._stageVideo);
			}
			this._stageVideo = null;
			this._stageVideoInUse = false;
		}
		
		override public function destroy() : void {
			Settings.instance.removeEventListener(Settings.Evt_UseGPU,this.onUseGPUChanged);
			StageVideoManager.instance.removeEventListener(StageVideoManager.AVAILABILITY,this.onStageVideoAvailability);
			if(this._stageVideo) {
				this._stageVideo.removeEventListener(RenderEvent.Evt_RenderState,this.onStageVideoRenderStateEvent);
				this._stageVideo.attachNetStream(null);
				StageVideoManager.instance.release(this._stageVideo);
			}
			this._stageVideo = null;
			this._stageVideoInUse = false;
			this._stageVideoStatus = "";
			super.destroy();
		}
		
		override public function bind(param1:IEngine, param2:IDecoder, param3:IMovie) : void {
			this._decoderUpdate = !(_decoder == param2);
			super.bind(param1,param2,param3);
			this.tryUseGPU();
		}
		
		override protected function changeVideoSize() : void {
			super.changeVideoSize();
			this.trySetViewPort();
		}
		
		override public function tryUseGPU() : void {
			var _loc1_:* = false;
			if((_holder.runtimeData.supportGPU) && (_decoder)) {
				_loc1_ = false;
				if((Settings.instance.useGPU) && Settings.instance.brightness == 50 && Settings.instance.contrast == 50) {
					_loc1_ = StageVideoManager.instance.stageVideoIsAvailable;
				}
				if(_loc1_ != this._stageVideoInUse) {
					this._stageVideoInUse = _loc1_;
					this.setUseGPU();
				} else if(this._decoderUpdate) {
					if(this._stageVideo) {
						this._stageVideo.attachNetStream(null);
						this._stageVideo.attachNetStream(_decoder as NetStream);
					} else {
						_video.attachNetStream(null);
						_video.attachNetStream(_decoder as NetStream);
					}
					this._decoderUpdate = false;
				}
				
			}
		}
		
		override public function tryUpGPUDepth() : void {
			if((this._stageVideo) && !_holder.isPreload) {
				this._stageVideo.depth = StageVideoManager.instance.getNewDepth();
				this.trySetViewPort();
			}
		}
		
		private function setUseGPU() : void {
			_log.info((this._stageVideoInUse?"start":"stop") + " user GPU!");
			if(this._stageVideoInUse) {
				if(this._stageVideo) {
					this._stageVideo.removeEventListener(RenderEvent.Evt_RenderState,this.onStageVideoRenderStateEvent);
					this._stageVideo.attachNetStream(null);
					StageVideoManager.instance.release(this._stageVideo);
				}
				this._stageVideo = StageVideoManager.instance.getStageVideo();
				if(this._stageVideo == null) {
					this._stageVideoInUse = false;
					_video.visible = true;
					_video.attachNetStream(null);
					_video.attachNetStream(_decoder as NetStream);
				} else {
					if(_holder.isPreload) {
						this._stageVideo.depth = 0;
						this._stageVideo.viewPort = new Rectangle(-2,-2,1,1);
					} else {
						this._stageVideo.depth = StageVideoManager.instance.getNewDepth();
						this.trySetViewPort();
					}
					this._stageVideo.addEventListener(RenderEvent.Evt_RenderState,this.onStageVideoRenderStateEvent);
					this._stageVideo.attachNetStream(_decoder as NetStream);
					_video.visible = false;
				}
			} else {
				if(this._stageVideo) {
					this._stageVideo.removeEventListener(RenderEvent.Evt_RenderState,this.onStageVideoRenderStateEvent);
					this._stageVideo.attachNetStream(null);
					StageVideoManager.instance.release(this._stageVideo);
					this._stageVideo = null;
				}
				_video.visible = true;
				_video.attachNetStream(null);
				_video.attachNetStream(_decoder as NetStream);
			}
		}
		
		private function trySetViewPort() : void {
			var _loc1_:Point = null;
			if((this._stageVideo) && (_realArea.width > 0) && _realArea.height > 0) {
				_loc1_ = _parent.localToGlobal(new Point(_realArea.x,_realArea.y));
				this._stageVideo.viewPort = new Rectangle(_loc1_.x,_loc1_.y,_realArea.width,_realArea.height);
			}
		}
		
		private function onStageVideoRenderStateEvent(param1:*) : void {
			_log.info("StageVideo Render State : " + param1.status);
			this._stageVideoStatus = param1.status;
			if(param1.status != "unavailable") {
				this.trySetViewPort();
				dispatchEvent(new RenderEvent(RenderEvent.Evt_GPUChanged,true));
			} else {
				this._stageVideoInUse = false;
				this.setUseGPU();
				dispatchEvent(new RenderEvent(RenderEvent.Evt_GPUChanged,false));
			}
		}
		
		private function onUseGPUChanged(param1:Event) : void {
			this.tryUseGPU();
		}
		
		private function onStageVideoAvailability(param1:Event) : void {
			this.tryUseGPU();
		}
	}
}
