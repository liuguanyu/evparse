package com.qiyi.player.wonder.body.controller {
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.body.view.AppViewMediator;
	
	public class PrepViewCommand extends SimpleCommand {
		
		public function PrepViewCommand() {
			super();
		}
		
		override public function execute(param1:INotification) : void {
			super.execute(param1);
			var _loc2_:Player = param1.getBody() as Player;
			if(!facade.hasMediator(AppViewMediator.NAME)) {
				facade.registerMediator(new AppViewMediator(_loc2_.appView));
			}
		}
	}
}
