package com.qiyi.player.wonder.plugins.setting.view.parts.filter {
	import flash.display.Sprite;
	import flash.text.TextField;
	import com.qiyi.player.wonder.common.ui.FastCreator;
	import flash.text.TextFieldAutoSize;
	
	public class FilterRadioItem extends Sprite {
		
		public function FilterRadioItem() {
			super();
			this.useHandCursor = this.buttonMode = true;
			this.init();
		}
		
		private var _title:TextField;
		
		private var _sprTitle:String = "";
		
		private var _index:uint = 0;
		
		private var _isSelected:Boolean = false;
		
		public function get index() : uint {
			return this._index;
		}
		
		public function set index(param1:uint) : void {
			this._index = param1;
		}
		
		public function get isSelected() : Boolean {
			return this._isSelected;
		}
		
		public function set isSelected(param1:Boolean) : void {
			this._isSelected = param1;
			graphics.clear();
			if(param1) {
				graphics.beginFill(8040500,0.8);
				graphics.drawRoundRect(0,0,60,26,3);
				graphics.endFill();
			}
		}
		
		private function init() : void {
			this._title = FastCreator.createLabel(this._sprTitle,16777215,14,TextFieldAutoSize.LEFT);
			this._title.mouseEnabled = this._title.selectable = false;
			addChild(this._title);
		}
		
		public function setTitle(param1:String) : void {
			this._sprTitle = param1;
			this._title.text = this._sprTitle;
			this._title.x = (60 - this._title.width) * 0.5;
		}
		
		public function destroy() : void {
			if(this._title) {
				if(this._title.parent) {
					this._title.parent.removeChild(this._title);
				}
				this._title = null;
			}
		}
	}
}
