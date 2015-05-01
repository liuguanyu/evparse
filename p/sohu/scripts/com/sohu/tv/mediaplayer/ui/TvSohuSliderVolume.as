package com.sohu.tv.mediaplayer.ui {
	import flash.display.Sprite;
	import ebing.controls.*;
	import flash.events.*;
	import flash.utils.*;
	import ebing.Utils;
	import ebing.events.SliderEventUtil;
	import ebing.events.MouseEventUtil;
	import com.sohu.tv.mediaplayer.stat.SendRef;
	
	public class TvSohuSliderVolume extends TvSohuSliderSpeed {
		
		public function TvSohuSliderVolume(param1:Object) {
			super(param1);
		}
		
		private var _mask_mc:Sprite;
		
		private var _topMcWidth:Number;
		
		private var _tempRate:Number = 0;
		
		private var _clickTimes:Number = 0;
		
		override protected function doSlide(param1:Number, param2:Number) : void {
			super.doSlide(param1,param2);
			_top_mc.width = _middle_mc.width;
			this._mask_mc.width = _dollop_btn.x + _dollop_btn.width / 2;
			if(_topRate_num == 0) {
				this._mask_mc.visible = false;
			} else {
				this._mask_mc.visible = true;
			}
		}
		
		override protected function drawSkin() : void {
			this._mask_mc = new Sprite();
			Utils.drawRect(this._mask_mc,0,0,_middle_mc.width,_middle_mc.height,16777215,1);
			super.drawSkin();
			var _loc1_:Number = Utils.getMaxWidth([_top_mc,_middle_mc,_bottom_mc,_dollop_btn,_hit_spr]);
			var _loc2_:Number = Utils.getMaxHeight([_top_mc,_middle_mc,_bottom_mc,_dollop_btn,_hit_spr]);
			_container.addChild(_bottom_mc);
			_container.addChild(_middle_mc);
			_container.addChild(_top_mc);
			_container.addChild(this._mask_mc);
			_container.addChild(_hit_spr);
			_container.addChild(_dollop_btn);
			Utils.setCenterByNumber(_bottom_mc,_loc1_,_loc2_);
			Utils.setCenterByNumber(_middle_mc,_loc1_,_loc2_);
			Utils.setCenterByNumber(_dollop_btn,_loc1_,_loc2_);
			Utils.setCenterByNumber(_top_mc,_loc1_,_loc2_);
			Utils.setCenterByNumber(this._mask_mc,_loc1_,_loc2_);
			Utils.setCenterByNumber(_hit_spr,_loc1_,_loc2_);
			_bottom_mc.x = _middle_mc.x = _top_mc.x = this._mask_mc.x = _dollop_btn.x = _hit_spr.x = 0;
			_top_mc.mask = this._mask_mc;
			_top_mc.width = _middle_mc.width = this._mask_mc.width;
		}
		
		override protected function speedForward(param1:Boolean = false) : void {
			if(_seekNum == -1) {
				_seekNum = _dollop_btn.x + _dollop_btn.width / 2;
			}
			if(_topRate_num < 1) {
				_seekNum = param1?_seekNum + 3:_seekNum + 1;
				this.doSlide(_seekNum,0);
			} else if(++_time % 10 == 9 || (param1)) {
				if(_superRate < 5) {
					_superRate = _superRate + 0.5;
				}
				dispatch(SliderEventUtil.SLIDER_RATE,{
					"rate":_superRate,
					"sign":1
				});
			}
			
		}
		
		override public function set topRate(param1:Number) : void {
			super.topRate = param1;
			if(param1 >= 0 && param1 <= 1) {
				_topRate_num = param1;
				this._mask_mc.width = _topRate_num * (_bottom_mc.width - _dollop_btn.width) + _dollop_btn.width / 2;
				_dollop_btn.x = Math.floor(this._mask_mc.width - _dollop_btn.width / 2);
				_top_mc.width = _middle_mc.width;
				if(_topRate_num == 0) {
					_top_mc.visible = false;
				} else {
					_top_mc.visible = true;
				}
			}
		}
		
		override protected function downHandler(param1:MouseEventUtil) : void {
			super.downHandler(param1);
			switch(param1.target) {
				case _dollop_btn:
					this._tempRate = _topRate_num;
					break;
			}
		}
		
		override protected function upHandler(param1:MouseEventUtil) : void {
			super.upHandler(param1);
			switch(param1.target) {
				case _dollop_btn:
					if(_topRate_num - this._tempRate > 0) {
						SendRef.getInstance().sendPQVPC("fun_yangli205733_PL_C_UpBar");
					} else if(_topRate_num - this._tempRate < 0) {
						SendRef.getInstance().sendPQVPC("fun_yangli205733_PL_C_DownBar");
					}
					
					this._tempRate = _topRate_num;
					if(this._clickTimes < 2) {
						this._clickTimes++;
					} else {
						dispatchEvent(new Event("clickTimes"));
						this._clickTimes = 0;
					}
					break;
			}
		}
	}
}
