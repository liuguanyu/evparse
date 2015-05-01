package com.qiyi.player.wonder.body.controller.playercommand {
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.body.model.PlayerProxy;
	import com.qiyi.player.wonder.body.BodyDef;
	
	public class PlayerStopCommand extends SimpleCommand {
		
		public function PlayerStopCommand() {
			super();
		}
		
		override public function execute(param1:INotification) : void {
			super.execute(param1);
			var _loc2_:String = param1.getName();
			var _loc3_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc2_ == BodyDef.NOTIFIC_PLAYER_STOP) {
				_loc3_.curActor.stop();
			} else if(_loc2_ == BodyDef.NOTIFIC_PLAYER_PRE_STOP) {
				_loc3_.preActor.stop();
			}
			
		}
	}
}
