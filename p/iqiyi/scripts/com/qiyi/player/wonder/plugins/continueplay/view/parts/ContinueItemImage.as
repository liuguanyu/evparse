package com.qiyi.player.wonder.plugins.continueplay.view.parts
{
	import flash.display.Loader;
	import flash.utils.Dictionary;
	import com.qiyi.player.wonder.common.config.SystemConfig;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.events.IOErrorEvent;
	
	public class ContinueItemImage extends Loader
	{
		
		private static const IMAGE_CACHE:Dictionary = new Dictionary();
		
		private static const MAX_RETRY_COUNT:int = 2;
		
		private var _url:String = "";
		
		private var _curRetryCount:int = 0;
		
		public function ContinueItemImage()
		{
			super();
			contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
		}
		
		public static function getImage(param1:String) : ContinueItemImage
		{
			var _loc3:Array = null;
			var _loc4:* = 0;
			var _loc5:String = null;
			if(param1 == null || param1 == "")
			{
				var param1:String = SystemConfig.DEFAULT_IMAGE_URL;
			}
			else
			{
				_loc3 = param1.match(new RegExp("_\\d+_\\d+\\."));
				if((_loc3) && _loc3.length > 0)
				{
					param1 = param1.replace(new RegExp("_\\d+_\\d+\\."),"_116_65.");
				}
				else
				{
					_loc4 = param1.lastIndexOf(".");
					_loc5 = param1.substr(0,_loc4);
					_loc5 = _loc5 + "_116_65";
					_loc5 = _loc5 + param1.substr(_loc4);
					param1 = _loc5;
				}
			}
			var _loc2:ContinueItemImage = null;
			if(IMAGE_CACHE[param1] == null || param1 == SystemConfig.DEFAULT_IMAGE_URL)
			{
				_loc2 = new ContinueItemImage();
				_loc2.load(new URLRequest(param1),new LoaderContext(true));
				IMAGE_CACHE[param1] = _loc2;
			}
			else
			{
				_loc2 = IMAGE_CACHE[param1] as ContinueItemImage;
			}
			return _loc2;
		}
		
		override public function load(param1:URLRequest, param2:LoaderContext = null) : void
		{
			this._url = param1.url;
			super.load(param1,param2);
		}
		
		private function onIOError(param1:IOErrorEvent) : void
		{
			if(this._curRetryCount < MAX_RETRY_COUNT)
			{
				this._curRetryCount++;
				this.load(new URLRequest(this._url),new LoaderContext(true));
			}
		}
	}
}
