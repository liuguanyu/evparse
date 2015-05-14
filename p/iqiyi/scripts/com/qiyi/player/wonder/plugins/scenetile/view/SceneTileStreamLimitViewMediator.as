package com.qiyi.player.wonder.plugins.scenetile.view
{
	import org.puremvc.as3.patterns.mediator.Mediator;
	import com.qiyi.player.wonder.plugins.scenetile.model.SceneTileProxy;
	import com.qiyi.player.wonder.plugins.scenetile.SceneTileDef;
	import com.qiyi.player.wonder.body.BodyDef;
	import com.qiyi.player.wonder.plugins.videolink.VideoLinkDef;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.body.model.PlayerProxy;
	import com.qiyi.player.wonder.common.pingback.PingBack;
	import com.qiyi.player.wonder.common.pingback.PingBackDef;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	
	public class SceneTileStreamLimitViewMediator extends Mediator
	{
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.scenetile.view.SceneTileStreamLimitViewMediator";
		
		private var _sceneTileProxy:SceneTileProxy;
		
		private var _sceneTileStreamLimitView:SceneTileStreamLimitView;
		
		public function SceneTileStreamLimitViewMediator(param1:SceneTileStreamLimitView)
		{
			super(NAME,param1);
			this._sceneTileStreamLimitView = param1;
		}
		
		override public function onRegister() : void
		{
			super.onRegister();
			this._sceneTileProxy = facade.retrieveProxy(SceneTileProxy.NAME) as SceneTileProxy;
			this._sceneTileStreamLimitView.addEventListener(SceneTileEvent.Evt_DefinitLimitOpen,this.onSceneTileDefinitLimitViewOpen);
			this._sceneTileStreamLimitView.addEventListener(SceneTileEvent.Evt_DefinitLimitClose,this.onSceneTileDefinitLimitViewClose);
		}
		
		override public function listNotificationInterests() : Array
		{
			return [SceneTileDef.NOTIFIC_ADD_STATUS,SceneTileDef.NOTIFIC_REMOVE_STATUS,BodyDef.NOTIFIC_RESIZE,BodyDef.NOTIFIC_CHECK_USER_COMPLETE,BodyDef.NOTIFIC_PLAYER_ADD_STATUS,BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR,VideoLinkDef.NOTIFIC_ADD_STATUS];
		}
		
		override public function handleNotification(param1:INotification) : void
		{
			var _loc5:PlayerProxy = null;
			super.handleNotification(param1);
			var _loc2:Object = param1.getBody();
			var _loc3:String = param1.getName();
			var _loc4:String = param1.getType();
			switch(_loc3)
			{
				case SceneTileDef.NOTIFIC_ADD_STATUS:
					if(int(_loc2) == SceneTileDef.STATUS_STREAM_LIMIT_OPEN)
					{
						_loc5 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
						if(_loc5.curActor.movieModel)
						{
							this._sceneTileStreamLimitView.setPanelAttribute(this._sceneTileProxy.limitDifinition,_loc5.curActor.movieModel.qualityDefinitionControlType,_loc5.curActor.movieModel.qualityDefinitionControlTimeRange);
						}
						PingBack.getInstance().showActionPing_4_0(PingBackDef.DEFIN_LIMIT_SHOWCLICK);
					}
					this._sceneTileStreamLimitView.onAddStatus(int(_loc2));
					break;
				case SceneTileDef.NOTIFIC_REMOVE_STATUS:
					this._sceneTileStreamLimitView.onRemoveStatus(int(_loc2));
					break;
				case BodyDef.NOTIFIC_RESIZE:
					this._sceneTileStreamLimitView.onResize(_loc2.w,_loc2.h);
					break;
				case BodyDef.NOTIFIC_CHECK_USER_COMPLETE:
					this.onCheckUserComplete();
					break;
				case BodyDef.NOTIFIC_PLAYER_ADD_STATUS:
					this.onPlayerStatusChanged(int(_loc2),true,_loc4);
					break;
				case BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR:
					this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_STREAM_LIMIT_OPEN);
					break;
				case VideoLinkDef.NOTIFIC_ADD_STATUS:
					if(int(_loc2) == VideoLinkDef.STATUS_OPEN)
					{
						this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_STREAM_LIMIT_OPEN);
					}
					break;
			}
		}
		
		private function onSceneTileDefinitLimitViewOpen(param1:SceneTileEvent) : void
		{
			if(!this._sceneTileProxy.hasStatus(SceneTileDef.STATUS_STREAM_LIMIT_OPEN))
			{
				this._sceneTileProxy.addStatus(SceneTileDef.STATUS_STREAM_LIMIT_OPEN);
			}
		}
		
		private function onSceneTileDefinitLimitViewClose(param1:SceneTileEvent) : void
		{
			if(this._sceneTileProxy.hasStatus(SceneTileDef.STATUS_STREAM_LIMIT_OPEN))
			{
				this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_STREAM_LIMIT_OPEN);
			}
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
						this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_STREAM_LIMIT_OPEN);
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
			this._sceneTileStreamLimitView.onUserInfoChanged(_loc2);
		}
	}
}
