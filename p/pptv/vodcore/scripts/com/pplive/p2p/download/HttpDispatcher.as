package com.pplive.p2p.download
{
	import com.pplive.p2p.ResourceCache;
	import com.pplive.p2p.Util;
	import com.pplive.p2p.struct.Constants;
	import com.pplive.p2p.struct.SubPiece;
	import flash.events.Event;
	
	class HttpDispatcher extends Dispatcher
	{
		
		protected var _downloader:IDownloader;
		
		function HttpDispatcher(param1:ResourceCache, param2:IDownloader)
		{
			super(param1);
			this._downloader = param2;
		}
		
		public static function fixRequestRange(param1:ResourceCache, param2:uint, param3:uint, param4:uint = 16) : Object
		{
			var _loc7:uint = 0;
			var param3:uint = Util.upAlign(param3 > 0 && param3 < param1.length?param3:param1.length,Constants.SUBPIECE_SIZE);
			var _loc5:SubPiece = param1.getFirstSubPieceMissed(param2);
			if(_loc5.offset >= param3 || _loc5.offset >= param1.length)
			{
				return null;
			}
			var _loc6:Object = new Object();
			_loc6.begin = _loc5.offset;
			while(_loc5.offset < param3)
			{
				while(_loc5.offset < param3 && !param1.hasSubPiece(_loc5))
				{
					_loc5.moveToNextSubPiece();
				}
				_loc6.end = _loc5.offset;
				_loc7 = 0;
				while(param1.hasSubPiece(_loc5))
				{
					_loc5.moveToNextSubPiece();
					if(++_loc7 >= param4)
					{
						break;
					}
				}
				if(_loc7 >= param4)
				{
					break;
				}
			}
			if(_loc6.end >= param1.length)
			{
				_loc6.end = 0;
			}
			return _loc6;
		}
		
		override public function get currentMethod() : String
		{
			return "HTTP";
		}
		
		override public function set restPlayTime(param1:Number) : void
		{
			_restPlayTime = param1;
			this._downloader.restPlayTime = param1;
		}
		
		override public function requestHeader() : void
		{
			this.stop();
			_requestHeader = true;
			_offset = -1;
			this.doRequest();
		}
		
		override public function request(param1:uint) : void
		{
			this.stop();
			_requestHeader = false;
			_offset = param1;
			this.doRequest();
		}
		
		override public function stop() : void
		{
			this._downloader.removeEventListener(Event.COMPLETE,this.onHttpComplete);
			this._downloader.cancel();
		}
		
		protected function doRequest() : void
		{
			var _loc1:Object = null;
			this._downloader.addEventListener(Event.COMPLETE,this.onHttpComplete,false,0,true);
			if(_requestHeader)
			{
				_loc1 = fixRequestRange(_resource,0,_resource.headLength);
			}
			else
			{
				_loc1 = fixRequestRange(_resource,_offset,0);
			}
			if(_loc1)
			{
				this._downloader.request(_loc1.begin,_loc1.end);
			}
			else
			{
				this.stop();
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		protected function onHttpComplete(param1:Event) : void
		{
			this.doRequest();
		}
	}
}
