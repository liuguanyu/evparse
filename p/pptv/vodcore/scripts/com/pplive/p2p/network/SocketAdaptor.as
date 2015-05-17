package com.pplive.p2p.network
{
	import flash.net.Socket;
	
	public class SocketAdaptor extends Socket implements ISocket
	{
		
		public function SocketAdaptor(param1:String = null, param2:int = 0)
		{
			super(param1,param2);
		}
	}
}
