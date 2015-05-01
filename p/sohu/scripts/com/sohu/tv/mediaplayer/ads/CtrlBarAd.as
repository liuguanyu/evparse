package com.sohu.tv.mediaplayer.ads {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import com.sohu.tv.mediaplayer.stat.*;
	import ebing.net.*;
	import flash.events.*;
	import ebing.Utils;
	import com.sohu.tv.mediaplayer.PlayerConfig;
	import com.sohu.tv.mediaplayer.net.TvSohuURLLoaderUtil;
	import flash.display.Loader;
	
	public class CtrlBarAd extends EventDispatcher {
		
		public function CtrlBarAd() {
			super();
			this._normalAdMask = new Sprite();
			this._normalAd_c = new Sprite();
			this._fullAd_c = new Sprite();
			this._fullAdMask = new Sprite();
			Utils.drawRect(this._normalAdMask,0,0,280,20,0,1);
			Utils.drawRect(this._fullAdMask,0,0,420,20,0,1);
		}
		
		private var _adPath:String = "";
		
		private var _adContent:DisplayObject;
		
		private var _state:String = "no";
		
		private var _width:Number = 0;
		
		private var _height:Number = 0;
		
		private var _showPause:Boolean;
		
		private var _container:Sprite;
		
		private var _normalAdMask:Sprite;
		
		private var _fullAdMask:Sprite;
		
		private var _normalAdPath:String = "";
		
		private var _fullAdPath:String = "";
		
		private var _adPingback:String = "";
		
		private var _adClick:String = "";
		
		private var _normalAd_c:Sprite;
		
		private var _fullAd_c:Sprite;
		
		private var _isReady:Boolean = false;
		
		private var _adClicklayerfbar:Boolean = false;
		
		private var _fullAdHitAre:Sprite;
		
		private var _normalAdHitAre:Sprite;
		
		private var _isSendAdPlayStock:Boolean = false;
		
		public function get container() : Sprite {
			return this._container;
		}
		
		public function set container(param1:Sprite) : void {
			this._container = param1;
		}
		
		public function softInit(param1:Object) : void {
			this._adPath = param1.adPar;
			var _loc2_:Array = this._adPath.split("|");
			this._normalAdPath = _loc2_[0];
			this._fullAdPath = _loc2_.length > 1?_loc2_[1]:"";
			this._adClick = param1.adClick;
			this._adPingback = !(param1.adPingback == null) && !(param1.adPingback == undefined) && !(param1.adPingback == "undefined")?param1.adPingback:"";
			this._adClicklayerfbar = !(param1.adClicklayerfbar == null) && !(param1.adClicklayerfbar == undefined) && !(param1.adClicklayerfbar == "undefined") && !(param1.adClicklayerfbar == "") && (param1.adClicklayerfbar == true || param1.adClicklayerfbar == "true")?true:false;
		}
		
		public function play() : void {
			if(this._adContent == null && !(this._adPath == "")) {
				if(this._state == "no") {
					this.loadNormalAd();
					this.loadFullAd();
					this._state = "loading";
					this.pingback();
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
				if(this._normalAdPath != "") {
					_loc2_ = Utils.getType(this._normalAdPath,".");
				}
				_loc3_ = this._adPath != ""?"act":"na";
				InforSender.getInstance().sendCustomMesg("http://wl.hd.sohu.com/s.gif?prod=flash&systype=" + (PlayerConfig.isHotOrMy?"0":"1") + "&cid=" + PlayerConfig.catcode + "&log=" + _loc3_ + "&from=" + PlayerConfig.domainProperty + "&3th=0&adTime=0&adType=" + _loc2_ + "&dmpt=cad&po=b" + "&adUrl=" + (this._adPath != ""?escape(this._adPath):"") + _loc1_);
			}
			if(this._adPingback != "") {
				new TvSohuURLLoaderUtil().multiSend(this._adPingback);
				this._adPingback = "";
			}
		}
		
		private function loadNormalAd() : void {
			if(this._normalAdPath != "") {
				new LoaderUtil().load(20,function(param1:Object):void {
					var obj:Object = param1;
					if(obj.info == "success") {
						obj.data.contentLoaderInfo.sharedEvents.addEventListener("allowDomain",function(param1:Event):void {
							obj.data.content["clickUrl"] = _adClick;
						});
						obj.data.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_click"));
						_normalAd_c.addChild(obj.data);
						if(!(_container.stage.displayState == "fullScreen") && !PlayerConfig.isBrowserFullScreen || _fullAdPath == "") {
							_width = obj.data.contentLoaderInfo.width;
							_height = obj.data.contentLoaderInfo.height;
						}
						_normalAdHitAre = new Sprite();
						Utils.drawRect(_normalAdHitAre,0,0,obj.data.contentLoaderInfo.width,_height = obj.data.contentLoaderInfo.height,65280,0);
						_normalAdHitAre.buttonMode = true;
						_normalAdHitAre.addEventListener(MouseEvent.CLICK,adClickHandler);
						_normalAdHitAre.visible = false;
						_normalAd_c.addChild(_normalAdHitAre);
						_normalAd_c.visible = true;
						_container.addChild(_normalAd_c);
						_container.addChild(_normalAdMask);
						_normalAd_c.mask = _normalAdMask;
						_state = "playing";
						if(_isReady) {
							dispatch(TvSohuAdsEvent.CTRLBARSHOWN);
							dispatchSharedEvent();
						} else {
							_isReady = true;
						}
					}
				},null,this._normalAdPath);
			}
		}
		
		private function loadFullAd() : void {
			if(this._fullAdPath != "") {
				new LoaderUtil().load(20,function(param1:Object):void {
					var obj:Object = param1;
					if(obj.info == "success") {
						obj.data.contentLoaderInfo.sharedEvents.addEventListener("allowDomain",function(param1:Event):void {
							obj.data.content["clickUrl"] = _adClick;
						});
						obj.data.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_click"));
						_fullAd_c.addChild(obj.data);
						if(_container.stage.displayState == "fullScreen" || (PlayerConfig.isBrowserFullScreen) || _normalAdPath == "") {
							_width = obj.data.contentLoaderInfo.width;
							_height = obj.data.contentLoaderInfo.height;
						}
						_fullAdHitAre = new Sprite();
						Utils.drawRect(_fullAdHitAre,0,0,obj.data.contentLoaderInfo.width,obj.data.contentLoaderInfo.height,15790320,0);
						_fullAdHitAre.buttonMode = true;
						_fullAdHitAre.addEventListener(MouseEvent.CLICK,adClickHandler);
						_fullAdHitAre.visible = false;
						_fullAd_c.addChild(_fullAdHitAre);
						_fullAd_c.visible = true;
						_container.addChild(_fullAd_c);
						_container.addChild(_fullAdMask);
						_fullAd_c.mask = _fullAdMask;
						_state = "playing";
						if(_isReady) {
							dispatch(TvSohuAdsEvent.CTRLBARSHOWN);
							dispatchSharedEvent();
						} else {
							_isReady = true;
						}
					}
				},null,this._fullAdPath);
			}
		}
		
		public function get hasAd() : Boolean {
			return this._adPath == ""?false:true;
		}
		
		public function changeAd() : void {
			if(this.hasAd) {
				if((this._container.stage.displayState == "fullScreen" || (PlayerConfig.isBrowserFullScreen)) && !(this._fullAdPath == "")) {
					this._fullAd_c.visible = true;
					if(this._fullAdHitAre != null) {
						this._fullAdHitAre.visible = this._adClicklayerfbar;
					}
					this._normalAd_c.visible = false;
					if(this._normalAdHitAre != null) {
						this._normalAdHitAre.visible = false;
					}
				} else {
					this._fullAd_c.visible = false;
					if(this._fullAdHitAre != null) {
						this._fullAdHitAre.visible = false;
					}
					this._normalAd_c.visible = true;
					if(this._normalAdHitAre != null) {
						this._normalAdHitAre.visible = this._adClicklayerfbar;
					}
				}
			}
		}
		
		private function adClickHandler(param1:MouseEvent) : void {
			if(this._adClick != "") {
				Utils.openWindow(this._adClick);
			}
		}
		
		public function destroy() : void {
			this._adPath = this._normalAdPath = this._fullAdPath = "";
			this._fullAd_c.visible = this._normalAd_c.visible = false;
			if(this._fullAdHitAre != null) {
				this._fullAdHitAre.visible = false;
			}
			if(this._normalAdHitAre != null) {
				this._normalAdHitAre.visible = false;
			}
			this._state = "no";
			this._isSendAdPlayStock = false;
		}
		
		public function dispatchSharedEvent() : void {
			var _loc1_:Loader = null;
			if((this._fullAd_c.visible) && this._fullAd_c.numChildren >= 1) {
				_loc1_ = this._fullAd_c.getChildAt(this._fullAd_c.numChildren - 1) as Loader;
			} else if((this._normalAd_c.visible) && this._normalAd_c.numChildren >= 1) {
				_loc1_ = this._normalAd_c.getChildAt(this._normalAd_c.numChildren - 1) as Loader;
			}
			
			if(_loc1_ != null) {
				if(this._container.stage.displayState == "fullScreen" || (PlayerConfig.isHide)) {
					_loc1_.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_show_fs"));
				} else {
					_loc1_.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_show_fs_cx"));
				}
			}
		}
		
		public function get width() : Number {
			if(this.hasAd) {
				return (this._fullAd_c.visible) && !(this._fullAdPath == "")?this._fullAdMask.width:this._normalAdMask.width;
			}
			return 0;
		}
		
		public function get height() : Number {
			if(this.hasAd) {
				return (this._fullAd_c.visible) && !(this._fullAdPath == "")?this._fullAdMask.height:this._normalAdMask.height;
			}
			return 0;
		}
		
		public function get metaWidth() : Number {
			return this._fullAd_c.visible?420:280;
		}
		
		public function set width(param1:Number) : void {
			var _loc2_:Sprite = null;
			if((this._fullAd_c.visible) && !(this._fullAdPath == "")) {
				_loc2_ = this._fullAdMask;
			} else {
				_loc2_ = this._normalAdMask;
			}
			_loc2_.width = param1;
		}
		
		public function set height(param1:Number) : void {
			var _loc2_:Sprite = null;
			if((this._fullAd_c.visible) && !(this._fullAdPath == "")) {
				_loc2_ = this._fullAdMask;
			} else {
				_loc2_ = this._normalAdMask;
			}
			_loc2_.height = param1;
		}
		
		public function get normalAd_c() : Sprite {
			return this._normalAd_c;
		}
		
		public function get state() : String {
			return this._state;
		}
		
		private function dispatch(param1:String, param2:Object = null) : void {
			var _loc3_:TvSohuAdsEvent = new TvSohuAdsEvent(param1);
			_loc3_.obj = param2;
			dispatchEvent(_loc3_);
		}
	}
}
