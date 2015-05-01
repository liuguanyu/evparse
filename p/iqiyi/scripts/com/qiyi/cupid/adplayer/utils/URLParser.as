package com.qiyi.cupid.adplayer.utils {
	import flash.utils.Dictionary;
	
	public class URLParser extends Object {
		
		public function URLParser(param1:String) {
			super();
			this._url = param1;
			this.parse();
		}
		
		private var _url:String;
		
		private var _host:String = "";
		
		private var _port:String = "";
		
		private var _protocol:String = "";
		
		private var _path:String = "";
		
		private var _parameters:Dictionary;
		
		private var _parameterArray:Array;
		
		public function getHost() : String {
			return this._host;
		}
		
		public function getPort() : String {
			return this._port;
		}
		
		public function getProtocol() : String {
			return this._protocol;
		}
		
		public function getPath() : String {
			return this._path;
		}
		
		public function getParameters() : Dictionary {
			return this._parameters;
		}
		
		public function getParameterArray() : Array {
			return this._parameterArray;
		}
		
		private function parse() : void {
			var _loc4_:Array = null;
			var _loc5_:String = null;
			var _loc6_:Array = null;
			var _loc7_:Dictionary = null;
			var _loc1_:RegExp = new RegExp("((?P<protocol>[a-zA-Z]+) : \\/\\/)?  (?P<host>[^:\\/]*) (:(?P<port>\\d+))?  ((?P<path>[^?]*))? ((?P<parameters>.*))? ","x");
			var _loc2_:Object = _loc1_.exec(this._url);
			this._protocol = _loc2_.protocol;
			this._host = _loc2_.host;
			this._port = _loc2_.port;
			this._path = _loc2_.path;
			var _loc3_:String = _loc2_.parameters;
			if(_loc3_ != "") {
				if(_loc3_.charAt(0) == "?") {
					_loc3_ = _loc3_.substring(1);
				}
				this._parameters = new Dictionary();
				this._parameterArray = new Array();
				_loc4_ = _loc3_.split("&");
				for each(_loc5_ in _loc4_) {
					_loc6_ = _loc5_.split("=");
					this._parameters[_loc6_[0]] = _loc6_[1];
					_loc7_ = new Dictionary();
					_loc7_["key"] = _loc6_[0];
					_loc7_["value"] = _loc6_[1];
					this._parameterArray.push(_loc7_);
				}
			}
		}
	}
}
