package com.qiyi.player.wonder.plugins.share.view
{
	import org.puremvc.as3.patterns.mediator.Mediator;
	import com.qiyi.player.wonder.plugins.share.model.ShareProxy;
	import com.qiyi.player.wonder.plugins.share.ShareDef;
	import com.qiyi.player.wonder.body.BodyDef;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.plugins.ad.ADDef;
	import com.qiyi.player.wonder.body.model.PlayerProxy;
	import com.qiyi.player.core.model.IMovieModel;
	import com.qiyi.player.wonder.common.pingback.PingBack;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.core.model.IMovieInfo;
	import com.qiyi.player.base.utils.Utility;
	import com.qiyi.player.core.model.def.ChannelEnum;
	
	public class ShareViewMediator extends Mediator
	{
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.share.view.ShareViewMediator";
		
		private var _shareProxy:ShareProxy;
		
		private var _shareView:ShareView;
		
		public function ShareViewMediator(param1:ShareView)
		{
			super(NAME,param1);
			this._shareView = param1;
		}
		
		override public function onRegister() : void
		{
			super.onRegister();
			this._shareProxy = facade.retrieveProxy(ShareProxy.NAME) as ShareProxy;
			this._shareView.addEventListener(ShareEvent.Evt_Open,this.onShareViewOpen);
			this._shareView.addEventListener(ShareEvent.Evt_Close,this.onShareViewClose);
			this._shareView.addEventListener(ShareEvent.Evt_ShareBtnClick,this.onShareBtnClick);
		}
		
		override public function listNotificationInterests() : Array
		{
			return [ShareDef.NOTIFIC_ADD_STATUS,ShareDef.NOTIFIC_REMOVE_STATUS,BodyDef.NOTIFIC_RESIZE,BodyDef.NOTIFIC_CHECK_USER_COMPLETE,BodyDef.NOTIFIC_PLAYER_ADD_STATUS,BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR];
		}
		
		override public function handleNotification(param1:INotification) : void
		{
			super.handleNotification(param1);
			var _loc2:Object = param1.getBody();
			var _loc3:String = param1.getName();
			var _loc4:String = param1.getType();
			switch(_loc3)
			{
				case ShareDef.NOTIFIC_ADD_STATUS:
					if(int(_loc2) == ShareDef.STATUS_OPEN)
					{
						this.addOpenParam();
						sendNotification(ADDef.NOTIFIC_POPUP_OPEN);
					}
					this._shareView.onAddStatus(int(_loc2));
					break;
				case ShareDef.NOTIFIC_REMOVE_STATUS:
					if(int(_loc2) == ShareDef.STATUS_OPEN)
					{
						sendNotification(ADDef.NOTIFIC_POPUP_CLOSE);
					}
					this._shareView.onRemoveStatus(int(_loc2));
					break;
				case BodyDef.NOTIFIC_RESIZE:
					this._shareView.onResize(_loc2.w,_loc2.h);
					break;
				case BodyDef.NOTIFIC_CHECK_USER_COMPLETE:
					this.onCheckUserComplete();
					break;
				case BodyDef.NOTIFIC_PLAYER_ADD_STATUS:
					this.onPlayerStatusChanged(int(_loc2),true,_loc4);
					break;
				case BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR:
					this._shareProxy.removeStatus(ShareDef.STATUS_OPEN);
					break;
			}
		}
		
		private function onShareViewOpen(param1:ShareEvent) : void
		{
			if(!this._shareProxy.hasStatus(ShareDef.STATUS_OPEN))
			{
				this._shareProxy.addStatus(ShareDef.STATUS_OPEN);
			}
		}
		
		private function onShareViewClose(param1:ShareEvent) : void
		{
			if(this._shareProxy.hasStatus(ShareDef.STATUS_OPEN))
			{
				this._shareProxy.removeStatus(ShareDef.STATUS_OPEN);
			}
		}
		
		private function onShareBtnClick(param1:ShareEvent) : void
		{
			var _loc2:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc3:IMovieModel = _loc2.curActor.movieModel;
			PingBack.getInstance().videoSharePing(param1.data.toString(),0,_loc3.duration);
			sendNotification(BodyDef.NOTIFIC_PLAYER_PAUSE);
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
						this._shareProxy.removeStatus(ShareDef.STATUS_OPEN);
					}
					break;
				case BodyDef.PLAYER_STATUS_PLAYING:
					if(param2)
					{
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
			this._shareView.onUserInfoChanged(_loc2);
		}
		
		private function addOpenParam() : void
		{
			var _loc1:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2:IMovieModel = _loc1.curActor.movieModel;
			var _loc3:IMovieInfo = _loc1.curActor.movieInfo;
			var _loc4:* = true;
			if((_loc3.infoJSON) && (_loc3.infoJSON.plc) && (_loc3.infoJSON.plc[14]) && !(_loc3.infoJSON.plc[14].coa == 1))
			{
				_loc4 = false;
			}
			this._shareView.updateOpenParam(_loc1.curActor.getHtmlUrl(),_loc1.curActor.getSwfUrl(),_loc2.duration,Utility.getItemById(ChannelEnum.ITEMS,_loc2.channelID),_loc3.pageUrl,_loc3.title,_loc4);
		}
	}
}
