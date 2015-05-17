package com.pplive.p2p.struct
{
	public class TcpPeerInfo extends PeerInfo
	{
		
		private var _ip:String;
		
		private var _port:uint;
		
		private var _detectIp:String;
		
		private var _detectPort:uint;
		
		public function TcpPeerInfo(param1:uint, param2:String, param3:uint, param4:String, param5:uint, param6:uint, param7:uint)
		{
			super(param1,"TcpPeer: " + param4 + ":" + param5,param6,param7);
			this._ip = param2;
			this._port = param3;
			this._detectIp = param4;
			this._detectPort = param5;
		}
		
		public function get ip() : String
		{
			return this._ip;
		}
		
		public function get port() : uint
		{
			return this._port;
		}
		
		public function get detectIp() : String
		{
			return this._detectIp;
		}
		
		public function get detectPort() : uint
		{
			return this._detectPort;
		}
		
		override public function toString() : String
		{
			return "version:" + version + ", ip:" + this.ip + ", port:" + this.port + ", detectIp:" + this.detectIp + ", detectPort:" + this.detectPort + ", priority:" + uploadPriority;
		}
	}
}
