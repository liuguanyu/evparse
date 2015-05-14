package com.qiyi.cupid.adplayer.utils
{
	import flash.utils.Dictionary;
	
	public class URLParser extends Object
	{
		
		private var _url:String;
		
		private var _host:String = "";
		
		private var _port:String = "";
		
		private var _protocol:String = "";
		
		private var _path:String = "";
		
		private var _parameters:Dictionary;
		
		private var _parameterArray:Array;
		
		public function URLParser(param1:String)
		{
			super();
			this._url = param1;
			this.parse();
		}
		
		public function getHost() : String
		{
			return this._host;
		}
		
		public function getPort() : String
		{
			return this._port;
		}
		
		public function getProtocol() : String
		{
			return this._protocol;
		}
		
		public function getPath() : String
		{
			return this._path;
		}
		
		public function getParameters() : Dictionary
		{
			return this._parameters;
		}
		
		public function getParameterArray() : Array
		{
			return this._parameterArray;
		}
		
		private function parse() : void
		{
			var _loc4:Array = null;
			var _loc5:String = null;
			var _loc6:Array = null;
			var _loc7:Dictionary = null;
			var _loc1:RegExp = new RegExp("((?P<protocol>[a-zA-Z]+) : \\/\\/)?  (?P<host>[^:\\/]*) (:(?P<port>\\d+))?  ((?P<path>[^?]*))? ((?P<parameters>.*))? ","x");
			var _loc2:Object = _loc1.exec(this._url);
			this._protocol = _loc2.protocol;
			this._host = _loc2.host;
			this._port = _loc2.port;
			this._path = _loc2.path;
			var _loc3:String = _loc2.parameters;
			if(_loc3 != "")
			{
				if(_loc3.charAt(0) == "?")
				{
					_loc3 = _loc3.substring(1);
				}
				this._parameters = new Dictionary();
				this._parameterArray = new Array();
				_loc4 = _loc3.split("&");
				for each(_loc5 in _loc4)
				{
					_loc6 = _loc5.split("=");
					this._parameters[_loc6[0]] = _loc6[1];
					_loc7 = new Dictionary();
					_loc7["key"] = _loc6[0];
					_loc7["value"] = _loc6[1];
					this._parameterArray.push(_loc7);
				}
			}
		}
	}
}
