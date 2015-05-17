package com.pplive.p2p.kernel
{
	import com.pplive.p2p.network.ISocketListener;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import com.pplive.p2p.network.SocketAdaptor;
	import com.pplive.p2p.network.TcpStream;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import com.pplive.p2p.network.protocol.Packet;
	import com.pplive.p2p.network.Endpoint;
	import com.pplive.p2p.network.protocol.StartDownloadPacket;
	import com.pplive.p2p.network.protocol.StopDownloadPacket;
	
	public class KernelPreDownload extends Object implements ISocketListener
	{
		
		private static var logger:ILogger = getLogger(KernelPreDownload);
		
		private static var localHost:String = "127.0.0.1";
		
		private var _port:uint;
		
		private var _socket:SocketAdaptor;
		
		private var _stream:TcpStream;
		
		private var _url:String;
		
		private var _restPlayTime:uint;
		
		private var _isStart:Boolean;
		
		public function KernelPreDownload(param1:uint)
		{
			super();
			this._port = param1;
		}
		
		public function start(param1:String, param2:uint) : void
		{
			this._url = param1;
			this._restPlayTime = param2;
			this._isStart = true;
			this.execute();
		}
		
		public function stop(param1:String) : void
		{
			this._url = param1;
			this._isStart = false;
			this.execute();
		}
		
		private function execute() : void
		{
			if(null == this._socket)
			{
				this._socket = new SocketAdaptor();
				this._socket.addEventListener(Event.CONNECT,this.onConnect,false,0,true);
				this._socket.addEventListener(IOErrorEvent.IO_ERROR,this.onError,false,0,true);
				this._socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError,false,0,true);
				this._socket.connect(localHost,this._port);
			}
		}
		
		public function destroy() : void
		{
			logger.info("destory");
			if(this._socket)
			{
				this.removeSocketListen();
				this._socket = null;
			}
			if(this._stream)
			{
				this._stream.destory();
				this._stream = null;
			}
		}
		
		public function onPacket(param1:Packet) : void
		{
			logger.info("onPacket," + param1);
		}
		
		public function onSocketLost() : void
		{
			logger.info("onSocketLost");
			this._stream.destory();
			this._stream = null;
		}
		
		private function removeSocketListen() : void
		{
			this._socket.removeEventListener(Event.CONNECT,this.onConnect);
			this._socket.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
			this._socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
		}
		
		private function onConnect(param1:Event) : void
		{
			logger.info("onConnect,to start predownload?" + this._isStart);
			this.removeSocketListen();
			this._stream = new TcpStream(this._socket,new Endpoint(localHost,this._port),this);
			this.SendPacket();
			this.destroy();
		}
		
		private function onError(param1:Event) : void
		{
			logger.error("onError " + param1);
		}
		
		private function SendPacket() : void
		{
			var _loc1:String = null;
			var _loc2:StartDownloadPacket = null;
			var _loc3:StopDownloadPacket = null;
			if(this._stream)
			{
				_loc1 = this._url + "&resttime=" + this._restPlayTime;
				logger.info("url to kernel:" + _loc1);
				if(this._isStart)
				{
					_loc2 = new StartDownloadPacket(_loc1);
					this._stream.sendPacket(_loc2);
				}
				else
				{
					_loc3 = new StopDownloadPacket(_loc1);
					this._stream.sendPacket(_loc3);
				}
			}
		}
	}
}
