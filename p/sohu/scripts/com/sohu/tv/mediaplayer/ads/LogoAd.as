package com.sohu.tv.mediaplayer.ads {
	import flash.display.*;
	import com.sohu.tv.mediaplayer.stat.*;
	import ebing.net.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	import ebing.Utils;
	import com.sohu.tv.mediaplayer.PlayerConfig;
	import com.sohu.tv.mediaplayer.net.TvSohuURLLoaderUtil;
	
	public class LogoAd extends EventDispatcher {
		
		public function LogoAd() {
			super();
			this._flogoadSmallLoader = new Loader();
			this._flogoadBigLoader = new Loader();
			this._owner = this;
		}
		
		private var _flogoadSprite:Sprite;
		
		private var _flogoadSmallLoader:Loader;
		
		private var _flogoadBigLoader:Loader;
		
		private var _logoAdReady:Boolean;
		
		private var _flogoTimeout:Number = 0;
		
		private var _flogoTimeoutID:Number = 0;
		
		private var _loc_y:Number;
		
		private var _logoAdPlayed:Boolean;
		
		private var _adPath:String = "";
		
		private var _adDelay:String = "";
		
		private var _adInternal:String = "";
		
		private var _adPingback:String = "";
		
		private var _adClick:String = "";
		
		private var _owner:LogoAd;
		
		private var _width:Number = 0;
		
		private var _height:Number = 0;
		
		private var _container:Sprite;
		
		private var _state:String = "no";
		
		private var _flogoInternal:Number = 0;
		
		private var _adClicklayerflogo:Boolean = false;
		
		private var _hitAreSmall:Sprite;
		
		private var _hitAreBig:Sprite;
		
		private var _isSendAdPlayStock:Boolean = false;
		
		private var _adFirsttime:String = "";
		
		public function get container() : Sprite {
			return this._container;
		}
		
		public function set container(param1:Sprite) : void {
			this._container = param1;
		}
		
		public function softInit(param1:Object) : void {
			this._adPath = param1.adPar;
			this._adDelay = param1.adDelayPar;
			this._adInternal = !(param1.adIntervalPar == null) && !(param1.adIntervalPar == undefined) && !(param1.adIntervalPar == "undefined")?param1.adIntervalPar:"0";
			this._adClick = param1.adClick;
			this._adPingback = !(param1.adPingback == null) && !(param1.adPingback == undefined) && !(param1.adPingback == "undefined")?param1.adPingback:"";
			this._adClicklayerflogo = !(param1.adClicklayerflogo == null) && !(param1.adClicklayerflogo == undefined) && !(param1.adClicklayerflogo == "undefined") && !(param1.adClicklayerflogo == "") && (param1.adClicklayerflogo == "true" || param1.adClicklayerflogo == true)?true:false;
			this._adFirsttime = !(param1.adFirsttimePar == null) && !(param1.adFirsttimePar == undefined) && !(param1.adFirsttimePar == "undefined")?param1.adFirsttimePar:"0";
		}
		
		private function flogoadSmallCompleteHandler(param1:Event) : void {
			var evt:Event = param1;
			this._flogoadSprite.addChild(this._flogoadSmallLoader);
			this._flogoadSmallLoader.visible = false;
			this._hitAreSmall = new Sprite();
			Utils.drawRect(this._hitAreSmall,0,0,this._flogoadSmallLoader.contentLoaderInfo.width,this._flogoadSmallLoader.contentLoaderInfo.height,16711680,0);
			this._flogoadSprite.addChild(this._hitAreSmall);
			this._hitAreSmall.buttonMode = true;
			this._hitAreSmall.addEventListener(MouseEvent.CLICK,this.adClickHandler);
			this._hitAreSmall.visible = false;
			if(!this._adClicklayerflogo) {
				this._flogoadSmallLoader.contentLoaderInfo.sharedEvents.addEventListener("allowDomain",function(param1:Event):void {
					_flogoadSmallLoader.content["clickUrl"] = _adClick;
				});
				this._flogoadSmallLoader.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_click"));
			}
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
			this._hitAreBig = new Sprite();
			Utils.drawRect(this._hitAreBig,0,0,this._flogoadBigLoader.contentLoaderInfo.width,this._flogoadBigLoader.contentLoaderInfo.height,255,0);
			this._flogoadSprite.addChild(this._hitAreBig);
			this._hitAreBig.buttonMode = true;
			this._hitAreBig.addEventListener(MouseEvent.CLICK,this.adClickHandler);
			this._hitAreBig.visible = false;
			if(!this._adClicklayerflogo) {
				this._flogoadBigLoader.contentLoaderInfo.sharedEvents.addEventListener("allowDomain",function(param1:Event):void {
					_flogoadBigLoader.content["clickUrl"] = _adClick;
				});
				this._flogoadBigLoader.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_click"));
			}
			if(this._logoAdReady) {
				this.playLogoAdd();
			}
			this._logoAdReady = true;
		}
		
		private function adClickHandler(param1:MouseEvent) : void {
			if(this._adClick != "") {
				Utils.openWindow(this._adClick);
			}
		}
		
		private function flogoadBigErrorHandler(param1:IOErrorEvent) : void {
			this._flogoadBigLoader = null;
		}
		
		private function playLogoAd(... rest) : void {
			if(this._state == "playing") {
				if(!(this._flogoadSprite == null) && this._flogoadSprite.numChildren > 0) {
					if(this._container.stage.displayState == StageDisplayState.FULL_SCREEN || (PlayerConfig.isBrowserFullScreen)) {
						if(this._flogoadBigLoader != null) {
							this._flogoadBigLoader.visible = true;
						}
						this._hitAreBig.visible = this._adClicklayerflogo;
						if(this._flogoadSmallLoader != null) {
							this._flogoadSmallLoader.visible = this._hitAreSmall.visible = false;
						}
						this._flogoadBigLoader.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_show_jb"));
					} else {
						if(this._flogoadSmallLoader != null) {
							this._flogoadSmallLoader.visible = true;
						}
						this._hitAreSmall.visible = this._adClicklayerflogo;
						if(this._flogoadBigLoader != null) {
							this._flogoadBigLoader.visible = this._hitAreBig.visible = false;
						}
						this._flogoadSmallLoader.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_show_jb"));
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
				if(this._container.stage.displayState == StageDisplayState.FULL_SCREEN || (PlayerConfig.isBrowserFullScreen)) {
					if(this._flogoadSprite.visible == true) {
						if(this._flogoadBigLoader != null) {
							this._flogoadBigLoader.visible = true;
						}
						this._hitAreBig.visible = this._adClicklayerflogo;
						if(this._flogoadSmallLoader != null) {
							this._flogoadSmallLoader.visible = this._hitAreSmall.visible = false;
						}
					}
					_loc1_ = true;
				} else {
					if(this._flogoadSprite.visible == true) {
						if(this._flogoadBigLoader != null) {
							this._flogoadBigLoader.visible = this._hitAreBig.visible = false;
						}
						if(this._flogoadSmallLoader != null) {
							this._flogoadSmallLoader.visible = true;
						}
						this._hitAreSmall.visible = this._adClicklayerflogo;
					}
					_loc1_ = false;
				}
			}
			return _loc1_;
		}
		
		private function hideLogoAd() : void {
			this._flogoadSprite.visible = false;
			if(this._flogoTimeout > 0) {
				clearTimeout(this._flogoTimeoutID);
			}
			if(!(this._adInternal == "") && !(this._adInternal == "0")) {
				this._flogoInternal = setTimeout(this.loadAndPlayAd,Number(this._adInternal) * 1000);
			} else {
				this._flogoInternal = setTimeout(this.loadAndPlayAd,PlayerConfig.LOGOAD_DELAY * 1000);
			}
			dispatchEvent(new TvSohuAdsEvent(TvSohuAdsEvent.LOGOFINISH));
			this.destroy();
		}
		
		private function loadAndPlayAd() : void {
			var ptCode:RegExp = new RegExp("&pageUrl=");
			var url:String = TvSohuAds.getInstance().fetchAdsUrl;
			url = url.replace(ptCode,"&pt=flogo&pageUrl=");
			new URLLoaderUtil().load(10,function(param1:Object):void {
				var _loc2_:Object = null;
				var _loc3_:Object = null;
				clearTimeout(_flogoInternal);
				if(param1.info == "success") {
					_loc2_ = new JSON().parse(param1.data);
					if(_loc2_.status == 1) {
						_loc3_ = {
							"adPar":_loc2_.data.flogoad,
							"adClick":_loc2_.data.flogoclickurl,
							"adDelayPar":_loc2_.data.flogodelay,
							"adIntervalPar":_loc2_.data.flogointerval,
							"adPingback":_loc2_.data.flogopingback,
							"adClicklayerflogo":_loc2_.data.clicklayerflogo
						};
						softInit(_loc3_);
						play();
					} else {
						hideLogoAd();
					}
				} else {
					hideLogoAd();
				}
			},url + "&m=" + new Date().getTime());
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
						if(this._adDelay != "") {
							this._flogoTimeout = Number(this._adDelay) * 1000;
						} else {
							this._flogoTimeout = 10 * 1000;
						}
						if((this.checkUrl(_loc2_,"swf")) || (this.checkUrl(_loc2_,"jpg")) || (this.checkUrl(_loc2_,"gif")) || (this.checkUrl(_loc2_,"jpeg")) || (this.checkUrl(_loc2_,"SWF")) || (this.checkUrl(_loc2_,"JPG")) || (this.checkUrl(_loc2_,"GIF")) || (this.checkUrl(_loc2_,"JPEG"))) {
							this._flogoadSmallLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.flogoadSmallCompleteHandler);
							this._flogoadSmallLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.flogoadSmallErrorHandler);
							this._flogoadSmallLoader.load(new URLRequest(_loc2_));
						}
						if((this.checkUrl(_loc3_,"swf")) || (this.checkUrl(_loc3_,"jpg")) || (this.checkUrl(_loc3_,"gif")) || (this.checkUrl(_loc2_,"jpeg")) || (this.checkUrl(_loc3_,"SWF")) || (this.checkUrl(_loc3_,"JPG")) || (this.checkUrl(_loc3_,"GIF")) || (this.checkUrl(_loc2_,"JPEG"))) {
							this._flogoadBigLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.flogoadBigCompleteHandler);
							this._flogoadBigLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.flogoadBigErrorHandler);
							this._flogoadBigLoader.load(new URLRequest(_loc3_));
						}
					} else {
						this.hideLogoAd();
					}
				} else {
					this._flogoadSprite.visible = true;
					this._state = "playing";
				}
			}
		}
		
		public function pingback() : void {
			var _loc1_:String = null;
			var _loc2_:String = null;
			var _loc3_:String = null;
			if(!this._isSendAdPlayStock && !(this._adPingback == "")) {
				this._isSendAdPlayStock = true;
				_loc1_ = this._adPingback.split("?").length > 1?"&" + this._adPingback.split("?")[1]:"";
				_loc2_ = "";
				if(this._adPath.split("|")[0] != "") {
					_loc2_ = Utils.getType(this._adPath.split("|")[0],".");
				}
				_loc3_ = this._adPath != ""?"act":"na";
				InforSender.getInstance().sendCustomMesg("http://wl.hd.sohu.com/s.gif?prod=flash&systype=" + (PlayerConfig.isHotOrMy?"0":"1") + "&cid=" + PlayerConfig.catcode + "&log=" + _loc3_ + "&from=" + PlayerConfig.domainProperty + "&3th=0&adTime=0&adType=" + _loc2_ + "&dmpt=lad&po=b" + "&adUrl=" + (this._adPath != ""?escape(this._adPath):"") + _loc1_);
			}
			if(this._adPingback != "") {
				new TvSohuURLLoaderUtil().multiSend(this._adPingback);
			}
		}
		
		private function playLogoAdd() : void {
			if(this._state == "playing") {
				if(this._adPath != "") {
					if(!(this._adFirsttime == "") && !(this._adFirsttime == "0")) {
						setTimeout(this.playLogoAd,Number(this._adFirsttime) * 1000);
					} else {
						this.playLogoAd();
					}
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
			if(this._flogoadSprite != null) {
				this._flogoadSprite.visible = false;
			}
			clearTimeout(this._flogoInternal);
			if(this._flogoTimeout > 0) {
				clearTimeout(this._flogoTimeoutID);
			}
			this.destroy();
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
		
		private function destroy() : void {
			var _loc1_:uint = 0;
			var _loc2_:uint = 0;
			this._adPath = this._adFirsttime = this._adDelay = this._adInternal = this._adPingback = this._adClick = "";
			this._state = "no";
			this._logoAdReady = this._logoAdPlayed = false;
			this._isSendAdPlayStock = false;
			if(this._flogoadSprite != null) {
				_loc1_ = 0;
				while(_loc1_ < this._flogoadSprite.numChildren) {
					this._flogoadSprite.removeChildAt(0);
					_loc1_++;
				}
			}
			if(this._container != null) {
				_loc2_ = 0;
				while(_loc2_ < this._container.numChildren) {
					this._container.removeChildAt(0);
					_loc2_++;
				}
			}
		}
	}
}
