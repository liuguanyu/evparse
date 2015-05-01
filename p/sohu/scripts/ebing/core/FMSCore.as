package ebing.core {
	import flash.display.Sprite;
	import ebing.net.NetStreamUtil;
	import flash.media.SoundTransform;
	import ebing.utils.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	import ebing.events.MediaEvent;
	import ebing.Utils;
	import flash.media.Video;
	import flash.display.StageDisplayState;
	
	public class FMSCore extends Sprite {
		
		public function FMSCore(param1:Object) {
			super();
			if(param1.doInit) {
				this.hardInit(param1);
			}
		}
		
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
		
		protected var _fileType:String;
		
		protected var _video_c:Sprite;
		
		protected var _soundTransform:SoundTransform;
		
		protected var _timeeee:Number = -1;
		
		protected var _isBufferFlush:Boolean = false;
		
		protected var _hardInitHandler:Function;
		
		protected var _seeking:Boolean;
		
		protected var _ttttt:Number = 0;
		
		protected var _sysInited:Boolean = false;
		
		protected var _rtmpeUrl:String;
		
		protected var _doNCClose:Boolean = false;
		
		protected var _preloadTime:uint = 30;
		
		private var K1026044EB31EC02A5E480B8724F16C2AF4A751373567K:Boolean = false;
		
		protected var _sysStatus_str:String = "5";
		
		public function hardInit(param1:Object) : void {
			this._buffer_num = param1.buffer;
			this._width_num = param1.width;
			this._height_num = param1.height;
			this._rtmpeUrl = param1.rtmpeUrl;
			this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K = param1.isWriteLog;
			this._hardInitHandler = param1.hardInitHandler;
			this.connectNC();
		}
		
		protected function connectNC() : void {
			if(this._my_nc == null) {
				this._my_nc = new NetConnection();
				this._my_nc.client = this;
				this._my_nc.addEventListener(NetStatusEvent.NET_STATUS,this.netStatusHandler);
				this._my_nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
			}
			this._doNCClose = false;
			this._my_nc.connect(this._rtmpeUrl);
		}
		
		public function onBWDone() : void {
		}
		
		protected function netStatusHandler(param1:NetStatusEvent) : void {
			if(this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K) {
				LogManager.msg("FMS服务器连接状态：" + param1.info.code);
			}
			switch(param1.info.code) {
				case "NetConnection.Connect.Success":
					if(!this._sysInited) {
						this.sysInit("start");
					}
					break;
				case "NetConnection.Connect.Closed":
					this.dispatch(MediaEvent.NC_CONNECT_CLOSED);
					break;
				case "NetConnection.Connect.Failed":
					break;
			}
		}
		
		private function securityErrorHandler(param1:SecurityErrorEvent) : void {
			trace("securityErrorHandler: " + param1);
		}
		
		protected function sysInit(param1:String = null) : void {
			if(param1 == "start") {
				this.newFunc();
				this._sysInited = true;
				this._client_obj = new Object();
				this._clientTem_obj = new Object();
				this._client_obj.onMetaData = this.onMetaData;
				this._bg_spr = new Sprite();
				this._video_c = new Sprite();
				Utils.drawRect(this._bg_spr,0,0,this._width_num,this._height_num,0,1);
				addChild(this._bg_spr);
				this._screenMode_str = "normal";
				this.resize(this._width_num,this._height_num);
				this._hardInitHandler({"info":"success"});
			}
			this._sysStatus_str = "5";
			this._played_boo = false;
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
				
				this._fileType = "mp4";
				this.resize(this._width_num,this._height_num);
			}
			if((this._tow) && !this._video_arr[this._downloadIndex_uint].ns.gotMetaData) {
				if(this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K) {
					LogManager.msg("第" + this._downloadIndex_uint + "段MetaData获取！obj.duration:" + param1.duration + " size:" + this._video_arr[this._downloadIndex_uint].ns.bytesTotal);
				}
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
			var _loc2_:String = null;
			var _loc1_:SharedObject = SharedObject.getLocal("so","/");
			if(_loc1_.data.volume < 0 || String(_loc1_.data.volume) == "NaN" || _loc1_.data.volume == undefined) {
				_loc1_.data.volume = 0.8;
				try {
					_loc2_ = _loc1_.flush();
					if(_loc2_ == SharedObjectFlushStatus.PENDING) {
						_loc1_.addEventListener(NetStatusEvent.NET_STATUS,this.onStatusShare);
					} else if(_loc2_ == SharedObjectFlushStatus.FLUSHED) {
					}
					
				}
				catch(e:Error) {
				}
			}
			if(_loc1_.data.volume < 0 || String(_loc1_.data.volume) == "NaN" || _loc1_.data.volume == undefined) {
				this.volume = _loc1_.data.volume;
				return;
			}
			this.volume = _loc1_.data.volume;
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
		
		protected function aboutTime() : void {
			var _loc1_:* = NaN;
			if(!(this._sysStatus_str == "4") && this._currentIndex_uint < this._video_arr.length) {
				_loc1_ = this.getNSTime(this._now_ns);
				this._nowTime_num = this._seeking?this._nowTime_num:_loc1_;
				Utils.debug("_now_ns.time:" + this._now_ns.time + " _nowTime_num:" + this._nowTime_num + " _seeking:" + this._seeking + " nstime:" + _loc1_ + " _fileType:" + this._fileType);
				this.dispatch(MediaEvent.PLAY_PROGRESS,{
					"nowTime":this._nowTime_num,
					"totTime":this._vTotTime_num,
					"isSeek":false
				});
			}
		}
		
		protected function asyncErrorHandler(param1:AsyncErrorEvent) : void {
			if(this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K) {
				LogManager.msg("asyncErrorHandler:" + param1);
			}
		}
		
		protected function ioErrorHandler(param1:IOErrorEvent) : void {
			if(this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K) {
				LogManager.msg("ioErrorHandler:" + param1);
			}
		}
		
		protected function onStatus(param1:NetStatusEvent) : void {
			var _loc3_:uint = 0;
			var _loc4_:uint = 0;
			Utils.debug("onStatus:" + param1);
			var _loc2_:NetStreamUtil = this._video_arr[this._currentIndex_uint].ns;
			switch(param1.info.code) {
				case "NetStream.Play.Start":
					if(this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K) {
						LogManager.msg("evt.info.code:" + param1.info.code + " _isStart:" + this._isStart + " _currentIndex_uint:" + this._currentIndex_uint);
					}
					this._startTime = 0;
					_loc2_.dragTime = 0;
					if(!this._isStart) {
						this._isStart = true;
						this._timer.start();
						if(this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K) {
							LogManager.msg("加载中...");
						}
						this.dispatch(MediaEvent.START);
					}
					break;
				case "NetStream.Buffer.Empty":
					if(this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K) {
						LogManager.msg("缓冲中(" + this._currentIndex_uint + ")...nstimeCeil:" + Math.ceil(this.getNSTime(this._now_ns) * 10) + " durationFloor:" + Math.floor(this._video_arr[this._currentIndex_uint].duration * 10) + " getNSTime:" + this.getNSTime(this._now_ns) + " stopflag:" + this._stopFlag_boo + " " + this.getClipInfo(this._currentIndex_uint));
					}
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
					if(this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K) {
						LogManager.msg("播放中(" + this._currentIndex_uint + ")...");
					}
					this.dispatch(MediaEvent.FULL);
					this.dispatch(MediaEvent.DRAG_END);
					this._seeking = false;
					if(!this._played_boo) {
						this._played_boo = true;
						this.dispatch(MediaEvent.PLAYED);
					}
					if(this._ttttt > 0) {
						this.seek(this._ttttt);
						this.play();
					}
					break;
				case "NetStream.Buffer.Flush":
					this._isBufferFlush = true;
					break;
				case "NetStream.Play.Stop":
					if(this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K) {
						LogManager.msg("第" + this._currentIndex_uint + "段Stop事件触发了！nstimeCeil:" + Math.ceil(this.getNSTime(this._now_ns) * 10) + " durationFloor:" + Math.floor(this._video_arr[this._currentIndex_uint].duration * 10) + " getNSTime:" + this.getNSTime(this._now_ns) + " stopflag:" + this._stopFlag_boo + " " + this.getClipInfo(this._currentIndex_uint));
					}
					if(this._stopFlag_boo) {
						this.judgeStop();
					} else {
						this._stopFlag_boo = true;
					}
					break;
				case "NetStream.Play.StreamNotFound":
					if(this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K) {
						LogManager.msg("视频不存在!");
					}
					break;
				case "NetStream.Seek.Notify":
					_loc4_ = 0;
					while(_loc4_ < this._video_arr.length) {
						this._video_arr[_loc4_].video.visible = false;
						_loc4_++;
					}
					this._video_arr[this._currentIndex_uint].video.visible = true;
					if(this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K) {
						LogManager.msg("NetStream.Seek.Notify");
					}
					break;
				case "NetStream.Seek.InvalidTime":
					if(this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K) {
						LogManager.msg("Seek.InvalidTime");
					}
					break;
				case "NetStream.Seek.Failed":
					if(this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K) {
						LogManager.msg("Seek.Failed");
					}
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
			if(this._sysStatus_str == "5") {
				this._now_ns.play(this._video_arr[0].flv);
				this._video_arr[this._downloadIndex_uint].download = "loading";
				if(this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K) {
					LogManager.msg("开始播放:" + this._video_arr[0].flv);
				}
				this.dispatch(MediaEvent.CONNECTING);
			}
			if(this._sysStatus_str == "4") {
				if(this._video_arr[this._currentIndex_uint].download == "no") {
					if(this._startTime > 0) {
						this._now_ns.play(this._video_arr[0].flv);
						this._video_arr[this._downloadIndex_uint].download = "part_loading";
						this._ttttt = this._startTime;
					} else {
						this._now_ns.play(this._video_arr[0].flv);
						this._video_arr[this._downloadIndex_uint].download = "loading";
					}
					this.dispatch(MediaEvent.DRAG_START);
					this.dispatch(MediaEvent.CONNECTING);
				}
				trace("_now_ns.resume();");
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
				this._doNCClose = true;
				this._timer.stop();
				this.changeNS(this._currentIndex_uint,0);
				if(this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K) {
					LogManager.msg("停止了_now_ns:" + this._now_ns);
				}
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
		
		private function initSectState(param1:uint) : void {
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
			Utils.debug("MediaEvent.DRAG_START:" + MediaEvent.DRAG_START);
			this.K1026043DB3C4729D2C49DD8DF29CB1BC5D1968373567K(param2);
			Utils.debug("_playedTime:" + this._playedTime_num + " _nowLoadedSize_num:" + this._nowLoadedSize_num);
			this.changeNS(this._currentIndex_uint,param2);
			this._currentIndex_uint = this._downloadIndex_uint = param2;
			Utils.debug("_startTime111111111111111:" + this._startTime);
			this._startTime = Math.abs(Math.round(param1));
			Utils.debug("_startTime222222222222222:" + this._startTime);
			if(this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K) {
				LogManager.msg("--------========++++++++");
			}
			this._startTime = this._startTime <= this._optimize?0:this._startTime;
			Utils.debug("_startTime333333333333333:" + this._startTime);
		}
		
		public function seek(param1:Number, param2:* = null) : void {
			this._playedTime_num = 0;
			trace("sec:" + param1 + " _vTotTime_num:" + this._vTotTime_num);
			if(param1 >= 0 && param1 <= this._vTotTime_num && !(param2 == 0)) {
				this._now_ns.pause();
				this._sysStatus_str = "4";
				this._seeking = true;
				this._nowTime_num = param1;
				this._startTime = param1;
				if(this._video_arr[this._currentIndex_uint].download != "no") {
					trace("_now_ns.seek(sec)");
					this._now_ns.seek(param1);
					this._ttttt = 0;
					this.dispatch(MediaEvent.DRAG_START);
					this.dispatch(MediaEvent.CONNECTING);
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
		
		public function get downloadIndex() : Number {
			return this._downloadIndex_uint;
		}
		
		public function get vrate() : Number {
			if(this._videoRate == -1) {
				return Math.round(this._fileSize_num / this._vTotTime_num);
			}
			return this._videoRate;
		}
		
		public function dispatch(param1:String, param2:Object = null) : void {
			var _loc3_:MediaEvent = new MediaEvent(param1);
			_loc3_.obj = param2;
			dispatchEvent(_loc3_);
		}
	}
}
