package com.qiyi.player.wonder.plugins.videolink.view.part
{
	import flash.display.Sprite;
	import com.qiyi.player.wonder.IDestroy;
	import common.CommonCloseBtn;
	import common.CommonBg;
	import videolink.ActivityNoticeSuona;
	import flash.text.TextField;
	import com.qiyi.player.wonder.common.ui.FastCreator;
	import flash.text.TextFieldAutoSize;
	import flash.events.TextEvent;
	import flash.events.MouseEvent;
	import com.qiyi.player.wonder.plugins.videolink.view.VideoLinkEvent;
	import flash.display.DisplayObject;
	
	public class ActivityNoticePanel extends Sprite implements IDestroy
	{
		
		private static const TEXT_LINK:String = "<a href=\'event:onTextEventClick\'>去看看</a>";
		
		private var _closeBtn:CommonCloseBtn;
		
		private var _commanBg:CommonBg;
		
		private var _suona:ActivityNoticeSuona;
		
		private var _descriptionTf:TextField;
		
		private var _linkTF:TextField;
		
		public function ActivityNoticePanel()
		{
			super();
			this.initUI();
		}
		
		private function initUI() : void
		{
			this._commanBg = new CommonBg();
			this._commanBg.width = 290;
			this._commanBg.height = 70;
			addChild(this._commanBg);
			this._suona = new ActivityNoticeSuona();
			this._suona.x = 15;
			this._suona.y = 25;
			addChild(this._suona);
			this._descriptionTf = FastCreator.createLabel("11111",16777215,12,TextFieldAutoSize.LEFT);
			this._descriptionTf.y = 14;
			this._descriptionTf.width = 270;
			this._descriptionTf.wordWrap = this._descriptionTf.multiline = true;
			addChild(this._descriptionTf);
			this._linkTF = FastCreator.createLabel("立即下载",16749085,12,TextFieldAutoSize.LEFT);
			this._linkTF.x = 220;
			this._linkTF.y = 30;
			this._linkTF.htmlText = TEXT_LINK;
			addChild(this._linkTF);
			this._closeBtn = new CommonCloseBtn();
			this._closeBtn.x = this._commanBg.width - this._closeBtn.width;
			addChild(this._closeBtn);
			this._linkTF.addEventListener(TextEvent.LINK,this.onWatchVideoClick);
			this._closeBtn.addEventListener(MouseEvent.CLICK,this.onCloseBtnClick);
		}
		
		public function updateInfo(param1:String) : void
		{
			this._descriptionTf.text = "      " + param1;
		}
		
		public function onResize(param1:int, param2:int) : void
		{
		}
		
		private function onWatchVideoClick(param1:TextEvent) : void
		{
			dispatchEvent(new VideoLinkEvent(VideoLinkEvent.Evt_BtnAndIconClick));
		}
		
		private function onCloseBtnClick(param1:MouseEvent) : void
		{
			dispatchEvent(new VideoLinkEvent(VideoLinkEvent.Evt_Close));
		}
		
		public function destroy() : void
		{
			var _loc1:DisplayObject = null;
			this._linkTF.removeEventListener(TextEvent.LINK,this.onWatchVideoClick);
			this._closeBtn.removeEventListener(MouseEvent.CLICK,this.onCloseBtnClick);
			while(numChildren)
			{
				_loc1 = getChildAt(0);
				if(_loc1.parent)
				{
					removeChild(_loc1);
				}
				_loc1 = null;
			}
		}
	}
}
