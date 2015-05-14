package com.qiyi.player.wonder.body.controller.initcommand
{
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.wonder.common.config.FlashVarConfig;
	import com.qiyi.player.wonder.body.BodyDef;
	
	public class InitLoginStateCommand extends SimpleCommand
	{
		
		public function InitLoginStateCommand()
		{
			super();
		}
		
		override public function execute(param1:INotification) : void
		{
			super.execute(param1);
			var _loc2:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			if(FlashVarConfig.passportID)
			{
				_loc2.isLogin = true;
				_loc2.passportID = FlashVarConfig.passportID;
				_loc2.P00001 = FlashVarConfig.P00001;
				_loc2.profileID = FlashVarConfig.profileID;
				_loc2.profileCookie = FlashVarConfig.profileCookie;
			}
			sendNotification(BodyDef.NOTIFIC_CHECK_USER);
		}
	}
}
