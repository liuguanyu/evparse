package com.qiyi.player.wonder.plugins.controllbar.view.controllbar
{
	import flash.display.Sprite;
	import controllbar.ControlBarBtnNormal;
	import controllbar.ControlBarBtnHover;
	import controllbar.ControlBarBtnSelectedNormal;
	import controllbar.ControlBarBtnSelectedHover;
	import flash.text.TextField;
	import com.qiyi.player.wonder.plugins.controllbar.ControllBarDef;
	import com.qiyi.player.wonder.body.BodyDef;
	import flash.events.MouseEvent;
	import com.qiyi.player.wonder.common.ui.FastCreator;
	import flash.text.TextFieldAutoSize;
	
	public class ControllBarButton extends Sprite
	{
		
		private var _normalBtnBg:ControlBarBtnNormal;
		
		private var _hoverBtnBg:ControlBarBtnHover;
		
		private var _selectedNormalBtnBg:ControlBarBtnSelectedNormal;
		
		private var _selectedHoverBtnBg:ControlBarBtnSelectedHover;
		
		private var _textField:TextField;
		
		private var _text:String = "";
		
		private var _isSelected:Boolean = false;
		
		public function ControllBarButton(param1:String)
		{
			super();
			this._text = param1;
			this._normalBtnBg = new ControlBarBtnNormal();
			addChild(this._normalBtnBg);
			this._hoverBtnBg = new ControlBarBtnHover();
			this._hoverBtnBg.visible = false;
			addChild(this._hoverBtnBg);
			this._selectedNormalBtnBg = new ControlBarBtnSelectedNormal();
			this._selectedNormalBtnBg.visible = false;
			addChild(this._selectedNormalBtnBg);
			this._selectedHoverBtnBg = new ControlBarBtnSelectedHover();
			this._selectedHoverBtnBg.visible = false;
			addChild(this._selectedHoverBtnBg);
			this._normalBtnBg.mouseChildren = this._normalBtnBg.mouseEnabled = this._selectedNormalBtnBg.mouseChildren = this._selectedNormalBtnBg.mouseEnabled = this._selectedHoverBtnBg.mouseChildren = this._selectedHoverBtnBg.mouseEnabled = this._hoverBtnBg.mouseChildren = this._hoverBtnBg.mouseEnabled = false;
			this.useHandCursor = this.buttonMode = true;
			this._textField = FastCreator.createLabel(param1,10066329,12,TextFieldAutoSize.LEFT);
			this._textField.x = 0;
			addChild(this._textField);
			this._textField.mouseEnabled = false;
			addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
			this.updateLayout();
		}
		
		public function get text() : String
		{
			return this._text;
		}
		
		public function get isSelected() : Boolean
		{
			return this._isSelected;
		}
		
		public function set isSelected(param1:Boolean) : void
		{
			this._isSelected = param1;
			if(this._isSelected)
			{
				this._selectedHoverBtnBg.visible = false;
				this._selectedNormalBtnBg.visible = true;
				this._hoverBtnBg.visible = false;
				this._normalBtnBg.visible = false;
				this._textField.defaultTextFormat = ControllBarDef.SELECTED_FONT_COLOR;
			}
			else
			{
				this._selectedHoverBtnBg.visible = false;
				this._selectedNormalBtnBg.visible = false;
				this._hoverBtnBg.visible = false;
				this._normalBtnBg.visible = true;
				this._textField.defaultTextFormat = ControllBarDef.DEFAULT_FONT_COLOR;
			}
			this._textField.text = this._text;
		}
		
		public function updateBtnText(param1:String) : void
		{
			this._text = param1;
			this._textField.text = this._text;
			this.updateLayout();
		}
		
		private function updateLayout() : void
		{
			this._selectedHoverBtnBg.width = this._selectedNormalBtnBg.width = this._hoverBtnBg.width = this._normalBtnBg.width = this._textField.textWidth + ControllBarDef.GAP_BG_TEXT * 2;
			this._selectedHoverBtnBg.y = this._selectedNormalBtnBg.y = this._hoverBtnBg.y = this._normalBtnBg.y = (BodyDef.VIDEO_BOTTOM_RESERVE - this._hoverBtnBg.height) / 2;
			this._selectedHoverBtnBg.x = this._selectedNormalBtnBg.x = this._hoverBtnBg.x = this._normalBtnBg.x = ControllBarDef.GAP_BG_MOUSE;
			this._textField.y = (BodyDef.VIDEO_BOTTOM_RESERVE - this._textField.height) / 2;
			this._textField.x = ControllBarDef.GAP_BG_MOUSE + ControllBarDef.GAP_BG_TEXT - 2;
			this.graphics.clear();
			this.graphics.beginFill(16777215,0);
			this.graphics.drawRect(0,0,this._hoverBtnBg.width + ControllBarDef.GAP_BG_MOUSE * 2,BodyDef.VIDEO_BOTTOM_RESERVE);
			this.graphics.endFill();
		}
		
		private function onMouseOver(param1:MouseEvent) : void
		{
			if(this._isSelected)
			{
				this._selectedHoverBtnBg.visible = true;
				this._selectedNormalBtnBg.visible = false;
				this._hoverBtnBg.visible = false;
				this._normalBtnBg.visible = false;
				this._textField.defaultTextFormat = ControllBarDef.SELECTED_FONT_COLOR;
			}
			else
			{
				this._selectedHoverBtnBg.visible = false;
				this._selectedNormalBtnBg.visible = false;
				this._hoverBtnBg.visible = true;
				this._normalBtnBg.visible = false;
				this._textField.defaultTextFormat = ControllBarDef.HOVER_FONT_COLOR;
			}
			this._textField.text = this._text;
		}
		
		private function onMouseOut(param1:MouseEvent) : void
		{
			if(this._isSelected)
			{
				this._selectedHoverBtnBg.visible = false;
				this._selectedNormalBtnBg.visible = true;
				this._hoverBtnBg.visible = false;
				this._normalBtnBg.visible = false;
				this._textField.defaultTextFormat = ControllBarDef.SELECTED_FONT_COLOR;
			}
			else
			{
				this._selectedHoverBtnBg.visible = false;
				this._selectedNormalBtnBg.visible = false;
				this._hoverBtnBg.visible = false;
				this._normalBtnBg.visible = true;
				this._textField.defaultTextFormat = ControllBarDef.DEFAULT_FONT_COLOR;
			}
			this._textField.text = this._text;
		}
	}
}
