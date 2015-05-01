package com.qiyi.player.wonder.plugins.dock.model {
	import org.puremvc.as3.patterns.proxy.Proxy;
	import com.qiyi.player.wonder.common.status.IStatus;
	import com.qiyi.player.wonder.common.status.Status;
	import com.qiyi.player.wonder.plugins.dock.DockDef;
	
	public class DockProxy extends Proxy implements IStatus {
		
		public function DockProxy(param1:Object = null) {
			super(NAME,param1);
			this._status = new Status(DockDef.STATUS_BEGIN,DockDef.STATUS_END);
			this._status.addStatus(DockDef.STATUS_VIEW_INIT);
			this._status.addStatus(DockDef.STATUS_LIGHT_ON);
		}
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.dock.model.DockProxy";
		
		private var _status:Status;
		
		public function get status() : Status {
			return this._status;
		}
		
		public function addStatus(param1:int, param2:Boolean = true) : void {
			if(param1 >= DockDef.STATUS_BEGIN && param1 < DockDef.STATUS_END && !this._status.hasStatus(param1)) {
				if(param1 == DockDef.STATUS_OPEN && !this._status.hasStatus(DockDef.STATUS_VIEW_INIT)) {
					this._status.addStatus(DockDef.STATUS_VIEW_INIT);
					sendNotification(DockDef.NOTIFIC_ADD_STATUS,DockDef.STATUS_VIEW_INIT);
				}
				this._status.addStatus(param1);
				if(param2) {
					sendNotification(DockDef.NOTIFIC_ADD_STATUS,param1);
				}
			}
		}
		
		public function removeStatus(param1:int, param2:Boolean = true) : void {
			if(param1 >= DockDef.STATUS_BEGIN && param1 < DockDef.STATUS_END && (this._status.hasStatus(param1))) {
				this._status.removeStatus(param1);
				if(param2) {
					sendNotification(DockDef.NOTIFIC_REMOVE_STATUS,param1);
				}
			}
		}
		
		public function hasStatus(param1:int) : Boolean {
			return this._status.hasStatus(param1);
		}
	}
}
