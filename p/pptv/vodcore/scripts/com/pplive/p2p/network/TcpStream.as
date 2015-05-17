package com.pplive.p2p.network
{
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import flash.utils.ByteArray;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import com.pplive.p2p.network.protocol.Packet;
	import com.pplive.profile.FunctionProfiler;
	import com.pplive.p2p.network.protocol.SubPiecePacket;
	import com.pplive.p2p.network.protocol.AnnounceResponsePacket;
	import com.pplive.p2p.network.protocol.KernelStatusPacket;
	import com.pplive.util.StringConvert;
	import flash.utils.Endian;
	
	public class TcpStream extends Object
	{
		
		private static var logger:ILogger = getLogger(TcpStream);
		
		private var _socket:ISocket;
		
		private var _endpoint:Endpoint;
		
		private var _listener:ISocketListener;
		
		private var responsePacketAction:uint;
		
		private var responsePacketBytes:ByteArray;
		
		private var packetDelimiter:ByteArray;
		
		private var subpiecePacketHeaderBytes:ByteArray;
		
		private var subPiecePacketBytes:ByteArray;
		
		private var subpiecePacketLength:uint;
		
		public function TcpStream(param1:ISocket, param2:Endpoint, param3:ISocketListener = null)
		{
			this.responsePacketBytes = new ByteArray();
			this.packetDelimiter = new ByteArray();
			this.subpiecePacketHeaderBytes = new ByteArray();
			this.subPiecePacketBytes = new ByteArray();
			super();
			this._socket = param1;
			this._socket.addEventListener(Event.CLOSE,this.onClose,false,0,true);
			this._socket.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError,false,0,true);
			this._socket.addEventListener(ProgressEvent.SOCKET_DATA,this.onSockData,false,0,true);
			this._endpoint = param2;
			this._listener = param3;
			this.responsePacketBytes.endian = Endian.LITTLE_ENDIAN;
			this.subpiecePacketHeaderBytes.endian = Endian.LITTLE_ENDIAN;
			this.resetReceive();
		}
		
		public function destory() : void
		{
			this._socket.removeEventListener(Event.CLOSE,this.onClose);
			this._socket.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
			this._socket.removeEventListener(ProgressEvent.SOCKET_DATA,this.onSockData);
			if(this._socket.connected)
			{
				this._socket.close();
			}
			this._socket = null;
			this._endpoint = null;
			this._listener = null;
			this.responsePacketBytes = null;
			this.packetDelimiter = null;
			this.subpiecePacketHeaderBytes = null;
			this.subPiecePacketBytes = null;
		}
		
		public function get endpoint() : Endpoint
		{
			return this._endpoint;
		}
		
		public function sendPacket(param1:Packet) : void
		{
			var _loc2:ByteArray = null;
			if((this._socket) && (this._socket.connected))
			{
				_loc2 = param1.ToByteArray();
				_loc2.writeByte(13);
				_loc2.writeByte(10);
				_loc2.writeByte(13);
				_loc2.writeByte(10);
				logger.debug("sendPacket action:" + param1.action + ", transactionID:" + param1.transactionId + ", size=" + _loc2.length);
				this._socket.writeBytes(_loc2);
				this._socket.flush();
			}
		}
		
		private function onIOError(param1:IOErrorEvent) : void
		{
			logger.error("onIOError " + this.endpoint);
			this._socket.close();
		}
		
		private function onClose(param1:Event) : void
		{
			if(this._listener)
			{
				this._listener.onSocketLost();
			}
		}
		
		private function onSockData(param1:ProgressEvent) : void
		{
			var _loc3:* = 0;
			logger.debug("onSockData bytesAvailable:" + this._socket.bytesAvailable);
			var _loc2:FunctionProfiler = new FunctionProfiler(logger);
			while((this._socket) && (this._socket.connected) && this._socket.bytesAvailable > 0)
			{
				if(this.responsePacketAction == 0)
				{
					_loc3 = this._socket.readUnsignedByte();
					this.responsePacketAction = _loc3;
					this.responsePacketBytes.writeByte(_loc3);
					logger.debug("onSockData got action:" + this.responsePacketAction);
				}
				else if(this.responsePacketAction != SubPiecePacket.ACTION)
				{
					_loc3 = this._socket.readUnsignedByte();
					if(this.packetDelimiter.length == 0 && _loc3 == 13 || this.packetDelimiter.length == 1 && _loc3 == 10 || this.packetDelimiter.length == 2 && _loc3 == 13)
					{
						this.packetDelimiter.writeByte(_loc3);
					}
					else if(this.packetDelimiter.length == 3 && _loc3 == 10)
					{
						logger.debug("onSockData find delimiter \\r\\n\\r\\n");
						this.onResponsePacket();
					}
					else
					{
						if(this.packetDelimiter.length != 0)
						{
							this.responsePacketBytes.writeBytes(this.packetDelimiter);
							this.packetDelimiter.clear();
						}
						this.responsePacketBytes.writeByte(_loc3);
					}
					
				}
				else if(this.subpiecePacketLength == 0)
				{
					if(this._socket.bytesAvailable < 28)
					{
						break;
					}
					this.subpiecePacketHeaderBytes.writeByte(SubPiecePacket.ACTION);
					this._socket.readBytes(this.subpiecePacketHeaderBytes,1,26);
					this.subpiecePacketLength = this._socket.readUnsignedShort();
					logger.debug("onSockData got subpiecePacket length:" + this.subpiecePacketLength);
				}
				else
				{
					if(this._socket.bytesAvailable < this.subpiecePacketLength + 4)
					{
						break;
					}
					this._socket.readBytes(this.subPiecePacketBytes,0,this.subpiecePacketLength);
					this._socket.readInt();
					_loc2.makeSection();
					this.onResponsePacket();
				}
				
				
			}
			_loc2.end();
		}
		
		private function onResponsePacket() : void
		{
			var _loc2:Packet = null;
			var _loc3:AnnounceResponsePacket = null;
			var _loc4:KernelStatusPacket = null;
			var _loc5:SubPiecePacket = null;
			var _loc1:FunctionProfiler = new FunctionProfiler(logger,"onResponsePacket");
			this.responsePacketBytes.position = 0;
			switch(this.responsePacketAction)
			{
				case AnnounceResponsePacket.ACTION:
					logger.debug("onSockData received AnnounceResponsePacket:" + StringConvert.byteArray2HexString(this.responsePacketBytes));
					_loc3 = new AnnounceResponsePacket(0,null,null,null);
					_loc3.fromByteArray(this.responsePacketBytes);
					_loc2 = _loc3;
					break;
				case KernelStatusPacket.ACTION:
					_loc4 = new KernelStatusPacket(0,null,0,0);
					_loc4.fromByteArray(this.responsePacketBytes);
					_loc2 = _loc4;
					break;
				case SubPiecePacket.ACTION:
					logger.debug("onSockData received SubPiecePacket");
					this.subpiecePacketHeaderBytes.position = 0;
					_loc5 = new SubPiecePacket(0,null,null,null);
					_loc5.fromByteArrayEx(this.subpiecePacketHeaderBytes,this.subPiecePacketBytes);
					_loc2 = _loc5;
					break;
			}
			_loc1.makeSection();
			this.resetReceive();
			_loc1.makeSection();
			if((_loc2) && (this._listener))
			{
				this._listener.onPacket(_loc2);
			}
			_loc1.end();
		}
		
		private function resetReceive() : void
		{
			logger.debug("resetReceive");
			this.responsePacketAction = 0;
			this.responsePacketBytes.clear();
			this.packetDelimiter.clear();
			this.subpiecePacketHeaderBytes.clear();
			this.subPiecePacketBytes = new ByteArray();
			this.subpiecePacketLength = 0;
		}
	}
}
