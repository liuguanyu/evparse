package com.qiyi.player.wonder.plugins.offlinewatch.view
{
	import com.iqiyi.components.panelSystem.impls.BasePanel;
	import com.qiyi.player.wonder.common.status.Status;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import common.CommonBg;
	import offinewatch.OffineDownloadlUI;
	import flash.text.TextField;
	import common.CommonCloseBtn;
	import flash.utils.Timer;
	import com.qiyi.player.wonder.plugins.offlinewatch.OfflineWatchDef;
	import flash.display.DisplayObjectContainer;
	import com.iqiyi.components.global.GlobalStage;
	import gs.TweenLite;
	import com.qiyi.player.wonder.body.BodyDef;
	import com.qiyi.player.wonder.common.ui.FastCreator;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	
	public class OfflineWatchView extends BasePanel
	{
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.offlinewatch.view.OfflineWatchView";
		
		private static const TEXT_DESCRIBE:String = "安装爱奇艺视频客户端，\n马上开始为您下载本片";
		
		private static const TEXT_CONFIRM:String = "秒后自动消失";
		
		private var _status:Status;
		
		private var _userInfoVO:UserInfoVO;
		
		private var _bg:CommonBg;
		
		private var _downloadUI:OffineDownloadlUI;
		
		private var _describeTF:TextField;
		
		private var _countDownTF:TextField;
		
		private var _closeBtn:CommonCloseBtn;
		
		private var _countDownTimer:Timer;
		
		private var _time:uint = 0;
		
		public function OfflineWatchView(param1:DisplayObjectContainer, param2:Status, param3:UserInfoVO)
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
				case OfflineWatchDef.STATUS_OPEN:
					this.open();
					this._time = OfflineWatchDef.OFFLINEWATCH_PANEL_SHOW_TIME;
					this._countDownTF.text = this._time + TEXT_CONFIRM;
					this.creatCountDownTimer();
					break;
			}
		}
		
		public function onRemoveStatus(param1:int) : void
		{
			this._status.removeStatus(param1);
			switch(param1)
			{
				case OfflineWatchDef.STATUS_OPEN:
					this.close();
					this._time = 0;
					this.clearCountDownTimer();
					break;
			}
		}
		
		public function onResize(param1:int, param2:int) : void
		{
			if(isOnStage)
			{
				x = (param1 - this._bg.width) / 2;
				y = (param2 - this._bg.height) / 2;
			}
		}
		
		override public function open(param1:DisplayObjectContainer = null) : void
		{
			if(!isOnStage)
			{
				super.open(param1);
				dispatchEvent(new OfflineWatchEvent(OfflineWatchEvent.Evt_Open));
			}
		}
		
		override public function close() : void
		{
			if(isOnStage)
			{
				super.close();
				dispatchEvent(new OfflineWatchEvent(OfflineWatchEvent.Evt_Close));
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
		
		private function initUI() : void
		{
			this._bg = new CommonBg();
			this._bg.width = 380;
			this._bg.height = 160;
			addChild(this._bg);
			this._downloadUI = new OffineDownloadlUI();
			addChild(this._downloadUI);
			this._describeTF = FastCreator.createLabel(TEXT_DESCRIBE,16777215,14);
			this._describeTF.x = 160;
			this._describeTF.y = 50;
			addChild(this._describeTF);
			this._countDownTF = FastCreator.createLabel(TEXT_CONFIRM,16777215,12);
			this._countDownTF.x = 220;
			this._countDownTF.y = 110;
			this._countDownTF.mouseEnabled = false;
			addChild(this._countDownTF);
			this._closeBtn = new CommonCloseBtn();
			this._closeBtn.x = this._bg.width - this._closeBtn.width - 5;
			this._closeBtn.y = 1;
			addChild(this._closeBtn);
			this._closeBtn.addEventListener(MouseEvent.CLICK,this.onCloseBtnClick);
		}
		
		private function creatCountDownTimer() : void
		{
			this.clearCountDownTimer();
			this._countDownTimer = new Timer(1000,this._time);
			this._countDownTimer.addEventListener(TimerEvent.TIMER,this.onCountDownTimer);
			this._countDownTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onCountDownTimerComplete);
			this._countDownTimer.start();
		}
		
		private function clearCountDownTimer() : void
		{
			if(this._countDownTimer)
			{
				this._countDownTimer.stop();
				this._countDownTimer.removeEventListener(TimerEvent.TIMER,this.onCountDownTimer);
				this._countDownTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onCountDownTimerComplete);
				this._countDownTimer = null;
			}
		}
		
		private function onCountDownTimer(param1:TimerEvent) : void
		{
			this._time = this._time - 1;
			this._countDownTF.text = this._time + TEXT_CONFIRM;
		}
		
		private function onCountDownTimerComplete(param1:TimerEvent) : void
		{
			this.close();
		}
		
		private function onCloseBtnClick(param1:MouseEvent) : void
		{
			this.close();
		}
	}
}
