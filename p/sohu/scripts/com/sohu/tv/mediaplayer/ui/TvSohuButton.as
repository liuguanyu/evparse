package com.sohu.tv.mediaplayer.ui {
	import ebing.controls.ButtonUtil;
	import ebing.Utils;
	import com.greensock.*;
	import com.greensock.easing.*;
	import flash.display.*;
	import flash.utils.*;
	import flash.events.MouseEvent;
	
	public class TvSohuButton extends ButtonUtil {
		
		public function TvSohuButton(param1:Object) {
			this._verObj = new Object();
			super(param1);
		}
		
		private var _cartoon:MovieClip;
		
		private var _tween:TweenLite;
		
		private var _num:int = 0;
		
		private var _str:String;
		
		private var _time:Number;
		
		private var _verObj:Object;
		
		override protected function sysInit() : void {
			super.sysInit();
			this._verObj = Utils.RegExpVersion();
		}
		
		public function set hasLable(param1:String) : void {
			if(_skin_mc.txt != null) {
				_skin_mc.txt.text = param1;
			}
			this._str = param1;
		}
		
		override public function set enabled(param1:Boolean) : void {
			if(_enabled_boo != param1) {
				_enabled_boo = param1;
				if(param1) {
					_target.buttonMode = true;
					_target.useHandCursor = true;
					this.addEvent();
				} else {
					_target.buttonMode = false;
					_target.useHandCursor = false;
					if(_skin_mc != null) {
						_skin_mc.gotoAndStop(4);
					}
					this.removeEvent();
				}
			}
			if(_skin_mc.txt != null) {
				_skin_mc.txt.text = this._str;
			}
		}
		
		override protected function clickHandler(param1:MouseEvent) : void {
			super.clickHandler(param1);
			this.setTimeFun();
		}
		
		override protected function overHandler(param1:MouseEvent) : void {
			super.overHandler(param1);
			if(_skin_mc.txt != null) {
				_skin_mc.txt.text = this._str;
			}
		}
		
		override protected function downHandler(param1:MouseEvent) : void {
			super.downHandler(param1);
			this.setTimeFun();
		}
		
		override protected function upHandler(param1:MouseEvent) : void {
			super.upHandler(param1);
			if(_skin_mc.txt != null) {
				_skin_mc.txt.text = this._str;
			}
		}
		
		override protected function onStageMouseUp(param1:MouseEvent) : void {
			super.onStageMouseUp(param1);
			if(_skin_mc.txt != null) {
				_skin_mc.txt.text = this._str;
			}
		}
		
		override protected function outHandler(param1:MouseEvent) : void {
			super.outHandler(param1);
			this.setTimeFun();
		}
		
		override protected function moveHandler(param1:MouseEvent) : void {
			super.moveHandler(param1);
			if(_skin_mc.txt != null) {
				_skin_mc.txt.text = this._str;
			}
		}
		
		override protected function doubleHandler(param1:MouseEvent) : void {
			super.doubleHandler(param1);
			if(_skin_mc.txt != null) {
				_skin_mc.txt.text = this._str;
			}
		}
		
		override protected function addEvent() : void {
			_target.addEventListener(MouseEvent.MOUSE_DOWN,this.downHandler);
			_target.addEventListener(MouseEvent.MOUSE_UP,this.upHandler);
			_target.addEventListener(MouseEvent.MOUSE_MOVE,this.moveHandler);
			_target.addEventListener(MouseEvent.DOUBLE_CLICK,this.doubleHandler);
			_target.addEventListener(MouseEvent.CLICK,this.clickHandler);
		}
		
		override protected function removeEvent() : void {
			_target.removeEventListener(MouseEvent.MOUSE_DOWN,this.downHandler);
			_target.removeEventListener(MouseEvent.MOUSE_UP,this.upHandler);
			_target.removeEventListener(MouseEvent.MOUSE_MOVE,this.moveHandler);
			_target.removeEventListener(MouseEvent.DOUBLE_CLICK,this.doubleHandler);
			_target.removeEventListener(MouseEvent.CLICK,this.clickHandler);
		}
		
		public function set clicked(param1:Boolean) : void {
			if(param1) {
				if(_skin_mc != null) {
					_skin_mc.gotoAndStop(3);
				}
			} else if(_skin_mc != null) {
				_skin_mc.gotoAndStop(1);
			}
			
		}
		
		private function setTimeFun() : void {
			if(this._verObj.majorVersion == 9) {
				this._time = setInterval(function():void {
					if(_skin_mc.txt.text != null) {
						_skin_mc.txt.text = _str;
						clearInterval(_time);
					}
				},50);
			} else if(_skin_mc.txt != null) {
				_skin_mc.txt.text = this._str;
			}
			
		}
	}
}
