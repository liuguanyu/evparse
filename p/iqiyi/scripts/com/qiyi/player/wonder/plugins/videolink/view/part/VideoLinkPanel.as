package com.qiyi.player.wonder.plugins.videolink.view.part {
	import flash.display.Sprite;
	import com.qiyi.player.wonder.IDestroy;
	import common.CommonCloseBtn;
	import common.CommonBg;
	import flash.text.TextField;
	import videolink.VideoLinkBtn;
	import flash.display.Loader;
	import com.qiyi.player.wonder.common.ui.FastCreator;
	import flash.text.TextFieldAutoSize;
	import flash.events.MouseEvent;
	import com.qiyi.player.wonder.plugins.videolink.model.VideoLinkInfo;
	import com.qiyi.player.wonder.plugins.videolink.VideoLinkDef;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import com.qiyi.player.wonder.plugins.videolink.view.VideoLinkEvent;
	import flash.display.DisplayObject;
	
	public class VideoLinkPanel extends Sprite implements IDestroy {
		
		public function VideoLinkPanel() {
			super();
			this.initUI();
		}
		
		private static const CONST_DISTANCE:uint = 70;
		
		private var _closeBtn:CommonCloseBtn;
		
		private var _commanBg:CommonBg;
		
		private var _descriptionTf:TextField;
		
		private var _linkBtn:VideoLinkBtn;
		
		private var _linkBtnTF:TextField;
		
		private var _loader:Loader;
		
		private function initUI() : void {
			this._commanBg = new CommonBg();
			this._commanBg.width = 290;
			this._commanBg.height = 70;
			addChild(this._commanBg);
			this._descriptionTf = FastCreator.createLabel("123",16777215,12,TextFieldAutoSize.LEFT);
			this._descriptionTf.x = 120;
			this._descriptionTf.y = 4;
			this._descriptionTf.width = 140;
			this._descriptionTf.wordWrap = this._descriptionTf.multiline = true;
			addChild(this._descriptionTf);
			this._linkBtn = new VideoLinkBtn();
			this._linkBtn.x = 125;
			this._linkBtn.y = 45;
			addChild(this._linkBtn);
			this._linkBtnTF = FastCreator.createLabel("立即观看",16777215,13,TextFieldAutoSize.LEFT);
			this._linkBtnTF.x = this._linkBtn.x + (this._linkBtn.width - this._linkBtnTF.width) * 0.5;
			this._linkBtnTF.y = this._linkBtn.y + (this._linkBtn.height - this._linkBtnTF.height) * 0.5;
			this._linkBtnTF.selectable = this._linkBtnTF.mouseEnabled = false;
			addChild(this._linkBtnTF);
			this._closeBtn = new CommonCloseBtn();
			this._closeBtn.x = this._commanBg.width - this._closeBtn.width;
			addChild(this._closeBtn);
			this._linkBtn.addEventListener(MouseEvent.CLICK,this.onWatchVideoClick);
			this._closeBtn.addEventListener(MouseEvent.CLICK,this.onCloseBtnClick);
		}
		
		public function updateInfo(param1:VideoLinkInfo) : void {
			this._descriptionTf.text = param1.title;
			this.loaderPNG(param1.picUrl);
			switch(param1.btnType) {
				case VideoLinkDef.BTN_TYPE_PLAY:
					this._linkBtnTF.text = "立即观看";
					break;
				case VideoLinkDef.BTN_TYPE_DOWNLOAD:
					this._linkBtnTF.text = "立即下载";
					break;
				case VideoLinkDef.BTN_TYPE_INSERT:
					this._linkBtnTF.text = "立即进入";
					break;
			}
		}
		
		public function onResize(param1:int, param2:int) : void {
		}
		
		private function loaderPNG(param1:String) : void {
			this.destroyUpLoader();
			this._loader = new Loader();
			this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onComplete);
			this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
			this._loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onIOError);
			this._loader.load(new URLRequest(param1));
		}
		
		private function onComplete(param1:Event) : void {
			addChild(this._loader);
		}
		
		private function onIOError(param1:Event) : void {
		}
		
		private function destroyUpLoader() : void {
			if(this._loader == null) {
				return;
			}
			if(this._loader.parent) {
				removeChild(this._loader);
			}
			this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onComplete);
			this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
			this._loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onIOError);
			this._loader = null;
		}
		
		private function onWatchVideoClick(param1:MouseEvent) : void {
			dispatchEvent(new VideoLinkEvent(VideoLinkEvent.Evt_BtnAndIconClick));
		}
		
		private function onCloseBtnClick(param1:MouseEvent) : void {
			dispatchEvent(new VideoLinkEvent(VideoLinkEvent.Evt_Close));
		}
		
		public function destroy() : void {
			var _loc1_:DisplayObject = null;
			this.destroyUpLoader();
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
