package com.qiyi.player.wonder.plugins.setting.view.parts.filter
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import com.qiyi.player.base.pub.EnumItem;
	import flash.events.MouseEvent;
	import com.qiyi.player.wonder.plugins.setting.view.SettingEvent;
	import com.qiyi.player.core.model.def.SkipPointEnum;
	import com.qiyi.player.wonder.common.ui.FastCreator;
	import flash.text.TextFieldAutoSize;
	
	public class FilterSexRadioPart extends Sprite
	{
		
		private static const STR_SEX_SELECTED:Array = ["大众版","男生版","女生版"];
		
		private static const STR_SEX_DESCRIBE:String = "不同性别:";
		
		private var _tfDescribe:TextField;
		
		private var _radioListItemVec:Vector.<FilterRadioItem>;
		
		private var _sexList:Vector.<EnumItem>;
		
		private var _curSelectedSex:EnumItem;
		
		public function FilterSexRadioPart()
		{
			super();
			this._radioListItemVec = new Vector.<FilterRadioItem>();
			this._tfDescribe = FastCreator.createLabel(STR_SEX_DESCRIBE,16777215,14,TextFieldAutoSize.LEFT);
			addChild(this._tfDescribe);
		}
		
		public function setSexAttribute(param1:EnumItem, param2:Vector.<EnumItem>) : void
		{
			var _loc3:FilterRadioItem = null;
			var _loc4:uint = 0;
			this._sexList = param2;
			this._curSelectedSex = param1;
			this.destroy();
			_loc4 = 0;
			while(_loc4 < this._sexList.length)
			{
				_loc3 = new FilterRadioItem();
				_loc3.setTitle(this.getTitleByEnumItem(this._sexList[_loc4]));
				_loc3.index = _loc4;
				_loc3.x = 90 * _loc4 + this._tfDescribe.width + 20;
				if(this._sexList[_loc4] == this._curSelectedSex)
				{
					_loc3.isSelected = true;
				}
				else
				{
					_loc3.isSelected = false;
				}
				addChild(_loc3);
				this._radioListItemVec.push(_loc3);
				_loc3.addEventListener(MouseEvent.CLICK,this.onFilterSexRadioItemClick);
				_loc4++;
			}
		}
		
		private function onFilterSexRadioItemClick(param1:MouseEvent) : void
		{
			var _loc3:FilterRadioItem = null;
			var _loc2:FilterRadioItem = param1.target as FilterRadioItem;
			if((_loc2) && !(this._curSelectedSex == this._sexList[_loc2.index]))
			{
				this._curSelectedSex = this._sexList[_loc2.index];
				dispatchEvent(new SettingEvent(SettingEvent.Evt_FilterSexRadioClick,this._curSelectedSex));
				for each(_loc3 in this._radioListItemVec)
				{
					if(this._sexList[_loc3.index] == this._curSelectedSex)
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
		
		private function getTitleByEnumItem(param1:EnumItem) : String
		{
			var _loc2:* = "";
			switch(param1)
			{
				case SkipPointEnum.ENJOYABLE_SUB_COMMON:
					_loc2 = STR_SEX_SELECTED[0];
					break;
				case SkipPointEnum.ENJOYABLE_SUB_MALE:
					_loc2 = STR_SEX_SELECTED[1];
					break;
				case SkipPointEnum.ENJOYABLE_SUB_FEMALE:
					_loc2 = STR_SEX_SELECTED[2];
					break;
			}
			return _loc2;
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
