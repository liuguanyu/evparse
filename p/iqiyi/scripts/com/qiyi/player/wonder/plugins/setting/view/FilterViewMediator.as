package com.qiyi.player.wonder.plugins.setting.view {
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
	
	public class FilterViewMediator extends Mediator {
		
		public function FilterViewMediator(param1:FilterView) {
			super(NAME,param1);
			this._filterView = param1;
		}
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.setting.view.FilterViewMediator";
		
		private var _settingProxy:SettingProxy;
		
		private var _filterView:FilterView;
		
		override public function onRegister() : void {
			super.onRegister();
			this._settingProxy = facade.retrieveProxy(SettingProxy.NAME) as SettingProxy;
			this._filterView.addEventListener(SettingEvent.Evt_FilterOpen,this.onFilterViewOpen);
			this._filterView.addEventListener(SettingEvent.Evt_FilterClose,this.onFilterViewClose);
			this._filterView.addEventListener(SettingEvent.Evt_FilterSexRadioClick,this.onFilterFilterSexRadioClick);
			this._filterView.addEventListener(SettingEvent.Evt_FilterConfirmBtnClick,this.onFilterConfirmBtnClick);
		}
		
		override public function listNotificationInterests() : Array {
			return [SettingDef.NOTIFIC_ADD_STATUS,SettingDef.NOTIFIC_REMOVE_STATUS,SettingDef.NOTIFIC_FILTER_SKIP_MOVIECLIP,BodyDef.NOTIFIC_RESIZE,BodyDef.NOTIFIC_CHECK_USER_COMPLETE,BodyDef.NOTIFIC_PLAYER_ADD_STATUS,BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR,BodyDef.NOTIFIC_FULL_SCREEN];
		}
		
		override public function handleNotification(param1:INotification) : void {
			super.handleNotification(param1);
			var _loc2_:Object = param1.getBody();
			var _loc3_:String = param1.getName();
			var _loc4_:String = param1.getType();
			switch(_loc3_) {
				case SettingDef.NOTIFIC_ADD_STATUS:
					if(int(_loc2_) == SettingDef.STATUS_FILTER_OPEN) {
						this.setCommonPanelAttribute();
						sendNotification(ADDef.NOTIFIC_POPUP_OPEN);
					}
					this._filterView.onAddStatus(int(_loc2_));
					break;
				case SettingDef.NOTIFIC_REMOVE_STATUS:
					this._filterView.onRemoveStatus(int(_loc2_));
					if(int(_loc2_) == SettingDef.STATUS_FILTER_OPEN) {
						sendNotification(ADDef.NOTIFIC_POPUP_CLOSE);
					}
					break;
				case SettingDef.NOTIFIC_FILTER_SKIP_MOVIECLIP:
					this._filterView.playSkipMovieClip();
					break;
				case BodyDef.NOTIFIC_RESIZE:
					this._filterView.onResize(_loc2_.w,_loc2_.h);
					break;
				case BodyDef.NOTIFIC_CHECK_USER_COMPLETE:
					this.onCheckUserComplete();
					break;
				case BodyDef.NOTIFIC_PLAYER_ADD_STATUS:
					this.onPlayerStatusChanged(int(_loc2_),true,_loc4_);
					break;
				case BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR:
					this._settingProxy.removeStatus(SettingDef.STATUS_FILTER_OPEN);
					break;
				case BodyDef.NOTIFIC_FULL_SCREEN:
					this._filterView.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
					break;
			}
		}
		
		private function onPlayerStatusChanged(param1:int, param2:Boolean, param3:String) : void {
			if(param3 != BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR) {
				return;
			}
			switch(param1) {
				case BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE:
				case BodyDef.PLAYER_STATUS_STOPED:
				case BodyDef.PLAYER_STATUS_STOPPING:
				case BodyDef.PLAYER_STATUS_FAILED:
					if(param2) {
						this._settingProxy.removeStatus(SettingDef.STATUS_FILTER_OPEN);
					}
					break;
			}
		}
		
		private function onFilterViewOpen(param1:SettingEvent) : void {
			if(!this._settingProxy.hasStatus(SettingDef.STATUS_FILTER_OPEN)) {
				this._settingProxy.addStatus(SettingDef.STATUS_FILTER_OPEN);
			}
		}
		
		private function onFilterViewClose(param1:SettingEvent) : void {
			if(this._settingProxy.hasStatus(SettingDef.STATUS_FILTER_OPEN)) {
				this._settingProxy.removeStatus(SettingDef.STATUS_FILTER_OPEN);
			}
		}
		
		private function onFilterConfirmBtnClick(param1:SettingEvent) : void {
			var _loc2_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc3_:Boolean = _loc2_.curActor.movieModel.hasEnjoyableSubType(SkipPointEnum.ENJOYABLE_SUB_MALE);
			var _loc4_:Boolean = _loc2_.curActor.movieModel.hasEnjoyableSubType(SkipPointEnum.ENJOYABLE_SUB_FEMALE);
			var _loc5_:EnumItem = param1.data.curSex as EnumItem;
			var _loc6_:uint = param1.data.timeIndex;
			if((_loc2_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) && (!(_loc5_ == _loc2_.curActor.movieModel.curEnjoyableSubType) || !(_loc6_ == _loc2_.curActor.movieModel.curEnjoyableSubDurationIndex))) {
				_loc2_.curActor.setEnjoyableSubType(_loc5_,_loc6_);
				_loc2_.preActor.setEnjoyableSubType(_loc5_,_loc6_);
				switch(_loc5_) {
					case SkipPointEnum.ENJOYABLE_SUB_MALE:
						sendNotification(TipsDef.NOTIFIC_UPDATE_TIP_ATTR,{
							"attr":TipsDef.TIP_ATTR_NAME_FILTER_TYPE,
							"value":((_loc3_) || (_loc4_)?TipsDef.CONSTANT_FILTER_MALE:"")
						});
						break;
					case SkipPointEnum.ENJOYABLE_SUB_FEMALE:
						sendNotification(TipsDef.NOTIFIC_UPDATE_TIP_ATTR,{
							"attr":TipsDef.TIP_ATTR_NAME_FILTER_TYPE,
							"value":((_loc3_) || (_loc4_)?TipsDef.CONSTANT_FILTER_FEMALE:"")
						});
						break;
					default:
						sendNotification(TipsDef.NOTIFIC_UPDATE_TIP_ATTR,{
							"attr":TipsDef.TIP_ATTR_NAME_FILTER_TYPE,
							"value":((_loc3_) || (_loc4_)?TipsDef.CONSTANT_FILTER_COMMON:"")
						});
				}
				sendNotification(TipsDef.NOTIFIC_REQUEST_SHOW_TIP,TipsDef.TIP_ID_FILTER_OPEN_TIP);
			}
		}
		
		private function onFilterFilterSexRadioClick(param1:SettingEvent) : void {
			var _loc2_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc2_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) {
				this._filterView.setPanelTimeAttribute(_loc2_.curActor.movieModel.getEnjoyableSubDurationList(param1.data as EnumItem));
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
			this._filterView.onUserInfoChanged(_loc2_);
		}
		
		private function checkHavNestEnjoyableSkip() : Boolean {
			var _loc2_:uint = 0;
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) {
				_loc2_ = 0;
				while(_loc2_ < _loc1_.curActor.movieModel.skipPointInfoCount) {
					if(_loc1_.curActor.movieModel.getSkipPointInfoAt(_loc2_).skipPointType == SkipPointEnum.ENJOYABLE) {
						if(_loc1_.curActor.currentTime < _loc1_.curActor.movieModel.getSkipPointInfoAt(_loc2_).endTime) {
							return true;
						}
					}
					_loc2_++;
				}
			}
			return false;
		}
		
		private function setCommonPanelAttribute() : void {
			var _loc2_:* = false;
			var _loc3_:* = false;
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			this._filterView.guessSex = UserManager.getInstance().userLocalSex.getSex();
			if(_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) {
				_loc2_ = _loc1_.curActor.movieModel.hasEnjoyableSubType(SkipPointEnum.ENJOYABLE_SUB_MALE);
				_loc3_ = _loc1_.curActor.movieModel.hasEnjoyableSubType(SkipPointEnum.ENJOYABLE_SUB_FEMALE);
				this._filterView.setPanelSexAttribute(_loc1_.curActor.movieModel.curEnjoyableSubType,this.getSexList());
				this._filterView.setPanelTimeAttribute(this.getSexData(_loc1_.curActor.movieModel.curEnjoyableSubType),_loc1_.curActor.movieModel.curEnjoyableSubDurationIndex);
			}
		}
		
		private function getSexList() : Vector.<EnumItem> {
			var _loc3_:* = false;
			var _loc4_:* = false;
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2_:Vector.<EnumItem> = new Vector.<EnumItem>();
			if(_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) {
				_loc3_ = _loc1_.curActor.movieModel.hasEnjoyableSubType(SkipPointEnum.ENJOYABLE_SUB_MALE);
				_loc4_ = _loc1_.curActor.movieModel.hasEnjoyableSubType(SkipPointEnum.ENJOYABLE_SUB_FEMALE);
				if((_loc3_) && (_loc4_)) {
					_loc2_.push(SkipPointEnum.ENJOYABLE_SUB_MALE);
					_loc2_.push(SkipPointEnum.ENJOYABLE_SUB_FEMALE);
				} else if((_loc3_) && !_loc4_) {
					_loc2_.push(SkipPointEnum.ENJOYABLE_SUB_COMMON);
					_loc2_.push(SkipPointEnum.ENJOYABLE_SUB_MALE);
				} else if(!_loc3_ && (_loc4_)) {
					_loc2_.push(SkipPointEnum.ENJOYABLE_SUB_COMMON);
					_loc2_.push(SkipPointEnum.ENJOYABLE_SUB_FEMALE);
				} else {
					_loc2_.push(SkipPointEnum.ENJOYABLE_SUB_COMMON);
				}
				
				
			}
			return _loc2_;
		}
		
		private function getSexData(param1:EnumItem) : Array {
			var _loc3_:Array = null;
			var _loc2_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc2_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) {
				_loc3_ = _loc2_.curActor.movieModel.getEnjoyableSubDurationList(param1);
			}
			return _loc3_;
		}
	}
}
