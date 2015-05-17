package com.pplive.p2p.network.protocol
{
	import org.as3commons.logging.api.ILogger;
	import flash.utils.ByteArray;
	import org.as3commons.logging.api.getLogger;
	
	public class Deserializer extends Object
	{
		
		private static var logger:ILogger = getLogger(Deserializer);
		
		public function Deserializer()
		{
			super();
		}
		
		public static function deserialize(param1:ByteArray) : Packet
		{
			var packet:Packet = null;
			var bytes:ByteArray = param1;
			var action:uint = bytes.readUnsignedByte();
			bytes.position--;
			switch(action)
			{
				case AnnounceRequestPacket.ACTION:
					packet = new AnnounceRequestPacket(0,null);
					break;
				case AnnounceResponsePacket.ACTION:
					packet = new AnnounceResponsePacket(0,null,null,null);
					break;
				case KernelStatusPacket.ACTION:
					packet = new KernelStatusPacket(0,null,0,0);
					break;
				case ReportRestPlayTimePacket.ACTION:
					packet = new ReportRestPlayTimePacket(null,0);
					break;
				case ReportSpeedPacket.ACTION:
					packet = new ReportSpeedPacket(0,0);
					break;
				case ReportStatusPacket.ACTION:
					packet = new ReportStatusPacket(null,false);
					break;
				case StartDownloadPacket.ACTION:
					packet = new StartDownloadPacket("");
					break;
				case StopDownloadPacket.ACTION:
					packet = new StopDownloadPacket("");
					break;
				case SubPiecePacket.ACTION:
					packet = new SubPiecePacket(0,null,null,null);
					break;
				case SubPieceRequestPacket.ACTION:
					packet = new SubPieceRequestPacket(0,null,null,0);
					break;
				default:
					logger.error("unkown packet type: " + action);
			}
			if(packet)
			{
				try
				{
					packet.fromByteArray(bytes);
					return packet;
				}
				catch(e:*)
				{
					logger.error(e);
				}
			}
			return null;
		}
		
		public static function serialize(param1:Packet) : ByteArray
		{
			return param1.ToByteArray();
		}
	}
}
