package com.qiyi.player.wonder.plugins.setting.view {
	import org.puremvc.as3.patterns.mediator.Mediator;
	import com.qiyi.player.wonder.plugins.setting.model.SettingProxy;
	import com.qiyi.player.wonder.plugins.setting.SettingDef;
	import com.qiyi.player.wonder.body.BodyDef;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.plugins.controllbar.model.ControllBarProxy;
	import com.qiyi.player.wonder.body.model.PlayerProxy;
	import com.qiyi.player.core.model.def.DefinitionControlTypeEnum;
	import com.qiyi.player.core.model.impls.pub.Settings;
	import com.qiyi.player.core.model.def.DefinitionEnum;
	import com.qiyi.player.base.pub.EnumItem;
	import com.qiyi.player.wonder.plugins.ad.ADDef;
	import gs.TweenLite;
	import com.qiyi.player.wonder.plugins.topbar.TopBarDef;
	import com.qiyi.player.wonder.plugins.tips.TipsDef;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.wonder.common.pingback.PingBack;
	import com.qiyi.player.wonder.common.config.FlashVarConfig;
	import com.iqiyi.components.global.GlobalStage;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import com.qiyi.player.user.UserDef;
	import com.qiyi.player.wonder.plugins.scenetile.SceneTileDef;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	
	public class DefinitionViewMediator extends Mediator {
		
		public function DefinitionViewMediator(param1:DefinitionView) {
			super(NAME,param1);
			this._definitionView = param1;
		}
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.setting.view.DefinitionViewMediator";
		
		private var _settingProxy:SettingProxy;
		
		private var _definitionView:DefinitionView;
		
		override public function onRegister() : void {
			super.onRegister();
			this._settingProxy = facade.retrieveProxy(SettingProxy.NAME) as SettingProxy;
			this._definitionView.addEventListener(SettingEvent.Evt_DefinitionOpen,this.onDefinitionViewOpen);
			this._definitionView.addEventListener(SettingEvent.Evt_DefinitionClose,this.onDefinitionViewClose);
			this._definitionView.addEventListener(SettingEvent.Evt_DefinitionChangeClick,this.onDefinitionViewChangeClick);
		}
		
		override public function listNotificationInterests() : Array {
			return [SettingDef.NOTIFIC_ADD_STATUS,SettingDef.NOTIFIC_REMOVE_STATUS,BodyDef.NOTIFIC_CHECK_USER_COMPLETE,BodyDef.NOTIFIC_PLAYER_ADD_STATUS,BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR,BodyDef.NOTIFIC_FULL_SCREEN,BodyDef.NOTIFIC_PLAYER_DEFINITION_SWITCHED];
		}
		
		override public function handleNotification(param1:INotification) : void {
			var _loc5_:ControllBarProxy = null;
			var _loc6_:PlayerProxy = null;
			super.handleNotification(param1);
			var _loc2_:Object = param1.getBody();
			var _loc3_:String = param1.getName();
			var _loc4_:String = param1.getType();
			switch(_loc3_) {
				case SettingDef.NOTIFIC_ADD_STATUS:
					_loc5_ = facade.retrieveProxy(ControllBarProxy.NAME) as ControllBarProxy;
					_loc6_ = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
					if(int(_loc2_) == SettingDef.STATUS_DEFINITION_OPEN) {
						this._definitionView.initUI(_loc5_.definitionBtnX,_loc5_.definitionBtnY,this.getDefinitionArray(),_loc6_.curActor.movieModel.qualityDefinitionControlType != DefinitionControlTypeEnum.NONE?this.getLimitDefinitionArray():[],Settings.instance.autoMatchRate?DefinitionEnum.NONE:null,_loc6_.curActor.movieModel.curDefinitionInfo.type.id);
						sendNotification(ADDef.NOTIFIC_POPUP_OPEN);
					}
					this._definitionView.onAddStatus(int(_loc2_));
					break;
				case SettingDef.NOTIFIC_REMOVE_STATUS:
					this._definitionView.onRemoveStatus(int(_loc2_));
					if(int(_loc2_) == SettingDef.STATUS_DEFINITION_OPEN) {
						sendNotification(ADDef.NOTIFIC_POPUP_CLOSE);
					}
					break;
				case BodyDef.NOTIFIC_CHECK_USER_COMPLETE:
					this.onCheckUserComplete();
					break;
				case BodyDef.NOTIFIC_PLAYER_ADD_STATUS:
					this.onPlayerStatusChanged(int(_loc2_),true,_loc4_);
					break;
				case BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR:
					TweenLite.killTweensOf(this.onPlayerDefinitionSwitchComplete);
					this._settingProxy.removeStatus(SettingDef.STATUS_DEFINITION_OPEN);
					break;
				case BodyDef.NOTIFIC_FULL_SCREEN:
					this.onFullScreen(Boolean(_loc2_));
					break;
				case BodyDef.NOTIFIC_PLAYER_DEFINITION_SWITCHED:
					if(_loc4_ == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR) {
						this.onPlayerDefinitionSwitched(int(_loc2_));
					}
					break;
			}
		}
		
		private function onPlayerStatusChanged(param1:int, param2:Boolean, param3:String) : void {
			if(param3 != BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR) {
				return;
			}
			switch(param1) {
				case BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE:
					if(param2) {
						TweenLite.killTweensOf(this.onPlayerDefinitionSwitchComplete);
					}
				case BodyDef.PLAYER_STATUS_STOPED:
				case BodyDef.PLAYER_STATUS_STOPPING:
				case BodyDef.PLAYER_STATUS_FAILED:
					if(param2) {
						this._settingProxy.removeStatus(SettingDef.STATUS_DEFINITION_OPEN);
					}
					break;
			}
		}
		
		private function onFullScreen(param1:Boolean) : void {
			var _loc2_:PlayerProxy = null;
			var _loc3_:EnumItem = null;
			if(param1) {
				_loc2_ = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
				if(_loc2_.curActor.movieModel) {
					_loc3_ = _loc2_.curActor.movieModel.curDefinitionInfo.type;
					if(_loc3_ == DefinitionEnum.LIMIT) {
						sendNotification(TopBarDef.NOTIFIC_REQUEST_SCALE,TopBarDef.SCALE_VALUE_75);
						sendNotification(TipsDef.NOTIFIC_REQUEST_SHOW_TIP,TipsDef.TIP_ID_CHANG_SIZE_75);
					}
				}
			}
		}
		
		private function onPlayerDefinitionSwitched(param1:int) : void {
			if(param1 >= 0) {
				TweenLite.killTweensOf(this.onPlayerDefinitionSwitchComplete);
				TweenLite.delayedCall(param1 / 1000,this.onPlayerDefinitionSwitchComplete);
			}
		}
		
		private function onPlayerDefinitionSwitchComplete() : void {
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc1_.curActor.movieModel) {
				this._definitionView.setChangeVidComplete(_loc1_.curActor.movieModel.curDefinitionInfo.type);
			}
		}
		
		private function onDefinitionViewOpen(param1:SettingEvent) : void {
			if(!this._settingProxy.hasStatus(SettingDef.STATUS_DEFINITION_OPEN)) {
				this._settingProxy.addStatus(SettingDef.STATUS_DEFINITION_OPEN);
			}
		}
		
		private function onDefinitionViewClose(param1:SettingEvent) : void {
			if(this._settingProxy.hasStatus(SettingDef.STATUS_DEFINITION_OPEN)) {
				this._settingProxy.removeStatus(SettingDef.STATUS_DEFINITION_OPEN);
			}
		}
		
		private function onDefinitionViewChangeClick(param1:SettingEvent) : void {
			var _loc2_:PlayerProxy = null;
			var _loc4_:EnumItem = null;
			var _loc5_:Date = null;
			var _loc6_:* = NaN;
			_loc2_ = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc3_:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			if(param1.data as EnumItem == DefinitionEnum.NONE) {
				Settings.instance.autoMatchRate = true;
			} else if(_loc2_.curActor.movieModel.hasDefinitionByType(param1.data as EnumItem)) {
				if(_loc2_.curActor.movieModel) {
					_loc4_ = _loc2_.curActor.movieModel.curDefinitionInfo.type;
					if((param1.data) && (_loc4_) && !(_loc4_ == param1.data)) {
						PingBack.getInstance().switchDefinition(_loc4_.id,EnumItem(param1.data).id);
					}
				}
				Settings.instance.autoMatchRate = false;
				Settings.instance.definition = param1.data as EnumItem;
				if((FlashVarConfig.outsite) && (param1.data == DefinitionEnum.SUPER_HIGH || param1.data == DefinitionEnum.FULL_HD)) {
					sendNotification(BodyDef.NOTIFIC_PLAYER_PAUSE);
					Settings.update();
					GlobalStage.setNormalScreen();
					navigateToURL(new URLRequest(_loc2_.curActor.movieInfo.pageUrl),"_blank");
				}
			} else if(_loc3_.userLevel != UserDef.USER_LEVEL_NORMAL) {
				Settings.instance.autoMatchRate = false;
				Settings.instance.definition = param1.data as EnumItem;
				sendNotification(BodyDef.NOTIFIC_PLAYER_REFRESH);
			} else {
				switch(_loc2_.curActor.movieModel.qualityDefinitionControlType) {
					case DefinitionControlTypeEnum.BYTIME:
						_loc5_ = new Date(_loc2_.curActor.serverTime * 1000);
						_loc6_ = _loc5_.getHours() * 60 * 60 + _loc5_.getMinutes() * 60 + _loc5_.getSeconds();
						if(_loc6_ < _loc2_.curActor.movieModel.qualityDefinitionControlTimeRange.st || _loc6_ > _loc2_.curActor.movieModel.qualityDefinitionControlTimeRange.et) {
							Settings.instance.autoMatchRate = false;
							Settings.instance.definition = param1.data as EnumItem;
							sendNotification(BodyDef.NOTIFIC_PLAYER_REFRESH);
						} else {
							sendNotification(SceneTileDef.NOTIFIC_OPEN_CLOSE_STREAM_LIMIT,param1.data);
						}
						break;
					default:
						sendNotification(SceneTileDef.NOTIFIC_OPEN_CLOSE_STREAM_LIMIT,param1.data);
				}
			}
			
			
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
			this._definitionView.onUserInfoChanged(_loc2_);
		}
		
		private function getLimitDefinitionArray() : Array {
			var _loc3_:EnumItem = null;
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2_:Array = new Array();
			var _loc4_:uint = 0;
			while(_loc4_ < _loc1_.curActor.movieModel.qualityDefinitionControlList.length) {
				_loc3_ = _loc1_.curActor.movieModel.qualityDefinitionControlList[_loc4_];
				if(_loc3_ != null) {
					_loc2_.push(_loc3_);
				}
				_loc4_++;
			}
			_loc2_.sortOn("id",Array.DESCENDING | Array.NUMERIC);
			return _loc2_;
		}
		
		private function getDefinitionArray() : Array {
			var _loc3_:EnumItem = null;
			var _loc6_:uint = 0;
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2_:Array = new Array();
			var _loc4_:* = false;
			var _loc5_:uint = 0;
			while(_loc5_ < _loc1_.curActor.movieModel.curAudioTrackInfo.definitionCount) {
				_loc4_ = false;
				_loc3_ = _loc1_.curActor.movieModel.curAudioTrackInfo.findDefinitionInfoAt(_loc5_).type;
				if(_loc3_ != null) {
					if(_loc1_.curActor.movieModel.qualityDefinitionControlType != DefinitionControlTypeEnum.NONE) {
						_loc6_ = 0;
						while(_loc6_ < _loc1_.curActor.movieModel.qualityDefinitionControlList.length) {
							if(_loc3_.id == (_loc1_.curActor.movieModel.qualityDefinitionControlList[_loc6_] as EnumItem).id) {
								_loc4_ = true;
							}
							_loc6_++;
						}
						if(!_loc4_) {
							_loc2_.push(_loc3_);
						}
					} else {
						_loc2_.push(_loc3_);
					}
				}
				_loc5_++;
			}
			_loc2_.sortOn("id",Array.DESCENDING | Array.NUMERIC);
			if(_loc2_[0] == DefinitionEnum.LIMIT) {
				_loc2_.push(_loc2_.shift());
			}
			_loc2_.push(DefinitionEnum.NONE);
			return _loc2_;
		}
	}
}
