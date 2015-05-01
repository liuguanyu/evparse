package com.qiyi.player.wonder.plugins.videolink.view.part {
	import flash.display.Sprite;
	import com.qiyi.player.wonder.IDestroy;
	import common.CommonCloseBtn;
	import common.CommonBg;
	import flash.text.TextField;
	import videolink.VideoLinkBtn;
	import videolink.ClientIcon;
	import com.qiyi.player.wonder.common.ui.FastCreator;
	import flash.text.TextFieldAutoSize;
	import flash.events.MouseEvent;
	import com.qiyi.player.wonder.plugins.videolink.view.VideoLinkEvent;
	import flash.display.DisplayObject;
	
	public class ClientDownloadPanel extends Sprite implements IDestroy {
		
		public function ClientDownloadPanel() {
			super();
			this.initUI();
		}
		
		private static const STR_VIDEOLINK_DEC:String = "视频播放是不是有点卡？\n安装爱奇艺客户端更流畅";
		
		private var _closeBtn:CommonCloseBtn;
		
		private var _commanBg:CommonBg;
		
		private var _descriptionTf:TextField;
		
		private var _linkBtn:VideoLinkBtn;
		
		private var _linkBtnTF:TextField;
		
		private var _clientIcon:ClientIcon;
		
		private function initUI() : void {
			this._commanBg = new CommonBg();
			this._commanBg.width = 290;
			this._commanBg.height = 70;
			addChild(this._commanBg);
			this._clientIcon = new ClientIcon();
			this._clientIcon.useHandCursor = this._clientIcon.buttonMode = true;
			addChild(this._clientIcon);
			this._descriptionTf = FastCreator.createLabel(STR_VIDEOLINK_DEC,16777215,12,TextFieldAutoSize.LEFT);
			this._descriptionTf.x = 120;
			this._descriptionTf.y = 4;
			this._descriptionTf.width = 140;
			this._descriptionTf.wordWrap = this._descriptionTf.multiline = true;
			addChild(this._descriptionTf);
			this._linkBtn = new VideoLinkBtn();
			this._linkBtn.x = 125;
			this._linkBtn.y = 45;
			addChild(this._linkBtn);
			this._linkBtnTF = FastCreator.createLabel("立即下载",16777215,13,TextFieldAutoSize.LEFT);
			this._linkBtnTF.x = this._linkBtn.x + (this._linkBtn.width - this._linkBtnTF.width) * 0.5;
			this._linkBtnTF.y = this._linkBtn.y + (this._linkBtn.height - this._linkBtnTF.height) * 0.5;
			this._linkBtnTF.selectable = this._linkBtnTF.mouseEnabled = false;
			addChild(this._linkBtnTF);
			this._closeBtn = new CommonCloseBtn();
			this._closeBtn.x = this._commanBg.width - this._closeBtn.width;
			addChild(this._closeBtn);
			this._clientIcon.addEventListener(MouseEvent.CLICK,this.onWatchVideoClick);
			this._linkBtn.addEventListener(MouseEvent.CLICK,this.onWatchVideoClick);
			this._closeBtn.addEventListener(MouseEvent.CLICK,this.onCloseBtnClick);
		}
		
		public function onResize(param1:int, param2:int) : void {
		}
		
		private function onWatchVideoClick(param1:MouseEvent) : void {
			dispatchEvent(new VideoLinkEvent(VideoLinkEvent.Evt_BtnAndIconClick));
		}
		
		private function onCloseBtnClick(param1:MouseEvent) : void {
			dispatchEvent(new VideoLinkEvent(VideoLinkEvent.Evt_Close));
		}
		
		public function destroy() : void {
			var _loc1_:DisplayObject = null;
			this._clientIcon.removeEventListener(MouseEvent.CLICK,this.onWatchVideoClick);
			this._linkBtn.removeEventListener(MouseEvent.CLICK,this.onWatchVideoClick);
			this._closeBtn.removeEventListener(MouseEvent.CLICK,this.onCloseBtnClick);
			while(numChildren) {
				_loc1_ = getChildAt(0);
				if(_loc1_.parent) {
					removeChild(_loc1_);
				}
				_loc1_ = null;
			}
		}
	}
}
