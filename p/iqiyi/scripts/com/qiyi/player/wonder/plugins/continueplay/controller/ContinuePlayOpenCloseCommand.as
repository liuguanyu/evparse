package com.qiyi.player.wonder.plugins.continueplay.controller {
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.plugins.continueplay.model.ContinuePlayProxy;
	import com.qiyi.player.wonder.plugins.continueplay.ContinuePlayDef;
	
	public class ContinuePlayOpenCloseCommand extends SimpleCommand {
		
		public function ContinuePlayOpenCloseCommand() {
			super();
		}
		
		override public function execute(param1:INotification) : void {
			super.execute(param1);
			var _loc2_:ContinuePlayProxy = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
			if(Boolean(param1.getBody())) {
				_loc2_.addStatus(ContinuePlayDef.STATUS_OPEN);
			} else {
				_loc2_.removeStatus(ContinuePlayDef.STATUS_OPEN);
			}
		}
	}
}
