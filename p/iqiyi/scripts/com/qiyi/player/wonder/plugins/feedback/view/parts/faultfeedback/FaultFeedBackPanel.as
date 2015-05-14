package com.qiyi.player.wonder.plugins.feedback.view.parts.faultfeedback
{
	import flash.display.Sprite;
	import com.qiyi.player.wonder.IDestroy;
	import flash.display.Shape;
	import common.CommonNormalScreenBtn;
	import feedback.FeedPanelUI;
	import feedback.FeedSuccessPanelUI;
	import flash.text.TextField;
	import com.qiyi.player.wonder.common.ui.SimpleBtn;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import com.qiyi.player.wonder.plugins.feedback.FeedbackDef;
	import com.adobe.serialization.json.JSON;
	import com.qiyi.player.wonder.plugins.feedback.model.FeedbackInfo;
	import com.iqiyi.components.global.GlobalStage;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.events.FocusEvent;
	import com.qiyi.player.wonder.common.ui.FastCreator;
	import flash.net.URLVariables;
	import flash.system.Capabilities;
	import com.qiyi.player.wonder.plugins.feedback.view.FeedbackEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequestMethod;
	import gs.TweenLite;
	import com.iqiyi.components.tooltip.ToolTip;
	
	public class FaultFeedBackPanel extends Sprite implements IDestroy
	{
		
		private static const TEXT_TITLE:String = "遇到问题了？尽管告诉我们吧！";
		
		private static const TEXT_DESCRIBE_1:String = "请详细描述您遇到的问题。";
		
		private static const TEXT_LINK:String = "也许这里有答案，<a href=\'event:onTextEventClick\'><u>去看看！</u></a>";
		
		private static const TEXT_QUESTION_INPUT:String = "为了更好得解决您的问题，请输入不少于5个字的描述。";
		
		private static const TEXT_DESCRIBE_2:String = "如果您发现我们判断的地区有误，请修改。正确的地区能使您观看更流畅！";
		
		private static const TEXT_SUCC_TITLE:String = "提交成功！感谢您对爱奇艺的支持.";
		
		private static const TEXT_SUCC_DESCRIBE:String = "我们会认真处理您的意见或建议，由于反馈众多，可能无法逐一回复，请见谅。";
		
		private var _bgShape:Shape;
		
		private var _normalScreenBtn:CommonNormalScreenBtn;
		
		private var _feedPanel:FeedPanelUI;
		
		private var _feedSuccPanel:FeedSuccessPanelUI;
		
		private var _titleTF:TextField;
		
		private var _describeTF_1:TextField;
		
		private var _helpLinkTF:TextField;
		
		private var _questionInputTF:TextField;
		
		private var _phoneTF:TextField;
		
		private var _phoneInputTF:TextField;
		
		private var _mailTF:TextField;
		
		private var _mailInputTF:TextField;
		
		private var _areaTF:TextField;
		
		private var _areaParamTF:TextField;
		
		private var _ipTF:TextField;
		
		private var _ipParamTF:TextField;
		
		private var _operatorsTF:TextField;
		
		private var _operatorsParamTF:TextField;
		
		private var _describeTF_2:TextField;
		
		private var _countryTF:TextField;
		
		private var _countryInputTF:TextField;
		
		private var _provinceTF:TextField;
		
		private var _provinceInputTF:TextField;
		
		private var _countyTF:TextField;
		
		private var _countyInputTF:TextField;
		
		private var _operatorsInputTF:TextField;
		
		private var _faultTF:TextField;
		
		private var _submitBtn:SimpleBtn;
		
		private var _returnBtn:SimpleBtn;
		
		private var _succTitleTF:TextField;
		
		private var _succDescribeTF:TextField;
		
		private var _succReturnBtn:SimpleBtn;
		
		private var _isCanFeedBack:Boolean = true;
		
		private var _loader:URLLoader;
		
		public function FaultFeedBackPanel()
		{
			super();
			this._normalScreenBtn = new CommonNormalScreenBtn();
			ToolTip.getInstance().registerComponent(this._normalScreenBtn,"退出全屏");
			this._normalScreenBtn.addEventListener(MouseEvent.CLICK,this.onNormalScreenBtnClick);
			addChild(this._normalScreenBtn);
			if(FeedbackInfo.instance.entry == "")
			{
				return;
			}
			this.initPanel();
			if(FeedbackInfo.instance.userInfo == null)
			{
				this.requestLocation();
			}
		}
		
		private function requestLocation() : void
		{
			var _loc1:URLLoader = new URLLoader();
			_loc1.addEventListener(Event.COMPLETE,this.onLoaderLocationComplete);
			_loc1.addEventListener(IOErrorEvent.IO_ERROR,this.onError);
			_loc1.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
			_loc1.load(new URLRequest(FeedbackDef.FEEDBACK_GET_LOCATION_URL));
		}
		
		private function onLoaderLocationComplete(param1:Event) : void
		{
			var data:String = null;
			var dataJSON:Object = null;
			var var_5:Event = param1;
			var urlLoader:URLLoader = var_5.target as URLLoader;
			try
			{
				data = urlLoader.data.toString() as String;
				data = data.split("=")[1];
				dataJSON = com.adobe.serialization.json.JSON.decode(data,false);
				FeedbackInfo.instance.userInfo = dataJSON;
				this._areaParamTF.text = FeedbackInfo.instance.country;
				this._ipParamTF.text = FeedbackInfo.instance.ip;
				this._operatorsParamTF.text = FeedbackInfo.instance.isp;
			}
			catch(e:Error)
			{
			}
			urlLoader.removeEventListener(Event.COMPLETE,this.onLoaderLocationComplete);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
			urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
			urlLoader = null;
		}
		
		private function onError(param1:Event) : void
		{
			var _loc2:URLLoader = param1.target as URLLoader;
			_loc2.removeEventListener(Event.COMPLETE,this.onLoaderLocationComplete);
			_loc2.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
			_loc2.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
			_loc2 = null;
		}
		
		private function initPanel() : void
		{
			if(this._bgShape == null)
			{
				this._bgShape = new Shape();
				this._bgShape.graphics.beginFill(0);
				this._bgShape.graphics.drawRect(0,0,GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
				this._bgShape.graphics.endFill();
				this.addChild(this._bgShape);
			}
			if(this._feedPanel == null)
			{
				this._feedPanel = new FeedPanelUI();
				this._feedPanel.visible = true;
				this.addChild(this._feedPanel);
				this.initFeedPanel();
			}
			if(this._feedSuccPanel == null)
			{
				this._feedSuccPanel = new FeedSuccessPanelUI();
				this._feedSuccPanel.visible = false;
				this.addChild(this._feedSuccPanel);
				this.initFeedSuccPanel();
			}
			this._submitBtn.addEventListener(MouseEvent.CLICK,this.onSubmitClick);
			this._returnBtn.addEventListener(MouseEvent.CLICK,this.onBackBtnClick);
			this._succReturnBtn.addEventListener(MouseEvent.CLICK,this.onBackBtnClick);
			this._helpLinkTF.addEventListener(TextEvent.LINK,this.onHelpLinkClick);
			this._countryInputTF.addEventListener(FocusEvent.FOCUS_IN,this.onInputTextFocusIn);
			this._countyInputTF.addEventListener(FocusEvent.FOCUS_IN,this.onInputTextFocusIn);
			this._provinceInputTF.addEventListener(FocusEvent.FOCUS_IN,this.onInputTextFocusIn);
			this._operatorsInputTF.addEventListener(FocusEvent.FOCUS_IN,this.onInputTextFocusIn);
			this._questionInputTF.addEventListener(FocusEvent.FOCUS_IN,this.onInputTextFocusIn);
			this._mailInputTF.addEventListener(FocusEvent.FOCUS_IN,this.onInputTextFocusIn);
			this._phoneInputTF.addEventListener(FocusEvent.FOCUS_IN,this.onInputTextFocusIn);
		}
		
		private function initFeedPanel() : void
		{
			this._titleTF = FastCreator.createLabel(TEXT_TITLE,16777215,18);
			this._titleTF.x = (this._feedPanel.width - this._titleTF.width) / 2;
			this._feedPanel.addChild(this._titleTF);
			this._describeTF_1 = FastCreator.createLabel(TEXT_DESCRIBE_1,16777215,14);
			this._describeTF_1.x = 0;
			this._describeTF_1.y = 40;
			this._feedPanel.addChild(this._describeTF_1);
			this._helpLinkTF = FastCreator.createLabel(TEXT_LINK,16777215);
			this._helpLinkTF.y = 40;
			this._helpLinkTF.x = 410;
			this._feedPanel.addChild(this._helpLinkTF);
			this._questionInputTF = FastCreator.createInput(TEXT_QUESTION_INPUT,4276545);
			this._questionInputTF.y = 66;
			this._questionInputTF.x = 3;
			this._questionInputTF.width = this._feedPanel.width - 6;
			this._questionInputTF.height = 160;
			this._questionInputTF.multiline = true;
			this._questionInputTF.maxChars = FeedbackDef.FEEDBACK_RESUBMIT_INPUT_MAXCHAR;
			this._feedPanel.addChild(this._questionInputTF);
			this._phoneTF = FastCreator.createLabel("手机：",16777215,14);
			this._phoneTF.y = 240;
			this._phoneTF.x = 0;
			this._feedPanel.addChild(this._phoneTF);
			this._phoneInputTF = FastCreator.createInput("",3355443,14);
			this._phoneInputTF.x = 50;
			this._phoneInputTF.y = 240;
			this._phoneInputTF.width = 180;
			this._phoneInputTF.height = 22;
			this._phoneInputTF.maxChars = 11;
			this._phoneInputTF.multiline = false;
			this._feedPanel.addChild(this._phoneInputTF);
			this._mailTF = FastCreator.createLabel("邮箱：",16777215,14);
			this._mailTF.x = 266;
			this._mailTF.y = 240;
			this._feedPanel.addChild(this._mailTF);
			this._mailInputTF = FastCreator.createInput("",3355443,14);
			this._mailInputTF.x = 317;
			this._mailInputTF.y = 240;
			this._mailInputTF.width = 180;
			this._mailInputTF.height = 22;
			this._mailInputTF.multiline = false;
			this._feedPanel.addChild(this._mailInputTF);
			this._areaTF = FastCreator.createLabel("地区：",13290186);
			this._areaTF.x = 0;
			this._areaTF.y = 268;
			this._feedPanel.addChild(this._areaTF);
			this._areaParamTF = FastCreator.createLabel("",13290186);
			this._areaParamTF.x = 34;
			this._areaParamTF.y = 268;
			this._areaParamTF.width = 70;
			this._areaParamTF.multiline = false;
			this._areaParamTF.text = FeedbackInfo.instance.country;
			this._feedPanel.addChild(this._areaParamTF);
			this._ipTF = FastCreator.createLabel("IP：",13290186);
			this._ipTF.x = 112;
			this._ipTF.y = 268;
			this._feedPanel.addChild(this._ipTF);
			this._ipParamTF = FastCreator.createLabel("",13290186);
			this._ipParamTF.x = 142;
			this._ipParamTF.y = 268;
			this._ipParamTF.width = 70;
			this._ipParamTF.multiline = false;
			this._ipParamTF.text = FeedbackInfo.instance.ip;
			this._feedPanel.addChild(this._ipParamTF);
			this._operatorsTF = FastCreator.createLabel("运营商：",13290186);
			this._operatorsTF.x = 244;
			this._operatorsTF.y = 268;
			this._feedPanel.addChild(this._operatorsTF);
			this._operatorsParamTF = FastCreator.createLabel("",13290186);
			this._operatorsParamTF.x = 288;
			this._operatorsParamTF.y = 268;
			this._operatorsParamTF.width = 130;
			this._operatorsParamTF.multiline = false;
			this._operatorsParamTF.text = FeedbackInfo.instance.isp;
			this._feedPanel.addChild(this._operatorsParamTF);
			this._describeTF_2 = FastCreator.createLabel(TEXT_DESCRIBE_2,13290186);
			this._describeTF_2.y = 288;
			this._describeTF_2.x = 0;
			this._feedPanel.addChild(this._describeTF_2);
			this._countryTF = FastCreator.createLabel("国家/地区",13290186);
			this._countryTF.x = 60;
			this._countryTF.y = 313;
			this._feedPanel.addChild(this._countryTF);
			this._countryInputTF = FastCreator.createInput("中国大陆",3355443);
			this._countryInputTF.x = 2;
			this._countryInputTF.y = 315;
			this._countryInputTF.width = 54;
			this._countryInputTF.multiline = false;
			this._feedPanel.addChild(this._countryInputTF);
			this._provinceTF = FastCreator.createLabel("省",13290186);
			this._provinceTF.x = 178;
			this._provinceTF.y = 313;
			this._feedPanel.addChild(this._provinceTF);
			this._provinceInputTF = FastCreator.createInput("填写省份",3355443);
			this._provinceInputTF.x = 120;
			this._provinceInputTF.y = 315;
			this._provinceInputTF.width = 54;
			this._provinceInputTF.multiline = false;
			this._feedPanel.addChild(this._provinceInputTF);
			this._countyTF = FastCreator.createLabel("县/市/区",13290186);
			this._countyTF.x = 258;
			this._countyTF.y = 313;
			this._feedPanel.addChild(this._countyTF);
			this._countyInputTF = FastCreator.createInput("填写县市",3355443);
			this._countyInputTF.x = 200;
			this._countyInputTF.y = 315;
			this._countyInputTF.width = 54;
			this._countyInputTF.multiline = false;
			this._feedPanel.addChild(this._countyInputTF);
			this._operatorsInputTF = FastCreator.createInput("填写运营商",3355443);
			this._operatorsInputTF.x = 315;
			this._operatorsInputTF.y = 315;
			this._operatorsInputTF.width = 64;
			this._operatorsInputTF.multiline = false;
			this._feedPanel.addChild(this._operatorsInputTF);
			this._faultTF = FastCreator.createLabel("提交失败！",10027008,14);
			this._faultTF.x = 230;
			this._faultTF.y = 358;
			this._faultTF.visible = false;
			this._feedPanel.addChild(this._faultTF);
			this._submitBtn = new SimpleBtn("提交");
			this._submitBtn.x = this._feedPanel.width / 4 - this._submitBtn.width / 2;
			this._submitBtn.y = 358;
			this._feedPanel.addChild(this._submitBtn);
			this._returnBtn = new SimpleBtn("返回");
			this._returnBtn.x = this._feedPanel.width / 4 * 3 - this._returnBtn.width / 2;
			this._returnBtn.y = 358;
			this._feedPanel.addChild(this._returnBtn);
		}
		
		private function initFeedSuccPanel() : void
		{
			this._succTitleTF = FastCreator.createLabel(TEXT_SUCC_TITLE,16777215,18);
			this._succTitleTF.x = (this._feedPanel.width - this._succTitleTF.width) / 2;
			this._succTitleTF.y = 103;
			this._feedSuccPanel.addChild(this._succTitleTF);
			this._succDescribeTF = FastCreator.createLabel(TEXT_SUCC_DESCRIBE,16777215,14);
			this._succDescribeTF.x = (this._feedPanel.width - this._succDescribeTF.width) / 2;
			this._succDescribeTF.y = 168;
			this._feedSuccPanel.addChild(this._succDescribeTF);
			this._succReturnBtn = new SimpleBtn("返回");
			this._succReturnBtn.x = this._feedPanel.width / 2 - this._returnBtn.width / 2;
			this._succReturnBtn.y = 244;
			this._feedSuccPanel.addChild(this._succReturnBtn);
		}
		
		private function onSubmitClick(param1:MouseEvent) : void
		{
			this._submitBtn.removeEventListener(MouseEvent.CLICK,this.onSubmitClick);
			var _loc2:* = 0;
			var _loc3:* = 0;
			while(_loc3 < this._questionInputTF.text.length)
			{
				if(this._questionInputTF.text.charAt(_loc3) == " ")
				{
					_loc2++;
				}
				_loc3++;
			}
			if(this._isCanFeedBack)
			{
				this._isCanFeedBack = false;
				this.requestTicket();
			}
		}
		
		private function getVariables() : URLVariables
		{
			var _loc1:URLVariables = new URLVariables();
			_loc1.ticket = FeedbackInfo.instance.ticket;
			_loc1.email = this._mailInputTF.text;
			if(this._questionInputTF.text == TEXT_QUESTION_INPUT)
			{
				_loc1.content = "";
			}
			else
			{
				_loc1.content = this._questionInputTF.text;
			}
			_loc1.entry_class = FeedbackDef.FEEDBACK_RESUBMIT_ENTRY_CLASS;
			_loc1.phone = this._phoneInputTF.text;
			_loc1.fb_class = FeedbackDef.FEEDBACK_RESUBMIT_FB_CLASS;
			_loc1.uplevel_url = "";
			_loc1.v_id = FeedbackInfo.instance.vid;
			_loc1.v_title = FeedbackInfo.instance.title;
			_loc1.flash_sound = FeedbackInfo.instance.volume;
			_loc1.flash_version = Capabilities.version;
			_loc1.record = "";
			_loc1.speed_test = "0@0@0@0@0@ @ @ @" + FeedbackInfo.instance.logCookie;
			_loc1.login_email = "";
			_loc1.city = FeedbackInfo.instance.city;
			_loc1.country = FeedbackInfo.instance.country;
			_loc1.isp = FeedbackInfo.instance.isp;
			_loc1.province = "";
			_loc1.player_version = FeedbackInfo.instance.playerVersion;
			_loc1.category_id = FeedbackInfo.instance.channelId;
			if(this._countyInputTF.text != "填写县市")
			{
				_loc1.input_city = this._countyInputTF.text;
			}
			if(this._operatorsInputTF.text != "填写运营商")
			{
				_loc1.input_isp = this._operatorsInputTF.text;
			}
			if(this._provinceInputTF.text != "填写省份")
			{
				_loc1.input_province = this._provinceInputTF.text;
			}
			return _loc1;
		}
		
		private function onNormalScreenBtnClick(param1:MouseEvent) : void
		{
			this._normalScreenBtn.visible = false;
			GlobalStage.setNormalScreen();
		}
		
		private function onBackBtnClick(param1:MouseEvent) : void
		{
			dispatchEvent(new FeedbackEvent(FeedbackEvent.Evt_FaultFeedbackReturn));
		}
		
		private function onHelpLinkClick(param1:TextEvent) : void
		{
			GlobalStage.setNormalScreen();
			navigateToURL(new URLRequest(FeedbackDef.FEEDBACK_HELP_URL),"_blank");
		}
		
		private function onInputTextFocusIn(param1:FocusEvent) : void
		{
			switch(param1.target)
			{
				case this._countryInputTF:
					if(this._countryInputTF.text == "中国大陆")
					{
						param1.target.text = "";
					}
					break;
				case this._provinceInputTF:
					if(this._provinceInputTF.text == "填写省份")
					{
						param1.target.text = "";
					}
					break;
				case this._countyInputTF:
					if(this._countyInputTF.text == "填写县市")
					{
						param1.target.text = "";
					}
					break;
				case this._operatorsInputTF:
					if(this._operatorsInputTF.text == "填写运营商")
					{
						param1.target.text = "";
					}
					break;
				case this._questionInputTF:
					if(this._questionInputTF.text == TEXT_QUESTION_INPUT)
					{
						param1.target.text = "";
					}
					break;
			}
			param1.target.addEventListener(FocusEvent.FOCUS_OUT,this.onInputTextFocusOut);
		}
		
		private function onInputTextFocusOut(param1:FocusEvent) : void
		{
			param1.target.removeEventListener(FocusEvent.FOCUS_OUT,this.onInputTextFocusOut);
			if(param1.target.text != "")
			{
				return;
			}
			switch(param1.target)
			{
				case this._countryInputTF:
					this._countryInputTF.text = "中国大陆";
					break;
				case this._provinceInputTF:
					this._provinceInputTF.text = "填写省份";
					break;
				case this._countyInputTF:
					this._countyInputTF.text = "填写县市";
					break;
				case this._operatorsInputTF:
					this._operatorsInputTF.text = "填写运营商";
					break;
				case this._questionInputTF:
					this._questionInputTF.text = TEXT_QUESTION_INPUT;
					break;
			}
		}
		
		public function onResize(param1:uint, param2:uint) : void
		{
			if(this._bgShape)
			{
				this._bgShape.width = param1;
				this._bgShape.height = param2;
			}
			if(this._feedPanel)
			{
				this._feedPanel.x = (param1 - this._feedPanel.width) / 2;
				this._feedPanel.y = (param2 - this._feedPanel.height) / 2;
			}
			if(this._feedSuccPanel)
			{
				this._feedSuccPanel.x = (param1 - this._feedSuccPanel.width) / 2;
				this._feedSuccPanel.y = (param2 - this._feedSuccPanel.height) / 2;
			}
			if(GlobalStage.isFullScreen())
			{
				this._normalScreenBtn.visible = true;
				this._normalScreenBtn.x = param1 - this._normalScreenBtn.width - 2;
				this._normalScreenBtn.y = 8;
			}
			else
			{
				this._normalScreenBtn.visible = false;
			}
		}
		
		private function requestTicket() : void
		{
			var _loc1:URLLoader = new URLLoader();
			_loc1.addEventListener(Event.COMPLETE,this.onLoaderTicketComplete);
			_loc1.addEventListener(IOErrorEvent.IO_ERROR,this.onUploadError);
			_loc1.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onUploadError);
			_loc1.load(new URLRequest(FeedbackDef.FEEDBACK_GET_TICKET_URL + "?n=" + Math.random()));
		}
		
		private function onLoaderTicketComplete(param1:Event) : void
		{
			var data:String = null;
			var var_5:Event = param1;
			var urlLoader:URLLoader = var_5.target as URLLoader;
			try
			{
				data = urlLoader.data.toString() as String;
				FeedbackInfo.instance.ticket = data;
				this.requestUploadError();
			}
			catch(e:Error)
			{
			}
			urlLoader.removeEventListener(Event.COMPLETE,this.onLoaderTicketComplete);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onUploadError);
			urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onUploadError);
			urlLoader = null;
		}
		
		private function requestUploadError() : void
		{
			var request:URLRequest = new URLRequest(FeedbackDef.FEEDBACK_FEED_BACK_URL);
			try
			{
				request.method = URLRequestMethod.POST;
				request.data = this.getVariables();
			}
			catch(e:Error)
			{
			}
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE,this.onUploadErrorComplete);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onUploadError);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onUploadError);
			urlLoader.load(request);
		}
		
		private function onUploadErrorComplete(param1:Event) : void
		{
			this._isCanFeedBack = false;
			this._feedPanel.visible = false;
			this._feedSuccPanel.visible = true;
			dispatchEvent(new FeedbackEvent(FeedbackEvent.Evt_FaultFeedBackSuccess));
			var _loc2:URLLoader = param1.target as URLLoader;
			_loc2.removeEventListener(Event.COMPLETE,this.onUploadErrorComplete);
			_loc2.removeEventListener(IOErrorEvent.IO_ERROR,this.onUploadError);
			_loc2.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onUploadError);
			_loc2 = null;
		}
		
		private function onUploadError(param1:Event) : void
		{
			this._isCanFeedBack = true;
			if(this._faultTF)
			{
				this._faultTF.visible = true;
				TweenLite.killTweensOf(this.removeFailText);
				TweenLite.delayedCall(5,this.removeFailText);
			}
			var _loc2:URLLoader = param1.target as URLLoader;
			_loc2.removeEventListener(Event.COMPLETE,this.onLoaderTicketComplete);
			_loc2.removeEventListener(Event.COMPLETE,this.onUploadErrorComplete);
			_loc2.removeEventListener(IOErrorEvent.IO_ERROR,this.onUploadError);
			_loc2.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onUploadError);
		}
		
		private function removeFailText() : void
		{
			if(this._feedPanel == null)
			{
				return;
			}
			if(this._faultTF)
			{
				this._faultTF.visible = false;
			}
			if(this._submitBtn)
			{
				this._submitBtn.addEventListener(MouseEvent.CLICK,this.onSubmitClick);
			}
		}
		
		public function destroy() : void
		{
			this._submitBtn.removeEventListener(MouseEvent.CLICK,this.onSubmitClick);
			this._returnBtn.removeEventListener(MouseEvent.CLICK,this.onBackBtnClick);
			this._succReturnBtn.removeEventListener(MouseEvent.CLICK,this.onBackBtnClick);
			this._helpLinkTF.removeEventListener(TextEvent.LINK,this.onHelpLinkClick);
			this._normalScreenBtn.removeEventListener(MouseEvent.CLICK,this.onNormalScreenBtnClick);
			this._countryInputTF.removeEventListener(FocusEvent.FOCUS_IN,this.onInputTextFocusIn);
			this._countyInputTF.removeEventListener(FocusEvent.FOCUS_IN,this.onInputTextFocusIn);
			this._provinceInputTF.removeEventListener(FocusEvent.FOCUS_IN,this.onInputTextFocusIn);
			this._operatorsInputTF.removeEventListener(FocusEvent.FOCUS_IN,this.onInputTextFocusIn);
			this._questionInputTF.removeEventListener(FocusEvent.FOCUS_IN,this.onInputTextFocusIn);
			this._mailInputTF.removeEventListener(FocusEvent.FOCUS_IN,this.onInputTextFocusIn);
			this._phoneInputTF.removeEventListener(FocusEvent.FOCUS_IN,this.onInputTextFocusIn);
			removeChild(this._normalScreenBtn);
			this._normalScreenBtn = null;
			if((this._bgShape) && (this._bgShape.parent))
			{
				this._bgShape.graphics.clear();
				removeChild(this._bgShape);
				this._bgShape = null;
			}
			if((this._feedPanel) && (this._feedPanel.parent))
			{
				removeChild(this._feedPanel);
				FastCreator.removeAllChild(this._feedPanel);
				this._feedPanel = null;
			}
			if((this._feedSuccPanel) && (this._feedSuccPanel.parent))
			{
				removeChild(this._feedSuccPanel);
				FastCreator.removeAllChild(this._feedSuccPanel);
				this._feedSuccPanel = null;
			}
		}
	}
}
