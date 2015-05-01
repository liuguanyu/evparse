package com.qiyi.player.wonder.plugins.topbar.view.item {
	import flash.display.Sprite;
	import com.qiyi.player.wonder.plugins.topbar.TopBarDef;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import com.qiyi.player.wonder.plugins.topbar.view.TopBarEvent;
	
	public class VideoScaleBar extends Sprite {
		
		public function VideoScaleBar() {
			var _loc1_:VideoScaleItem = null;
			super();
			this._bgShape = new Shape();
			addChild(this._bgShape);
			this._vsiVector = new Vector.<VideoScaleItem>();
			var _loc2_:uint = 0;
			while(_loc2_ < SCALE_ARR.length) {
				_loc1_ = new VideoScaleItem(SCALE_ARR[_loc2_],SCALE_TYPE_ARR[_loc2_]);
				this._vsiVector.push(_loc1_);
				_loc1_.x = _loc2_ * (_loc1_.width + 5);
				addChild(_loc1_);
				_loc1_.addEventListener(MouseEvent.CLICK,this.onItemClick);
				_loc2_++;
			}
		}
		
		private static const SCALE_ARR:Array = ["50%","75%","100%","满屏"];
		
		private static const SCALE_TYPE_ARR:Array = [TopBarDef.SCALE_VALUE_50,TopBarDef.SCALE_VALUE_75,TopBarDef.SCALE_VALUE_100,TopBarDef.SCALE_VALUE_FULL];
		
		private var _vsiVector:Vector.<VideoScaleItem>;
		
		private var _bgShape:Shape;
		
		private function onItemClick(param1:MouseEvent) : void {
			var _loc3_:VideoScaleItem = null;
			var _loc2_:VideoScaleItem = param1.target as VideoScaleItem;
			if(_loc2_) {
				for each(_loc3_ in this._vsiVector) {
					_loc3_.isSelected = false;
				}
				dispatchEvent(new TopBarEvent(TopBarEvent.Evt_ScaleClick,_loc2_.type));
			}
		}
		
		public function setVideoScale(param1:uint) : void {
			var _loc2_:VideoScaleItem = null;
			for each(_loc2_ in this._vsiVector) {
				if(param1 == _loc2_.type) {
					_loc2_.isSelected = true;
					this._bgShape.graphics.clear();
					this._bgShape.graphics.beginFill(5865493);
					this._bgShape.graphics.drawRoundRect(_loc2_.x,_loc2_.y,_loc2_.width,_loc2_.height,5);
					this._bgShape.graphics.endFill();
				}
			}
		}
	}
}
