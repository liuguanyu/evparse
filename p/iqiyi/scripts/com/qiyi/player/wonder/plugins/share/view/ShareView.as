package com.qiyi.player.wonder.plugins.share.view
{
	import com.iqiyi.components.panelSystem.impls.BasePanel;
	import com.qiyi.player.wonder.common.status.Status;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.wonder.plugins.share.view.parts.VideoShare;
	import common.CommonCloseBtn;
	import common.CommonBg;
	import flash.events.MouseEvent;
	import com.qiyi.player.base.pub.EnumItem;
	import com.qiyi.player.wonder.plugins.share.ShareDef;
	import flash.display.DisplayObjectContainer;
	import com.iqiyi.components.global.GlobalStage;
	import gs.TweenLite;
	import com.qiyi.player.wonder.body.BodyDef;
	
	public class ShareView extends BasePanel
	{
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.share.view.ShareView";
		
		private var _status:Status;
		
		private var _userInfoVO:UserInfoVO;
		
		private var _videoShareView:VideoShare;
		
		private var _closeBtn:CommonCloseBtn;
		
		private var _background:CommonBg;
		
		public function ShareView(param1:DisplayObjectContainer, param2:Status, param3:UserInfoVO)
		{
			super(NAME,param1);
			type = BodyDef.VIEW_TYPE_POPUP;
			this._status = param2;
			this._userInfoVO = param3;
			this.initPanel();
		}
		
		private function initPanel() : void
		{
			this._background = new CommonBg();
			addChild(this._background);
			this._closeBtn = new CommonCloseBtn();
			this._closeBtn.x = 327;
			addChild(this._closeBtn);
			this._closeBtn.addEventListener(MouseEvent.CLICK,this.onCloseBtnClick);
		}
		
		public function updateOpenParam(param1:String, param2:String, param3:Number, param4:EnumItem, param5:String, param6:String, param7:Boolean) : void
		{
			this.destroyVideoShareView();
			this._background.width = 360;
			this._background.height = param7?130:72;
			this._videoShareView = new VideoShare(param1,param2,param3,param4,param5,param6,param7);
			this._videoShareView.addEventListener(ShareEvent.Evt_ShareBtnClick,this.onShareBtnClick);
			addChild(this._videoShareView);
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
				case ShareDef.STATUS_OPEN:
					this.open();
					break;
			}
		}
		
		public function onRemoveStatus(param1:int) : void
		{
			this._status.removeStatus(param1);
			switch(param1)
			{
				case ShareDef.STATUS_OPEN:
					this.close();
					break;
			}
		}
		
		public function onResize(param1:int, param2:int) : void
		{
			if(isOnStage)
			{
				x = (param1 - this._background.width) / 2;
				y = (param2 - this._background.height) / 2;
			}
		}
		
		override public function open(param1:DisplayObjectContainer = null) : void
		{
			if(!isOnStage)
			{
				super.open(param1);
				dispatchEvent(new ShareEvent(ShareEvent.Evt_Open));
			}
		}
		
		override public function close() : void
		{
			if(isOnStage)
			{
				super.close();
				dispatchEvent(new ShareEvent(ShareEvent.Evt_Close));
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
			this.destroyVideoShareView();
		}
		
		private function destroyVideoShareView() : void
		{
			if((this._videoShareView) && (this._videoShareView.parent))
			{
				this._videoShareView.removeEventListener(ShareEvent.Evt_ShareBtnClick,this.onShareBtnClick);
				this._videoShareView.destory();
				removeChild(this._videoShareView);
				this._videoShareView = null;
			}
		}
		
		private function onShareBtnClick(param1:ShareEvent) : void
		{
			dispatchEvent(new ShareEvent(ShareEvent.Evt_ShareBtnClick,param1.data));
		}
		
		private function onCloseBtnClick(param1:MouseEvent) : void
		{
			this.close();
		}
	}
}
