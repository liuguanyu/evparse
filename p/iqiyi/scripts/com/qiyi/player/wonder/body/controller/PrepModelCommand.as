package com.qiyi.player.wonder.body.controller {
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
	
	public class PrepModelCommand extends SimpleCommand {
		
		public function PrepModelCommand() {
			super();
		}
		
		override public function execute(param1:INotification) : void {
			super.execute(param1);
			var _loc2_:JavascriptAPIProxy = new JavascriptAPIProxy();
			facade.registerProxy(_loc2_);
			var _loc3_:UserProxy = new UserProxy();
			facade.registerProxy(_loc3_);
			var _loc4_:PlayerProxy = new PlayerProxy();
			facade.registerProxy(_loc4_);
			_loc2_.injectUserProxy(_loc3_);
			_loc2_.injectPlayerProxy(_loc4_);
			_loc3_.injectPlayerProxy(_loc4_);
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
