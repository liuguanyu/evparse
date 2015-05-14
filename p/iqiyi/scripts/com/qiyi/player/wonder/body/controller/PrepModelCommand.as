package com.qiyi.player.wonder.body.controller
{
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.body.model.JavascriptAPIProxy;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.wonder.body.model.PlayerProxy;
	import com.qiyi.player.wonder.plugins.ad.ADPlugins;
	import com.qiyi.player.wonder.plugins.continueplay.ContinuePlayPlugins;
	import com.qiyi.player.wonder.plugins.controllbar.ControllBarPlugins;
	import com.qiyi.player.wonder.plugins.dock.DockPlugins;
	import com.qiyi.player.wonder.plugins.feedback.FeedbackPlugins;
	import com.qiyi.player.wonder.plugins.loading.LoadingPlugins;
	import com.qiyi.player.wonder.plugins.offlinewatch.OfflineWatchPlugins;
	import com.qiyi.player.wonder.plugins.recommend.RecommendPlugins;
	import com.qiyi.player.wonder.plugins.scenetile.SceneTilePlugins;
	import com.qiyi.player.wonder.plugins.setting.SettingPlugins;
	import com.qiyi.player.wonder.plugins.share.SharePlugins;
	import com.qiyi.player.wonder.plugins.tips.TipsPlugins;
	import com.qiyi.player.wonder.plugins.topbar.TopBarPlugins;
	import com.qiyi.player.wonder.plugins.videolink.VideoLinkPlugins;
	
	public class PrepModelCommand extends SimpleCommand
	{
		
		public function PrepModelCommand()
		{
			super();
		}
		
		override public function execute(param1:INotification) : void
		{
			super.execute(param1);
			var _loc2:JavascriptAPIProxy = new JavascriptAPIProxy();
			facade.registerProxy(_loc2);
			var _loc3:UserProxy = new UserProxy();
			facade.registerProxy(_loc3);
			var _loc4:PlayerProxy = new PlayerProxy();
			facade.registerProxy(_loc4);
			_loc2.injectUserProxy(_loc3);
			_loc2.injectPlayerProxy(_loc4);
			_loc3.injectPlayerProxy(_loc4);
			ADPlugins.getInstance().initModel();
			ContinuePlayPlugins.getInstance().initModel();
			ControllBarPlugins.getInstance().initModel();
			DockPlugins.getInstance().initModel();
			FeedbackPlugins.getInstance().initModel();
			LoadingPlugins.getInstance().initModel();
			OfflineWatchPlugins.getInstance().initModel();
			RecommendPlugins.getInstance().initModel();
			SceneTilePlugins.getInstance().initModel();
			SettingPlugins.getInstance().initModel();
			SharePlugins.getInstance().initModel();
			TipsPlugins.getInstance().initModel();
			TopBarPlugins.getInstance().initModel();
			VideoLinkPlugins.getInstance().initModel();
		}
	}
}
