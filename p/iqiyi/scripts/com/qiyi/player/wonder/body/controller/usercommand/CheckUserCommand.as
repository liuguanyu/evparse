package com.qiyi.player.wonder.body.controller.usercommand {
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.body.model.UserProxy;
	
	public class CheckUserCommand extends SimpleCommand {
		
		public function CheckUserCommand() {
			super();
		}
		
		override public function execute(param1:INotification) : void {
			super.execute(param1);
			var _loc2_:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			_loc2_.checkUser();
		}
	}
}
