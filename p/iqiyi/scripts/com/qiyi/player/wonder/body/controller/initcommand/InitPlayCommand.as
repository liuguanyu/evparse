package com.qiyi.player.wonder.body.controller.initcommand {
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.core.player.LoadMovieParams;
	import com.qiyi.player.wonder.common.config.FlashVarConfig;
	import com.qiyi.player.wonder.body.BodyDef;
	
	public class InitPlayCommand extends SimpleCommand {
		
		public function InitPlayCommand() {
			super();
		}
		
		override public function execute(param1:INotification) : void {
			var _loc2_:LoadMovieParams = null;
			super.execute(param1);
			if(FlashVarConfig.owner == FlashVarConfig.OWNER_PAGE || FlashVarConfig.owner == FlashVarConfig.OWNER_CLIENT && !(FlashVarConfig.vid == "")) {
				_loc2_ = new LoadMovieParams();
				_loc2_.tvid = FlashVarConfig.tvid;
				_loc2_.vid = FlashVarConfig.vid;
				_loc2_.movieIsMember = FlashVarConfig.isMemberMovie;
				_loc2_.albumId = FlashVarConfig.albumId;
				if(FlashVarConfig.shareStartTime >= 0) {
					_loc2_.startTime = FlashVarConfig.shareStartTime;
				}
				if(FlashVarConfig.shareEndTime > 0) {
					_loc2_.endTime = FlashVarConfig.shareEndTime;
				}
				sendNotification(BodyDef.NOTIFIC_PLAYER_LOAD_MOVIE,_loc2_,BodyDef.LOAD_MOVIE_TYPE_ORIGINAL);
			}
			facade.removeCommand(BodyDef.NOTIFIC_INIT_PLAY);
		}
	}
}
