package com.qiyi.player.wonder.plugins.setting.view
{
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
	
	public class DefinitionViewMediator extends Mediator
	{
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.setting.view.DefinitionViewMediator";
		
		private var _settingProxy:SettingProxy;
		
		private var _definitionView:DefinitionView;
		
		public function DefinitionViewMediator(param1:DefinitionView)
		{
			super(NAME,param1);
			this._definitionView = param1;
		}
		
		override public function onRegister() : void
		{
			super.onRegister();
			this._settingProxy = facade.retrieveProxy(SettingProxy.NAME) as SettingProxy;
			this._definitionView.addEventListener(SettingEvent.Evt_DefinitionOpen,this.onDefinitionViewOpen);
			this._definitionView.addEventListener(SettingEvent.Evt_DefinitionClose,this.onDefinitionViewClose);
			this._definitionView.addEventListener(SettingEvent.Evt_DefinitionChangeClick,this.onDefinitionViewChangeClick);
		}
		
		override public function listNotificationInterests() : Array
		{
			return [SettingDef.NOTIFIC_ADD_STATUS,SettingDef.NOTIFIC_REMOVE_STATUS,BodyDef.NOTIFIC_CHECK_USER_COMPLETE,BodyDef.NOTIFIC_PLAYER_ADD_STATUS,BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR,BodyDef.NOTIFIC_FULL_SCREEN,BodyDef.NOTIFIC_PLAYER_DEFINITION_SWITCHED];
		}
		
		override public function handleNotification(param1:INotification) : void
		{
			var _loc5:ControllBarProxy = null;
			var _loc6:PlayerProxy = null;
			super.handleNotification(param1);
			var _loc2:Object = param1.getBody();
			var _loc3:String = param1.getName();
			var _loc4:String = param1.getType();
			switch(_loc3)
			{
				case SettingDef.NOTIFIC_ADD_STATUS:
					_loc5 = facade.retrieveProxy(ControllBarProxy.NAME) as ControllBarProxy;
					_loc6 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
					if(int(_loc2) == SettingDef.STATUS_DEFINITION_OPEN)
					{
						this._definitionView.initUI(_loc5.definitionBtnX,_loc5.definitionBtnY,this.getDefinitionArray(),_loc6.curActor.movieModel.qualityDefinitionControlType != DefinitionControlTypeEnum.NONE?this.getLimitDefinitionArray():[],Settings.instance.autoMatchRate?DefinitionEnum.NONE:null,_loc6.curActor.movieModel.curDefinitionInfo.type.id);
						sendNotification(ADDef.NOTIFIC_POPUP_OPEN);
					}
					this._definitionView.onAddStatus(int(_loc2));
					break;
				case SettingDef.NOTIFIC_REMOVE_STATUS:
					this._definitionView.onRemoveStatus(int(_loc2));
					if(int(_loc2) == SettingDef.STATUS_DEFINITION_OPEN)
					{
						sendNotification(ADDef.NOTIFIC_POPUP_CLOSE);
					}
					break;
				case BodyDef.NOTIFIC_CHECK_USER_COMPLETE:
					this.onCheckUserComplete();
					break;
				case BodyDef.NOTIFIC_PLAYER_ADD_STATUS:
					this.onPlayerStatusChanged(int(_loc2),true,_loc4);
					break;
				case BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR:
					TweenLite.killTweensOf(this.onPlayerDefinitionSwitchComplete);
					this._settingProxy.removeStatus(SettingDef.STATUS_DEFINITION_OPEN);
					break;
				case BodyDef.NOTIFIC_FULL_SCREEN:
					this.onFullScreen(Boolean(_loc2));
					break;
				case BodyDef.NOTIFIC_PLAYER_DEFINITION_SWITCHED:
					if(_loc4 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
					{
						this.onPlayerDefinitionSwitched(int(_loc2));
					}
					break;
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
					if(param2)
					{
						TweenLite.killTweensOf(this.onPlayerDefinitionSwitchComplete);
					}
				case BodyDef.PLAYER_STATUS_STOPED:
				case BodyDef.PLAYER_STATUS_STOPPING:
				case BodyDef.PLAYER_STATUS_FAILED:
					if(param2)
					{
						this._settingProxy.removeStatus(SettingDef.STATUS_DEFINITION_OPEN);
					}
					break;
			}
		}
		
		private function onFullScreen(param1:Boolean) : void
		{
			var _loc2:PlayerProxy = null;
			var _loc3:EnumItem = null;
			if(param1)
			{
				_loc2 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
				if(_loc2.curActor.movieModel)
				{
					_loc3 = _loc2.curActor.movieModel.curDefinitionInfo.type;
					if(_loc3 == DefinitionEnum.LIMIT)
					{
						sendNotification(TopBarDef.NOTIFIC_REQUEST_SCALE,TopBarDef.SCALE_VALUE_75);
						sendNotification(TipsDef.NOTIFIC_REQUEST_SHOW_TIP,TipsDef.TIP_ID_CHANG_SIZE_75);
					}
				}
			}
		}
		
		private function onPlayerDefinitionSwitched(param1:int) : void
		{
			if(param1 >= 0)
			{
				TweenLite.killTweensOf(this.onPlayerDefinitionSwitchComplete);
				TweenLite.delayedCall(param1 / 1000,this.onPlayerDefinitionSwitchComplete);
			}
		}
		
		private function onPlayerDefinitionSwitchComplete() : void
		{
			var _loc1:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc1.curActor.movieModel)
			{
				this._definitionView.setChangeVidComplete(_loc1.curActor.movieModel.curDefinitionInfo.type);
			}
		}
		
		private function onDefinitionViewOpen(param1:SettingEvent) : void
		{
			if(!this._settingProxy.hasStatus(SettingDef.STATUS_DEFINITION_OPEN))
			{
				this._settingProxy.addStatus(SettingDef.STATUS_DEFINITION_OPEN);
			}
		}
		
		private function onDefinitionViewClose(param1:SettingEvent) : void
		{
			if(this._settingProxy.hasStatus(SettingDef.STATUS_DEFINITION_OPEN))
			{
				this._settingProxy.removeStatus(SettingDef.STATUS_DEFINITION_OPEN);
			}
		}
		
		private function onDefinitionViewChangeClick(param1:SettingEvent) : void
		{
			var _loc2:PlayerProxy = null;
			var _loc4:EnumItem = null;
			var _loc5:Date = null;
			var _loc6:* = NaN;
			_loc2 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc3:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			if(param1.data as EnumItem == DefinitionEnum.NONE)
			{
				Settings.instance.autoMatchRate = true;
			}
			else if(_loc2.curActor.movieModel.hasDefinitionByType(param1.data as EnumItem))
			{
				if(_loc2.curActor.movieModel)
				{
					_loc4 = _loc2.curActor.movieModel.curDefinitionInfo.type;
					if((param1.data) && (_loc4) && !(_loc4 == param1.data))
					{
						PingBack.getInstance().switchDefinition(_loc4.id,EnumItem(param1.data).id);
					}
				}
				Settings.instance.autoMatchRate = false;
				Settings.instance.definition = param1.data as EnumItem;
				if((FlashVarConfig.outsite) && (param1.data == DefinitionEnum.SUPER_HIGH || param1.data == DefinitionEnum.FULL_HD))
				{
					sendNotification(BodyDef.NOTIFIC_PLAYER_PAUSE);
					Settings.update();
					GlobalStage.setNormalScreen();
					navigateToURL(new URLRequest(_loc2.curActor.movieInfo.pageUrl),"_blank");
				}
			}
			else if(_loc3.userLevel != UserDef.USER_LEVEL_NORMAL)
			{
				Settings.instance.autoMatchRate = false;
				Settings.instance.definition = param1.data as EnumItem;
				sendNotification(BodyDef.NOTIFIC_PLAYER_REFRESH);
			}
			else
			{
				switch(_loc2.curActor.movieModel.qualityDefinitionControlType)
				{
					case DefinitionControlTypeEnum.BYTIME:
						_loc5 = new Date(_loc2.curActor.serverTime * 1000);
						_loc6 = _loc5.getHours() * 60 * 60 + _loc5.getMinutes() * 60 + _loc5.getSeconds();
						if(_loc6 < _loc2.curActor.movieModel.qualityDefinitionControlTimeRange.st || _loc6 > _loc2.curActor.movieModel.qualityDefinitionControlTimeRange.et)
						{
							Settings.instance.autoMatchRate = false;
							Settings.instance.definition = param1.data as EnumItem;
							sendNotification(BodyDef.NOTIFIC_PLAYER_REFRESH);
						}
						else
						{
							sendNotification(SceneTileDef.NOTIFIC_OPEN_CLOSE_STREAM_LIMIT,param1.data);
						}
						break;
					default:
						sendNotification(SceneTileDef.NOTIFIC_OPEN_CLOSE_STREAM_LIMIT,param1.data);
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
			this._definitionView.onUserInfoChanged(_loc2);
		}
		
		private function getLimitDefinitionArray() : Array
		{
			var _loc3:EnumItem = null;
			var _loc1:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2:Array = new Array();
			var _loc4:uint = 0;
			while(_loc4 < _loc1.curActor.movieModel.qualityDefinitionControlList.length)
			{
				_loc3 = _loc1.curActor.movieModel.qualityDefinitionControlList[_loc4];
				if(_loc3 != null)
				{
					_loc2.push(_loc3);
				}
				_loc4++;
			}
			_loc2.sortOn("id",Array.DESCENDING | Array.NUMERIC);
			return _loc2;
		}
		
		private function getDefinitionArray() : Array
		{
			var _loc3:EnumItem = null;
			var _loc6:uint = 0;
			var _loc1:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2:Array = new Array();
			var _loc4:* = false;
			var _loc5:uint = 0;
			while(_loc5 < _loc1.curActor.movieModel.curAudioTrackInfo.definitionCount)
			{
				_loc4 = false;
				_loc3 = _loc1.curActor.movieModel.curAudioTrackInfo.findDefinitionInfoAt(_loc5).type;
				if(_loc3 != null)
				{
					if(_loc1.curActor.movieModel.qualityDefinitionControlType != DefinitionControlTypeEnum.NONE)
					{
						_loc6 = 0;
						while(_loc6 < _loc1.curActor.movieModel.qualityDefinitionControlList.length)
						{
							if(_loc3.id == (_loc1.curActor.movieModel.qualityDefinitionControlList[_loc6] as EnumItem).id)
							{
								_loc4 = true;
							}
							_loc6++;
						}
						if(!_loc4)
						{
							_loc2.push(_loc3);
						}
					}
					else
					{
						_loc2.push(_loc3);
					}
				}
				_loc5++;
			}
			_loc2.sortOn("id",Array.DESCENDING | Array.NUMERIC);
			if(_loc2[0] == DefinitionEnum.LIMIT)
			{
				_loc2.push(_loc2.shift());
			}
			_loc2.push(DefinitionEnum.NONE);
			return _loc2;
		}
	}
}
