package com.pplive.p2p.struct
{
	public class RtmfpPeerInfo extends PeerInfo
	{
		
		public function RtmfpPeerInfo(param1:uint, param2:String, param3:uint, param4:uint)
		{
			super(param1,param2,param3,param4);
		}
		
		override public function toString() : String
		{
			return "version:" + version + ", flashid:" + id + ", priority:" + uploadPriority;
		}
	}
}
