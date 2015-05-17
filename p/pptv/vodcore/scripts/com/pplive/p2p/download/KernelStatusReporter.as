package com.pplive.p2p.download
{
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import com.pplive.p2p.struct.RID;
	import flash.net.Socket;
	import flash.utils.Timer;
	import flash.utils.Endian;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import com.pplive.p2p.struct.Constants;
	import flash.events.TimerEvent;
	import com.pplive.p2p.network.protocol.Packet;
	import flash.utils.ByteArray;
	import com.pplive.p2p.network.protocol.Deserializer;
	import com.pplive.p2p.network.protocol.ReportRestPlayTimePacket;
	
	class KernelStatusReporter extends Object
	{
		
		private static var logger:ILogger = getLogger(KernelStatusReporter);
		
		private var _port:uint;
		
		private var _rid:RID;
		
		private var _vip:Boolean;
		
		private var _restPlayTime:uint;
		
		private var _socket:Socket;
		
		private var _timer:Timer;
		
		function KernelStatusReporter(param1:uint, param2:RID, param3:Boolean)
		{
			this._timer = new Timer(1000);
			super();
			this._port = param1;
			this._rid = param2;
			this._vip = param3;
		}
		
		public function start() : void
		{
			if(this._socket)
			{
				return;
			}
			try
			{
				this._socket = new Socket();
				this._socket.endian = Endian.LITTLE_ENDIAN;
				this._socket.addEventListener(Event.CONNECT,this.onConnected,false,0,true);
				this._socket.addEventListener(IOErrorEvent.IO_ERROR,this.onError,false,0,true);
				this._socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError,false,0,true);
				this._socket.connect(Constants.KERNEL_HOST,this._port);
				this._timer.addEventListener(TimerEvent.TIMER,this.onTimer,false,0,true);
				this._timer.start();
			}
			catch(e:*)
			{
				close();
				throw e;
			}
		}
		
		public function close() : void
		{
			this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
			this._timer.stop();
			if(this._socket)
			{
				try
				{
					this._socket.close();
				}
				catch(e:*)
				{
				}
				this._socket.removeEventListener(Event.CONNECT,this.onConnected);
				this._socket.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
				this._socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
				this._socket = null;
			}
		}
		
		public function set restPlayTime(param1:uint) : void
		{
			this._restPlayTime = param1;
		}
		
		public function set vip(param1:Boolean) : void
		{
			this._vip = param1;
		}
		
		private function onConnected(param1:Event) : void
		{
			logger.info("kernel status reporter: connected");
		}
		
		private function onError(param1:Event) : void
		{
			logger.error("onError: " + param1);
			this.close();
		}
		
		private function sendPacket(param1:Packet) : void
		{
			var _loc2:ByteArray = null;
			if((this._socket) && (this._socket.connected))
			{
				_loc2 = Deserializer.serialize(param1);
				if(_loc2 != null)
				{
					_loc2.writeByte(13);
					_loc2.writeByte(10);
					_loc2.writeByte(13);
					_loc2.writeByte(10);
					this._socket.writeBytes(_loc2);
					this._socket.flush();
				}
			}
		}
		
		private function onTimer(param1:TimerEvent) : void
		{
			if(this._socket)
			{
				this.sendPacket(new ReportRestPlayTimePacket(this._rid,this._restPlayTime));
			}
		}
	}
}
