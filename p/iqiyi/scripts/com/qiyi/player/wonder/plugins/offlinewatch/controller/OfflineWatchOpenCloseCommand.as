package com.qiyi.player.wonder.plugins.offlinewatch.controller {
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.plugins.offlinewatch.model.OfflineWatchProxy;
	import com.iqiyi.components.panelSystem.PanelManager;
	import com.qiyi.player.wonder.body.BodyDef;
	import com.qiyi.player.wonder.plugins.offlinewatch.OfflineWatchDef;
	
	public class OfflineWatchOpenCloseCommand extends SimpleCommand {
		
		public function OfflineWatchOpenCloseCommand() {
			super();
		}
		
		override public function execute(param1:INotification) : void {
			super.execute(param1);
			var _loc2_:OfflineWatchProxy = facade.retrieveProxy(OfflineWatchProxy.NAME) as OfflineWatchProxy;
			if(Boolean(param1.getBody())) {
				PanelManager.getInstance().closeByType(BodyDef.VIEW_TYPE_POPUP);
				_loc2_.addStatus(OfflineWatchDef.STATUS_OPEN);
			} else {
				_loc2_.removeStatus(OfflineWatchDef.STATUS_OPEN);
			}
		}
	}
}
