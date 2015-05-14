package com.qiyi.player.wonder.plugins.topbar.view.item
{
	import flash.display.Sprite;
	import flash.text.TextFormat;
	import com.qiyi.player.wonder.common.ui.FastCreator;
	import flash.text.TextField;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import topbar.TopBarScaleSizeFull;
	import topbar.TopBarScaleSize100;
	import topbar.TopBarScaleSize75;
	import topbar.TopBarScaleSize50;
	import com.qiyi.player.wonder.plugins.topbar.TopBarDef;
	
	public class VideoScaleItem extends Sprite
	{
		
		private static const FORMAT_SELECTED:TextFormat = FastCreator.createTextFormat(null,14,16777215);
		
		private static const FORMAT_OVER:TextFormat = FastCreator.createTextFormat(null,14,7841296);
		
		private static const FORMAT_OUT:TextFormat = FastCreator.createTextFormat(null,14,13421772);
		
		private var _textField:TextField;
		
		private var _mcIcon:MovieClip;
		
		private var _isSelected:Boolean = false;
		
		private var _textContent:String;
		
		private var _type:uint = 0;
		
		public function VideoScaleItem(param1:String, param2:uint)
		{
			super();
			this._textContent = param1;
			this._type = param2;
			this.graphics.clear();
			this.graphics.beginFill(16711680,0);
			this.graphics.drawRect(0,0,80,30);
			this.graphics.endFill();
			this.useHandCursor = this.buttonMode = true;
			this._mcIcon = this.getMovieClipByType(this._type);
			if(this._mcIcon)
			{
				this._mcIcon.mouseChildren = this._mcIcon.mouseEnabled = false;
				this._mcIcon.gotoAndStop("outFrame");
				addChild(this._mcIcon);
			}
			addChild(this._mcIcon);
			this._textField = FastCreator.createLabel(param1,13421772,14);
			this._mcIcon.x = (this.width - this._mcIcon.width - this._textField.width) * 0.5 + 2;
			this._mcIcon.y = (this.height - this._mcIcon.height) * 0.5 + 4;
			this._textField.x = this._mcIcon.x + this._mcIcon.width;
			this._textField.y = (this.height - this._textField.height) * 0.5;
			this._textField.mouseEnabled = false;
			addChild(this._textField);
			this.addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
			this.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
		}
		
		public function get type() : uint
		{
			return this._type;
		}
		
		private function onRollOver(param1:MouseEvent) : void
		{
			if(this._isSelected)
			{
				if(this._mcIcon)
				{
					this._mcIcon.gotoAndStop("curFrame");
				}
				this._textField.defaultTextFormat = FORMAT_SELECTED;
			}
			else
			{
				if(this._mcIcon)
				{
					this._mcIcon.gotoAndStop("overFrame");
				}
				this._textField.defaultTextFormat = FORMAT_OVER;
			}
			this._textField.text = this._textContent;
		}
		
		private function onRollOut(param1:MouseEvent) : void
		{
			if(this._isSelected)
			{
				if(this._mcIcon)
				{
					this._mcIcon.gotoAndStop("curFrame");
				}
				this._textField.defaultTextFormat = FORMAT_SELECTED;
			}
			else
			{
				if(this._mcIcon)
				{
					this._mcIcon.gotoAndStop("outFrame");
				}
				this._textField.defaultTextFormat = FORMAT_OUT;
			}
			this._textField.text = this._textContent;
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
				if(this._mcIcon)
				{
					this._mcIcon.gotoAndStop("curFrame");
				}
				this._textField.defaultTextFormat = FORMAT_SELECTED;
			}
			else
			{
				if(this._mcIcon)
				{
					this._mcIcon.gotoAndStop("outFrame");
				}
				this._textField.defaultTextFormat = FORMAT_OUT;
			}
			this._textField.text = this._textContent;
		}
		
		private function getMovieClipByType(param1:uint) : MovieClip
		{
			var _loc2:MovieClip = null;
			switch(param1)
			{
				case TopBarDef.SCALE_VALUE_FULL:
					_loc2 = new TopBarScaleSizeFull();
					break;
				case TopBarDef.SCALE_VALUE_100:
					_loc2 = new TopBarScaleSize100();
					break;
				case TopBarDef.SCALE_VALUE_75:
					_loc2 = new TopBarScaleSize75();
					break;
				case TopBarDef.SCALE_VALUE_50:
					_loc2 = new TopBarScaleSize50();
					break;
				default:
					_loc2 = new TopBarScaleSize100();
			}
			return _loc2;
		}
	}
}
