package com.qiyi.cupid.adplayer.view.components
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	public dynamic class AdBlockTips extends MovieClip
	{
		
		public var _otherBrowserBtn:SimpleButton;
		
		public var _feedbackBtn:SimpleButton;
		
		public var _installBtn:SimpleButton;
		
		public function AdBlockTips()
		{
			super();
			addFrameScript(0,this.frame1);
		}
		
		public function installBtnMouseClickHandler(param1:MouseEvent) : void
		{
			navigateToURL(new URLRequest("http://static.qiyi.com/ext/common/QIYImedia_0_13.exe"),"_self");
		}
		
		public function feedbackBtnMouseClickHandler(param1:MouseEvent) : void
		{
			navigateToURL(new URLRequest("http://www.iqiyi.com/common/helpandsuggest.html"),"_blank");
		}
		
		public function otherBrowserBtnMouseClickHandler(param1:MouseEvent) : void
		{
			navigateToURL(new URLRequest("http://www.iqiyi.com/common/helpandsuggest.html#wenti31"),"_blank");
		}
		
		function frame1() : *
		{
			this._installBtn.addEventListener(MouseEvent.CLICK,this.installBtnMouseClickHandler);
			this._feedbackBtn.addEventListener(MouseEvent.CLICK,this.feedbackBtnMouseClickHandler);
			this._otherBrowserBtn.addEventListener(MouseEvent.CLICK,this.otherBrowserBtnMouseClickHandler);
		}
	}
}
