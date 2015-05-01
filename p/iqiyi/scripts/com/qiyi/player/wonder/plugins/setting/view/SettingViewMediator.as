package com.qiyi.player.wonder.plugins.setting.view {
	import org.puremvc.as3.patterns.mediator.Mediator;
	import com.qiyi.player.wonder.plugins.setting.model.SettingProxy;
	import com.qiyi.player.wonder.plugins.setting.SettingDef;
	import com.qiyi.player.wonder.plugins.topbar.TopBarDef;
	import com.qiyi.player.wonder.body.BodyDef;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.body.model.PlayerProxy;
	import com.qiyi.player.core.model.IAudioTrackInfo;
	import com.qiyi.player.core.model.impls.subtitle.Language;
	import com.qiyi.player.wonder.plugins.ad.ADDef;
	import com.qiyi.player.core.model.impls.pub.Settings;
	import com.qiyi.player.base.pub.EnumItem;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	
	public class SettingViewMediator extends Mediator {
		
		public function SettingViewMediator(param1:SettingView) {
			super(NAME,param1);
			this._settingView = param1;
		}
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.setting.view.SettingViewMediator";
		
		private var _settingProxy:SettingProxy;
		
		private var _settingView:SettingView;
		
		private var _titleSettingMouseOvered:Boolean = false;
		
		override public function onRegister() : void {
			super.onRegister();
			this._settingProxy = facade.retrieveProxy(SettingProxy.NAME) as SettingProxy;
			this._settingView.addEventListener(SettingEvent.Evt_Open,this.onSettingViewOpen);
			this._settingView.addEventListener(SettingEvent.Evt_Close,this.onSettingViewClose);
			this._settingView.subtitles.addEventListener(SettingEvent.Evt_TitleLanguageChanged,this.onLanguageChanged);
			this._settingView.subtitles.addEventListener(SettingEvent.Evt_TitleFontColorChanged,this.onFontColorChanged);
			this._settingView.subtitles.addEventListener(SettingEvent.Evt_TitleFontSizeChanged,this.onFontSizeChanged);
			this._settingView.soundTrackLanguage.addEventListener(SettingEvent.Evt_AudioTrackChanged,this.onAudioTrackChanged);
		}
		
		override public function listNotificationInterests() : Array {
			return [SettingDef.NOTIFIC_ADD_STATUS,SettingDef.NOTIFIC_REMOVE_STATUS,TopBarDef.NOTIFIC_SCREEN_SCALE_CHANGE,BodyDef.NOTIFIC_RESIZE,BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR,BodyDef.NOTIFIC_PLAYER_ADD_STATUS,BodyDef.NOTIFIC_CHECK_USER_COMPLETE];
		}
		
		override public function handleNotification(param1:INotification) : void {
			var _loc5_:PlayerProxy = null;
			var _loc6_:Vector.<IAudioTrackInfo> = null;
			var _loc7_:Vector.<Language> = null;
			var _loc8_:uint = 0;
			super.handleNotification(param1);
			var _loc2_:Object = param1.getBody();
			var _loc3_:String = param1.getName();
			var _loc4_:String = param1.getType();
			switch(_loc3_) {
				case SettingDef.NOTIFIC_ADD_STATUS:
					if(int(_loc2_) == SettingDef.STATUS_OPEN) {
						_loc5_ = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
						_loc6_ = new Vector.<IAudioTrackInfo>();
						_loc7_ = new Vector.<Language>();
						_loc8_ = 0;
						while(_loc8_ < _loc5_.curActor.movieModel.audioTrackCount) {
							_loc6_.push(_loc5_.curActor.movieModel.getAudioTrackInfoAt(_loc8_));
							_loc8_++;
						}
						_loc8_ = 0;
						while(_loc8_ < _loc5_.curActor.movieInfo.subtitles.length) {
							_loc7_.push(_loc5_.curActor.movieInfo.subtitles[_loc8_]);
							_loc8_++;
						}
						this._settingView.subtitlesLangTypeVector = _loc7_.length >= 1?_loc7_:null;
						this._settingView.soundTrackLangVector = _loc6_.length > 1?_loc6_:null;
						sendNotification(ADDef.NOTIFIC_POPUP_OPEN);
					}
					this._settingView.onAddStatus(int(_loc2_));
					break;
				case SettingDef.NOTIFIC_REMOVE_STATUS:
					if(int(_loc2_) == SettingDef.STATUS_OPEN) {
						sendNotification(ADDef.NOTIFIC_POPUP_CLOSE);
					}
					this._settingView.onRemoveStatus(int(_loc2_));
					break;
				case TopBarDef.NOTIFIC_SCREEN_SCALE_CHANGE:
					break;
				case BodyDef.NOTIFIC_RESIZE:
					this._settingView.onResize(_loc2_.w,_loc2_.h);
					break;
				case BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR:
					this._settingProxy.removeStatus(SettingDef.STATUS_OPEN);
					break;
				case BodyDef.NOTIFIC_PLAYER_ADD_STATUS:
					this.onPlayerStatusChanged(int(_loc2_),true,_loc4_);
					break;
				case BodyDef.NOTIFIC_CHECK_USER_COMPLETE:
					this.onCheckUserComplete();
					break;
			}
		}
		
		private function onSettingViewOpen(param1:SettingEvent) : void {
			if(!this._settingProxy.hasStatus(SettingDef.STATUS_OPEN)) {
				this._settingProxy.addStatus(SettingDef.STATUS_OPEN);
			}
		}
		
		private function onSettingViewClose(param1:SettingEvent) : void {
			if(this._settingProxy.hasStatus(SettingDef.STATUS_OPEN)) {
				this._settingProxy.removeStatus(SettingDef.STATUS_OPEN);
			}
		}
		
		private function onLanguageChanged(param1:SettingEvent) : void {
			Settings.instance.subtitleLang = param1.data as EnumItem;
		}
		
		private function onFontColorChanged(param1:SettingEvent) : void {
			Settings.instance.subtitleColor = int(param1.data);
		}
		
		private function onFontSizeChanged(param1:SettingEvent) : void {
			Settings.instance.subtitleSize = int(param1.data);
		}
		
		private function onAudioTrackChanged(param1:SettingEvent) : void {
			Settings.instance.audioTrack = param1.data as EnumItem;
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
			this._settingView.onUserInfoChanged(_loc2_);
		}
		
		private function onPlayerStatusChanged(param1:int, param2:Boolean, param3:String) : void {
			if(param3 != BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR) {
				return;
			}
			switch(param1) {
				case BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE:
				case BodyDef.PLAYER_STATUS_FAILED:
				case BodyDef.PLAYER_STATUS_STOPED:
					if(param2) {
						this._settingProxy.removeStatus(SettingDef.STATUS_OPEN);
					}
					break;
			}
		}
	}
}
