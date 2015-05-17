package com.pplive.p2p.network.protocol
{
	import com.pplive.p2p.struct.PeerDownloadInfo;
	import com.pplive.p2p.struct.BlockMap;
	import flash.utils.ByteArray;
	import com.pplive.p2p.struct.RID;
	
	public class AnnounceResponsePacket extends PeerResponsePacket
	{
		
		public static const ACTION:uint = 177;
		
		public var peerDownloadInfo:PeerDownloadInfo;
		
		public var blockMap:BlockMap;
		
		public function AnnounceResponsePacket(param1:uint, param2:RID, param3:PeerDownloadInfo, param4:BlockMap, param5:uint = 1)
		{
			super(ACTION,param1,param2,param5);
			this.peerDownloadInfo = param3;
			this.blockMap = param4;
		}
		
		override public function fromByteArray(param1:ByteArray) : void
		{
			super.fromByteArray(param1);
			this.peerDownloadInfo = new PeerDownloadInfo();
			this.peerDownloadInfo.fromByteArray(param1);
			this.blockMap = new BlockMap(0);
			this.blockMap.fromByteArray(param1);
		}
		
		override public function ToByteArray() : ByteArray
		{
			var _loc1:ByteArray = super.ToByteArray();
			this.peerDownloadInfo.toByteArray(_loc1);
			this.blockMap.toByteArray(_loc1);
			return _loc1;
		}
	}
}
