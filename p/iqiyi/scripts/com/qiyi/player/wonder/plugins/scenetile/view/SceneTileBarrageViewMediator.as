package com.qiyi.player.wonder.plugins.scenetile.view
{
	import org.puremvc.as3.patterns.mediator.Mediator;
	import com.qiyi.player.wonder.plugins.scenetile.model.SceneTileProxy;
	import com.qiyi.player.wonder.body.model.PlayerProxy;
	import com.qiyi.player.base.logging.ILogger;
	import flash.events.Event;
	import com.qiyi.player.wonder.plugins.scenetile.SceneTileDef;
	import com.qiyi.player.wonder.body.BodyDef;
	import com.qiyi.player.wonder.plugins.ad.ADDef;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.plugins.scenetile.model.barrage.BarrageInfo;
	import com.qiyi.player.wonder.body.model.JavascriptAPIProxy;
	import com.qiyi.player.wonder.plugins.scenetile.model.barrage.socket.BarrageSocket;
	import com.adobe.serialization.json.JSON;
	import com.qiyi.player.wonder.common.config.FlashVarConfig;
	import com.qiyi.player.wonder.plugins.ad.model.ADProxy;
	import com.qiyi.player.wonder.common.pingback.PingBack;
	import com.iqiyi.components.global.GlobalStage;
	import com.qiyi.player.wonder.plugins.scenetile.view.barragepart.BarrageItem;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.base.logging.Log;
	
	public class SceneTileBarrageViewMediator extends Mediator
	{
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.scenetile.view.SceneTileBarrageViewMediator";
		
		private var _sceneTileProxy:SceneTileProxy;
		
		private var _playerProxy:PlayerProxy;
		
		private var _sceneTileView:SceneTileBarrageView;
		
		private var _log:ILogger;
		
		public function SceneTileBarrageViewMediator(param1:SceneTileBarrageView)
		{
			this._log = Log.getLogger(NAME);
			super(NAME,param1);
			this._sceneTileView = param1;
		}
		
		override public function onRegister() : void
		{
			super.onRegister();
			this._sceneTileProxy = facade.retrieveProxy(SceneTileProxy.NAME) as SceneTileProxy;
			this._playerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			this._sceneTileView.addEventListener(Event.ENTER_FRAME,this.onSceneTileViewEnterFrame);
			this._sceneTileView.addEventListener(SceneTileEvent.Evt_BarrageDeleteInfo,this.onBarrageDeleteInfo);
			this._sceneTileView.addEventListener(SceneTileEvent.Evt_BarrageItemClick,this.onBarrageItemClick);
		}
		
		override public function listNotificationInterests() : Array
		{
			return [SceneTileDef.NOTIFIC_ADD_STATUS,SceneTileDef.NOTIFIC_REMOVE_STATUS,SceneTileDef.NOTIFIC_RECEIVE_BARRAGE_INFO,SceneTileDef.NOTIFIC_STAR_HEAD_SHOW,BodyDef.NOTIFIC_RESIZE,BodyDef.NOTIFIC_CHECK_USER_COMPLETE,BodyDef.NOTIFIC_PLAYER_ADD_STATUS,BodyDef.NOTIFIC_PLAYER_REPLAY,BodyDef.NOTIFIC_PLAYER_REMOVE_STATUS,BodyDef.NOTIFIC_FULL_SCREEN,BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR,BodyDef.NOTIFIC_JS_CALL_SET_BARRAGE_STATUS,BodyDef.NOTIFIC_JS_CALL_SET_SELF_SEND_BARRAGE_INFO,BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE,BodyDef.NOTIFIC_JS_CALL_SET_BARRAGE_SETTING,BodyDef.NOTIFIC_PLAYER_RUNNING,BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE,ADDef.NOTIFIC_ADD_STATUS];
		}
		
		override public function handleNotification(param1:INotification) : void
		{
			var _loc2:Object = null;
			var _loc5:Vector.<BarrageInfo> = null;
			var _loc6:JavascriptAPIProxy = null;
			var _loc7:BarrageInfo = null;
			var _loc8:Object = null;
			var _loc9:JavascriptAPIProxy = null;
			super.handleNotification(param1);
			_loc2 = param1.getBody();
			var _loc3:String = param1.getName();
			var _loc4:String = param1.getType();
			switch(_loc3)
			{
				case SceneTileDef.NOTIFIC_ADD_STATUS:
					this._sceneTileView.onAddStatus(int(_loc2));
					break;
				case SceneTileDef.NOTIFIC_REMOVE_STATUS:
					this._sceneTileView.onRemoveStatus(int(_loc2));
					break;
				case SceneTileDef.NOTIFIC_RECEIVE_BARRAGE_INFO:
					_loc5 = _loc2 as Vector.<BarrageInfo>;
					if(_loc5)
					{
						this._sceneTileView.updateBufferBarrageInfo(_loc5,true);
					}
					break;
				case SceneTileDef.NOTIFIC_STAR_HEAD_SHOW:
					if(this.checkShowStarHead())
					{
						this._sceneTileProxy.addStatus(SceneTileDef.STATUS_BARRAGE_STAR_HEAD_SHOW);
					}
					else
					{
						this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_BARRAGE_STAR_HEAD_SHOW);
					}
					break;
				case BodyDef.NOTIFIC_RESIZE:
					this._sceneTileView.onResize(_loc2.w,_loc2.h);
					break;
				case BodyDef.NOTIFIC_CHECK_USER_COMPLETE:
					this.onCheckUserComplete();
					break;
				case BodyDef.NOTIFIC_PLAYER_ADD_STATUS:
					this.onPlayerStatusChanged(int(_loc2),true,_loc4);
					break;
				case BodyDef.NOTIFIC_PLAYER_REMOVE_STATUS:
					this.onPlayerStatusChanged(int(_loc2),false,_loc4);
					break;
				case BodyDef.NOTIFIC_FULL_SCREEN:
					break;
				case BodyDef.NOTIFIC_PLAYER_REPLAY:
					this._sceneTileProxy.curDataParagraph = this._sceneTileProxy.preLoadDataParagraph = 0;
					break;
				case BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR:
					this._sceneTileView.clearAllBarrageItem();
					this._sceneTileProxy.curDataParagraph = this._sceneTileProxy.preLoadDataParagraph = 0;
					this._sceneTileView.removeEventListener(Event.ENTER_FRAME,this.onSceneTileViewEnterFrame);
					this._sceneTileProxy.barrageSocket.close();
					_loc6 = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
					_loc6.callJsSetBarrageInteractInfo(this._sceneTileProxy.starInteractInfo.starInteractObj,this._sceneTileProxy.barrageSocket.connected);
					this._playerProxy.curActor.isStarBarrage = this._playerProxy.preActor.isStarBarrage = this._sceneTileProxy.barrageSocket.connected;
					break;
				case BodyDef.NOTIFIC_JS_CALL_SET_BARRAGE_STATUS:
					this._playerProxy.curActor.openBarrage = this._playerProxy.preActor.openBarrage = _loc2.isOpen;
					this._sceneTileProxy.isBarrageOpen = _loc2.isOpen;
					if(!this._sceneTileProxy.isBarrageOpen)
					{
						this._sceneTileProxy.barrageSocket.close();
						_loc9 = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
						_loc9.callJsSetBarrageInteractInfo(this._sceneTileProxy.starInteractInfo.starInteractObj,this._sceneTileProxy.barrageSocket.connected);
						this._playerProxy.curActor.isStarBarrage = this._playerProxy.preActor.isStarBarrage = this._sceneTileProxy.barrageSocket.connected;
					}
					this._sceneTileView.hideAllBarrageItem(this.checkShowBarrage());
					if((this.checkShowBarrage()) && !this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_PAUSED) && !this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPED) && !this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_WAITING))
					{
						this._sceneTileView.addEventListener(Event.ENTER_FRAME,this.onSceneTileViewEnterFrame);
					}
					break;
				case BodyDef.NOTIFIC_JS_CALL_SET_SELF_SEND_BARRAGE_INFO:
					_loc7 = new BarrageInfo();
					_loc8 = new Object();
					_loc8.msgType = BarrageSocket.TVL_TYPE_SEND_MESSAGE;
					_loc8.data = [_loc2];
					if(this._sceneTileProxy.barrageSocket.connected)
					{
						this._sceneTileProxy.barrageSocket.send(BarrageSocket.TVL_TYPE_SEND_MESSAGE,com.adobe.serialization.json.JSON.encode(_loc8));
					}
					_loc7.update(_loc2.contentId,_loc2.showTime,_loc2.content,_loc2.likes,_loc2.font == undefined?SceneTileDef.BARRAGE_DEFAULT_FONT_SIZE:_loc2.font,_loc2.color == undefined?SceneTileDef.BARRAGE_DEFAULT_FONT_COLOR:_loc2.color,_loc2.position == undefined?SceneTileDef.BARRAGE_POSITION_NONE:_loc2.position,SceneTileDef.BARRAGE_CONTENT_TYPE_NONE,SceneTileDef.BARRAGE_BG_TYPE_NONE);
					if((this._sceneTileProxy.barrageSocket.connected) && (_loc2.contentType) && _loc2.contentType == SceneTileDef.BARRAGE_CONTENT_TYPE_STAR)
					{
						return;
					}
					if((this._playerProxy.curActor.movieModel) && (this._playerProxy.curActor.movieModel.albumId == "202445101") || (this._playerProxy.curActor.movieInfo.infoJSON) && (this._playerProxy.curActor.movieInfo.infoJSON.sid == "202445101"))
					{
						return;
					}
					this._sceneTileView.updateSelfBarrageInfo(_loc7);
					break;
				case BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE:
					this._sceneTileView.hideAllBarrageItem(this.checkShowBarrage());
					if(this.checkShowStarHead())
					{
						this._sceneTileProxy.addStatus(SceneTileDef.STATUS_BARRAGE_STAR_HEAD_SHOW);
					}
					else
					{
						this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_BARRAGE_STAR_HEAD_SHOW);
					}
					break;
				case BodyDef.NOTIFIC_JS_CALL_SET_BARRAGE_SETTING:
					this._sceneTileProxy.barrageAlpha = _loc2.alpha == undefined?this._sceneTileProxy.barrageAlpha:_loc2.alpha;
					if(_loc2.isFilterImage != undefined)
					{
						this._sceneTileProxy.barrageIsFilterImage = _loc2.isFilterImage == "1"?true:false;
					}
					this._sceneTileView.updateAllBarrageItemAlpha(this._sceneTileProxy.barrageAlpha);
					this._sceneTileView.isFilterImage = this._sceneTileProxy.barrageIsFilterImage;
					break;
				case BodyDef.NOTIFIC_PLAYER_RUNNING:
					this.onPlayerRunning(_loc2.currentTime,_loc2.bufferTime,_loc2.duration,_loc2.playingDuration);
					break;
				case ADDef.NOTIFIC_ADD_STATUS:
					this.onADStatusChanged(int(_loc2),true);
					break;
			}
		}
		
		private function onPlayerStatusChanged(param1:int, param2:Boolean, param3:String) : void
		{
			var _loc4:JavascriptAPIProxy = null;
			if(param3 != BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
			{
				return;
			}
			switch(param1)
			{
				case BodyDef.PLAYER_STATUS_ALREADY_READY:
				case BodyDef.PLAYER_STATUS_ALREADY_INFO_READY:
				case BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE:
					if(param2)
					{
						this._sceneTileView.clearAllBarrageItem();
						this._sceneTileProxy.curDataParagraph = this._sceneTileProxy.preLoadDataParagraph = 0;
						this._sceneTileView.removeEventListener(Event.ENTER_FRAME,this.onSceneTileViewEnterFrame);
						this._sceneTileProxy.barrageSocket.close();
						_loc4 = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
						_loc4.callJsSetBarrageInteractInfo(this._sceneTileProxy.starInteractInfo.starInteractObj,this._sceneTileProxy.barrageSocket.connected);
						this._playerProxy.curActor.isStarBarrage = this._playerProxy.preActor.isStarBarrage = this._sceneTileProxy.barrageSocket.connected;
					}
					break;
				case BodyDef.PLAYER_STATUS_PAUSED:
					if(param2)
					{
						this._sceneTileView.removeEventListener(Event.ENTER_FRAME,this.onSceneTileViewEnterFrame);
					}
					break;
				case BodyDef.PLAYER_STATUS_PLAYING:
					if((param2) && (this.checkShowBarrage()))
					{
						this._sceneTileView.addEventListener(Event.ENTER_FRAME,this.onSceneTileViewEnterFrame);
					}
					break;
				case BodyDef.PLAYER_STATUS_FAILED:
				case BodyDef.PLAYER_STATUS_STOPED:
					if(param2)
					{
						this._sceneTileView.clearAllBarrageItem();
						this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW);
						this._sceneTileView.removeEventListener(Event.ENTER_FRAME,this.onSceneTileViewEnterFrame);
					}
					break;
			}
		}
		
		private function onADStatusChanged(param1:int, param2:Boolean) : void
		{
			switch(param1)
			{
				case ADDef.STATUS_LOADING:
				case ADDef.STATUS_PAUSED:
				case ADDef.STATUS_PLAYING:
					this._sceneTileView.removeEventListener(Event.ENTER_FRAME,this.onSceneTileViewEnterFrame);
					this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_BARRAGE_STAR_HEAD_SHOW);
					break;
			}
		}
		
		private function onSceneTileViewEnterFrame(param1:Event) : void
		{
			var _loc2:Vector.<BarrageInfo> = null;
			var _loc3:* = 0;
			if((this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) && (this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY)))
			{
				if((FlashVarConfig.putBarrage) && (this._playerProxy.curActor.movieInfo.putBarrage) && this._playerProxy.curActor.currentTime >= SceneTileDef.BARRAGE_REQUEST_INTERVAL_TIME * this._sceneTileProxy.curDataParagraph || this._playerProxy.curActor.currentTime < SceneTileDef.BARRAGE_REQUEST_INTERVAL_TIME * (this._sceneTileProxy.curDataParagraph - 1))
				{
					_loc3 = Math.ceil(this._playerProxy.curActor.currentTime / SceneTileDef.BARRAGE_REQUEST_INTERVAL_TIME);
					this._sceneTileProxy.requestBarrageData(_loc3 == 0?1:_loc3,this._playerProxy.curActor.movieModel.tvid);
					this._sceneTileView.isFilterImage = this._sceneTileProxy.barrageIsFilterImage;
				}
				if(!this._sceneTileProxy.starInteractInfo.isReady && !this._sceneTileProxy.starInteractInfo.isLoading)
				{
					this._sceneTileProxy.starInteractInfo.startLoad();
				}
				_loc2 = this._sceneTileProxy.getBarrageData(Math.ceil(this._playerProxy.curActor.currentTime / 1000));
				if(_loc2 != null)
				{
					this._sceneTileView.updateBufferBarrageInfo(_loc2);
				}
				this._sceneTileView.updateBarrageItemCoordinate(this._sceneTileProxy.barrageSocket.connected);
				this._sceneTileView.checkAddBarrageItem(this.checkShowBarrage(),this._sceneTileProxy.barrageAlpha,this._sceneTileProxy.barrageSocket.connected);
				this._sceneTileView.checkRemoveBarrageItem();
			}
		}
		
		private function checkShowBarrage() : Boolean
		{
			var _loc1:ADProxy = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
			if((this._sceneTileProxy.isBarrageOpen) && (FlashVarConfig.putBarrage) && (this._playerProxy.curActor.movieInfo.putBarrage) && !_loc1.hasStatus(ADDef.STATUS_PLAYING) && !_loc1.hasStatus(ADDef.STATUS_PAUSED) && !_loc1.hasStatus(ADDef.STATUS_LOADING) && !this._playerProxy.curActor.smallWindowMode)
			{
				return true;
			}
			return false;
		}
		
		private function onBarrageDeleteInfo(param1:SceneTileEvent) : void
		{
			PingBack.getInstance().barrageDeleteInfo(int(param1.data),this._playerProxy.curActor.currentTime);
		}
		
		private function onBarrageItemClick(param1:SceneTileEvent) : void
		{
			GlobalStage.setNormalScreen();
			var _loc2:BarrageItem = param1.data as BarrageItem;
			var _loc3:JavascriptAPIProxy = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
			if((_loc2) && (_loc2.barrageInfo.userInfo))
			{
				_loc3.callJsBarrageReply(_loc2.barrageInfo.userInfo.uid,_loc2.barrageInfo.userInfo.name?_loc2.barrageInfo.userInfo.name:"");
			}
		}
		
		private function onPlayerRunning(param1:int, param2:int, param3:int, param4:int) : void
		{
			var _loc5:Object = null;
			var _loc6:* = NaN;
			var _loc7:JavascriptAPIProxy = null;
			if((this._sceneTileProxy.starInteractInfo.isReady) && (this._playerProxy.curActor.movieModel))
			{
				_loc5 = this._sceneTileProxy.starInteractInfo.getStarInteractByTvid(this._playerProxy.curActor.movieModel.tvid);
				_loc6 = new Date().valueOf();
				if((_loc5) && _loc6 >= Number(_loc5.begin_time) * 1000 && _loc6 < Number(_loc5.end_time) * 1000)
				{
					if(!this._sceneTileProxy.barrageSocket.connected && !this._sceneTileProxy.barrageSocket.isConnecting && (this._sceneTileProxy.isBarrageOpen))
					{
						this._sceneTileProxy.barrageSocket.open(this._playerProxy.curActor.movieModel.tvid);
					}
				}
				else if(this._sceneTileProxy.barrageSocket.connected)
				{
					this._sceneTileProxy.barrageSocket.close();
					_loc7 = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
					_loc7.callJsSetBarrageInteractInfo(this._sceneTileProxy.starInteractInfo.starInteractObj,this._sceneTileProxy.barrageSocket.connected);
					this._playerProxy.curActor.isStarBarrage = this._playerProxy.preActor.isStarBarrage = this._sceneTileProxy.barrageSocket.connected;
					sendNotification(SceneTileDef.NOTIFIC_STAR_HEAD_SHOW);
				}
				
			}
		}
		
		private function checkShowStarHead() : Boolean
		{
			var _loc1:ADProxy = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
			if((this._sceneTileProxy.barrageSocket.connected) && !this._playerProxy.curActor.smallWindowMode && (this._sceneTileProxy.isBarrageOpen) && (this._playerProxy.curActor.movieInfo.putBarrage) && (FlashVarConfig.putBarrage) && !_loc1.hasStatus(ADDef.STATUS_PLAYING) && !_loc1.hasStatus(ADDef.STATUS_PAUSED) && !_loc1.hasStatus(ADDef.STATUS_LOADING))
			{
				return true;
			}
			return false;
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
			if(this._sceneTileProxy.barrageSocket.connected)
			{
				this._sceneTileProxy.barrageSocket.sendLogin(false);
			}
			this._sceneTileView.onUserInfoChanged(_loc2);
		}
	}
}
