package com.sohu.tv.mediaplayer.ads {
	import flash.display.*;
	import ebing.net.*;
	import flash.events.*;
	import flash.text.*;
	import com.sohu.tv.mediaplayer.PlayerConfig;
	
	public class PauseAd extends EventDispatcher implements IAds {
		
		public function PauseAd() {
			super();
			this._close_btn = new Sprite();
		}
		
		protected var _adPath:String;
		
		private var _adPingback:String = "";
		
		protected var _showPause:Boolean;
		
		protected var _adContent:Loader;
		
		protected var _owner:PauseAd;
		
		protected var _state:String = "no";
		
		protected var _width:Number = 0;
		
		protected var _height:Number = 0;
		
		protected var _closeBtnUp:Sprite;
		
		protected var _closeBtnOver:Sprite;
		
		protected var _close_btn:Sprite;
		
		protected var _container:Sprite;
		
		public function get container() : Sprite {
			return this._container;
		}
		
		public function set container(param1:Sprite) : void {
			this._container = param1;
		}
		
		public function softInit(param1:Object) : void {
			var _loc2_:String = param1.adPar;
			this._adPath = _loc2_;
			this._adPingback = !(param1.adPingback == null) && !(param1.adPingback == undefined) && !(param1.adPingback == "undefined")?param1.adPingback:"";
		}
		
		public function play() : void {
			this._showPause = true;
			if(this._adContent == null) {
				if(this._state == "no") {
					new LoaderUtil().load(20,this.pauseAdHandler,null,this._adPath);
					this._state = "loading";
					this.pingback();
				}
			} else if(this._showPause) {
				this._container.visible = true;
				this._state = "playing";
				this.dispatch(TvSohuAdsEvent.PAUSESHOWN);
				this._adContent.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_show"));
			} else {
				this.close();
			}
			
		}
		
		public function pingback() : void {
			if(this._adPingback != "") {
				new URLLoaderUtil().multiSend(this._adPingback);
			}
		}
		
		protected function pauseAdHandler(param1:Object) : void {
			if(param1.info == "success") {
				this._adContent = param1.data;
				this._width = param1.data.contentLoaderInfo.width;
				this._height = param1.data.contentLoaderInfo.height;
				this._closeBtnUp = PlayerConfig.drawCloseBtn(15,0,16777215);
				this._closeBtnOver = PlayerConfig.drawCloseBtn(15,0,16711680);
				this._close_btn.addChild(this._closeBtnUp);
				this._close_btn.addChild(this._closeBtnOver);
				this._close_btn.addEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
				this._close_btn.addEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler);
				this._close_btn.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
				this._close_btn.x = this._width - this._close_btn.width - 2;
				this._close_btn.y = 2;
				this._close_btn.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));
				this._close_btn.buttonMode = true;
				this._close_btn.useHandCursor = true;
				this._close_btn.mouseChildren = false;
				this._container.addChild(this._adContent);
				this._container.addChild(this._close_btn);
				this._adContent.contentLoaderInfo.sharedEvents.addEventListener("noPad",this.noPadHandler);
				this._adContent.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_show"));
				if(this._showPause) {
					this._container.visible = true;
					this._state = "playing";
					this.dispatch(TvSohuAdsEvent.PAUSESHOWN);
				} else {
					this.close();
				}
			}
		}
		
		protected function mouseOverHandler(param1:MouseEvent) : void {
			this._closeBtnOver.visible = true;
			this._closeBtnUp.visible = false;
		}
		
		protected function mouseOutHandler(param1:MouseEvent) : void {
			this._closeBtnOver.visible = false;
			this._closeBtnUp.visible = true;
		}
		
		protected function mouseUpHandler(param1:MouseEvent) : void {
			this.close();
		}
		
		protected function noPadHandler(param1:Event) : void {
			this.close();
		}
		
		public function get hasAd() : Boolean {
			if(this._adPath == "") {
				return false;
			}
			return true;
		}
		
		public function close() : void {
			this._showPause = false;
			this._container.visible = false;
			try {
				this._adContent.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_hide"));
			}
			catch(evt:*) {
			}
			this._state = "end";
			this.dispatch(TvSohuAdsEvent.PAUSECLOSED);
		}
		
		public function destroy() : void {
			this._adPath = "";
			this._state = "no";
		}
		
		public function get state() : String {
			return this._state;
		}
		
		public function get width() : Number {
			return this._width;
		}
		
		public function get height() : Number {
			return this._height;
		}
		
		public function get adPath() : String {
			return this._adPath;
		}
		
		protected function dispatch(param1:String, param2:Object = null) : void {
			var _loc3_:TvSohuAdsEvent = new TvSohuAdsEvent(param1);
			_loc3_.obj = param2;
			dispatchEvent(_loc3_);
		}
	}
}
