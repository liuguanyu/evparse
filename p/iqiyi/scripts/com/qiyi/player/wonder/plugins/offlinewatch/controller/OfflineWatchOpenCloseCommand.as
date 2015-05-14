package com.qiyi.player.wonder.plugins.offlinewatch.controller
{
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.plugins.offlinewatch.model.OfflineWatchProxy;
	import com.iqiyi.components.panelSystem.PanelManager;
	import com.qiyi.player.wonder.body.BodyDef;
	import com.qiyi.player.wonder.plugins.offlinewatch.OfflineWatchDef;
	
	public class OfflineWatchOpenCloseCommand extends SimpleCommand
	{
		
		public function OfflineWatchOpenCloseCommand()
		{
			super();
		}
		
		override public function execute(param1:INotification) : void
		{
			super.execute(param1);
			var _loc2:OfflineWatchProxy = facade.retrieveProxy(OfflineWatchProxy.NAME) as OfflineWatchProxy;
			if(Boolean(param1.getBody()))
			{
				PanelManager.getInstance().closeByType(BodyDef.VIEW_TYPE_POPUP);
				_loc2.addStatus(OfflineWatchDef.STATUS_OPEN);
			}
			else
			{
				_loc2.removeStatus(OfflineWatchDef.STATUS_OPEN);
			}
		}
	}
}
