package com.qiyi.player.wonder.plugins.videolink.view
{
	import com.iqiyi.components.panelSystem.impls.BasePanel;
	import com.qiyi.player.wonder.common.status.Status;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.wonder.plugins.videolink.view.part.VideoLinkPanel;
	import com.qiyi.player.wonder.plugins.videolink.view.part.ClientDownloadPanel;
	import com.qiyi.player.wonder.plugins.videolink.view.part.ActivityNoticePanel;
	import com.qiyi.player.wonder.plugins.videolink.VideoLinkDef;
	import flash.display.DisplayObjectContainer;
	import com.iqiyi.components.global.GlobalStage;
	import com.qiyi.player.wonder.plugins.videolink.model.VideoLinkInfo;
	import gs.TweenLite;
	
	public class VideoLinkView extends BasePanel
	{
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.videolink.view.VideoLinkView";
		
		private static const CONST_DISTANCE:uint = 70;
		
		private var _status:Status;
		
		private var _userInfoVO:UserInfoVO;
		
		private var _videoLinkPanel:VideoLinkPanel;
		
		private var _clientDownloadPanel:ClientDownloadPanel;
		
		private var _activityNoticePanel:ActivityNoticePanel;
		
		private var _panelType:uint = 0;
		
		private var _activityNoticeLink:String = "";
		
		public function VideoLinkView(param1:DisplayObjectContainer, param2:Status, param3:UserInfoVO)
		{
			super(NAME,param1);
			this._status = param2;
			this._userInfoVO = param3;
		}
		
		public function get activityNoticeLink() : String
		{
			return this._activityNoticeLink;
		}
		
		public function get panelType() : uint
		{
			return this._panelType;
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
				case VideoLinkDef.STATUS_OPEN:
					this.open();
					break;
			}
		}
		
		public function onRemoveStatus(param1:int) : void
		{
			this._status.removeStatus(param1);
			switch(param1)
			{
				case VideoLinkDef.STATUS_OPEN:
					this.close();
					break;
			}
		}
		
		override public function open(param1:DisplayObjectContainer = null) : void
		{
			if(!isOnStage)
			{
				super.open(param1);
				dispatchEvent(new VideoLinkEvent(VideoLinkEvent.Evt_Open));
			}
		}
		
		override public function close() : void
		{
			if(isOnStage)
			{
				super.close();
				dispatchEvent(new VideoLinkEvent(VideoLinkEvent.Evt_Close));
			}
		}
		
		public function onResize(param1:int, param2:int) : void
		{
			if((this._videoLinkPanel) && (this._videoLinkPanel.parent))
			{
				this._videoLinkPanel.onResize(param1,param2);
				this._videoLinkPanel.x = 2;
				this._videoLinkPanel.y = GlobalStage.stage.stageHeight - this._videoLinkPanel.height - CONST_DISTANCE;
			}
			if((this._clientDownloadPanel) && (this._clientDownloadPanel.parent))
			{
				this._clientDownloadPanel.onResize(param1,param2);
				this._clientDownloadPanel.x = 2;
				this._clientDownloadPanel.y = GlobalStage.stage.stageHeight - this._clientDownloadPanel.height - CONST_DISTANCE;
			}
			if((this._activityNoticePanel) && (this._activityNoticePanel.parent))
			{
				this._activityNoticePanel.onResize(param1,param2);
				this._activityNoticePanel.x = 2;
				this._activityNoticePanel.y = GlobalStage.stage.stageHeight - this._activityNoticePanel.height - CONST_DISTANCE;
			}
		}
		
		public function initVideoLinkPanel(param1:int, param2:VideoLinkInfo = null) : void
		{
			this.destroyAllPanel();
			this._panelType = param1;
			this._videoLinkPanel = new VideoLinkPanel();
			this._videoLinkPanel.updateInfo(param2);
			addChild(this._videoLinkPanel);
			this._videoLinkPanel.addEventListener(VideoLinkEvent.Evt_BtnAndIconClick,this.onWatchVideoClick);
			this._videoLinkPanel.addEventListener(VideoLinkEvent.Evt_Close,this.onCloseBtnClick);
			this.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
		}
		
		public function initClientDownloadPanel(param1:int) : void
		{
			this.destroyAllPanel();
			this._panelType = param1;
			TweenLite.delayedCall(VideoLinkDef.PANEL_SHOW_TIME,this.close);
			this._clientDownloadPanel = new ClientDownloadPanel();
			addChild(this._clientDownloadPanel);
			this._clientDownloadPanel.addEventListener(VideoLinkEvent.Evt_BtnAndIconClick,this.onWatchVideoClick);
			this._clientDownloadPanel.addEventListener(VideoLinkEvent.Evt_Close,this.onCloseBtnClick);
			this.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
		}
		
		public function initActivityNoticePanel(param1:int, param2:String, param3:String) : void
		{
			this.destroyAllPanel();
			this._panelType = param1;
			this._activityNoticeLink = param3;
			TweenLite.delayedCall(VideoLinkDef.PANEL_SHOW_TIME,this.close);
			this._activityNoticePanel = new ActivityNoticePanel();
			this._activityNoticePanel.updateInfo(param2);
			addChild(this._activityNoticePanel);
			this._activityNoticePanel.addEventListener(VideoLinkEvent.Evt_BtnAndIconClick,this.onWatchVideoClick);
			this._activityNoticePanel.addEventListener(VideoLinkEvent.Evt_Close,this.onCloseBtnClick);
			this.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
		}
		
		private function destroyAllPanel() : void
		{
			if(this._videoLinkPanel)
			{
				this._videoLinkPanel.removeEventListener(VideoLinkEvent.Evt_BtnAndIconClick,this.onWatchVideoClick);
				this._videoLinkPanel.removeEventListener(VideoLinkEvent.Evt_Close,this.onCloseBtnClick);
				this._videoLinkPanel.destroy();
				if(this._videoLinkPanel.parent)
				{
					removeChild(this._videoLinkPanel);
				}
				this._videoLinkPanel = null;
			}
			if(this._clientDownloadPanel)
			{
				this._clientDownloadPanel.removeEventListener(VideoLinkEvent.Evt_BtnAndIconClick,this.onWatchVideoClick);
				this._clientDownloadPanel.removeEventListener(VideoLinkEvent.Evt_Close,this.onCloseBtnClick);
				this._clientDownloadPanel.destroy();
				if(this._clientDownloadPanel.parent)
				{
					removeChild(this._clientDownloadPanel);
				}
				this._clientDownloadPanel = null;
			}
			if(this._activityNoticePanel)
			{
				this._activityNoticePanel.removeEventListener(VideoLinkEvent.Evt_BtnAndIconClick,this.onWatchVideoClick);
				this._activityNoticePanel.removeEventListener(VideoLinkEvent.Evt_Close,this.onCloseBtnClick);
				this._activityNoticePanel.destroy();
				if(this._activityNoticePanel.parent)
				{
					removeChild(this._activityNoticePanel);
				}
				this._activityNoticePanel = null;
			}
		}
		
		private function onWatchVideoClick(param1:VideoLinkEvent) : void
		{
			dispatchEvent(new VideoLinkEvent(VideoLinkEvent.Evt_BtnAndIconClick));
		}
		
		private function onCloseBtnClick(param1:VideoLinkEvent) : void
		{
			TweenLite.killTweensOf(this.close);
			this.close();
		}
	}
}
