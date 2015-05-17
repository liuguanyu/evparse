package com.pplive.p2p.struct
{
	public class Constants extends Object
	{
		
		public static const SUBPIECE_SIZE:uint = 1024;
		
		public static const PIECE_SIZE:uint = 131072;
		
		public static const BLOCK_SIZE:uint = 2097152;
		
		public static const PIECE_NUM_PER_BLOCK:uint = 16;
		
		public static const SUBPIECE_NUM_PER_PIECE:uint = 128;
		
		public static const SUBPIECE_NUM_PER_BLOCK:uint = 2048;
		
		public static const KERNEL_HOST:String = "127.0.0.1";
		
		public static const KERNEL_MAGIC_PORT0:uint = 9000;
		
		public static const KERNEL_MAGIC_PORT1:uint = 9001;
		
		public static var KERNEL_MAGIC_PORT:uint = KERNEL_MAGIC_PORT0;
		
		public static const BWTYPE_NORMAL:uint = 0;
		
		public static const BWTYPE_HTTP_MORE:uint = 1;
		
		public static const BWTYPE_HTTP_ONLY:uint = 2;
		
		public static const BWTYPE_HTTP_PREFERRED:uint = 3;
		
		public static const BWTYPE_P2P_MORE:uint = 4;
		
		public static const BWTYPE_VOD_P2P_ONLY:uint = 5;
		
		public static const BWTYPE_P2P_INCREASE_CONNECT:uint = 6;
		
		public static const BWTYPE_RTMFP_ONLY:uint = 101;
		
		public static const KERNEL_STATUS_UNKNOWN:uint = 0;
		
		public static const KERNEL_STATUS_EXIST:uint = 1;
		
		public static const KERNEL_STATUS_NON_EXIST:uint = 2;
		
		public static const KERNEL_MAX_TOLERATED_FAIL_TIMES:uint = 3;
		
		public static const PLAY_MODE_UNKNOWN:int = -1;
		
		public static const PLAY_MODE_DIRECT:int = 0;
		
		public static const PLAY_MODE_KERNEL:int = 1;
		
		public static const HTTP_RECV_TIMEOUT:uint = 10000;
		
		public static var LOCAL_KERNEL_TCP_PORT:uint = 16000;
		
		public static var IS_VIP:Boolean = false;
		
		public function Constants()
		{
			super();
		}
	}
}
