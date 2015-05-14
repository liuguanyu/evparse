package com.qiyi.player.wonder.plugins.feedback.controller
{
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.plugins.feedback.model.FeedbackProxy;
	import com.iqiyi.components.panelSystem.PanelManager;
	import com.qiyi.player.wonder.body.BodyDef;
	import com.qiyi.player.wonder.plugins.feedback.FeedbackDef;
	
	public class FeebackOpenCloseCommand extends SimpleCommand
	{
		
		public function FeebackOpenCloseCommand()
		{
			super();
		}
		
		override public function execute(param1:INotification) : void
		{
			super.execute(param1);
			var _loc2:FeedbackProxy = facade.retrieveProxy(FeedbackProxy.NAME) as FeedbackProxy;
			if(Boolean(param1.getBody()))
			{
				PanelManager.getInstance().closeByType(BodyDef.VIEW_TYPE_POPUP);
				_loc2.addStatus(FeedbackDef.STATUS_OPEN);
			}
			else
			{
				_loc2.removeStatus(FeedbackDef.STATUS_OPEN);
			}
		}
	}
}
