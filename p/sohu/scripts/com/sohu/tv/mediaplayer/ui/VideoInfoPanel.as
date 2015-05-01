package com.sohu.tv.mediaplayer.ui {
	import flash.utils.Timer;
	import flash.text.TextField;
	import com.sohu.tv.mediaplayer.video.TvSohuMediaPlayback;
	import com.sohu.tv.mediaplayer.PlayerConfig;
	import ebing.Utils;
	import ebing.controls.*;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	
	public class VideoInfoPanel extends TvSohuPanel {
		
		public function VideoInfoPanel(param1:MovieClip, param2:TvSohuMediaPlayback) {
			this._speed_txt = param1.speed_txt;
			this._volume_txt = param1.volume_txt;
			this._rate_txt = param1.rate_txt;
			this._averageSpeed_txt = param1.averageSpeed_txt;
			this._bytesTotal_txt = param1.bytesTotal_txt;
			this._metaSize_txt = param1.metaSize_txt;
			this._currentSize_txt = param1.currentSize_txt;
			this._scale_txt = param1.scale_txt;
			this._light_txt = param1.light_txt;
			this._contrast_txt = param1.contrast_txt;
			this._saturation_txt = param1.saturation_txt;
			this._fps_txt = param1.fps_txt;
			this._renderStat_txt = param1.renderStat_txt;
			this._kbps_txt = param1.kbps_txt;
			this._videoFps_txt = param1.videoFps_txt;
			this._dropFrames_txt = param1.dropFrames_txt;
			this._mode_txt = param1.mode_txt;
			this._svdLen_txt = param1.svdLen_txt;
			this._stvdcolor_txt = param1.stvdcolor_txt;
			this._playback = param2;
			this.newFunc();
			this.drawSkin();
			this.addEvent();
			super(param1);
			if(!(this._playback.core == null) && !(this._playback.core == undefined)) {
				this._beforeSize = this._playback.core.fileLoadedSize;
				this._timer.start();
			}
		}
		
		private var _timer:Timer;
		
		private var _beforeSize:Number = 0;
		
		private var _speed_txt:TextField;
		
		private var _volume_txt:TextField;
		
		private var _rate_txt:TextField;
		
		private var _averageSpeed_txt:TextField;
		
		private var _bytesTotal_txt:TextField;
		
		private var _metaSize_txt:TextField;
		
		private var _currentSize_txt:TextField;
		
		private var _scale_txt:TextField;
		
		private var _light_txt:TextField;
		
		private var _contrast_txt:TextField;
		
		private var _saturation_txt:TextField;
		
		private var _fps_txt:TextField;
		
		private var _loadTime:uint = 0;
		
		private var _totSpeed:Number = 0;
		
		private var _totTime:Number = 0;
		
		private var _averageSpeed:Number = 0;
		
		private var _time_arr:Array;
		
		private var _playback:TvSohuMediaPlayback;
		
		private var _renderStat_txt:TextField;
		
		private var _kbps_txt:TextField;
		
		private var _videoFps_txt:TextField;
		
		private var _dropFrames_txt:TextField;
		
		private var _mode_txt:TextField;
		
		private var _svdLen_txt:TextField;
		
		private var _stvdcolor_txt:TextField;
		
		private function newFunc() : void {
			this._timer = new Timer(1000);
			this._timer.addEventListener(TimerEvent.TIMER,this.timerHandler);
			this._time_arr = new Array();
		}
		
		private function drawSkin() : void {
		}
		
		private function addEvent() : void {
		}
		
		public function get averageSpeedForNum() : Number {
			if(PlayerConfig.isFms) {
				this._averageSpeed = 0;
			}
			return this._averageSpeed;
		}
		
		public function get averageSpeed() : String {
			return this._averageSpeed_txt.text;
		}
		
		public function get speed() : String {
			return this._speed_txt.text;
		}
		
		private function getSpeed(param1:Number) : String {
			var param1:Number = isNaN(param1)?0:param1;
			var _loc2_:Number = param1 / 1024;
			var _loc3_:Number = _loc2_;
			var _loc4_:* = " KB/S";
			if(_loc2_ > 1024) {
				_loc3_ = _loc2_ / 1024;
				_loc4_ = " MB/S";
			}
			return Utils.numberFormat(_loc3_,2) + _loc4_;
		}
		
		private function timerHandler(param1:TimerEvent) : void {
			var by:Number = NaN;
			var loadedSize:Number = NaN;
			var speed:Number = NaN;
			var clipLoadState:String = null;
			var clipIsErr:Boolean = false;
			var tsp:Number = NaN;
			var asp:Number = NaN;
			var i:uint = 0;
			var vrate:Number = NaN;
			var vr:String = null;
			var bt:String = null;
			var scale:String = null;
			var so:SharedObject = null;
			var flushResult:String = null;
			var evt:TimerEvent = param1;
			try {
				if(!(this._playback.core == null) && !(this._playback.core == undefined)) {
					by = this._playback.core.videoArr[this._playback.core.loadingClipIndex].ns.bytesLoaded;
					loadedSize = by < 0?0:by;
					speed = loadedSize - this._beforeSize < 0?0:loadedSize - this._beforeSize;
					if(this._time_arr.length > 10) {
						this._time_arr.shift();
					}
					this._time_arr.push(speed);
					clipLoadState = this._playback.core.videoArr[this._playback.core.loadingClipIndex].download;
					clipIsErr = this._playback.core.videoArr[this._playback.core.loadingClipIndex].iserr;
					tsp = 0;
					asp = 0;
					i = 0;
					while(i < this._time_arr.length) {
						tsp = tsp + this._time_arr[i];
						i++;
					}
					asp = tsp / this._time_arr.length;
					this._speed_txt.text = asp >= 0?this.getSpeed(asp):"-";
					if(clipIsErr) {
						this._speed_txt.text = "本段链接终止";
					} else if(clipLoadState == "loaded" || clipLoadState == "part_loaded") {
						this._speed_txt.text = "本段下载完毕";
					} else if(speed >= 0) {
						this._totSpeed = this._totSpeed + speed;
						this._loadTime = this._loadTime + 1;
					}
					
					
					this._averageSpeed = this._totSpeed / this._loadTime;
					this._volume_txt.text = String(Math.round(this._playback.core.volume * 100)) + "%";
					vrate = this._playback.core.vrate;
					this._averageSpeed_txt.text = this.getSpeed(this._totSpeed / this._loadTime);
					this._totTime++;
					if(this._totTime % 60 == 0 && !PlayerConfig.isLive) {
						so = SharedObject.getLocal("vmsPlayer","/");
						so.data.bw = Math.round(this._totSpeed / this._loadTime / 1024 * 8);
						try {
							flushResult = so.flush();
							if(flushResult == SharedObjectFlushStatus.PENDING) {
								so.addEventListener(NetStatusEvent.NET_STATUS,this.onStatusShare);
							} else if(flushResult == SharedObjectFlushStatus.FLUSHED) {
							}
							
						}
						catch(e:Error) {
						}
					}
					if(this._totTime % 60 == 0 && !PlayerConfig.isLive) {
						if((PlayerConfig.isFms) || (PlayerConfig.isCounterfeitFms)) {
							this._averageSpeed_txt.text = this._speed_txt.text = "无法测速";
						} else if(clipIsErr) {
							this._averageSpeed_txt.text = "链接终止";
						}
						
						bt = Utils.numberFormat(this._playback.core.fileTotSize / 1024 / 1024,2) + " MB";
						this._bytesTotal_txt.text = bt;
						this._currentSize_txt.text = String(Math.round(this._playback.core.videoContainer.width)) + "*" + String(Math.round(this._playback.core.videoContainer.height));
						scale = "";
						switch(this._playback.core.scaleState) {
							case "4_3":
								scale = "4:3";
								break;
							case "16_9":
								scale = "16:9";
								break;
							case "meta":
								scale = "原始比例";
								break;
							case "full":
								scale = "满屏";
								break;
						}
						this._scale_txt.text = scale;
						this._light_txt.text = this._playback.lightRate != 0.5?String(Math.round(((this._playback.lightRate - 1) * 2 + 1) * 100)) + "%":"原始亮度";
						this._contrast_txt.text = this._playback.contrastRate != 0.5?String(Math.round(((this._playback.contrastRate - 1) * 2 + 1) * 100)) + "%":"原始对比度";
						this._saturation_txt.text = this._playback.saturationRate != 0.5?String(Math.round(((this._playback.saturationRate - 1) * 2 + 1) * 100)) + "%":"原始饱和度";
						this._fps_txt.text = Utils.numberFormat(this._playback.core.ns.currentFPS,2) + " Fps";
						this._beforeSize = loadedSize;
						try {
							this._renderStat_txt.text = this._playback.core.videoArr[this._playback.core.curIndex].video.info.getRenderStat();
							this._kbps_txt.text = this._playback.core.videoArr[this._playback.core.curIndex].video.info.getKbps();
							this._videoFps_txt.text = this._playback.core.videoArr[this._playback.core.curIndex].video.info.getVideoFps();
							this._dropFrames_txt.text = this._playback.core.videoArr[this._playback.core.curIndex].video.info.getDropFrames();
							this._svdLen_txt.text = this._playback.core.videoArr[this._playback.core.curIndex].video.info.getSvdLen();
							this._stvdcolor_txt.text = this._playback.core.videoArr[this._playback.core.curIndex].video.info.getCurColor() + "--" + this._playback.core.videoArr[this._playback.core.curIndex].video.info.getColorSpace();
						}
						catch(evt:Error) {
						}
					} else {
						if((PlayerConfig.isFms) || (PlayerConfig.isCounterfeitFms)) {
							this._averageSpeed_txt.text = this._speed_txt.text = "无法测速";
						} else if(clipIsErr) {
							this._averageSpeed_txt.text = "链接终止";
						}
						
						bt = Utils.numberFormat(this._playback.core.fileTotSize / 1024 / 1024,2) + " MB";
						this._bytesTotal_txt.text = bt;
						this._currentSize_txt.text = String(Math.round(this._playback.core.videoContainer.width)) + "*" + String(Math.round(this._playback.core.videoContainer.height));
						scale = "";
						switch(this._playback.core.scaleState) {
							case "4_3":
								scale = "4:3";
								break;
							case "16_9":
								scale = "16:9";
								break;
							case "meta":
								scale = "原始比例";
								break;
							case "full":
								scale = "满屏";
								break;
						}
						this._scale_txt.text = scale;
						this._light_txt.text = this._playback.lightRate != 0.5?String(Math.round(((this._playback.lightRate - 1) * 2 + 1) * 100)) + "%":"原始亮度";
						this._contrast_txt.text = this._playback.contrastRate != 0.5?String(Math.round(((this._playback.contrastRate - 1) * 2 + 1) * 100)) + "%":"原始对比度";
						this._saturation_txt.text = this._playback.saturationRate != 0.5?String(Math.round(((this._playback.saturationRate - 1) * 2 + 1) * 100)) + "%":"原始饱和度";
						this._fps_txt.text = Utils.numberFormat(this._playback.core.ns.currentFPS,2) + " Fps";
						this._beforeSize = loadedSize;
						this._renderStat_txt.text = this._playback.core.videoArr[this._playback.core.curIndex].video.info.getRenderStat();
						this._kbps_txt.text = this._playback.core.videoArr[this._playback.core.curIndex].video.info.getKbps();
						this._videoFps_txt.text = this._playback.core.videoArr[this._playback.core.curIndex].video.info.getVideoFps();
						this._dropFrames_txt.text = this._playback.core.videoArr[this._playback.core.curIndex].video.info.getDropFrames();
						this._svdLen_txt.text = this._playback.core.videoArr[this._playback.core.curIndex].video.info.getSvdLen();
						this._stvdcolor_txt.text = this._playback.core.videoArr[this._playback.core.curIndex].video.info.getCurColor() + "--" + this._playback.core.videoArr[this._playback.core.curIndex].video.info.getColorSpace();
					}
				}
			}
			catch(e:Error) {
			}
		}
		
		private function onStatusShare(param1:NetStatusEvent) : void {
			if(param1.info.code != "SharedObject.Flush.Success") {
				if(param1.info.code == "SharedObject.Flush.Failed") {
				}
			}
			param1.target.removeEventListener(NetStatusEvent.NET_STATUS,this.onStatusShare);
		}
		
		override public function open(param1:* = null) : void {
			super.open();
			if(!(this._playback.core == null) && !(this._playback.core == undefined)) {
				this._beforeSize = this._playback.core.fileLoadedSize;
			}
		}
		
		override public function close(param1:* = null) : void {
			super.close(param1);
		}
		
		public function loadProgress(param1:*) : void {
		}
	}
}
