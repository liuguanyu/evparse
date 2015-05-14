package com.qiyi.player.wonder.plugins.recommend.view
{
	import org.puremvc.as3.patterns.mediator.Mediator;
	import com.qiyi.player.wonder.plugins.recommend.model.RecommendProxy;
	import com.qiyi.player.wonder.plugins.recommend.RecommendDef;
	import com.qiyi.player.wonder.body.BodyDef;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.plugins.ad.ADDef;
	import com.qiyi.player.wonder.common.pingback.PingBack;
	import com.qiyi.player.wonder.common.pingback.PingBackDef;
	import com.qiyi.player.wonder.plugins.recommend.model.RecommendVO;
	import com.iqiyi.components.global.GlobalStage;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import com.qiyi.player.wonder.body.model.PlayerProxy;
	import com.qiyi.player.wonder.plugins.continueplay.model.ContinuePlayProxy;
	import com.qiyi.player.core.model.def.ChannelEnum;
	import com.qiyi.player.wonder.common.config.SystemConfig;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.core.model.IMovieModel;
	import com.qiyi.player.user.impls.UserManager;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import com.adobe.serialization.json.JSON;
	
	public class RecommendViewMediator extends Mediator
	{
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.recommend.view.RecommendViewMediator";
		
		private var _recommendProxy:RecommendProxy;
		
		private var _recommendView:RecommendView;
		
		public function RecommendViewMediator(param1:RecommendView)
		{
			super(NAME,param1);
			this._recommendView = param1;
		}
		
		override public function onRegister() : void
		{
			super.onRegister();
			this._recommendProxy = facade.retrieveProxy(RecommendProxy.NAME) as RecommendProxy;
			this._recommendView.addEventListener(RecommendEvent.Evt_Finish_Open,this.onRecommendViewOpen);
			this._recommendView.addEventListener(RecommendEvent.Evt_Finish_Close,this.onRecommendViewClose);
			this._recommendView.addEventListener(RecommendEvent.Evt_ReplayVideo,this.onRecommendReplayVideo);
			this._recommendView.addEventListener(RecommendEvent.Evt_OpenVideo,this.onRecommendOpenVideo);
			this._recommendView.addEventListener(RecommendEvent.Evt_CustomizeItemClick,this.onCustomizeItemClick);
		}
		
		override public function listNotificationInterests() : Array
		{
			return [RecommendDef.NOTIFIC_ADD_STATUS,RecommendDef.NOTIFIC_REMOVE_STATUS,BodyDef.NOTIFIC_RESIZE,BodyDef.NOTIFIC_CHECK_USER_COMPLETE,BodyDef.NOTIFIC_PLAYER_ADD_STATUS,BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR,BodyDef.NOTIFIC_PLAYER_REPLAYED];
		}
		
		override public function handleNotification(param1:INotification) : void
		{
			super.handleNotification(param1);
			var _loc2:Object = param1.getBody();
			var _loc3:String = param1.getName();
			var _loc4:String = param1.getType();
			switch(_loc3)
			{
				case RecommendDef.NOTIFIC_ADD_STATUS:
					if(int(_loc2) == RecommendDef.STATUS_FINISH_RECOMMEND_OPEN)
					{
						this.createRecommend();
					}
					this._recommendView.onAddStatus(int(_loc2));
					break;
				case RecommendDef.NOTIFIC_REMOVE_STATUS:
					this._recommendView.onRemoveStatus(int(_loc2));
					break;
				case BodyDef.NOTIFIC_RESIZE:
					this._recommendView.onResize(_loc2.w,_loc2.h);
					break;
				case BodyDef.NOTIFIC_CHECK_USER_COMPLETE:
					this.onCheckUserComplete();
					break;
				case BodyDef.NOTIFIC_PLAYER_ADD_STATUS:
					this.onPlayerStatusChanged(int(_loc2),true,_loc4);
					break;
				case BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR:
					this._recommendProxy.removeStatus(RecommendDef.STATUS_FINISH_RECOMMEND_OPEN);
					break;
				case BodyDef.NOTIFIC_PLAYER_REPLAYED:
					if(_loc4 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
					{
						this._recommendProxy.removeStatus(RecommendDef.STATUS_FINISH_RECOMMEND_OPEN);
					}
					break;
			}
		}
		
		private function onRecommendViewOpen(param1:RecommendEvent) : void
		{
			if(!this._recommendProxy.hasStatus(RecommendDef.STATUS_FINISH_RECOMMEND_OPEN))
			{
				this._recommendProxy.addStatus(RecommendDef.STATUS_FINISH_RECOMMEND_OPEN);
			}
		}
		
		private function onRecommendViewClose(param1:RecommendEvent) : void
		{
			if(this._recommendProxy.hasStatus(RecommendDef.STATUS_FINISH_RECOMMEND_OPEN))
			{
				this._recommendProxy.removeStatus(RecommendDef.STATUS_FINISH_RECOMMEND_OPEN);
			}
		}
		
		private function onRecommendReplayVideo(param1:RecommendEvent) : void
		{
			sendNotification(ADDef.NOTIFIC_REQUEST_REPLAY_VIDEO);
			PingBack.getInstance().userActionPing(PingBackDef.REPLAY);
		}
		
		private function onRecommendOpenVideo(param1:RecommendEvent) : void
		{
			var _loc2:RecommendVO = param1.data as RecommendVO;
			GlobalStage.setNormalScreen();
			PingBack.getInstance().recommendSelectionPing(_loc2.playUrl,String(_loc2.seatID));
			PingBack.getInstance().recommendClick4QiyuPing(_loc2.albumID,this._recommendProxy.getEventID(this._recommendProxy.playFinishJson),this._recommendProxy.getBkt(this._recommendProxy.playFinishJson),this._recommendProxy.getArea(this._recommendProxy.playFinishJson),_loc2.seatID.toString(),_loc2.playUrl,_loc2.channel);
			navigateToURL(new URLRequest(_loc2.playUrl),"_self");
		}
		
		private function onCustomizeItemClick(param1:RecommendEvent) : void
		{
			if(GlobalStage.isFullScreen())
			{
				GlobalStage.setNormalScreen();
			}
			var _loc2:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc3:ContinuePlayProxy = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
			if(_loc2.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY))
			{
				if(_loc2.curActor.movieInfo.channel == ChannelEnum.FINANCE)
				{
					navigateToURL(new URLRequest(SystemConfig.RECOMMEND_CUSTOMIZE_FINANCE_URL),"_blank");
				}
				else if(_loc2.curActor.movieInfo.channel == ChannelEnum.ENTERTAINMENT)
				{
					navigateToURL(new URLRequest(SystemConfig.RECOMMEND_CUSTOMIZE_ENTERTAINMENT_URL),"_blank");
				}
				else
				{
					navigateToURL(new URLRequest(SystemConfig.RECOMMEND_CUSTOMIZE_NEWS_URL),"_blank");
				}
				
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
			this._recommendView.onUserInfoChanged(_loc2);
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
				case BodyDef.PLAYER_STATUS_PLAYING:
					if(param2)
					{
						this._recommendProxy.removeStatus(RecommendDef.STATUS_FINISH_RECOMMEND_OPEN);
					}
					break;
			}
		}
		
		private function createRecommend() : void
		{
			var _loc1:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2:ContinuePlayProxy = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
			var _loc3:IMovieModel = _loc1.curActor.movieModel;
			var _loc4:String = UserManager.getInstance().user?UserManager.getInstance().user.profileID:"";
			var _loc5:* = SystemConfig.RECOMMEND_URL + "area=" + SystemConfig.RECOMMEND_PPC_AREA + "&referenceId=" + _loc3.tvid + "&channelId=" + (_loc2.taid != ""?int(_loc2.tcid):_loc3.channelID) + "&albumId=" + (_loc2.tcid != ""?_loc2.taid:_loc3.albumId) + "&page=1" + "&type=video" + "&withRefer=true" + "&profileId=" + _loc4 + "&size=27";
			var _loc6:URLLoader = new URLLoader();
			_loc6.addEventListener(Event.COMPLETE,this.onUrlLoaderComplete);
			_loc6.addEventListener(IOErrorEvent.IO_ERROR,this.onUrlLoaderError);
			_loc6.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onUrlLoaderError);
			_loc6.load(new URLRequest(_loc5));
		}
		
		private function onUrlLoaderComplete(param1:Event) : void
		{
			var playerProxy:PlayerProxy = null;
			var var_5:Event = param1;
			var urlLoader:URLLoader = var_5.target as URLLoader;
			try
			{
				this._recommendProxy.playFinishJson = com.adobe.serialization.json.JSON.decode(urlLoader.data);
				playerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
				this._recommendView.recommendData(this._recommendProxy.playFinishDataVector,playerProxy.curActor.movieInfo.channel.id);
				PingBack.getInstance().recommendLoadDoneSend(this._recommendProxy.getRecommendIDString(this._recommendProxy.playFinishDataVector),this._recommendProxy.getEventID(this._recommendProxy.playFinishJson),this._recommendProxy.getBkt(this._recommendProxy.playFinishJson),this._recommendProxy.getArea(this._recommendProxy.playFinishJson));
			}
			catch(e:Error)
			{
			}
			urlLoader.removeEventListener(Event.COMPLETE,this.onUrlLoaderComplete);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onUrlLoaderError);
			urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onUrlLoaderError);
			urlLoader = null;
		}
		
		private function onUrlLoaderError(param1:Event) : void
		{
			var _loc2:URLLoader = param1.target as URLLoader;
			_loc2.removeEventListener(Event.COMPLETE,this.onUrlLoaderComplete);
			_loc2.removeEventListener(IOErrorEvent.IO_ERROR,this.onUrlLoaderError);
			_loc2.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onUrlLoaderError);
			_loc2 = null;
		}
	}
}
