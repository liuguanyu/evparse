package com.sohu.tv.mediaplayer.ui {
	import ebing.Utils;
	import flash.system.System;
	import com.sohu.tv.mediaplayer.ads.AdLog;
	import flash.text.*;
	import flash.display.*;
	import ebing.utils.*;
	import flash.events.*;
	import com.greensock.*;
	import com.greensock.easing.*;
	import flash.net.*;
	import flash.utils.*;
	
	public class LogsPanel extends Sprite {
		
		public function LogsPanel(param1:Number, param2:Number) {
			this._copyLogs_btn = new CustomButton("复制全部log");
			this._mailTo_btn = new CustomButton("MailTo:TECH");
			this._mainLogs_btn = new CustomButton("主播放器");
			this._adLogs_btn = new CustomButton("广告");
			super();
			this._mainLogsText = new TextField();
			this._adLogsText = new TextField();
			this._bg = new Sprite();
			this._close_btn = new Sprite();
			this._owner = this;
			LogManager.logsText = this._mainLogsText;
			AdLog.logsText = this._adLogsText;
			this.drawSkin(param1,param2);
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
		
		private var _mainLogsText:TextField;
		
		private var _adLogsText:TextField;
		
		private var _bg:Sprite;
		
		private var _copyLogs_btn:CustomButton;
		
		private var _mailTo_btn:CustomButton;
		
		protected var _owner;
		
		protected var _isOpen:Boolean = false;
		
		private var _closeBtnUp:Sprite;
		
		private var _closeBtnOver:Sprite;
		
		private var _close_btn:Sprite;
		
		private var _mainLogs_btn:CustomButton;
		
		private var _adLogs_btn:CustomButton;
		
		private function drawSkin(param1:Number, param2:Number) : void {
			Utils.drawRect(this._bg,0,0,param1,param2,0,0.9);
			addChild(this._bg);
			this._closeBtnUp = drawCloseBtn(15,0,16777215);
			this._closeBtnOver = drawCloseBtn(15,0,16711680);
			this._close_btn.addChild(this._closeBtnUp);
			this._close_btn.addChild(this._closeBtnOver);
			this._closeBtnOver.visible = false;
			this._close_btn.buttonMode = this._close_btn.useHandCursor = true;
			this._close_btn.mouseChildren = false;
			setTextFormat(this._adLogsText,16777215);
			setTextFormat(this._mainLogsText,16777215);
			addChild(this._mainLogsText);
			addChild(this._adLogsText);
			this._close_btn.x = param1 - this._close_btn.width - 5;
			this._close_btn.y = 5;
			addChild(this._close_btn);
			addChild(this._copyLogs_btn);
			addChild(this._mailTo_btn);
			addChild(this._mainLogs_btn);
			addChild(this._adLogs_btn);
			this._mainLogs_btn.y = this._adLogs_btn.y = 5;
			this._mainLogs_btn.x = 5;
			this._adLogs_btn.x = this._mainLogs_btn.x + this._mainLogs_btn.width;
			this._mainLogsText.y = this._adLogsText.y = this._mainLogs_btn.y + this._mainLogs_btn.height + 20;
			this._mainLogsText.x = this._adLogsText.x = 10;
			this._mainLogsText.width = this._adLogsText.width = param1 - 10;
			this._mainLogsText.height = this._adLogsText.height = param2 - 60;
			this._mainLogsText.visible = this._adLogsText.visible = false;
		}
		
		private function addEvent() : void {
			this._copyLogs_btn.addEventListener(MouseEvent.CLICK,this.copyLogs);
			this._mailTo_btn.addEventListener(MouseEvent.CLICK,this.mailTo);
			this._mainLogs_btn.addEventListener(MouseEvent.CLICK,this.showMainLogs);
			this._adLogs_btn.addEventListener(MouseEvent.CLICK,this.showAdLogs);
			this._close_btn.addEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
			this._close_btn.addEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler);
			this._close_btn.addEventListener(MouseEvent.MOUSE_UP,this.close);
		}
		
		private function copyLogs(param1:MouseEvent) : void {
			this.sumLogs();
		}
		
		private function mailTo(param1:MouseEvent) : void {
			this.sumLogs();
			Utils.openWindow("mailto:tv-tech-flash@sohu-inc.com?subject=SohuTVPlayerLogs(" + new Date().toString() + ")&body=Please paste:");
		}
		
		private function sumLogs() : void {
			var _loc1_:TextField = new TextField();
			_loc1_.text = "主播放器日志： " + this._mainLogsText.text + "广告日志：" + this._adLogsText.text;
			System.setClipboard(_loc1_.text);
			LogManager.msg("播放器log已复制！");
			AdLog.msg("广告log已复制！");
		}
		
		private function showMainLogs(param1:MouseEvent) : void {
			this._mainLogsText.visible = true;
			this._adLogsText.visible = false;
		}
		
		private function showAdLogs(param1:MouseEvent) : void {
			this._adLogsText.visible = true;
			this._mainLogsText.visible = false;
		}
		
		public function resize(param1:Number, param2:Number) : void {
			var _loc3_:* = NaN;
			var _loc4_:* = NaN;
			if(!(this._bg == null) && !(this._close_btn == null)) {
				_loc3_ = param1 - this._bg.width;
				_loc4_ = param2 - this._bg.height;
				this._close_btn.x = this._close_btn.x + _loc3_;
				this._bg.width = param1;
				this._bg.height = param2;
				Utils.setCenter(this._copyLogs_btn,this._bg);
				Utils.setCenter(this._mailTo_btn,this._bg);
				this._copyLogs_btn.x = this._copyLogs_btn.x - this._copyLogs_btn.width / 2 - 5;
				this._mailTo_btn.x = this._mailTo_btn.x + this._mailTo_btn.width / 2 + 5;
				this._copyLogs_btn.y = this._bg.height - this._copyLogs_btn.height - 10;
				this._mailTo_btn.y = this._bg.height - this._mailTo_btn.height - 10;
				this._mainLogsText.width = this._mainLogsText.width + _loc3_;
				this._mainLogsText.height = this._mainLogsText.height + _loc4_;
				this._adLogsText.width = this._mainLogsText.width;
				this._adLogsText.height = this._mainLogsText.height;
			}
			setTextFormat(this._adLogsText,16777215);
			setTextFormat(this._mainLogsText,16777215);
		}
		
		public function close(param1:* = null) : void {
			var evt:* = param1;
			this._mainLogsText.visible = this._adLogsText.visible = false;
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
			this._mainLogsText.visible = true;
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
