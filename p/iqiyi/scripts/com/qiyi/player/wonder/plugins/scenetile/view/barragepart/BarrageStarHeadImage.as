package com.qiyi.player.wonder.plugins.scenetile.view.barragepart
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.display.Loader;
	import com.qiyi.player.base.logging.ILogger;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import com.qiyi.player.base.logging.Log;
	
	public class BarrageStarHeadImage extends EventDispatcher
	{
		
		private static var _instance:BarrageStarHeadImage;
		
		public static const COMPLETE:String = "COMPLETE";
		
		private var _imgDic:Dictionary;
		
		private var _waitLoadVec:Vector.<String>;
		
		private var _loader:Loader;
		
		private var _isInit:Boolean = false;
		
		private var _loading:Boolean = false;
		
		private var _log:ILogger;
		
		public function BarrageStarHeadImage()
		{
			this._log = Log.getLogger("com.qiyi.player.wonder.plugins.scenetile.view.barragepart.BarrageStarHeadImage");
			super();
		}
		
		public static function get instance() : BarrageStarHeadImage
		{
			return _instance = _instance || new BarrageStarHeadImage();
		}
		
		public function init() : void
		{
			this._isInit = true;
			this._imgDic = new Dictionary();
			this._waitLoadVec = new Vector.<String>();
		}
		
		public function getHeadImageByUrl(param1:String) : BitmapData
		{
			if(!this._isInit)
			{
				this.init();
			}
			var _loc2:Bitmap = this._imgDic[param1];
			if(_loc2)
			{
				return this._imgDic[param1].bitmapData;
			}
			this.imgLoader(param1);
			return null;
		}
		
		private function imgLoader(param1:String) : void
		{
			var i:uint = 0;
			var var_36:String = param1;
			if(!this._loading)
			{
				this._log.debug("BarrageStarHeadImage request star head image imgUrl : " + var_36);
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
					_log.debug("BarrageStarHeadImage request star head image Error" + error);
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
			var var_5:Event = param1;
			this._loading = false;
			try
			{
				bitmap = new Bitmap((this._loader.content as Bitmap).bitmapData);
				this._imgDic[var_5.target.url] = bitmap;
				dispatchEvent(new Event(COMPLETE));
				this._log.debug("BarrageStarHeadImage request star head image Complete");
			}
			catch(error:Error)
			{
				_log.debug("BarrageStarHeadImage star head image Complete Error:" + error);
			}
			if(this._waitLoadVec.length > 0)
			{
				this.imgLoader(this._waitLoadVec.pop());
			}
		}
		
		private function onErrorHandler(param1:Event) : void
		{
			this._loading = false;
			if(this._waitLoadVec.length > 0)
			{
				this.imgLoader(this._waitLoadVec.shift());
			}
			this._log.debug("BarrageStarHeadImage request star head image Error");
		}
	}
}
