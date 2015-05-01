package com.qiyi.player.wonder.plugins.share.view.parts {
	import flash.display.Sprite;
	import flash.text.TextField;
	import com.iqiyi.components.videoshare.ShareBtnsBarUI;
	import com.iqiyi.components.videoshare.EmbedCodesUI;
	import com.qiyi.player.wonder.common.ui.SimpleBtn;
	import com.qiyi.player.base.pub.EnumItem;
	import com.qiyi.player.wonder.common.ui.FastCreator;
	import flash.events.MouseEvent;
	import com.iqiyi.components.tooltip.ToolTip;
	import com.qiyi.player.wonder.plugins.share.ShareDef;
	import com.iqiyi.components.global.GlobalStage;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import com.qiyi.player.wonder.plugins.share.view.ShareEvent;
	import flash.system.System;
	
	public class VideoShare extends Sprite {
		
		public function VideoShare(param1:String, param2:String, param3:Number, param4:EnumItem, param5:String, param6:String, param7:Boolean) {
			super();
			this._htmlUrl = param1;
			this._swfUrl = param2;
			this._duration = param3;
			this._channel = param4;
			this._videoUrl = param5;
			this._flvTitle = param6;
			this._isShowLinkUrl = param7;
			this.initShareBtnsBarPart();
			if(param7) {
				this.initCopyUrlPart();
			}
		}
		
		private static const TEXT_SHOT_TITLE:String = "一键分享：";
		
		private static const TEXT_CODE_TITLE:String = "复制转帖：";
		
		private static const TEXT_SINE_TITLE:String = "新浪微博";
		
		private static const TEXT_RENREN_TITLE:String = "人人网";
		
		private static const TEXT_TENCENT_TITLE:String = "腾讯微博";
		
		private static const TEXT_QZONE_TITLE:String = "QQ空间";
		
		private static const TEXT_COPY_FLASH:String = "复制flash地址";
		
		private static const TEXT_COPY_VIDEO:String = "复制视频地址";
		
		private static const TEXT_COPY_HTML:String = "复制Html地址";
		
		private var _screenShotTitle:TextField;
		
		private var _embedCodesTitle:TextField;
		
		private var _shareBtnsBar:ShareBtnsBarUI;
		
		private var _embedCodes:EmbedCodesUI;
		
		private var _copyFlashBtn:SimpleBtn;
		
		private var _copyVideoBtn:SimpleBtn;
		
		private var _copyHtmlBtn:SimpleBtn;
		
		private var _htmlUrl:String;
		
		private var _swfUrl:String;
		
		private var _videoUrl:String;
		
		private var _duration:Number;
		
		private var _flvTitle:String;
		
		private var _channel:EnumItem;
		
		private var _isShowLinkUrl:Boolean = false;
		
		private function initCopyUrlPart() : void {
			this._embedCodes = new EmbedCodesUI();
			this._embedCodes.copyOK.visible = false;
			addChild(this._embedCodes);
			this._embedCodesTitle = FastCreator.createLabel(TEXT_CODE_TITLE,13421772);
			this._embedCodesTitle.x = 20;
			this._embedCodesTitle.y = 62;
			addChild(this._embedCodesTitle);
			this._copyFlashBtn = new SimpleBtn(TEXT_COPY_FLASH,100);
			this._copyFlashBtn.x = this._embedCodesTitle.x;
			addChild(this._copyFlashBtn);
			this._copyVideoBtn = new SimpleBtn(TEXT_COPY_VIDEO,100);
			this._copyVideoBtn.x = 111 + this._embedCodesTitle.x;
			addChild(this._copyVideoBtn);
			this._copyHtmlBtn = new SimpleBtn(TEXT_COPY_HTML,100);
			this._copyHtmlBtn.x = 222 + this._embedCodesTitle.x;
			addChild(this._copyHtmlBtn);
			this._copyFlashBtn.y = this._copyVideoBtn.y = this._copyHtmlBtn.y = this._embedCodesTitle.y + this._embedCodesTitle.height + 5;
			this._copyFlashBtn.addEventListener(MouseEvent.CLICK,this.copyFlashURL);
			this._copyVideoBtn.addEventListener(MouseEvent.CLICK,this.copyVideoURL);
			this._copyHtmlBtn.addEventListener(MouseEvent.CLICK,this.copyHtmlURL);
		}
		
		private function initShareBtnsBarPart() : void {
			this._shareBtnsBar = new ShareBtnsBarUI();
			this._shareBtnsBar.x = 83;
			this._shareBtnsBar.y = 32;
			addChild(this._shareBtnsBar);
			this._screenShotTitle = FastCreator.createLabel(TEXT_SHOT_TITLE,13421772);
			this._screenShotTitle.x = 20;
			this._screenShotTitle.y = 33;
			addChild(this._screenShotTitle);
			ToolTip.getInstance().registerComponent(this._shareBtnsBar.sinaBtn,TEXT_SINE_TITLE);
			ToolTip.getInstance().registerComponent(this._shareBtnsBar.qzoneBtn,TEXT_QZONE_TITLE);
			ToolTip.getInstance().registerComponent(this._shareBtnsBar.tencentBtn,TEXT_TENCENT_TITLE);
			ToolTip.getInstance().registerComponent(this._shareBtnsBar.renrenBtn,TEXT_RENREN_TITLE);
			this._shareBtnsBar.renrenBtn.addEventListener(MouseEvent.MOUSE_UP,this.renrenShareHandler);
			this._shareBtnsBar.sinaBtn.addEventListener(MouseEvent.MOUSE_UP,this.sinaShareHandler);
			this._shareBtnsBar.qzoneBtn.addEventListener(MouseEvent.MOUSE_UP,this.qzoneShareHandler);
			this._shareBtnsBar.tencentBtn.addEventListener(MouseEvent.MOUSE_UP,this.tencentShareHandler);
		}
		
		private function renrenShareHandler(param1:MouseEvent) : void {
			var _loc2_:String = ShareDef.SHARE_PLATFORM_RENREN_URI + "?link=" + this.getVideoURL() + "&title=" + encodeURIComponent("【视频：" + this._flvTitle + "】（分享@爱奇艺）");
			this.shareBtnClick(_loc2_,ShareDef.SHARE_TYPE_RENREN);
		}
		
		private function sinaShareHandler(param1:MouseEvent) : void {
			var _loc2_:* = "";
			_loc2_ = ShareDef.SHARE_PLATFORM_SINA_URI + "?appkey=1925825497&url=" + this.getVideoURL() + "&title=" + encodeURIComponent("【视频：" + this._flvTitle + "】") + "&content=utf-8&pic=&ralateUid=1731986465";
			this.shareBtnClick(_loc2_,ShareDef.SHARE_TYPE_SINA);
		}
		
		private function qzoneShareHandler(param1:MouseEvent) : void {
			var _loc2_:String = ShareDef.SHARE_PLATFORM_QQ_URI + "?url=" + this.getVideoURL().split("=").join("%3D");
			this.shareBtnClick(_loc2_,ShareDef.SHARE_TYPE_QQ);
		}
		
		private function tencentShareHandler(param1:MouseEvent) : void {
			var _loc2_:String = ShareDef.SHARE_PLATFORM_TENCENT_URI + "?title=" + encodeURIComponent("【视频：" + this._flvTitle + "】（分享@爱奇艺）") + "&url=" + this.getVideoURL().split("=").join("%3D");
			this.shareBtnClick(_loc2_,ShareDef.SHARE_TYPE_TENCENT);
		}
		
		private function getVideoURL() : String {
			var _loc2_:RegExp = null;
			var _loc1_:* = "";
			if(this._videoUrl != null) {
				_loc1_ = this._videoUrl.indexOf("?") == -1?this._videoUrl + "?" + "share_sTime=" + 0 + "-share_eTime=" + Math.floor(this._duration / 1000) + "-src=sharemodclk131212":this._videoUrl + "&" + "share_sTime=" + 0 + "-share_eTime=" + Math.floor(this._duration / 1000) + "-src=sharemodclk131212";
				_loc2_ = new RegExp("&","g");
				_loc1_ = _loc1_.replace(_loc2_,"%26");
			}
			return _loc1_;
		}
		
		private function shareBtnClick(param1:String, param2:String) : void {
			GlobalStage.setNormalScreen();
			navigateToURL(new URLRequest(param1),"_blank");
			var _loc3_:ShareEvent = new ShareEvent(ShareEvent.Evt_ShareBtnClick);
			_loc3_.data = param2;
			dispatchEvent(_loc3_);
		}
		
		private function copyFlashURL(param1:MouseEvent) : void {
			System.setClipboard(this._swfUrl);
			this.playCopySuccess(this._copyFlashBtn.x + 32,this._copyFlashBtn.y + 20);
		}
		
		private function copyVideoURL(param1:MouseEvent) : void {
			var _loc2_:RegExp = new RegExp("%26","g");
			var _loc3_:String = this.getVideoURL().replace(_loc2_,"&");
			if(_loc3_ == this._videoUrl) {
				System.setClipboard(this._videoUrl);
			} else {
				System.setClipboard(_loc3_);
			}
			this.playCopySuccess(this._copyVideoBtn.x + 32,this._copyVideoBtn.y + 20);
		}
		
		private function copyHtmlURL(param1:MouseEvent) : void {
			System.setClipboard(this._htmlUrl);
			this.playCopySuccess(this._copyHtmlBtn.x + 32,this._copyHtmlBtn.y + 20);
		}
		
		private function playCopySuccess(param1:Number, param2:Number) : void {
			this._embedCodes.copyOK.x = param1;
			this._embedCodes.copyOK.y = param2;
			this._embedCodes.copyOK.visible = true;
			this._embedCodes.copyOK.gotoAndPlay(2);
		}
		
		public function destory() : void {
			ToolTip.getInstance().unregisterComponent(this._shareBtnsBar.sinaBtn);
			ToolTip.getInstance().unregisterComponent(this._shareBtnsBar.qzoneBtn);
			ToolTip.getInstance().unregisterComponent(this._shareBtnsBar.tencentBtn);
			ToolTip.getInstance().unregisterComponent(this._shareBtnsBar.renrenBtn);
			this._shareBtnsBar.renrenBtn.removeEventListener(MouseEvent.MOUSE_UP,this.renrenShareHandler);
			this._shareBtnsBar.sinaBtn.removeEventListener(MouseEvent.MOUSE_UP,this.sinaShareHandler);
			this._shareBtnsBar.qzoneBtn.removeEventListener(MouseEvent.MOUSE_UP,this.qzoneShareHandler);
			this._shareBtnsBar.tencentBtn.removeEventListener(MouseEvent.MOUSE_UP,this.tencentShareHandler);
			if((this._screenShotTitle) && (this._screenShotTitle.parent)) {
				removeChild(this._screenShotTitle);
				this._screenShotTitle = null;
			}
			if((this._embedCodesTitle) && (this._embedCodesTitle.parent)) {
				removeChild(this._embedCodesTitle);
				this._embedCodesTitle = null;
			}
			if((this._shareBtnsBar) && (this._shareBtnsBar.parent)) {
				removeChild(this._shareBtnsBar);
				this._shareBtnsBar = null;
			}
			if((this._embedCodes) && (this._embedCodes.parent)) {
				removeChild(this._embedCodes);
				this._embedCodes = null;
			}
			if((this._copyFlashBtn) && (this._copyFlashBtn.parent)) {
				this._copyFlashBtn.removeEventListener(MouseEvent.CLICK,this.copyFlashURL);
				removeChild(this._copyFlashBtn);
				this._copyFlashBtn = null;
			}
			if((this._copyVideoBtn) && (this._copyVideoBtn.parent)) {
				this._copyVideoBtn.removeEventListener(MouseEvent.CLICK,this.copyVideoURL);
				removeChild(this._copyVideoBtn);
				this._copyVideoBtn = null;
			}
			if((this._copyHtmlBtn) && (this._copyHtmlBtn.parent)) {
				this._copyHtmlBtn.removeEventListener(MouseEvent.CLICK,this.copyHtmlURL);
				removeChild(this._copyHtmlBtn);
				this._copyHtmlBtn = null;
			}
			this._channel = null;
		}
	}
}
