package com.pplive.p2p.connection
{
	import com.pplive.net.RtmfpStream;
	import com.pplive.events.RtmfpEvent;
	import com.pplive.p2p.network.protocol.Packet;
	import flash.utils.ByteArray;
	import com.pplive.p2p.network.protocol.Deserializer;
	import flash.utils.Endian;
	import com.pplive.p2p.struct.RtmfpPeerInfo;
	
	public class RtmfpPeerConnection extends PeerConnection
	{
		
		private var _stream:RtmfpStream;
		
		private var _isAccepted:Boolean;
		
		public function RtmfpPeerConnection(param1:RtmfpPeerInfo, param2:RtmfpStream, param3:Boolean)
		{
			super(param1);
			this._stream = param2;
			this._isAccepted = param3;
			this._stream = param2;
			this._stream.addEventListener(RtmfpEvent.RTMFP_STREAM_CLOSED,this.onRtmfpStreamClosed,false,0,true);
			this._stream.dataHandler = this.onRtmfpData;
		}
		
		override public function get isRTMFP() : Boolean
		{
			return true;
		}
		
		override public function get isAcceptedConnection() : Boolean
		{
			return this._isAccepted;
		}
		
		private function onRtmfpStreamClosed(param1:RtmfpEvent) : void
		{
			close();
		}
		
		override protected function doClose() : void
		{
			if(this._stream)
			{
				this._stream.removeEventListener(RtmfpEvent.RTMFP_STREAM_CLOSED,this.onRtmfpStreamClosed);
				this._stream.close();
				this._stream = null;
			}
			super.doClose();
		}
		
		override protected function sendPacketImpl(param1:Packet) : void
		{
			var _loc2:ByteArray = null;
			if(this._stream)
			{
				_loc2 = Deserializer.serialize(param1);
				if(_loc2 != null)
				{
					this._stream.send(_loc2);
				}
			}
		}
		
		private function onRtmfpData(param1:*) : void
		{
			var _loc3:Packet = null;
			var _loc2:ByteArray = param1 as ByteArray;
			if((_loc2) && _loc2.length > 0)
			{
				_loc2.position = 0;
				_loc2.endian = Endian.LITTLE_ENDIAN;
				_loc3 = Deserializer.deserialize(_loc2);
				if(_loc3)
				{
					onPacket(_loc3);
				}
			}
		}
	}
}
