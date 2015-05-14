package com.qiyi.player.wonder.plugins.scenetile.view
{
	import com.iqiyi.components.panelSystem.impls.BasePanel;
	import com.qiyi.player.wonder.common.status.Status;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import common.CommonBg;
	import common.CommonCloseBtn;
	import flash.text.TextField;
	import flash.display.Sprite;
	import com.qiyi.player.wonder.plugins.scenetile.SceneTileDef;
	import flash.display.DisplayObjectContainer;
	import gs.TweenLite;
	import com.qiyi.player.wonder.common.ui.FastCreator;
	import flash.text.TextFieldAutoSize;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import com.iqiyi.components.global.GlobalStage;
	import com.qiyi.player.base.pub.EnumItem;
	import com.qiyi.player.wonder.common.utils.StringUtils;
	import com.qiyi.player.wonder.common.utils.ChineseNameOfLangAudioDef;
	import com.qiyi.player.core.model.def.DefinitionControlTypeEnum;
	import com.qiyi.player.wonder.common.pingback.PingBack;
	import com.qiyi.player.wonder.common.pingback.PingBackDef;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import com.qiyi.player.wonder.common.config.SystemConfig;
	import com.qiyi.player.wonder.body.BodyDef;
	
	public class SceneTileStreamLimitView extends BasePanel
	{
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.scenetile.view.SceneTileStreamLimitView";
		
		private static const STR_TITLE_TIME_LIMIT:String = "{0}  是{1}画质<font color=\'#F15A24\'>" + "<a href=\'event:onTextLinkClick\'><u>VIP会员专属时段</u></a></font>";
		
		private static const STR_TITLE_AREA_LIMIT:String = "当前用户数量激增，" + "{0}画质优先<font color=\'#F15A24\'><a href=\'event:onTextLinkClick\'><u>保障VIP会员观看</u></a></font>";
		
		private static const STR_BTN_OPENMEMBER:String = "开通VIP会员，自由观看{0}视频";
		
		private static const STR_BTN_DOWNLOADCLIENT:String = "<a href=\'event:onTextLinkClick\'>" + "你可以使用<font color=\'#F15A24\'>桌面客户端</font>，{0}免费看</a>";
		
		private var _status:Status;
		
		private var _userInfoVO:UserInfoVO;
		
		private var _bg:CommonBg;
		
		private var _closeBtn:CommonCloseBtn;
		
		private var _tfLimitDescribe:TextField;
		
		private var _sprRegisteredMemberBtn:Sprite;
		
		private var _tfRegisteredMemberBtn:TextField;
		
		private var _tfDownLoadClientBtn:TextField;
		
		public function SceneTileStreamLimitView(param1:DisplayObjectContainer, param2:Status, param3:UserInfoVO)
		{
			super(NAME,param1);
			type = BodyDef.VIEW_TYPE_POPUP;
			this._status = param2;
			this._userInfoVO = param3;
			this.initUI();
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
				case SceneTileDef.STATUS_STREAM_LIMIT_OPEN:
					this.open();
					break;
			}
		}
		
		public function onRemoveStatus(param1:int) : void
		{
			this._status.removeStatus(param1);
			switch(param1)
			{
				case SceneTileDef.STATUS_STREAM_LIMIT_OPEN:
					this.close();
					break;
			}
		}
		
		public function onResize(param1:int, param2:int) : void
		{
			x = (param1 - this.width) * 0.5;
			y = (param2 - this.height) * 0.5;
		}
		
		override public function open(param1:DisplayObjectContainer = null) : void
		{
			if(!isOnStage)
			{
				super.open(param1);
				dispatchEvent(new SceneTileEvent(SceneTileEvent.Evt_DefinitLimitOpen));
			}
		}
		
		override public function close() : void
		{
			if(isOnStage)
			{
				super.close();
				TweenLite.killTweensOf(this.close);
				dispatchEvent(new SceneTileEvent(SceneTileEvent.Evt_DefinitLimitClose));
			}
		}
		
		override protected function onAddToStage() : void
		{
			super.onAddToStage();
		}
		
		override protected function onRemoveFromStage() : void
		{
			super.onRemoveFromStage();
		}
		
		private function initUI() : void
		{
			this._bg = new CommonBg();
			this._bg.width = 400;
			this._bg.height = 230;
			addChild(this._bg);
			this._tfLimitDescribe = FastCreator.createLabel(STR_TITLE_TIME_LIMIT,16777215,16,TextFieldAutoSize.LEFT);
			this._tfLimitDescribe.y = 40;
			addChild(this._tfLimitDescribe);
			this._sprRegisteredMemberBtn = new Sprite();
			this._sprRegisteredMemberBtn.useHandCursor = this._sprRegisteredMemberBtn.buttonMode = true;
			this._sprRegisteredMemberBtn.graphics.beginFill(15817252);
			this._sprRegisteredMemberBtn.graphics.drawRoundRect(0,0,280,40,5);
			this._sprRegisteredMemberBtn.graphics.endFill();
			addChild(this._sprRegisteredMemberBtn);
			this._sprRegisteredMemberBtn.x = (this._bg.width - this._sprRegisteredMemberBtn.width) * 0.5;
			this._sprRegisteredMemberBtn.y = this._tfLimitDescribe.y + 50;
			this._tfRegisteredMemberBtn = FastCreator.createLabel(STR_BTN_OPENMEMBER,16777215,14,TextFieldAutoSize.CENTER);
			this._tfRegisteredMemberBtn.x = this._sprRegisteredMemberBtn.x + (this._sprRegisteredMemberBtn.width - this._tfRegisteredMemberBtn.width) * 0.5;
			this._tfRegisteredMemberBtn.y = this._sprRegisteredMemberBtn.y + (this._sprRegisteredMemberBtn.height - this._tfRegisteredMemberBtn.height) * 0.5;
			this._tfRegisteredMemberBtn.selectable = this._tfRegisteredMemberBtn.mouseEnabled = false;
			addChild(this._tfRegisteredMemberBtn);
			this._tfDownLoadClientBtn = FastCreator.createLabel(STR_BTN_DOWNLOADCLIENT,16777215,14,TextFieldAutoSize.CENTER);
			this._tfDownLoadClientBtn.htmlText = STR_BTN_DOWNLOADCLIENT;
			this._tfDownLoadClientBtn.x = (this._bg.width - this._tfDownLoadClientBtn.width) * 0.5;
			this._tfDownLoadClientBtn.y = this._sprRegisteredMemberBtn.y + this._sprRegisteredMemberBtn.height + 20;
			addChild(this._tfDownLoadClientBtn);
			this._closeBtn = new CommonCloseBtn();
			this._closeBtn.x = this._bg.width - this._closeBtn.width - 5;
			this._closeBtn.y = 1;
			addChild(this._closeBtn);
			this._closeBtn.addEventListener(MouseEvent.CLICK,this.onCloseBtnClick);
			this._tfLimitDescribe.addEventListener(TextEvent.LINK,this.onLimitDescribeLinkClick);
			this._sprRegisteredMemberBtn.addEventListener(MouseEvent.CLICK,this.onRegisteredMemberBtnClick);
			this._tfDownLoadClientBtn.addEventListener(TextEvent.LINK,this.onDownLoadClientBtnClick);
			this.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
		}
		
		public function setPanelAttribute(param1:EnumItem, param2:EnumItem = null, param3:Object = null) : void
		{
			var _loc5:String = null;
			var _loc4:* = "";
			switch(param2)
			{
				case DefinitionControlTypeEnum.BYTIME:
					if(param3)
					{
						_loc5 = this.getHoursBySeconds(param3.st) + " ~ " + this.getHoursBySeconds(param3.et);
						_loc4 = StringUtils.substitute(STR_TITLE_TIME_LIMIT,_loc5,ChineseNameOfLangAudioDef.getDefinitionName(param1));
					}
					else
					{
						_loc4 = StringUtils.substitute(STR_TITLE_AREA_LIMIT,ChineseNameOfLangAudioDef.getDefinitionName(param1));
					}
					break;
				case DefinitionControlTypeEnum.BYAREA:
				case DefinitionControlTypeEnum.BYIDC:
					_loc4 = StringUtils.substitute(STR_TITLE_AREA_LIMIT,ChineseNameOfLangAudioDef.getDefinitionName(param1));
					break;
				default:
					_loc4 = StringUtils.substitute(STR_TITLE_AREA_LIMIT,ChineseNameOfLangAudioDef.getDefinitionName(param1));
			}
			this._tfRegisteredMemberBtn.text = StringUtils.substitute(STR_BTN_OPENMEMBER,ChineseNameOfLangAudioDef.getDefinitionName(param1));
			this._tfDownLoadClientBtn.htmlText = StringUtils.substitute(STR_BTN_DOWNLOADCLIENT,ChineseNameOfLangAudioDef.getDefinitionName(param1));
			this._tfLimitDescribe.htmlText = _loc4;
			this._tfLimitDescribe.x = (this._bg.width - this._tfLimitDescribe.width) * 0.5;
			this.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
		}
		
		private function onRegisteredMemberBtnClick(param1:MouseEvent) : void
		{
			GlobalStage.setNormalScreen();
			PingBack.getInstance().userActionPing_4_0(PingBackDef.DEFIN_LIMIT_SHOWCLICK);
			navigateToURL(new URLRequest("http://serv.vip.iqiyi.com/order/preview.action" + "?pid=a0226bd958843452" + "&platform=b6c13e26323c537d" + "&fc=a50752baab740e33"),"_self");
		}
		
		private function onDownLoadClientBtnClick(param1:TextEvent) : void
		{
			GlobalStage.setNormalScreen();
			PingBack.getInstance().userActionPing_4_0(PingBackDef.DEFIN_LIMIT_DOWNLOADCLICK);
			if(Capabilities.version.indexOf("WIN") == 0)
			{
				navigateToURL(new URLRequest("http://static.qiyi.com/ext/common/QIYImedia_0_21.exe"),"_blank");
			}
			else
			{
				navigateToURL(new URLRequest(SystemConfig.CLIENT_DOWNLOAD_URL_MAC),"_blank");
			}
		}
		
		private function getHoursBySeconds(param1:Number) : String
		{
			var _loc2:uint = Math.floor(param1 / 60 / 60);
			var _loc3:uint = param1 / 60 % 60;
			return (_loc2 > 9?_loc2:"0" + _loc2) + ":" + (_loc3 > 9?_loc3:"0" + _loc3);
		}
		
		private function onLimitDescribeLinkClick(param1:TextEvent) : void
		{
			GlobalStage.setNormalScreen();
			navigateToURL(new URLRequest(SystemConfig.VIP_HELP_DESK_URL),"_black");
		}
		
		private function onCloseBtnClick(param1:MouseEvent) : void
		{
			this.close();
		}
	}
}
