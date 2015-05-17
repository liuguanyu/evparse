package com.pplive.util
{
	import flash.net.URLVariables;
	
	public class URI extends Object
	{
		
		private static const regexp:RegExp = new RegExp("(?:(http|https)://)?([-\\w\\d.]+)(?::(\\d+))?(/[-\\w\\d+&@#%=~_|!:,.;/]*)?(?:\\?(.*))?");
		
		public var protocol:String;
		
		public var host:String;
		
		public var port:uint;
		
		public var path:String;
		
		private var _variables:URLVariables;
		
		public function URI(param1:String)
		{
			this._variables = new URLVariables();
			super();
			var _loc2:Object = regexp.exec(param1);
			if(_loc2 != null)
			{
				this.protocol = _loc2[1];
				this.host = _loc2[2];
				this.port = uint(_loc2[3]);
				this.path = _loc2[4];
				if(_loc2[5])
				{
					this._variables.decode(_loc2[5]);
				}
			}
		}
		
		public static function transferToPPFixFilename(param1:String) : String
		{
			var _loc2:RegExp = new RegExp("%","g");
			return param1.replace(_loc2,"__");
		}
		
		public function toString(param1:Boolean) : String
		{
			var _loc3:String = null;
			var _loc4:Vector.<String> = null;
			var _loc5:* = undefined;
			var _loc2:String = this.protocol == null?"":this.protocol + "://";
			_loc2 = _loc2 + this.host;
			_loc2 = _loc2 + (this.port == 0?"":":" + this.port);
			_loc2 = _loc2 + (this.path == null?"":this.path);
			if(param1)
			{
				_loc3 = this._variables.toString();
				if(_loc3)
				{
					_loc2 = _loc2 + ("?" + _loc3);
				}
			}
			else
			{
				_loc4 = new Vector.<String>();
				for(_loc5 in this._variables)
				{
					_loc4.push(_loc5 + "=" + this._variables[_loc5]);
				}
				if(_loc4.length)
				{
					_loc2 = _loc2 + ("?" + _loc4.join("&"));
				}
			}
			return _loc2;
		}
		
		public function get variables() : URLVariables
		{
			return this._variables;
		}
	}
}
