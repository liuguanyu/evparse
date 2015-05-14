package com.qiyi.player.wonder.plugins.controllbar.view.controllbar
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import com.qiyi.player.wonder.common.ui.FastCreator;
	import flash.text.TextFieldAutoSize;
	
	public class ControllBarDispalyTime extends Sprite
	{
		
		private var _curTimeTF:TextField;
		
		private var _totalTimeTF:TextField;
		
		public function ControllBarDispalyTime()
		{
			super();
			this._curTimeTF = FastCreator.createLabel("00:00:00",10066329,12,TextFieldAutoSize.LEFT,false,"Verdana");
			this._totalTimeTF = FastCreator.createLabel(" / 00:00:00",6710886,12,TextFieldAutoSize.LEFT,false,"Verdana");
			addChild(this._curTimeTF);
			addChild(this._totalTimeTF);
		}
		
		public function updateTime(param1:String, param2:String) : void
		{
			this._curTimeTF.text = param1.toString();
			this._totalTimeTF.text = " / " + param2;
			this._totalTimeTF.x = this._curTimeTF.x + this._curTimeTF.textWidth;
		}
	}
}
