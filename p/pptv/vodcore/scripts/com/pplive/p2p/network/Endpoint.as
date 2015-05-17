package com.pplive.p2p.network
{
	import de.polygonal.ds.Comparable;
	
	public class Endpoint extends Object implements Comparable
	{
		
		private var _ip:String;
		
		private var _port:uint;
		
		public function Endpoint(param1:String, param2:uint)
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
		
		public function compare(param1:Object) : int
		{
			var _loc2:Endpoint = param1 as Endpoint;
			if(this.ip < _loc2.ip)
			{
				return -1;
			}
			if(this.ip > _loc2.ip)
			{
				return 1;
			}
			if(this.port < _loc2.port)
			{
				return -1;
			}
			if(this.port > _loc2.port)
			{
				return 1;
			}
			return 0;
		}
		
		public function toString() : String
		{
			return this.ip + ":" + this.port;
		}
	}
}
