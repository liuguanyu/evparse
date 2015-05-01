package com.qiyi.player.wonder.plugins.feedback.view.parts.copyrightexpired {
	import flash.display.Sprite;
	import com.qiyi.player.wonder.plugins.recommend.model.RecommendVO;
	import flash.display.Shape;
	import flash.display.Loader;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.MouseEvent;
	import com.qiyi.player.wonder.common.config.SystemConfig;
	import flash.net.URLRequest;
	import com.qiyi.player.wonder.common.ui.FastCreator;
	import flash.text.TextFormat;
	
	public class CopyrightExpiredRecommendItem extends Sprite {
		
		public function CopyrightExpiredRecommendItem(param1:RecommendVO) {
			var _loc4_:Array = null;
			var _loc5_:* = 0;
			var _loc6_:String = null;
			super();
			this._data = param1;
			this._imageLine = new Shape();
			this._imageLine.graphics.beginFill(6645093);
			this._imageLine.graphics.drawRect(0,0,ITEM_WIDTH,68);
			this._imageLine.graphics.endFill();
			this._imageLine.visible = false;
			addChild(this._imageLine);
			this.useHandCursor = this.buttonMode = true;
			var _loc2_:String = this._data.picUrl;
			if(_loc2_ == null || _loc2_ == "") {
				_loc2_ = SystemConfig.DEFAULT_IMAGE_URL;
			} else {
				_loc4_ = _loc2_.match(new RegExp("_\\d+_\\d+\\."));
				if((_loc4_) && _loc4_.length > 0) {
					_loc2_ = _loc2_.replace(new RegExp("_\\d+_\\d+\\."),"_116_65.");
				} else {
					_loc5_ = _loc2_.lastIndexOf(".");
					_loc6_ = _loc2_.substr(0,_loc5_);
					_loc6_ = _loc6_ + "_116_65";
					_loc6_ = _loc6_ + _loc2_.substr(_loc5_);
					_loc2_ = _loc6_;
				}
			}
			this._loader = new Loader();
			this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onComplete);
			this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
			this._loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onIOError);
			this._loader.load(new URLRequest(_loc2_));
			this._loader.mouseChildren = this._loader.mouseEnabled = false;
			addChild(this._loader);
			var _loc3_:String = this._data.videoName.length > 17?this._data.videoName.slice(0,17) + "...":this._data.videoName;
			this._tfVideoName = FastCreator.createLabel("",16777215,12);
			this._tfVideoName.y = 67;
			this._tfVideoName.x = 0;
			this._tfVideoName.width = ITEM_WIDTH;
			addChild(this._tfVideoName);
			this._tfVideoName.wordWrap = true;
			this._tfVideoName.defaultTextFormat = new TextFormat(FastCreator.FONT_MSYH,12,16777215,false,null,null,null,null,"center");
			this._tfVideoName.text = _loc3_;
			this._tfVideoName.selectable = this._tfVideoName.mouseEnabled = false;
			addEventListener(MouseEvent.MOUSE_OVER,this.onRollOver);
			addEventListener(MouseEvent.MOUSE_OUT,this.onRollOut);
		}
		
		public static const ITEM_WIDTH:uint = 118;
		
		private var _data:RecommendVO;
		
		private var _imageLine:Shape;
		
		private var _loader:Loader;
		
		private var _tfVideoName:TextField;
		
		public function get data() : RecommendVO {
			return this._data;
		}
		
		private function onComplete(param1:Event) : void {
			this._loader.x = this._loader.y = 1;
			this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onComplete);
			this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
			this._loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onIOError);
		}
		
		private function onIOError(param1:Event) : void {
			this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onComplete);
			this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
			this._loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onIOError);
		}
		
		private function onRollOver(param1:MouseEvent) : void {
			this._imageLine.graphics.clear();
			this._imageLine.graphics.beginFill(16777215);
			this._imageLine.graphics.drawRect(0,0,ITEM_WIDTH,68);
			this._imageLine.graphics.endFill();
			this._imageLine.visible = true;
		}
		
		private function onRollOut(param1:MouseEvent) : void {
			this._imageLine.graphics.clear();
			this._imageLine.visible = false;
		}
		
		public function destroy() : void {
			this._imageLine.graphics.clear();
			if(this._imageLine.parent) {
				removeChild(this._imageLine);
			}
			this._data = null;
			this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onComplete);
			this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
			this._loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onIOError);
			if(this._loader.parent) {
				removeChild(this._loader);
			}
			this._loader = null;
		}
	}
}
