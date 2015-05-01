package com.qiyi.player.wonder.plugins.feedback.view {
	import com.iqiyi.components.panelSystem.impls.BasePanel;
	import com.qiyi.player.wonder.common.status.Status;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.wonder.plugins.feedback.view.parts.networkfault.NetWorkFaultView;
	import com.qiyi.player.wonder.plugins.feedback.view.parts.faultfeedback.FaultFeedBackPanel;
	import com.qiyi.player.wonder.plugins.feedback.view.parts.copyrightexpired.CopyrightExpired;
	import com.qiyi.player.wonder.plugins.feedback.view.parts.copyrightlimited.CopyrightLimited;
	import com.qiyi.player.wonder.plugins.feedback.view.parts.privatevideo.PrivateVideo;
	import com.qiyi.player.wonder.plugins.feedback.view.parts.concurrencylimit.ConcurrencyLimit;
	import com.qiyi.player.wonder.plugins.feedback.view.parts.maliceerror.MaliceError;
	import common.CommonNormalScreenBtn;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import com.qiyi.player.wonder.plugins.feedback.FeedbackDef;
	import flash.geom.Rectangle;
	import com.iqiyi.components.global.GlobalStage;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import com.iqiyi.components.tooltip.ToolTip;
	import flash.utils.getTimer;
	import flash.events.Event;
	import gs.TweenLite;
	import com.qiyi.player.wonder.body.BodyDef;
	
	public class FeedbackView extends BasePanel {
		
		public function FeedbackView(param1:DisplayObjectContainer, param2:Status, param3:UserInfoVO) {
			super(NAME,param1);
			type = BodyDef.VIEW_TYPE_END_POPUP;
			this._status = param2;
			this._userInfoVO = param3;
			hasCover = true;
			this._normalScreenBtn = new CommonNormalScreenBtn();
			this._normalScreenBtn.addEventListener(MouseEvent.CLICK,this.onNormalScreenBtnClick);
			ToolTip.getInstance().registerComponent(this._normalScreenBtn,"退出全屏");
			this.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
		}
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.feedback.view.FeedbackView";
		
		private var _status:Status;
		
		private var _userInfoVO:UserInfoVO;
		
		private var _netWorkFaultView:NetWorkFaultView;
		
		private var _faultFeedBackPanel:FaultFeedBackPanel;
		
		private var _copyrightExpired:CopyrightExpired;
		
		private var _copyrightLimited:CopyrightLimited;
		
		private var _privateVideo:PrivateVideo;
		
		private var _concurrencyLimit:ConcurrencyLimit;
		
		private var _maliceError:MaliceError;
		
		private var _normalScreenBtn:CommonNormalScreenBtn;
		
		private var _videoName:String = "";
		
		private var _submitTime:uint;
		
		public function createMaliceErrorView() : void {
			this._maliceError = new MaliceError();
			addChild(this._maliceError);
		}
		
		public function createNetWorkFaultView() : void {
			this._netWorkFaultView = new NetWorkFaultView();
			addChild(this._netWorkFaultView);
			this._netWorkFaultView.refreshBtn.addEventListener(MouseEvent.CLICK,this.onRefreshClick);
			this._netWorkFaultView.helpBtn.addEventListener(MouseEvent.CLICK,this.onHelpMouseClick);
			this._netWorkFaultView.downLoadBtn.addEventListener(MouseEvent.CLICK,this.onDownloadBtnClick);
		}
		
		public function createCopyrightExpiredView(param1:String, param2:Boolean = true, param3:String = "") : void {
			this._copyrightExpired = new CopyrightExpired(param1,param2,param3);
			this._copyrightExpired.linkTextField.addEventListener(TextEvent.LINK,this.onOpenFaultFeedbackPanel);
			this._copyrightExpired.downLoadBtn.addEventListener(MouseEvent.CLICK,this.onDownloadBtnClick);
			addChild(this._copyrightExpired);
		}
		
		public function createCopyrightLimitedView(param1:uint) : void {
			this._copyrightLimited = new CopyrightLimited(param1);
			addChild(this._copyrightLimited);
			this._copyrightLimited.linkTextField.addEventListener(TextEvent.LINK,this.onOpenFaultFeedbackPanel);
			this._copyrightLimited.downLoadBtn.addEventListener(MouseEvent.CLICK,this.onDownloadBtnClick);
		}
		
		public function createPrivatevideo(param1:uint, param2:Boolean, param3:Boolean) : void {
			if((this._privateVideo) && (this._privateVideo.parent)) {
				removeChild(this._privateVideo);
				this._privateVideo.destroy();
				this._privateVideo = null;
			}
			this._privateVideo = new PrivateVideo(param1,param2,param3);
			addChild(this._privateVideo);
			this._privateVideo.addEventListener(FeedbackEvent.Evt_PrivateNestVideo,this.onNestVideoLink);
			this._privateVideo.addEventListener(FeedbackEvent.Evt_PrivateConfirmBtnClick,this.onConfirmBtnClick);
		}
		
		public function createConcurrencyLimit(param1:Boolean) : void {
			if((this._concurrencyLimit) && (this._concurrencyLimit.parent)) {
				removeChild(this._concurrencyLimit);
				this._concurrencyLimit.destroy();
				this._concurrencyLimit = null;
			}
			this._concurrencyLimit = new ConcurrencyLimit(param1);
			addChild(this._concurrencyLimit);
			this._concurrencyLimit.addEventListener(FeedbackEvent.Evt_SkipMemberAuthBtnClick,this.onSkipMemberAuthBtnClick);
		}
		
		public function get videoName() : String {
			return this._videoName;
		}
		
		public function set videoName(param1:String) : void {
			this._videoName = param1;
			if((this._copyrightExpired) && (this._copyrightExpired.parent)) {
				this._copyrightExpired.videoName = this._videoName;
			}
		}
		
		public function onUserInfoChanged(param1:UserInfoVO) : void {
			this._userInfoVO = param1;
		}
		
		public function onAddStatus(param1:int) : void {
			this._status.addStatus(param1);
			switch(param1) {
				case FeedbackDef.STATUS_OPEN:
					this.open();
					break;
			}
		}
		
		public function onRemoveStatus(param1:int) : void {
			this._status.removeStatus(param1);
			switch(param1) {
				case FeedbackDef.STATUS_OPEN:
					this.close();
					break;
			}
		}
		
		public function onResize(param1:int, param2:int) : void {
			if(isOnStage) {
				setCoverArea(new Rectangle(0,0,param1,param2));
				if((this._faultFeedBackPanel) && (this._faultFeedBackPanel.parent)) {
					this._faultFeedBackPanel.onResize(param1,param2);
				}
				if((this._netWorkFaultView) && (this._netWorkFaultView.parent)) {
					this._netWorkFaultView.onResize(param1,param2);
				}
				if((this._copyrightExpired) && (this._copyrightExpired.parent)) {
					this._copyrightExpired.onResize(param1,param2);
				}
				if((this._copyrightLimited) && (this._copyrightLimited.parent)) {
					this._copyrightLimited.onResize(param1,param2);
				}
				if((this._maliceError) && (this._maliceError.parent)) {
					this._maliceError.onResize(param1,param2);
				}
				if((this._privateVideo) && (this._privateVideo.parent)) {
					this._privateVideo.onResize(param1,param2);
				}
				if((this._concurrencyLimit) && (this._concurrencyLimit.parent)) {
					this._concurrencyLimit.onResize(param1,param2);
				}
				if((GlobalStage.isFullScreen()) && this._faultFeedBackPanel == null) {
					this._normalScreenBtn.x = GlobalStage.stage.stageWidth - this._normalScreenBtn.width;
					this._normalScreenBtn.y = 8;
					addChild(this._normalScreenBtn);
				} else if(this._faultFeedBackPanel == null && (this._normalScreenBtn.parent)) {
					removeChild(this._normalScreenBtn);
				}
				
			}
		}
		
		override public function open(param1:DisplayObjectContainer = null) : void {
			if(!isOnStage) {
				super.open(param1);
				dispatchEvent(new FeedbackEvent(FeedbackEvent.Evt_Open));
			}
		}
		
		override public function close() : void {
			if(isOnStage) {
				super.close();
				dispatchEvent(new FeedbackEvent(FeedbackEvent.Evt_Close));
			}
		}
		
		override protected function createCover() : Sprite {
			var _loc1_:Sprite = new Sprite();
			_loc1_.graphics.beginFill(0,1);
			_loc1_.graphics.drawRect(0,0,1,1);
			_loc1_.graphics.endFill();
			return _loc1_;
		}
		
		override protected function onAddToStage() : void {
			super.onAddToStage();
			this.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
			setCoverArea(new Rectangle(0,0,GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight));
		}
		
		override protected function onRemoveFromStage() : void {
			super.onRemoveFromStage();
			if((this._netWorkFaultView) && (this._netWorkFaultView.parent)) {
				this._netWorkFaultView.destroy();
				removeChild(this._netWorkFaultView);
				this._netWorkFaultView = null;
			}
			if((this._copyrightExpired) && (this._copyrightExpired.parent)) {
				this._copyrightExpired.linkTextField.removeEventListener(TextEvent.LINK,this.onOpenFaultFeedbackPanel);
				this._copyrightExpired.downLoadBtn.removeEventListener(MouseEvent.CLICK,this.onDownloadBtnClick);
				removeChild(this._copyrightExpired);
				this._copyrightExpired.destroy();
				this._copyrightExpired = null;
			}
			if((this._copyrightLimited) && (this._copyrightLimited.parent)) {
				this._copyrightLimited.linkTextField.removeEventListener(TextEvent.LINK,this.onOpenFaultFeedbackPanel);
				this._copyrightLimited.downLoadBtn.removeEventListener(MouseEvent.CLICK,this.onDownloadBtnClick);
				removeChild(this._copyrightLimited);
				this._copyrightLimited.destroy();
				this._copyrightLimited = null;
			}
			if((this._maliceError) && (this._maliceError.parent)) {
				removeChild(this._maliceError);
				this._maliceError.destroy();
				this._maliceError = null;
			}
			if((this._privateVideo) && (this._privateVideo.parent)) {
				removeChild(this._privateVideo);
				this._privateVideo.destroy();
				this._privateVideo = null;
			}
			if((this._concurrencyLimit) && (this._concurrencyLimit.parent)) {
				removeChild(this._concurrencyLimit);
				this._concurrencyLimit.destroy();
				this._concurrencyLimit = null;
			}
			ToolTip.getInstance().unregisterComponent(this._normalScreenBtn);
		}
		
		private function onNormalScreenBtnClick(param1:MouseEvent) : void {
			GlobalStage.setNormalScreen();
		}
		
		private function onRefreshClick(param1:MouseEvent) : void {
			if(this._netWorkFaultView) {
				this._netWorkFaultView.refreshBtn.removeEventListener(MouseEvent.CLICK,this.onRefreshClick);
				this._netWorkFaultView.helpBtn.removeEventListener(MouseEvent.CLICK,this.onHelpMouseClick);
				this._netWorkFaultView.downLoadBtn.removeEventListener(MouseEvent.CLICK,this.onDownloadBtnClick);
			}
			this.close();
			dispatchEvent(new FeedbackEvent(FeedbackEvent.Evt_Refresh));
		}
		
		private function onHelpMouseClick(param1:MouseEvent) : void {
			if(this._netWorkFaultView.isFeedBacked) {
				this._netWorkFaultView.isFeedBacked = uint(getTimer() / 1000) - this._submitTime <= FeedbackDef.FEEDBACK_RESUBMIT_TIME_GAP / 1000;
			} else if(this._submitTime) {
				this._netWorkFaultView.isFeedBacked = uint(getTimer() / 1000) - this._submitTime <= FeedbackDef.FEEDBACK_RESUBMIT_TIME_GAP / 1000;
			}
			
			if(!this._netWorkFaultView.isFeedBacked) {
				this.onOpenFaultFeedbackPanel(param1);
			} else {
				this._netWorkFaultView.rejectMsg.visible = true;
			}
		}
		
		private function onDownloadBtnClick(param1:MouseEvent) : void {
			dispatchEvent(new FeedbackEvent(FeedbackEvent.Evt_DownloadBtnClick));
		}
		
		private function onOpenFaultFeedbackPanel(param1:Event) : void {
			if(GlobalStage.isFullScreen()) {
				GlobalStage.setNormalScreen();
			}
			this._faultFeedBackPanel = new FaultFeedBackPanel();
			this._faultFeedBackPanel.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
			this._faultFeedBackPanel.addEventListener(FeedbackEvent.Evt_FaultFeedbackReturn,this.onFeedbackReturn);
			this._faultFeedBackPanel.addEventListener(FeedbackEvent.Evt_FaultFeedBackSuccess,this.onFeedbackOK);
			addChild(this._faultFeedBackPanel);
		}
		
		private function onFeedbackOK(param1:FeedbackEvent) : void {
			if(this._netWorkFaultView) {
				this._netWorkFaultView.isFeedBacked = true;
				this._submitTime = uint(getTimer() / 1000);
				TweenLite.delayedCall(FeedbackDef.FEEDBACK_RESUBMIT_TIME_GAP / 1000,this.hideRejectMsg);
			}
		}
		
		private function onFeedbackReturn(param1:FeedbackEvent) : void {
			if(!this._faultFeedBackPanel) {
				return;
			}
			removeChild(this._faultFeedBackPanel);
			this._faultFeedBackPanel.removeEventListener(FeedbackEvent.Evt_FaultFeedbackReturn,this.onFeedbackReturn);
			this._faultFeedBackPanel.removeEventListener(FeedbackEvent.Evt_FaultFeedBackSuccess,this.onFeedbackOK);
			this._faultFeedBackPanel.destroy();
			this._faultFeedBackPanel = null;
		}
		
		private function onNestVideoLink(param1:FeedbackEvent) : void {
			dispatchEvent(new FeedbackEvent(FeedbackEvent.Evt_PrivateNestVideo));
		}
		
		private function onConfirmBtnClick(param1:FeedbackEvent) : void {
			dispatchEvent(new FeedbackEvent(FeedbackEvent.Evt_PrivateConfirmBtnClick,param1.data));
		}
		
		private function onSkipMemberAuthBtnClick(param1:FeedbackEvent) : void {
			dispatchEvent(new FeedbackEvent(FeedbackEvent.Evt_SkipMemberAuthBtnClick));
		}
		
		private function hideRejectMsg() : void {
			if(this._netWorkFaultView) {
				this._netWorkFaultView.rejectMsg.visible = false;
			}
		}
	}
}
