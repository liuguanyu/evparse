package com.sohu.tv.mediaplayer.video {
	import ebing.core.FlashCore;
	import flash.events.ProgressEvent;
	import ebing.utils.LogManager;
	import ebing.events.MediaEvent;
	import ebing.net.LoaderUtil;
	import flash.system.LoaderContext;
	import flash.utils.setInterval;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	import flash.utils.clearInterval;
	import flash.display.Loader;
	import flash.media.SoundTransform;
	
	public class TvSohuFlashCore extends FlashCore {
		
		public function TvSohuFlashCore(param1:Object) {
			if(param1.index != null) {
				this._id = param1.index;
			}
			if(param1.isPIPAd != null) {
				this._isPIPAd = param1.isPIPAd;
			}
			if(param1.isThirdAds != null) {
				this.thirdAdsMark = param1.isThirdAds;
			}
			super(param1);
		}
		
		private var _addChildId:Number = 0;
		
		private var _isVpaidAd:Boolean = false;
		
		private var _id:int = 0;
		
		private var _isPIPAd:Boolean = false;
		
		private var thirdAdsMark:String = "";
		
		override public function softInit(param1:Object) : void {
			this._isVpaidAd = false;
			if(param1.url.split("?path").length >= 2) {
				this._isVpaidAd = true;
			}
			super.softInit(param1);
		}
		
		override protected function swfProgressHnadler(param1:ProgressEvent) : void {
			super.swfProgressHnadler(param1);
		}
		
		override protected function swfHandler(param1:Object) : void {
			if(param1.info == "success") {
				_swf = param1.data;
				if(this._isPIPAd) {
					addChild(_swf);
					_bg_spr.visible = false;
					_sysStatus_str = "4";
					try {
						LogManager.msg("w666:" + _width_num + " h666:" + _height_num);
						_swf.content["resize"](_width_num,_height_num);
					}
					catch(e:Error) {
					}
				} else {
					try {
						_swf.content["init"](LogManager);
					}
					catch(e:Error) {
					}
					LogManager.msg("w:" + _width_num + " h:" + _height_num);
					dispatch(MediaEvent.START);
				}
			} else if(param1.info == "timeout") {
				dispatch(MediaEvent.CONNECT_TIMEOUT);
				_sysStatus_str = "5";
			} else {
				LogManager.msg("VPAIDDDDDDDDDDStatus:");
				dispatch(MediaEvent.NOTFOUND);
			}
			
		}
		
		public function swfPause() : void {
			super.pause();
		}
		
		public function swfStart() : void {
			super.play();
			if(_swf) {
				try {
					_swf.content["play"]();
				}
				catch(e:Error) {
				}
			}
		}
		
		public function swfStop() : void {
			if(_swf != null) {
				try {
					_swf.unloadAndStop(true);
					_swf = null;
				}
				catch(e:Error) {
				}
			}
		}
		
		public function loadSwf() : void {
			new LoaderUtil().load(_timeLimit,this.swfHandler,this.swfProgressHnadler,_url,new LoaderContext(this._isPIPAd));
		}
		
		override public function play(param1:* = null) : void {
			var evt:* = param1;
			if(_sysStatus_str == "5") {
				new LoaderUtil().load(_timeLimit,this.swfHandler,this.swfProgressHnadler,_url,new LoaderContext(this._isVpaidAd));
			}
			if(_sysStatus_str == "4") {
				this._addChildId = setInterval(function():void {
					if(_swf != null) {
						if(_isPIPAd) {
							_swf.content["playMc"]();
						} else {
							addChild(_swf);
						}
						if(_swf) {
							try {
								_swf.content["resize"](_width_num,_height_num);
							}
							catch(e:Error) {
								resize(_width_num,_height_num);
							}
							if(_isVpaidAd) {
								_swf.content.addEventListener("AD_ALL_OVER",closeFlash);
							}
							_swf.contentLoaderInfo.sharedEvents.addEventListener("allowDomain",function(param1:Event):void {
								dispatchEvent(new MouseEvent("allowFlash"));
							});
							_swf.contentLoaderInfo.sharedEvents.addEventListener("closeFlash",closeFlash);
							_swf.contentLoaderInfo.sharedEvents.addEventListener("ad_click",function(param1:Event):void {
								dispatchEvent(new MouseEvent("ad_click"));
							});
							_swf.contentLoaderInfo.sharedEvents.addEventListener("pauseFlash",function(param1:Event):void {
								dispatchEvent(new MouseEvent("pauseFlash"));
							});
							_swf.contentLoaderInfo.sharedEvents.addEventListener("resumeFlash",function(param1:Event):void {
								dispatchEvent(new MouseEvent("resumeFlash"));
							});
							try {
								_swf.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("callFlash"));
							}
							catch(e:Error) {
							}
						}
						_timer.start();
						_getTime = getTimer();
						clearInterval(_addChildId);
					}
				},20);
			}
			_sysStatus_str = "3";
			dispatch(MediaEvent.PLAY);
		}
		
		override public function resize(param1:Number, param2:Number) : void {
			_width_num = _bg_spr.width = param1;
			_height_num = _bg_spr.height = param2;
			if(this._isPIPAd) {
				_bg_spr.visible = false;
			}
			if(!this._isVpaidAd && !this._isPIPAd) {
				super.resize(param1,param2);
			}
			try {
				_swf.content["resize"](_width_num,_height_num);
			}
			catch(e:Error) {
			}
		}
		
		override public function pause(param1:* = null) : void {
			super.pause();
			if(_swf) {
				try {
					_swf.content["pause"]();
				}
				catch(e:Error) {
				}
			}
		}
		
		override protected function aboutTime(param1:Number) : void {
			if(!(this.thirdAdsMark == "") && this.thirdAdsMark == "2") {
				if(!(_swf == null) && _sysStatus_str == "3") {
					LogManager.msg("VPAIDLOGS11---adRemainingTime:" + _swf.content["adRemainingTime"]() + " adPlayedTime:" + _swf.content["adPlayedTime"]());
					if(!(_swf.content["adRemainingTime"]() == undefined) && !(_swf.content["adRemainingTime"]() == null)) {
						if(_swf.content["adRemainingTime"]() >= 0) {
							LogManager.msg("VPAIDLOGS---adRemainingTime:" + _swf.content["adRemainingTime"]());
							_filePlayedTime = _fileTotTime - _swf.content["adRemainingTime"]() * 1000;
							LogManager.msg("VPAIDLOGS---_filePlayedTime:" + _filePlayedTime);
							if(_filePlayedTime < 0) {
								LogManager.msg("我是大辉狼1");
								dispatch(MediaEvent.PLAY_ABEND,{
									"playedTime":_filePlayedTime / 1000,
									"totTime":_fileTotTime / 1000
								});
								this.stop("noevent");
							}
						}
					} else if(_swf.content["adPlayedTime"]() >= 0) {
						_filePlayedTime = _swf.content["adPlayedTime"]() * 1000;
					}
					
					dispatch(MediaEvent.PLAY_PROGRESS,{
						"nowTime":_filePlayedTime / 1000,
						"totTime":_fileTotTime / 1000
					});
				}
			} else {
				super.aboutTime(param1);
			}
		}
		
		private function closeFlash(param1:Event = null) : void {
			dispatchEvent(new MouseEvent("closeFlash"));
			param1.target.removeEventListener("closeFlash",this.closeFlash);
			this.stop();
		}
		
		override public function stop(param1:* = null) : void {
			var evt:* = param1;
			_timer.stop();
			_sysStatus_str = "5";
			if(evt != "noevent") {
				if(_finish_boo) {
					dispatch(MediaEvent.STOP,{"finish":true});
					_finish_boo = false;
				} else {
					dispatch(MediaEvent.STOP,{"finish":false});
				}
				try {
					_swf.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_closed"));
				}
				catch(e:Error) {
				}
			}
			if(_swf) {
				try {
					_swf.content["stopAd"]();
					_swf.content["stop"]();
				}
				catch(e:Error) {
				}
				_swf.contentLoaderInfo.sharedEvents.removeEventListener("allowDomain",function(param1:Event):void {
					dispatchEvent(new MouseEvent("allowFlash"));
				});
				_swf.contentLoaderInfo.sharedEvents.removeEventListener("closeFlash",this.closeFlash);
				_swf.contentLoaderInfo.sharedEvents.removeEventListener("ad_click",function(param1:Event):void {
					dispatchEvent(new MouseEvent("ad_click"));
				});
				_swf.contentLoaderInfo.sharedEvents.removeEventListener("pauseFlash",function(param1:Event):void {
					dispatchEvent(new MouseEvent("pauseFlash"));
				});
				_swf.contentLoaderInfo.sharedEvents.removeEventListener("resumeFlash",function(param1:Event):void {
					dispatchEvent(new MouseEvent("resumeFlash"));
				});
			}
			this.thirdAdsMark = "";
		}
		
		public function get streamState() : String {
			var _loc1_:String = null;
			switch(_sysStatus_str) {
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
		
		public function get swf() : Loader {
			return _swf;
		}
		
		public function get id() : int {
			return this._id;
		}
		
		override public function set volume(param1:Number) : void {
			super.volume = param1;
			if(_swf) {
				try {
					_swf.content["soundTransform"] = new SoundTransform(param1,0);
					_swf.content["setAdVolume"](param1);
				}
				catch(e:Error) {
				}
			}
		}
	}
}
