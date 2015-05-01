package ebing.core.vc31 {
	import flash.display.Sprite;
	import flash.net.NetConnection;
	import ebing.net.NetStreamUtil;
	import flash.net.SharedObject;
	import flash.utils.Timer;
	import flash.media.SoundTransform;
	import ebing.utils.*;
	import flash.events.*;
	import ebing.Utils;
	import flash.media.Video;
	import ebing.events.MediaEvent;
	import flash.net.SharedObjectFlushStatus;
	import flash.display.StageDisplayState;
	
	public class VideoCore extends Sprite {
		
		public function VideoCore(param1:Object) {
			super();
			if(param1.doInit) {
				this.init(param1);
			}
		}
		
		public static const AUTHOR:String = "闪族E兵-QQ:16521603";
		
		protected var _width_num:Number;
		
		protected var _height_num:Number;
		
		protected var _metaWidth_num:Number = 0;
		
		protected var _metaHeight_num:Number = 0;
		
		protected var _buffer_num:Number;
		
		protected var _volume_num:Number;
		
		protected var _bg_spr:Sprite;
		
		protected var _video_arr:Array;
		
		protected var _my_nc:NetConnection;
		
		protected var _now_ns:NetStreamUtil;
		
		protected var _vTotTime_num:Number;
		
		protected var _stopFlag_boo:Boolean = false;
		
		protected var _currentIndex_uint:uint = 0;
		
		protected var _downloadIndex_uint:uint = 0;
		
		protected var _fileSize_num:Number = 0;
		
		protected var _nowLoadedSize_num:Number = 0;
		
		protected var _nowLoadedSize2_num:Number = 0;
		
		protected var _playedTime_num:Number = 0;
		
		protected var _nowTime_num:Number = 0;
		
		protected var _so:SharedObject;
		
		protected var _client_obj:Object;
		
		protected var _clientTem_obj:Object;
		
		protected var _played_boo:Boolean = false;
		
		protected var _finish_boo:Boolean = false;
		
		protected var _screenMode_str:String;
		
		protected var _tow:Boolean = true;
		
		protected var _timer:Timer;
		
		protected var _isGained:Boolean = false;
		
		protected var _startTime:Number = -1;
		
		protected var _optimize:uint = 6;
		
		protected var _isStart:Boolean = false;
		
		protected var _videoRate:Number;
		
		protected var _audioRate:Number;
		
		protected var _fileType:String;
		
		protected var _video_c:Sprite;
		
		protected var _soundTransform:SoundTransform;
		
		protected var _timeeee:Number = -1;
		
		protected var _lastoutBuffer:Boolean = false;
		
		protected var _isBufferFlush:Boolean = false;
		
		protected var _preloadTime:uint = 30;
		
		protected var _sysStatus_str:String = "5";
		
		public function init(param1:Object) : void {
			this._buffer_num = param1.buffer;
			this._width_num = param1.width;
			this._height_num = param1.height;
			this.sysInit("start");
			this.newFunc();
		}
		
		protected function sysInit(param1:String = null) : void {
			if(param1 == "start") {
				this._my_nc = new NetConnection();
				this._my_nc.connect(null);
				this._client_obj = new Object();
				this._clientTem_obj = new Object();
				this._client_obj.onMetaData = this.onMetaData;
				this._clientTem_obj.onMetaData = this.onMetaDataTem;
				this._bg_spr = new Sprite();
				this._video_c = new Sprite();
				Utils.drawRect(this._bg_spr,0,0,this._width_num,this._height_num,0,1);
				addChild(this._bg_spr);
				this._screenMode_str = "normal";
				this.resize(this._width_num,this._height_num);
			}
			this._sysStatus_str = "5";
			this._played_boo = false;
			this._audioRate = this._videoRate = -1;
			this._isStart = false;
			this._downloadIndex_uint = this._currentIndex_uint = 0;
			this._nowLoadedSize2_num = this._nowLoadedSize_num = this._playedTime_num = 0;
			this._startTime = -1;
		}
		
		public function initMedia(param1:Object) : void {
			var _loc9_:uint = 0;
			var _loc2_:String = param1.flv;
			var _loc3_:String = param1.time;
			var _loc4_:String = param1.size;
			this._isGained = false;
			this._vTotTime_num = 0;
			this._fileSize_num = 0;
			if(this._video_arr != null) {
				_loc9_ = 0;
				while(_loc9_ < this._video_arr.length) {
					this._video_arr[_loc9_].ns.removeEventListener(NetStatusEvent.NET_STATUS,this.onStatus);
					this._video_arr[_loc9_].ns.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,this.asyncErrorHandler);
					this._video_arr[_loc9_].ns.removeEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
					this._video_c.removeChild(this._video_arr[_loc9_].video);
					_loc9_++;
				}
				this._video_arr.splice(0);
			}
			var _loc5_:Array = _loc2_.split(",");
			var _loc6_:Array = _loc3_.split(",");
			var _loc7_:Array = _loc4_.split(",");
			this._video_arr = new Array();
			var _loc8_:uint = 0;
			while(_loc8_ < _loc5_.length) {
				this._video_arr[_loc8_] = {
					"flv":_loc5_[_loc8_],
					"video":new Video(),
					"start":(_loc8_ == 0?0:this._vTotTime_num + 1),
					"end":(_loc8_ == 0?_loc6_[_loc8_]:this._vTotTime_num + Number(_loc6_[_loc8_])),
					"download":"no",
					"ns":new NetStreamUtil(this._my_nc),
					"time":Number(_loc6_[_loc8_]),
					"size":Number(_loc7_[_loc8_]),
					"iserr":false,
					"datastart":0,
					"dataend":0,
					"duration":Number(_loc6_[_loc8_]),
					"gotMetaData":false
				};
				this._vTotTime_num = this._vTotTime_num + Number(_loc6_[_loc8_]);
				this._fileSize_num = this._fileSize_num + Number(_loc7_[_loc8_]);
				this._video_arr[_loc8_].video.smoothing = true;
				this._video_arr[_loc8_].video.attachNetStream(this._video_arr[_loc8_].ns);
				this._video_arr[_loc8_].ns.bufferTime = this._buffer_num;
				this._video_arr[_loc8_].video.visible = false;
				this._video_arr[_loc8_].ns.client = this._clientTem_obj;
				this._video_arr[_loc8_].ns.clipNo = _loc8_;
				this._video_c.addChild(this._video_arr[_loc8_].video);
				_loc8_++;
			}
			addChild(this._video_c);
			this.resize(this._width_num,this._height_num);
			this._video_arr[0].ns.addEventListener(NetStatusEvent.NET_STATUS,this.onStatus);
			this._video_arr[0].ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.asyncErrorHandler);
			this._video_arr[0].ns.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
			this._video_arr[0].ns.client = this._client_obj;
			this._now_ns = this._video_arr[0].ns;
			this._video_arr[0].video.visible = true;
			this.initVolume();
			this.sysInit();
		}
		
		protected function getClipInfo(param1:uint) : String {
			return "clip:" + param1 + " start:" + this._video_arr[param1].start + " end:" + this._video_arr[param1].end + " time:" + this._video_arr[param1].time + " size:" + this._video_arr[param1].size + " duration:" + this._video_arr[param1].duration;
		}
		
		public function resize(param1:Number, param2:Number) : void {
			this._width_num = this._bg_spr.width = param1;
			this._height_num = this._bg_spr.height = param2;
			if(this._video_arr != null) {
				if(this._metaWidth_num != 0) {
					this._video_c.width = this._metaWidth_num;
					this._video_c.height = this._metaHeight_num;
				} else {
					this._video_c.width = this._width_num;
					this._video_c.height = this._height_num;
				}
				Utils.prorata(this._video_c,this._bg_spr.width,this._bg_spr.height);
				Utils.setCenter(this._video_c,this._bg_spr);
			}
		}
		
		protected function onMetaDataTem(param1:Object) : void {
			Utils.debug("onMetaDataTem");
		}
		
		protected function onMetaData(param1:Object) : void {
			var _loc2_:* = NaN;
			if(!this._isGained) {
				this._isGained = true;
				this._metaWidth_num = param1.width;
				this._metaHeight_num = param1.height;
				if(param1.keyframes != null) {
					this._fileType = "flv";
				} else if(param1.seekpoints != null) {
					this._fileType = "mp4";
				} else {
					this._fileType = "unknown";
				}
				
				this.resize(this._width_num,this._height_num);
			}
			if((this._tow) && !this._video_arr[this._downloadIndex_uint].ns.gotMetaData) {
				LogManager.msg("第" + this._downloadIndex_uint + "段MetaData获取！obj.duration:" + param1.duration + " size:" + this._video_arr[this._downloadIndex_uint].ns.bytesTotal);
				this._video_arr[this._downloadIndex_uint].ns.gotMetaData = true;
				if(this._fileType == "mp4") {
					this._video_arr[this._downloadIndex_uint].duration = param1.duration;
					this._video_arr[this._downloadIndex_uint].datastart = this._video_arr[this._downloadIndex_uint].time - param1.duration;
					this._playedTime_num = this._playedTime_num + this._video_arr[this._downloadIndex_uint].datastart;
					this._nowLoadedSize_num = this._nowLoadedSize_num + (this._video_arr[this._downloadIndex_uint].size - this._video_arr[this._downloadIndex_uint].ns.bytesTotal);
				} else {
					_loc2_ = this._video_arr[this._downloadIndex_uint].ns.time;
					this._video_arr[this._downloadIndex_uint].duration = this._video_arr[this._downloadIndex_uint].time - _loc2_;
					this._video_arr[this._downloadIndex_uint].datastart = _loc2_;
					this._playedTime_num = this._playedTime_num + this._video_arr[this._downloadIndex_uint].datastart;
					this._nowLoadedSize_num = this._nowLoadedSize_num + (this._video_arr[this._downloadIndex_uint].size - this._video_arr[this._downloadIndex_uint].ns.bytesTotal);
					Utils.debug("------------++++++++++++++videoType:" + this._fileType + " nstime:" + this._video_arr[this._downloadIndex_uint].ns.time + " _nowLoadedSize_num:" + this._nowLoadedSize_num);
				}
			}
			this.dispatch(MediaEvent.DRAG_END);
		}
		
		public function initVolume() : void {
			var _loc1_:SharedObject = SharedObject.getLocal("so","/");
			if(_loc1_.data.volume < 0 || String(_loc1_.data.volume) == "NaN" || _loc1_.data.volume == undefined) {
				_loc1_.data.volume = 0.8;
				_loc1_.flush();
			}
			this.volume = _loc1_.data.volume;
			this.saveVolume();
		}
		
		public function get volume() : Number {
			return this._volume_num;
		}
		
		public function get curIndex() : uint {
			return this._currentIndex_uint;
		}
		
		public function get videoArr() : Array {
			return this._video_arr;
		}
		
		public function set volume(param1:Number) : void {
			this._soundTransform.volume = param1;
			LogManager.msg(param1);
			var _loc2_:uint = 0;
			while(_loc2_ < this._video_arr.length) {
				this._video_arr[_loc2_].ns.soundTransform = this._soundTransform;
				_loc2_++;
			}
			this._volume_num = param1;
		}
		
		public function get sTransform() : SoundTransform {
			Utils.debug("get sTransform:" + this._soundTransform);
			return this._soundTransform;
		}
		
		public function set sTransform(param1:SoundTransform) : void {
			var _loc2_:uint = 0;
			Utils.debug("set sTransform:" + this._soundTransform);
			this._soundTransform = param1;
			if(this._video_arr != null) {
				_loc2_ = 0;
				while(_loc2_ < this._video_arr.length) {
					this._video_arr[_loc2_].ns.soundTransform = this._soundTransform;
					_loc2_++;
				}
			}
		}
		
		public function saveVolume() : void {
			var _loc1_:String = null;
			this._so = SharedObject.getLocal("so","/");
			this._so.data.volume = this._volume_num;
			try {
				_loc1_ = this._so.flush();
				if(_loc1_ == SharedObjectFlushStatus.PENDING) {
					this._so.addEventListener(NetStatusEvent.NET_STATUS,this.onStatusShare);
				} else if(_loc1_ == SharedObjectFlushStatus.FLUSHED) {
				}
				
			}
			catch(e:Error) {
			}
		}
		
		protected function onStatusShare(param1:NetStatusEvent) : void {
			if(param1.info.code != "SharedObject.Flush.Success") {
				if(param1.info.code == "SharedObject.Flush.Failed") {
				}
			}
			this._so.removeEventListener(NetStatusEvent.NET_STATUS,this.onStatusShare);
		}
		
		protected function newFunc() : void {
			this._timer = new Timer(100,0);
			this._timer.addEventListener(TimerEvent.TIMER,this.timerHandler);
			this._soundTransform = new SoundTransform();
		}
		
		protected function getNSTime(param1:NetStreamUtil) : Number {
			return this._fileType == "mp4"?param1.time:param1.time - this._video_arr[this._currentIndex_uint].datastart;
		}
		
		protected function timerHandler(param1:TimerEvent) : void {
			this.aboutTime();
			this.aboutDownload();
			if(Math.ceil(this.getNSTime(this._now_ns) * 10) >= Math.floor(this._video_arr[this._currentIndex_uint].duration * 10) && !(this._video_arr[this._currentIndex_uint].duration == 0)) {
				Utils.debug("timerHandler:" + this._stopFlag_boo + " _now_ns.time:" + this._now_ns.time + " duration:" + this._video_arr[this._currentIndex_uint].duration);
				if(this._stopFlag_boo) {
					this.judgeStop();
				} else {
					this._stopFlag_boo = true;
				}
			}
			param1.updateAfterEvent();
		}
		
		protected function download(param1:uint, param2:* = null) : void {
			this._video_arr[this._currentIndex_uint].ns.client = this._clientTem_obj;
			this._video_arr[param1].ns.client = this._client_obj;
			var _loc3_:String = param2 == null?this._video_arr[param1].flv:this._video_arr[param1].flv + "?start=" + param2;
			LogManager.msg("预加载视频执行了(" + param1 + ")url:" + _loc3_);
			this._downloadIndex_uint = param1;
			if(param2 == null || param2 == 0) {
				this._video_arr[param1].download = "loading";
			} else {
				this._video_arr[param1].download = "part_loading";
			}
			this._video_arr[param1].ns.play(_loc3_);
			this._video_arr[param1].ns.pause();
		}
		
		protected function aboutTime() : void {
			var _loc1_:* = NaN;
			var _loc2_:* = NaN;
			var _loc3_:* = NaN;
			if(!(this._sysStatus_str == "4") && this._currentIndex_uint < this._video_arr.length) {
				_loc1_ = !this._tow?Math.floor(this._video_arr[this._currentIndex_uint].time - this.getNSTime(this._now_ns)):Math.floor(this._video_arr[this._currentIndex_uint].time - (this._video_arr[this._currentIndex_uint].datastart + this.getNSTime(this._now_ns)));
				if(_loc1_ <= this._preloadTime && (this._video_arr[this._currentIndex_uint].download == "loaded" || this._video_arr[this._currentIndex_uint].download == "part_loaded") && this._currentIndex_uint < this._video_arr.length - 1) {
					if(this._video_arr[this._currentIndex_uint + 1].download == "no") {
						this.download(this._currentIndex_uint + 1);
					}
				}
				_loc2_ = this.getNSTime(this._now_ns);
				this._nowTime_num = _loc2_ + this._playedTime_num;
				if(this._timeeee != -1) {
					if(this._video_arr[this._currentIndex_uint].ns.time != 0) {
						Utils.debug("second seek " + this._video_arr[this._currentIndex_uint].ns.time);
						this._now_ns.seek(this._timeeee);
						this._timeeee = -1;
					}
				} else if(_loc2_ != 0) {
					_loc3_ = this._nowTime_num < 0?0:this._nowTime_num;
					this.dispatch(MediaEvent.PLAY_PROGRESS,{
						"nowTime":_loc3_,
						"totTime":this._vTotTime_num,
						"isSeek":false
					});
				}
				
			}
		}
		
		protected function aboutDownload() : void {
			var by_num:Number = NaN;
			var tot_num:Number = NaN;
			var loaded:Number = NaN;
			var download:String = null;
			var index:uint = 0;
			var i:uint = 0;
			if(this._video_arr[this._downloadIndex_uint].download == "loading" || this._video_arr[this._downloadIndex_uint].download == "part_loading") {
				by_num = this._video_arr[this._downloadIndex_uint].ns.bytesLoaded;
				tot_num = this._video_arr[this._downloadIndex_uint].ns.bytesTotal;
				loaded = this._nowLoadedSize2_num = this._nowLoadedSize_num + by_num;
				if(this._tow) {
					this._video_arr[this._downloadIndex_uint].dataend = this._video_arr[this._downloadIndex_uint].datastart + this._video_arr[this._downloadIndex_uint].duration * by_num / tot_num;
				}
				if(by_num >= tot_num && tot_num > 0) {
					download = "loaded";
					if(this._video_arr[this._downloadIndex_uint].ns.isDrag) {
						download = "part_loaded";
					}
					this._video_arr[this._downloadIndex_uint].download = download;
					this._nowLoadedSize_num = this._nowLoadedSize_num + tot_num;
					try {
						Utils.debug("_downloadIndex_uint:" + this._downloadIndex_uint + "_video_arr[_downloadIndex_uint].download:" + this._video_arr[this._downloadIndex_uint].download);
						index = this._downloadIndex_uint + 1;
						i = index;
						while(i < this._video_arr.length) {
							if(this._video_arr[i].download == "loaded") {
								this._nowLoadedSize_num = this._nowLoadedSize_num + this._video_arr[i].size;
								i++;
								continue;
							}
							break;
						}
						LogManager.msg("当前视频加载完毕了(" + this._downloadIndex_uint + ") by_num:" + by_num + " tot_num:" + tot_num);
						by_num = tot_num = 0;
						this.checkLastoutBuffer();
					}
					catch(evt:*) {
						Utils.debug(evt);
					}
				}
				this.dispatch(MediaEvent.LOAD_PROGRESS,{
					"nowSize":this._nowLoadedSize_num + by_num,
					"totSize":this._fileSize_num
				});
			}
		}
		
		private function checkLastoutBuffer() : void {
			LogManager.msg("检测预加载状态！clip:" + this._downloadIndex_uint + " downloadState:" + this._video_arr[this._downloadIndex_uint].download + " lb:" + this._lastoutBuffer + " <:" + (this._downloadIndex_uint < this._video_arr.length - 1));
			if((this._lastoutBuffer) && (this._video_arr[this._downloadIndex_uint].download == "loaded" || this._video_arr[this._downloadIndex_uint].download == "part_loaded") && this._downloadIndex_uint < this._video_arr.length - 1) {
				this.download(this._downloadIndex_uint + 1);
			}
		}
		
		protected function asyncErrorHandler(param1:AsyncErrorEvent) : void {
			LogManager.msg("asyncErrorHandler:" + param1);
		}
		
		protected function ioErrorHandler(param1:IOErrorEvent) : void {
			LogManager.msg("ioErrorHandler:" + param1);
		}
		
		protected function onStatus(param1:NetStatusEvent) : void {
			var _loc3_:uint = 0;
			var _loc4_:uint = 0;
			Utils.debug("onStatus:" + param1);
			var _loc2_:NetStreamUtil = this._video_arr[this._currentIndex_uint].ns;
			switch(param1.info.code) {
				case "NetStream.Play.Start":
					LogManager.msg("evt.info.code:" + param1.info.code + " _isStart:" + this._isStart + " _currentIndex_uint:" + this._currentIndex_uint);
					this._startTime = 0;
					_loc2_.dragTime = 0;
					if(!this._isStart) {
						this._isStart = true;
						this._timer.start();
						LogManager.msg("加载中...");
						this.dispatch(MediaEvent.START);
					}
					break;
				case "NetStream.Buffer.Empty":
					LogManager.msg("缓冲中(" + this._currentIndex_uint + ")...nstimeCeil:" + Math.ceil(this.getNSTime(this._now_ns) * 10) + " durationFloor:" + Math.floor(this._video_arr[this._currentIndex_uint].duration * 10) + " getNSTime:" + this.getNSTime(this._now_ns) + " stopflag:" + this._stopFlag_boo + " " + this.getClipInfo(this._currentIndex_uint));
					if(!this._isBufferFlush && _loc2_.bufferLength < _loc2_.bufferTime) {
						this.dispatch(MediaEvent.BUFFER_EMPTY);
					}
					break;
				case "NetStream.Buffer.Full":
					this._isBufferFlush = false;
					_loc3_ = 0;
					while(_loc3_ < this._video_arr.length) {
						this._video_arr[_loc3_].video.visible = false;
						_loc3_++;
					}
					this._video_arr[this._currentIndex_uint].video.visible = true;
					LogManager.msg("播放中(" + this._currentIndex_uint + ")...");
					this.dispatch(MediaEvent.FULL);
					if(!this._played_boo) {
						this._played_boo = true;
						this.dispatch(MediaEvent.PLAYED);
					}
					break;
				case "NetStream.Buffer.Flush":
					this._isBufferFlush = true;
					break;
				case "NetStream.Play.Stop":
					LogManager.msg("第" + this._currentIndex_uint + "段Stop事件触发了！nstimeCeil:" + Math.ceil(this.getNSTime(this._now_ns) * 10) + " durationFloor:" + Math.floor(this._video_arr[this._currentIndex_uint].duration * 10) + " getNSTime:" + this.getNSTime(this._now_ns) + " stopflag:" + this._stopFlag_boo + " " + this.getClipInfo(this._currentIndex_uint));
					if(this._stopFlag_boo) {
						this.judgeStop();
					} else {
						this._stopFlag_boo = true;
					}
					break;
				case "NetStream.Play.StreamNotFound":
					break;
				case "NetStream.Seek.Notify":
					_loc4_ = 0;
					while(_loc4_ < this._video_arr.length) {
						this._video_arr[_loc4_].video.visible = false;
						_loc4_++;
					}
					this._video_arr[this._currentIndex_uint].video.visible = true;
					LogManager.msg("NetStream.Seek.Notify");
					break;
				case "NetStream.Seek.InvalidTime":
					LogManager.msg("Seek.InvalidTime");
					break;
				case "NetStream.Seek.Failed":
					LogManager.msg("Seek.Failed");
					break;
			}
		}
		
		protected function changeNS(param1:uint, param2:uint) : void {
			this._video_arr[param1].ns.removeEventListener(NetStatusEvent.NET_STATUS,this.onStatus);
			this._video_arr[param1].ns.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,this.asyncErrorHandler);
			this._video_arr[param1].ns.removeEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
			this._video_arr[param1].ns.client = this._clientTem_obj;
			this._video_arr[param2].ns.addEventListener(NetStatusEvent.NET_STATUS,this.onStatus);
			this._video_arr[param2].ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.asyncErrorHandler);
			this._video_arr[param2].ns.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
			this._video_arr[param2].ns.client = this._client_obj;
			this._now_ns = this._video_arr[param2].ns;
			this._currentIndex_uint = param2;
		}
		
		protected function judgeStop() : void {
			this._now_ns.pause();
			if(this._tow) {
				this._playedTime_num = this._playedTime_num + this._video_arr[this._currentIndex_uint].duration;
			} else {
				this._playedTime_num = this._playedTime_num + this._video_arr[this._currentIndex_uint].time;
			}
			if(this._currentIndex_uint < this._video_arr.length - 1) {
				this._video_arr[this._currentIndex_uint].video.visible = false;
				this.changeNS(this._currentIndex_uint,this._currentIndex_uint + 1);
				this._now_ns.seek(0);
				this._video_arr[this._currentIndex_uint].video.visible = true;
				if(!this._video_arr[this._currentIndex_uint].iserr) {
					this._now_ns.resume();
				}
			} else {
				Utils.debug("结束");
				this._finish_boo = true;
				this.stop();
			}
			this._stopFlag_boo = false;
		}
		
		public function play(param1:* = null) : void {
			var _loc2_:* = NaN;
			if(this._sysStatus_str == "5") {
				this._now_ns.play(this._video_arr[0].flv);
				this._video_arr[this._downloadIndex_uint].download = "loading";
				LogManager.msg("开始播放:" + this._video_arr[0].flv);
				this.dispatch(MediaEvent.CONNECTING);
			}
			if(this._sysStatus_str == "4") {
				_loc2_ = this._startTime > 0?this._startTime:null;
				if(this._video_arr[this._currentIndex_uint].download == "no") {
					this.download(this._currentIndex_uint,_loc2_);
					this.dispatch(MediaEvent.CONNECTING);
				}
				this._now_ns.resume();
			}
			this._sysStatus_str = "3";
			this.dispatch(MediaEvent.PLAY);
		}
		
		public function stop(param1:* = null) : void {
			var _loc2_:uint = 0;
			if(this._sysStatus_str != "5") {
				_loc2_ = 0;
				while(_loc2_ < this._video_arr.length) {
					this._video_arr[_loc2_].ns.seek(0);
					this._video_arr[_loc2_].ns.close();
					Utils.debug("close() in stop");
					_loc2_++;
				}
				this._sysStatus_str = "5";
				this._timer.stop();
				this.changeNS(this._currentIndex_uint,0);
				LogManager.msg("停止了_now_ns:" + this._now_ns);
				Utils.debug("display stop");
				this._now_ns = this._video_arr[0].ns;
				this.sysInit();
				if(param1 != "noevent") {
					if(this._finish_boo) {
						this.dispatch(MediaEvent.STOP,{"finish":true});
						this._finish_boo = false;
					} else {
						this.dispatch(MediaEvent.STOP,{"finish":false});
					}
				}
			}
		}
		
		public function destroy() : void {
			this._now_ns.close();
			this.stop();
			this._my_nc.close();
			this._my_nc = null;
			Utils.debug("close() in destroy");
		}
		
		public function sleep(param1:* = null) : void {
			this.pause("0");
		}
		
		public function pause(param1:* = null) : void {
			this._now_ns.pause();
			this._sysStatus_str = "4";
			if(param1 != "0") {
				this.dispatch(MediaEvent.PAUSE,{"isHard":(param1 == null?false:true)});
			}
		}
		
		protected function initSectState(param1:uint) : void {
			var _loc2_:Object = this._video_arr[param1];
			_loc2_.ns.close();
			Utils.debug("close() in initSectState");
			_loc2_.download = "no";
			_loc2_.datastart = 0;
			_loc2_.dataend = 0;
			Utils.debug("---------第" + param1 + "段清掉了!");
		}
		
		private function initProHaveData(param1:uint) : void {
			var _loc2_:* = "1";
			this._playedTime_num = 0;
			this._nowLoadedSize_num = 0;
			var _loc3_:uint = 0;
			while(_loc3_ < this._video_arr.length) {
				if(param1 != _loc3_) {
					this._video_arr[_loc3_].video.visible = false;
				}
				if(_loc3_ < param1) {
					this._playedTime_num = this._playedTime_num + this._video_arr[_loc3_].time;
					this._nowLoadedSize_num = this._nowLoadedSize_num + this._video_arr[_loc3_].size;
				} else if(_loc3_ == param1) {
					if(this._video_arr[_loc3_].download == "part_loaded" || this._video_arr[_loc3_].download == "loaded") {
						this._nowLoadedSize_num = this._nowLoadedSize_num + this._video_arr[_loc3_].size;
					} else if(this._video_arr[_loc3_].download == "part_loading" || this._video_arr[_loc3_].download == "loading") {
						this._nowLoadedSize_num = this._nowLoadedSize_num + (this._video_arr[_loc3_].size - this._video_arr[_loc3_].ns.bytesTotal);
					}
					
				} else if(_loc3_ > param1) {
					if(this._video_arr[_loc3_].download == "loaded") {
						if(_loc2_ == "1") {
							this._nowLoadedSize_num = this._nowLoadedSize_num + this._video_arr[_loc3_].size;
						}
					} else {
						_loc2_ = "0";
						if(!(this._video_arr[_loc3_].download == "loading") || !(this._video_arr[_loc3_ - 1].download == "loaded")) {
							this.initSectState(_loc3_);
						}
					}
				}
				
				
				_loc3_++;
			}
		}
		
		private function K1026043DB3C4729D2C49DD8DF29CB1BC5D1968373567K(param1:uint) : void {
			this._playedTime_num = 0;
			this._nowLoadedSize_num = 0;
			var _loc2_:uint = 0;
			while(_loc2_ < this._video_arr.length) {
				if(this._video_arr[_loc2_].download != "loaded") {
					this.initSectState(_loc2_);
				}
				if(_loc2_ < param1) {
					this._playedTime_num = this._playedTime_num + this._video_arr[_loc2_].time;
					this._nowLoadedSize_num = this._nowLoadedSize_num + this._video_arr[_loc2_].size;
				}
				_loc2_++;
			}
		}
		
		protected function tow(param1:Number, param2:uint) : void {
			this.dispatch(MediaEvent.DRAG_START);
			this.K1026043DB3C4729D2C49DD8DF29CB1BC5D1968373567K(param2);
			this.changeNS(this._currentIndex_uint,param2);
			this._currentIndex_uint = this._downloadIndex_uint = param2;
			this._startTime = Math.abs(Math.round(param1));
			LogManager.msg("-----------drag---------------");
			this._startTime = this._startTime <= this._optimize?0:this._startTime;
		}
		
		public function seek(param1:Number, param2:* = null) : void {
			var _loc5_:uint = 0;
			var _loc6_:* = NaN;
			var _loc7_:* = false;
			var _loc8_:String = null;
			var _loc9_:* = NaN;
			var _loc10_:* = NaN;
			var _loc3_:Number = this._playedTime_num;
			this._playedTime_num = 0;
			var _loc4_:* = false;
			if(param1 >= 0 && param1 <= this._vTotTime_num) {
				_loc5_ = 0;
				while(_loc5_ < this._video_arr.length) {
					if(param1 >= this._video_arr[_loc5_].start && param1 <= this._video_arr[_loc5_].end) {
						_loc6_ = param1 - this._video_arr[_loc5_].start;
						this._now_ns.pause();
						this._sysStatus_str = "4";
						_loc4_ = true;
						if(this._tow) {
							if((_loc6_ < this._video_arr[_loc5_].datastart || _loc6_ > this._video_arr[_loc5_].dataend) && !(param2 == 0)) {
								this.tow(_loc6_,_loc5_);
							} else {
								if(param2 != 0) {
									if(!(this._video_arr[_loc5_].download == "part_loading") && !(this._video_arr[_loc5_].download == "loading")) {
										this.initProHaveData(_loc5_);
										this.dispatch(MediaEvent.LOAD_PROGRESS,{
											"nowSize":this._nowLoadedSize_num,
											"totSize":this._fileSize_num
										});
									}
								}
								Utils.debug("_playedTime_num1:" + this._playedTime_num);
								this._playedTime_num = this._playedTime_num + this._video_arr[_loc5_].datastart;
								Utils.debug("_playedTime_num2:" + this._playedTime_num + " seeksec:" + _loc6_ + " _fileType:" + this._fileType);
								_loc7_ = this._currentIndex_uint == _loc5_;
								this.changeNS(this._currentIndex_uint,_loc5_);
								_loc8_ = this._fileType;
								if(_loc8_ == "mp4") {
									_loc9_ = _loc6_ - this._video_arr[_loc5_].datastart;
									if(_loc9_ >= 1 && _loc9_ <= this._video_arr[_loc5_].dataend - 1) {
										Utils.debug("+++++++++-----+++++++++++++++_now_ns.time:" + this._now_ns.time + " getNSTime:" + this.getNSTime(this._now_ns));
										if(param2 == 0 || (_loc7_)) {
											this._now_ns.seek(_loc9_);
										} else {
											this._now_ns.seek(0);
											this._timeeee = _loc9_;
										}
										Utils.debug("最终mp4-seek:" + _loc9_ + " _video_arr[i].datastart:" + this._video_arr[_loc5_].datastart + " _video_arr[i].dataend:" + this._video_arr[_loc5_].dataend);
									}
								} else {
									_loc9_ = _loc6_ - 1;
									if(_loc9_ >= this._video_arr[_loc5_].datastart + 1 && _loc9_ <= this._video_arr[_loc5_].dataend - 1) {
										if(param2 == 0 || (_loc7_)) {
											this._now_ns.seek(_loc9_);
										} else {
											this._now_ns.seek(0);
											this._timeeee = _loc9_;
										}
										Utils.debug("最终seek:" + _loc9_ + " _video_arr[i].datastart:" + this._video_arr[_loc5_].datastart + " _video_arr[i].dataend:" + this._video_arr[_loc5_].dataend);
									}
								}
							}
						} else {
							this.changeNS(this._currentIndex_uint,_loc5_);
							_loc10_ = param1 - this._video_arr[_loc5_].start;
							this._now_ns.seek(_loc10_);
						}
						break;
					}
					this._playedTime_num = this._playedTime_num + this._video_arr[_loc5_].time;
					_loc5_++;
				}
				if(!_loc4_) {
					this._playedTime_num = _loc3_;
				}
			}
		}
		
		public function changeScreenMode(param1:* = null) : void {
			stage.displayState = stage.displayState == StageDisplayState.FULL_SCREEN?StageDisplayState.NORMAL:StageDisplayState.FULL_SCREEN;
		}
		
		public function playOrPause(param1:* = null) : void {
			if(this._sysStatus_str == "4") {
				this.play();
			} else if(this._sysStatus_str == "3") {
				this.pause(param1);
			}
			
		}
		
		public function get fileType() : String {
			return this._fileType;
		}
		
		public function get videoContainer() : Sprite {
			return this._video_c;
		}
		
		public function get metaWidth() : Number {
			return this._metaWidth_num;
		}
		
		public function get metaHeight() : Number {
			return this._metaHeight_num;
		}
		
		public function get ns() : NetStreamUtil {
			return this._now_ns;
		}
		
		public function get streamState() : String {
			var _loc1_:String = null;
			switch(this._sysStatus_str) {
				case "5":
					_loc1_ = "stop";
					break;
				case "4":
					_loc1_ = "pause";
					break;
				case "3":
					_loc1_ = "play";
					break;
			}
			return _loc1_;
		}
		
		public function get sTime() : Number {
			return Math.round(this._video_arr[this._currentIndex_uint].datastart + this.getNSTime(this._now_ns));
		}
		
		public function get screenMode() : String {
			return this._screenMode_str;
		}
		
		public function get arate() : Number {
			return this._audioRate;
		}
		
		public function get vrate() : Number {
			if(this._videoRate == -1) {
				return Math.round(this._fileSize_num / this._vTotTime_num);
			}
			return this._videoRate;
		}
		
		public function set lastoutBuffer(param1:Boolean) : void {
			this._lastoutBuffer = param1;
			this.checkLastoutBuffer();
		}
		
		public function get lastoutBuffer() : Boolean {
			return this._lastoutBuffer;
		}
		
		public function get filePlayedTime() : Number {
			return this._nowTime_num;
		}
		
		public function get fileTotTime() : Number {
			return this._vTotTime_num;
		}
		
		public function get fileLoadedSize() : Number {
			return this._nowLoadedSize2_num;
		}
		
		public function get fileTotSize() : Number {
			return this._fileSize_num;
		}
		
		public function set screenMode(param1:String) : void {
			this._screenMode_str = param1;
		}
		
		public function dispatch(param1:String, param2:Object = null) : void {
			var _loc3_:MediaEvent = new MediaEvent(param1);
			_loc3_.obj = param2;
			dispatchEvent(_loc3_);
		}
	}
}
