package com.qiyi.player.wonder.body.controller.playercommand
{
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.body.model.PlayerProxy;
	import com.qiyi.player.wonder.body.BodyDef;
	import com.qiyi.player.wonder.common.pingback.PingBack;
	import com.qiyi.player.wonder.common.pingback.PingBackDef;
	
	public class PlayerPauseCommand extends SimpleCommand
	{
		
		public function PlayerPauseCommand()
		{
			super();
		}
		
		override public function execute(param1:INotification) : void
		{
			var _loc3:* = 0;
			super.execute(param1);
			var _loc2:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if((_loc2.curActor.hasStatus(BodyDef.PLAYER_STATUS_PLAYING)) || (_loc2.curActor.hasStatus(BodyDef.PLAYER_STATUS_SEEKING)) || (_loc2.curActor.hasStatus(BodyDef.PLAYER_STATUS_WAITING)))
			{
				_loc3 = param1.getBody() == null?0:int(param1.getBody());
				_loc2.curActor.pause(_loc3);
				PingBack.getInstance().userActionPing(PingBackDef.PAUSE,_loc2.curActor.currentTime);
			}
		}
	}
}
