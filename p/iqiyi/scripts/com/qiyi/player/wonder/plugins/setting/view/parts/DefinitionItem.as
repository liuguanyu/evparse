package com.qiyi.player.wonder.plugins.setting.view.parts
{
	import flash.display.Sprite;
	import com.qiyi.player.base.pub.EnumItem;
	import flash.text.TextField;
	import flash.display.Shape;
	import com.qiyi.player.wonder.common.ui.FastCreator;
	import com.qiyi.player.wonder.plugins.setting.SettingDef;
	import flash.events.MouseEvent;
	import com.qiyi.player.wonder.common.utils.ChineseNameOfLangAudioDef;
	import flash.text.TextFieldAutoSize;
	import setting.StreamLimitIcon;
	
	public class DefinitionItem extends Sprite
	{
		
		private static const FONT_SIZE:uint = 13;
		
		private var _data:EnumItem;
		
		private var _textField:TextField;
		
		private var _mouseArea:Shape;
		
		private var _isSelected:Boolean = false;
		
		private var _isVid:Boolean = false;
		
		private var _streamLimitIcon:Sprite;
		
		public function DefinitionItem(param1:EnumItem, param2:Boolean)
		{
			super();
			this._data = param1;
			this._textField = FastCreator.createLabel("",13421772,FONT_SIZE,TextFieldAutoSize.LEFT);
			this._textField.htmlText = this.getTextByEnumItem();
			this._textField.mouseEnabled = this._textField.selectable = false;
			addChild(this._textField);
			if(!this._streamLimitIcon && (param2))
			{
				this._streamLimitIcon = new StreamLimitIcon();
				this._streamLimitIcon.mouseChildren = this._streamLimitIcon.mouseEnabled = false;
				addChild(this._streamLimitIcon);
			}
			this._mouseArea = new Shape();
			this._mouseArea.graphics.beginFill(0);
			this._mouseArea.graphics.drawRect(0,0,SettingDef.DEFINITION_PANEL_WIDTH,SettingDef.DEFINITION_PANEL_ITEM_HEIGHT);
			this._mouseArea.graphics.endFill();
			this._mouseArea.alpha = 0;
			addChild(this._mouseArea);
			if(this._streamLimitIcon)
			{
				this._streamLimitIcon.x = (this.width - this._streamLimitIcon.width - this._textField.width) * 0.5;
				this._streamLimitIcon.y = (this.height - this._streamLimitIcon.height) * 0.5 - 2;
				this._textField.x = this._streamLimitIcon.x + this._streamLimitIcon.width;
				this._textField.y = (this.height - this._textField.height) * 0.5;
			}
			else
			{
				this._textField.x = (this.width - this._textField.width) * 0.5;
				this._textField.y = (this.height - this._textField.height) * 0.5;
			}
			addEventListener(MouseEvent.ROLL_OVER,this.onItemRollOver);
			addEventListener(MouseEvent.ROLL_OUT,this.onItemRollOut);
		}
		
		public function get isVid() : Boolean
		{
			return this._isVid;
		}
		
		public function set isVid(param1:Boolean) : void
		{
			this._isVid = param1;
			if(param1)
			{
				this._textField.defaultTextFormat = FastCreator.createTextFormat(FastCreator.FONT_MSYH,FONT_SIZE,this._isSelected?16777215:SettingDef.DEFINITION_COLOR);
				this._textField.htmlText = this.getTextByEnumItem();
			}
			else
			{
				this._textField.defaultTextFormat = FastCreator.createTextFormat(FastCreator.FONT_MSYH,FONT_SIZE,13421772);
				this._textField.htmlText = this.getTextByEnumItem();
			}
		}
		
		public function get isSelected() : Boolean
		{
			return this._isSelected;
		}
		
		public function set isSelected(param1:Boolean) : void
		{
			this._isSelected = param1;
			if(param1)
			{
				this._textField.defaultTextFormat = FastCreator.createTextFormat(FastCreator.FONT_MSYH,FONT_SIZE,16777215);
				this._textField.htmlText = this.getTextByEnumItem();
				graphics.clear();
				graphics.beginFill(SettingDef.DEFINITION_COLOR);
				graphics.drawRoundRect(0,0,SettingDef.DEFINITION_PANEL_WIDTH,SettingDef.DEFINITION_PANEL_ITEM_HEIGHT,SettingDef.DEFINITION_PANEL_RADIUS);
				graphics.endFill();
			}
			else
			{
				this._textField.defaultTextFormat = FastCreator.createTextFormat(FastCreator.FONT_MSYH,FONT_SIZE,13421772);
				this._textField.htmlText = this.getTextByEnumItem();
				graphics.clear();
			}
		}
		
		public function get data() : EnumItem
		{
			return this._data;
		}
		
		private function onItemRollOver(param1:MouseEvent) : void
		{
			if(!this._isSelected)
			{
				graphics.clear();
				graphics.lineStyle(1,SettingDef.DEFINITION_COLOR,0.3);
				graphics.drawRoundRect(1,0,SettingDef.DEFINITION_PANEL_WIDTH - 2,SettingDef.DEFINITION_PANEL_ITEM_HEIGHT,SettingDef.DEFINITION_PANEL_RADIUS);
				graphics.endFill();
			}
		}
		
		private function onItemRollOut(param1:MouseEvent) : void
		{
			if(!this._isSelected)
			{
				graphics.clear();
			}
		}
		
		private function getTextByEnumItem() : String
		{
			var _loc1:String = ChineseNameOfLangAudioDef.getDefinitionName(this._data);
			return _loc1 == ""?"自动":_loc1;
		}
		
		public function destroy() : void
		{
			if((this._streamLimitIcon) && (this._streamLimitIcon.parent))
			{
				removeChild(this._streamLimitIcon);
				this._streamLimitIcon = null;
			}
			this.graphics.clear();
			removeEventListener(MouseEvent.ROLL_OVER,this.onItemRollOver);
			removeEventListener(MouseEvent.ROLL_OUT,this.onItemRollOut);
			removeChild(this._textField);
			this._textField = null;
		}
	}
}
