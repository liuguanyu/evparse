package com.qiyi.player.wonder.plugins.scenetile.view.barragepart {
	import flash.events.EventDispatcher;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import com.qiyi.player.wonder.common.config.SystemConfig;
	import flash.system.LoaderContext;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public class BarrageExpressionImage extends EventDispatcher {
		
		public function BarrageExpressionImage() {
			super();
		}
		
		private static var _instance:BarrageExpressionImage;
		
		public static const COMPLETE:String = "";
		
		private static const WIDTH:uint = 42;
		
		private static const HEIGTH:uint = 42;
		
		private static const GAP:uint = 5;
		
		public static function get instance() : BarrageExpressionImage {
			return _instance = _instance || new BarrageExpressionImage();
		}
		
		private var _loader:Loader;
		
		private var _expImage:Bitmap;
		
		private var _bitmapDataVec:Vector.<BitmapData>;
		
		private var _regExp:RegExp;
		
		private var _inited:Boolean = false;
		
		private var _loading:Boolean = false;
		
		public function init() : void {
			if(this._inited) {
				return;
			}
			this.tryLoad();
			this._regExp = new RegExp("^\\d{3}$");
			this._bitmapDataVec = new Vector.<BitmapData>();
			this._inited = true;
		}
		
		private function tryLoad() : void {
			if(!this._loading && !this._expImage) {
				try {
					if(this._loader) {
						this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplete);
						this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOErrorHandler);
						this._loader.close();
						this._loader = null;
					}
				}
				catch(error:Error) {
				}
				this._loader = new Loader();
				this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplete);
				this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIOErrorHandler);
				this._loading = true;
				this._loader.load(new URLRequest(SystemConfig.BARRAGE_EXPRESSION_IMAGE_URL),new LoaderContext(true));
			}
			if(!this._loading && !this._expImage) {
				return;
			}
		}
		
		private function onLoadComplete(param1:Event) : void {
			var _loc2_:BitmapData = null;
			var _loc3_:Matrix = null;
			var _loc4_:uint = 0;
			this._expImage = this._loader.content as Bitmap;
			this._loading = false;
			if(this._expImage != null) {
				while(this._bitmapDataVec.length > 0) {
					_loc2_ = this._bitmapDataVec.pop();
					_loc2_ = null;
				}
				_loc4_ = 0;
				while(_loc4_ < Math.floor(this._expImage.width / (WIDTH + GAP))) {
					_loc3_ = new Matrix();
					_loc2_ = new BitmapData(WIDTH,HEIGTH,true,0);
					_loc3_.tx = -_loc4_ * (WIDTH + GAP) - GAP;
					_loc2_.draw(this._expImage.bitmapData,_loc3_,null,null,new Rectangle(0,0,WIDTH,HEIGTH));
					this._bitmapDataVec.push(_loc2_);
					_loc4_++;
				}
				dispatchEvent(new Event(COMPLETE));
			}
		}
		
		private function onIOErrorHandler(param1:IOErrorEvent) : void {
			this._loading = false;
		}
		
		public function getBitmapdataByContent(param1:String) : BitmapData {
			var _loc2_:String = null;
			var _loc3_:uint = 0;
			if(!this._expImage) {
				this.tryLoad();
				return null;
			}
			if(this.isFaceContent(param1)) {
				_loc2_ = param1.substr(1,param1.length - 2);
				if(!this._regExp.test(_loc2_)) {
					return null;
				}
				_loc3_ = uint(_loc2_);
				if(this._bitmapDataVec.length <= _loc3_) {
					return null;
				}
				return this._bitmapDataVec[_loc3_];
			}
			return null;
		}
		
		public function isFaceContent(param1:String) : Boolean {
			if(param1) {
				return param1.substr(0,1) == "[" && param1.substr(param1.length - 1,1) == "]";
			}
			return false;
		}
	}
}