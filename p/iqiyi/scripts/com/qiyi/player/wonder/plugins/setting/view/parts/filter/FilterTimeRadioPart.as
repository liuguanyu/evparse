package com.qiyi.player.wonder.plugins.setting.view.parts.filter
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import com.qiyi.player.wonder.plugins.setting.view.SettingEvent;
	import com.qiyi.player.wonder.common.ui.FastCreator;
	import flash.text.TextFieldAutoSize;
	
	public class FilterTimeRadioPart extends Sprite
	{
		
		private static const STR_TIME:String = "分钟";
		
		private static const STR_TIME_DESCRIBE:String = "不同时长:";
		
		private var _tfDescribe:TextField;
		
		private var _radioListItemVec:Vector.<FilterRadioItem>;
		
		private var _timeList:Array;
		
		private var _curTimeIndex:uint = 0;
		
		public function FilterTimeRadioPart()
		{
			super();
			this._radioListItemVec = new Vector.<FilterRadioItem>();
			this._tfDescribe = FastCreator.createLabel(STR_TIME_DESCRIBE,16777215,14,TextFieldAutoSize.LEFT);
			addChild(this._tfDescribe);
		}
		
		public function setTimeAttribute(param1:uint, param2:Array) : void
		{
			var _loc3:FilterRadioItem = null;
			var _loc4:uint = 0;
			this._timeList = param2;
			this._curTimeIndex = param1;
			this.destroy();
			_loc4 = 0;
			while(_loc4 < this._timeList.length)
			{
				_loc3 = new FilterRadioItem();
				_loc3.setTitle(uint(this._timeList[_loc4] / 60 / 1000) + STR_TIME);
				_loc3.index = _loc4;
				_loc3.x = 90 * _loc4 + this._tfDescribe.width + 20;
				if(_loc4 == this._curTimeIndex)
				{
					_loc3.isSelected = true;
				}
				else
				{
					_loc3.isSelected = false;
				}
				addChild(_loc3);
				this._radioListItemVec.push(_loc3);
				_loc3.addEventListener(MouseEvent.CLICK,this.onFilterTimeRadioItemClick);
				_loc4++;
			}
		}
		
		private function onFilterTimeRadioItemClick(param1:MouseEvent) : void
		{
			var _loc3:FilterRadioItem = null;
			var _loc2:FilterRadioItem = param1.target as FilterRadioItem;
			if((_loc2) && !(this._curTimeIndex == _loc2.index))
			{
				this._curTimeIndex = _loc2.index;
				dispatchEvent(new SettingEvent(SettingEvent.Evt_FilterTimeRadioClick,this._curTimeIndex));
				for each(_loc3 in this._radioListItemVec)
				{
					if(_loc3.index == this._curTimeIndex)
					{
						_loc3.isSelected = true;
					}
					else
					{
						_loc3.isSelected = false;
					}
				}
			}
		}
		
		public function destroy() : void
		{
			var _loc1:FilterRadioItem = null;
			while((this._radioListItemVec) && this._radioListItemVec.length > 0)
			{
				_loc1 = this._radioListItemVec.pop();
				if(_loc1.parent)
				{
					_loc1.parent.removeChild(_loc1);
				}
				_loc1.destroy();
				_loc1 = null;
			}
		}
	}
}
