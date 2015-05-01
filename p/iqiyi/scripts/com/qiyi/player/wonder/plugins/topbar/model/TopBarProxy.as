package com.qiyi.player.wonder.plugins.topbar.model {
	import org.puremvc.as3.patterns.proxy.Proxy;
	import com.qiyi.player.wonder.common.status.IStatus;
	import com.qiyi.player.wonder.common.status.Status;
	import com.qiyi.player.wonder.plugins.topbar.TopBarDef;
	
	public class TopBarProxy extends Proxy implements IStatus {
		
		public function TopBarProxy(param1:Object = null) {
			super(NAME,param1);
			this._status = new Status(TopBarDef.STATUS_BEGIN,TopBarDef.STATUS_END);
			this._scaleValue = TopBarDef.SCALE_VALUE_100;
			this._status.addStatus(TopBarDef.STATUS_VIEW_INIT);
		}
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.topbar.model.TopBarProxy";
		
		private var _status:Status;
		
		private var _scaleValue:int;
		
		private var _upWardWheelCount:int;
		
		private var _downWardWheelCount:int;
		
		public function get status() : Status {
			return this._status;
		}
		
		public function set scaleValue(param1:int) : void {
			if(param1 != this._scaleValue) {
				this._scaleValue = param1;
				sendNotification(TopBarDef.NOTIFIC_SCREEN_SCALE_CHANGE,this._scaleValue);
			}
		}
		
		public function get scaleValue() : int {
			return this._scaleValue;
		}
		
		public function get upWardWheelCount() : int {
			return this._upWardWheelCount;
		}
		
		public function set upWardWheelCount(param1:int) : void {
			this._upWardWheelCount = param1;
		}
		
		public function get downWardWheelCount() : int {
			return this._downWardWheelCount;
		}
		
		public function set downWardWheelCount(param1:int) : void {
			this._downWardWheelCount = param1;
		}
		
		public function addStatus(param1:int, param2:Boolean = true) : void {
			if(param1 >= TopBarDef.STATUS_BEGIN && param1 < TopBarDef.STATUS_END && !this._status.hasStatus(param1)) {
				if(param1 == TopBarDef.STATUS_OPEN && !this._status.hasStatus(TopBarDef.STATUS_VIEW_INIT)) {
					this._status.addStatus(TopBarDef.STATUS_VIEW_INIT);
					sendNotification(TopBarDef.NOTIFIC_ADD_STATUS,TopBarDef.STATUS_VIEW_INIT);
				}
				this._status.addStatus(param1);
				if(param2) {
					sendNotification(TopBarDef.NOTIFIC_ADD_STATUS,param1);
				}
			}
		}
		
		public function removeStatus(param1:int, param2:Boolean = true) : void {
			if(param1 >= TopBarDef.STATUS_BEGIN && param1 < TopBarDef.STATUS_END && (this._status.hasStatus(param1))) {
				this._status.removeStatus(param1);
				if(param2) {
					sendNotification(TopBarDef.NOTIFIC_REMOVE_STATUS,param1);
				}
			}
		}
		
		public function hasStatus(param1:int) : Boolean {
			return this._status.hasStatus(param1);
		}
	}
}
