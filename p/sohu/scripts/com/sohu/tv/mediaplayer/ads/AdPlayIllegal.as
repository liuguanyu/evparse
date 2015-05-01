package com.sohu.tv.mediaplayer.ads {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import ebing.Utils;
	import flash.text.TextFormatAlign;
	import flash.events.TextEvent;
	import flash.text.AntiAliasType;
	import com.sohu.tv.mediaplayer.stat.ErrorSenderPQ;
	
	public class AdPlayIllegal extends Sprite {
		
		public function AdPlayIllegal(param1:Number, param2:Number, param3:String) {
			super();
			this._width = param1;
			this._height = param2;
			this._msg = param3;
			this.init();
		}
		
		private var _width:Number = 0;
		
		private var _height:Number = 0;
		
		private var _bg:Sprite;
		
		private var _msg:String = "";
		
		private var _limit:TextField;
		
		private var _tf:TextFormat;
		
		private function init() : void {
			this.drawSkin();
		}
		
		private function drawSkin() : void {
			this._bg = new Sprite();
			Utils.drawRect(this._bg,0,0,this._width,this._height,0,1);
			addChild(this._bg);
			this._tf = new TextFormat();
			this._tf.size = 14;
			this._tf.leading = 10;
			this._tf.font = "微软雅黑";
			this._tf.align = TextFormatAlign.CENTER;
			this._limit = new TextField();
			this._limit.wordWrap = true;
			this._limit.multiline = true;
			this._limit.textColor = 11776947;
			this._limit.width = this._width;
			this._limit.height = 150;
			this._limit.htmlText = this._msg;
			this._limit.addEventListener(TextEvent.LINK,this.linkHandler);
			this._limit.antiAliasType = AntiAliasType.ADVANCED;
			this._limit.setTextFormat(this._tf);
			addChild(this._limit);
			Utils.setCenter(this._limit,this._bg);
		}
		
		private function linkHandler(param1:TextEvent) : void {
			switch(param1.text) {
				case "1":
					ErrorSenderPQ.getInstance().sendFeedback();
					break;
			}
		}
		
		public function resize(param1:Number, param2:Number) : void {
			this._width = param1;
			this._height = param2;
			this._bg.width = this._width;
			this._bg.height = this._height;
			Utils.setCenter(this._limit,this._bg);
		}
	}
}
