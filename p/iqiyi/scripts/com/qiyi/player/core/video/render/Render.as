package com.qiyi.player.core.video.render
{
	import flash.events.EventDispatcher;
	import com.qiyi.player.core.player.coreplayer.ICorePlayer;
	import flash.display.Sprite;
	import com.qiyi.player.core.video.engine.IEngine;
	import com.qiyi.player.core.video.decoder.IDecoder;
	import com.qiyi.player.core.model.IMovie;
	import flash.media.Video;
	import flash.geom.Rectangle;
	import com.qiyi.player.base.logging.ILogger;
	import com.qiyi.player.base.pub.EnumItem;
	import com.qiyi.player.core.video.def.VideoAccEnum;
	import com.qiyi.player.core.video.events.EngineEvent;
	import com.qiyi.player.core.video.events.DecoderEvent;
	import com.qiyi.player.core.model.events.MovieEvent;
	import com.qiyi.player.core.model.impls.pub.Settings;
	import com.qiyi.player.core.video.events.RenderEvent;
	import com.qiyi.player.base.utils.ColorMatrix;
	import flash.filters.ColorMatrixFilter;
	import com.qiyi.player.core.player.def.PlayerUseTypeEnum;
	import flash.events.Event;
	import com.qiyi.player.base.logging.Log;
	
	public class Render extends EventDispatcher implements IRender
	{
		
		protected var _holder:ICorePlayer;
		
		protected var _parent:Sprite;
		
		protected var _engine:IEngine;
		
		protected var _decoder:IDecoder;
		
		protected var _movie:IMovie;
		
		protected var _video:Video;
		
		protected var _settingArea:Rectangle;
		
		protected var _realArea:Rectangle;
		
		private var _videoStatus:String;
		
		private var _puman:Boolean = false;
		
		private var _zoom:int = 100;
		
		private var _widthRate:int;
		
		private var _heightRate:int;
		
		protected var _log:ILogger;
		
		public function Render(param1:ICorePlayer, param2:Sprite)
		{
			this._log = Log.getLogger("com.qiyi.player.core.video.render.Render");
			super();
			this._holder = param1;
			this._parent = param2;
			this._settingArea = new Rectangle();
			this._realArea = new Rectangle();
			this._video = new Video();
			this._video.addEventListener(RenderEvent.Evt_RenderState,this.onRenderStateChangeEvent);
			this._parent.addChild(this._video);
			Settings.instance.addEventListener(Settings.Evt_VideoAttriChanged,this.onVideoAttriChanged);
			Settings.instance.addEventListener(Settings.Evt_VideoRateChanged,this.onVideoRateChanged);
			this.setVideoDisplaySettings(Settings.instance.brightness,Settings.instance.contrast);
			this.setVideoRate(Settings.instance.videoRateWidth,Settings.instance.videoRateHeight);
		}
		
		public function get accStatus() : EnumItem
		{
			switch(this._videoStatus)
			{
				case "accelerated":
					return VideoAccEnum.CPU_ACCELERATED;
				case "software":
					return VideoAccEnum.CPU_SOFTWARE;
				default:
					return VideoAccEnum.UNKNOWN;
			}
		}
		
		public function bind(param1:IEngine, param2:IDecoder, param3:IMovie) : void
		{
			if(this._engine)
			{
				this._engine.removeEventListener(EngineEvent.Evt_DefinitionSwitched,this.onDefinitionChanged);
				this._engine.removeEventListener(EngineEvent.Evt_AudioTrackSwitched,this.onAudioTrackChanged);
			}
			this._engine = param1;
			this._engine.addEventListener(EngineEvent.Evt_DefinitionSwitched,this.onDefinitionChanged);
			this._engine.addEventListener(EngineEvent.Evt_AudioTrackSwitched,this.onAudioTrackChanged);
			if(this._decoder)
			{
				this._decoder.removeEventListener(DecoderEvent.Evt_MetaData,this.onDecoderMetaData);
			}
			this._decoder = param2;
			this._video.attachNetStream(param2.netstream);
			if(this._movie)
			{
				this._movie.removeEventListener(MovieEvent.Evt_Meta_Ready,this.onMovieMetaReady);
			}
			this._movie = param3;
			this._movie.addEventListener(MovieEvent.Evt_Meta_Ready,this.onMovieMetaReady);
			this.changeVideoSize();
			this.updateSmoothing(this._movie);
		}
		
		public function releaseBind() : void
		{
			this._video.attachNetStream(null);
			if(this._movie)
			{
				this._movie.removeEventListener(MovieEvent.Evt_Meta_Ready,this.onMovieMetaReady);
				this._movie = null;
			}
		}
		
		public function tryUseGPU() : void
		{
		}
		
		public function tryUpGPUDepth() : void
		{
		}
		
		public function destroy() : void
		{
			Settings.instance.removeEventListener(Settings.Evt_VideoAttriChanged,this.onVideoAttriChanged);
			Settings.instance.removeEventListener(Settings.Evt_VideoRateChanged,this.onVideoRateChanged);
			if(this._engine)
			{
				this._engine.removeEventListener(EngineEvent.Evt_DefinitionSwitched,this.onDefinitionChanged);
				this._engine.removeEventListener(EngineEvent.Evt_AudioTrackSwitched,this.onAudioTrackChanged);
				this._engine = null;
			}
			this._video.removeEventListener(RenderEvent.Evt_RenderState,this.onRenderStateChangeEvent);
			this._video.attachNetStream(null);
			this._parent.removeChild(this._video);
			this._video = null;
			this._parent = null;
			if(this._movie)
			{
				this._movie.removeEventListener(MovieEvent.Evt_Meta_Ready,this.onMovieMetaReady);
				this._movie = null;
			}
			this._holder = null;
			if(this._decoder)
			{
				this._decoder.removeEventListener(DecoderEvent.Evt_MetaData,this.onDecoderMetaData);
				this._decoder = null;
			}
		}
		
		public function setRect(param1:int, param2:int, param3:int, param4:int) : void
		{
			this._settingArea.x = param1;
			this._settingArea.y = param2;
			this._settingArea.width = param3;
			this._settingArea.height = param4;
			this.changeVideoSize();
		}
		
		public function getSettingArea() : Rectangle
		{
			return this._settingArea;
		}
		
		public function setZoom(param1:int) : void
		{
			if(this._zoom != param1)
			{
				this._zoom = param1;
				this.changeVideoSize();
			}
		}
		
		public function getRealArea() : Rectangle
		{
			return this._realArea;
		}
		
		public function setVideoDisplaySettings(param1:int, param2:int) : void
		{
			var _loc3:ColorMatrix = null;
			var _loc4:ColorMatrixFilter = null;
			if(this._holder.runtimeData.playerUseType == PlayerUseTypeEnum.MAIN)
			{
				if(!(param1 == 50) || !(param2 == 50))
				{
					_loc3 = new ColorMatrix();
					_loc3.adjustColor(this.changeBrightnessValue(param1),this.changeBrightnessValue(param2),0,0);
					_loc4 = new ColorMatrixFilter(_loc3);
					this._video.filters = [_loc4];
				}
				else
				{
					this._video.filters = [];
				}
			}
		}
		
		public function clearVideo() : void
		{
			this._video.clear();
		}
		
		public function setPuman(param1:Boolean) : void
		{
			if(this._puman != param1)
			{
				this._puman = param1;
				this.changeVideoSize();
			}
		}
		
		public function setVideoRate(param1:int, param2:int) : void
		{
			if(this._holder.runtimeData.playerUseType == PlayerUseTypeEnum.MAIN)
			{
				if(!(this._widthRate == param1) || !(this._heightRate == param2))
				{
					this._widthRate = param1;
					this._heightRate = param2;
					this.changeVideoSize();
				}
			}
		}
		
		protected function changeVideoSize() : void
		{
			var _loc2:* = 0;
			var _loc3:* = 0;
			var _loc4:* = 0;
			var _loc5:* = 0;
			this._log.info("video size changed: " + this._settingArea.toString());
			if(this._movie == null)
			{
				return;
			}
			if(this._puman)
			{
				this._video.height = this._realArea.height = this._settingArea.height;
				this._video.width = this._realArea.width = this._settingArea.width;
				this._video.y = this._realArea.y = this._settingArea.y;
				this._video.x = this._realArea.x = this._settingArea.x;
				dispatchEvent(new RenderEvent(RenderEvent.Evt_RenderAreaChanged));
				return;
			}
			var _loc1:Number = 0;
			if(this._widthRate == 0 || this._heightRate == 0)
			{
				if(this._movie.width > 0 && this._movie.height > 0)
				{
					_loc1 = this._movie.width / this._movie.height;
				}
				else if(this._decoder.metadata)
				{
					_loc1 = this._decoder.metadata.width / this._decoder.metadata.height;
				}
				else
				{
					this._video.height = this._realArea.height = this._settingArea.height;
					this._video.width = this._realArea.width = this._settingArea.width;
					this._video.y = this._realArea.y = this._settingArea.y;
					this._video.x = this._realArea.x = this._settingArea.x;
					dispatchEvent(new RenderEvent(RenderEvent.Evt_RenderAreaChanged));
					this._log.info("video size : waiting metadata!");
					if(!this._decoder.hasEventListener(DecoderEvent.Evt_MetaData))
					{
						this._decoder.addEventListener(DecoderEvent.Evt_MetaData,this.onDecoderMetaData);
					}
					return;
				}
				
			}
			else
			{
				_loc1 = this._widthRate / this._heightRate;
			}
			if(_loc1 <= this._settingArea.width / this._settingArea.height)
			{
				_loc5 = this._settingArea.height;
				_loc4 = this._settingArea.height * _loc1;
			}
			else
			{
				_loc5 = this._settingArea.width / _loc1;
				_loc4 = this._settingArea.width;
			}
			if(this._zoom != 100)
			{
				_loc5 = _loc5 * this._zoom / 100;
				_loc4 = _loc4 * this._zoom / 100;
			}
			_loc2 = this._settingArea.x + (this._settingArea.width - _loc4) / 2;
			_loc3 = this._settingArea.y + (this._settingArea.height - _loc5) / 2;
			this._video.x = this._realArea.x = _loc2;
			this._video.y = this._realArea.y = _loc3;
			this._video.width = this._realArea.width = _loc4;
			this._video.height = this._realArea.height = _loc5;
			dispatchEvent(new RenderEvent(RenderEvent.Evt_RenderAreaChanged));
		}
		
		private function onDecoderMetaData(param1:Event) : void
		{
			this._decoder.removeEventListener(DecoderEvent.Evt_MetaData,this.onDecoderMetaData);
			this.changeVideoSize();
		}
		
		private function onMovieMetaReady(param1:Event) : void
		{
			this.changeVideoSize();
		}
		
		private function onRenderStateChangeEvent(param1:*) : void
		{
			this._log.info("Render State Changed : " + param1.status);
			this._videoStatus = param1.status;
		}
		
		private function onDefinitionChanged(param1:EngineEvent) : void
		{
			var _loc2:Number = Number(param1.data);
			if(_loc2 >= 0)
			{
				this.updateSmoothing(this._movie);
			}
		}
		
		private function onAudioTrackChanged(param1:EngineEvent) : void
		{
			var _loc2:Number = Number(param1.data);
			if(_loc2 >= 0)
			{
				this.updateSmoothing(this._movie);
			}
		}
		
		private function onVideoAttriChanged(param1:Event) : void
		{
			this.setVideoDisplaySettings(Settings.instance.brightness,Settings.instance.contrast);
		}
		
		private function onVideoRateChanged(param1:Event) : void
		{
			this.setVideoRate(Settings.instance.videoRateWidth,Settings.instance.videoRateHeight);
		}
		
		private function changeBrightnessValue(param1:int) : int
		{
			return param1 * 2 - 100;
		}
		
		private function changeContrastValue(param1:int) : int
		{
			return param1 - 50;
		}
		
		private function updateSmoothing(param1:IMovie) : void
		{
			this._video.smoothing = true;
		}
	}
}
