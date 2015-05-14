package com.qiyi.player.wonder.plugins.setting.view
{
	import org.puremvc.as3.patterns.mediator.Mediator;
	import com.qiyi.player.wonder.plugins.setting.model.SettingProxy;
	import com.qiyi.player.wonder.plugins.setting.SettingDef;
	import com.qiyi.player.wonder.body.BodyDef;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.plugins.ad.ADDef;
	import com.iqiyi.components.global.GlobalStage;
	import com.qiyi.player.wonder.body.model.PlayerProxy;
	import com.qiyi.player.core.model.def.SkipPointEnum;
	import com.qiyi.player.base.pub.EnumItem;
	import com.qiyi.player.wonder.plugins.tips.TipsDef;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.user.impls.UserManager;
	
	public class FilterViewMediator extends Mediator
	{
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.setting.view.FilterViewMediator";
		
		private var _settingProxy:SettingProxy;
		
		private var _filterView:FilterView;
		
		public function FilterViewMediator(param1:FilterView)
		{
			super(NAME,param1);
			this._filterView = param1;
		}
		
		override public function onRegister() : void
		{
			super.onRegister();
			this._settingProxy = facade.retrieveProxy(SettingProxy.NAME) as SettingProxy;
			this._filterView.addEventListener(SettingEvent.Evt_FilterOpen,this.onFilterViewOpen);
			this._filterView.addEventListener(SettingEvent.Evt_FilterClose,this.onFilterViewClose);
			this._filterView.addEventListener(SettingEvent.Evt_FilterSexRadioClick,this.onFilterFilterSexRadioClick);
			this._filterView.addEventListener(SettingEvent.Evt_FilterConfirmBtnClick,this.onFilterConfirmBtnClick);
		}
		
		override public function listNotificationInterests() : Array
		{
			return [SettingDef.NOTIFIC_ADD_STATUS,SettingDef.NOTIFIC_REMOVE_STATUS,SettingDef.NOTIFIC_FILTER_SKIP_MOVIECLIP,BodyDef.NOTIFIC_RESIZE,BodyDef.NOTIFIC_CHECK_USER_COMPLETE,BodyDef.NOTIFIC_PLAYER_ADD_STATUS,BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR,BodyDef.NOTIFIC_FULL_SCREEN];
		}
		
		override public function handleNotification(param1:INotification) : void
		{
			super.handleNotification(param1);
			var _loc2:Object = param1.getBody();
			var _loc3:String = param1.getName();
			var _loc4:String = param1.getType();
			switch(_loc3)
			{
				case SettingDef.NOTIFIC_ADD_STATUS:
					if(int(_loc2) == SettingDef.STATUS_FILTER_OPEN)
					{
						this.setCommonPanelAttribute();
						sendNotification(ADDef.NOTIFIC_POPUP_OPEN);
					}
					this._filterView.onAddStatus(int(_loc2));
					break;
				case SettingDef.NOTIFIC_REMOVE_STATUS:
					this._filterView.onRemoveStatus(int(_loc2));
					if(int(_loc2) == SettingDef.STATUS_FILTER_OPEN)
					{
						sendNotification(ADDef.NOTIFIC_POPUP_CLOSE);
					}
					break;
				case SettingDef.NOTIFIC_FILTER_SKIP_MOVIECLIP:
					this._filterView.playSkipMovieClip();
					break;
				case BodyDef.NOTIFIC_RESIZE:
					this._filterView.onResize(_loc2.w,_loc2.h);
					break;
				case BodyDef.NOTIFIC_CHECK_USER_COMPLETE:
					this.onCheckUserComplete();
					break;
				case BodyDef.NOTIFIC_PLAYER_ADD_STATUS:
					this.onPlayerStatusChanged(int(_loc2),true,_loc4);
					break;
				case BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR:
					this._settingProxy.removeStatus(SettingDef.STATUS_FILTER_OPEN);
					break;
				case BodyDef.NOTIFIC_FULL_SCREEN:
					this._filterView.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
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
				case BodyDef.PLAYER_STATUS_STOPED:
				case BodyDef.PLAYER_STATUS_STOPPING:
				case BodyDef.PLAYER_STATUS_FAILED:
					if(param2)
					{
						this._settingProxy.removeStatus(SettingDef.STATUS_FILTER_OPEN);
					}
					break;
			}
		}
		
		private function onFilterViewOpen(param1:SettingEvent) : void
		{
			if(!this._settingProxy.hasStatus(SettingDef.STATUS_FILTER_OPEN))
			{
				this._settingProxy.addStatus(SettingDef.STATUS_FILTER_OPEN);
			}
		}
		
		private function onFilterViewClose(param1:SettingEvent) : void
		{
			if(this._settingProxy.hasStatus(SettingDef.STATUS_FILTER_OPEN))
			{
				this._settingProxy.removeStatus(SettingDef.STATUS_FILTER_OPEN);
			}
		}
		
		private function onFilterConfirmBtnClick(param1:SettingEvent) : void
		{
			var _loc2:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc3:Boolean = _loc2.curActor.movieModel.hasEnjoyableSubType(SkipPointEnum.ENJOYABLE_SUB_MALE);
			var _loc4:Boolean = _loc2.curActor.movieModel.hasEnjoyableSubType(SkipPointEnum.ENJOYABLE_SUB_FEMALE);
			var _loc5:EnumItem = param1.data.curSex as EnumItem;
			var _loc6:uint = param1.data.timeIndex;
			if((_loc2.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) && (!(_loc5 == _loc2.curActor.movieModel.curEnjoyableSubType) || !(_loc6 == _loc2.curActor.movieModel.curEnjoyableSubDurationIndex)))
			{
				_loc2.curActor.setEnjoyableSubType(_loc5,_loc6);
				_loc2.preActor.setEnjoyableSubType(_loc5,_loc6);
				switch(_loc5)
				{
					case SkipPointEnum.ENJOYABLE_SUB_MALE:
						sendNotification(TipsDef.NOTIFIC_UPDATE_TIP_ATTR,{
							"attr":TipsDef.TIP_ATTR_NAME_FILTER_TYPE,
							"value":((_loc3) || (_loc4)?TipsDef.CONSTANT_FILTER_MALE:"")
						});
						break;
					case SkipPointEnum.ENJOYABLE_SUB_FEMALE:
						sendNotification(TipsDef.NOTIFIC_UPDATE_TIP_ATTR,{
							"attr":TipsDef.TIP_ATTR_NAME_FILTER_TYPE,
							"value":((_loc3) || (_loc4)?TipsDef.CONSTANT_FILTER_FEMALE:"")
						});
						break;
					default:
						sendNotification(TipsDef.NOTIFIC_UPDATE_TIP_ATTR,{
							"attr":TipsDef.TIP_ATTR_NAME_FILTER_TYPE,
							"value":((_loc3) || (_loc4)?TipsDef.CONSTANT_FILTER_COMMON:"")
						});
				}
				sendNotification(TipsDef.NOTIFIC_REQUEST_SHOW_TIP,TipsDef.TIP_ID_FILTER_OPEN_TIP);
			}
		}
		
		private function onFilterFilterSexRadioClick(param1:SettingEvent) : void
		{
			var _loc2:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc2.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY))
			{
				this._filterView.setPanelTimeAttribute(_loc2.curActor.movieModel.getEnjoyableSubDurationList(param1.data as EnumItem));
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
			this._filterView.onUserInfoChanged(_loc2);
		}
		
		private function checkHavNestEnjoyableSkip() : Boolean
		{
			var _loc2:uint = 0;
			var _loc1:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY))
			{
				_loc2 = 0;
				while(_loc2 < _loc1.curActor.movieModel.skipPointInfoCount)
				{
					if(_loc1.curActor.movieModel.getSkipPointInfoAt(_loc2).skipPointType == SkipPointEnum.ENJOYABLE)
					{
						if(_loc1.curActor.currentTime < _loc1.curActor.movieModel.getSkipPointInfoAt(_loc2).endTime)
						{
							return true;
						}
					}
					_loc2++;
				}
			}
			return false;
		}
		
		private function setCommonPanelAttribute() : void
		{
			var _loc2:* = false;
			var _loc3:* = false;
			var _loc1:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			this._filterView.guessSex = UserManager.getInstance().userLocalSex.getSex();
			if(_loc1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY))
			{
				_loc2 = _loc1.curActor.movieModel.hasEnjoyableSubType(SkipPointEnum.ENJOYABLE_SUB_MALE);
				_loc3 = _loc1.curActor.movieModel.hasEnjoyableSubType(SkipPointEnum.ENJOYABLE_SUB_FEMALE);
				this._filterView.setPanelSexAttribute(_loc1.curActor.movieModel.curEnjoyableSubType,this.getSexList());
				this._filterView.setPanelTimeAttribute(this.getSexData(_loc1.curActor.movieModel.curEnjoyableSubType),_loc1.curActor.movieModel.curEnjoyableSubDurationIndex);
			}
		}
		
		private function getSexList() : Vector.<EnumItem>
		{
			var _loc3:* = false;
			var _loc4:* = false;
			var _loc1:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2:Vector.<EnumItem> = new Vector.<EnumItem>();
			if(_loc1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY))
			{
				_loc3 = _loc1.curActor.movieModel.hasEnjoyableSubType(SkipPointEnum.ENJOYABLE_SUB_MALE);
				_loc4 = _loc1.curActor.movieModel.hasEnjoyableSubType(SkipPointEnum.ENJOYABLE_SUB_FEMALE);
				if((_loc3) && (_loc4))
				{
					_loc2.push(SkipPointEnum.ENJOYABLE_SUB_MALE);
					_loc2.push(SkipPointEnum.ENJOYABLE_SUB_FEMALE);
				}
				else if((_loc3) && !_loc4)
				{
					_loc2.push(SkipPointEnum.ENJOYABLE_SUB_COMMON);
					_loc2.push(SkipPointEnum.ENJOYABLE_SUB_MALE);
				}
				else if(!_loc3 && (_loc4))
				{
					_loc2.push(SkipPointEnum.ENJOYABLE_SUB_COMMON);
					_loc2.push(SkipPointEnum.ENJOYABLE_SUB_FEMALE);
				}
				else
				{
					_loc2.push(SkipPointEnum.ENJOYABLE_SUB_COMMON);
				}
				
				
			}
			return _loc2;
		}
		
		private function getSexData(param1:EnumItem) : Array
		{
			var _loc3:Array = null;
			var _loc2:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc2.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY))
			{
				_loc3 = _loc2.curActor.movieModel.getEnjoyableSubDurationList(param1);
			}
			return _loc3;
		}
	}
}
