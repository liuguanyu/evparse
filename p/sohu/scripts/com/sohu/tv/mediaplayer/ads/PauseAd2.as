package com.sohu.tv.mediaplayer.ads {
	import flash.display.*;
	import ebing.net.*;
	import com.sohu.tv.mediaplayer.stat.*;
	import flash.events.*;
	import flash.text.*;
	import ebing.Utils;
	import com.sohu.tv.mediaplayer.PlayerConfig;
	import flash.external.ExternalInterface;
	import com.sohu.tv.mediaplayer.net.TvSohuURLLoaderUtil;
	
	public class PauseAd2 extends EventDispatcher implements IAds {
		
		public function PauseAd2() {
			super();
			this._normalAdCloseBtn = new Sprite();
			this._fullAdCloseBtn = new Sprite();
			this._normalAd_c = new Sprite();
			this._fullAd_c = new Sprite();
			this._adLoader = new URLLoaderUtil();
		}
		
		protected var _adPath:String;
		
		private var _adPingback:String = "";
		
		private var _adClick:String = "";
		
		protected var _showPause:Boolean;
		
		protected var _normalAdContent:Loader;
		
		protected var _fullAdContent:Loader;
		
		protected var _owner:PauseAd;
		
		protected var _state:String = "no";
		
		protected var _normalAdCloseBtn:Sprite;
		
		protected var _fullAdCloseBtn:Sprite;
		
		protected var _container:Sprite;
		
		private var _adLoader:URLLoaderUtil;
		
		private var _padSfunc:String = "";
		
		private var _adAlign:String = "";
		
		private var _normalAdW:Number = 0;
		
		private var _normalAdH:Number = 0;
		
		private var _fullAdW:Number = 0;
		
		private var _fullAdH:Number = 0;
		
		private var _thirdAds:Boolean = false;
		
		private var _stageW:Number = 0;
		
		private var _stageH:Number = 0;
		
		private var _adClickLayer:Boolean = false;
		
		private var _normalAdPath:String = "";
		
		private var _fullAdPath:String = "";
		
		private var _normalAd_c:Sprite;
		
		private var _fullAd_c:Sprite;
		
		private var _normalAdMask:Sprite;
		
		private var _fullAdMask:Sprite;
		
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
			var _loc2_:String = null;
			var _loc3_:Array = null;
			if(!(param1.adPar == null) && !(param1.adPar == "")) {
				_loc2_ = param1.adPar;
				this._adPath = _loc2_;
				_loc3_ = this._adPath.split("|");
				this._normalAdPath = _loc3_[0];
				this._fullAdPath = _loc3_.length > 1?_loc3_[1]:"";
			}
			this._adClick = param1.adClick;
			this._adPingback = !(param1.adPingback == null) && !(param1.adPingback == undefined) && !(param1.adPingback == "undefined")?param1.adPingback:"";
			this._padSfunc = !(param1.padsfunc == null) && !(param1.padsfunc == undefined) && !(param1.padsfunc == "undefined") && !(param1.padsfunc == "")?param1.padsfunc:"";
			this._adAlign = !(param1.adAlign == null) && !(param1.adAlign == undefined) && !(param1.adAlign == "undefined") && !(param1.adAlign == "")?param1.adAlign:"";
			this._adClickLayer = !(param1.adClickLayer == null) && !(param1.adClickLayer == undefined) && !(param1.adClickLayer == "undefined") && !(param1.adClickLayer == "") && (param1.adClickLayer == "true" || param1.adClickLayer == true)?true:false;
		}
		
		public function play() : void {
			var vipUser:String = Utils.getBrowserCookie("fee_status");
			var vu:String = !(PlayerConfig.passportMail == "") && !(vipUser == "") && PlayerConfig.passportMail == vipUser?"&vu=" + vipUser:vipUser;
			var ptCode:RegExp = new RegExp("&pageUrl=");
			var url:String = TvSohuAds.getInstance().fetchAdsUrl;
			url = url.replace(ptCode,"&pt=pad&pageUrl=");
			this._adLoader.load(10,function(param1:Object):void {
				var _loc2_:Object = null;
				if(param1.info == "success") {
					AdLog.msg("==========暂停广告信息(json)开始==========");
					AdLog.msg(param1.data);
					AdLog.msg("==========暂停广告信息(json)结束==========");
					_loc2_ = new JSON().parse(param1.data);
					if(_loc2_.status == 1) {
						destroy();
						softInit({
							"adPar":_loc2_.data.pad,
							"adClick":_loc2_.data.padclickurl,
							"adPingback":_loc2_.data.padpingback,
							"padsfunc":_loc2_.data.padsfunc,
							"adAlign":_loc2_.data.align,
							"adClickLayer":_loc2_.data.clicklayer
						});
						if(!(_normalAdPath == "") || !(_fullAdPath == "")) {
							AdLog.msg("暂停广告地址 : :" + _normalAdPath + "|" + _fullAdPath);
							_showPause = true;
							if(_normalAdContent == null && _fullAdContent == null) {
								if(_state == "no") {
									new LoaderUtil().load(20,loadNormalAd,null,_normalAdPath);
									new LoaderUtil().load(20,loadFullAd,null,_fullAdPath);
									_state = "loading";
									pingback();
									AdLog.msg("分别loader普屏和全屏暂停广告");
								}
							} else if(_showPause) {
								AdLog.msg("有暂停广告直接展示");
								if((_container.stage.displayState == "fullScreen" || (PlayerConfig.isBrowserFullScreen)) && !(_fullAdPath == "")) {
									_fullAd_c.visible = true;
									_normalAd_c.visible = false;
									_fullAdContent.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_show"));
								} else {
									_normalAd_c.visible = true;
									_fullAd_c.visible = false;
									_normalAdContent.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_show"));
								}
								_container.visible = true;
								_state = "playing";
							} else {
								AdLog.msg("关闭现有的暂停广告");
								close();
							}
							
						} else {
							AdLog.msg("无暂停广告");
							pingback();
						}
					}
				}
			},url + "&m=" + new Date().getTime());
		}
		
		public function pingback() : void {
			var _loc1_:String = null;
			var _loc2_:String = null;
			var _loc3_:String = null;
			if(!this._isSendAdPlayStock && !(this._adPingback == "")) {
				this._isSendAdPlayStock = true;
				_loc1_ = "";
				_loc2_ = this._adPingback.split("?").length > 1?"&" + this._adPingback.split("?")[1]:"";
				if(this._normalAdPath != "") {
					_loc1_ = Utils.getType(this._normalAdPath,".");
				}
				_loc3_ = this._adPath != ""?"act":"na";
				InforSender.getInstance().sendCustomMesg("http://wl.hd.sohu.com/s.gif?prod=flash&systype=" + (PlayerConfig.isHotOrMy?"0":"1") + "&cid=" + PlayerConfig.catcode + "&log=" + _loc3_ + "&from=" + PlayerConfig.domainProperty + "&3th=0&adTime=0&adType=" + _loc1_ + "&dmpt=pad&po=b" + "&adUrl=" + (this._adPath != ""?escape(this._adPath):"") + _loc2_);
			}
			if(this._adPingback != "") {
				if(!(this._padSfunc == "") && (ExternalInterface.available)) {
					ExternalInterface.call(this._padSfunc,0,this._adPingback);
				} else {
					new TvSohuURLLoaderUtil().multiSend(this._adPingback);
				}
			}
		}
		
		protected function loadNormalAd(param1:Object) : void {
			var obj:Object = param1;
			if(obj.info == "success") {
				this._normalAdContent = obj.data;
				this._normalAdW = obj.data.contentLoaderInfo.width;
				this._normalAdH = obj.data.contentLoaderInfo.height;
				this._normalAdCloseBtn = this.closeBtnSp(this._normalAdCloseBtn);
				this._normalAdCloseBtn.x = Math.round(this._normalAdW - this._normalAdCloseBtn.width / 2 + 10);
				this._normalAdMask = new Sprite();
				Utils.drawRect(this._normalAdMask,0,0,this._normalAdW,this._normalAdH,0,0);
				this._normalAdMask.visible = false;
				this._normalAd_c.addChild(this._normalAdMask);
				if(this._adClickLayer) {
					this._normalAdMask.visible = true;
					this._normalAdContent.mask = this._normalAdMask;
				}
				this._normalAd_c.addChild(this._normalAdContent);
				this._normalAdHitAre = new Sprite();
				Utils.drawRect(this._normalAdHitAre,0,0,this._normalAdW,this._normalAdH,16711680,0);
				this._normalAd_c.addChild(this._normalAdHitAre);
				this._normalAdHitAre.buttonMode = true;
				this._normalAdHitAre.addEventListener(MouseEvent.CLICK,this.adClickHandler);
				this._normalAd_c.addChild(this._normalAdCloseBtn);
				this._container.addChild(this._normalAd_c);
				this._normalAd_c.visible = false;
				this._normalAdHitAre.visible = this._normalAdCloseBtn.visible = this._adClickLayer;
				this._normalAdContent.contentLoaderInfo.sharedEvents.addEventListener("resize",this.resize);
				this._normalAdContent.contentLoaderInfo.sharedEvents.addEventListener("noPad",this.noPadHandler);
				this._normalAdContent.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_show"));
				this._normalAdContent.contentLoaderInfo.sharedEvents.addEventListener("allowDomain",function(param1:Event):void {
					if(_showPause) {
						_normalAdCloseBtn.visible = true;
						_normalAdContent.content["clickUrl"] = _adClick;
					}
				});
				this._normalAdContent.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_click"));
				this.showFullOrNor();
			}
		}
		
		protected function loadFullAd(param1:Object) : void {
			var obj:Object = param1;
			if(obj.info == "success") {
				this._fullAdContent = obj.data;
				this._fullAdW = obj.data.contentLoaderInfo.width;
				this._fullAdH = obj.data.contentLoaderInfo.height;
				this._fullAdCloseBtn = this.closeBtnSp(this._fullAdCloseBtn);
				this._fullAdCloseBtn.x = Math.round(this._fullAdW - this._fullAdCloseBtn.width / 2 + 10);
				this._fullAdMask = new Sprite();
				Utils.drawRect(this._fullAdMask,0,0,this._fullAdW,this._fullAdH,0,1);
				this._fullAdMask.visible = false;
				this._fullAd_c.addChild(this._fullAdMask);
				if(this._adClickLayer) {
					this._fullAdMask.visible = true;
					this._fullAdContent.mask = this._fullAdMask;
				}
				this._fullAd_c.addChild(this._fullAdContent);
				this._fullAdHitAre = new Sprite();
				Utils.drawRect(this._fullAdHitAre,0,0,this._fullAdW,this._fullAdH,16711680,0);
				this._fullAd_c.addChild(this._fullAdHitAre);
				this._fullAdHitAre.buttonMode = true;
				this._fullAdHitAre.addEventListener(MouseEvent.CLICK,this.adClickHandler);
				this._fullAd_c.addChild(this._fullAdCloseBtn);
				this._container.addChild(this._fullAd_c);
				this._fullAd_c.visible = false;
				this._fullAdHitAre.visible = this._fullAdCloseBtn.visible = this._adClickLayer;
				this._fullAdContent.contentLoaderInfo.sharedEvents.addEventListener("resize",this.resize);
				this._fullAdContent.contentLoaderInfo.sharedEvents.addEventListener("noPad",this.noPadHandler);
				this._fullAdContent.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_show"));
				this._fullAdContent.contentLoaderInfo.sharedEvents.addEventListener("allowDomain",function(param1:Event):void {
					if(_showPause) {
						_fullAdCloseBtn.visible = true;
						_fullAdContent.content["clickUrl"] = _adClick;
					}
				});
				this._fullAdContent.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_click"));
				this.showFullOrNor();
			}
		}
		
		private function showFullOrNor() : void {
			if(this._showPause) {
				if((this._container.stage.displayState == "fullScreen" || (PlayerConfig.isBrowserFullScreen)) && !(this._fullAdPath == "")) {
					this._fullAd_c.visible = true;
					this._normalAd_c.visible = false;
					AdLog.msg("展示全屏暂停广告");
				} else {
					this._normalAd_c.visible = true;
					this._fullAd_c.visible = false;
					AdLog.msg("展示普屏暂停广告");
				}
				this._container.visible = true;
				this._state = "playing";
				this.dispatch(TvSohuAdsEvent.PAUSESHOWN);
			} else {
				this.close();
			}
		}
		
		private function adClickHandler(param1:MouseEvent) : void {
			if(this._adClick != "") {
				Utils.openWindow(this._adClick);
			}
		}
		
		private function resize(param1:Event) : void {
			this._thirdAds = true;
			this.changeSize(this._stageW,this._stageH);
		}
		
		public function changeSize(param1:Number, param2:Number) : void {
			var w:Number = param1;
			var h:Number = param2;
			this._stageW = w;
			this._stageH = h;
			try {
				this.changeNormalAdSize(w,h);
				this.changeFullAdSize(w,h);
			}
			catch(evt:*) {
			}
			if((this._container.stage.displayState == "fullScreen" || (PlayerConfig.isBrowserFullScreen)) && !(this._fullAdPath == "")) {
				if(this._fullAd_c != null) {
					this._fullAd_c.visible = true;
				}
				if(this._fullAdHitAre != null) {
					this._fullAdHitAre.visible = this._adClickLayer;
				}
				if(this._normalAd_c != null) {
					this._normalAd_c.visible = false;
				}
				if(this._normalAdHitAre != null) {
					this._normalAdHitAre.visible = false;
				}
			} else {
				if(this._fullAd_c != null) {
					this._fullAd_c.visible = false;
				}
				if(this._fullAdHitAre != null) {
					this._fullAdHitAre.visible = false;
				}
				if(this._normalAd_c != null) {
					this._normalAd_c.visible = true;
				}
				if(this._normalAdHitAre != null) {
					this._normalAdHitAre.visible = this._adClickLayer;
				}
			}
		}
		
		private function changeNormalAdSize(param1:Number, param2:Number) : void {
			var _loc5_:* = NaN;
			var _loc3_:Number = this._normalAdW;
			var _loc4_:Number = this._normalAdH;
			if(this._normalAdContent != null) {
				if(param1 > this._normalAdW + 26 && param2 > this._normalAdH + 26) {
					this._normalAdContent.scaleX = this._normalAdContent.scaleY = 1;
					this._normalAdW = this._normalAdContent.contentLoaderInfo.width;
					this._normalAdH = this._normalAdContent.contentLoaderInfo.height;
				} else {
					_loc5_ = Math.min(param1 / (_loc3_ + 26),param2 / (_loc4_ + 26));
					this._normalAdContent.scaleX = _loc5_ * this._normalAdContent.scaleX;
					this._normalAdContent.scaleY = _loc5_ * this._normalAdContent.scaleY;
					this._normalAdW = _loc5_ * _loc3_;
					this._normalAdH = _loc5_ * _loc4_;
				}
				if(this._thirdAds) {
					this._normalAdCloseBtn.x = Math.round(this._normalAdW / 2 + this._normalAdContent.content["width"] * this._normalAdContent.scaleX / 2 - this._normalAdCloseBtn.width / 2 + 10);
					this._normalAdCloseBtn.y = Math.round(this._normalAdH / 2 - this._normalAdContent.content["height"] * this._normalAdContent.scaleY / 2);
					this._normalAdCloseBtn.visible = true;
				} else {
					this._normalAdCloseBtn.x = Math.round(this._normalAdW - this._normalAdCloseBtn.width / 2 + 10);
				}
			}
			if((this._adClickLayer) && !(this._normalAdHitAre == null)) {
				this._normalAdHitAre.width = this._normalAdW;
				this._normalAdHitAre.height = this._normalAdW;
			}
			if((this._adClickLayer) && !(this._normalAdMask == null)) {
				this._normalAdMask.width = this._normalAdW;
				this._normalAdMask.height = this._normalAdH;
				this._normalAdContent.mask = this._normalAdMask;
			}
		}
		
		private function changeFullAdSize(param1:Number, param2:Number) : void {
			var _loc5_:* = NaN;
			var _loc3_:Number = this._fullAdW;
			var _loc4_:Number = this._fullAdH;
			if(this._fullAdContent != null) {
				if(param1 > this._fullAdW + 26 && param2 > this._fullAdH + 26) {
					this._fullAdContent.scaleX = this._fullAdContent.scaleY = 1;
					this._fullAdW = this._fullAdContent.contentLoaderInfo.width;
					this._fullAdH = this._fullAdContent.contentLoaderInfo.height;
				} else {
					_loc5_ = Math.min(param1 / (_loc3_ + 26),param2 / (_loc4_ + 26));
					this._fullAdContent.scaleX = _loc5_ * this._fullAdContent.scaleX;
					this._fullAdContent.scaleY = _loc5_ * this._fullAdContent.scaleY;
					this._fullAdW = _loc5_ * _loc3_;
					this._fullAdH = _loc5_ * _loc4_;
				}
				if(this._thirdAds) {
					this._fullAdCloseBtn.x = Math.round(this._fullAdW / 2 + this._fullAdContent.content["width"] * this._fullAdContent.scaleX / 2 - this._fullAdCloseBtn.width / 2 + 10);
					this._fullAdCloseBtn.y = Math.round(this._fullAdH / 2 - this._fullAdContent.content["height"] * this._fullAdContent.scaleY / 2);
					this._fullAdCloseBtn.visible = true;
				} else {
					this._fullAdCloseBtn.x = Math.round(this._fullAdW - this._fullAdCloseBtn.width / 2 + 10);
				}
			}
			if((this._adClickLayer) && !(this._fullAdHitAre == null)) {
				this._fullAdHitAre.width = this._fullAdW;
				this._fullAdHitAre.height = this._fullAdH;
			}
			if((this._adClickLayer) && !(this._fullAdMask == null)) {
				this._fullAdMask.width = this._fullAdW;
				this._fullAdMask.height = this._fullAdH;
				this._fullAdContent.mask = this._fullAdMask;
			}
		}
		
		protected function mouseUpHandler(param1:MouseEvent) : void {
			this.close();
		}
		
		protected function noPadHandler(param1:Event) : void {
			this.close();
		}
		
		public function get hasAd() : Boolean {
			return true;
		}
		
		public function get adAlign() : String {
			return this._adAlign;
		}
		
		public function close(param1:* = null) : void {
			var evt:* = param1;
			this._showPause = false;
			this._container.visible = false;
			this._thirdAds = false;
			this._adClickLayer = false;
			this._isSendAdPlayStock = false;
			if(!(this._normalAdHitAre == null) && !(this._normalAdMask == null)) {
				this._normalAdHitAre.removeEventListener(MouseEvent.CLICK,this.adClickHandler);
				this._normalAdMask.visible = this._normalAdHitAre.visible = false;
			}
			if(!(this._fullAdHitAre == null) && !(this._fullAdMask == null)) {
				this._fullAdHitAre.removeEventListener(MouseEvent.CLICK,this.adClickHandler);
				this._fullAdMask.visible = this._fullAdHitAre.visible = false;
			}
			this._adLoader.close();
			try {
				if(this._normalAdContent != null) {
					this._normalAdContent.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_hide"));
				}
				if(this._fullAdContent != null) {
					this._fullAdContent.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_hide"));
				}
			}
			catch(evt:*) {
			}
			this._state = "end";
			this.dispatch(TvSohuAdsEvent.PAUSECLOSED);
			AdLog.msg("关闭暂停广告");
		}
		
		public function destroy() : void {
			this._adPath = "";
			this._state = "no";
			if(this._normalAdContent != null) {
				this._normalAdContent.contentLoaderInfo.sharedEvents.removeEventListener("noPad",this.noPadHandler);
				try {
					this._normalAd_c.removeChild(this._normalAdContent);
					this._normalAd_c.removeChild(this._normalAdCloseBtn);
					this._container.removeChild(this._normalAd_c);
				}
				catch(evt:*) {
				}
				this._normalAdContent = null;
			}
			if(this._fullAdContent != null) {
				this._fullAdContent.contentLoaderInfo.sharedEvents.removeEventListener("noPad",this.noPadHandler);
				try {
					this._fullAd_c.removeChild(this._fullAdContent);
					this._fullAd_c.removeChild(this._fullAdCloseBtn);
					this._container.removeChild(this._fullAd_c);
				}
				catch(evt:*) {
				}
				this._fullAdContent = null;
			}
			AdLog.msg("销毁暂停广告");
		}
		
		public function get state() : String {
			return this._state;
		}
		
		public function get width() : Number {
			if(!(this._fullAd_c == null) && (this._fullAd_c.visible) && !(this._fullAdPath == "") && !(this._fullAdContent == null)) {
				return this._fullAdW;
			}
			if(!(this._normalAd_c == null) && (this._normalAd_c.visible) && !(this._normalAdPath == "") && !(this._normalAdContent == null)) {
				return this._normalAdW;
			}
			return 0;
		}
		
		public function get height() : Number {
			if(!(this._fullAd_c == null) && (this._fullAd_c.visible) && !(this._fullAdPath == "") && !(this._fullAdContent == null)) {
				return this._fullAdH;
			}
			if(!(this._normalAd_c == null) && (this._normalAd_c.visible) && !(this._normalAdPath == "") && !(this._normalAdContent == null)) {
				return this._normalAdH;
			}
			return 0;
		}
		
		public function get adPath() : String {
			return this._adPath;
		}
		
		protected function dispatch(param1:String, param2:Object = null) : void {
			var _loc3_:TvSohuAdsEvent = new TvSohuAdsEvent(param1);
			_loc3_.obj = param2;
			dispatchEvent(_loc3_);
		}
		
		private function closeBtnSp(param1:Sprite) : Sprite {
			var _closeBtnUp:Sprite = null;
			var _closeBtnOver:Sprite = null;
			var sp:Sprite = param1;
			sp = new Sprite();
			_closeBtnUp = this.drawCircleCloseBtn(11,0,16777215);
			_closeBtnOver = this.drawCircleCloseBtn(12,16711680,16777215);
			sp.addChild(_closeBtnUp);
			sp.addChild(_closeBtnOver);
			sp.addEventListener(MouseEvent.MOUSE_OVER,function(param1:Event):void {
				_closeBtnOver.visible = true;
				_closeBtnUp.visible = false;
			});
			sp.addEventListener(MouseEvent.MOUSE_OUT,function(param1:Event):void {
				_closeBtnOver.visible = false;
				_closeBtnUp.visible = true;
			});
			sp.addEventListener(MouseEvent.MOUSE_UP,function(param1:Event):void {
				close();
			});
			sp.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));
			sp.buttonMode = true;
			sp.useHandCursor = true;
			sp.mouseChildren = false;
			return sp;
		}
		
		private function drawCircleCloseBtn(param1:Number, param2:uint, param3:uint) : Sprite {
			var _loc4_:Sprite = new Sprite();
			var _loc5_:Number = 2;
			var _loc6_:Number = 8.5;
			_loc4_.graphics.lineStyle(_loc5_,param3,0.5);
			_loc4_.graphics.beginFill(param2,0.6);
			_loc4_.graphics.drawCircle(_loc5_,_loc5_,param1);
			_loc4_.graphics.endFill();
			var _loc7_:Sprite = new Sprite();
			_loc7_.graphics.lineStyle(2,16777215,1);
			_loc7_.graphics.lineTo(_loc6_,_loc6_);
			_loc7_.graphics.moveTo(_loc6_,0);
			_loc7_.graphics.lineTo(0,_loc6_);
			_loc4_.addChild(_loc7_);
			_loc7_.x = -_loc5_;
			_loc7_.y = -_loc5_;
			return _loc4_;
		}
	}
}
