package com.qiyi.player.wonder.plugins.setting.view.parts.filter {
	import flash.display.Sprite;
	import flash.text.TextField;
	import com.qiyi.player.base.pub.EnumItem;
	import flash.events.MouseEvent;
	import com.qiyi.player.wonder.plugins.setting.view.SettingEvent;
	import com.qiyi.player.core.model.def.SkipPointEnum;
	import com.qiyi.player.wonder.common.ui.FastCreator;
	import flash.text.TextFieldAutoSize;
	
	public class FilterSexRadioPart extends Sprite {
		
		public function FilterSexRadioPart() {
			super();
			this._radioListItemVec = new Vector.<FilterRadioItem>();
			this._tfDescribe = FastCreator.createLabel(STR_SEX_DESCRIBE,16777215,14,TextFieldAutoSize.LEFT);
			addChild(this._tfDescribe);
		}
		
		private static const STR_SEX_SELECTED:Array = ["大众版","男生版","女生版"];
		
		private static const STR_SEX_DESCRIBE:String = "不同性别:";
		
		private var _tfDescribe:TextField;
		
		private var _radioListItemVec:Vector.<FilterRadioItem>;
		
		private var _sexList:Vector.<EnumItem>;
		
		private var _curSelectedSex:EnumItem;
		
		public function setSexAttribute(param1:EnumItem, param2:Vector.<EnumItem>) : void {
			var _loc3_:FilterRadioItem = null;
			var _loc4_:uint = 0;
			this._sexList = param2;
			this._curSelectedSex = param1;
			this.destroy();
			_loc4_ = 0;
			while(_loc4_ < this._sexList.length) {
				_loc3_ = new FilterRadioItem();
				_loc3_.setTitle(this.getTitleByEnumItem(this._sexList[_loc4_]));
				_loc3_.index = _loc4_;
				_loc3_.x = 90 * _loc4_ + this._tfDescribe.width + 20;
				if(this._sexList[_loc4_] == this._curSelectedSex) {
					_loc3_.isSelected = true;
				} else {
					_loc3_.isSelected = false;
				}
				addChild(_loc3_);
				this._radioListItemVec.push(_loc3_);
				_loc3_.addEventListener(MouseEvent.CLICK,this.onFilterSexRadioItemClick);
				_loc4_++;
			}
		}
		
		private function onFilterSexRadioItemClick(param1:MouseEvent) : void {
			var _loc3_:FilterRadioItem = null;
			var _loc2_:FilterRadioItem = param1.target as FilterRadioItem;
			if((_loc2_) && !(this._curSelectedSex == this._sexList[_loc2_.index])) {
				this._curSelectedSex = this._sexList[_loc2_.index];
				dispatchEvent(new SettingEvent(SettingEvent.Evt_FilterSexRadioClick,this._curSelectedSex));
				for each(_loc3_ in this._radioListItemVec) {
					if(this._sexList[_loc3_.index] == this._curSelectedSex) {
						_loc3_.isSelected = true;
					} else {
						_loc3_.isSelected = false;
					}
				}
			}
		}
		
		private function getTitleByEnumItem(param1:EnumItem) : String {
			var _loc2_:* = "";
			switch(param1) {
				case SkipPointEnum.ENJOYABLE_SUB_COMMON:
					_loc2_ = STR_SEX_SELECTED[0];
					break;
				case SkipPointEnum.ENJOYABLE_SUB_MALE:
					_loc2_ = STR_SEX_SELECTED[1];
					break;
				case SkipPointEnum.ENJOYABLE_SUB_FEMALE:
					_loc2_ = STR_SEX_SELECTED[2];
					break;
			}
			return _loc2_;
		}
		
		public function destroy() : void {
			var _loc1_:FilterRadioItem = null;
			while((this._radioListItemVec) && this._radioListItemVec.length > 0) {
				_loc1_ = this._radioListItemVec.pop();
				if(_loc1_.parent) {
					_loc1_.parent.removeChild(_loc1_);
				}
				_loc1_.destroy();
				_loc1_ = null;
			}
		}
	}
}
