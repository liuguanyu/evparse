package com.qiyi.player.wonder.plugins.setting.controller
{
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.plugins.setting.model.SettingProxy;
	import com.iqiyi.components.panelSystem.PanelManager;
	import com.qiyi.player.wonder.body.BodyDef;
	import com.qiyi.player.wonder.plugins.setting.SettingDef;
	
	public class DefinitionOpenCloseCommand extends SimpleCommand
	{
		
		public function DefinitionOpenCloseCommand()
		{
			super();
		}
		
		override public function execute(param1:INotification) : void
		{
			super.execute(param1);
			var _loc2:SettingProxy = facade.retrieveProxy(SettingProxy.NAME) as SettingProxy;
			if(Boolean(param1.getBody()))
			{
				PanelManager.getInstance().closeByType(BodyDef.VIEW_TYPE_POPUP);
				_loc2.addStatus(SettingDef.STATUS_DEFINITION_OPEN);
			}
			else
			{
				_loc2.removeStatus(SettingDef.STATUS_DEFINITION_OPEN);
			}
		}
	}
}
