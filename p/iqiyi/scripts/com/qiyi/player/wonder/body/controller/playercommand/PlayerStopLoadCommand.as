package com.qiyi.player.wonder.body.controller.playercommand
{
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.body.model.PlayerProxy;
	import com.qiyi.player.wonder.body.BodyDef;
	
	public class PlayerStopLoadCommand extends SimpleCommand
	{
		
		public function PlayerStopLoadCommand()
		{
			super();
		}
		
		override public function execute(param1:INotification) : void
		{
			super.execute(param1);
			var _loc2:String = param1.getName();
			var _loc3:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc2 == BodyDef.NOTIFIC_PLAYER_STOP_LOAD)
			{
				_loc3.curActor.stopLoad();
			}
			else if(_loc2 == BodyDef.NOTIFIC_PLAYER_PRE_STOP_LOAD)
			{
				_loc3.preActor.stopLoad();
			}
			
		}
	}
}
