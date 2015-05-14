package com.qiyi.player.wonder.body.controller.usercommand
{
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.body.model.PlayerProxy;
	import com.qiyi.player.wonder.body.BodyDef;
	
	public class CheckTryWatchRefreshCommand extends SimpleCommand
	{
		
		public function CheckTryWatchRefreshCommand()
		{
			super();
		}
		
		override public function execute(param1:INotification) : void
		{
			super.execute(param1);
			var _loc2:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(((_loc2.curActor.hasStatus(BodyDef.PLAYER_STATUS_FAILED)) || (_loc2.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_START_LOAD)) || (_loc2.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY))) && !_loc2.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPED) && !_loc2.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPPING))
			{
				if(_loc2.curActor.loadMovieParams.movieIsMember)
				{
					sendNotification(BodyDef.NOTIFIC_PLAYER_REFRESH);
				}
			}
			if((_loc2.preActor.hasStatus(BodyDef.PLAYER_STATUS_FAILED)) || (_loc2.preActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_START_LOAD)))
			{
				if(_loc2.preActor.loadMovieParams.movieIsMember)
				{
					sendNotification(BodyDef.NOTIFIC_PLAYER_PRE_REFRESH);
				}
			}
		}
	}
}
