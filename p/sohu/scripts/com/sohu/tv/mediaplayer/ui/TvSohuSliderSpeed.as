package com.sohu.tv.mediaplayer.ui {
	import flash.display.MovieClip;
	import ebing.controls.*;
	import com.sohu.tv.mediaplayer.stat.*;
	import flash.events.*;
	import flash.utils.*;
	import ebing.events.SliderEventUtil;
	import ebing.events.MouseEventUtil;
	
	public class TvSohuSliderSpeed extends SliderSpeed {
		
		public function TvSohuSliderSpeed(param1:Object) {
			this._parObj = param1;
			this._isDivision = param1.isDivision;
			this._sendPQ = param1.sendPQ;
			super(param1);
		}
		
		protected var _superRate:Number = 1;
		
		protected var _time:Number = 0;
		
		private var _rateTextBar:MovieClip;
		
		private var _parObj:Object;
		
		private var _isDivision:Boolean;
		
		private var _sendPQ:Object;
		
		override protected function doSlide(param1:Number, param2:Number) : void {
			super.doSlide(param1,param2);
			this._superRate = 1;
			this.setRateText(topRate);
		}
		
		private function setRateText(param1:Number) : void {
			var _loc2_:* = NaN;
			var _loc3_:* = 0;
			if(this._rateTextBar != null) {
				_loc2_ = 0;
				if(this._isDivision) {
					_loc2_ = (param1 - 1) * 2 + 1;
				} else {
					_loc2_ = param1;
				}
				_loc3_ = Math.round(_loc2_ * 100);
				this._rateTextBar["rate_txt"].text = _loc3_ > 0?"+" + _loc3_:_loc3_;
			}
		}
		
		override protected function addEvent() : void {
			super.addEvent();
			this.addEventListener(FocusEvent.FOCUS_IN,this.onFocusIn);
			this.addEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
		}
		
		private function onFocusIn(param1:FocusEvent) : void {
			if(this._rateTextBar != null) {
				this._rateTextBar.gotoAndStop(2);
				this._rateTextBar["rate_txt"].textColor = 16777215;
			}
		}
		
		private function onFocusOut(param1:FocusEvent) : void {
			if(this._rateTextBar != null) {
				this._rateTextBar.gotoAndStop(1);
				this._rateTextBar["rate_txt"].textColor = 16777215;
			}
		}
		
		override protected function drawSkin() : void {
			super.drawSkin();
			if(!(this._parObj.skin == null) && !(this._parObj.skin.rateTextMc == null) && !(this._parObj.skin.rateTextMc == undefined)) {
				this._rateTextBar = this._parObj.skin.rateTextMc;
				this._rateTextBar.x = this.width + 1;
				this._rateTextBar.y = _container.y;
				this._rateTextBar.gotoAndStop(1);
				addChild(this._rateTextBar);
			}
		}
		
		override protected function speedForward(param1:Boolean = false) : void {
			if(_seekNum == -1) {
				_seekNum = _dollop_btn.x + _dollop_btn.width / 2;
			}
			if(_topRate_num < 1) {
				_seekNum = param1?_seekNum + 3:_seekNum + 1;
				this.doSlide(_seekNum,0);
			} else if(++this._time % 10 == 9 || (param1)) {
				this._superRate = this._superRate + 0.5;
				dispatch(SliderEventUtil.SLIDER_RATE,{
					"rate":this._superRate,
					"sign":1
				});
			}
			
		}
		
		override protected function speedBack(param1:Boolean = false) : void {
			if(_seekNum == -1) {
				_seekNum = _dollop_btn.x + _dollop_btn.width / 2;
			}
			if(_topRate_num < 1) {
				_seekNum = param1?_seekNum - 3:_seekNum - 1;
				this.doSlide(_seekNum,0);
			} else if(++this._time % 10 == 9 || (param1)) {
				this._superRate = this._superRate - 0.5;
				if(this._superRate < 1) {
					_topRate_num = this._superRate = 0.999999;
				}
				dispatch(SliderEventUtil.SLIDER_RATE,{
					"rate":this._superRate,
					"sign":1
				});
			}
			
		}
		
		override protected function upHandler(param1:MouseEventUtil) : void {
			super.upHandler(param1);
			if(this._sendPQ != null) {
				switch(param1.target) {
					case _forward_btn:
						if(!(this._sendPQ.forward == null) && !(this._sendPQ.forward == "")) {
							SendRef.getInstance().sendPQVPC(this._sendPQ.forward);
						}
						break;
					case _back_btn:
						if(!(this._sendPQ.back == null) && !(this._sendPQ.back == "")) {
							SendRef.getInstance().sendPQVPC(this._sendPQ.back);
						}
						break;
					case _dollop_btn:
						if(!(this._sendPQ.dollop == null) && !(this._sendPQ.dollop == "")) {
							SendRef.getInstance().sendPQVPC(this._sendPQ.dollop);
						}
						break;
				}
			}
		}
		
		override public function set topRate(param1:Number) : void {
			super.topRate = param1;
			this.setRateText(topRate);
		}
		
		public function get superRate() : Number {
			return this._superRate;
		}
		
		public function set superRate(param1:Number) : void {
			this._superRate = param1;
		}
	}
}
