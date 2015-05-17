package com.pplive.p2p.struct
{
	import flash.utils.ByteArray;
	
	public class PeerDownloadInfo extends Object
	{
		
		public var isDownloading:Boolean;
		
		public var onLineTime:uint;
		
		public var avgDownload:uint;
		
		public var nowDownload:uint;
		
		public var avgUpload:uint;
		
		public var nowUpload:uint;
		
		public function PeerDownloadInfo()
		{
			super();
		}
		
		public function fromByteArray(param1:ByteArray) : void
		{
			this.isDownloading = param1.readUnsignedByte() == 1?true:false;
			this.onLineTime = param1.readUnsignedInt();
			this.avgDownload = param1.readUnsignedShort();
			this.nowDownload = param1.readUnsignedShort();
			this.avgUpload = param1.readUnsignedShort();
			this.nowUpload = param1.readUnsignedShort();
			param1.position = param1.position + 3;
		}
		
		public function toByteArray(param1:ByteArray) : void
		{
			param1.writeByte(this.isDownloading?1:0);
			param1.writeUnsignedInt(this.onLineTime);
			param1.writeShort(this.avgDownload);
			param1.writeShort(this.nowDownload);
			param1.writeShort(this.avgUpload);
			param1.writeShort(this.nowUpload);
			param1.writeByte(0);
			param1.writeByte(0);
			param1.writeByte(0);
		}
	}
}
