package com.sohu.tv.mediaplayer.video {
	import flash.media.Video;
	import flash.net.NetStream;
	import flash.media.StageVideo;
	import flash.geom.Rectangle;
	import flash.events.StageVideoEvent;
	import flash.events.VideoEvent;
	import flash.display.Stage;
	
	public class TvSohuVideo extends Video {
		
		public function TvSohuVideo(param1:Stage) {
			super();
			this.id = Math.random() * 1000 >> 0;
			this.infoWr = new InfoWriter();
			this.allsvd = param1.stageVideos;
			this.svdLen = this.allsvd.length;
			this.svdAvaliable = this.svdLen >= 2;
			addEventListener(VideoEvent.RENDER_STATE,this.onVdRender);
			if((this.svdAvaliable) && !this.svd_a && !this.svd_b) {
				this.svd_a = this.allsvd[0];
				this.svd_b = this.allsvd[1];
				this.curSvd = this.svd_a;
				this.nexSvd = this.svd_b;
				this.infoWr.setSvdLen(this.svdLen);
				this.infoWr.setColorSpace(this.curSvd.colorSpaces);
			}
			if((this.svdAvaliable) && (this.svd_a) && (this.svd_b)) {
				this.svd_a.addEventListener(StageVideoEvent.RENDER_STATE,this.onSvdRender);
				this.svd_b.addEventListener(StageVideoEvent.RENDER_STATE,this.onSvdRender);
			}
		}
		
		public static const VIDEO_MODE:int = 0;
		
		public static const STG_VIDEO_MODE:int = 1;
		
		private static const svd_msg:String = "\nstage video not avaliable!\nwhen it unavaliable, do not set the predictMode to STG_VIDEO_MODE!";
		
		public static var predictMode:int = VIDEO_MODE;
		
		private static var lastVisiTrueObj:TvSohuVideo;
		
		private static var curStm:NetStream;
		
		private static var nexStm:NetStream;
		
		private static var S_curSvd:StageVideo;
		
		private static var S_nexSvd:StageVideo;
		
		private static var S_svd_a:StageVideo;
		
		private static var S_svd_b:StageVideo;
		
		private static var svdRect:Rectangle = new Rectangle(0,0,1,1);
		
		public static function updateSvdWHXY(param1:Number, param2:Number, param3:Number, param4:Number) : void {
			svdRect = new Rectangle(param3,param4,param1,param2);
			S_svd_a.viewPort = svdRect;
			S_svd_b.viewPort = svdRect;
		}
		
		private var allsvd:Vector.<StageVideo>;
		
		private var svdLen:int = 0;
		
		private var infoWr:InfoWriter;
		
		private var svdAvaliable:Boolean;
		
		private var id:int;
		
		private function onSvdRender(param1:StageVideoEvent) : void {
			this.infoWr.setRenderStat("S_" + param1.status);
			this.infoWr.setCurColor(param1.colorSpace);
		}
		
		private function onVdRender(param1:VideoEvent) : void {
			this.infoWr.setRenderStat("V_" + param1.status);
			this.infoWr.setCurColor("--");
		}
		
		public function dispose() : void {
			this.infoWr.dispose();
			this.infoWr = null;
			this.allsvd = null;
			if((parent) && (parent.contains(this))) {
				parent.removeChild(this);
			}
			if((this.svdAvaliable) && (this.svd_a) && (this.svd_b)) {
				this.svd_a.removeEventListener(StageVideoEvent.RENDER_STATE,this.onSvdRender);
				this.svd_b.removeEventListener(StageVideoEvent.RENDER_STATE,this.onSvdRender);
			}
			removeEventListener(VideoEvent.RENDER_STATE,this.onVdRender);
		}
		
		public function activateSvd() : void {
			this.curSvd.attachNetStream(curStm);
			super.attachNetStream(null);
			super.visible = false;
		}
		
		public function activateVd() : void {
			super.attachNetStream(curStm);
			super.clear();
			this.curSvd.attachNetStream(null);
			var _loc1_:Rectangle = svdRect.clone();
			_loc1_.x = -5000;
			this.nexSvd.viewPort = _loc1_;
			super.visible = true;
		}
		
		override public function attachNetStream(param1:NetStream) : void {
			super.attachNetStream(param1);
			this.infoWr.updateTarget(param1);
			curStm = param1;
		}
		
		public function attachSvdCurStream(param1:NetStream) : void {
			this.curSvd.attachNetStream(param1);
			this.infoWr.updateTarget(param1);
			curStm = param1;
		}
		
		public function attachSvdNextStream(param1:NetStream) : void {
			this.nexSvd.attachNetStream(param1);
			nexStm = param1;
		}
		
		override public function set visible(param1:Boolean) : void {
			var _loc2_:Rectangle = null;
			if(param1) {
				if(predictMode === STG_VIDEO_MODE) {
					super.visible = false;
					this.curSvd.depth = this.svdLen - 1;
					this.curSvd.viewPort = svdRect;
					lastVisiTrueObj = this;
				} else {
					super.visible = true;
				}
			} else {
				if(predictMode === STG_VIDEO_MODE) {
					if(lastVisiTrueObj === this) {
						if(this.curSvd === this.svd_a) {
							this.curSvd = this.svd_b;
							this.nexSvd = this.svd_a;
						} else {
							this.curSvd = this.svd_a;
							this.nexSvd = this.svd_b;
						}
						_loc2_ = svdRect.clone();
						_loc2_.x = -5000;
						this.nexSvd.viewPort = _loc2_;
						this.nexSvd.depth = 1;
						lastVisiTrueObj = null;
					}
				}
				super.visible = false;
			}
		}
		
		public function get info() : TvSohuVideoInfo {
			return this.infoWr;
		}
		
		override public function get x() : Number {
			if(predictMode === STG_VIDEO_MODE) {
				return svdRect.x;
			}
			return super.x;
		}
		
		override public function get y() : Number {
			if(predictMode === STG_VIDEO_MODE) {
				return svdRect.y;
			}
			return super.y;
		}
		
		override public function get width() : Number {
			if(predictMode === STG_VIDEO_MODE) {
				return svdRect.width;
			}
			return super.width;
		}
		
		override public function get height() : Number {
			if(predictMode === STG_VIDEO_MODE) {
				return svdRect.height;
			}
			return super.height;
		}
		
		public function get svd_a() : StageVideo {
			if(!this.svdAvaliable) {
				throw new Error(svd_msg);
			} else {
				return S_svd_a;
			}
		}
		
		public function get svd_b() : StageVideo {
			if(!this.svdAvaliable) {
				throw new Error(svd_msg);
			} else {
				return S_svd_b;
			}
		}
		
		public function get curSvd() : StageVideo {
			if(!this.svdAvaliable) {
				throw new Error(svd_msg);
			} else {
				return S_curSvd;
			}
		}
		
		public function get nexSvd() : StageVideo {
			if(!this.svdAvaliable) {
				throw new Error(svd_msg);
			} else {
				return S_nexSvd;
			}
		}
		
		public function set svd_a(param1:StageVideo) : void {
			if(!this.svdAvaliable) {
				throw new Error(svd_msg);
			} else {
				S_svd_a = param1;
				return;
			}
		}
		
		public function set svd_b(param1:StageVideo) : void {
			if(!this.svdAvaliable) {
				throw new Error(svd_msg);
			} else {
				S_svd_b = param1;
				return;
			}
		}
		
		public function set curSvd(param1:StageVideo) : void {
			if(!this.svdAvaliable) {
				throw new Error(svd_msg);
			} else {
				S_curSvd = param1;
				return;
			}
		}
		
		public function set nexSvd(param1:StageVideo) : void {
			if(!this.svdAvaliable) {
				throw new Error(svd_msg);
			} else {
				S_nexSvd = param1;
				return;
			}
		}
		
		override public function get videoWidth() : int {
			if(predictMode === STG_VIDEO_MODE) {
				return this.curSvd.videoWidth;
			}
			return super.videoWidth;
		}
		
		override public function get videoHeight() : int {
			if(predictMode === STG_VIDEO_MODE) {
				return this.curSvd.videoHeight;
			}
			return super.videoHeight;
		}
	}
}
import com.sohu.tv.mediaplayer.video.TvSohuVideoInfo;
import flash.net.NetStream;

final class InfoWriter extends TvSohuVideoInfo {
	
	function InfoWriter() {
		super();
	}
	
	public function updateTarget(param1:NetStream) : void {
		_updateTarget(param1);
	}
	
	public function setRenderStat(param1:String) : void {
		_setRenderStat(param1);
	}
	
	public function setSvdLen(param1:int) : void {
		_setSvdLen(param1);
	}
	
	public function setCurColor(param1:String) : void {
		_setCurColor(param1);
	}
	
	public function setColorSpace(param1:Vector.<String>) : void {
		_setColorSpace(param1);
	}
}
