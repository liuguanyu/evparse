package com.qiyi.player.wonder.plugins.share.controller
{
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.plugins.share.model.ShareProxy;
	import com.iqiyi.components.panelSystem.PanelManager;
	import com.qiyi.player.wonder.body.BodyDef;
	import com.qiyi.player.wonder.plugins.share.ShareDef;
	
	public class ShareOpenCloseCommand extends SimpleCommand
	{
		
		public function ShareOpenCloseCommand()
		{
			super();
		}
		
		override public function execute(param1:INotification) : void
		{
			super.execute(param1);
			var _loc2:ShareProxy = facade.retrieveProxy(ShareProxy.NAME) as ShareProxy;
			if(Boolean(param1.getBody()))
			{
				PanelManager.getInstance().closeByType(BodyDef.VIEW_TYPE_POPUP);
				_loc2.addStatus(ShareDef.STATUS_OPEN);
			}
			else
			{
				_loc2.removeStatus(ShareDef.STATUS_OPEN);
			}
		}
	}
}
