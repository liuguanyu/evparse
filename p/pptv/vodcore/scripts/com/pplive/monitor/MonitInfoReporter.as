package com.pplive.monitor
{
	import flash.net.XMLSocket;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.utils.getTimer;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	
	public class MonitInfoReporter extends Object
	{
		
		private static const DEFAULT_HOST:String = "localhost";
		
		private static const DEFAULT_PORT:uint = 19701;
		
		private var _host:String;
		
		private var _port:uint;
		
		private var _socket:XMLSocket;
		
		private var _timer:Timer;
		
		private var _lastConnectTime:uint = 0;
		
		public function MonitInfoReporter()
		{
			super();
		}
		
		public function start(param1:String = "localhost", param2:uint = 19701, param3:uint = 1000) : void
		{
			if(!this._timer)
			{
				this._host = param1;
				this._port = param2;
				this._timer = new Timer(param3);
				this._timer.addEventListener(TimerEvent.TIMER,this.onTimer,false,0,true);
				this._timer.start();
				this.connect();
			}
		}
		
		private function onTimer(param1:Event) : void
		{
			var _loc2:Date = null;
			var _loc3:XML = null;
			if(this._socket)
			{
				if(this._socket.connected)
				{
					_loc2 = new Date();
					Monitor.root.setAttr("date",_loc2.fullYear + "-" + (_loc2.month + 1) + "-" + _loc2.date + " " + _loc2.hours + ":" + _loc2.minutes + ":" + _loc2.seconds);
					_loc3 = Monitor.root.getMonitedInfoInXML();
					this._socket.send(_loc3);
				}
				else if(this._lastConnectTime + 10000 <= getTimer())
				{
					this.close();
					this.connect();
				}
				
			}
			else if(this._lastConnectTime + 3000 <= getTimer())
			{
				this.connect();
			}
			
		}
		
		private function connect() : void
		{
			try
			{
				this._lastConnectTime = getTimer();
				this._socket = new XMLSocket();
				this._socket.timeout = 2000;
				this._socket.addEventListener(IOErrorEvent.IO_ERROR,this.onError,false,0,true);
				this._socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError,false,0,true);
				this._socket.addEventListener(Event.CLOSE,this.onError,false,0,true);
				this._socket.connect(this._host,this._port);
			}
			catch(e:*)
			{
				close();
				trace(e);
			}
		}
		
		private function close() : void
		{
			var s:XMLSocket = null;
			if(this._socket)
			{
				s = this._socket;
				this._socket = null;
				try
				{
					s.close();
				}
				catch(e:*)
				{
					trace(e);
				}
				s.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
				s.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
				s.removeEventListener(Event.CLOSE,this.onError);
			}
		}
		
		private function onError(param1:Event) : void
		{
			trace(param1);
			this.close();
		}
	}
}
