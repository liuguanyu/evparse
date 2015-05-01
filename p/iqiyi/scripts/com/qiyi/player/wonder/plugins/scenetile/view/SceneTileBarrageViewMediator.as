package com.qiyi.player.wonder.plugins.scenetile.view {
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
	
	public class SceneTileBarrageViewMediator extends Mediator {
		
		public function SceneTileBarrageViewMediator(param1:SceneTileBarrageView) {
			this._log = Log.getLogger(NAME);
			super(NAME,param1);
			this._sceneTileView = param1;
		}
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.scenetile.view.SceneTileBarrageViewMediator";
		
		private var _sceneTileProxy:SceneTileProxy;
		
		private var _playerProxy:PlayerProxy;
		
		private var _sceneTileView:SceneTileBarrageView;
		
		private var _log:ILogger;
		
		override public function onRegister() : void {
			super.onRegister();
			this._sceneTileProxy = facade.retrieveProxy(SceneTileProxy.NAME) as SceneTileProxy;
			this._playerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			this._sceneTileView.addEventListener(Event.ENTER_FRAME,this.onSceneTileViewEnterFrame);
			this._sceneTileView.addEventListener(SceneTileEvent.Evt_BarrageDeleteInfo,this.onBarrageDeleteInfo);
			this._sceneTileView.addEventListener(SceneTileEvent.Evt_BarrageItemClick,this.onBarrageItemClick);
		}
		
		override public function listNotificationInterests() : Array {
			return [SceneTileDef.NOTIFIC_ADD_STATUS,SceneTileDef.NOTIFIC_REMOVE_STATUS,SceneTileDef.NOTIFIC_RECEIVE_BARRAGE_INFO,SceneTileDef.NOTIFIC_STAR_HEAD_SHOW,BodyDef.NOTIFIC_RESIZE,BodyDef.NOTIFIC_CHECK_USER_COMPLETE,BodyDef.NOTIFIC_PLAYER_ADD_STATUS,BodyDef.NOTIFIC_PLAYER_REPLAY,BodyDef.NOTIFIC_PLAYER_REMOVE_STATUS,BodyDef.NOTIFIC_FULL_SCREEN,BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR,BodyDef.NOTIFIC_JS_CALL_SET_BARRAGE_STATUS,BodyDef.NOTIFIC_JS_CALL_SET_SELF_SEND_BARRAGE_INFO,BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE,BodyDef.NOTIFIC_JS_CALL_SET_BARRAGE_SETTING,BodyDef.NOTIFIC_PLAYER_RUNNING,BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE,ADDef.NOTIFIC_ADD_STATUS];
		}
		
		override public function handleNotification(param1:INotification) : void {
			var _loc2_:Object = null;
			var _loc5_:Vector.<BarrageInfo> = null;
			var _loc6_:JavascriptAPIProxy = null;
			var _loc7_:BarrageInfo = null;
			var _loc8_:Object = null;
			var _loc9_:JavascriptAPIProxy = null;
			super.handleNotification(param1);
			_loc2_ = param1.getBody();
			var _loc3_:String = param1.getName();
			var _loc4_:String = param1.getType();
			switch(_loc3_) {
				case SceneTileDef.NOTIFIC_ADD_STATUS:
					this._sceneTileView.onAddStatus(int(_loc2_));
					break;
				case SceneTileDef.NOTIFIC_REMOVE_STATUS:
					this._sceneTileView.onRemoveStatus(int(_loc2_));
					break;
				case SceneTileDef.NOTIFIC_RECEIVE_BARRAGE_INFO:
					_loc5_ = _loc2_ as Vector.<BarrageInfo>;
					if(_loc5_) {
						this._sceneTileView.updateBufferBarrageInfo(_loc5_,true);
					}
					break;
				case SceneTileDef.NOTIFIC_STAR_HEAD_SHOW:
					if(this.checkShowStarHead()) {
						this._sceneTileProxy.addStatus(SceneTileDef.STATUS_BARRAGE_STAR_HEAD_SHOW);
					} else {
						this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_BARRAGE_STAR_HEAD_SHOW);
					}
					break;
				case BodyDef.NOTIFIC_RESIZE:
					this._sceneTileView.onResize(_loc2_.w,_loc2_.h);
					break;
				case BodyDef.NOTIFIC_CHECK_USER_COMPLETE:
					this.onCheckUserComplete();
					break;
				case BodyDef.NOTIFIC_PLAYER_ADD_STATUS:
					this.onPlayerStatusChanged(int(_loc2_),true,_loc4_);
					break;
				case BodyDef.NOTIFIC_PLAYER_REMOVE_STATUS:
					this.onPlayerStatusChanged(int(_loc2_),false,_loc4_);
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
					_loc6_ = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
					_loc6_.callJsSetBarrageInteractInfo(this._sceneTileProxy.starInteractInfo.starInteractObj,this._sceneTileProxy.barrageSocket.connected);
					this._playerProxy.curActor.isStarBarrage = this._playerProxy.preActor.isStarBarrage = this._sceneTileProxy.barrageSocket.connected;
					break;
				case BodyDef.NOTIFIC_JS_CALL_SET_BARRAGE_STATUS:
					this._playerProxy.curActor.openBarrage = this._playerProxy.preActor.openBarrage = _loc2_.isOpen;
					this._sceneTileProxy.isBarrageOpen = _loc2_.isOpen;
					if(!this._sceneTileProxy.isBarrageOpen) {
						this._sceneTileProxy.barrageSocket.close();
						_loc9_ = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
						_loc9_.callJsSetBarrageInteractInfo(this._sceneTileProxy.starInteractInfo.starInteractObj,this._sceneTileProxy.barrageSocket.connected);
						this._playerProxy.curActor.isStarBarrage = this._playerProxy.preActor.isStarBarrage = this._sceneTileProxy.barrageSocket.connected;
					}
					this._sceneTileView.hideAllBarrageItem(this.checkShowBarrage());
					if((this.checkShowBarrage()) && !this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_PAUSED) && !this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPED) && !this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_WAITING)) {
						this._sceneTileView.addEventListener(Event.ENTER_FRAME,this.onSceneTileViewEnterFrame);
					}
					break;
				case BodyDef.NOTIFIC_JS_CALL_SET_SELF_SEND_BARRAGE_INFO:
					_loc7_ = new BarrageInfo();
					_loc8_ = new Object();
					_loc8_.msgType = BarrageSocket.TVL_TYPE_SEND_MESSAGE;
					_loc8_.data = [_loc2_];
					if(this._sceneTileProxy.barrageSocket.connected) {
						this._sceneTileProxy.barrageSocket.send(BarrageSocket.TVL_TYPE_SEND_MESSAGE,com.adobe.serialization.json.JSON.encode(_loc8_));
					}
					_loc7_.update(_loc2_.contentId,_loc2_.showTime,_loc2_.content,_loc2_.likes,_loc2_.font == undefined?SceneTileDef.BARRAGE_DEFAULT_FONT_SIZE:_loc2_.font,_loc2_.color == undefined?SceneTileDef.BARRAGE_DEFAULT_FONT_COLOR:_loc2_.color,_loc2_.position == undefined?SceneTileDef.BARRAGE_POSITION_NONE:_loc2_.position,SceneTileDef.BARRAGE_CONTENT_TYPE_NONE,SceneTileDef.BARRAGE_BG_TYPE_NONE);
					if((this._sceneTileProxy.barrageSocket.connected) && (_loc2_.contentType) && _loc2_.contentType == SceneTileDef.BARRAGE_CONTENT_TYPE_STAR) {
						return;
					}
					if((this._playerProxy.curActor.movieModel) && (this._playerProxy.curActor.movieModel.albumId == "202445101") || (this._playerProxy.curActor.movieInfo.infoJSON) && (this._playerProxy.curActor.movieInfo.infoJSON.sid == "202445101")) {
						return;
					}
					this._sceneTileView.updateSelfBarrageInfo(_loc7_);
					break;
				case BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE:
					this._sceneTileView.hideAllBarrageItem(this.checkShowBarrage());
					if(this.checkShowStarHead()) {
						this._sceneTileProxy.addStatus(SceneTileDef.STATUS_BARRAGE_STAR_HEAD_SHOW);
					} else {
						this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_BARRAGE_STAR_HEAD_SHOW);
					}
					break;
				case BodyDef.NOTIFIC_JS_CALL_SET_BARRAGE_SETTING:
					this._sceneTileProxy.barrageAlpha = _loc2_.alpha == undefined?this._sceneTileProxy.barrageAlpha:_loc2_.alpha;
					if(_loc2_.isFilterImage != undefined) {
						this._sceneTileProxy.barrageIsFilterImage = _loc2_.isFilterImage == "1"?true:false;
					}
					this._sceneTileView.updateAllBarrageItemAlpha(this._sceneTileProxy.barrageAlpha);
					this._sceneTileView.isFilterImage = this._sceneTileProxy.barrageIsFilterImage;
					break;
				case BodyDef.NOTIFIC_PLAYER_RUNNING:
					this.onPlayerRunning(_loc2_.currentTime,_loc2_.bufferTime,_loc2_.duration,_loc2_.playingDuration);
					break;
				case ADDef.NOTIFIC_ADD_STATUS:
					this.onADStatusChanged(int(_loc2_),true);
					break;
			}
		}
		
		private function onPlayerStatusChanged(param1:int, param2:Boolean, param3:String) : void {
			var _loc4_:JavascriptAPIProxy = null;
			if(param3 != BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR) {
				return;
			}
			switch(param1) {
				case BodyDef.PLAYER_STATUS_ALREADY_READY:
				case BodyDef.PLAYER_STATUS_ALREADY_INFO_READY:
				case BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE:
					if(param2) {
						this._sceneTileView.clearAllBarrageItem();
						this._sceneTileProxy.curDataParagraph = this._sceneTileProxy.preLoadDataParagraph = 0;
						this._sceneTileView.removeEventListener(Event.ENTER_FRAME,this.onSceneTileViewEnterFrame);
						this._sceneTileProxy.barrageSocket.close();
						_loc4_ = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
						_loc4_.callJsSetBarrageInteractInfo(this._sceneTileProxy.starInteractInfo.starInteractObj,this._sceneTileProxy.barrageSocket.connected);
						this._playerProxy.curActor.isStarBarrage = this._playerProxy.preActor.isStarBarrage = this._sceneTileProxy.barrageSocket.connected;
					}
					break;
				case BodyDef.PLAYER_STATUS_PAUSED:
					if(param2) {
						this._sceneTileView.removeEventListener(Event.ENTER_FRAME,this.onSceneTileViewEnterFrame);
					}
					break;
				case BodyDef.PLAYER_STATUS_PLAYING:
					if((param2) && (this.checkShowBarrage())) {
						this._sceneTileView.addEventListener(Event.ENTER_FRAME,this.onSceneTileViewEnterFrame);
					}
					break;
				case BodyDef.PLAYER_STATUS_FAILED:
				case BodyDef.PLAYER_STATUS_STOPED:
					if(param2) {
						this._sceneTileView.clearAllBarrageItem();
						this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW);
						this._sceneTileView.removeEventListener(Event.ENTER_FRAME,this.onSceneTileViewEnterFrame);
					}
					break;
			}
		}
		
		private function onADStatusChanged(param1:int, param2:Boolean) : void {
			switch(param1) {
				case ADDef.STATUS_LOADING:
				case ADDef.STATUS_PAUSED:
				case ADDef.STATUS_PLAYING:
					this._sceneTileView.removeEventListener(Event.ENTER_FRAME,this.onSceneTileViewEnterFrame);
					this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_BARRAGE_STAR_HEAD_SHOW);
					break;
			}
		}
		
		private function onSceneTileViewEnterFrame(param1:Event) : void {
			var _loc2_:Vector.<BarrageInfo> = null;
			var _loc3_:* = 0;
			if((this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) && (this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY))) {
				if((FlashVarConfig.putBarrage) && (this._playerProxy.curActor.movieInfo.putBarrage) && this._playerProxy.curActor.currentTime >= SceneTileDef.BARRAGE_REQUEST_INTERVAL_TIME * this._sceneTileProxy.curDataParagraph || this._playerProxy.curActor.currentTime < SceneTileDef.BARRAGE_REQUEST_INTERVAL_TIME * (this._sceneTileProxy.curDataParagraph - 1)) {
					_loc3_ = Math.ceil(this._playerProxy.curActor.currentTime / SceneTileDef.BARRAGE_REQUEST_INTERVAL_TIME);
					this._sceneTileProxy.requestBarrageData(_loc3_ == 0?1:_loc3_,this._playerProxy.curActor.movieModel.tvid);
					this._sceneTileView.isFilterImage = this._sceneTileProxy.barrageIsFilterImage;
				}
				if(!this._sceneTileProxy.starInteractInfo.isReady && !this._sceneTileProxy.starInteractInfo.isLoading) {
					this._sceneTileProxy.starInteractInfo.startLoad();
				}
				_loc2_ = this._sceneTileProxy.getBarrageData(Math.ceil(this._playerProxy.curActor.currentTime / 1000));
				if(_loc2_ != null) {
					this._sceneTileView.updateBufferBarrageInfo(_loc2_);
				}
				this._sceneTileView.updateBarrageItemCoordinate(this._sceneTileProxy.barrageSocket.connected);
				this._sceneTileView.checkAddBarrageItem(this.checkShowBarrage(),this._sceneTileProxy.barrageAlpha,this._sceneTileProxy.barrageSocket.connected);
				this._sceneTileView.checkRemoveBarrageItem();
			}
		}
		
		private function checkShowBarrage() : Boolean {
			var _loc1_:ADProxy = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
			if((this._sceneTileProxy.isBarrageOpen) && (FlashVarConfig.putBarrage) && (this._playerProxy.curActor.movieInfo.putBarrage) && !_loc1_.hasStatus(ADDef.STATUS_PLAYING) && !_loc1_.hasStatus(ADDef.STATUS_PAUSED) && !_loc1_.hasStatus(ADDef.STATUS_LOADING) && !this._playerProxy.curActor.smallWindowMode) {
				return true;
			}
			return false;
		}
		
		private function onBarrageDeleteInfo(param1:SceneTileEvent) : void {
			PingBack.getInstance().barrageDeleteInfo(int(param1.data),this._playerProxy.curActor.currentTime);
		}
		
		private function onBarrageItemClick(param1:SceneTileEvent) : void {
			GlobalStage.setNormalScreen();
			var _loc2_:BarrageItem = param1.data as BarrageItem;
			var _loc3_:JavascriptAPIProxy = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
			if((_loc2_) && (_loc2_.barrageInfo.userInfo)) {
				_loc3_.callJsBarrageReply(_loc2_.barrageInfo.userInfo.uid,_loc2_.barrageInfo.userInfo.name?_loc2_.barrageInfo.userInfo.name:"");
			}
		}
		
		private function onPlayerRunning(param1:int, param2:int, param3:int, param4:int) : void {
			var _loc5_:Object = null;
			var _loc6_:* = NaN;
			var _loc7_:JavascriptAPIProxy = null;
			if((this._sceneTileProxy.starInteractInfo.isReady) && (this._playerProxy.curActor.movieModel)) {
				_loc5_ = this._sceneTileProxy.starInteractInfo.getStarInteractByTvid(this._playerProxy.curActor.movieModel.tvid);
				_loc6_ = new Date().valueOf();
				if((_loc5_) && _loc6_ >= Number(_loc5_.begin_time) * 1000 && _loc6_ < Number(_loc5_.end_time) * 1000) {
					if(!this._sceneTileProxy.barrageSocket.connected && !this._sceneTileProxy.barrageSocket.isConnecting && (this._sceneTileProxy.isBarrageOpen)) {
						this._sceneTileProxy.barrageSocket.open(this._playerProxy.curActor.movieModel.tvid);
					}
				} else if(this._sceneTileProxy.barrageSocket.connected) {
					this._sceneTileProxy.barrageSocket.close();
					_loc7_ = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
					_loc7_.callJsSetBarrageInteractInfo(this._sceneTileProxy.starInteractInfo.starInteractObj,this._sceneTileProxy.barrageSocket.connected);
					this._playerProxy.curActor.isStarBarrage = this._playerProxy.preActor.isStarBarrage = this._sceneTileProxy.barrageSocket.connected;
					sendNotification(SceneTileDef.NOTIFIC_STAR_HEAD_SHOW);
				}
				
			}
		}
		
		private function checkShowStarHead() : Boolean {
			var _loc1_:ADProxy = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
			if((this._sceneTileProxy.barrageSocket.connected) && !this._playerProxy.curActor.smallWindowMode && (this._sceneTileProxy.isBarrageOpen) && (this._playerProxy.curActor.movieInfo.putBarrage) && (FlashVarConfig.putBarrage) && !_loc1_.hasStatus(ADDef.STATUS_PLAYING) && !_loc1_.hasStatus(ADDef.STATUS_PAUSED) && !_loc1_.hasStatus(ADDef.STATUS_LOADING)) {
				return true;
			}
			return false;
		}
		
		private function onCheckUserComplete() : void {
			var _loc1_:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			var _loc2_:UserInfoVO = new UserInfoVO();
			_loc2_.isLogin = _loc1_.isLogin;
			_loc2_.passportID = _loc1_.passportID;
			_loc2_.userID = _loc1_.userID;
			_loc2_.userName = _loc1_.userName;
			_loc2_.userLevel = _loc1_.userLevel;
			_loc2_.userType = _loc1_.userType;
			if(this._sceneTileProxy.barrageSocket.connected) {
				this._sceneTileProxy.barrageSocket.sendLogin(false);
			}
			this._sceneTileView.onUserInfoChanged(_loc2_);
		}
	}
}
