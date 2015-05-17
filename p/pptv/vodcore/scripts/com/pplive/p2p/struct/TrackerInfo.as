package com.pplive.p2p.struct
{
	public class TrackerInfo extends Object
	{
		
		private var _ip:String;
		
		private var _port:uint;
		
		public function TrackerInfo(param1:String, param2:uint)
		{
			super();
			this._ip = param1;
			this._port = param2;
		}
		
		public function get ip() : String
		{
			return this._ip;
		}
		
		public function get port() : uint
		{
			return this._port;
		}
		
		public function toString() : String
		{
			return this._ip + ":" + this._port;
		}
	}
}
