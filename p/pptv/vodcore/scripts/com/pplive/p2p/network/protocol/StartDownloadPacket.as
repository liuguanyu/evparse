package com.pplive.p2p.network.protocol
{
	import flash.utils.ByteArray;
	
	public class StartDownloadPacket extends Packet
	{
		
		public static const ACTION:uint = 214;
		
		private var _downloadUrl:String;
		
		private var _referUrl:String;
		
		private var _userAgent:String;
		
		private var _fileName:String;
		
		public function StartDownloadPacket(param1:String)
		{
			super(ACTION,Packet.NewTransactionID(),Packet.PROTOCOL_VERSION);
			this._downloadUrl = param1;
		}
		
		override public function ToByteArray() : ByteArray
		{
			var _loc1:ByteArray = super.ToByteArray();
			_loc1.writeUTF(this._downloadUrl);
			_loc1.writeShort(0);
			_loc1.writeShort(0);
			_loc1.writeShort(0);
			return _loc1;
		}
	}
}
