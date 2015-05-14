package com.qiyi.player.wonder.plugins.feedback.view.parts.maliceerror
{
	import flash.display.Sprite;
	import com.qiyi.player.wonder.IDestroy;
	import flash.text.TextField;
	import flash.display.DisplayObject;
	import com.qiyi.player.wonder.common.ui.FastCreator;
	import com.iqiyi.components.global.GlobalStage;
	
	public class MaliceError extends Sprite implements IDestroy
	{
		
		private static const TF_ERROR_TEXT:String = "您的电脑可能存在恶意的插件导致视频无法播放，请检查并卸载！";
		
		private var _errorText:TextField;
		
		public function MaliceError()
		{
			super();
			this._errorText = FastCreator.createLabel(TF_ERROR_TEXT,16777215,16);
			addChild(this._errorText);
			this.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
		}
		
		public function onResize(param1:int, param2:int) : void
		{
			graphics.clear();
			graphics.beginFill(0);
			graphics.drawRect(0,0,param1,param2);
			graphics.endFill();
			this._errorText.x = (param1 - this._errorText.width) / 2;
			this._errorText.y = (param2 - this._errorText.height) / 2;
		}
		
		public function destroy() : void
		{
			var _loc1:DisplayObject = null;
			while(numChildren > 0)
			{
				_loc1 = getChildAt(0);
				if(_loc1.parent)
				{
					removeChild(_loc1);
				}
				_loc1 = null;
			}
		}
	}
}
