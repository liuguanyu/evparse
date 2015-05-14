package com.qiyi.player.wonder.plugins.feedback.view.parts.copyrightexpired
{
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
	
	public class CopyrightExpiredRecommendItem extends Sprite
	{
		
		public static const ITEM_WIDTH:uint = 118;
		
		private var _data:RecommendVO;
		
		private var _imageLine:Shape;
		
		private var _loader:Loader;
		
		private var _tfVideoName:TextField;
		
		public function CopyrightExpiredRecommendItem(param1:RecommendVO)
		{
			var _loc4:Array = null;
			var _loc5:* = 0;
			var _loc6:String = null;
			super();
			this._data = param1;
			this._imageLine = new Shape();
			this._imageLine.graphics.beginFill(6645093);
			this._imageLine.graphics.drawRect(0,0,ITEM_WIDTH,68);
			this._imageLine.graphics.endFill();
			this._imageLine.visible = false;
			addChild(this._imageLine);
			this.useHandCursor = this.buttonMode = true;
			var _loc2:String = this._data.picUrl;
			if(_loc2 == null || _loc2 == "")
			{
				_loc2 = SystemConfig.DEFAULT_IMAGE_URL;
			}
			else
			{
				_loc4 = _loc2.match(new RegExp("_\\d+_\\d+\\."));
				if((_loc4) && _loc4.length > 0)
				{
					_loc2 = _loc2.replace(new RegExp("_\\d+_\\d+\\."),"_116_65.");
				}
				else
				{
					_loc5 = _loc2.lastIndexOf(".");
					_loc6 = _loc2.substr(0,_loc5);
					_loc6 = _loc6 + "_116_65";
					_loc6 = _loc6 + _loc2.substr(_loc5);
					_loc2 = _loc6;
				}
			}
			this._loader = new Loader();
			this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onComplete);
			this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
			this._loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onIOError);
			this._loader.load(new URLRequest(_loc2));
			this._loader.mouseChildren = this._loader.mouseEnabled = false;
			addChild(this._loader);
			var _loc3:String = this._data.videoName.length > 17?this._data.videoName.slice(0,17) + "...":this._data.videoName;
			this._tfVideoName = FastCreator.createLabel("",16777215,12);
			this._tfVideoName.y = 67;
			this._tfVideoName.x = 0;
			this._tfVideoName.width = ITEM_WIDTH;
			addChild(this._tfVideoName);
			this._tfVideoName.wordWrap = true;
			this._tfVideoName.defaultTextFormat = new TextFormat(FastCreator.FONT_MSYH,12,16777215,false,null,null,null,null,"center");
			this._tfVideoName.text = _loc3;
			this._tfVideoName.selectable = this._tfVideoName.mouseEnabled = false;
			addEventListener(MouseEvent.MOUSE_OVER,this.onRollOver);
			addEventListener(MouseEvent.MOUSE_OUT,this.onRollOut);
		}
		
		public function get data() : RecommendVO
		{
			return this._data;
		}
		
		private function onComplete(param1:Event) : void
		{
			this._loader.x = this._loader.y = 1;
			this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onComplete);
			this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
			this._loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onIOError);
		}
		
		private function onIOError(param1:Event) : void
		{
			this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onComplete);
			this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
			this._loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onIOError);
		}
		
		private function onRollOver(param1:MouseEvent) : void
		{
			this._imageLine.graphics.clear();
			this._imageLine.graphics.beginFill(16777215);
			this._imageLine.graphics.drawRect(0,0,ITEM_WIDTH,68);
			this._imageLine.graphics.endFill();
			this._imageLine.visible = true;
		}
		
		private function onRollOut(param1:MouseEvent) : void
		{
			this._imageLine.graphics.clear();
			this._imageLine.visible = false;
		}
		
		public function destroy() : void
		{
			this._imageLine.graphics.clear();
			if(this._imageLine.parent)
			{
				removeChild(this._imageLine);
			}
			this._data = null;
			this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onComplete);
			this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
			this._loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onIOError);
			if(this._loader.parent)
			{
				removeChild(this._loader);
			}
			this._loader = null;
		}
	}
}
