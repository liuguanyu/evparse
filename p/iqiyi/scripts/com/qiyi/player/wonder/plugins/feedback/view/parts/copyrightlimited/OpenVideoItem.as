package com.qiyi.player.wonder.plugins.feedback.view.parts.copyrightlimited {
	import flash.display.Sprite;
	import flash.text.TextField;
	import com.qiyi.player.wonder.common.ui.FastCreator;
	import flash.events.MouseEvent;
	import com.iqiyi.components.global.GlobalStage;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	public class OpenVideoItem extends Sprite {
		
		public function OpenVideoItem(param1:String, param2:String, param3:String, param4:Boolean = false) {
			super();
			buttonMode = true;
			this._videoUrl = param1;
			this._picUrl = param2;
			this._label = param3;
			if(param3.length > 26) {
				this._label = param3.slice(0,26) + "..";
			}
			this._horizontal = param4;
			this.initUI();
			addEventListener(MouseEvent.CLICK,this.onItemClick);
			addEventListener(MouseEvent.ROLL_OVER,this.onItemRollOver);
			addEventListener(MouseEvent.ROLL_OUT,this.onItemRollOut);
		}
		
		private var _videoUrl:String;
		
		public var _picUrl:String = "";
		
		private var _label:String;
		
		private var _horizontal:Boolean;
		
		private var _labelText:TextField;
		
		private function initUI() : void {
			var _loc1_:OpenVideoPicFrame = null;
			this._labelText = FastCreator.createLabel(this._label,10066329);
			this._labelText.wordWrap = true;
			this._labelText.height = 54;
			if(this._horizontal) {
				_loc1_ = new OpenVideoPicFrame(117,79,this._picUrl,16777215,10066329,2);
				_loc1_.x = 9.5;
				_loc1_.y = 20;
				this._labelText.x = _loc1_.x;
				this._labelText.y = 110;
				this._labelText.width = 117;
			} else {
				_loc1_ = new OpenVideoPicFrame(95,122,this._picUrl,16777215,10066329,2);
				_loc1_.x = 20.5;
				_loc1_.y = 8;
				this._labelText.x = _loc1_.x;
				this._labelText.y = 138;
				this._labelText.width = 95;
			}
			addChild(_loc1_);
			addChild(this._labelText);
		}
		
		private function onItemClick(param1:MouseEvent) : void {
			if(GlobalStage.isFullScreen()) {
				GlobalStage.setNormalScreen();
			}
			navigateToURL(new URLRequest(this._videoUrl),"_self");
		}
		
		private function onItemRollOver(param1:MouseEvent) : void {
			this._labelText.defaultTextFormat.underline = true;
			this._labelText.textColor = 8562957;
		}
		
		private function onItemRollOut(param1:MouseEvent) : void {
			this._labelText.defaultTextFormat.underline = false;
			this._labelText.textColor = 10066329;
		}
	}
}
