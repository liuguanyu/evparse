package com.qiyi.player.wonder {
	import org.puremvc.as3.patterns.facade.Facade;
	import com.qiyi.player.wonder.body.BodyDef;
	import com.qiyi.player.wonder.body.controller.StartupCommand;
	import com.qiyi.player.wonder.body.controller.usercommand.CheckUserCommand;
	import com.qiyi.player.wonder.body.controller.playercommand.PlayerLoadMovieCommand;
	import com.qiyi.player.wonder.body.controller.initcommand.InitPlayerCommand;
	import com.qiyi.player.wonder.body.controller.initcommand.InitPlayCommand;
	import com.qiyi.player.wonder.body.controller.playercommand.PlayerPauseCommand;
	import com.qiyi.player.wonder.body.controller.playercommand.PlayerPlayCommand;
	import com.qiyi.player.wonder.body.controller.playercommand.PlayerRefreshCommand;
	import com.qiyi.player.wonder.body.controller.playercommand.PlayerReplayCommand;
	import com.qiyi.player.wonder.body.controller.playercommand.PlayerResumeCommand;
	import com.qiyi.player.wonder.body.controller.playercommand.PlayerSeekCommand;
	import com.qiyi.player.wonder.body.controller.playercommand.PlayerStartLoadCommand;
	import com.qiyi.player.wonder.body.controller.playercommand.PlayerStopLoadCommand;
	import com.qiyi.player.wonder.body.controller.playercommand.PlayerStopCommand;
	import com.qiyi.player.wonder.body.controller.usercommand.CheckTryWatchRefreshCommand;
	import com.qiyi.player.wonder.body.controller.jscommand.CallJSPlayerStatusCommand;
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
	import com.qiyi.player.wonder.common.pingback.PingBack;
	
	public class AppFacade extends Facade {
		
		public function AppFacade(param1:SingletonClass) {
			this.initializePingBack();
			this.initializePlugins();
			super();
		}
		
		public static var _instance:AppFacade;
		
		public static function getInstance() : AppFacade {
			if(_instance == null) {
				_instance = new AppFacade(new SingletonClass());
			}
			return _instance;
		}
		
		public function startup(param1:Object) : void {
			sendNotification(BodyDef.NOTIFIC_STARTUP,param1);
		}
		
		override protected function initializeController() : void {
			super.initializeController();
			registerCommand(BodyDef.NOTIFIC_STARTUP,StartupCommand);
			registerCommand(BodyDef.NOTIFIC_CHECK_USER,CheckUserCommand);
			registerCommand(BodyDef.NOTIFIC_PLAYER_LOAD_MOVIE,PlayerLoadMovieCommand);
			registerCommand(BodyDef.NOTIFIC_PLAYER_PRE_LOAD_MOVIE,PlayerLoadMovieCommand);
			registerCommand(BodyDef.NOTIFIC_INIT_PLAYER,InitPlayerCommand);
			registerCommand(BodyDef.NOTIFIC_INIT_PLAY,InitPlayCommand);
			registerCommand(BodyDef.NOTIFIC_PLAYER_PAUSE,PlayerPauseCommand);
			registerCommand(BodyDef.NOTIFIC_PLAYER_PLAY,PlayerPlayCommand);
			registerCommand(BodyDef.NOTIFIC_PLAYER_REFRESH,PlayerRefreshCommand);
			registerCommand(BodyDef.NOTIFIC_PLAYER_PRE_REFRESH,PlayerRefreshCommand);
			registerCommand(BodyDef.NOTIFIC_PLAYER_REPLAY,PlayerReplayCommand);
			registerCommand(BodyDef.NOTIFIC_PLAYER_RESUME,PlayerResumeCommand);
			registerCommand(BodyDef.NOTIFIC_PLAYER_SEEK,PlayerSeekCommand);
			registerCommand(BodyDef.NOTIFIC_PLAYER_START_LOAD,PlayerStartLoadCommand);
			registerCommand(BodyDef.NOTIFIC_PLAYER_PRE_START_LOAD,PlayerStartLoadCommand);
			registerCommand(BodyDef.NOTIFIC_PLAYER_STOP_LOAD,PlayerStopLoadCommand);
			registerCommand(BodyDef.NOTIFIC_PLAYER_PRE_STOP_LOAD,PlayerStopLoadCommand);
			registerCommand(BodyDef.NOTIFIC_PLAYER_STOP,PlayerStopCommand);
			registerCommand(BodyDef.NOTIFIC_PLAYER_PRE_STOP,PlayerStopCommand);
			registerCommand(BodyDef.NOTIFIC_CHECK_TRY_WATCH_REFRESH,CheckTryWatchRefreshCommand);
			registerCommand(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS,CallJSPlayerStatusCommand);
			ADPlugins.getInstance().initController();
			ContinuePlayPlugins.getInstance().initController();
			ControllBarPlugins.getInstance().initController();
			DockPlugins.getInstance().initController();
			FeedbackPlugins.getInstance().initController();
			LoadingPlugins.getInstance().initController();
			OfflineWatchPlugins.getInstance().initController();
			RecommendPlugins.getInstance().initController();
			SceneTilePlugins.getInstance().initController();
			SettingPlugins.getInstance().initController();
			SharePlugins.getInstance().initController();
			TipsPlugins.getInstance().initController();
			TopBarPlugins.getInstance().initController();
			VideoLinkPlugins.getInstance().initController();
		}
		
		private function initializePingBack() : void {
			PingBack.getInstance().init(this);
		}
		
		private function initializePlugins() : void {
			ADPlugins.getInstance().init(this);
			ContinuePlayPlugins.getInstance().init(this);
			ControllBarPlugins.getInstance().init(this);
			DockPlugins.getInstance().init(this);
			FeedbackPlugins.getInstance().init(this);
			LoadingPlugins.getInstance().init(this);
			OfflineWatchPlugins.getInstance().init(this);
			RecommendPlugins.getInstance().init(this);
			SceneTilePlugins.getInstance().init(this);
			SettingPlugins.getInstance().init(this);
			SharePlugins.getInstance().init(this);
			TipsPlugins.getInstance().init(this);
			TopBarPlugins.getInstance().init(this);
			VideoLinkPlugins.getInstance().init(this);
		}
	}
}
class SingletonClass extends Object {
	
	function SingletonClass() {
		super();
	}
}
