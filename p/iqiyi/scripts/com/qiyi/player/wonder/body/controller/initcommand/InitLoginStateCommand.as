package com.qiyi.player.wonder.body.controller.initcommand {
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.wonder.common.config.FlashVarConfig;
	import com.qiyi.player.wonder.body.BodyDef;
	
	public class InitLoginStateCommand extends SimpleCommand {
		
		public function InitLoginStateCommand() {
			super();
		}
		
		override public function execute(param1:INotification) : void {
			super.execute(param1);
			var _loc2_:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			if(FlashVarConfig.passportID) {
				_loc2_.isLogin = true;
				_loc2_.passportID = FlashVarConfig.passportID;
				_loc2_.P00001 = FlashVarConfig.P00001;
				_loc2_.profileID = FlashVarConfig.profileID;
				_loc2_.profileCookie = FlashVarConfig.profileCookie;
			}
			sendNotification(BodyDef.NOTIFIC_CHECK_USER);
		}
	}
}
