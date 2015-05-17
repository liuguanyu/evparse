package com.pplive.p2p.connection
{
	import com.pplive.monitor.Monitable;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import com.pplive.p2p.BootStrapConfig;
	import flash.utils.getTimer;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import com.pplive.p2p.struct.TcpPeerInfo;
	import flash.utils.Endian;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import com.pplive.p2p.events.PeerConnectFailedEvent;
	import com.pplive.p2p.events.PeerConnectedEvent;
	
	class TcpConnector extends Monitable
	{
		
		private static var logger:ILogger = getLogger(TcpConnector);
		
		private var _preConnectTime:uint;
		
		private var _pendings:Dictionary;
		
		private var _pendingCount:uint;
		
		private var _timer:Timer;
		
		private var _timeout:uint = 300000.0;
		
		function TcpConnector()
		{
			this._pendings = new Dictionary();
			this._timer = new Timer(250);
			super("TcpConnector");
		}
		
		public function get pendingCount() : uint
		{
			return this._pendingCount;
		}
		
		public function get canConnect() : Boolean
		{
			if(this._pendingCount >= BootStrapConfig.TCP_CONNECT_MAX_PENDING_COUNT)
			{
				return false;
			}
			var _loc1:Number = 1000 / BootStrapConfig.TCP_CONNECT_RATE;
			return this._preConnectTime + _loc1 < getTimer();
		}
		
		public function start() : void
		{
			this._timer.addEventListener(TimerEvent.TIMER,this.onTimer,false,0,true);
			this._timer.start();
		}
		
		public function stop() : void
		{
			var _loc1:* = undefined;
			this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
			this._timer.stop();
			for(_loc1 in this._pendings)
			{
				this.dropPending(_loc1 as Socket);
				this.removeListeners(_loc1 as Socket,true);
			}
		}
		
		public function connect(param1:TcpPeerInfo) : void
		{
			var socket:Socket = null;
			var pending:Pending = null;
			var peer:TcpPeerInfo = param1;
			try
			{
				socket = new Socket();
				socket.endian = Endian.LITTLE_ENDIAN;
				socket.addEventListener(Event.CONNECT,this.onConnected,false,0,true);
				socket.addEventListener(IOErrorEvent.IO_ERROR,this.onError,false,0,true);
				socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError,false,0,true);
				socket.connect(peer.detectIp,peer.detectPort);
				pending = new Pending(peer);
				this._pendings[socket] = pending;
				this._pendingCount++;
				this._preConnectTime = getTimer();
				monitor.addChild(pending.monitor);
			}
			catch(e:*)
			{
				logger.error("connect: " + e);
				dispatchEvent(new PeerConnectFailedEvent(peer));
			}
		}
		
		private function dropPending(param1:Socket) : Pending
		{
			var _loc2:Pending = this._pendings[param1];
			delete this._pendings[param1];
			true;
			if(_loc2)
			{
				this._pendingCount--;
				monitor.removeChild(_loc2.monitor);
			}
			return _loc2;
		}
		
		private function removeListeners(param1:Socket, param2:Boolean) : void
		{
			var socket:Socket = param1;
			var close:Boolean = param2;
			if(close)
			{
				try
				{
					socket.close();
				}
				catch(e:*)
				{
				}
			}
			socket.removeEventListener(Event.CONNECT,this.onConnected);
			socket.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
			socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
		}
		
		private function onTimer(param1:TimerEvent) : void
		{
			var _loc3:* = undefined;
			var _loc4:Pending = null;
			var _loc2:uint = getTimer();
			for(_loc3 in this._pendings)
			{
				_loc4 = this._pendings[_loc3];
				if(_loc4.starttime + this._timeout < _loc2)
				{
					this.dropPending(_loc3);
					this.removeListeners(_loc3,true);
					dispatchEvent(new PeerConnectFailedEvent(_loc4.peer));
				}
			}
		}
		
		private function onConnected(param1:Event) : void
		{
			var _loc2:Socket = param1.target as Socket;
			var _loc3:Pending = this.dropPending(_loc2);
			if(_loc3)
			{
				this.removeListeners(_loc2,false);
				dispatchEvent(new PeerConnectedEvent(new TcpPeerConnection(_loc3.peer,_loc2)));
			}
		}
		
		private function onError(param1:Event) : void
		{
			var _loc2:Socket = param1.target as Socket;
			var _loc3:Pending = this.dropPending(_loc2);
			if(_loc3)
			{
				this.removeListeners(_loc2,true);
				dispatchEvent(new PeerConnectFailedEvent(_loc3.peer));
			}
		}
	}
}

import com.pplive.monitor.Monitable;
import com.pplive.p2p.struct.PeerInfo;
import flash.utils.getTimer;

class Pending extends Monitable
{
	
	public var peer:PeerInfo;
	
	public var starttime:uint;
	
	function Pending(param1:PeerInfo)
	{
		this.starttime = getTimer();
		super("Pending");
		this.peer = param1;
	}
}
