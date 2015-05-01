package com.iqiyi.components.tooltip {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class DefaultToolTip extends Sprite implements IDefaultToolTip {
		
		public function DefaultToolTip() {
			super();
			this._bg = new DefaultBg();
			addChild(this._bg);
			this._textField = new TextField();
			this._textField.x = this.GAP;
			this._textField.y = this.GAP;
			this._textField.type = TextFieldType.DYNAMIC;
			this._textField.multiline = true;
			this._textField.wordWrap = false;
			this._textField.selectable = false;
			this._textField.autoSize = TextFieldAutoSize.LEFT;
			this._textField.mouseEnabled = false;
			var _loc1_:TextFormat = new TextFormat();
			_loc1_.size = 12;
			_loc1_.color = 16777215;
			_loc1_.align = TextFormatAlign.LEFT;
			_loc1_.leading = 0;
			_loc1_.font = "微软雅黑";
			this._textField.defaultTextFormat = _loc1_;
			addChild(this._textField);
		}
		
		private const GAP:int = 3;
		
		private var _bg:DefaultBg;
		
		private var _textField:TextField;
		
		public function set text(param1:String) : void {
			this._textField.text = param1;
			this.update();
		}
		
		public function set htmlText(param1:String) : void {
			this._textField.htmlText = param1;
			this.update();
		}
		
		private function update() : void {
			this._bg.width = this._textField.width + 2 * this.GAP;
			this._bg.height = this._textField.height + 2 * this.GAP;
		}
	}
}
