package com.qiyi.player.wonder.body.controller.playercommand {
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.body.model.PlayerProxy;
	
	public class PlayerSeekCommand extends SimpleCommand {
		
		public function PlayerSeekCommand() {
			super();
		}
		
		override public function execute(param1:INotification) : void {
			super.execute(param1);
			var _loc2_:int = int(param1.getBody().time);
			var _loc3_:int = int(param1.getBody().type);
			var _loc4_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			_loc4_.curActor.seek(_loc2_,_loc3_);
		}
	}
}
