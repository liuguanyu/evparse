package com.sohu.tv.mediaplayer.ads {
	import flash.display.*;
	import ebing.net.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	import com.sohu.tv.mediaplayer.PlayerConfig;
	import com.sohu.tv.mediaplayer.net.TvSohuURLLoaderUtil;
	import ebing.Utils;
	
	public class TopLogoAd extends EventDispatcher {
		
		public function TopLogoAd() {
			super();
			this._flogoadSmallLoader = new Loader();
			this._flogoadBigLoader = new Loader();
			this._owner = this;
		}
		
		private var _flogoadSprite:Sprite;
		
		private var _flogoadSmallLoader:Loader;
		
		private var _flogoadBigLoader:Loader;
		
		private var _logoAdReady:Boolean;
		
		private var _flogoadTimer:Timer;
		
		private var _flogoTimeout:Number = 0;
		
		private var _flogoTimeoutID:Number = 0;
		
		private var _loc_y:Number;
		
		private var _logoAdPlayed:Boolean;
		
		private var _flogoDelay:Number = 0;
		
		private var _logo_ad_first_display_time:Number = 0;
		
		private var _adPath:String = "";
		
		private var _adDelay:String = "";
		
		private var _adPingback:String = "";
		
		private var _adClick:String = "";
		
		private var _owner:TopLogoAd;
		
		private var _width:Number = 0;
		
		private var _height:Number = 0;
		
		private var _container:Sprite;
		
		private var _state:String = "no";
		
		public function get container() : Sprite {
			return this._container;
		}
		
		public function set container(param1:Sprite) : void {
			this._container = param1;
		}
		
		public function softInit(param1:Object) : void {
			this._adPath = param1.adPar;
			this._adDelay = param1.adDelayPar;
			this._adClick = param1.adClick;
			this._adPingback = !(param1.adPingback == null) && !(param1.adPingback == undefined) && !(param1.adPingback == "undefined")?param1.adPingback:"";
		}
		
		private function flogoadSmallCompleteHandler(param1:Event) : void {
			var evt:Event = param1;
			this._flogoadSprite.addChild(this._flogoadSmallLoader);
			this._flogoadSmallLoader.visible = false;
			this._flogoadSmallLoader.contentLoaderInfo.sharedEvents.addEventListener("allowDomain",function(param1:Event):void {
				_flogoadSmallLoader.content["clickUrl"] = _adClick;
			});
			this._flogoadSmallLoader.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_click"));
			if(this._logoAdReady) {
				this.playLogoAdd();
			}
			this._logoAdReady = true;
		}
		
		private function flogoadSmallErrorHandler(param1:IOErrorEvent) : void {
			this._flogoadSmallLoader = null;
		}
		
		private function flogoadBigCompleteHandler(param1:Event) : void {
			var evt:Event = param1;
			this._flogoadSprite.addChild(this._flogoadBigLoader);
			this._flogoadBigLoader.visible = false;
			this._flogoadBigLoader.contentLoaderInfo.sharedEvents.addEventListener("allowDomain",function(param1:Event):void {
				_flogoadBigLoader.content["clickUrl"] = _adClick;
			});
			this._flogoadBigLoader.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_click"));
			if(this._logoAdReady) {
				this.playLogoAdd();
			}
			this._logoAdReady = true;
		}
		
		private function flogoadBigErrorHandler(param1:IOErrorEvent) : void {
			this._flogoadBigLoader = null;
		}
		
		private function runLogoAd() : void {
			if(this._state == "playing") {
				this._flogoadTimer.start();
				this.playLogoAd();
			}
		}
		
		private function playLogoAd(... rest) : void {
			if(this._state == "playing") {
				if(!(this._flogoadSprite == null) && this._flogoadSprite.numChildren > 0) {
					if(this._container.stage.displayState == StageDisplayState.FULL_SCREEN || (PlayerConfig.isBrowserFullScreen)) {
						if(this._flogoadBigLoader != null) {
							this._flogoadBigLoader.visible = true;
						}
						if(this._flogoadSmallLoader != null) {
							this._flogoadSmallLoader.visible = false;
						}
						this._flogoadBigLoader.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_show_sx"));
					} else {
						if(this._flogoadSmallLoader != null) {
							this._flogoadSmallLoader.visible = true;
						}
						if(this._flogoadBigLoader != null) {
							this._flogoadBigLoader.visible = false;
						}
						this._flogoadSmallLoader.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_show_sx"));
					}
					this._flogoadSprite.visible = true;
					this.pingback();
					if(this._flogoTimeout > 0) {
						this._flogoTimeoutID = setTimeout(this.hideLogoAd,this._flogoTimeout);
					}
				}
			}
		}
		
		public function changeAd() : Boolean {
			var _loc1_:* = false;
			if(!(this._flogoadSprite == null) && this._flogoadSprite.numChildren > 0) {
				_loc1_ = false;
				if(this._container.stage.displayState == StageDisplayState.FULL_SCREEN || (PlayerConfig.isBrowserFullScreen)) {
					if(this._flogoadSprite.visible == true) {
						if(this._flogoadBigLoader != null) {
							this._flogoadBigLoader.visible = true;
						}
						if(this._flogoadSmallLoader != null) {
							this._flogoadSmallLoader.visible = false;
						}
					}
					_loc1_ = true;
				} else {
					if(this._flogoadSprite.visible == true) {
						if(this._flogoadBigLoader != null) {
							this._flogoadBigLoader.visible = false;
						}
						if(this._flogoadSmallLoader != null) {
							this._flogoadSmallLoader.visible = true;
						}
					}
					_loc1_ = false;
				}
			}
			return _loc1_;
		}
		
		private function hideLogoAd() : void {
			this._flogoadSprite.visible = false;
		}
		
		private function showLogoAd() : void {
			if(this._flogoadSprite != null) {
				this._flogoadSprite.visible = true;
			}
		}
		
		public function play() : void {
			var _loc1_:Array = null;
			var _loc2_:String = null;
			var _loc3_:String = null;
			var _loc4_:Array = null;
			if(!this._logoAdPlayed) {
				this._logoAdPlayed = true;
				if(this._state == "no") {
					this._state = "playing";
					this._flogoadSprite = new Sprite();
					this._flogoadSprite.visible = false;
					this._container.addChild(this._flogoadSprite);
					if(this._adPath != "") {
						_loc1_ = this._adPath.split("|");
						_loc2_ = _loc1_[0] || "";
						_loc3_ = _loc1_[1] || "";
						_loc4_ = this._adDelay.split(",");
						if(this._adDelay == "") {
							this._flogoDelay = 0;
							this._flogoTimeout = 0;
						} else if(_loc4_.length == 1) {
							this._flogoDelay = (Number(_loc4_[0]) * 60000) || (15 * 60000);
							this._flogoTimeout = 8 * 1000;
						} else if(_loc4_.length == 2) {
							this._flogoDelay = (Number(_loc4_[0]) * 60000) || (15 * 60000);
							this._flogoTimeout = (Number(_loc4_[1]) * 1000) || (8 * 1000);
						} else if(_loc4_.length == 3) {
							this._flogoDelay = (Number(_loc4_[0]) * 60000) || (15 * 60000);
							this._flogoTimeout = (Number(_loc4_[1]) * 1000) || (8 * 1000);
							this._logo_ad_first_display_time = (Number(_loc4_[2]) * 60000) || (3 * 60000);
						}
						
						
						
						if((this.checkUrl(_loc2_,"swf")) || (this.checkUrl(_loc2_,"jpg")) || (this.checkUrl(_loc2_,"gif")) || (this.checkUrl(_loc2_,"jpeg"))) {
							this._flogoadSmallLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.flogoadSmallCompleteHandler);
							this._flogoadSmallLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.flogoadSmallErrorHandler);
							this._flogoadSmallLoader.load(new URLRequest(_loc2_));
						}
						if((this.checkUrl(_loc3_,"swf")) || (this.checkUrl(_loc3_,"jpg")) || (this.checkUrl(_loc3_,"gif")) || (this.checkUrl(_loc2_,"jpeg"))) {
							this._flogoadBigLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.flogoadBigCompleteHandler);
							this._flogoadBigLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.flogoadBigErrorHandler);
							this._flogoadBigLoader.load(new URLRequest(_loc3_));
						}
					}
				} else {
					this._flogoadSprite.visible = true;
					this._state = "playing";
				}
			}
		}
		
		public function pingback() : void {
			if(this._adPingback != "") {
				new TvSohuURLLoaderUtil().multiSend(this._adPingback);
			}
		}
		
		private function playLogoAdd() : void {
			if(this._state == "playing") {
				if(this._adPath != "") {
					Utils.debug("_tlogoDelay:" + this._flogoDelay + " _tlogoTimeout:" + " _logo_ad_first_display_time:" + this._logo_ad_first_display_time);
					if(this._flogoDelay > 0 && this._flogoTimeout > 0) {
						this._flogoadTimer = new Timer(this._flogoDelay,0);
						this._flogoadTimer.addEventListener(TimerEvent.TIMER,this.playLogoAd);
						setTimeout(this.runLogoAd,this._logo_ad_first_display_time);
					} else {
						this.playLogoAd();
					}
					Utils.debug("wwwwwwwwwwwwwwwwww:" + this.width + " hhhhhhhhhhhhhhhhhhhhhhh:" + this.height);
					dispatchEvent(new TvSohuAdsEvent(TvSohuAdsEvent.LOGOSHOWN));
				}
			}
		}
		
		public function get hasAd() : Boolean {
			if(this._adPath != "") {
				return true;
			}
			return false;
		}
		
		private function checkUrl(param1:String, param2:String) : Boolean {
			if(param1 == "") {
				return false;
			}
			var _loc3_:Number = param1.length;
			var _loc4_:Number = param2.length;
			return param1.substring(_loc3_ - _loc4_ - 1) == "." + param2;
		}
		
		public function close() : void {
			this._flogoadSprite.visible = false;
			this._state = "end";
		}
		
		public function get width() : Number {
			try {
				if(!(this._container.stage == null) && (this._container.stage.displayState == StageDisplayState.FULL_SCREEN || (PlayerConfig.isBrowserFullScreen))) {
					if(this._flogoadBigLoader.contentLoaderInfo != null) {
						this._width = this._flogoadBigLoader.contentLoaderInfo.width;
					}
				} else if(this._flogoadSmallLoader.contentLoaderInfo != null) {
					this._width = this._flogoadSmallLoader.contentLoaderInfo.width;
				}
				
			}
			catch(evt:*) {
			}
			return this._width;
		}
		
		public function get height() : Number {
			try {
				if(!(this._container.stage == null) && (this._container.stage.displayState == StageDisplayState.FULL_SCREEN || (PlayerConfig.isBrowserFullScreen))) {
					if(this._flogoadBigLoader.contentLoaderInfo != null) {
						this._height = this._flogoadBigLoader.contentLoaderInfo.height;
					}
				} else if(this._flogoadSmallLoader.contentLoaderInfo != null) {
					this._height = this._flogoadSmallLoader.contentLoaderInfo.height;
				}
				
			}
			catch(evt:*) {
			}
			return this._height;
		}
	}
}
