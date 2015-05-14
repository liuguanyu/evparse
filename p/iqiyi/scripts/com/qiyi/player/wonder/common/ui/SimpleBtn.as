package com.qiyi.player.wonder.common.ui
{
	import flash.display.Sprite;
	import common.CommonBtn;
	import flash.text.TextField;
	
	public class SimpleBtn extends Sprite
	{
		
		private static const GAP:uint = 8;
		
		private var _commonBtn:CommonBtn;
		
		private var _tfTitle:TextField;
		
		private var _width:uint = 0;
		
		private var _heigth:uint = 0;
		
		public function SimpleBtn(param1:String = "确定", param2:uint = 84, param3:uint = 22, param4:uint = 16777215, param5:int = 12, param6:String = "", param7:Boolean = false, param8:String = "微软雅黑", param9:Array = null)
		{
			this._tfTitle = FastCreator.createLabel(param1,param4,param5,param6,param7,param8,param9);
			this._tfTitle.mouseEnabled = this._tfTitle.selectable = false;
			this._commonBtn = new CommonBtn();
			addChild(this._commonBtn);
			addChild(this._tfTitle);
			this._width = param2;
			this._heigth = param3;
			this.setTitle(param1,this._width,this._heigth);
			super();
		}
		
		public function setTitle(param1:String, param2:uint = 0, param3:uint = 0) : void
		{
			this._tfTitle.htmlText = param1;
			this._width = param2 == 0?this._width:param2;
			this._heigth = param3 == 0?this._heigth:param3;
			this._commonBtn.width = this._width == 0?this._tfTitle.textWidth + GAP:param2;
			this._commonBtn.height = this._heigth == 0?this._tfTitle.textHeight + GAP:param3;
			this._tfTitle.x = (this._commonBtn.width - this._tfTitle.width) / 2;
			this._tfTitle.y = (this._commonBtn.height - this._tfTitle.height) / 2;
		}
	}
}
