package com.qiyi.player.wonder.body.controller.playercommand {
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.body.model.PlayerProxy;
	import com.qiyi.player.wonder.common.pingback.PingBack;
	
	public class PlayerPlayCommand extends SimpleCommand {
		
		public function PlayerPlayCommand() {
			super();
		}
		
		override public function execute(param1:INotification) : void {
			super.execute(param1);
			var _loc2_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			_loc2_.curActor.play();
			PingBack.getInstance().playStartPing();
			PingBack.getInstance().startVisitsPing();
		}
	}
}
