package com.sohu.tv.mediaplayer.ads {
	import flash.display.*;
	
	public class EndAd extends StartAd {
		
		public function EndAd(param1:Object) {
			super(param1);
		}
		
		private var isEndFinish:Boolean = true;
		
		override protected function checkAdPlayTime(param1:String, param2:String) : void {
			AdLog.msg("后贴广告取消时间验证");
		}
		
		override protected function close() : void {
			super.close();
			if(this.isEndFinish) {
				dispatch(TvSohuAdsEvent.ENDFINISH);
			} else {
				this.isEndFinish = true;
			}
		}
		
		override public function destroy() : void {
			this.isEndFinish = false;
			this.close();
			sysInit("start");
			_container.visible = false;
			_isShown = false;
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
		
		override protected function sendAdPlayStock(param1:uint) : void {
			var _loc2_:String = null;
			try {
				if(!_adList[param1].isSendAdPlayStock && !(_adList[param1].adStatUrl == "")) {
					_loc2_ = _adList[param1].adStatUrl.split("?").length > 1?_adList[param1].adStatUrl.split("?")[1]:"";
					sendAdStock(param1,"ead","b",_loc2_);
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
					sendAdStock(param1,"ead","a",_loc2_);
					_adList[param1].isSendAdStopStock = true;
				}
			}
			catch(evt:*) {
			}
		}
	}
}
