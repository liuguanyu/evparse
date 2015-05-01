package com.qiyi.player.wonder.plugins.setting.controller {
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.plugins.setting.model.SettingProxy;
	import com.qiyi.player.wonder.plugins.setting.SettingDef;
	import com.iqiyi.components.panelSystem.PanelManager;
	import com.qiyi.player.wonder.body.BodyDef;
	
	public class SettingOpenCloseCommand extends SimpleCommand {
		
		public function SettingOpenCloseCommand() {
			super();
		}
		
		override public function execute(param1:INotification) : void {
			super.execute(param1);
			var _loc2_:SettingProxy = facade.retrieveProxy(SettingProxy.NAME) as SettingProxy;
			if(_loc2_.hasStatus(SettingDef.STATUS_OPEN)) {
				_loc2_.removeStatus(SettingDef.STATUS_OPEN);
			} else {
				PanelManager.getInstance().closeByType(BodyDef.VIEW_TYPE_POPUP);
				_loc2_.addStatus(SettingDef.STATUS_OPEN);
			}
		}
	}
}
