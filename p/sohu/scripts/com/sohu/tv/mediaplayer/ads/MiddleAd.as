package com.sohu.tv.mediaplayer.ads {
	import flash.display.*;
	import ebing.events.*;
	import ebing.net.*;
	import flash.utils.*;
	import com.sohu.tv.mediaplayer.Model;
	import com.sohu.tv.mediaplayer.PlayerConfig;
	
	public class MiddleAd extends StartAd {
		
		public function MiddleAd(param1:Object) {
			super(param1);
		}
		
		protected var _midAdInx:int = 0;
		
		protected var _hasMidAd:Boolean = false;
		
		protected var _isMidAdTip:Boolean = false;
		
		private var _isMadPlay:Number = 0;
		
		override protected function close() : void {
			super.close();
			_isShown = false;
			_state = "no";
			dispatch(TvSohuAdsEvent.MIDDLEFINISH);
			this._hasMidAd = false;
			this._isMidAdTip = false;
		}
		
		override public function set detailClass(param1:Class) : void {
			var _loc3_:Sprite = null;
			var _loc2_:uint = 0;
			while(_loc2_ < _adList.length) {
				_loc3_ = new param1();
				_loc3_["plTip_mc"].visible = false;
				_adList[_loc2_].detail.addChild(_loc3_);
				_loc2_++;
			}
			resize(_width,_height);
		}
		
		override public function play() : void {
			_adList = [];
			_state = "loading";
			this.loadAndPlayAd();
		}
		
		public function sysInitMid() : void {
			this.close();
			sysInit("start");
			_container.visible = false;
			this._hasMidAd = false;
			this._isMidAdTip = false;
		}
		
		override protected function adStart(param1:MediaEvent) : void {
			if(!_isShown) {
				_isShown = true;
				dispatch(TvSohuAdsEvent.MIDDLESHOWN);
			}
		}
		
		override protected function checkAdPlayTime(param1:String, param2:String) : void {
			AdLog.msg("中插广告取消时间验证");
		}
		
		private function loadAndPlayAd() : void {
			var _loc1_:* = "";
			if(!(Model.getInstance().videoInfo.data.adpo == null) && !(PlayerConfig.midAdTimeArr == null) && PlayerConfig.midAdTimeArr.length > 0) {
				_loc1_ = "&inx=" + (this._midAdInx + 1) + "&tot=" + PlayerConfig.midAdTimeArr.length + "&ptime=" + PlayerConfig.midAdTimeArr[this._midAdInx];
			} else if(!(PlayerConfig.midAdTimeArr == null) && PlayerConfig.midAdTimeArr.length > 0) {
				_loc1_ = "&ptime=" + PlayerConfig.midAdTimeArr[0];
			}
			
			var _loc2_:RegExp = new RegExp("&pageUrl=");
			var _loc3_:String = TvSohuAds.getInstance().fetchAdsUrl;
			_loc3_ = _loc3_.replace(_loc2_,"&pt=mad&pageUrl=");
			new URLLoaderUtil().load(5,this.adInfoHandler,_loc3_ + _loc1_ + "&m=" + new Date().getTime());
		}
		
		private function adInfoHandler(param1:Object) : void {
			var _loc2_:Object = null;
			var _loc3_:String = null;
			if(param1.info == "success") {
				_loc2_ = new ebing.net.JSON().parse(param1.data);
				if(_loc2_.status == 1) {
					_state = "success";
					_loc3_ = _loc2_.data.mad;
					AdLog.msg("==========中插广告部分开始==========");
					softInit({"adPar":_loc3_});
					AdLog.msg("==========中插广告部分结束==========");
					this.checkMidAd();
				} else {
					_state = "failed";
					dispatch(TvSohuAdsEvent.MIDDLE_LOAD_FAILED);
				}
			} else {
				_state = "failed";
				dispatch(TvSohuAdsEvent.MIDDLE_LOAD_FAILED);
			}
		}
		
		private function checkMidAd() : void {
			var i:uint = 0;
			while(i < _adList.length) {
				if(_adList[i].adPath != "") {
					this._hasMidAd = true;
				}
				i++;
			}
			this._isMadPlay = setTimeout(function():void {
				sysInitMid();
			},7000);
		}
		
		public function goToPlayMidAd() : void {
			clearTimeout(this._isMadPlay);
			super.play();
		}
		
		public function get midAdInx() : int {
			return this._midAdInx;
		}
		
		public function get hasMidAd() : Boolean {
			return this._hasMidAd;
		}
		
		public function set hasMidAd(param1:Boolean) : void {
			this._hasMidAd = param1;
		}
		
		public function get isMidAdTip() : Boolean {
			return this._isMidAdTip;
		}
		
		public function set isMidAdTip(param1:Boolean) : void {
			this._isMidAdTip = param1;
		}
		
		public function set midAdInx(param1:int) : void {
			this._midAdInx = param1;
		}
		
		override protected function sendAdPlayStock(param1:uint) : void {
			var _loc2_:String = null;
			try {
				if(!_adList[param1].isSendAdPlayStock && !(_adList[param1].adStatUrl == "")) {
					_loc2_ = _adList[param1].adStatUrl.split("?").length > 1?_adList[param1].adStatUrl.split("?")[1]:"";
					sendAdStock(param1,"mad","b",_loc2_);
					_adList[param1].isSendAdPlayStock = true;
				}
			}
			catch(evt:*) {
			}
		}
		
		override protected function sendAdStopStock(param1:uint) : void {
			var _loc2_:String = null;
			try {
				if(!_adList[param1].isSendAdStopStock && !(_adList[param1].adPath == "") && !(_adList[param1].adPlayOverStatUrl == "")) {
					_loc2_ = _adList[param1].adPlayOverStatUrl.split("?").length > 1?_adList[param1].adPlayOverStatUrl.split("?")[1]:"";
					sendAdStock(param1,"mad","a",_loc2_);
					_adList[param1].isSendAdStopStock = true;
				}
			}
			catch(evt:*) {
			}
		}
	}
}
