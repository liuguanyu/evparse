package com.qiyi.player.wonder.body.controller.playercommand
{
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.body.model.PlayerProxy;
	import com.qiyi.player.wonder.body.BodyDef;
	
	public class PlayerStartLoadCommand extends SimpleCommand
	{
		
		public function PlayerStartLoadCommand()
		{
			super();
		}
		
		override public function execute(param1:INotification) : void
		{
			super.execute(param1);
			var _loc2:String = param1.getName();
			var _loc3:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc2 == BodyDef.NOTIFIC_PLAYER_START_LOAD)
			{
				_loc3.curActor.startLoad();
			}
			else if(_loc2 == BodyDef.NOTIFIC_PLAYER_PRE_START_LOAD)
			{
				_loc3.preActor.startLoad();
			}
			
		}
	}
}
