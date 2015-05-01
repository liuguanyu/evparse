package com.qiyi.player.wonder.body.controller.playercommand {
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.core.player.LoadMovieParams;
	import com.qiyi.player.wonder.body.model.PlayerProxy;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.wonder.body.BodyDef;
	import com.qiyi.player.wonder.common.config.FlashVarConfig;
	import com.qiyi.player.user.UserDef;
	import com.qiyi.player.core.model.def.DefinitionEnum;
	
	public class PlayerLoadMovieCommand extends SimpleCommand {
		
		public function PlayerLoadMovieCommand() {
			super();
		}
		
		override public function execute(param1:INotification) : void {
			super.execute(param1);
			var _loc2_:LoadMovieParams = (param1.getBody() as LoadMovieParams).clone();
			var _loc3_:String = param1.getType();
			var _loc4_:String = param1.getName();
			var _loc5_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc6_:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			_loc2_.recordHistory = true;
			_loc2_.prepareToPlayEnd = BodyDef.PLAYER_PREPARE_TO_PLAY_END_TIME;
			_loc2_.prepareLeaveSkipPoint = BodyDef.FILTER_OUT_ENJOYABLE_TIME;
			_loc2_.collectionID = FlashVarConfig.collectionID;
			if((_loc6_.isLogin) && !(_loc6_.userLevel == UserDef.USER_LEVEL_NORMAL)) {
				_loc2_.autoDefinitionlimit = DefinitionEnum.FULL_HD;
			} else {
				_loc2_.autoDefinitionlimit = DefinitionEnum.HIGH;
			}
			if(_loc4_ == BodyDef.NOTIFIC_PLAYER_LOAD_MOVIE) {
				_loc5_.curActor.loadMovie(_loc2_,_loc3_);
			} else if(_loc4_ == BodyDef.NOTIFIC_PLAYER_PRE_LOAD_MOVIE) {
				_loc5_.preActor.loadMovie(_loc2_,_loc3_);
			}
			
		}
	}
}
