package com.sohu.tv.mediaplayer.ui {
	import flash.display.MovieClip;
	import com.greensock.TweenLite;
	import ebing.utils.Timeout;
	import com.greensock.easing.*;
	import ebing.controls.*;
	import ebing.events.*;
	import flash.events.*;
	import flash.utils.*;
	import ebing.Utils;
	import com.sohu.tv.mediaplayer.stat.SendRef;
	import com.sohu.tv.mediaplayer.PlayerConfig;
	
	public class TvSohuVolumeBar extends VolumeBar {
		
		public function TvSohuVolumeBar(param1:Object) {
			this._volArr = new Array();
			this._volMcArr = new Array();
			super(param1);
		}
		
		private var _bg:MovieClip;
		
		private var _width:Number = 0;
		
		private var _height:Number = 0;
		
		private var _sliderY:Number = 0;
		
		private var _enabled:Boolean = false;
		
		private var _volContinueTip:MovieClip;
		
		private var _tween:TweenLite;
		
		private var _isShow:Boolean = false;
		
		private var _timeout:Timeout;
		
		private var _volMc:MovieClip;
		
		private var _volNum:Number;
		
		private var _volArr:Array;
		
		private var _volMcArr:Array;
		
		private var _time:Number;
		
		private var _isVertical:Boolean = false;
		
		override public function init(param1:Object) : void {
			this._bg = param1.skin.bgMc;
			this._volMc = param1.skin.volMc;
			this._volContinueTip = param1.skin.volContinueTipMc;
			if(param1.isVertical != null) {
				this._isVertical = param1.isVertical;
			}
			this._sliderY = param1.sliderY;
			super.init(param1);
		}
		
		override protected function drawSkin() : void {
			var _loc5_:MovieClip = null;
			var _loc1_:Number = Utils.getMaxWidth([this._bg,_slider,_comebackVol_btn,_muteVol_btn]);
			var _loc2_:Number = Utils.getMaxHeight([this._bg,_slider,_comebackVol_btn,_muteVol_btn]);
			addChild(this._bg);
			addChild(this._volContinueTip);
			var _loc3_:* = 0;
			while(_loc3_ < this._volMc.numChildren) {
				this._volArr.push(this._volMc.getChildAt(_loc3_));
				_loc3_++;
			}
			var _loc4_:* = 0;
			while(_loc4_ < this._volArr.length) {
				_loc5_ = this._volArr[_loc4_] as MovieClip;
				_loc5_.gotoAndStop(1);
				_loc5_.visible = false;
				_muteVol_btn.addChild(_loc5_);
				this._volMcArr.push(_loc5_);
				_loc4_++;
			}
			super.drawSkin();
			Utils.setCenterByNumber(_comebackVol_btn,_loc1_,_loc2_);
			Utils.setCenterByNumber(_muteVol_btn,_loc1_,_loc2_);
			if(this._isVertical) {
				Utils.setCenterByNumber(this._bg,_loc1_,_loc2_);
				Utils.setCenterByNumber(_slider,_loc1_,_loc2_);
				this._bg.x = _comebackVol_btn.x = _muteVol_btn.x = 0;
				_comebackVol_btn.y = _muteVol_btn.y = 0;
				this._bg.y = _comebackVol_btn.y - this._bg.height;
				_slider.x = 0;
				_slider.y = -14;
				this._bg.gotoAndStop(1);
				this._bg.visible = _slider.visible = false;
				this._volContinueTip.x = -25;
				this._volContinueTip.y = _slider.y - 4;
				this._width = _muteVol_btn.width;
				this._height = this._bg.y;
				this._volContinueTip.visible = false;
			} else {
				_comebackVol_btn.x = _muteVol_btn.x = 0;
				_comebackVol_btn.y = _muteVol_btn.y = 0;
				_slider.x = _comebackVol_btn.x + _comebackVol_btn.width;
				_slider.y = _comebackVol_btn.y + 2;
				this._volContinueTip.y = _comebackVol_btn.y - 10;
				this._volContinueTip.x = _slider.x + _slider.width - 12;
				this._width = _loc1_;
				this._height = _loc2_;
				this._volContinueTip.visible = false;
				this._bg.visible = false;
			}
		}
		
		override protected function checkRate(param1:SliderEventUtil = null) : void {
			var evt:SliderEventUtil = param1;
			super.checkRate(evt);
			if(_slider.topRate >= 1) {
				_comebackVol_btn.visible = false;
				_muteVol_btn.visible = true;
				if(Math.round(_slider["superRate"] * 100) > 100) {
					this._volNum = 3;
				} else {
					this._volNum = 2;
				}
				this.checkArrVis(this._volNum);
			} else if(_slider.topRate > 0 && _slider.topRate < 1) {
				_comebackVol_btn.visible = false;
				_muteVol_btn.visible = true;
				if(_slider.topRate > 0 && _slider.topRate <= 0.33) {
					this._volNum = 0;
				} else if(_slider.topRate > 0.33 && _slider.topRate <= 0.66) {
					this._volNum = 1;
				} else {
					this._volNum = 2;
				}
				
				this.checkArrVis(this._volNum);
			} else {
				_comebackVol_btn.visible = true;
				_muteVol_btn.visible = false;
			}
			
			this._isShow = true;
			this._volContinueTip.rate_txt.text = _slider.topRate < 1?Math.round(_slider.topRate * 100) + "%":Math.round(_slider["superRate"] * 100) + "%";
			if(this._isVertical) {
				this._volContinueTip.y = _slider.y + 15 - Math.round(_slider.topRate * 100 * 0.53);
			} else {
				this._volContinueTip.x = _slider.x + 4 + Math.round(_slider.topRate * 100 * 0.53);
				this._volContinueTip.y = _comebackVol_btn.y - 10;
			}
			this._timeout.restart();
			if(!this._volContinueTip.visible && !(evt == null)) {
				this._volContinueTip.alpha = 0;
				this._volContinueTip.visible = true;
				this._tween = TweenLite.to(this._volContinueTip,0.3,{
					"alpha":1,
					"ease":Quad.easeOut,
					"onComplete":function():void {
						_timeout.start();
					}
				});
			}
		}
		
		private function hideTip(param1:* = null) : void {
			var evt:* = param1;
			this._isShow = false;
			this._tween = TweenLite.to(this._volContinueTip,0.3,{
				"alpha":0,
				"ease":Quad.easeOut,
				"onComplete":function():void {
					_volContinueTip.visible = false;
				}
			});
		}
		
		override protected function newFunc() : void {
			_slider = new TvSohuSliderVolume(_par);
			_slider.addEventListener("clickTimes",function(param1:Event):void {
				dispatchEvent(new Event("volKeyboardTip"));
			});
			if(this._isVertical) {
				_slider.rotation = -90;
			}
			this._timeout = new Timeout(2);
		}
		
		private function mouseOver(param1:MouseEvent) : void {
			var evt:MouseEvent = param1;
			if(this._isVertical) {
				clearTimeout(this._time);
				this._time = setInterval(function():void {
					_bg.visible = true;
					_bg.gotoAndStop(2);
					_tween = TweenLite.to(_bg,0.3,{
						"alpha":1,
						"ease":Quad.easeOut
					});
					_slider.visible = true;
					_tween = TweenLite.to(_slider,0.3,{
						"alpha":1,
						"ease":Quad.easeOut
					});
				},200);
			}
		}
		
		private function mouseOut(param1:MouseEvent) : void {
			var evt:MouseEvent = param1;
			if(this._isVertical) {
				clearTimeout(this._time);
				this._time = setInterval(function():void {
					_bg.visible = false;
					_timeout.stop();
					_volContinueTip.visible = false;
					_tween = TweenLite.to(_bg,0.3,{
						"alpha":0,
						"ease":Quad.easeOut,
						"onComplete":function():void {
							_bg.gotoAndStop(1);
						}
					});
					_slider.visible = false;
					_tween = TweenLite.to(_slider,0.3,{
						"alpha":0,
						"ease":Quad.easeOut
					});
				},200);
			}
		}
		
		override public function get width() : Number {
			return this._width;
		}
		
		override public function get height() : Number {
			return this._height;
		}
		
		override public function set enabled(param1:Boolean) : void {
			super.enabled = this._enabled = param1;
			if((this._enabled) && !this.hasEventListener(MouseEvent.MOUSE_OVER)) {
				this.addEventListener(MouseEvent.MOUSE_OVER,this.mouseOver);
				this.addEventListener(MouseEvent.MOUSE_OUT,this.mouseOut);
			} else if(!this._enabled) {
				this.removeEventListener(MouseEvent.MOUSE_OVER,this.mouseOver);
				this.removeEventListener(MouseEvent.MOUSE_OUT,this.mouseOut);
			}
			
		}
		
		override protected function addEvent() : void {
			super.addEvent();
			this.addEventListener(MouseEvent.MOUSE_OVER,this.mouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT,this.mouseOut);
			this._timeout.addEventListener(Timeout.TIMEOUT,this.hideTip);
			this.addEventListener(Event.ADDED_TO_STAGE,this.onAddStage);
			_muteVol_btn.addEventListener(MouseEventUtil.MOUSE_OVER,this.muteOver);
			_muteVol_btn.addEventListener(MouseEventUtil.MOUSE_OUT,this.muteOut);
		}
		
		protected function muteOver(param1:MouseEventUtil) : void {
			var _loc2_:* = 0;
			while(_loc2_ < this._volMcArr.length) {
				this._volMcArr[_loc2_].gotoAndStop(2);
				_loc2_++;
			}
			if(!this._isVertical) {
				this._volContinueTip.visible = false;
			}
		}
		
		protected function muteOut(param1:MouseEventUtil) : void {
			var _loc2_:* = 0;
			while(_loc2_ < this._volMcArr.length) {
				this._volMcArr[_loc2_].gotoAndStop(1);
				_loc2_++;
			}
			if(!this._isVertical) {
				this._volContinueTip.visible = false;
			}
		}
		
		private function checkArrVis(param1:Number) : void {
			var _loc2_:* = 0;
			while(_loc2_ < this._volMcArr.length) {
				if(_loc2_ == param1) {
					this._volMcArr[_loc2_].visible = true;
				} else {
					this._volMcArr[_loc2_].visible = false;
				}
				_loc2_++;
			}
		}
		
		private function onAddStage(param1:Event) : void {
			this.removeEventListener(Event.ADDED_TO_STAGE,this.onAddStage);
		}
		
		override public function set rate(param1:Number) : void {
			var _loc2_:Number = 0;
			if(param1 >= 0 && param1 <= 1) {
				_loc2_ = param1;
			} else if(param1 > 1) {
				_loc2_ = 1;
				_slider["superRate"] = param1;
			}
			
			_slider.topRate = _loc2_;
			this.checkRate();
		}
		
		override protected function muteVolume(param1:MouseEventUtil) : void {
			if(_slider["superRate"] <= 1) {
				_volume_num = _slider.topRate;
			} else {
				_volume_num = _slider["superRate"];
			}
			_slider.topRate = 0;
			_slider.dispatch(SliderEventUtil.SLIDER_RATE,{"rate":_slider.topRate});
			_slider.dispatch(SliderEventUtil.SLIDE_END,{"sign":1});
			param1.target.visible = false;
			_comebackVol_btn.visible = true;
			if(!this._isVertical) {
				this._volContinueTip.visible = false;
			}
			dispatchEvent(new Event("muteVolume"));
			SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_C_Mute&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
		}
		
		public function comebackVolume2() : void {
			if(_volume_num > 1) {
				_slider.topRate = 1;
			} else {
				_volume_num = _volume_num > 0?_volume_num:0.8;
				_slider.topRate = _volume_num;
			}
			_slider.dispatch(SliderEventUtil.SLIDER_RATE,{"rate":_volume_num});
			_slider.dispatch(SliderEventUtil.SLIDE_END,{"sign":1});
			_comebackVol_btn.visible = false;
			_muteVol_btn.visible = true;
			if(this._isVertical) {
				if(!(_slider == null) && !(this._bg == null) && (_slider.visible) && (this._bg.visible)) {
					this._volContinueTip.visible = true;
				} else {
					this._volContinueTip.visible = false;
				}
			} else {
				this._volContinueTip.visible = false;
			}
			dispatchEvent(new Event("muteVolume"));
		}
		
		override protected function comebackVolume(param1:MouseEventUtil) : void {
			this.comebackVolume2();
			dispatchEvent(new Event("comebackVolume"));
			SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_C_Unmute&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
		}
	}
}
