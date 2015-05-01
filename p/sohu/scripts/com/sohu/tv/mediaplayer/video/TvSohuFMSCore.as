package com.sohu.tv.mediaplayer.video {
	import ebing.core.FMSCore;
	import com.sohu.tv.mediaplayer.stat.*;
	import ebing.events.*;
	import ebing.net.*;
	import ebing.utils.*;
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.media.Video;
	import com.sohu.tv.mediaplayer.PlayerConfig;
	import ebing.Utils;
	
	public class TvSohuFMSCore extends FMSCore {
		
		public function TvSohuFMSCore(param1:Object) {
			this._videoArr = new Array();
			super(param1);
			this._qfStat = ErrorSenderPQ.getInstance();
		}
		
		private var _addChildId:Number = 0;
		
		private var _ncRetryNum:Number = 2;
		
		private var _totBufferNum:Number = 0;
		
		private var _qfStat:ErrorSenderPQ;
		
		private var _displayRate:Number = 1;
		
		private var _scaleWidth:Number = 0;
		
		private var _scaleHeight:Number = 0;
		
		private var _scaleState:String = "meta";
		
		private var _connectTimer:Number = 0;
		
		private var _bufferSpend:uint = 0;
		
		private var _rotateType:int = 0;
		
		private var _videoArr:Array;
		
		private var _isDirectRotation:Boolean = false;
		
		private var _coreTempTime:Number = 0;
		
		private var _softInitObj:Object;
		
		public function get lastoutBuffer() : Boolean {
			return false;
		}
		
		override public function initMedia(param1:Object) : void {
			var _loc9_:uint = 0;
			this._softInitObj = param1;
			var _loc2_:String = param1.flv;
			var _loc3_:String = param1.time;
			var _loc4_:String = param1.size;
			_isGained = false;
			_vTotTime_num = 0;
			_fileSize_num = 0;
			if(_video_arr != null) {
				_loc9_ = 0;
				while(_loc9_ < _video_arr.length) {
					_video_arr[_loc9_].ns.removeEventListener(NetStatusEvent.NET_STATUS,this.onStatus);
					_video_arr[_loc9_].ns.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,asyncErrorHandler);
					_video_arr[_loc9_].ns.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
					_video_c.removeChild(_video_arr[_loc9_].video);
					_loc9_++;
				}
				_video_arr.splice(0);
			}
			var _loc5_:Array = _loc2_.split(",");
			var _loc6_:Array = _loc3_.split(",");
			var _loc7_:Array = _loc4_.split(",");
			_video_arr = new Array();
			var _loc8_:uint = 0;
			while(_loc8_ < _loc5_.length) {
				_video_arr[_loc8_] = {
					"flv":_loc5_[_loc8_],
					"video":new Video(),
					"start":(_loc8_ == 0?0:_vTotTime_num + 1),
					"end":(_loc8_ == 0?_loc6_[_loc8_]:_vTotTime_num + Number(_loc6_[_loc8_])),
					"download":"no",
					"ns":new NetStreamUtil(_my_nc),
					"time":Number(_loc6_[_loc8_]),
					"size":Number(_loc7_[_loc8_]),
					"iserr":false,
					"datastart":0,
					"dataend":0,
					"duration":Number(_loc6_[_loc8_]),
					"gotMetaData":false,
					"isnp":true,
					"sendVV":false,
					"datarate":Math.floor(Number(_loc7_[_loc8_]) * 8 / 1000 / Number(_loc6_[_loc8_]))
				};
				_vTotTime_num = _vTotTime_num + Number(_loc6_[_loc8_]);
				_fileSize_num = _fileSize_num + Number(_loc7_[_loc8_]);
				_video_arr[_loc8_].video.smoothing = true;
				_video_arr[_loc8_].video.attachNetStream(_video_arr[_loc8_].ns);
				_video_arr[_loc8_].ns.bufferTime = _buffer_num;
				_video_arr[_loc8_].video.visible = false;
				_video_arr[_loc8_].ns.client = _clientTem_obj;
				_video_arr[_loc8_].ns.clipNo = _loc8_;
				_video_c.addChild(_video_arr[_loc8_].video);
				this._videoArr.push(_video_arr[_loc8_].video);
				_loc8_++;
			}
			addChild(_video_c);
			this.refresh(false);
			this.resize(_width_num,_height_num);
			_video_arr[0].ns.addEventListener(NetStatusEvent.NET_STATUS,this.onStatus);
			_video_arr[0].ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR,asyncErrorHandler);
			_video_arr[0].ns.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			_video_arr[0].ns.client = _client_obj;
			_now_ns = _video_arr[0].ns;
			_video_arr[0].video.visible = true;
			this.initVolume();
			sysInit();
		}
		
		override public function initVolume() : void {
			if(!PlayerConfig.isMute) {
				super.initVolume();
			} else {
				volume = 0;
			}
		}
		
		override protected function connectNC() : void {
			LogManager.msg("开始连接FMS服务器！ 地址：" + _rtmpeUrl);
			super.connectNC();
			clearTimeout(this._connectTimer);
			this._connectTimer = setTimeout(this.connectTimeout,10 * 1000);
		}
		
		private function connectTimeout() : void {
			_my_nc.close();
		}
		
		override protected function netStatusHandler(param1:NetStatusEvent) : void {
			var evt:NetStatusEvent = param1;
			Utils.debug(evt.info.code);
			switch(evt.info.code) {
				case "NetConnection.Connect.Success":
					clearTimeout(this._connectTimer);
					if(_sysInited) {
						if(_sysStatus_str == "3") {
							seek(_startTime);
							this.play();
						} else if(_sysStatus_str == "4") {
							seek(_startTime);
						}
						
					}
					break;
				case "NetConnection.Connect.Closed":
					if(!_doNCClose) {
						if(this._ncRetryNum-- > 0) {
							setTimeout(function():void {
								_rtmpeUrl = _rtmpeUrl.replace("rtmpe","rtmpte");
								connectNC();
							},500);
						} else if(this._ncRetryNum <= 0) {
							this._qfStat.sendPQStat({
								"error":PlayerConfig.CDN_ERROR_NETCONNECTION,
								"code":PlayerConfig.CDN_CODE,
								"split":0,
								"dom":(_rtmpeUrl?_rtmpeUrl:""),
								"drag":-1,
								"allno":1,
								"errno":1,
								"cdnid":PlayerConfig.cdnId,
								"datarate":0
							});
							dispatch(MediaEvent.NC_RETRY_FAILED);
						}
						
					}
					break;
				case "NetConnection.Connect.Failed":
					if(this._ncRetryNum-- > 0) {
						setTimeout(function():void {
							_rtmpeUrl = _rtmpeUrl.replace("rtmpe","rtmpte");
							connectNC();
						},500);
					} else if(this._ncRetryNum <= 0) {
						this._qfStat.sendPQStat({
							"error":PlayerConfig.CDN_ERROR_NCFAILED,
							"code":PlayerConfig.CDN_CODE,
							"split":0,
							"dom":(_rtmpeUrl?_rtmpeUrl:""),
							"drag":-1,
							"allno":1,
							"errno":1,
							"cdnid":PlayerConfig.cdnId,
							"datarate":0
						});
						dispatch(MediaEvent.NC_RETRY_FAILED);
					}
					
					break;
				case "NetConnection.Connect.IdleTimeout":
					LogManager.msg("FMS服务器超时!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
					break;
			}
			super.netStatusHandler(evt);
		}
		
		override protected function timerHandler(param1:TimerEvent) : void {
			aboutTime();
			if(Math.ceil(getNSTime(_now_ns) * 10) >= Math.floor(_video_arr[_currentIndex_uint].duration * 10) && !(_video_arr[_currentIndex_uint].duration == 0) || Math.ceil(getNSTime(_now_ns) * 10) >= Math.floor(fileTotTime * 10)) {
				Utils.debug("timerHandler:" + _stopFlag_boo + " _now_ns.time:" + _now_ns.time + " duration:" + _video_arr[_currentIndex_uint].duration);
				if(_stopFlag_boo) {
					judgeStop();
				} else {
					_stopFlag_boo = true;
				}
			}
			param1.updateAfterEvent();
		}
		
		override public function get vrate() : Number {
			return _video_arr[_downloadIndex_uint].datarate;
		}
		
		public function displayZoom(param1:Number = 1) : void {
			if(param1 > 0 && param1 <= 1) {
				this._displayRate = param1;
				Utils.prorata(_video_c,this._displayRate * _bg_spr.width,this._displayRate * _bg_spr.height);
				Utils.setCenter(_video_c,_bg_spr);
			}
		}
		
		public function displayTo4_3(param1:Event) : void {
			this._scaleState = "4_3";
			if(this._rotateType % 2 != 0) {
				this._scaleWidth = 3;
				this._scaleHeight = 4;
			} else {
				this._scaleWidth = 4;
				this._scaleHeight = 3;
			}
			this.resize(_width_num,_height_num);
		}
		
		public function displayTo16_9(param1:Event) : void {
			this._scaleState = "16_9";
			if(this._rotateType % 2 != 0) {
				this._scaleWidth = 9;
				this._scaleHeight = 16;
			} else {
				this._scaleWidth = 16;
				this._scaleHeight = 9;
			}
			this.resize(_width_num,_height_num);
		}
		
		public function displayToMeta(param1:Event) : void {
			this._scaleState = "meta";
			this._scaleWidth = this._scaleHeight = 0;
			this.resize(_width_num,_height_num);
		}
		
		public function displayToFull(param1:Event) : void {
			this._scaleState = "full";
			this._scaleWidth = _width_num;
			this._scaleHeight = _height_num;
			this.resize(_width_num,_height_num);
		}
		
		public function setR(param1:int) : void {
			this._rotateType = param1;
			this._isDirectRotation = true;
			this.refresh();
			this.resize(_width_num,_height_num);
		}
		
		public function get scaleState() : String {
			return this._scaleState;
		}
		
		public function get rotateType() : int {
			return this._rotateType;
		}
		
		public function get loadingClipIndex() : Number {
			return _downloadIndex_uint;
		}
		
		override public function play(param1:* = null) : void {
			this._coreTempTime = new Date().getTime();
			super.play(param1);
		}
		
		public function get coreTempTime() : Number {
			return this._coreTempTime;
		}
		
		override public function resize(param1:Number, param2:Number) : void {
			var _loc3_:* = 0;
			_width_num = _bg_spr.width = param1;
			_height_num = _bg_spr.height = param2;
			if(this._scaleState == "full") {
				if(this._rotateType % 2 != 0) {
					this._scaleWidth = _height_num;
					this._scaleHeight = _width_num;
				} else {
					this._scaleWidth = _width_num;
					this._scaleHeight = _height_num;
				}
			}
			if(_video_arr != null) {
				if(this._scaleWidth != 0) {
					_video_c.width = this._scaleWidth;
					_video_c.height = this._scaleHeight;
				} else if(_metaWidth_num != 0) {
					if(this._rotateType % 2 != 0) {
						_video_c.width = _metaHeight_num;
						_video_c.height = _metaWidth_num;
					} else {
						_video_c.width = _metaWidth_num;
						_video_c.height = _metaHeight_num;
					}
				} else {
					_video_c.width = _width_num;
					_video_c.height = _height_num;
				}
				
				if(this._displayRate == 1) {
					Utils.prorata(_video_c,_bg_spr.width,_bg_spr.height);
					Utils.setCenter(_video_c,_bg_spr);
				} else {
					this.displayZoom(this._displayRate);
				}
				if(this._isDirectRotation) {
					_loc3_ = 0;
					if(this._rotateType == 1) {
						_loc3_ = 0;
						while(_loc3_ < this._videoArr.length) {
							this._videoArr[_loc3_].x = this._videoArr[_loc3_].width;
							this._videoArr[_loc3_].y = 0;
							_loc3_++;
						}
					} else if(this._rotateType == 2) {
						_loc3_ = 0;
						while(_loc3_ < this._videoArr.length) {
							this._videoArr[_loc3_].x = this._videoArr[_loc3_].width;
							this._videoArr[_loc3_].y = this._videoArr[_loc3_].height;
							_loc3_++;
						}
					} else if(this._rotateType == 3) {
						_loc3_ = 0;
						while(_loc3_ < this._videoArr.length) {
							this._videoArr[_loc3_].x = 0;
							this._videoArr[_loc3_].y = this._videoArr[_loc3_].height;
							_loc3_++;
						}
					} else if(this._rotateType == 0) {
						_loc3_ = 0;
						while(_loc3_ < this._videoArr.length) {
							this._videoArr[_loc3_].x = 0;
							this._videoArr[_loc3_].y = 0;
							_loc3_++;
						}
					}
					
					
					
				}
			}
		}
		
		private function refresh(param1:Boolean = true) : void {
			var _loc3_:* = NaN;
			if(param1) {
				_loc3_ = this._scaleWidth;
				this._scaleWidth = this._scaleHeight;
				this._scaleHeight = _loc3_;
			}
			var _loc2_:uint = 0;
			while(_loc2_ < this._videoArr.length) {
				this._videoArr[_loc2_].rotation = this._rotateType * 90;
				_loc2_++;
			}
		}
		
		override public function stop(param1:* = null) : void {
			super.stop(param1);
			this.initMedia(this._softInitObj);
		}
		
		override protected function onStatus(param1:NetStatusEvent) : void {
			super.onStatus(param1);
			var _loc2_:NetStreamUtil = _video_arr[_currentIndex_uint].ns;
			switch(param1.info.code) {
				case "NetStream.Buffer.Empty":
					if(!_isBufferFlush && _loc2_.bufferLength < _loc2_.bufferTime) {
						_loc2_.bufferNum++;
						this._totBufferNum++;
						this._bufferSpend = getTimer();
						this._qfStat.sendPQStat({
							"error":1,
							"code":PlayerConfig.BUFFER_CODE,
							"split":_currentIndex_uint + 1,
							"dom":_loc2_.playUrl,
							"ontime":_loc2_.time,
							"bufno":_loc2_.bufferNum,
							"allbufno":this._totBufferNum,
							"datarate":_video_arr[_currentIndex_uint].datarate
						});
					}
					break;
				case "NetStream.Buffer.Full":
					if(this._totBufferNum == 1 && this._bufferSpend > 0) {
						this._qfStat.sendPQStat({
							"error":0,
							"code":PlayerConfig.BUFFER_FULL_CODE,
							"bd":getTimer() - this._bufferSpend,
							"split":_currentIndex_uint + 1,
							"dom":_loc2_.playUrl,
							"ontime":_loc2_.time,
							"bufno":_loc2_.bufferNum,
							"allbufno":this._totBufferNum,
							"datarate":_video_arr[_currentIndex_uint].datarate
						});
						this._bufferSpend = 0;
					}
					break;
				case "NetStream.Play.Stop":
					if(PlayerConfig.allErrNo == 0 && this._totBufferNum == 0 && _video_arr[_currentIndex_uint].ns.time > 0 && _video_arr[_currentIndex_uint].ns.time + 30 < _video_arr[_currentIndex_uint].time) {
						this._qfStat.sendPQStat({
							"error":0,
							"code":99,
							"ontime":_video_arr[_currentIndex_uint].ns.time,
							"dom":_loc2_.playUrl,
							"drag":_loc2_.dragTime,
							"errno":_loc2_.cdnNum + _loc2_.gslbNum,
							"cdnid":PlayerConfig.cdnId
						});
					}
					break;
				case "NetStream.Play.StreamNotFound":
					_video_arr[_currentIndex_uint].ns.destroyLocation();
					if(_video_arr[_currentIndex_uint].retryNum == 0) {
						_video_arr[_currentIndex_uint].iserr = true;
						dispatch(MediaEvent.RETRY_FAILED);
						dispatch(MediaEvent.NOTFOUND);
						dispatch(MediaEvent.DRAG_END);
						PlayerConfig.allErrNo++;
						_loc2_.cdnNum++;
						_video_arr[_currentIndex_uint].retryNum = -1;
					} else {
						_video_arr[_currentIndex_uint].iserr = false;
						_video_arr[_currentIndex_uint].retryNum--;
					}
					this._qfStat.sendPQStat({
						"error":PlayerConfig.CDN_ERROR_NOTFOUND,
						"code":PlayerConfig.CDN_CODE,
						"split":_currentIndex_uint + 1,
						"dom":_loc2_.playUrl,
						"drag":_loc2_.dragTime,
						"allno":PlayerConfig.allErrNo,
						"errno":_loc2_.cdnNum + _loc2_.gslbNum,
						"cdnid":PlayerConfig.cdnId,
						"datarate":_video_arr[_currentIndex_uint].datarate
					});
					break;
				case "NetStream.Play.Failed":
					LogManager.msg("第" + _currentIndex_uint + "段[视频]加载失败！retryNum:" + _video_arr[_currentIndex_uint].retryNum);
					if(_video_arr[_currentIndex_uint].retryNum == 0) {
						_video_arr[_currentIndex_uint].iserr = true;
						dispatch(MediaEvent.RETRY_FAILED);
						dispatch(MediaEvent.NOTFOUND);
						dispatch(MediaEvent.DRAG_END);
						PlayerConfig.allErrNo++;
						_loc2_.cdnNum++;
						_video_arr[_currentIndex_uint].retryNum = -1;
					} else {
						_video_arr[_currentIndex_uint].iserr = false;
						_video_arr[_currentIndex_uint].retryNum--;
					}
					this._qfStat.sendPQStat({
						"error":PlayerConfig.CDN_ERROR_FAILED,
						"code":PlayerConfig.CDN_CODE,
						"split":_currentIndex_uint + 1,
						"dom":_loc2_.playUrl,
						"drag":_loc2_.dragTime,
						"allno":PlayerConfig.allErrNo,
						"errno":_loc2_.cdnNum + _loc2_.gslbNum,
						"cdnid":PlayerConfig.cdnId,
						"datarate":_video_arr[_currentIndex_uint].datarate
					});
					break;
				case "NetStream.Play.FileStructureInvalid":
					LogManager.msg("第" + _currentIndex_uint + "段[视频]文件结构无效！retryNum:" + _video_arr[_currentIndex_uint].retryNum);
					if(_video_arr[_currentIndex_uint].retryNum == 0) {
						_video_arr[_currentIndex_uint].iserr = true;
						dispatch(MediaEvent.RETRY_FAILED);
						dispatch(MediaEvent.NOTFOUND);
						dispatch(MediaEvent.DRAG_END);
						PlayerConfig.allErrNo++;
						_loc2_.cdnNum++;
						_video_arr[_currentIndex_uint].retryNum = -1;
					} else {
						_video_arr[_currentIndex_uint].iserr = false;
						_video_arr[_currentIndex_uint].retryNum--;
					}
					this._qfStat.sendPQStat({
						"error":PlayerConfig.CDN_ERROR_FAILED,
						"code":PlayerConfig.CDN_CODE,
						"split":_currentIndex_uint + 1,
						"dom":_loc2_.playUrl,
						"drag":_loc2_.dragTime,
						"allno":PlayerConfig.allErrNo,
						"errno":_loc2_.cdnNum + _loc2_.gslbNum,
						"cdnid":PlayerConfig.cdnId,
						"datarate":_video_arr[_currentIndex_uint].datarate
					});
					break;
				case "CDNTimeout":
					LogManager.msg("第" + _currentIndex_uint + "段[视频]CDN超时！retryNum:" + _video_arr[_currentIndex_uint].retryNum);
					if(_video_arr[_currentIndex_uint].retryNum == 0) {
						_video_arr[_currentIndex_uint].iserr = true;
						dispatch(MediaEvent.RETRY_FAILED);
						dispatch(MediaEvent.NOTFOUND);
						dispatch(MediaEvent.DRAG_END);
						PlayerConfig.allErrNo++;
						_loc2_.cdnNum++;
						_video_arr[_currentIndex_uint].retryNum = -1;
					} else {
						_video_arr[_currentIndex_uint].iserr = false;
						_video_arr[_currentIndex_uint].retryNum--;
					}
					this._qfStat.sendPQStat({
						"error":PlayerConfig.CDN_ERROR_TIMEOUT,
						"code":PlayerConfig.CDN_CODE,
						"split":_currentIndex_uint + 1,
						"dom":_loc2_.playUrl,
						"drag":_loc2_.dragTime,
						"allno":PlayerConfig.allErrNo,
						"errno":_loc2_.cdnNum + _loc2_.gslbNum,
						"cdnid":PlayerConfig.cdnId,
						"datarate":_video_arr[_currentIndex_uint].datarate
					});
					break;
				case "NetStream.Play.Start":
					_video_arr[_currentIndex_uint].cdnuse = _loc2_.cdnuse;
					_video_arr[_currentIndex_uint].iserr = false;
					if((_video_arr[_currentIndex_uint].isnp) && _video_arr[_currentIndex_uint].sendVV == false) {
						_video_arr[_currentIndex_uint].isnp = false;
						_video_arr[_currentIndex_uint].sendVV = true;
					}
					break;
			}
		}
	}
}
