package com.sohu.tv.mediaplayer.ads {
	import ebing.controls.*;
	import ebing.events.*;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	import flash.utils.*;
	import ebing.Utils;
	import com.sohu.tv.mediaplayer.PlayerConfig;
	
	public class LoadAdErrorTip extends Sprite {
		
		public function LoadAdErrorTip(param1:Object) {
			super();
			this._tipTimeLimit = param1.time;
			this._width = param1.width;
			this._height = param1.height;
			this._tipTimer = new Timer(1000,this._tipTimeLimit);
			this._tipTimer.addEventListener(TimerEvent.TIMER,this.tipTimerHandler);
			this._tipTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.stop);
			this.newFunc();
			this.drawSkin();
			this.addEvent();
		}
		
		private var _tipMc:Sprite;
		
		private var _tipTimer:Timer;
		
		private var _tipTimeLimit:Number = 0;
		
		protected var _fileTotTime:Number = 0;
		
		protected var _filePlayedTime:Number = 0;
		
		protected var _errStatusSp:Sprite;
		
		protected var limit:TextField;
		
		protected var _width:Number = 0;
		
		protected var _height:Number = 0;
		
		protected var tf:TextFormat;
		
		protected var _tipFlagState:String = "";
		
		protected var _isErrTipShown:Boolean = false;
		
		protected var _bg:Sprite;
		
		public function loadTip() : void {
			this.dispatch(MediaEvent.LOAD_PROGRESS,{
				"nowSize":1,
				"totSize":1
			});
		}
		
		public function play() : void {
			if(!this._isErrTipShown) {
				this._tipTimer.start();
				this._errStatusSp.visible = true;
				this._tipFlagState = "play";
				this.dispatch(MediaEvent.START);
				this._isErrTipShown = true;
			}
		}
		
		protected function tipTimerHandler(param1:TimerEvent) : void {
			this._filePlayedTime = this._filePlayedTime + param1.target.delay / 1000;
			this.dispatch(MediaEvent.PLAY_PROGRESS,{
				"nowTime":this._filePlayedTime,
				"totTime":this._tipTimeLimit * 1000
			});
		}
		
		public function pause(param1:* = null) : void {
			this._tipTimer.stop();
			this._tipFlagState = "pause";
		}
		
		public function reStart(param1:* = null) : void {
			this._tipTimer.start();
			this._tipFlagState = "play";
		}
		
		public function stop(param1:* = null) : void {
			this._tipTimer.stop();
			this._errStatusSp.visible = false;
			this._tipFlagState = "stop";
			this.dispatch(MediaEvent.STOP,{"finish":true});
			this._isErrTipShown = false;
		}
		
		private function newFunc() : void {
		}
		
		private function drawSkin() : void {
			this._errStatusSp = new Sprite();
			this._bg = new Sprite();
			Utils.drawRect(this._bg,0,0,this._width,this._height,0,1);
			this.tf = new TextFormat();
			this.tf.size = 14;
			this.tf.leading = 5;
			this.tf.font = "微软雅黑";
			this.tf.align = TextFormatAlign.CENTER;
			this.limit = new TextField();
			this.limit.wordWrap = true;
			this.limit.multiline = true;
			this.limit.textColor = 11776947;
			this._errStatusSp.addChild(this._bg);
			this._errStatusSp.addChild(this.limit);
			addChild(this._errStatusSp);
			this._errStatusSp.visible = false;
			this.resize(this._width,this._height);
		}
		
		private function addEvent() : void {
		}
		
		public function resize(param1:Number, param2:Number) : void {
			this._width = param1 < 0?0:param1;
			this._height = param2 < 0?0:param2;
			this._bg.width = this._width;
			this._bg.height = this._height;
			this.limit.width = this._width;
			this.limit.htmlText = PlayerConfig.ILLEGAL_INTERCEPT_DATA;
			this.limit.setTextFormat(this.tf);
			Utils.setCenterByNumber(this.limit,this._width,this._height);
		}
		
		public function get errStatusSp() : Sprite {
			return this._errStatusSp;
		}
		
		public function get tipFlagState() : String {
			return this._tipFlagState;
		}
		
		protected function dispatch(param1:String, param2:Object = null) : void {
			var _loc3_:MediaEvent = new MediaEvent(param1);
			_loc3_.obj = param2;
			dispatchEvent(_loc3_);
		}
	}
}
