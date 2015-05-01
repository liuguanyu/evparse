package com.sohu.tv.mediaplayer.ui {
	import flash.display.Sprite;
	import flash.utils.*;
	import com.sohu.tv.mediaplayer.PlayerConfig;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import ebing.BitmapBytes;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	public class TvSohuPicPreview extends Sprite {
		
		public function TvSohuPicPreview() {
			super();
			this._arrayBigBlocks = new Array();
			this._arraySmallBlocks = new Array();
		}
		
		protected var _bigImgWidth:Number = 160;
		
		protected var _bigImgHeight:Number = 68;
		
		protected var _smallImgWidth:Number = 60;
		
		protected var _smallImgHeight:Number = 34;
		
		protected var _timeLimit:Number = 15;
		
		protected var _bigPicUrl:String = "";
		
		protected var _smallPicUrl:String = "";
		
		protected var _arrayBigBlocks:Array;
		
		protected var _arraySmallBlocks:Array;
		
		protected var _totalBlocks:Number = 50;
		
		protected var _MaxBlock:Number = 50;
		
		private var _bigPicBytes:ByteArray;
		
		public function hardInit(param1:Object = null) : void {
			if(param1 != null) {
				this._bigPicUrl = param1.bigPicUrl;
				this._bigImgWidth = this._bigPicUrl.split(".jpg")[0].split("_")[this._bigPicUrl.split(".jpg")[0].split("_").length - 3];
				this._bigImgHeight = this._bigPicUrl.split(".jpg")[0].split("_")[this._bigPicUrl.split(".jpg")[0].split("_").length - 2];
				this._timeLimit = this._bigPicUrl.split(".jpg")[0].split("_")[this._bigPicUrl.split(".jpg")[0].split("_").length - 1];
				this._totalBlocks = Math.ceil(PlayerConfig.totalDuration / this._timeLimit) + 1;
			}
			this.sysInit("start");
		}
		
		protected function sysInit(param1:String = null) : void {
			if(param1 == "start") {
				this.newFunc();
				this.drawSkin();
				this.addEvent();
			}
		}
		
		protected function newFunc() : void {
		}
		
		public function startLoadPic() : void {
			this.initPicArr();
			this.sendRequest("big",this._bigPicUrl);
		}
		
		public function initPicArr() : void {
			this._arrayBigBlocks = [];
			this._arraySmallBlocks = [];
		}
		
		private function sendRequest(param1:String, param2:String) : void {
			var m_request:URLRequest = null;
			var m_loader:URLLoader = null;
			var flag:String = param1;
			var p_url:String = param2;
			try {
				m_request = new URLRequest(p_url);
				m_loader = new URLLoader();
				m_loader.dataFormat = URLLoaderDataFormat.BINARY;
				m_loader.addEventListener(Event.COMPLETE,function(param1:*):void {
					onSendComplete(param1,flag);
				});
				m_loader.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
				m_loader.load(m_request);
			}
			catch(err:Error) {
			}
		}
		
		private function onSendComplete(param1:Event, param2:String = null) : void {
			var e:Event = param1;
			var flag:String = param2;
			var m_content:ByteArray = e.target.data as ByteArray;
			var _loader:Loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(param1:*):void {
				onLoadComplete(param1,flag);
			});
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
			_loader.loadBytes(m_content);
			var urlLoader:URLLoader = URLLoader(e.target);
			urlLoader.removeEventListener(Event.COMPLETE,this.onSendComplete);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
		}
		
		private function onLoadComplete(param1:Event, param2:String = null) : void {
			var _loc3_:BitmapData = (param1.target.content as Bitmap).bitmapData;
			if(param2 == "big") {
				this._bigPicBytes = new ByteArray();
				this._bigPicBytes = BitmapBytes.encodeByteArray(_loc3_);
				this._arrayBigBlocks = this.getBitMapArr(_loc3_,this._bigImgWidth,this._bigImgHeight);
				dispatchEvent(new Event("bigComplete"));
				this.sendRequest("small",this._bigPicUrl);
			}
			if(param2 == "small") {
				this._arraySmallBlocks = this.getBitMapArr(_loc3_,this._bigImgWidth,this._bigImgHeight);
				dispatchEvent(new Event("smallComplete"));
			}
			var _loc4_:Loader = Loader(param1.target.loader);
			_loc4_.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplete);
			_loc4_.unloadAndStop();
			_loc4_ = null;
		}
		
		private function ioErrorHandler(param1:IOErrorEvent) : void {
		}
		
		private function getHorNum(param1:Number) : Array {
			var _loc2_:Array = new Array();
			var _loc3_:* = 0;
			while(_loc3_ < param1) {
				if(_loc3_ == param1 - 1) {
					_loc2_.push(this._totalBlocks - this._MaxBlock * _loc3_);
				} else {
					_loc2_.push(this._MaxBlock);
				}
				_loc3_++;
			}
			return _loc2_;
		}
		
		private function getBitMapArr(param1:BitmapData, param2:Number, param3:Number) : Array {
			var _loc8_:* = 0;
			var _loc9_:BitmapData = null;
			var _loc10_:Bitmap = null;
			var _loc4_:Array = new Array();
			var _loc5_:Number = Math.ceil(this._totalBlocks / this._MaxBlock);
			var _loc6_:Array = this.getHorNum(_loc5_);
			var _loc7_:* = 0;
			while(_loc7_ < _loc5_) {
				_loc8_ = 0;
				while(_loc8_ < _loc6_[_loc7_]) {
					_loc9_ = new BitmapData(param2,param3);
					_loc9_.copyPixels(param1,new Rectangle(_loc8_ * param2,_loc7_ * param3,param2,param3),new Point(0,0));
					_loc10_ = new Bitmap(_loc9_);
					_loc4_.push(_loc10_);
					_loc8_++;
				}
				_loc7_++;
			}
			param1.dispose();
			return _loc4_;
		}
		
		protected function drawSkin() : void {
		}
		
		protected function addEvent() : void {
		}
		
		public function resize(param1:Number, param2:Number) : void {
		}
		
		protected function setEleStatus() : void {
		}
		
		public function get arrayBigBlocks() : Array {
			return this._arrayBigBlocks;
		}
		
		public function get arraySmallBlocks() : Array {
			return this._arraySmallBlocks;
		}
		
		public function get totalBlocks() : Number {
			return this._totalBlocks;
		}
		
		public function get timeLimit() : Number {
			return this._timeLimit;
		}
		
		public function get bWidth() : Number {
			return this._bigImgWidth;
		}
		
		public function get bHeight() : Number {
			return this._bigImgHeight;
		}
		
		public function get bigPicBytes() : ByteArray {
			return this._bigPicBytes;
		}
	}
}
