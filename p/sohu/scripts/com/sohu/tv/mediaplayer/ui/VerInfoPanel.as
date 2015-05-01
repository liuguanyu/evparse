package com.sohu.tv.mediaplayer.ui {
	import ebing.Utils;
	import flash.text.*;
	import flash.display.*;
	import flash.events.*;
	import com.greensock.*;
	import com.greensock.easing.*;
	import ebing.utils.*;
	import flash.net.*;
	import flash.utils.*;
	
	public class VerInfoPanel extends Sprite {
		
		public function VerInfoPanel(param1:Number, param2:Number) {
			super();
			this._panelVersion = new TextField();
			this._bg = new Sprite();
			this._close_btn = new Sprite();
			this._owner = this;
			VerLog.logsText = this._panelVersion;
			this._width = param1 >= 250?250:param1;
			this._height = param2 >= 200?200:param2;
			this.drawSkin(this._width,this._height);
			this.addEvent();
		}
		
		public static function setTextFormat(param1:TextField, param2:Number) : void {
			var _loc3_:TextFormat = new TextFormat();
			_loc3_.size = 12;
			_loc3_.leading = 10;
			_loc3_.font = "微软雅黑";
			_loc3_.align = TextFormatAlign.LEFT;
			param1.wordWrap = true;
			param1.textColor = param2;
			param1.setTextFormat(_loc3_);
		}
		
		public static function drawCloseBtn(param1:Number, param2:uint, param3:uint) : Sprite {
			var _loc4_:Number = int(param1 / 5);
			var _loc5_:Number = param1 / 2;
			var _loc6_:Number = _loc5_;
			var _loc7_:int = int(param1 / 5);
			var _loc8_:Sprite = new Sprite();
			var _loc9_:Sprite = new Sprite();
			_loc9_.graphics.beginFill(param2,0.8);
			_loc9_.graphics.drawCircle(_loc6_,_loc6_,_loc5_);
			_loc9_.graphics.endFill();
			_loc9_.graphics.lineStyle(_loc4_,param3,1,false,"normal",CapsStyle.NONE);
			_loc9_.graphics.moveTo(_loc7_,_loc7_);
			_loc9_.graphics.lineTo(param1 - _loc7_,param1 - _loc7_);
			_loc9_.graphics.moveTo(_loc7_,param1 - _loc7_);
			_loc9_.graphics.lineTo(param1 - _loc7_,_loc7_);
			_loc8_.addChild(_loc9_);
			_loc9_.x = 1;
			_loc9_.y = (_loc8_.height - _loc9_.height) / 2;
			_loc8_.graphics.beginFill(4473924,0);
			_loc8_.graphics.drawRect(0,0,_loc8_.width,_loc8_.height);
			_loc8_.graphics.endFill();
			return _loc8_;
		}
		
		private var _panelVersion:TextField;
		
		private var _bg:Sprite;
		
		protected var _owner;
		
		protected var _isOpen:Boolean = false;
		
		private var _closeBtnUp:Sprite;
		
		private var _closeBtnOver:Sprite;
		
		private var _close_btn:Sprite;
		
		private var _width:Number = 0;
		
		private var _height:Number = 0;
		
		private function drawSkin(param1:Number, param2:Number) : void {
			Utils.drawRect(this._bg,0,0,param1,param2,0,0.8);
			addChild(this._bg);
			this._closeBtnUp = drawCloseBtn(15,0,16777215);
			this._closeBtnOver = drawCloseBtn(15,0,16711680);
			this._close_btn.addChild(this._closeBtnUp);
			this._close_btn.addChild(this._closeBtnOver);
			this._closeBtnOver.visible = false;
			this._close_btn.buttonMode = this._close_btn.useHandCursor = true;
			this._close_btn.mouseChildren = false;
			setTextFormat(this._panelVersion,16777215);
			addChild(this._panelVersion);
			this._close_btn.x = param1 - this._close_btn.width - 5;
			this._close_btn.y = 5;
			addChild(this._close_btn);
			this._panelVersion.x = 10;
			this._panelVersion.width = param1 - 10;
			this._panelVersion.visible = false;
			this.resize(param1,param2);
		}
		
		private function addEvent() : void {
			this._close_btn.addEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
			this._close_btn.addEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler);
			this._close_btn.addEventListener(MouseEvent.MOUSE_UP,this.close);
		}
		
		public function resize(param1:Number, param2:Number) : void {
			var _loc3_:* = NaN;
			var _loc4_:* = NaN;
			this._width = param1 >= 250?250:param1;
			this._height = param2 >= 200?200:param2;
			if(!(this._bg == null) && !(this._close_btn == null)) {
				_loc3_ = this._width - this._bg.width;
				_loc4_ = this._height - this._bg.height;
				this._close_btn.x = this._close_btn.x + _loc3_;
				this._bg.width = this._width;
				this._panelVersion.width = this._panelVersion.width + _loc3_;
				this._bg.height = this._panelVersion.textHeight + 10;
			}
			setTextFormat(this._panelVersion,16777215);
		}
		
		public function close(param1:* = null) : void {
			var evt:* = param1;
			this._panelVersion.visible == false;
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
			this._panelVersion.visible = true;
			this._isOpen = true;
			this._owner.visible = true;
			TweenLite.to(this._owner,0.3,{
				"alpha":1,
				"ease":Quad.easeOut
			});
		}
		
		private function mouseOverHandler(param1:MouseEvent) : void {
			this._closeBtnOver.visible = true;
			this._closeBtnUp.visible = false;
		}
		
		private function mouseOutHandler(param1:MouseEvent) : void {
			this._closeBtnOver.visible = false;
			this._closeBtnUp.visible = true;
		}
		
		public function get isOpen() : Boolean {
			return this._isOpen;
		}
		
		override public function get width() : Number {
			return this._bg.width;
		}
		
		override public function get height() : Number {
			return this._bg.height;
		}
	}
}
