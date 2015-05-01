package com.sohu.tv.mediaplayer.ads {
	import flash.display.*;
	import ebing.net.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	import com.sohu.tv.mediaplayer.PlayerConfig;
	import com.sohu.tv.mediaplayer.net.TvSohuURLLoaderUtil;
	import ebing.Utils;
	
	public class TopAd extends EventDispatcher {
		
		public function TopAd() {
			super();
			this._bg = new Sprite();
			Utils.drawRect(this._bg,0,0,1,1,0,1);
		}
		
		private var _ftitleadLoader:Loader;
		
		private var _ftitleTimeout:Number = 0;
		
		private var _ftitleTimeoutID:Number = 0;
		
		private var _ftitleDelay:Number = 0;
		
		private var _adPath:String = "";
		
		private var _adDelay:String = "";
		
		private var _adPingback:String = "";
		
		private var _adClick:String = "";
		
		private var _title_ad_first_display_time:Number = 0;
		
		private var _ftitleadTimer:Timer;
		
		private var _container:Sprite;
		
		protected var _state:String = "no";
		
		private var _bg:Sprite;
		
		private var _width:Number = 0;
		
		private var _height:Number = 0;
		
		public function softInit(param1:Object) : void {
			this._adPath = param1.adPar;
			this._adDelay = param1.adDelayPar;
			this._adClick = param1.adClick;
			this._adPingback = (!(param1.adPingback == null) && !(param1.adPingback == undefined) && !(param1.adPingback == "undefined")) != null?param1.adPingback:"";
		}
		
		public function get container() : Sprite {
			return this._container;
		}
		
		public function set container(param1:Sprite) : void {
			this._container = param1;
		}
		
		private function playTitleAd(... rest) : void {
			if(this._state == "playing") {
				this.resizeTitleAd();
				if(this._container.stage.displayState == StageDisplayState.FULL_SCREEN || (PlayerConfig.isBrowserFullScreen)) {
					if(this._ftitleadLoader != null) {
						this._ftitleadLoader.visible = true;
						this._ftitleadLoader.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_show_st"));
						if(this._ftitleTimeout > 0) {
							this._ftitleTimeoutID = setTimeout(this.hideTitleAd,this._ftitleTimeout);
						}
						this.pingback();
					}
				} else if(this._ftitleadLoader != null) {
					this._ftitleadLoader.visible = false;
				}
				
				dispatchEvent(new TvSohuAdsEvent(TvSohuAdsEvent.TOPSHOWN));
			}
		}
		
		private function hideTitleAd() : void {
			if(this._ftitleadLoader != null) {
				this._ftitleadLoader.visible = false;
			}
		}
		
		private function resizeTitleAd() : void {
			if(this._ftitleadLoader != null) {
				if(this._ftitleTimeoutID != 0) {
					clearTimeout(this._ftitleTimeoutID);
				}
				if(this._container.stage.displayState == StageDisplayState.FULL_SCREEN || (PlayerConfig.isBrowserFullScreen)) {
					if(this._ftitleDelay == 0 && this._ftitleTimeout == 0) {
						this._ftitleadLoader.visible = true;
					}
				} else {
					this._ftitleadLoader.visible = false;
				}
				if(this._container.contains(this._ftitleadLoader)) {
					this._container.setChildIndex(this._ftitleadLoader,this._container.numChildren - 1);
				}
			}
		}
		
		private function ftitleCompleteHandler(param1:Event) : void {
			var evt:Event = param1;
			this._container.addChild(this._bg);
			this._container.addChild(this._ftitleadLoader);
			this._ftitleadLoader.visible = false;
			this._ftitleadLoader.contentLoaderInfo.sharedEvents.addEventListener("allowDomain",function(param1:Event):void {
				_ftitleadLoader.content["clickUrl"] = _adClick;
			});
			this._ftitleadLoader.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_click"));
			this.beginAd();
		}
		
		private function ftitleErrorHandler(param1:IOErrorEvent) : void {
			this._ftitleadLoader = null;
		}
		
		public function play() : void {
			var _loc1_:Array = null;
			if(this._adPath != "") {
				if(this._state == "no") {
					this._state = "playing";
					_loc1_ = this._adDelay.split(",");
					if(this._adDelay == "") {
						this._ftitleDelay = 0;
						this._ftitleTimeout = 0;
					} else if(_loc1_.length == 1) {
						this._ftitleDelay = (Number(_loc1_[0]) * 60000) || (15 * 60000);
						this._ftitleTimeout = 8 * 1000;
					} else if(_loc1_.length == 2) {
						this._ftitleDelay = (Number(_loc1_[0]) * 60000) || (15 * 60000);
						this._ftitleTimeout = (Number(_loc1_[1]) * 1000) || (8 * 1000);
					} else if(_loc1_.length == 3) {
						this._ftitleDelay = (Number(_loc1_[0]) * 60000) || (15 * 60000);
						this._ftitleTimeout = (Number(_loc1_[1]) * 1000) || (8 * 1000);
						this._title_ad_first_display_time = (Number(_loc1_[2]) * 60000) || (3 * 60000);
					}
					
					
					
					if((this.checkUrl(this._adPath,"swf")) || (this.checkUrl(this._adPath,"jpg")) || (this.checkUrl(this._adPath,"gif")) || (this.checkUrl(this._adPath,"jpeg"))) {
						this._ftitleadLoader = new Loader();
						this._ftitleadLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.ftitleCompleteHandler);
						this._ftitleadLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.ftitleErrorHandler);
						this._ftitleadLoader.load(new URLRequest(this._adPath));
					}
				} else {
					this._container.visible = true;
					this._state = "playing";
				}
			}
		}
		
		public function pingback() : void {
			if(this._adPingback != "") {
				new TvSohuURLLoaderUtil().multiSend(this._adPingback);
			}
		}
		
		public function close() : void {
			this._container.visible = false;
			this._state = "end";
		}
		
		public function get state() : String {
			return this._state;
		}
		
		private function beginAd() : void {
			if(this._adPath != "") {
				if(this._ftitleDelay > 0 && this._ftitleTimeout > 0) {
					this._ftitleadTimer = new Timer(this._ftitleDelay,0);
					this._ftitleadTimer.addEventListener(TimerEvent.TIMER,this.playTitleAd);
					setTimeout(this.runTitleAd,this._title_ad_first_display_time);
				} else {
					this.playTitleAd();
				}
			}
		}
		
		private function runTitleAd() : void {
			if(this._state == "playing") {
				this._ftitleadTimer.start();
				this.playTitleAd();
			}
		}
		
		public function get hasAd() : Boolean {
			return this._adPath == ""?false:true;
		}
		
		public function resize(param1:Number, param2:Number) : void {
			var w:Number = param1;
			var h:Number = param2;
			this._width = this._bg.width = w < 0?0:w;
			this._height = this._bg.height = h < 0?0:h;
			try {
				if(this._ftitleadLoader != null) {
					this._ftitleadLoader.x = Math.round(w - this._ftitleadLoader.contentLoaderInfo.width) / 2;
					this._ftitleadLoader.y = 0;
				}
				if(this._container.stage.displayState == StageDisplayState.FULL_SCREEN || (PlayerConfig.isBrowserFullScreen)) {
					this._container.visible = true;
				} else {
					this._container.visible = false;
				}
			}
			catch(evt:*) {
			}
		}
		
		private function checkUrl(param1:String, param2:String) : Boolean {
			if(param1 == "") {
				return false;
			}
			var _loc3_:Number = param1.length;
			var _loc4_:Number = param2.length;
			return param1.substring(_loc3_ - _loc4_ - 1) == "." + param2;
		}
	}
}
