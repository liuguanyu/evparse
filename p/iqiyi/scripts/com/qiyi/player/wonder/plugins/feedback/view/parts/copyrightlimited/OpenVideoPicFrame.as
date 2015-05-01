package com.qiyi.player.wonder.plugins.feedback.view.parts.copyrightlimited {
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	public class OpenVideoPicFrame extends Sprite {
		
		public function OpenVideoPicFrame(param1:int, param2:int, param3:String, param4:uint, param5:uint, param6:int) {
			super();
			this._picW = param1;
			this._picH = param2;
			this._picUrl = param3;
			this._bgColor = param4;
			this._lineColor = param5;
			this._margin = param6;
			graphics.lineStyle(1,this._lineColor);
			graphics.beginFill(this._bgColor,1);
			graphics.drawRect(0,0,this._picW + this._margin * 2,this._picH + this._margin * 2);
			graphics.endFill();
			addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
			addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
			this.loadPicture();
		}
		
		private var _picW:int;
		
		private var _picH:int;
		
		private var _picUrl:String;
		
		private var _bgColor:uint;
		
		private var _lineColor:int;
		
		private var _margin:int;
		
		private var _loader:Loader;
		
		private function onRollOver(param1:MouseEvent) : void {
			graphics.clear();
			graphics.lineStyle(2,8562957);
			graphics.beginFill(this._bgColor,1);
			graphics.drawRect(0,0,this._picW + this._margin * 2,this._picH + this._margin * 2);
			graphics.endFill();
		}
		
		private function onRollOut(param1:MouseEvent) : void {
			graphics.clear();
			graphics.lineStyle(1,this._lineColor);
			graphics.beginFill(this._bgColor,1);
			graphics.drawRect(0,0,this._picW + this._margin * 2,this._picH + this._margin * 2);
			graphics.endFill();
		}
		
		private function loadPicture() : void {
			var _loc1_:URLRequest = new URLRequest(this._picUrl);
			this._loader = new Loader();
			this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplete);
			this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIOErrorHandler);
			this._loader.load(_loc1_);
		}
		
		private function onLoadComplete(param1:Event) : void {
			this._loader.width = this._picW;
			this._loader.height = this._picH;
			addChild(this._loader);
			this._loader.x = this._loader.y = this._margin;
		}
		
		private function onIOErrorHandler(param1:IOErrorEvent) : void {
		}
	}
}
