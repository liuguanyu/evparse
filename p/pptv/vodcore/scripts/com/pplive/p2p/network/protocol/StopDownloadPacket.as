package com.pplive.p2p.network.protocol
{
	import flash.utils.ByteArray;
	
	public class StopDownloadPacket extends Packet
	{
		
		public static const ACTION:uint = 215;
		
		private var _downloadUrl:String;
		
		public function StopDownloadPacket(param1:String)
		{
			super(ACTION,Packet.NewTransactionID(),Packet.PROTOCOL_VERSION);
			this._downloadUrl = param1;
		}
		
		override public function ToByteArray() : ByteArray
		{
			var _loc1:ByteArray = super.ToByteArray();
			_loc1.writeUTF(this._downloadUrl);
			return _loc1;
		}
	}
}
