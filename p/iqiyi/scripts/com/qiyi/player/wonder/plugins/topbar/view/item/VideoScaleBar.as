package com.qiyi.player.wonder.plugins.topbar.view.item
{
	import flash.display.Sprite;
	import com.qiyi.player.wonder.plugins.topbar.TopBarDef;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import com.qiyi.player.wonder.plugins.topbar.view.TopBarEvent;
	
	public class VideoScaleBar extends Sprite
	{
		
		private static const SCALE_ARR:Array = ["50%","75%","100%","满屏"];
		
		private static const SCALE_TYPE_ARR:Array = [TopBarDef.SCALE_VALUE_50,TopBarDef.SCALE_VALUE_75,TopBarDef.SCALE_VALUE_100,TopBarDef.SCALE_VALUE_FULL];
		
		private var _vsiVector:Vector.<VideoScaleItem>;
		
		private var _bgShape:Shape;
		
		public function VideoScaleBar()
		{
			var _loc1:VideoScaleItem = null;
			super();
			this._bgShape = new Shape();
			addChild(this._bgShape);
			this._vsiVector = new Vector.<VideoScaleItem>();
			var _loc2:uint = 0;
			while(_loc2 < SCALE_ARR.length)
			{
				_loc1 = new VideoScaleItem(SCALE_ARR[_loc2],SCALE_TYPE_ARR[_loc2]);
				this._vsiVector.push(_loc1);
				_loc1.x = _loc2 * (_loc1.width + 5);
				addChild(_loc1);
				_loc1.addEventListener(MouseEvent.CLICK,this.onItemClick);
				_loc2++;
			}
		}
		
		private function onItemClick(param1:MouseEvent) : void
		{
			var _loc3:VideoScaleItem = null;
			var _loc2:VideoScaleItem = param1.target as VideoScaleItem;
			if(_loc2)
			{
				for each(_loc3 in this._vsiVector)
				{
					_loc3.isSelected = false;
				}
				dispatchEvent(new TopBarEvent(TopBarEvent.Evt_ScaleClick,_loc2.type));
			}
		}
		
		public function setVideoScale(param1:uint) : void
		{
			var _loc2:VideoScaleItem = null;
			for each(_loc2 in this._vsiVector)
			{
				if(param1 == _loc2.type)
				{
					_loc2.isSelected = true;
					this._bgShape.graphics.clear();
					this._bgShape.graphics.beginFill(5865493);
					this._bgShape.graphics.drawRoundRect(_loc2.x,_loc2.y,_loc2.width,_loc2.height,5);
					this._bgShape.graphics.endFill();
				}
			}
		}
	}
}
