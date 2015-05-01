package com.sohu.tv.mediaplayer.video {
	import ebing.core.vc37.VideoCore;
	import flash.display.Stage;
	import com.sohu.tv.mediaplayer.stat.*;
	import com.sohu.tv.mediaplayer.netstream.*;
	import ebing.events.*;
	import ebing.net.*;
	import ebing.utils.*;
	import flash.events.*;
	import flash.utils.*;
	import com.sohu.tv.mediaplayer.PlayerConfig;
	import com.sohu.tv.mediaplayer.p2p.P2PExplorer;
	import ebing.Utils;
	import ebing.external.Eif;
	import flash.external.ExternalInterface;
	import com.sohu.tv.mediaplayer.ads.TvSohuAds;
	import flash.media.Video;
	import p2pstream.XNetStreamVODFactory;
	import p2pstream.XNetStreamFactory;
	
	public class TvSohuVideoCore extends VideoCore {
		
		public function TvSohuVideoCore(param1:Object) {
			this._videoArr = new Array();
			this._owner = this;
			this._qfStat = ErrorSenderPQ.getInstance();
			if(param1.stage != null) {
				this._stage = param1.stage;
			}
			super(param1);
			this.sendP2PStat();
		}
		
		private var _qfStat:ErrorSenderPQ;
		
		private var _totBufferNum:Number = 0;
		
		private var _bufferEmptyTime:Number = 0;
		
		private var _retryNum:int = 3;
		
		private var _owner:TvSohuVideoCore;
		
		private var _previousIndex_int:int = -1;
		
		private var _displayRate:Number = 1;
		
		private var _scaleWidth:Number = 0;
		
		private var _scaleHeight:Number = 0;
		
		private var _scaleState:String = "meta";
		
		private var _bufferSpend:uint = 0;
		
		private var _intervalRetry:Number = 0;
		
		private var _rotateType:int = 0;
		
		private var _videoArr:Array;
		
		private var _isDirectRotation:Boolean = false;
		
		private var _isped:String = "0";
		
		private var _fbt:Number = 0;
		
		private var _dragNum:Number = 0;
		
		private var _softInitObj:Object;
		
		private var _coreTempTime:Number = 0;
		
		private var _vvBytesTotal:Number = 0;
		
		private var _clipBytesAugmenter:Number = 0;
		
		private var _stage:Stage;
		
		private var _lastTimeCDNBytes:Number = 0;
		
		private var _lastTimePeerBytes:Number = 0;
		
		override public function initMedia(param1:Object) : void {
			var _loc10_:uint = 0;
			this._softInitObj = param1;
			var _loc2_:Boolean = param1.is200;
			var _loc3_:String = param1.flv;
			var _loc4_:String = param1.time;
			var _loc5_:String = param1.size;
			_isGained = false;
			_vTotTime_num = 0;
			_fileSize_num = 0;
			if(_video_arr != null) {
				_loc10_ = 0;
				while(_loc10_ < _video_arr.length) {
					_video_arr[_loc10_].ns.removeEventListener(NetStatusEvent.NET_STATUS,this.onStatus);
					_video_arr[_loc10_].ns.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,asyncErrorHandler);
					_video_c.removeChild(_video_arr[_loc10_].video);
					_video_arr[_loc10_].video.dispose();
					_loc10_++;
				}
				_video_arr.splice(0);
			}
			_video_arr = new Array();
			LogManager.msg("isWebP2p:" + PlayerConfig.isWebP2p);
			LogManager.msg("==========播放器初始化数据开始==========");
			var _loc6_:Array = _loc3_.split(",");
			var _loc7_:Array = _loc4_.split(",");
			var _loc8_:Array = _loc5_.split(",");
			var _loc9_:uint = 0;
			while(_loc9_ < _loc6_.length) {
				_video_arr[_loc9_] = {
					"flv":_loc6_[_loc9_],
					"video":new TvSohuVideo(this._stage),
					"start":(_loc9_ == 0?0:_vTotTime_num + 1),
					"end":(_loc9_ == 0?_loc7_[_loc9_]:_vTotTime_num + Number(_loc7_[_loc9_])),
					"download":"no",
					"ns":(PlayerConfig.isWebP2p?new PlayVODStream(_my_nc,_loc2_,true,_loc9_):new TvSohuNetStream(_my_nc,_loc2_,true)),
					"time":Number(_loc7_[_loc9_]),
					"size":Number(_loc8_[_loc9_]),
					"iserr":false,
					"datastart":0,
					"dataend":0,
					"duration":Number(_loc7_[_loc9_]),
					"gotMetaData":false,
					"datarate":Math.floor(Number(_loc8_[_loc9_]) * 8 / 1024 / Number(_loc7_[_loc9_])),
					"isnp":false,
					"sendVV":false,
					"retryNum":this._retryNum,
					"laRetryNum":3,
					"bytesTotal":0,
					"isSentQF":false,
					"isAbend":false
				};
				_vTotTime_num = _vTotTime_num + Number(_loc7_[_loc9_]);
				_fileSize_num = _fileSize_num + Number(_loc8_[_loc9_]);
				_video_arr[_loc9_].video.smoothing = true;
				if(PlayerConfig.isWebP2p) {
					_video_arr[_loc9_].ns.attachVideoToStream(_video_arr[_loc9_].video);
				} else {
					_video_arr[_loc9_].video.attachNetStream(_video_arr[_loc9_].ns);
					_video_arr[_loc9_].ns.clipNo = _loc9_;
				}
				_video_arr[_loc9_].ns.bufferTime = _buffer_num;
				_video_arr[_loc9_].video.visible = false;
				_video_arr[_loc9_].ns.client = _clientTem_obj;
				_video_c.addChild(_video_arr[_loc9_].video);
				this._videoArr.push(_video_arr[_loc9_].video);
				LogManager.msg(getClipInfo(_loc9_));
				_loc9_++;
			}
			addChild(_video_c);
			this.refresh(false);
			this.resize(_width_num,_height_num);
			_video_arr[0].ns.addEventListener(NetStatusEvent.NET_STATUS,this.onStatus);
			LogManager.msg("==========播放器初始化数据结束==========");
			_video_arr[0].ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR,asyncErrorHandler);
			_video_arr[0].ns.client = _client_obj;
			_now_ns = _video_arr[0].ns;
			this.setPredictMode();
			_video_arr[0].video.visible = true;
			this.initVolume();
			this._lastTimeCDNBytes = this._lastTimePeerBytes = 0;
			sysInit();
		}
		
		private function webP2PRollback() : void {
			PlayerConfig.isWebP2p = false;
			var _loc1_:uint = filePlayedTime;
			this.stop("noevent");
			this.initMedia(this._softInitObj);
			seek(_loc1_);
		}
		
		override public function pause(param1:* = null) : void {
			super.pause(param1);
			if(!(param1 == "0") && !(param1 == null)) {
				this._isped = "1";
			}
		}
		
		override public function initVolume() : void {
			if(!PlayerConfig.isMute) {
				super.initVolume();
			} else {
				volume = 0;
			}
		}
		
		override protected function timerHandler(param1:TimerEvent) : void {
			if(!PlayerConfig.isLive || (PlayerConfig.isP2PLive)) {
				super.timerHandler(param1);
			} else {
				aboutTime();
				if(getNSTime(_now_ns) >= 1 && !_played_boo && _sysStatus_str == "3") {
					_played_boo = true;
					dispatch(MediaEvent.PLAYED);
				}
			}
		}
		
		override public function stop(param1:* = null) : void {
			if(_sysStatus_str != "5") {
				this.closeDownNextVideo();
			}
			this.saveSvdMode();
			super.stop(param1);
			this.initMedia(this._softInitObj);
		}
		
		override public function destroy() : void {
			this.closeDownNextVideo();
			super.destroy();
		}
		
		private function closeDownNextVideo() : void {
			new URLLoaderUtil().send(PlayerConfig.CHECKP2PPATH + "stoppreload?uuid=" + PlayerConfig.uuid);
		}
		
		override protected function newFunc() : void {
			super.newFunc();
			P2PExplorer.getInstance();
		}
		
		override public function get vrate() : Number {
			return _video_arr[_downloadIndex_uint].datarate;
		}
		
		public function get coreTempTime() : Number {
			return this._coreTempTime;
		}
		
		public function displayZoom(param1:Number = 1) : void {
			if(param1 > 0 && param1 <= 1) {
				this._displayRate = param1;
				Utils.prorata(_video_c,this._displayRate * _bg_spr.width,this._displayRate * _bg_spr.height);
				Utils.setCenter(_video_c,_bg_spr);
				this.changeStvWHXY();
			}
		}
		
		public function displayTo4_3(param1:Event = null) : void {
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
		
		public function displayTo16_9(param1:Event = null) : void {
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
		
		public function displayToMeta(param1:Event = null) : void {
			this._scaleState = "meta";
			this._scaleWidth = this._scaleHeight = 0;
			this.resize(_width_num,_height_num);
		}
		
		public function displayToFull(param1:Event = null) : void {
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
		
		public function get vvBytesTotal() : Number {
			return this._vvBytesTotal;
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
					this.changeStvWHXY();
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
		
		override public function play(param1:* = null) : void {
			var _loc2_:* = undefined;
			Utils.debug("play:" + _sysStatus_str);
			this._coreTempTime = new Date().getTime();
			if(_sysStatus_str == "5") {
				if(!PlayerConfig.sendRealVV) {
					PlayerConfig.videoDownloadTime = getTimer();
				}
				_now_ns.play(_video_arr[0].flv);
				_video_arr[_downloadIndex_uint].download = "loading";
				dispatch(MediaEvent.CONNECTING);
			}
			if(_sysStatus_str == "4") {
				_loc2_ = _startTime > 0?_startTime:null;
				if(_video_arr[_currentIndex_uint].download == "no") {
					this.download(_currentIndex_uint,_loc2_);
					_video_arr[_downloadIndex_uint].ns.removeEventListener(NetStatusEvent.NET_STATUS,this.downLoadStreamStatus);
					dispatch(MediaEvent.CONNECTING);
				}
				_now_ns.resume();
			}
			_sysStatus_str = "3";
			dispatch(MediaEvent.PLAY);
		}
		
		override protected function aboutDownload() : void {
			var by_num:Number = NaN;
			var tot_num:Number = NaN;
			var metaByTot_num:Number = NaN;
			var loaded:Number = NaN;
			var download:String = null;
			var index:uint = 0;
			var i:uint = 0;
			var vid:String = null;
			if(!(_video_arr[_downloadIndex_uint].download == "abend") && (_video_arr[_downloadIndex_uint].download == "loading" || _video_arr[_downloadIndex_uint].download == "part_loading")) {
				by_num = _video_arr[_downloadIndex_uint].ns.bytesLoaded;
				tot_num = _video_arr[_downloadIndex_uint].ns.bytesTotal;
				metaByTot_num = _video_arr[_downloadIndex_uint].bytesTotal;
				loaded = _nowLoadedSize2_num = _nowLoadedSize_num + by_num;
				if(this._clipBytesAugmenter > by_num) {
					this._vvBytesTotal = this._vvBytesTotal + by_num;
				} else {
					this._vvBytesTotal = this._vvBytesTotal + (by_num - this._clipBytesAugmenter);
				}
				this._clipBytesAugmenter = by_num;
				if(_tow) {
					_video_arr[_downloadIndex_uint].dataend = _video_arr[_downloadIndex_uint].datastart + _video_arr[_downloadIndex_uint].duration * by_num / tot_num;
				}
				if(by_num >= tot_num && tot_num > 0) {
					if(metaByTot_num - tot_num <= 200) {
						download = "loaded";
						if(_video_arr[_downloadIndex_uint].ns.isDrag) {
							download = "part_loaded";
						}
						_video_arr[_downloadIndex_uint].download = download;
						_nowLoadedSize_num = _nowLoadedSize_num + tot_num;
						try {
							Utils.debug("_downloadIndex_uint:" + _downloadIndex_uint + "_video_arr[_downloadIndex_uint].download:" + _video_arr[_downloadIndex_uint].download);
							index = _downloadIndex_uint + 1;
							i = index;
							while(i < _video_arr.length) {
								if(_video_arr[i].download == "loaded") {
									_nowLoadedSize_num = _nowLoadedSize_num + _video_arr[i].size;
									_downloadIndex_uint = i;
									i++;
									continue;
								}
								break;
							}
							LogManager.msg("当前视频加载完毕了(" + _downloadIndex_uint + ") by_num:" + by_num + " tot_num:" + tot_num + " metaByTot_num:" + metaByTot_num);
							by_num = tot_num = 0;
							_video_arr[_downloadIndex_uint].ns.sendCloseEvent();
							if(_downloadIndex_uint == _video_arr.length - 1 && (Eif.available)) {
								ExternalInterface.call("playerMovieLoaded");
								dispatchEvent(new Event("allLoaded"));
								if(Eif.available) {
									vid = ExternalInterface.call("getNextVideo")["videoId"];
									if(vid != null) {
										new URLLoaderUtil().load(8,null,"http://127.0.0.1:8828/preload?uuid=" + PlayerConfig.uuid + "&vid=" + vid + "&ptime=" + _nowTime_num + "&duration=" + _vTotTime_num + "&definition=" + (PlayerConfig.autoFix == "1"?"3":PlayerConfig.superVid == PlayerConfig.currentVid?"0":PlayerConfig.oriVid == PlayerConfig.currentVid?"4":PlayerConfig.hdVid == PlayerConfig.currentVid?"1":"2") + "&r=" + new Date().getTime());
									}
								}
							}
							this.checkLastoutBuffer();
						}
						catch(evt:*) {
							Utils.debug(evt);
						}
					} else if(!_video_arr[_downloadIndex_uint].isAbend) {
						_video_arr[_downloadIndex_uint].isAbend = true;
						this.downloadAbend({
							"nowSize":by_num,
							"totSize":tot_num,
							"metaTotSize":metaByTot_num,
							"clipIndex":_downloadIndex_uint
						});
					}
					
				}
				dispatch(MediaEvent.LOAD_PROGRESS,{
					"nowSize":_nowLoadedSize_num + by_num,
					"totSize":_fileSize_num
				});
			}
		}
		
		override protected function downloadAbend(param1:Object) : void {
			super.downloadAbend(param1);
			this.downLoadStreamStatus(new NetStatusEvent(NetStatusEvent.NET_STATUS,false,false,{"code":"Load.abend"}));
		}
		
		override protected function initSectState(param1:uint) : void {
			var _loc2_:* = false;
			if(param1 == _downloadIndex_uint && _video_arr[param1].download == "loading") {
				_loc2_ = true;
			}
			super.initSectState(param1);
			if(_loc2_) {
				_video_arr[param1].ns.sendCloseEvent();
			}
		}
		
		override protected function download(param1:uint, param2:* = null) : void {
			if(_video_arr[param1].flv != "null") {
				clearTimeout(this._intervalRetry);
				if(!PlayerConfig.sendRealVV) {
					PlayerConfig.videoDownloadTime = getTimer();
				}
				_video_arr[param1].retryNum = this._retryNum;
				_video_arr[param1].isSentQF = false;
				Utils.debug("*download*:" + this._previousIndex_int + "|" + _currentIndex_uint + "|" + param1 + "|" + _video_arr[param1].sendVV);
				if(this._previousIndex_int >= 0 && !(this._previousIndex_int == _currentIndex_uint) && !(_video_arr[this._previousIndex_int] == null)) {
					_video_arr[this._previousIndex_int].sendVV = false;
				}
				super.download(param1,param2);
				_video_arr[_downloadIndex_uint].ns.addEventListener(NetStatusEvent.NET_STATUS,this.downLoadStreamStatus);
			}
		}
		
		override protected function changeNS(param1:uint, param2:uint) : void {
			if(param1 != param2) {
				this._previousIndex_int = param1;
				Utils.debug("*changeNS*preInd:" + this._previousIndex_int.toString() + "/newInd:" + param2.toString());
			}
			_video_arr[param2].ns.removeEventListener(NetStatusEvent.NET_STATUS,this.downLoadStreamStatus);
			super.changeNS(param1,param2);
			PlayerConfig.playingSplit = _currentIndex_uint;
		}
		
		override protected function judgeStop() : void {
			var _loc1_:Boolean = Eif.available?new RegExp("GoogleTV","i").test(ExternalInterface.call("eval","window.navigator.userAgent")):false;
			if((PlayerConfig.isLive) && (PlayerConfig.isP2PLive) || (_loc1_)) {
				_now_ns.close();
			} else {
				_now_ns.pause();
			}
			if(_tow) {
				_playedTime_num = _playedTime_num + _video_arr[_currentIndex_uint].duration;
			} else {
				_playedTime_num = _playedTime_num + _video_arr[_currentIndex_uint].time;
			}
			if(_currentIndex_uint < _video_arr.length - 1) {
				_video_arr[_currentIndex_uint].video.visible = false;
				LogManager.msg("第" + _currentIndex_uint + "段结束！下段的错误状态是：" + _video_arr[_currentIndex_uint + 1].iserr + " 下载状态是：" + _video_arr[_currentIndex_uint + 1].download);
				this.changeNS(_currentIndex_uint,_currentIndex_uint + 1);
				_now_ns.seek(0);
				this.setSvdNextStream();
				_video_arr[_currentIndex_uint].video.visible = true;
				if(_video_arr[_currentIndex_uint].iserr) {
					dispatch(MediaEvent.RETRY_FAILED);
				} else {
					_now_ns.resume();
					LogManager.msg("第" + _currentIndex_uint + "段开始播放！");
				}
				this.downNewVideoInfo();
			} else {
				_finish_boo = true;
				this.stop();
			}
			_stopFlag_boo = false;
		}
		
		public function retry() : void {
			_video_arr[_currentIndex_uint].retryNum = this._retryNum;
			this.bbb();
		}
		
		public function retry2() : void {
			_startTime = getNSTime(_now_ns);
			this.bbb();
		}
		
		private function bbb() : void {
			clearTimeout(this._intervalRetry);
			_video_arr[_currentIndex_uint].iserr = false;
			_video_arr[_currentIndex_uint].ns.removeEventListener(NetStatusEvent.NET_STATUS,this.downLoadStreamStatus);
			if(_startTime > 0) {
				_video_arr[_currentIndex_uint].download = "part_loading";
			} else {
				_video_arr[_currentIndex_uint].download = "loading";
			}
			_video_arr[_currentIndex_uint].ns.play(_video_arr[_currentIndex_uint].flv + (_startTime > 0?"?start=" + _startTime:""));
			if((TvSohuAds.getInstance().startAd.hasAd) && TvSohuAds.getInstance().startAd.state == "playing" || _sysStatus_str == "4") {
				_video_arr[_currentIndex_uint].ns.pause();
			}
			dispatch(MediaEvent.CONNECTING);
		}
		
		override protected function onStatus(param1:NetStatusEvent) : void {
			var _loc3_:uint = 0;
			var _loc4_:uint = 0;
			var _loc5_:String = null;
			var _loc6_:Object = null;
			var _loc2_:TvSohuNetStream = _video_arr[_currentIndex_uint].ns;
			if(param1.info.code == "NetStream.Play.Stop" && Math.abs(getNSTime(_now_ns) - _video_arr[_currentIndex_uint].duration) > 1 && _sysStatus_str == "3") {
				if(!PlayerConfig.isLive) {
					_stopFlag_boo = false;
					_video_arr[_currentIndex_uint].ns.close();
					LogManager.msg("第" + _currentIndex_uint + "段Stop事件触发了(异常中断)！nstimeCeil:" + Math.ceil(getNSTime(_now_ns) * 10) + " durationFloor:" + Math.floor(_video_arr[_currentIndex_uint].duration * 10) + " getNSTime:" + getNSTime(_now_ns) + " stopflag:" + _stopFlag_boo + " " + getClipInfo(_currentIndex_uint));
					_video_arr[_currentIndex_uint].ns.addErrIp();
					if(_video_arr[_currentIndex_uint].retryNum == 0) {
						_video_arr[_currentIndex_uint].iserr = true;
						dispatch(MediaEvent.RETRY_FAILED);
						dispatch(MediaEvent.NOTFOUND);
						dispatch(MediaEvent.DRAG_END);
						PlayerConfig.allErrNo++;
						_loc2_.cdnNum++;
						this._qfStat.sendPQStat({
							"error":PlayerConfig.CDN_ERROR_NOTFOUND,
							"code":PlayerConfig.CDN_CODE,
							"split":_currentIndex_uint + 1,
							"dom":_loc2_.playUrl,
							"drag":_loc2_.dragTime,
							"allno":PlayerConfig.allErrNo,
							"errno":_loc2_.cdnNum + _loc2_.gslbNum,
							"cdnid":PlayerConfig.cdnId,
							"datarate":_video_arr[_currentIndex_uint].datarate,
							"isp2p":(_loc2_.hasP2P?1:0)
						});
						_video_arr[_currentIndex_uint].retryNum = -1;
					} else if(_video_arr[_currentIndex_uint].retryNum > 0) {
						_startTime = !PlayerConfig.isLive?getNSTime(_now_ns):0;
						_video_arr[_currentIndex_uint].iserr = false;
						_video_arr[_currentIndex_uint].retryNum--;
						this._owner.bbb();
					}
					
				}
			} else {
				if(_loc2_.dragTime != 0) {
					this._dragNum = _loc2_.dragTime;
				}
				switch(param1.info.code) {
					case "NetStream.Play.Start":
						_video_arr[_currentIndex_uint].isAbend = false;
						LogManager.msg("evt.info.code:" + param1.info.code + " _isStart:" + _isStart + " _currentIndex_uint:" + _currentIndex_uint);
						_startTime = 0;
						_loc2_.dragTime = 0;
						if(!_isStart) {
							_isStart = true;
							_timer.start();
							LogManager.msg("加载中...");
							dispatch(MediaEvent.START);
						}
						break;
					case "NetStream.Buffer.Empty":
						LogManager.msg("缓冲中(" + _currentIndex_uint + ")...nstimeCeil:" + Math.ceil(getNSTime(_now_ns) * 10) + " durationFloor:" + Math.floor(_video_arr[_currentIndex_uint].duration * 10) + " getNSTime:" + getNSTime(_now_ns) + " stopflag:" + _stopFlag_boo + " " + getClipInfo(_currentIndex_uint));
						if(!_isBufferFlush && _loc2_.bufferLength < _loc2_.bufferTime) {
							dispatch(MediaEvent.BUFFER_EMPTY);
						}
						break;
					case "NetStream.Buffer.Full":
						_isBufferFlush = false;
						_loc3_ = 0;
						while(_loc3_ < _video_arr.length) {
							if(_loc3_ != _currentIndex_uint) {
								_video_arr[_loc3_].video.visible = false;
							}
							_loc3_++;
						}
						this.setSvdNextStream();
						_video_arr[_currentIndex_uint].video.visible = true;
						LogManager.msg("播放中(" + _currentIndex_uint + ")...");
						LogManager.msg("NetStream.Buffer.Full");
						dispatch(MediaEvent.FULL);
						break;
					case "NetStream.Buffer.Flush":
						_isBufferFlush = true;
						break;
					case "NetStream.Play.Stop":
						LogManager.msg("第" + _currentIndex_uint + "段Stop事件触发了！nstimeCeil:" + Math.ceil(getNSTime(_now_ns) * 10) + " durationFloor:" + Math.floor(_video_arr[_currentIndex_uint].duration * 10) + " getNSTime:" + getNSTime(_now_ns) + " stopflag:" + _stopFlag_boo + " " + getClipInfo(_currentIndex_uint));
						if(_stopFlag_boo) {
							this.judgeStop();
						} else {
							_stopFlag_boo = true;
						}
						break;
					case "NetStream.Play.StreamNotFound":
						break;
					case "NetStream.Play.FileStructureInvalid":
						break;
					case "NetStream.Seek.Notify":
						_loc4_ = 0;
						while(_loc4_ < _video_arr.length) {
							if(_loc4_ != _currentIndex_uint) {
								_video_arr[_loc4_].video.visible = false;
							}
							_loc4_++;
						}
						_video_arr[_currentIndex_uint].video.visible = true;
						LogManager.msg("NetStream.Seek.Notify");
						dispatch(MediaEvent.SEEKED);
						break;
					case "NetStream.Seek.InvalidTime":
						LogManager.msg("Seek.InvalidTime");
						break;
					case "NetStream.Seek.Failed":
						LogManager.msg("Seek.Failed");
						break;
				}
			}
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
							"fbt":(getTimer() - this._fbt) / 1000,
							"isped":this._isped,
							"drag":this._dragNum,
							"allbufno":this._totBufferNum,
							"datarate":_video_arr[_currentIndex_uint].datarate,
							"isp2p":(_loc2_.hasP2P?1:0),
							"isdl":(_video_arr[_currentIndex_uint].download == "part_loaded" || _video_arr[_currentIndex_uint].download == "loaded"?"1":"0")
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
							"datarate":_video_arr[_currentIndex_uint].datarate,
							"isp2p":(_loc2_.hasP2P?1:0)
						});
						this._bufferSpend = 0;
					}
					if(!_played_boo) {
						this._fbt = getTimer();
					}
					break;
				case "NetStream.Play.StreamNotFound":
					_loc2_["clearCdnTimeout"]();
					_video_arr[_currentIndex_uint].ns.destroyLocation();
					LogManager.msg("第" + _currentIndex_uint + "段[视频]未找到！retryNum:" + _video_arr[_currentIndex_uint].retryNum);
					_video_arr[_currentIndex_uint].ns.addErrIp();
					if(_video_arr[_currentIndex_uint].retryNum == 0) {
						_video_arr[_currentIndex_uint].iserr = true;
						dispatch(MediaEvent.RETRY_FAILED);
						dispatch(MediaEvent.NOTFOUND);
						dispatch(MediaEvent.DRAG_END);
						PlayerConfig.allErrNo++;
						_loc2_.cdnNum++;
						this._qfStat.sendPQStat({
							"error":PlayerConfig.CDN_ERROR_NOTFOUND,
							"code":PlayerConfig.CDN_CODE,
							"split":_currentIndex_uint + 1,
							"dom":_loc2_.playUrl,
							"drag":_loc2_.dragTime,
							"allno":PlayerConfig.allErrNo,
							"errno":_loc2_.cdnNum + _loc2_.gslbNum,
							"cdnid":PlayerConfig.cdnId,
							"datarate":_video_arr[_currentIndex_uint].datarate,
							"isp2p":(_loc2_.hasP2P?1:0)
						});
						_video_arr[_currentIndex_uint].retryNum = -1;
					} else if(_video_arr[_currentIndex_uint].retryNum > 0) {
						_video_arr[_currentIndex_uint].iserr = false;
						_video_arr[_currentIndex_uint].retryNum--;
						_loc2_["setP2PTimeLimit"]();
						this._owner.bbb();
					}
					
					break;
				case "NetStream.Play.Failed":
					_loc2_["clearCdnTimeout"]();
					LogManager.msg("第" + _currentIndex_uint + "段[视频]加载失败！retryNum:" + _video_arr[_currentIndex_uint].retryNum);
					if(_video_arr[_currentIndex_uint].retryNum == 0) {
						_video_arr[_currentIndex_uint].iserr = true;
						dispatch(MediaEvent.RETRY_FAILED);
						dispatch(MediaEvent.NOTFOUND);
						dispatch(MediaEvent.DRAG_END);
						PlayerConfig.allErrNo++;
						_loc2_.cdnNum++;
						this._qfStat.sendPQStat({
							"error":PlayerConfig.CDN_ERROR_FAILED,
							"code":PlayerConfig.CDN_CODE,
							"split":_currentIndex_uint + 1,
							"dom":_loc2_.playUrl,
							"drag":_loc2_.dragTime,
							"allno":PlayerConfig.allErrNo,
							"errno":_loc2_.cdnNum + _loc2_.gslbNum,
							"cdnid":PlayerConfig.cdnId,
							"datarate":_video_arr[_currentIndex_uint].datarate,
							"isp2p":(_loc2_.hasP2P?1:0)
						});
						_video_arr[_currentIndex_uint].retryNum = -1;
					} else if(_video_arr[_currentIndex_uint].retryNum > 0) {
						_video_arr[_currentIndex_uint].iserr = false;
						_video_arr[_currentIndex_uint].retryNum--;
						_loc2_["setP2PTimeLimit"]();
						this._owner.bbb();
					}
					
					break;
				case "NetStream.Play.FileStructureInvalid":
					_loc2_["clearCdnTimeout"]();
					LogManager.msg("第" + _currentIndex_uint + "段[视频]文件结构无效！retryNum:" + _video_arr[_currentIndex_uint].retryNum);
					if(_video_arr[_currentIndex_uint].retryNum == 0) {
						_video_arr[_currentIndex_uint].iserr = true;
						dispatch(MediaEvent.RETRY_FAILED);
						dispatch(MediaEvent.NOTFOUND);
						dispatch(MediaEvent.DRAG_END);
						PlayerConfig.allErrNo++;
						_loc2_.cdnNum++;
						this._qfStat.sendPQStat({
							"error":PlayerConfig.CDN_ERROR_FILESTRUCTUREINVALID,
							"code":PlayerConfig.CDN_CODE,
							"split":_currentIndex_uint + 1,
							"dom":_loc2_.playUrl,
							"drag":_loc2_.dragTime,
							"allno":PlayerConfig.allErrNo,
							"errno":_loc2_.cdnNum + _loc2_.gslbNum,
							"cdnid":PlayerConfig.cdnId,
							"datarate":_video_arr[_currentIndex_uint].datarate,
							"isp2p":(_loc2_.hasP2P?1:0)
						});
						_video_arr[_currentIndex_uint].retryNum = -1;
					} else if(_video_arr[_currentIndex_uint].retryNum > 0) {
						_video_arr[_currentIndex_uint].iserr = false;
						_video_arr[_currentIndex_uint].retryNum--;
						_loc2_["setP2PTimeLimit"]();
						this._owner.bbb();
					}
					
					break;
				case "CDNTimeout":
					LogManager.msg("当前播放第" + _currentIndex_uint + "段[视频]CDN超时！retryNum:" + _video_arr[_currentIndex_uint].retryNum);
					_video_arr[_currentIndex_uint].ns.addErrIp();
					if(_video_arr[_currentIndex_uint].retryNum == 0) {
						_video_arr[_currentIndex_uint].iserr = true;
						dispatch(MediaEvent.RETRY_FAILED);
						dispatch(MediaEvent.NOTFOUND);
						dispatch(MediaEvent.DRAG_END);
						PlayerConfig.allErrNo++;
						_loc2_.cdnNum++;
						this._qfStat.sendPQStat({
							"error":PlayerConfig.CDN_ERROR_TIMEOUT,
							"code":PlayerConfig.CDN_CODE,
							"split":_currentIndex_uint + 1,
							"dom":_loc2_.playUrl,
							"drag":_loc2_.dragTime,
							"allno":PlayerConfig.allErrNo,
							"errno":_loc2_.cdnNum + _loc2_.gslbNum,
							"cdnid":PlayerConfig.cdnId,
							"datarate":_video_arr[_currentIndex_uint].datarate,
							"isp2p":(_loc2_.hasP2P?1:0)
						});
						_video_arr[_currentIndex_uint].retryNum = -1;
					} else if(_video_arr[_currentIndex_uint].retryNum > 0) {
						_video_arr[_currentIndex_uint].iserr = false;
						_video_arr[_currentIndex_uint].retryNum--;
						_loc2_["setP2PTimeLimit"]();
						this._owner.bbb();
					}
					
					break;
				case "GSLB.Failed":
					LogManager.msg("第" + _currentIndex_uint + "段[视频]调度失败！retryNum:" + _video_arr[_currentIndex_uint].retryNum + " reason:" + param1.info.reason);
					if(param1.info.reason == "overload") {
						dispatchEvent(new Event("live_overload"));
						return;
					}
					if(_video_arr[_currentIndex_uint].retryNum == 0) {
						_video_arr[_currentIndex_uint].iserr = true;
						_loc6_ = {
							"index":_currentIndex_uint,
							"reason":param1.info.reason
						};
						dispatch(MediaEvent.RETRY_FAILED);
						dispatch(MediaEvent.NOTFOUND,_loc6_);
						dispatch(MediaEvent.DRAG_END);
						PlayerConfig.all700ErrNo++;
						if(param1.info.reason == "timeout") {
							this._qfStat.sendPQStat({
								"error":PlayerConfig.GSLB_ERROR_TIMEOUT,
								"code":PlayerConfig.GSLB_CODE,
								"split":_currentIndex_uint + 1,
								"dom":PlayerConfig.gslbIp,
								"drag":_loc2_.dragTime,
								"allno":PlayerConfig.allErrNo,
								"all700no":PlayerConfig.all700ErrNo,
								"errno":_loc2_.gslbNum + _loc2_.cdnNum,
								"datarate":_video_arr[_currentIndex_uint].datarate
							});
						} else if(param1.info.reason == "ioerror") {
							this._qfStat.sendPQStat({
								"error":PlayerConfig.GSLB_ERROR_FAILED,
								"code":PlayerConfig.GSLB_CODE,
								"split":_currentIndex_uint + 1,
								"dom":PlayerConfig.gslbIp,
								"drag":_loc2_.dragTime,
								"allno":PlayerConfig.allErrNo,
								"all700no":PlayerConfig.all700ErrNo,
								"errno":_loc2_.gslbNum + _loc2_.cdnNum,
								"datarate":_video_arr[_currentIndex_uint].datarate
							});
						}
						
						_video_arr[_currentIndex_uint].retryNum = -1;
					} else if(_video_arr[_currentIndex_uint].retryNum > 0) {
						if(_video_arr[_currentIndex_uint].retryNum - 1 <= 1) {
							_video_arr[_currentIndex_uint].ns.changeGSLBIP = true;
						}
						_video_arr[_currentIndex_uint].iserr = false;
						_video_arr[_currentIndex_uint].retryNum--;
						this._owner.bbb();
					}
					
					break;
				case "GSLB.Success":
					_loc5_ = _video_arr[_currentIndex_uint].iserr?"2":"1";
					break;
				case "NetStream.Play.Start":
					_video_arr[_currentIndex_uint].isAbend = false;
					_loc2_["clearCdnTimeout"]();
					_video_arr[_currentIndex_uint].cdnuse = _loc2_.cdnuse;
					_video_arr[_currentIndex_uint].iserr = false;
					if((_video_arr[_currentIndex_uint].ns.isnp) && _video_arr[_currentIndex_uint].sendVV == false) {
						Utils.debug("*start*precur:" + this._previousIndex_int + "|" + _currentIndex_uint);
						this._qfStat.sendPQStat({
							"isClipsVV":true,
							"error":0,
							"code":PlayerConfig.CDN_CODE,
							"split":_currentIndex_uint + 1,
							"dom":_loc2_.playUrl,
							"drag":_loc2_.dragTime,
							"allno":PlayerConfig.allErrNo,
							"errno":_loc2_.cdnNum + _loc2_.gslbNum,
							"cdnid":PlayerConfig.cdnId,
							"cdnip":PlayerConfig.cdnIp,
							"datarate":_video_arr[_currentIndex_uint].datarate,
							"isp2p":(_loc2_.hasP2P?1:0)
						});
						_video_arr[_currentIndex_uint].ns.isnp = false;
						_video_arr[_currentIndex_uint].sendVV = true;
					}
					dispatchEvent(new Event("NS.Play.Start"));
					break;
				case "Webp2p.Rollback":
					this.webP2PRollback();
					break;
			}
		}
		
		private function downLoadStreamStatus(param1:NetStatusEvent) : void {
			var ns:TvSohuNetStream = null;
			var obj:Object = null;
			var evt:NetStatusEvent = param1;
			ns = _video_arr[_downloadIndex_uint].ns;
			switch(evt.info.code) {
				case "NetStream.Play.StreamNotFound":
					LogManager.msg("第" + _downloadIndex_uint + "段视频未找到！retryNum:" + _video_arr[_downloadIndex_uint].retryNum);
					ns["clearCdnTimeout"]();
					_video_arr[_downloadIndex_uint].ns.addErrIp();
					if(_video_arr[_downloadIndex_uint].retryNum == 0) {
						if(!_video_arr[_downloadIndex_uint].isSentQF) {
							_video_arr[_downloadIndex_uint].isSentQF = true;
							PlayerConfig.allErrNo++;
							ns.cdnNum++;
							this._qfStat.sendPQStat({
								"error":PlayerConfig.CDN_ERROR_NOTFOUND,
								"code":PlayerConfig.CDN_CODE,
								"split":_downloadIndex_uint + 1,
								"dom":ns.playUrl,
								"allno":PlayerConfig.allErrNo,
								"errno":ns.cdnNum + ns.gslbNum,
								"cdnid":PlayerConfig.cdnId,
								"datarate":_video_arr[_downloadIndex_uint].datarate,
								"isp2p":(ns.hasP2P?1:0)
							});
						}
						if(!(_currentIndex_uint == _downloadIndex_uint) && (lastoutBuffer)) {
							clearTimeout(this._intervalRetry);
							this._intervalRetry = setTimeout(function():void {
								LogManager.msg("第" + _downloadIndex_uint + "段视频10秒循环重试！");
								_video_arr[_downloadIndex_uint].iserr = false;
								ns["setP2PTimeLimit"]();
								ns.retry(_video_arr[_downloadIndex_uint].flv + (_startTime > 0?"?start=" + _startTime:""));
							},10000);
						} else {
							_video_arr[_downloadIndex_uint].iserr = true;
							dispatch(MediaEvent.DRAG_END);
							ns.removeEventListener(NetStatusEvent.NET_STATUS,this.downLoadStreamStatus);
							dispatch(MediaEvent.NOTFOUND);
							_video_arr[_downloadIndex_uint].retryNum = -1;
						}
					} else {
						_video_arr[_downloadIndex_uint].iserr = false;
						_video_arr[_downloadIndex_uint].retryNum--;
						ns["setP2PTimeLimit"]();
						ns.retry(_video_arr[_downloadIndex_uint].flv + (_startTime > 0?"?start=" + _startTime:""));
					}
					break;
				case "NetStream.Play.Start":
					_video_arr[_downloadIndex_uint].isAbend = false;
					clearTimeout(this._intervalRetry);
					ns["clearCdnTimeout"]();
					ns.dragTime = 0;
					_video_arr[_downloadIndex_uint].cdnuse = ns.cdnuse;
					_video_arr[_downloadIndex_uint].iserr = false;
					if((_video_arr[_downloadIndex_uint].ns.isnp) && _video_arr[_downloadIndex_uint].sendVV == false) {
						this._qfStat.sendPQStat({
							"isClipsVV":true,
							"error":0,
							"code":PlayerConfig.CDN_CODE,
							"split":_downloadIndex_uint + 1,
							"dom":ns.playUrl,
							"drag":ns.dragTime,
							"allno":PlayerConfig.allErrNo,
							"errno":ns.cdnNum + ns.gslbNum,
							"cdnid":PlayerConfig.cdnId,
							"cdnip":PlayerConfig.cdnIp,
							"datarate":_video_arr[_downloadIndex_uint].datarate,
							"isp2p":(ns.hasP2P?1:0)
						});
						_video_arr[_downloadIndex_uint].ns.isnp = false;
						_video_arr[_downloadIndex_uint].sendVV = true;
					}
					ns.removeEventListener(NetStatusEvent.NET_STATUS,this.downLoadStreamStatus);
					dispatchEvent(new Event("NS.Play.Start"));
					break;
				case "NetStream.Play.Failed":
					LogManager.msg("第" + _downloadIndex_uint + "段视频加载失败！retryNum:" + _video_arr[_downloadIndex_uint].retryNum);
					ns["clearCdnTimeout"]();
					if(_video_arr[_downloadIndex_uint].retryNum == 0) {
						if(!_video_arr[_downloadIndex_uint].isSentQF) {
							_video_arr[_downloadIndex_uint].isSentQF = true;
							PlayerConfig.allErrNo++;
							ns.cdnNum++;
							this._qfStat.sendPQStat({
								"error":PlayerConfig.CDN_ERROR_FAILED,
								"code":PlayerConfig.CDN_CODE,
								"split":_downloadIndex_uint + 1,
								"dom":ns.playUrl,
								"allno":PlayerConfig.allErrNo,
								"errno":ns.cdnNum + ns.gslbNum,
								"cdnid":PlayerConfig.cdnId,
								"datarate":_video_arr[_downloadIndex_uint].datarate,
								"isp2p":(ns.hasP2P?1:0)
							});
						}
						if(!(_currentIndex_uint == _downloadIndex_uint) && (lastoutBuffer)) {
							clearTimeout(this._intervalRetry);
							this._intervalRetry = setTimeout(function():void {
								LogManager.msg("第" + _downloadIndex_uint + "段视频10秒循环重试！");
								_video_arr[_downloadIndex_uint].iserr = false;
								ns["setP2PTimeLimit"]();
								ns.retry(_video_arr[_downloadIndex_uint].flv + (_startTime > 0?"?start=" + _startTime:""));
							},10000);
						} else {
							_video_arr[_downloadIndex_uint].iserr = true;
							dispatch(MediaEvent.DRAG_END);
							ns.removeEventListener(NetStatusEvent.NET_STATUS,this.downLoadStreamStatus);
							dispatch(MediaEvent.NOTFOUND);
							_video_arr[_downloadIndex_uint].retryNum = -1;
						}
					} else {
						_video_arr[_downloadIndex_uint].iserr = false;
						_video_arr[_downloadIndex_uint].retryNum--;
						ns["setP2PTimeLimit"]();
						ns.retry(_video_arr[_downloadIndex_uint].flv + (_startTime > 0?"?start=" + _startTime:""));
					}
					break;
				case "NetStream.Play.FileStructureInvalid":
					LogManager.msg("第" + _downloadIndex_uint + "段视频文件结构无效！retryNum:" + _video_arr[_downloadIndex_uint].retryNum);
					ns["clearCdnTimeout"]();
					if(_video_arr[_downloadIndex_uint].retryNum == 0) {
						if(!_video_arr[_downloadIndex_uint].isSentQF) {
							_video_arr[_downloadIndex_uint].isSentQF = true;
							PlayerConfig.allErrNo++;
							ns.cdnNum++;
							this._qfStat.sendPQStat({
								"error":PlayerConfig.CDN_ERROR_FILESTRUCTUREINVALID,
								"code":PlayerConfig.CDN_CODE,
								"split":_downloadIndex_uint + 1,
								"dom":ns.playUrl,
								"allno":PlayerConfig.allErrNo,
								"errno":ns.cdnNum + ns.gslbNum,
								"cdnid":PlayerConfig.cdnId,
								"datarate":_video_arr[_downloadIndex_uint].datarate,
								"isp2p":(ns.hasP2P?1:0)
							});
						}
						if(!(_currentIndex_uint == _downloadIndex_uint) && (lastoutBuffer)) {
							clearTimeout(this._intervalRetry);
							this._intervalRetry = setTimeout(function():void {
								LogManager.msg("第" + _downloadIndex_uint + "段视频10秒循环重试！");
								_video_arr[_downloadIndex_uint].iserr = false;
								ns["setP2PTimeLimit"]();
								ns.retry(_video_arr[_downloadIndex_uint].flv + (_startTime > 0?"?start=" + _startTime:""));
							},10000);
						} else {
							_video_arr[_downloadIndex_uint].iserr = true;
							dispatch(MediaEvent.DRAG_END);
							ns.removeEventListener(NetStatusEvent.NET_STATUS,this.downLoadStreamStatus);
							dispatch(MediaEvent.NOTFOUND);
							_video_arr[_downloadIndex_uint].retryNum = -1;
						}
					} else {
						_video_arr[_downloadIndex_uint].iserr = false;
						_video_arr[_downloadIndex_uint].retryNum--;
						ns["setP2PTimeLimit"]();
						ns.retry(_video_arr[_downloadIndex_uint].flv + (_startTime > 0?"?start=" + _startTime:""));
					}
					break;
				case "Load.abend":
					if(_currentIndex_uint != _downloadIndex_uint) {
						LogManager.msg("第" + _downloadIndex_uint + "段视频加载异常终止！laRetryNum:" + _video_arr[_downloadIndex_uint].laRetryNum);
						if(_video_arr[_downloadIndex_uint].laRetryNum == 0) {
							if(!(_currentIndex_uint == _downloadIndex_uint) && (lastoutBuffer)) {
								clearTimeout(this._intervalRetry);
								this._intervalRetry = setTimeout(function():void {
									LogManager.msg("第" + _downloadIndex_uint + "段视频10秒循环重试！");
									ns.removeEventListener(NetStatusEvent.NET_STATUS,downLoadStreamStatus);
									download(_downloadIndex_uint);
								},10000);
							}
						} else {
							_video_arr[_downloadIndex_uint].laRetryNum--;
							ns.removeEventListener(NetStatusEvent.NET_STATUS,this.downLoadStreamStatus);
							this.download(_downloadIndex_uint);
						}
					}
					break;
				case "CDNTimeout":
					LogManager.msg("预加载第" + _downloadIndex_uint + "段视频CDN超时！retryNum:" + _video_arr[_downloadIndex_uint].retryNum);
					if(_video_arr[_downloadIndex_uint].retryNum == 0) {
						if(!_video_arr[_downloadIndex_uint].isSentQF) {
							_video_arr[_downloadIndex_uint].isSentQF = true;
							PlayerConfig.allErrNo++;
							ns.cdnNum++;
							this._qfStat.sendPQStat({
								"error":PlayerConfig.CDN_ERROR_TIMEOUT,
								"code":PlayerConfig.CDN_CODE,
								"split":_downloadIndex_uint + 1,
								"dom":ns.playUrl,
								"allno":PlayerConfig.allErrNo,
								"errno":ns.cdnNum + ns.gslbNum,
								"cdnid":PlayerConfig.cdnId,
								"datarate":_video_arr[_downloadIndex_uint].datarate,
								"isp2p":(ns.hasP2P?1:0)
							});
						}
						if(!(_currentIndex_uint == _downloadIndex_uint) && (lastoutBuffer)) {
							clearTimeout(this._intervalRetry);
							this._intervalRetry = setTimeout(function():void {
								LogManager.msg("第" + _downloadIndex_uint + "段视频10秒循环重试！");
								_video_arr[_downloadIndex_uint].iserr = false;
								ns["setP2PTimeLimit"]();
								ns.retry(_video_arr[_downloadIndex_uint].flv + (_startTime > 0?"?start=" + _startTime:""));
							},10000);
						} else {
							_video_arr[_downloadIndex_uint].iserr = true;
							dispatch(MediaEvent.NOTFOUND);
							dispatch(MediaEvent.DRAG_END);
							_video_arr[_downloadIndex_uint].retryNum = -1;
						}
					} else {
						_video_arr[_downloadIndex_uint].iserr = false;
						_video_arr[_downloadIndex_uint].retryNum--;
						ns["setP2PTimeLimit"]();
						if(_downloadIndex_uint != _currentIndex_uint) {
							ns.retry(_video_arr[_downloadIndex_uint].flv + (_startTime > 0?"?start=" + _startTime:""));
						} else {
							this._owner.bbb();
						}
					}
					break;
				case "GSLB.Success":
					break;
				case "GSLB.Failed":
					LogManager.msg("第" + _downloadIndex_uint + "段视频调度失败！retryNum:" + _video_arr[_downloadIndex_uint].retryNum + " reason:" + evt.info.reason);
					if(_video_arr[_downloadIndex_uint].retryNum == 0) {
						_video_arr[_downloadIndex_uint].iserr = true;
						obj = {
							"index":_downloadIndex_uint,
							"reason":evt.info.reason
						};
						dispatch(MediaEvent.NOTFOUND,obj);
						dispatch(MediaEvent.DRAG_END);
						PlayerConfig.all700ErrNo++;
						if(evt.info.reason == "timeout") {
							this._qfStat.sendPQStat({
								"error":PlayerConfig.GSLB_ERROR_TIMEOUT,
								"code":PlayerConfig.GSLB_CODE,
								"split":_downloadIndex_uint + 1,
								"dom":PlayerConfig.gslbIp,
								"allno":PlayerConfig.allErrNo,
								"all700no":PlayerConfig.all700ErrNo,
								"errno":ns.gslbNum + ns.cdnNum,
								"datarate":_video_arr[_downloadIndex_uint].datarate
							});
						} else if(evt.info.reason == "ioerror") {
							this._qfStat.sendPQStat({
								"error":PlayerConfig.GSLB_ERROR_FAILED,
								"code":PlayerConfig.GSLB_CODE,
								"split":_downloadIndex_uint + 1,
								"dom":PlayerConfig.gslbIp,
								"allno":PlayerConfig.allErrNo,
								"all700no":PlayerConfig.all700ErrNo,
								"errno":ns.gslbNum + ns.cdnNum,
								"datarate":_video_arr[_downloadIndex_uint].datarate
							});
						}
						
						_video_arr[_downloadIndex_uint].retryNum = -1;
					} else {
						if(_video_arr[_downloadIndex_uint].retryNum - 1 <= 1) {
							_video_arr[_downloadIndex_uint].ns.changeGSLBIP = true;
						}
						_video_arr[_downloadIndex_uint].iserr = false;
						_video_arr[_downloadIndex_uint].retryNum--;
						ns.retry(_video_arr[_downloadIndex_uint].flv + (_startTime > 0?"?start=" + _startTime:""));
					}
					break;
				case "Webp2p.Rollback":
					this.webP2PRollback();
					break;
			}
		}
		
		private function downNewVideoInfo() : void {
			if((PlayerConfig.isLive) && (PlayerConfig.isP2PLive) && PlayerConfig.hashId[_downloadIndex_uint + 1] == undefined) {
				new URLLoaderUtil().load(10,function(param1:Object):void {
					var _loc2_:Object = null;
					var _loc3_:uint = 0;
					var _loc4_:String = null;
					if(param1.info == "success") {
						LogManager.msg("追加内容下载成功， 追加内容：" + param1.data);
						_loc2_ = new JSON().parse(param1.data);
						if(!(_loc2_ == null) && _loc2_.status == 1) {
							_loc3_ = 0;
							while(_loc3_ < _loc2_.clipsURL.length) {
								PlayerConfig.hashId.push(_loc2_.hc.shift());
								PlayerConfig.key.push(_loc2_.ck.shift());
								PlayerConfig.synUrl.push(_loc2_.su.shift());
								_loc4_ = _loc2_.clipsBytes.shift();
								PlayerConfig.fileSize.push(_loc4_);
								addClipItem(_loc2_.clipsURL.shift(),_loc2_.clipsDuration.shift(),_loc2_.clipsBytes.shift(),_video_arr.length);
								_loc3_++;
							}
						} else {
							LogManager.msg("无可追加内容：" + param1.data);
						}
					} else {
						LogManager.msg("追加内容下载失败，下载段号：" + _downloadIndex_uint + " 失败原因：" + param1.info);
					}
				},"http://live.tv.sohu.com/live/currSplit_json.jhtml?lid=" + PlayerConfig.vid + "&hashid=" + PlayerConfig.hashId[PlayerConfig.hashId.length - 1] + "&type=" + PlayerConfig.liveType + "&m=" + getTimer());
			}
		}
		
		private function addClipItem(param1:String, param2:String, param3:String, param4:uint) : void {
			var _loc5_:Boolean = _now_ns != null?_now_ns.is200:false;
			_video_arr.push({
				"flv":param1,
				"video":new Video(),
				"start":_vTotTime_num + 1,
				"end":_vTotTime_num + Number(param2),
				"download":"no",
				"ns":(PlayerConfig.isWebP2p?new PlayVODStream(_my_nc,_loc5_,true,param4):new TvSohuNetStream(_my_nc,_loc5_,true)),
				"time":Number(param2),
				"size":Number(param3),
				"iserr":false,
				"datastart":0,
				"dataend":0,
				"duration":Number(param2),
				"gotMetaData":false,
				"datarate":Math.floor(Number(param3) * 8 / 1024 / Number(param2)),
				"isnp":false,
				"sendVV":false,
				"retryNum":this._retryNum,
				"laRetryNum":3,
				"bytesTotal":0,
				"isSentQF":false,
				"isAbend":false
			});
			_vTotTime_num = _vTotTime_num + Number(param2);
			_fileSize_num = _fileSize_num + Number(param3);
			_video_arr[param4].video.smoothing = true;
			if(PlayerConfig.isWebP2p) {
				_video_arr[param4].ns.attachVideoToStream(_video_arr[param4].video);
			} else {
				_video_arr[param4].video.attachNetStream(_video_arr[param4].ns);
				_video_arr[param4].ns.clipNo = param4;
			}
			_video_arr[param4].ns.bufferTime = _buffer_num;
			_video_arr[param4].video.visible = false;
			_video_arr[param4].ns.client = _clientTem_obj;
			_video_c.addChild(_video_arr[param4].video);
			this._videoArr.push(_video_arr[param4].video);
			LogManager.msg("追加成功， 追加段号：" + param4);
		}
		
		override protected function checkLastoutBuffer() : void {
			if((PlayerConfig.isLive) && (PlayerConfig.isP2PLive)) {
				if((_video_arr[_downloadIndex_uint].download == "loaded" || _video_arr[_downloadIndex_uint].download == "part_loaded") && _downloadIndex_uint < _video_arr.length - 1 && !(PlayerConfig.hashId[_downloadIndex_uint + 1] == "")) {
					if(_video_arr[_downloadIndex_uint + 1].download == "no") {
						this.download(_downloadIndex_uint + 1);
					}
				}
			} else {
				super.checkLastoutBuffer();
			}
		}
		
		private function setPredictMode() : void {
			if((PlayerConfig.availableStvd) && !(PlayerConfig.recordSvdMode == 0)) {
				TvSohuVideo.predictMode = TvSohuVideo.STG_VIDEO_MODE;
				PlayerConfig.stvdInUse = true;
				_bg_spr.visible = false;
				this.changeStvWHXY();
				this.setSvdNextStream();
			} else {
				TvSohuVideo.predictMode = TvSohuVideo.VIDEO_MODE;
				PlayerConfig.stvdInUse = false;
				_bg_spr.visible = true;
			}
		}
		
		private function setSvdNextStream() : void {
			if((PlayerConfig.availableStvd) && !(PlayerConfig.recordSvdMode == 0)) {
				if(TvSohuVideo.predictMode == TvSohuVideo.STG_VIDEO_MODE) {
					if(PlayerConfig.isWebP2p) {
						_video_arr[_currentIndex_uint].ns.attachVideoToStream(_video_arr[_currentIndex_uint].video);
					} else {
						_video_arr[_currentIndex_uint].video.attachSvdCurStream(_video_arr[_currentIndex_uint].ns);
					}
					if(_currentIndex_uint < _video_arr.length - 1) {
						_video_arr[_currentIndex_uint].video.attachSvdNextStream(_video_arr[_currentIndex_uint + 1].ns);
					} else {
						_video_arr[_currentIndex_uint].video.attachSvdNextStream(null);
					}
				} else if(PlayerConfig.isWebP2p) {
					_video_arr[_currentIndex_uint].ns.attachVideoToStream(_video_arr[_currentIndex_uint].video);
				} else {
					_video_arr[_currentIndex_uint].video.attachNetStream(_now_ns);
				}
				
			}
		}
		
		public function toggleVideoMode() : void {
			PlayerConfig.recordSvdMode = -1;
			if((PlayerConfig.availableStvd) && !PlayerConfig.stvdInUse) {
				if(TvSohuVideo.predictMode == TvSohuVideo.VIDEO_MODE) {
					PlayerConfig.stvdInUse = true;
					TvSohuVideo.predictMode = TvSohuVideo.STG_VIDEO_MODE;
					_bg_spr.visible = false;
					this.changeStvWHXY();
				} else {
					PlayerConfig.stvdInUse = false;
					TvSohuVideo.predictMode = TvSohuVideo.VIDEO_MODE;
					_bg_spr.visible = true;
				}
			} else {
				TvSohuVideo.predictMode = TvSohuVideo.VIDEO_MODE;
				PlayerConfig.stvdInUse = false;
				_bg_spr.visible = true;
			}
			this.setSvdNextStream();
			_video_arr[_currentIndex_uint].video.visible = true;
		}
		
		private function saveSvdMode() : void {
			if(TvSohuVideo.predictMode == TvSohuVideo.STG_VIDEO_MODE && (PlayerConfig.stvdInUse)) {
				PlayerConfig.recordSvdMode = 1;
			} else if(TvSohuVideo.predictMode == TvSohuVideo.VIDEO_MODE && !PlayerConfig.stvdInUse) {
				PlayerConfig.recordSvdMode = 0;
			}
			
		}
		
		private function changeStvWHXY() : void {
			if((PlayerConfig.availableStvd) && (PlayerConfig.stvdInUse) && TvSohuVideo.predictMode == TvSohuVideo.STG_VIDEO_MODE && !(PlayerConfig.recordSvdMode == 0)) {
				TvSohuVideo.updateSvdWHXY(_video_c.width,_video_c.height,_video_c.x,_video_c.y);
			}
		}
		
		private function sendP2PStat(param1:String = "") : void {
			var p1:Number = NaN;
			var c1:Number = NaN;
			var p2pStatSender:URLLoaderUtil = null;
			var errType:String = param1;
			p1 = 0;
			c1 = 0;
			var num:Number = 0;
			p2pStatSender = new URLLoaderUtil();
			setInterval(function():void {
				var _loc4_:* = NaN;
				var _loc5_:* = NaN;
				var _loc6_:String = null;
				var _loc7_:String = null;
				var _loc8_:String = null;
				var _loc9_:String = null;
				var _loc1_:Number = 0;
				var _loc2_:Number = 0;
				var _loc3_:Number = 0;
				num++;
				try {
					if(!(XNetStreamVODFactory == null) && !(XNetStreamFactory.getClass("p2ptest.XNetStreamVOD")["TotalCDNDownloadValidBytes"] == null)) {
						_loc4_ = XNetStreamFactory.getClass("p2ptest.XNetStreamVOD")["TotalCDNDownloadValidBytes"];
						_loc5_ = XNetStreamFactory.getClass("p2ptest.XNetStreamVOD")["TotalP2PDownloadValidBytes"];
						_loc1_ = _loc4_ - _lastTimeCDNBytes;
						_loc2_ = _loc5_ - _lastTimePeerBytes;
						_loc1_ = _loc1_ < 0?0:_loc1_;
						_loc2_ = _loc2_ < 0?0:_loc2_;
						_loc3_ = _loc1_ + _loc2_;
						_lastTimeCDNBytes = _loc4_;
						_lastTimePeerBytes = _loc5_;
						p1 = p1 + _loc2_;
						c1 = c1 + _loc1_;
					}
				}
				catch(evt:*) {
				}
				if((PlayerConfig.isWebP2p) && (_loc1_ > 0 || _loc2_ > 0) && PlayerConfig.channel == "s") {
					if(errType != "") {
						_loc1_ = _loc2_ = 0;
					}
					_loc6_ = "";
					_loc7_ = String(PlayerConfig.catcode).substr(0,3);
					if(_loc7_ == "115" || _loc7_ == "106" || _loc7_ == "100") {
						_loc6_ = "&channelId=" + _loc7_;
					}
					_loc8_ = PlayerConfig.ta_jm != ""?"&ta=" + escape(PlayerConfig.ta_jm):"";
					_loc9_ = "http://pv.hd.sohu.com/p.gif?pid=" + PlayerConfig.pid + "&playlistid=" + PlayerConfig.vrsPlayListId + "&vid=" + PlayerConfig.currentVid + "&cateid=" + PlayerConfig.plcatid + "&c=" + _loc1_ + "&nid=" + PlayerConfig.channel + "&ua=yc" + "&t=" + _loc3_ + "&yid=" + PlayerConfig.yyid + "&cnt=" + "&uid=" + PlayerConfig.userId + _loc8_ + "&errType=" + errType + _loc6_ + "&url=" + PlayerConfig.currentPageUrl + "&n=" + new Date().getTime();
					p2pStatSender.send(_loc9_);
				}
			},30000);
		}
	}
}
