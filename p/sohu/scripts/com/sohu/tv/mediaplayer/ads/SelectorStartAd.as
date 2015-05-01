package com.sohu.tv.mediaplayer.ads {
	import ebing.net.URLLoaderUtil;
	import flash.display.*;
	import com.sohu.tv.mediaplayer.stat.*;
	import com.sohu.tv.mediaplayer.video.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;
	import ebing.net.LoaderUtil;
	import ebing.net.JSON;
	import ebing.Utils;
	import ebing.events.MediaEvent;
	
	public class SelectorStartAd extends EventDispatcher implements IAds {
		
		public function SelectorStartAd(param1:Object) {
			this._adA = new Sprite();
			this._adB = new Sprite();
			super();
			this._owner = this;
			this.hardInit(param1);
		}
		
		protected var _width:Number;
		
		protected var _height:Number;
		
		protected var _container:Sprite;
		
		protected var _state:String = "no";
		
		protected var _owner:SelectorStartAd;
		
		protected var _adNowTime:uint;
		
		protected var _adTotTime:uint;
		
		protected var _statSender:URLLoaderUtil;
		
		protected var _isShown:Boolean = false;
		
		protected var _countText:TextField;
		
		protected var _countDown:Sprite;
		
		protected var _wtimer:Timer;
		
		protected var _hasAd:Boolean = false;
		
		protected var _adLogoA:Loader;
		
		protected var _adLogoB:Loader;
		
		protected var _adLogoAText:TextField;
		
		protected var _adLogoBText:TextField;
		
		protected var _adA:Sprite;
		
		protected var _adB:Sprite;
		
		private var _adSelectorJson:Object;
		
		private var _selectedVideo:Array;
		
		public function hardInit(param1:Object) : void {
			this._width = param1.width;
			this._height = param1.height;
			this.sysInit("start");
		}
		
		public function get container() : Sprite {
			return this._container;
		}
		
		public function set container(param1:Sprite) : void {
			this._container = param1;
		}
		
		protected function appendCU(param1:Array, param2:Array) : void {
			if(param1 == null || param1.length < 1 || param2 == null || param2.length < 1) {
				return;
			}
			if(param1.length >= 1 && !(param1[0] == null) && !(param1[0] == "") && param2.length >= 4) {
				if(param2[3] == null || param2[3] == "") {
					param2[3] = param1[0];
				} else {
					param2[3] = param1[0] + "|" + param2[3];
				}
			}
			if(param1.length >= 2 && !(param1[1] == null) && !(param1[1] == "") && param2.length >= 6) {
				if(param2[5] == null || param2[5] == "") {
					param2[5] = param1[1];
				} else {
					param2[5] = param1[1] + "|" + param2[5];
				}
			}
			if(param1.length >= 3 && !(param1[2] == null) && !(param1[2] == "") && param2.length >= 7) {
				if(param2[6] == null || param2[6] == "") {
					param2[6] = param1[2];
				} else {
					param2[6] = param1[2] + "|" + param2[6];
				}
			}
		}
		
		protected function initAd() : Boolean {
			var _loc2_:* = false;
			var _loc3_:* = false;
			if(!this._adSelectorJson || this._adSelectorJson == null || !this._adSelectorJson.adtype || this._adSelectorJson.adtype == null || !(this._adSelectorJson.adtype == "selector") || !this._adSelectorJson.ad || this._adSelectorJson.ad == null || !(this._adSelectorJson.ad.length == 2)) {
				return false;
			}
			_loc2_ = false;
			_loc3_ = false;
			if(this._adSelectorJson.ad[0].video is Array && this._adSelectorJson.ad[0].video.length >= 8 && !(this._adSelectorJson.ad[0].video[7] == null) && !(this._adSelectorJson.ad[0].video[7] == "")) {
				_loc2_ = TvSohuAds.getInstance().isFrequencyLimit(this._adSelectorJson.ad[0].video[7]);
			}
			if(this._adSelectorJson.ad[1].video is Array && this._adSelectorJson.ad[1].video.length >= 8 && !(this._adSelectorJson.ad[1].video[7] == null) && !(this._adSelectorJson.ad[1].video[7] == "")) {
				_loc3_ = TvSohuAds.getInstance().isFrequencyLimit(this._adSelectorJson.ad[1].video[7]);
			}
			if((_loc2_) && (_loc3_)) {
				return false;
			}
			if(_loc2_) {
				if((this._adSelectorJson.ad[1].limitCU) && this._adSelectorJson.ad[1].limitCU is Object) {
					this.appendCU(this._adSelectorJson.ad[1].limitCU.after,this._adSelectorJson.ad[1].video);
				}
				this.selectedVideo(1);
				this._hasAd = true;
				return false;
			}
			if(_loc3_) {
				if((this._adSelectorJson.ad[0].limitCU) && this._adSelectorJson.ad[0].limitCU is Object) {
					this.appendCU(this._adSelectorJson.ad[0].limitCU.after,this._adSelectorJson.ad[0].video);
				}
				this.selectedVideo(0);
				this._hasAd = true;
				return false;
			}
			if((this._adSelectorJson.ad[0].limitCU) && this._adSelectorJson.ad[0].limitCU is Object) {
				this.appendCU(this._adSelectorJson.ad[0].limitCU.before,this._adSelectorJson.ad[0].video);
			}
			if((this._adSelectorJson.ad[1].limitCU) && this._adSelectorJson.ad[1].limitCU is Object) {
				this.appendCU(this._adSelectorJson.ad[1].limitCU.before,this._adSelectorJson.ad[1].video);
			}
			this._adTotTime = uint(this._adSelectorJson.wait);
			this._adTotTime = this._adTotTime > 10?10:this._adTotTime;
			this._wtimer = new Timer(1000,this._adTotTime);
			this._wtimer.addEventListener(TimerEvent.TIMER,this.adPlayProgress);
			this._wtimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.adPlayComplete);
			new LoaderUtil().load(8,this.adLogoAHandler,null,this._adSelectorJson.ad[0].pic);
			new LoaderUtil().load(8,this.adLogoBHandler,null,this._adSelectorJson.ad[1].pic);
			var _loc1_:TextFormat = new TextFormat();
			_loc1_.font = "SimSun";
			_loc1_.color = 10066329;
			_loc1_.size = 12;
			_loc1_.align = TextFormatAlign.CENTER;
			this._adLogoAText = new TextField();
			this._adLogoAText.selectable = false;
			this._adLogoAText.height = 16;
			this._adLogoAText.width = 160;
			this._adLogoAText.defaultTextFormat = _loc1_;
			this._adLogoAText.text = this._adSelectorJson.ad[0].desc;
			this._adLogoBText = new TextField();
			this._adLogoBText.selectable = false;
			this._adLogoBText.height = 16;
			this._adLogoBText.width = 160;
			this._adLogoBText.defaultTextFormat = _loc1_;
			this._adLogoBText.text = this._adSelectorJson.ad[1].desc;
			this._hasAd = true;
			return true;
		}
		
		public function softInit(param1:Object) : void {
			var obj:Object = param1;
			var selectorStartAdPar:String = obj.adPar;
			if(selectorStartAdPar != "") {
				try {
					this._adSelectorJson = new ebing.net.JSON().parse(selectorStartAdPar.replace(new RegExp("\'","g"),"\""));
				}
				catch(evt:*) {
					Utils.debug("选择器数据异常!" + evt);
				}
				if(!this.initAd()) {
					this.close();
					return;
				}
				this._container.addChild(this._countDown);
				this._countDown.visible = false;
				this._container.addChild(this._adA);
				this._adA.addEventListener(MouseEvent.CLICK,this.adAClickHandler);
				this._container.addChild(this._adB);
				this._adB.addEventListener(MouseEvent.CLICK,this.adBClickHandler);
				Utils.drawRect(this._container,0,0,this._width,this._height,0,1);
			} else {
				Utils.debug("选择器数据为空!");
			}
		}
		
		protected function sysInit(param1:String = null) : void {
			if(param1 == "start") {
				this.newFunc();
				this.drawSkin();
				this.addEvent();
			}
			this._adNowTime = this._adTotTime = 0;
		}
		
		protected function drawSkin() : void {
			this._countDown = new Sprite();
			Utils.drawRect(this._countDown,0,0,260,15,0,0);
			this._countText = new TextField();
			this._countText.autoSize = TextFieldAutoSize.LEFT;
			this._countText.selectable = false;
			var _loc1_:TextFormat = new TextFormat();
			_loc1_.font = "SimSun";
			_loc1_.color = 16777215;
			_loc1_.size = 14;
			this._countText.defaultTextFormat = _loc1_;
			this._countDown.addChild(this._countText);
			Utils.drawRect(this._adA,0,0,160,150,16777215,0);
			Utils.drawRect(this._adB,0,0,160,150,16777215,0);
			this._adA.buttonMode = true;
			this._adA.mouseChildren = false;
			this._adB.buttonMode = true;
			this._adB.mouseChildren = false;
			this.resize(this._width,this._height);
		}
		
		protected function adPlayProgress(param1:TimerEvent) : void {
			this._countText.htmlText = "点击图标选看广告，或等待 " + (this._adTotTime - this._wtimer.currentCount) + " 秒随机播放";
			this._adNowTime = this._wtimer.currentCount;
			this.dispatch(TvSohuAdsEvent.SELECTOR_PLAY_PROGRESS);
		}
		
		protected function adStart(param1:MediaEvent) : void {
			if(!this._isShown) {
				this._isShown = true;
			}
		}
		
		protected function addEvent() : void {
		}
		
		protected function adPlayComplete(param1:TimerEvent) : void {
			this._adNowTime = this._adTotTime;
			this.randomVideo();
		}
		
		protected function close() : void {
			this._state = "end";
			if(!(this._wtimer == null) && (this._wtimer.running)) {
				this._wtimer.stop();
			}
			this.dispatch(TvSohuAdsEvent.SELECTORFINISH);
			this._container.visible = false;
		}
		
		public function play() : void {
			this._state = "playing";
		}
		
		public function destroy() : void {
		}
		
		public function get state() : String {
			return this._state;
		}
		
		protected function newFunc() : void {
			this._statSender = new URLLoaderUtil();
		}
		
		public function resize(param1:Number, param2:Number) : void {
			this._width = param1 < 0?0:param1;
			this._height = param2 < 0?0:param2;
			this._countDown.x = Math.floor((this._width - this._countDown.width) / 2);
			this._countDown.y = Math.floor((this._height - this._countDown.height - 64 - 120 - 14 - 80) / 2);
			this._adA.x = Math.floor((this._width - 150 - 50 - 160) / 2);
			this._adA.y = this._countDown.y + this._countDown.height + 64;
			this._adB.x = Math.floor(this._width / 2) + 25;
			this._adB.y = this._countDown.y + this._countDown.height + 64;
		}
		
		public function get hasAd() : Boolean {
			return this._hasAd;
		}
		
		public function get adPath() : String {
			return "";
		}
		
		public function get video() : Array {
			return this._selectedVideo;
		}
		
		protected function showSelector() : void {
			if(!(this._adLogoA == null) && !(this._adLogoB == null)) {
				if((this._adSelectorJson.showCU) && !(this._adSelectorJson.showCU == null)) {
					this._statSender.multiSend(this._adSelectorJson.showCU);
				}
				this._wtimer.start();
				this._adA.visible = true;
				this._adB.visible = true;
				this._countDown.visible = true;
				this._countText.htmlText = "点击图标选看广告，或等待 " + this._adTotTime + " 秒随机播放";
			}
		}
		
		protected function adLogoAHandler(param1:Object) : void {
			if(param1.info == "success") {
				this._adLogoA = param1.data;
				this._adLogoA.width = 160;
				this._adLogoA.height = 120;
				this._adA.addChild(this._adLogoA);
				this._adLogoAText.y = this._adLogoA.y + this._adLogoA.height + 14;
				this._adA.addChild(this._adLogoAText);
				this.showSelector();
			} else {
				this.randomVideo();
			}
		}
		
		protected function adLogoBHandler(param1:Object) : void {
			if(param1.info == "success") {
				this._adLogoB = param1.data;
				this._adLogoB.width = 160;
				this._adLogoB.height = 120;
				this._adB.addChild(this._adLogoB);
				this._adLogoBText.y = this._adLogoB.y + this._adLogoB.height + 14;
				this._adB.addChild(this._adLogoBText);
				this.showSelector();
			} else {
				this.randomVideo();
			}
		}
		
		protected function adAClickHandler(param1:MouseEvent) : void {
			var _loc2_:RegExp = null;
			if((this._adSelectorJson.ad[0].clickCU) && !(this._adSelectorJson.ad[0].clickCU == null)) {
				_loc2_ = new RegExp("\\(h\\)","g");
				this._statSender.multiSend(this._adSelectorJson.ad[0].clickCU.replace(_loc2_,this._wtimer.currentCount.toString()));
			}
			this.selectedVideo(0);
			this.close();
		}
		
		protected function adBClickHandler(param1:MouseEvent) : void {
			var _loc2_:RegExp = null;
			if((this._adSelectorJson.ad[1].clickCU) && !(this._adSelectorJson.ad[1].clickCU == null)) {
				_loc2_ = new RegExp("\\(h\\)","g");
				this._statSender.multiSend(this._adSelectorJson.ad[1].clickCU.replace(_loc2_,this._wtimer.currentCount.toString()));
			}
			this.selectedVideo(1);
			this.close();
		}
		
		protected function randomVideo() : void {
			var _loc1_:uint = Math.round(Math.random() * 10) % this._adSelectorJson.ad.length;
			this.selectedVideo(_loc1_);
			this.close();
		}
		
		protected function selectedVideo(param1:int) : void {
			if((this._adSelectorJson.ad[param1].video) && !(this._adSelectorJson.ad[param1].video == null)) {
				this._selectedVideo = this._adSelectorJson.ad[param1].video;
			}
		}
		
		protected function dispatch(param1:String, param2:Object = null) : void {
			var _loc3_:TvSohuAdsEvent = new TvSohuAdsEvent(param1);
			_loc3_.obj = param2;
			dispatchEvent(_loc3_);
		}
	}
}
