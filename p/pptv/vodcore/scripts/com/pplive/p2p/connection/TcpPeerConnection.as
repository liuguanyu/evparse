package com.pplive.p2p.connection
{
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import com.pplive.p2p.network.protocol.Packet;
	import com.pplive.p2p.network.protocol.Deserializer;
	import com.pplive.p2p.network.protocol.SubPiecePacket;
	import com.pplive.p2p.struct.Constants;
	import com.pplive.p2p.struct.PeerInfo;
	import flash.utils.Endian;
	
	public class TcpPeerConnection extends PeerConnection
	{
		
		private var _socket:Socket;
		
		private var _action:uint;
		
		private var _receiveBuf:ByteArray;
		
		private var _subpieceLength:uint;
		
		public function TcpPeerConnection(param1:PeerInfo, param2:Socket)
		{
			this._receiveBuf = new ByteArray();
			super(param1);
			this._socket = param2;
			this._socket.addEventListener(Event.CLOSE,this.onClosed,false,0,true);
			this._socket.addEventListener(ProgressEvent.SOCKET_DATA,this.onReceiveData,false,0,true);
			this._socket.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError,false,0,true);
			this._socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError,false,0,true);
			this._receiveBuf.endian = Endian.LITTLE_ENDIAN;
		}
		
		override protected function doClose() : void
		{
			if(this._socket)
			{
				this._socket.removeEventListener(Event.CLOSE,this.onClosed);
				this._socket.removeEventListener(ProgressEvent.SOCKET_DATA,this.onReceiveData);
				this._socket.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
				this._socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
				if(this._socket.connected)
				{
					try
					{
						this._socket.close();
					}
					catch(e:*)
					{
					}
				}
				this._socket = null;
			}
		}
		
		override protected function sendPacketImpl(param1:Packet) : void
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
		
		private function onReceiveData(param1:ProgressEvent) : void
		{
			var _loc2:* = 0;
			while((this._socket) && (this._socket.connected) && this._socket.bytesAvailable > 0)
			{
				if(this._receiveBuf.length == 0)
				{
					this._action = this._socket.readUnsignedByte();
					this._receiveBuf.writeByte(this._action);
					continue;
				}
				if(this._action != SubPiecePacket.ACTION)
				{
					_loc2 = this._socket.readUnsignedByte();
					this._receiveBuf.writeByte(_loc2);
					if(this.checkDelimiter())
					{
						this.parsePacket();
					}
					else if(this._receiveBuf.length > 2048)
					{
						this.onDataError();
						return;
					}
					
					continue;
				}
				if(this._receiveBuf.length == 1)
				{
					if(this._socket.bytesAvailable < 28)
					{
						break;
					}
					this._socket.readBytes(this._receiveBuf,1,28);
					this._receiveBuf.position = this._receiveBuf.length - 2;
					this._subpieceLength = this._receiveBuf.readUnsignedShort();
					if(this._subpieceLength > Constants.SUBPIECE_SIZE)
					{
						this.onDataError();
						return;
					}
				}
				if(this._socket.bytesAvailable < this._subpieceLength + 4)
				{
					break;
				}
				this._socket.readBytes(this._receiveBuf,this._receiveBuf.length,this._subpieceLength + 4);
				if(this.checkDelimiter())
				{
					this.parsePacket();
					continue;
				}
				this.onDataError();
				return;
				break;
			}
		}
		
		private function parsePacket() : void
		{
			this._receiveBuf.position = 0;
			this._receiveBuf.length = this._receiveBuf.length - 4;
			var _loc1:Packet = Deserializer.deserialize(this._receiveBuf);
			this._receiveBuf.length = 0;
			this._action = 0;
			if(_loc1)
			{
				onPacket(_loc1);
			}
		}
		
		private function checkDelimiter() : Boolean
		{
			if(this._receiveBuf.length < 4)
			{
				return false;
			}
			var _loc1:uint = this._receiveBuf.position;
			this._receiveBuf.position = this._receiveBuf.length - 4;
			var _loc2:Boolean = this._receiveBuf.readUnsignedByte() == 13 && this._receiveBuf.readUnsignedByte() == 10 && this._receiveBuf.readUnsignedByte() == 13 && this._receiveBuf.readUnsignedByte() == 10;
			this._receiveBuf.position = _loc1;
			return _loc2;
		}
		
		private function onDataError() : void
		{
			logger.error("tcp data error");
			close();
		}
		
		private function onClosed(param1:Event) : void
		{
			close();
		}
		
		private function onIOError(param1:IOErrorEvent) : void
		{
			logger.error("tcp io error");
			close();
		}
		
		private function onSecurityError(param1:SecurityError) : void
		{
			logger.error("tcp security error: " + param1);
			close();
		}
	}
}
