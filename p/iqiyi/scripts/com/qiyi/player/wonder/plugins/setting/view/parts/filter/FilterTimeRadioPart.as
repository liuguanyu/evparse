package com.qiyi.player.wonder.plugins.setting.view.parts.filter {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import com.qiyi.player.wonder.plugins.setting.view.SettingEvent;
	import com.qiyi.player.wonder.common.ui.FastCreator;
	import flash.text.TextFieldAutoSize;
	
	public class FilterTimeRadioPart extends Sprite {
		
		public function FilterTimeRadioPart() {
			super();
			this._radioListItemVec = new Vector.<FilterRadioItem>();
			this._tfDescribe = FastCreator.createLabel(STR_TIME_DESCRIBE,16777215,14,TextFieldAutoSize.LEFT);
			addChild(this._tfDescribe);
		}
		
		private static const STR_TIME:String = "分钟";
		
		private static const STR_TIME_DESCRIBE:String = "不同时长:";
		
		private var _tfDescribe:TextField;
		
		private var _radioListItemVec:Vector.<FilterRadioItem>;
		
		private var _timeList:Array;
		
		private var _curTimeIndex:uint = 0;
		
		public function setTimeAttribute(param1:uint, param2:Array) : void {
			var _loc3_:FilterRadioItem = null;
			var _loc4_:uint = 0;
			this._timeList = param2;
			this._curTimeIndex = param1;
			this.destroy();
			_loc4_ = 0;
			while(_loc4_ < this._timeList.length) {
				_loc3_ = new FilterRadioItem();
				_loc3_.setTitle(uint(this._timeList[_loc4_] / 60 / 1000) + STR_TIME);
				_loc3_.index = _loc4_;
				_loc3_.x = 90 * _loc4_ + this._tfDescribe.width + 20;
				if(_loc4_ == this._curTimeIndex) {
					_loc3_.isSelected = true;
				} else {
					_loc3_.isSelected = false;
				}
				addChild(_loc3_);
				this._radioListItemVec.push(_loc3_);
				_loc3_.addEventListener(MouseEvent.CLICK,this.onFilterTimeRadioItemClick);
				_loc4_++;
			}
		}
		
		private function onFilterTimeRadioItemClick(param1:MouseEvent) : void {
			var _loc3_:FilterRadioItem = null;
			var _loc2_:FilterRadioItem = param1.target as FilterRadioItem;
			if((_loc2_) && !(this._curTimeIndex == _loc2_.index)) {
				this._curTimeIndex = _loc2_.index;
				dispatchEvent(new SettingEvent(SettingEvent.Evt_FilterTimeRadioClick,this._curTimeIndex));
				for each(_loc3_ in this._radioListItemVec) {
					if(_loc3_.index == this._curTimeIndex) {
						_loc3_.isSelected = true;
					} else {
						_loc3_.isSelected = false;
					}
				}
			}
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
