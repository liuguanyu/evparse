package com.qiyi.player.wonder.common.ui {
	import flash.display.Sprite;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	
	public class SelectTextField extends Sprite {
		
		public function SelectTextField(param1:String = "", param2:uint = 14) {
			super();
			this._textField = FastCreator.createLabel(param1,13421772,param2,"left");
			addChild(this._textField);
			this._mouseSprite = new Sprite();
			this._mouseSprite.graphics.beginFill(16711680,0);
			this._mouseSprite.graphics.drawRect(this._textField.x,this._textField.y,this._textField.width,this._textField.height);
			this._mouseSprite.graphics.endFill();
			this._mouseSprite.useHandCursor = true;
			this._mouseSprite.buttonMode = true;
			addChild(this._mouseSprite);
			this._mouseSprite.addEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOver);
			this._mouseSprite.addEventListener(MouseEvent.ROLL_OUT,this.onMouseRollOut);
		}
		
		private static const SELE_TEXTFORMAT:TextFormat = new TextFormat(FastCreator.FONT_MSYH,null,10079283);
		
		private static const NONE_TEXTFORMAT:TextFormat = new TextFormat(FastCreator.FONT_MSYH,null,13421772);
		
		private static const OVER_TEXTFORMAT:TextFormat = new TextFormat(FastCreator.FONT_MSYH,null,16777215);
		
		private var _mouseSprite:Sprite;
		
		private var _textField:TextField;
		
		private var _isSelected:Boolean = false;
		
		private var _data:Object;
		
		private function onMouseRollOver(param1:MouseEvent) : void {
			if(!this._isSelected) {
				this._textField.defaultTextFormat = OVER_TEXTFORMAT;
				this._textField.setTextFormat(OVER_TEXTFORMAT);
			}
		}
		
		private function onMouseRollOut(param1:MouseEvent) : void {
			if(!this._isSelected) {
				this._textField.defaultTextFormat = NONE_TEXTFORMAT;
				this._textField.setTextFormat(NONE_TEXTFORMAT);
			}
		}
		
		public function get data() : Object {
			return this._data;
		}
		
		public function set data(param1:Object) : void {
			this._data = param1;
		}
		
		public function get isSelected() : Boolean {
			return this._isSelected;
		}
		
		public function set isSelected(param1:Boolean) : void {
			this._isSelected = param1;
			this._textField.defaultTextFormat = this._isSelected?SELE_TEXTFORMAT:NONE_TEXTFORMAT;
			this._textField.setTextFormat(this._isSelected?SELE_TEXTFORMAT:NONE_TEXTFORMAT);
		}
		
		public function destroy() : void {
			this._mouseSprite.removeEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOver);
			this._mouseSprite.removeEventListener(MouseEvent.ROLL_OUT,this.onMouseRollOut);
			this._mouseSprite.graphics.clear();
			removeChild(this._mouseSprite);
			this._mouseSprite = null;
			removeChild(this._textField);
			this._textField = null;
			this._data = null;
		}
	}
}
