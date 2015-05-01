package com.sohu.tv.mediaplayer.ads {
	import ebing.net.*;
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;
	import com.sohu.tv.mediaplayer.PlayerConfig;
	
	public class SogouAd extends PauseAd {
		
		public function SogouAd() {
			super();
			new URLLoaderUtil().load(1,function(param1:Object):void {
				if(param1.info != "success") {
					_hasAd = true;
				}
			},PlayerConfig.CHECKP2PPATH + "shakehand" + "?uuid=" + PlayerConfig.uuid + "&vid=" + PlayerConfig.vid + "&r=" + (new Date().getTime() + Math.random()));
		}
		
		private var _statusID:int = -1;
		
		private var _hasAd:Boolean = false;
		
		override public function play() : void {
			super.play();
			_close_btn.visible = false;
			if((_showPause) && !(_adContent == null)) {
				this.show();
				dispatch(TvSohuAdsEvent.SOGOUSHOWN);
			}
		}
		
		override protected function pauseAdHandler(param1:Object) : void {
			var obj:Object = param1;
			super.pauseAdHandler(obj);
			if(obj.info == "success" && (_showPause)) {
				dispatch(TvSohuAdsEvent.SOGOUSHOWN);
				setTimeout(function():void {
					hide();
				},15000);
			}
		}
		
		override public function get hasAd() : Boolean {
			return this._hasAd;
		}
		
		override public function get height() : Number {
			var _loc1_:* = 0;
			if(_adContent != null) {
				_loc1_ = _adContent.contentLoaderInfo.height;
			}
			return _loc1_;
		}
		
		public function resize(param1:Number, param2:Number) : void {
			_width = param1 < 0?0:param1;
			_height = param2 < 0?0:param2;
			if(_adContent != null) {
				_adContent["content"].resize(param1,param2);
			}
		}
		
		public function get isShow() : Boolean {
			if(_state == "playing" && (_container.visible) && !(_adContent == null) && (_adContent.visible)) {
				return true;
			}
			return false;
		}
		
		public function hide() : void {
			if(_adContent != null) {
				_adContent.visible = false;
			}
		}
		
		public function show() : void {
			if(_adContent != null) {
				_adContent.visible = true;
			}
		}
	}
}
