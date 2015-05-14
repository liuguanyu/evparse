package com.qiyi.player.wonder.plugins.controllbar.view.preview.image
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import com.qiyi.player.base.logging.ILogger;
	import com.qiyi.player.wonder.common.config.SystemConfig;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.geom.Rectangle;
	import com.qiyi.player.wonder.plugins.controllbar.ControllBarDef;
	import flash.geom.Point;
	import com.qiyi.player.base.logging.Log;
	
	public class PreviewImageLoader extends EventDispatcher
	{
		
		private static var _instance:PreviewImageLoader;
		
		public static const COMPLETE:String = "COMPLETE";
		
		private var _imgDic:Dictionary;
		
		private var _waitLoadVec:Vector.<String>;
		
		private var _loader:Loader;
		
		private var _defaultImage:Bitmap;
		
		private var _isInit:Boolean = false;
		
		private var _loading:Boolean = false;
		
		private var _log:ILogger;
		
		public function PreviewImageLoader()
		{
			this._log = Log.getLogger("com.qiyi.player.wonder.plugins.controllbar.view.preview.image.PreviewImageLoader");
			super();
		}
		
		public static function get instance() : PreviewImageLoader
		{
			return _instance = _instance || new PreviewImageLoader();
		}
		
		public function init() : void
		{
			this._isInit = true;
			this._imgDic = new Dictionary();
			this._waitLoadVec = new Vector.<String>();
			this.imgLoader(SystemConfig.DEFAULT_IMAGE_URL);
		}
		
		public function getImageByIndex(param1:int) : BitmapData
		{
			if(!this._isInit)
			{
				this.init();
			}
			var _loc2:BitmapData = this._imgDic[param1];
			if(_loc2)
			{
				return _loc2;
			}
			return null;
		}
		
		public function getDefaultImage() : BitmapData
		{
			if(!this._isInit)
			{
				this.init();
			}
			if(this._defaultImage)
			{
				return this._defaultImage.bitmapData;
			}
			return null;
		}
		
		public function imgLoader(param1:String) : void
		{
			var i:uint = 0;
			var var_36:String = param1;
			if(!this._loading)
			{
				this._log.debug("PreviewImageLoader request image imgUrl = " + var_36);
				try
				{
					if(this._loader)
					{
						this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplete);
						this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onErrorHandler);
						this._loader.close();
						this._loader = null;
					}
				}
				catch(error:Error)
				{
					_log.debug("PreviewImageLoader request image Error = " + error);
				}
				this._loader = new Loader();
				this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplete);
				this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onErrorHandler);
				this._loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onErrorHandler);
				this._loading = true;
				this._loader.load(new URLRequest(var_36),new LoaderContext(true));
			}
			else
			{
				i = 0;
				while(i < this._waitLoadVec.length)
				{
					if(this._waitLoadVec[i] == var_36)
					{
						return;
					}
					i++;
				}
				this._waitLoadVec.push(var_36);
			}
			if(!this._loading)
			{
				return;
			}
		}
		
		private function onLoadComplete(param1:Event) : void
		{
			var bitmap:Bitmap = null;
			var imageIndex:int = 0;
			var strArr:Array = null;
			var strArr1:Array = null;
			var bitmapData:BitmapData = null;
			var rec:Rectangle = null;
			var i:int = 0;
			var j:int = 0;
			var var_5:Event = param1;
			this._loading = false;
			try
			{
				bitmap = new Bitmap((this._loader.content as Bitmap).bitmapData);
				imageIndex = 0;
				if(var_5.target.url == SystemConfig.DEFAULT_IMAGE_URL)
				{
					if(!this._defaultImage)
					{
						this._defaultImage = new Bitmap();
						this._defaultImage.bitmapData = bitmap.bitmapData;
					}
				}
				else
				{
					strArr = var_5.target.url.split(".jpg");
					if(strArr.length > 0)
					{
						strArr1 = strArr[0].split("_");
						if(strArr1.length > 0)
						{
							imageIndex = int(strArr1[strArr1.length - 1]);
						}
					}
					if(imageIndex > 0)
					{
						i = 0;
						while(i < ControllBarDef.IMAGE_PRE_BIG_ROW)
						{
							j = 0;
							while(j < ControllBarDef.IMAGE_PRE_BIG_COL)
							{
								rec = new Rectangle();
								rec.x = j * ControllBarDef.IMAGE_PRE_SMALL_SIZE.x;
								rec.y = i * ControllBarDef.IMAGE_PRE_SMALL_SIZE.y;
								rec.width = ControllBarDef.IMAGE_PRE_SMALL_SIZE.x;
								rec.height = ControllBarDef.IMAGE_PRE_SMALL_SIZE.y;
								bitmapData = new BitmapData(ControllBarDef.IMAGE_PRE_SMALL_SIZE.x,ControllBarDef.IMAGE_PRE_SMALL_SIZE.y,true,0);
								bitmapData.copyPixels(bitmap.bitmapData,rec,new Point(0,0));
								this._imgDic[(imageIndex - 1) * 100 + i * ControllBarDef.IMAGE_PRE_BIG_ROW + j] = bitmapData;
								j++;
							}
							i++;
						}
					}
					dispatchEvent(new Event(COMPLETE));
				}
				this._log.debug("PreviewImageLoader request image Complete");
			}
			catch(error:Error)
			{
				_log.debug("PreviewImageLoader json Error:" + error);
			}
			if(this._waitLoadVec.length > 0)
			{
				this.imgLoader(this._waitLoadVec.pop());
			}
		}
		
		public function clearImageData() : void
		{
			var _loc1:Object = null;
			var _loc2:BitmapData = null;
			for(_loc1 in this._imgDic)
			{
				_loc2 = this._imgDic[_loc1];
				delete this._imgDic[_loc1];
				true;
				_loc2 = null;
				_loc1 = null;
			}
		}
		
		private function onErrorHandler(param1:Event) : void
		{
			this._loading = false;
			if(this._waitLoadVec.length > 0)
			{
				this.imgLoader(this._waitLoadVec.shift());
			}
			this._log.debug("PreviewImageLoader request image Error");
		}
	}
}
