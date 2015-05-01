package com.sohu.tv.mediaplayer.ui {
	import flash.display.*;
	import com.greensock.*;
	import com.greensock.easing.*;
	import flash.events.*;
	
	public class TvSohuPanel extends Sprite {
		
		public function TvSohuPanel(param1:MovieClip, param2:Boolean = true) {
			super();
			this._owner = this;
			if(param2) {
				this.BaseHardInit(param1);
			}
		}
		
		protected var _owner;
		
		protected var _skin:MovieClip;
		
		protected var _isOpen:Boolean = false;
		
		protected var _close_btn:SimpleButton;
		
		public function BaseHardInit(param1:MovieClip) : void {
			this._skin = param1;
			this._skin.x = this._skin.y = 0;
			addChild(this._skin);
			this._close_btn = this._skin.close_btn;
			this._close_btn.addEventListener(MouseEvent.MOUSE_UP,this.close);
		}
		
		public function close(param1:* = null) : void {
			var evt:* = param1;
			if(!(evt == 0) && (this._isOpen)) {
				this._isOpen = false;
				this._owner.visible = true;
				TweenLite.to(this._owner,0.3,{
					"alpha":0,
					"ease":Quad.easeOut,
					"onComplete":function():void {
						_owner.visible = false;
					}
				});
			} else {
				this._owner.visible = false;
				this._owner.alpha = 0;
			}
		}
		
		public function open(param1:* = null) : void {
			this._isOpen = true;
			this._owner.visible = true;
			TweenLite.to(this._owner,0.3,{
				"alpha":1,
				"ease":Quad.easeOut
			});
		}
		
		public function resizeHandler(param1:Event = null) : void {
			this.changeSize(this._owner["parent"].core.width,this._owner["parent"].core.height);
		}
		
		public function changeSize(param1:Number, param2:Number) : void {
			var _loc3_:* = NaN;
			if(param1 <= this._skin.width || param2 <= this._skin.height) {
				_loc3_ = Math.min(param1 / this._skin.width,param2 / this._skin.height);
				this._skin.scaleX = _loc3_ * this._skin.scaleX;
				this._skin.scaleY = _loc3_ * this._skin.scaleY;
			} else {
				this._skin.scaleX = this._skin.scaleY = 1;
			}
		}
		
		public function get isOpen() : Boolean {
			return this._isOpen;
		}
		
		override public function get width() : Number {
			this.resizeHandler();
			return this._skin.width;
		}
		
		override public function get height() : Number {
			this.resizeHandler();
			return this._skin.height;
		}
	}
}
