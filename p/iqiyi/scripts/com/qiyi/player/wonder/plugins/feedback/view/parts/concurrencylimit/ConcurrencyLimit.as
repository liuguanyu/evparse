package com.qiyi.player.wonder.plugins.feedback.view.parts.concurrencylimit {
	import flash.display.Sprite;
	import com.qiyi.player.wonder.IDestroy;
	import feedback.ConcurrencyLimitImg;
	import flash.text.TextField;
	import feedback.ConcurrencyLimitCutoffRule;
	import common.CommonGreenBtn;
	import com.qiyi.player.wonder.common.ui.FastCreator;
	import flash.events.MouseEvent;
	import com.qiyi.player.wonder.common.pingback.PingBack;
	import com.qiyi.player.wonder.common.pingback.PingBackDef;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import com.qiyi.player.wonder.plugins.feedback.view.FeedbackEvent;
	import flash.display.DisplayObject;
	
	public class ConcurrencyLimit extends Sprite implements IDestroy {
		
		public function ConcurrencyLimit(param1:Boolean) {
			super();
			this._isMemberVideo = param1;
			this.initPanel();
		}
		
		private static const STR_LIMIT_EXPLAIN:String = "您的VIP帐号已被多人使用观看视频，\n您已无法继续使用该帐号的会员权益。";
		
		private static const STR_SUGGESTION_HANDLE:String = "想继续观看？请关闭其它设备下的视频播放。";
		
		private static const STR_CHANGE_PASSWORD:String = "如非本人操作，建议您立即修改密码。";
		
		private static const STR_CHANGE_PW_BTN:String = "修改密码";
		
		private static const STR_SKIP_MEMBER_BTN:String = "以非会员权益观看";
		
		private var _limitImg:ConcurrencyLimitImg;
		
		private var _limitExplain:TextField;
		
		private var _warnSuggestionHandle:TextField;
		
		private var _warnChangePassword:TextField;
		
		private var _cutoffRule:ConcurrencyLimitCutoffRule;
		
		private var _changePasswordBtn:CommonGreenBtn;
		
		private var _changePasswordTF:TextField;
		
		private var _skipMemberAuthBtn:CommonGreenBtn;
		
		private var _skipMemberAuthTF:TextField;
		
		private var _isMemberVideo:Boolean = false;
		
		private function initPanel() : void {
			this._limitImg = new ConcurrencyLimitImg();
			addChild(this._limitImg);
			this._limitExplain = FastCreator.createLabel(STR_LIMIT_EXPLAIN,16777215,18);
			addChild(this._limitExplain);
			this._warnSuggestionHandle = FastCreator.createLabel(STR_SUGGESTION_HANDLE,16777215,14);
			addChild(this._warnSuggestionHandle);
			this._warnChangePassword = FastCreator.createLabel(STR_CHANGE_PASSWORD,10066329,14);
			addChild(this._warnChangePassword);
			this._cutoffRule = new ConcurrencyLimitCutoffRule();
			addChild(this._cutoffRule);
			this._changePasswordBtn = new CommonGreenBtn();
			this._changePasswordBtn.width = 110;
			this._changePasswordBtn.height = 36;
			addChild(this._changePasswordBtn);
			this._changePasswordTF = FastCreator.createLabel(STR_CHANGE_PW_BTN,16777215,16);
			this._changePasswordTF.selectable = this._changePasswordTF.mouseEnabled = false;
			addChild(this._changePasswordTF);
			this._skipMemberAuthBtn = new CommonGreenBtn();
			this._skipMemberAuthBtn.width = 160;
			this._skipMemberAuthBtn.height = 36;
			addChild(this._skipMemberAuthBtn);
			this._skipMemberAuthTF = FastCreator.createLabel(STR_SKIP_MEMBER_BTN,16777215,16);
			this._skipMemberAuthTF.selectable = this._skipMemberAuthTF.mouseEnabled = false;
			addChild(this._skipMemberAuthTF);
			if(this._isMemberVideo) {
				this._skipMemberAuthBtn.visible = this._skipMemberAuthTF.visible = false;
			}
			this._changePasswordBtn.addEventListener(MouseEvent.CLICK,this.onChangePasswordBtnClick);
			this._skipMemberAuthBtn.addEventListener(MouseEvent.CLICK,this.onSkipMemberAuthBtnClick);
		}
		
		public function onResize(param1:int, param2:int) : void {
			graphics.clear();
			graphics.beginFill(0);
			graphics.drawRect(0,0,param1,param2);
			graphics.endFill();
			this._limitImg.x = (param1 - this._limitImg.width - this._limitExplain.width) * 0.5;
			this._limitImg.y = param2 * 0.5 - 130;
			this._limitExplain.x = this._limitImg.x + this._limitImg.width + 10;
			this._limitExplain.y = this._limitImg.y + (this._limitImg.height - this._limitExplain.height) * 0.5;
			this._cutoffRule.x = (param1 - this._cutoffRule.width) * 0.5;
			this._cutoffRule.y = this._limitExplain.y + this._limitExplain.height + 25;
			this._warnSuggestionHandle.x = (param1 - this._warnSuggestionHandle.width) * 0.5;
			this._warnSuggestionHandle.y = this._cutoffRule.y + this._cutoffRule.height + 25;
			this._warnChangePassword.x = (param1 - this._warnChangePassword.width) * 0.5;
			this._warnChangePassword.y = this._warnSuggestionHandle.y + this._warnSuggestionHandle.height + 5;
			if(this._isMemberVideo) {
				this._changePasswordBtn.x = (param1 - this._changePasswordBtn.width) * 0.5;
				this._changePasswordBtn.y = this._warnChangePassword.y + this._warnChangePassword.height + 25;
				this._changePasswordTF.x = this._changePasswordBtn.x + (this._changePasswordBtn.width - this._changePasswordTF.width) * 0.5;
				this._changePasswordTF.y = this._changePasswordBtn.y + (this._changePasswordBtn.height - this._changePasswordTF.height) * 0.5;
			} else {
				this._skipMemberAuthBtn.visible = this._skipMemberAuthTF.visible = true;
				this._changePasswordBtn.x = (param1 - this._changePasswordBtn.width - this._skipMemberAuthBtn.width - 50) * 0.5;
				this._changePasswordBtn.y = this._warnChangePassword.y + this._warnChangePassword.height + 25;
				this._changePasswordTF.x = this._changePasswordBtn.x + (this._changePasswordBtn.width - this._changePasswordTF.width) * 0.5;
				this._changePasswordTF.y = this._changePasswordBtn.y + (this._changePasswordBtn.height - this._changePasswordTF.height) * 0.5;
				this._skipMemberAuthBtn.x = this._changePasswordBtn.x + this._changePasswordBtn.width + 50;
				this._skipMemberAuthBtn.y = this._changePasswordBtn.y;
				this._skipMemberAuthTF.x = this._skipMemberAuthBtn.x + (this._skipMemberAuthBtn.width - this._skipMemberAuthTF.width) * 0.5;
				this._skipMemberAuthTF.y = this._skipMemberAuthBtn.y + (this._skipMemberAuthBtn.height - this._skipMemberAuthTF.height) * 0.5;
			}
		}
		
		private function onChangePasswordBtnClick(param1:MouseEvent) : void {
			if(this._isMemberVideo) {
				PingBack.getInstance().userActionPing_4_0(PingBackDef.CONCUR_LIMIT_VIP_PW_CLICK);
			} else {
				PingBack.getInstance().userActionPing_4_0(PingBackDef.CONCUR_LIMIT_PASSWORD_CLICK);
			}
			navigateToURL(new URLRequest("http://www.iqiyi.com/u/password"),"_blank");
		}
		
		private function onSkipMemberAuthBtnClick(param1:MouseEvent) : void {
			PingBack.getInstance().userActionPing_4_0(PingBackDef.CONCUR_LIMIT_INITPLAY_CLICK);
			dispatchEvent(new FeedbackEvent(FeedbackEvent.Evt_SkipMemberAuthBtnClick));
		}
		
		public function destroy() : void {
			var _loc1_:DisplayObject = null;
			while(numChildren > 0) {
				_loc1_ = getChildAt(0);
				if(_loc1_.parent) {
					removeChild(_loc1_);
				}
				_loc1_ = null;
			}
		}
	}
}
