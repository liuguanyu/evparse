package com.qiyi.player.wonder.body.controller.playercommand
{
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.core.player.LoadMovieParams;
	import com.qiyi.player.wonder.body.model.PlayerProxy;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.wonder.body.BodyDef;
	import com.qiyi.player.wonder.common.config.FlashVarConfig;
	import com.qiyi.player.user.UserDef;
	import com.qiyi.player.core.model.def.DefinitionEnum;
	
	public class PlayerLoadMovieCommand extends SimpleCommand
	{
		
		public function PlayerLoadMovieCommand()
		{
			super();
		}
		
		override public function execute(param1:INotification) : void
		{
			super.execute(param1);
			var _loc2:LoadMovieParams = (param1.getBody() as LoadMovieParams).clone();
			var _loc3:String = param1.getType();
			var _loc4:String = param1.getName();
			var _loc5:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc6:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			_loc2.recordHistory = true;
			_loc2.prepareToPlayEnd = BodyDef.PLAYER_PREPARE_TO_PLAY_END_TIME;
			_loc2.prepareLeaveSkipPoint = BodyDef.FILTER_OUT_ENJOYABLE_TIME;
			_loc2.collectionID = FlashVarConfig.collectionID;
			if((_loc6.isLogin) && !(_loc6.userLevel == UserDef.USER_LEVEL_NORMAL))
			{
				_loc2.autoDefinitionlimit = DefinitionEnum.FULL_HD;
			}
			else
			{
				_loc2.autoDefinitionlimit = DefinitionEnum.HIGH;
			}
			if(_loc4 == BodyDef.NOTIFIC_PLAYER_LOAD_MOVIE)
			{
				_loc5.curActor.loadMovie(_loc2,_loc3);
			}
			else if(_loc4 == BodyDef.NOTIFIC_PLAYER_PRE_LOAD_MOVIE)
			{
				_loc5.preActor.loadMovie(_loc2,_loc3);
			}
			
		}
	}
}
