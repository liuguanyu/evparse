package com.qiyi.player.wonder.plugins.scenetile.view.scorepart {
	import flash.display.Sprite;
	import common.CommonBg;
	import scenetile.ScoreCloseBtn;
	import scenetile.ScoreSuccessIcon;
	import flash.text.TextField;
	import scenetile.ScoreDecorateLine;
	import com.qiyi.player.wonder.common.ui.FastCreator;
	import flash.text.TextFieldAutoSize;
	import flash.events.MouseEvent;
	import com.iqiyi.components.global.GlobalStage;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import com.qiyi.player.wonder.common.config.SystemConfig;
	import com.qiyi.player.wonder.common.pingback.PingBack;
	import com.qiyi.player.wonder.common.pingback.PingBackDef;
	import com.qiyi.player.wonder.plugins.scenetile.view.SceneTileEvent;
	import flash.display.DisplayObject;
	
	public class ScoreSuccessPanel extends Sprite {
		
		public function ScoreSuccessPanel(param1:Boolean) {
			super();
			this._isLogin = param1;
			this.initPanel();
		}
		
		private static const STR_PANEL_DES_LOGIN:String = "评价成功！";
		
		private static const STR_PANEL_DES_UNLOGIN:String = "评价的越多为您推荐的更精准！";
		
		private static const STR_TOPERSONMOVIE_TF:String = "进入爱奇艺电影个性版";
		
		private static const STR_BOTTON_TF:String = "好电影与你零距离";
		
		private var _bg:CommonBg;
		
		private var _closeBtn:ScoreCloseBtn;
		
		private var _scoreSuccessIcon:ScoreSuccessIcon;
		
		private var _tfPanelDescribe:TextField;
		
		private var _btnToPersonMovie:Sprite;
		
		private var _tfToPersonMovie:TextField;
		
		private var _tfBottom:TextField;
		
		private var _decorateLineLeft:ScoreDecorateLine;
		
		private var _decorateLineRight:ScoreDecorateLine;
		
		private var _isLogin:Boolean = false;
		
		private function initPanel() : void {
			this._bg = new CommonBg();
			this._bg.width = 380;
			this._bg.height = 160;
			addChild(this._bg);
			if(this._isLogin) {
				this._scoreSuccessIcon = new ScoreSuccessIcon();
				this._scoreSuccessIcon.x = 126;
				this._scoreSuccessIcon.y = 20;
				addChild(this._scoreSuccessIcon);
				this._tfPanelDescribe = FastCreator.createLabel(STR_PANEL_DES_LOGIN,16777215,16,TextFieldAutoSize.LEFT);
				this._tfPanelDescribe.x = 159;
				this._tfPanelDescribe.y = 18;
				addChild(this._tfPanelDescribe);
			} else {
				this._tfPanelDescribe = FastCreator.createLabel(STR_PANEL_DES_UNLOGIN,16777215,16,TextFieldAutoSize.LEFT);
				this._tfPanelDescribe.x = (this._bg.width - this._tfPanelDescribe.width) * 0.5;
				this._tfPanelDescribe.y = 18;
				addChild(this._tfPanelDescribe);
			}
			this._btnToPersonMovie = new Sprite();
			this._btnToPersonMovie.graphics.beginFill(7323402);
			this._btnToPersonMovie.graphics.drawRoundRect(0,0,200,40,5);
			this._btnToPersonMovie.graphics.endFill();
			this._btnToPersonMovie.x = (this._bg.width - this._btnToPersonMovie.width) * 0.5;
			this._btnToPersonMovie.y = 66;
			this._btnToPersonMovie.buttonMode = this._btnToPersonMovie.useHandCursor = true;
			addChild(this._btnToPersonMovie);
			this._tfToPersonMovie = FastCreator.createLabel(STR_TOPERSONMOVIE_TF,0,16,TextFieldAutoSize.LEFT);
			this._tfToPersonMovie.x = this._btnToPersonMovie.x + (this._btnToPersonMovie.width - this._tfToPersonMovie.width) * 0.5;
			this._tfToPersonMovie.y = this._btnToPersonMovie.y + (this._btnToPersonMovie.height - this._tfToPersonMovie.height) * 0.5;
			this._tfToPersonMovie.selectable = this._tfToPersonMovie.mouseEnabled = false;
			addChild(this._tfToPersonMovie);
			this._tfBottom = FastCreator.createLabel(STR_BOTTON_TF,16777215,12,TextFieldAutoSize.LEFT);
			this._tfBottom.x = (this._bg.width - this._tfBottom.width) * 0.5;
			this._tfBottom.y = 122;
			addChild(this._tfBottom);
			this._decorateLineLeft = new ScoreDecorateLine();
			this._decorateLineLeft.x = this._tfBottom.x - this._decorateLineLeft.width - 3;
			this._decorateLineLeft.y = this._tfBottom.y + this._tfBottom.height * 0.5;
			addChild(this._decorateLineLeft);
			this._decorateLineRight = new ScoreDecorateLine();
			this._decorateLineRight.rotation = 180;
			this._decorateLineRight.x = this._tfBottom.x + this._tfBottom.width + this._decorateLineRight.width + 3;
			this._decorateLineRight.y = this._tfBottom.y + this._tfBottom.height * 0.5 + 1;
			addChild(this._decorateLineRight);
			this._closeBtn = new ScoreCloseBtn();
			this._closeBtn.x = this._bg.width - this._closeBtn.width / 2 - 5;
			this._closeBtn.y = -this._closeBtn.height / 2 + 5;
			addChild(this._closeBtn);
			this._btnToPersonMovie.addEventListener(MouseEvent.CLICK,this.onToPersonMovieBtnClick);
			this._closeBtn.addEventListener(MouseEvent.CLICK,this.onCloseBtnClick);
		}
		
		private function onToPersonMovieBtnClick(param1:MouseEvent) : void {
			GlobalStage.setNormalScreen();
			navigateToURL(new URLRequest(SystemConfig.MOVIE_INDIVIDUALIZATION_URL),"_black");
			PingBack.getInstance().userActionPing(PingBackDef.SCORE_PERSON_PAGE_CLICK);
		}
		
		private function onCloseBtnClick(param1:MouseEvent) : void {
			dispatchEvent(new SceneTileEvent(SceneTileEvent.Evt_ScoreClose));
		}
		
		public function destory() : void {
			var _loc1_:DisplayObject = null;
			this._btnToPersonMovie.removeEventListener(MouseEvent.CLICK,this.onToPersonMovieBtnClick);
			this._closeBtn.removeEventListener(MouseEvent.CLICK,this.onCloseBtnClick);
			while(numChildren > 0) {
				_loc1_ = getChildAt(0);
				if(_loc1_.parent) {
					_loc1_.parent.removeChild(_loc1_);
				}
				_loc1_ = null;
			}
		}
	}
}
