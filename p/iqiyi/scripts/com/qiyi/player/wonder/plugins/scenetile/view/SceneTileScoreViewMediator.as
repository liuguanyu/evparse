package com.qiyi.player.wonder.plugins.scenetile.view
{
	import org.puremvc.as3.patterns.mediator.Mediator;
	import com.qiyi.player.wonder.plugins.scenetile.model.SceneTileProxy;
	import com.qiyi.player.wonder.plugins.scenetile.SceneTileDef;
	import com.qiyi.player.wonder.body.BodyDef;
	import com.qiyi.player.wonder.plugins.videolink.VideoLinkDef;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.body.model.PlayerProxy;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.wonder.common.pingback.PingBack;
	import com.qiyi.player.wonder.common.pingback.PingBackDef;
	import com.qiyi.player.wonder.body.model.JavascriptAPIProxy;
	import com.iqiyi.components.global.GlobalStage;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	
	public class SceneTileScoreViewMediator extends Mediator
	{
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.scenetile.view.SceneTileScoreViewMediator";
		
		private var _sceneTileProxy:SceneTileProxy;
		
		private var _sceneTileScoreView:SceneTileScoreView;
		
		public function SceneTileScoreViewMediator(param1:SceneTileScoreView)
		{
			super(NAME,param1);
			this._sceneTileScoreView = param1;
		}
		
		override public function onRegister() : void
		{
			super.onRegister();
			this._sceneTileProxy = facade.retrieveProxy(SceneTileProxy.NAME) as SceneTileProxy;
			this._sceneTileScoreView.addEventListener(SceneTileEvent.Evt_ScoreOpen,this.onSceneTileScoreViewOpen);
			this._sceneTileScoreView.addEventListener(SceneTileEvent.Evt_ScoreSuccessOpen,this.onSceneTileScoreSuccessViewOpen);
			this._sceneTileScoreView.addEventListener(SceneTileEvent.Evt_ScoreClose,this.onSceneTileScoreViewClose);
			this._sceneTileScoreView.addEventListener(SceneTileEvent.Evt_ScoreHeartClick,this.onScoreHeartClick);
		}
		
		override public function listNotificationInterests() : Array
		{
			return [SceneTileDef.NOTIFIC_ADD_STATUS,SceneTileDef.NOTIFIC_REMOVE_STATUS,BodyDef.NOTIFIC_RESIZE,BodyDef.NOTIFIC_CHECK_USER_COMPLETE,BodyDef.NOTIFIC_PLAYER_ADD_STATUS,BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR,BodyDef.NOTIFIC_JS_CALL_SET_LOGIN_SOURCE,VideoLinkDef.NOTIFIC_ADD_STATUS];
		}
		
		override public function handleNotification(param1:INotification) : void
		{
			var _loc5:PlayerProxy = null;
			var _loc6:UserProxy = null;
			super.handleNotification(param1);
			var _loc2:Object = param1.getBody();
			var _loc3:String = param1.getName();
			var _loc4:String = param1.getType();
			switch(_loc3)
			{
				case SceneTileDef.NOTIFIC_ADD_STATUS:
					if(int(_loc2) == SceneTileDef.STATUS_SCORE_OPEN)
					{
						_loc5 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
						if(_loc5.curActor.movieModel)
						{
							this._sceneTileScoreView.initScorePanel(_loc5.curActor.movieInfo.title,this._sceneTileProxy.curScoreNum);
						}
						PingBack.getInstance().userActionPing(PingBackDef.SCORE_PANEL_SHOW);
					}
					else if(int(_loc2) == SceneTileDef.STATUS_SCORE_SUCCESS_OPEN)
					{
						_loc6 = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
						this._sceneTileScoreView.initScoreSuccessPanel(_loc6.isLogin);
					}
					
					this._sceneTileScoreView.onAddStatus(int(_loc2));
					break;
				case SceneTileDef.NOTIFIC_REMOVE_STATUS:
					this._sceneTileScoreView.onRemoveStatus(int(_loc2));
					break;
				case BodyDef.NOTIFIC_RESIZE:
					this._sceneTileScoreView.onResize(_loc2.w,_loc2.h);
					break;
				case BodyDef.NOTIFIC_CHECK_USER_COMPLETE:
					this.onCheckUserComplete();
					break;
				case BodyDef.NOTIFIC_PLAYER_ADD_STATUS:
					this.onPlayerStatusChanged(int(_loc2),true,_loc4);
					break;
				case BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR:
					this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_SCORE_OPEN);
					this._sceneTileProxy.isOpenAtFinish = this._sceneTileProxy.isOpenAtMidway = this._sceneTileProxy.isScored = false;
					this._sceneTileProxy.selectedScore = -1;
					break;
				case BodyDef.NOTIFIC_JS_CALL_SET_LOGIN_SOURCE:
					if(String(_loc2) == BodyDef.JS_LOGIN_STATUS_SOURCE_SCORE && this._sceneTileProxy.selectedScore > 0)
					{
						PingBack.getInstance().sendFilmScore(this._sceneTileProxy.selectedScore);
						PingBack.getInstance().sendFilmScoreRecommend(this._sceneTileProxy.selectedScore);
						if(this._sceneTileProxy.hasStatus(SceneTileDef.STATUS_SCORE_SUCCESS_OPEN))
						{
							this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_SCORE_SUCCESS_OPEN);
						}
						this._sceneTileProxy.addStatus(SceneTileDef.STATUS_SCORE_SUCCESS_OPEN);
					}
					break;
				case VideoLinkDef.NOTIFIC_ADD_STATUS:
					if(int(_loc2) == VideoLinkDef.STATUS_OPEN)
					{
						this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_SCORE_OPEN);
					}
					break;
			}
		}
		
		private function onSceneTileScoreViewOpen(param1:SceneTileEvent) : void
		{
			if(!this._sceneTileProxy.hasStatus(SceneTileDef.STATUS_SCORE_OPEN))
			{
				this._sceneTileProxy.addStatus(SceneTileDef.STATUS_SCORE_OPEN);
			}
		}
		
		private function onSceneTileScoreSuccessViewOpen(param1:SceneTileEvent) : void
		{
			if(!this._sceneTileProxy.hasStatus(SceneTileDef.STATUS_SCORE_SUCCESS_OPEN))
			{
				this._sceneTileProxy.addStatus(SceneTileDef.STATUS_SCORE_SUCCESS_OPEN);
			}
		}
		
		private function onSceneTileScoreViewClose(param1:SceneTileEvent) : void
		{
			if(this._sceneTileProxy.hasStatus(SceneTileDef.STATUS_SCORE_OPEN))
			{
				this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_SCORE_OPEN);
			}
			if(this._sceneTileProxy.hasStatus(SceneTileDef.STATUS_SCORE_SUCCESS_OPEN))
			{
				this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_SCORE_SUCCESS_OPEN);
			}
		}
		
		private function onScoreHeartClick(param1:SceneTileEvent) : void
		{
			var _loc3:JavascriptAPIProxy = null;
			this._sceneTileProxy.isScored = true;
			this._sceneTileProxy.selectedScore = int(param1.data) + 1;
			PingBack.getInstance().sendFilmScore(this._sceneTileProxy.selectedScore);
			PingBack.getInstance().sendFilmScoreRecommend(this._sceneTileProxy.selectedScore);
			var _loc2:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			if(!_loc2.isLogin)
			{
				GlobalStage.setNormalScreen();
				_loc3 = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
				_loc3.callJsShowLoginPanel(BodyDef.JS_LOGIN_STATUS_SOURCE_SCORE);
			}
			this._sceneTileProxy.addStatus(SceneTileDef.STATUS_SCORE_SUCCESS_OPEN);
		}
		
		private function onPlayerStatusChanged(param1:int, param2:Boolean, param3:String) : void
		{
			if(param3 != BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
			{
				return;
			}
			switch(param1)
			{
				case BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE:
				case BodyDef.PLAYER_STATUS_STOPED:
				case BodyDef.PLAYER_STATUS_FAILED:
					if(param2)
					{
						this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_SCORE_OPEN);
						this._sceneTileProxy.isOpenAtFinish = this._sceneTileProxy.isOpenAtMidway = this._sceneTileProxy.isScored = false;
						this._sceneTileProxy.selectedScore = -1;
					}
					break;
			}
		}
		
		private function onCheckUserComplete() : void
		{
			var _loc1:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			var _loc2:UserInfoVO = new UserInfoVO();
			_loc2.isLogin = _loc1.isLogin;
			_loc2.passportID = _loc1.passportID;
			_loc2.userID = _loc1.userID;
			_loc2.userName = _loc1.userName;
			_loc2.userLevel = _loc1.userLevel;
			_loc2.userType = _loc1.userType;
			this._sceneTileScoreView.onUserInfoChanged(_loc2);
		}
	}
}
