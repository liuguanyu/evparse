package com.qiyi.player.wonder.plugins.setting.view
{
	import com.iqiyi.components.panelSystem.impls.BasePanel;
	import com.qiyi.player.wonder.common.status.Status;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.core.model.impls.subtitle.Language;
	import com.qiyi.player.core.model.IAudioTrackInfo;
	import common.CommonBg;
	import common.CommonCloseBtn;
	import flash.text.TextField;
	import com.qiyi.player.wonder.plugins.setting.view.parts.Subtitles;
	import com.qiyi.player.wonder.plugins.setting.view.parts.SoundTrackLanguage;
	import com.qiyi.player.wonder.common.ui.SelectTextField;
	import common.CommonGreenBtn;
	import com.qiyi.player.wonder.common.ui.FastCreator;
	import flash.events.MouseEvent;
	import com.iqiyi.components.global.GlobalStage;
	import com.qiyi.player.wonder.plugins.setting.SettingDef;
	import flash.display.DisplayObjectContainer;
	import gs.TweenLite;
	import com.qiyi.player.wonder.body.BodyDef;
	
	public class SettingView extends BasePanel
	{
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.setting.view.SettingView";
		
		public static const SETTING_STR:String = "设置";
		
		private var _status:Status;
		
		private var _userInfoVO:UserInfoVO;
		
		private var _subtitlesLangTypeVector:Vector.<Language>;
		
		private var _soundTrackLangVector:Vector.<IAudioTrackInfo>;
		
		private var _bg:CommonBg;
		
		private var _closeBtn:CommonCloseBtn;
		
		private var _settingTF:TextField;
		
		private var _subtitles:Subtitles;
		
		private var _soundTrackLanguage:SoundTrackLanguage;
		
		private var _setDefaultTF:SelectTextField;
		
		private var _confirmTF:TextField;
		
		private var _confirmBtn:CommonGreenBtn;
		
		public function SettingView(param1:DisplayObjectContainer, param2:Status, param3:UserInfoVO)
		{
			super(NAME,param1);
			type = BodyDef.VIEW_TYPE_POPUP;
			this._status = param2;
			this._userInfoVO = param3;
			this.initUI();
		}
		
		public function get soundTrackLanguage() : SoundTrackLanguage
		{
			return this._soundTrackLanguage;
		}
		
		public function get subtitles() : Subtitles
		{
			return this._subtitles;
		}
		
		private function initUI() : void
		{
			this._bg = new CommonBg();
			this._bg.width = 400;
			addChild(this._bg);
			this._closeBtn = new CommonCloseBtn();
			this._closeBtn.x = this._bg.width - this._closeBtn.width - 5;
			this._closeBtn.y = 1;
			addChild(this._closeBtn);
			this._settingTF = FastCreator.createLabel(SETTING_STR,13421772,14);
			this._settingTF.x = 20;
			this._settingTF.y = 12;
			addChild(this._settingTF);
			this._subtitles = new Subtitles();
			this._subtitles.x = 45;
			addChild(this._subtitles);
			this._soundTrackLanguage = new SoundTrackLanguage();
			this._soundTrackLanguage.x = 45;
			addChild(this._soundTrackLanguage);
			this._setDefaultTF = new SelectTextField("恢复默认");
			this._setDefaultTF.x = 170;
			addChild(this._setDefaultTF);
			this._confirmBtn = new CommonGreenBtn();
			this._confirmBtn.x = 260;
			addChild(this._confirmBtn);
			this._confirmTF = FastCreator.createLabel("确认",16777215,14);
			this._confirmTF.x = this._confirmBtn.x + (this._confirmBtn.width - this._confirmTF.textWidth) / 2;
			this._confirmTF.selectable = this._confirmTF.mouseEnabled = false;
			addChild(this._confirmTF);
			this._setDefaultTF.addEventListener(MouseEvent.CLICK,this.onSetDefaultTFClick);
			this._confirmBtn.addEventListener(MouseEvent.CLICK,this.onConfirmBtnClick);
			this._closeBtn.addEventListener(MouseEvent.CLICK,this.onCloseBtnClick);
		}
		
		public function set subtitlesLangTypeVector(param1:Vector.<Language>) : void
		{
			this._subtitlesLangTypeVector = param1;
			if((this._subtitles) && (this._subtitlesLangTypeVector))
			{
				this._subtitles.visible = true;
				this._subtitles.initSubtitles(param1);
			}
			else
			{
				this._subtitles.visible = false;
			}
			this.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
		}
		
		public function set soundTrackLangVector(param1:Vector.<IAudioTrackInfo>) : void
		{
			this._soundTrackLangVector = param1;
			if((this._soundTrackLangVector) && (this._soundTrackLanguage))
			{
				this._soundTrackLanguage.visible = true;
				this._soundTrackLanguage.soundTrackLangVector = this._soundTrackLangVector;
			}
			else
			{
				this._soundTrackLanguage.visible = false;
			}
			this.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
		}
		
		public function onUserInfoChanged(param1:UserInfoVO) : void
		{
			this._userInfoVO = param1;
		}
		
		public function onAddStatus(param1:int) : void
		{
			this._status.addStatus(param1);
			switch(param1)
			{
				case SettingDef.STATUS_OPEN:
					this.open();
					break;
			}
		}
		
		public function onRemoveStatus(param1:int) : void
		{
			this._status.removeStatus(param1);
			switch(param1)
			{
				case SettingDef.STATUS_OPEN:
					this.close();
					break;
			}
		}
		
		public function onResize(param1:int, param2:int) : void
		{
			this.x = (param1 - this._bg.width) / 2;
			this.y = (param2 - height) / 2;
			this._subtitles.y = 50;
			this._soundTrackLanguage.y = this._subtitles.y + this._subtitles.height * int(this._subtitles.visible);
			if(this._subtitles.visible)
			{
				if(this._soundTrackLanguage.visible)
				{
					this._bg.height = 260;
					this._setDefaultTF.y = this._confirmBtn.y = this._soundTrackLanguage.y + 36;
				}
				else
				{
					this._bg.height = 215;
					this._setDefaultTF.y = this._confirmBtn.y = this._subtitles.y + this._subtitles.height + 10;
				}
			}
			else if(this._soundTrackLanguage.visible)
			{
				this._bg.height = 135;
				this._setDefaultTF.y = this._confirmBtn.y = this._soundTrackLanguage.y + 36;
			}
			
			this._confirmTF.y = this._confirmBtn.y + 2;
		}
		
		override public function open(param1:DisplayObjectContainer = null) : void
		{
			if(!isOnStage)
			{
				super.open(param1);
				dispatchEvent(new SettingEvent(SettingEvent.Evt_Open));
			}
		}
		
		override public function close() : void
		{
			if(isOnStage)
			{
				super.close();
				dispatchEvent(new SettingEvent(SettingEvent.Evt_Close));
			}
		}
		
		override protected function onAddToStage() : void
		{
			super.onAddToStage();
			this.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
			alpha = 0;
			TweenLite.to(this,BodyDef.POPUP_TWEEN_TIME / 1000,{"alpha":1});
		}
		
		override protected function onRemoveFromStage() : void
		{
			super.onRemoveFromStage();
			TweenLite.killTweensOf(this);
		}
		
		private function onSetDefaultTFClick(param1:MouseEvent) : void
		{
			if(this._soundTrackLanguage.visible)
			{
				this._soundTrackLanguage.resetClick();
			}
			if(this._subtitles.visible)
			{
				this._subtitles.resetClick();
			}
		}
		
		private function onConfirmBtnClick(param1:MouseEvent) : void
		{
			this.close();
		}
		
		private function onCloseBtnClick(param1:MouseEvent) : void
		{
			if(this._soundTrackLanguage.visible)
			{
				this._soundTrackLanguage.close();
			}
			if(this._subtitles.visible)
			{
				this._subtitles.close();
			}
			this.close();
		}
	}
}
