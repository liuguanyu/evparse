package com.qiyi.player.wonder.plugins.offlinewatch.model
{
	import org.puremvc.as3.patterns.proxy.Proxy;
	import com.qiyi.player.wonder.common.status.IStatus;
	import com.qiyi.player.wonder.common.status.Status;
	import com.qiyi.player.wonder.plugins.offlinewatch.OfflineWatchDef;
	
	public class OfflineWatchProxy extends Proxy implements IStatus
	{
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.offlinewatch.model.OfflineWatchProxy";
		
		private var _status:Status;
		
		public function OfflineWatchProxy(param1:Object = null)
		{
			super(NAME,param1);
			this._status = new Status(OfflineWatchDef.STATUS_BEGIN,OfflineWatchDef.STATUS_END);
		}
		
		public function get status() : Status
		{
			return this._status;
		}
		
		public function addStatus(param1:int, param2:Boolean = true) : void
		{
			if(param1 >= OfflineWatchDef.STATUS_BEGIN && param1 < OfflineWatchDef.STATUS_END && !this._status.hasStatus(param1))
			{
				if(param1 == OfflineWatchDef.STATUS_OPEN && !this._status.hasStatus(OfflineWatchDef.STATUS_VIEW_INIT))
				{
					this._status.addStatus(OfflineWatchDef.STATUS_VIEW_INIT);
					sendNotification(OfflineWatchDef.NOTIFIC_ADD_STATUS,OfflineWatchDef.STATUS_VIEW_INIT);
				}
				this._status.addStatus(param1);
				if(param2)
				{
					sendNotification(OfflineWatchDef.NOTIFIC_ADD_STATUS,param1);
				}
			}
		}
		
		public function removeStatus(param1:int, param2:Boolean = true) : void
		{
			if(param1 >= OfflineWatchDef.STATUS_BEGIN && param1 < OfflineWatchDef.STATUS_END && (this._status.hasStatus(param1)))
			{
				this._status.removeStatus(param1);
				if(param2)
				{
					sendNotification(OfflineWatchDef.NOTIFIC_REMOVE_STATUS,param1);
				}
			}
		}
		
		public function hasStatus(param1:int) : Boolean
		{
			return this._status.hasStatus(param1);
		}
	}
}
