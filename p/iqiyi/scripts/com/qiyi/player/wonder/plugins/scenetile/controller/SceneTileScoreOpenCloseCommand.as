package com.qiyi.player.wonder.plugins.scenetile.controller
{
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.plugins.scenetile.model.SceneTileProxy;
	import com.qiyi.player.wonder.body.model.PlayerProxy;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.user.impls.UserManager;
	
	public class SceneTileScoreOpenCloseCommand extends SimpleCommand
	{
		
		public function SceneTileScoreOpenCloseCommand()
		{
			super();
		}
		
		override public function execute(param1:INotification) : void
		{
			super.execute(param1);
			var _loc2:SceneTileProxy = facade.retrieveProxy(SceneTileProxy.NAME) as SceneTileProxy;
			var _loc3:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc4:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			var _loc5:String = UserManager.getInstance().user?UserManager.getInstance().user.passportID:"";
			var _loc6:String = UserManager.getInstance().user?UserManager.getInstance().user.profileID:"";
			if(_loc3.curActor.movieModel)
			{
				_loc2.requestScored(_loc3.curActor.movieModel.tvid,_loc5,_loc3.curActor.uuid,_loc6);
			}
		}
	}
}
