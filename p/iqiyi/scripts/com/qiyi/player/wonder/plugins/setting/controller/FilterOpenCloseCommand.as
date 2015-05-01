package com.qiyi.player.wonder.plugins.setting.controller {
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.plugins.setting.model.SettingProxy;
	import com.iqiyi.components.panelSystem.PanelManager;
	import com.qiyi.player.wonder.body.BodyDef;
	import com.qiyi.player.wonder.plugins.setting.SettingDef;
	
	public class FilterOpenCloseCommand extends SimpleCommand {
		
		public function FilterOpenCloseCommand() {
			super();
		}
		
		override public function execute(param1:INotification) : void {
			super.execute(param1);
			var _loc2_:SettingProxy = facade.retrieveProxy(SettingProxy.NAME) as SettingProxy;
			if(Boolean(param1.getBody())) {
				PanelManager.getInstance().closeByType(BodyDef.VIEW_TYPE_POPUP);
				_loc2_.addStatus(SettingDef.STATUS_FILTER_OPEN);
			} else {
				_loc2_.removeStatus(SettingDef.STATUS_FILTER_OPEN);
			}
		}
	}
}
