package com.pplive.p2p
{
	import com.pplive.p2p.struct.TrackerInfo;
	
	public class BootStrapConfig extends Object
	{
		
		public static var IS_UPDATED:Boolean = false;
		
		public static var ENABLE_CDN_CHECKER:Boolean = false;
		
		public static var CDN_CHECK_TIMEOUT:uint = 10;
		
		public static var DOWNLOAD_RESUME_HTTP_REST_PLAY_TIME:uint = 20;
		
		public static var DOWNLOAD_START_P2P_REST_PLAY_TIME:uint = 40;
		
		public static var DOWNLOAD_P2P_ENABLED:Boolean = true;
		
		public static var MAX_HTTP_MODE_DURATION:uint = 20;
		
		public static var MIN_P2P_MODE_DURATION:uint = 5;
		
		public static var CACHE_MEMORY_BOUND_IN_M:uint = 256;
		
		public static var TRACKERS:Vector.<TrackerInfo> = new Vector.<TrackerInfo>();
		
		public static var MAX_LIST_INTERVAL:uint = 120;
		
		public static var RTMFP_ENABLED:Boolean = true;
		
		public static var RTMFP_P2P_SERVER:String = "rtmfp://fppcert.pptv.com:1935";
		
		public static var RTMFP_P2P_SERVER_KEY:String = "";
		
		public static var RTMFP_MEDIA:String = "pplive-flash-p2p-media";
		
		public static var RTMFP_STARTUP_TIMEOUT:uint = 10;
		
		public static var RTMFP_DATA_RELIABLE:Boolean = true;
		
		public static var PEER_PRIORITY:String = "tracker";
		
		public static var ANNOUNCE_UPDATE_INTERVAL:uint = 3000;
		
		public static var RTMFP_DOWNLOAD_ENABLED:Boolean = true;
		
		public static var RTMFP_MIN_WINDOW_SIZE:uint = 4;
		
		public static var RTMFP_MAX_WINDOW_SIZE:uint = 200;
		
		public static var RTMFP_MAX_CONNECTION_COUNT:uint = 15;
		
		public static var RTMFP_P2P_CONNECT_TIMEOUT:uint = 10;
		
		public static var RTMFP_CONNECT_COUNT_BOUND:uint = 250;
		
		public static var RTMFP_CONNECTION_SETUP_COUNT_BOUND:uint = 80;
		
		public static var RTMFP_P2P_CONNECT_MAX_PENDING_COUNT:uint = 15;
		
		public static var RTMFP_P2P_CONNECT_RATE:Number = 4 / 60;
		
		public static var RTMFP_P2P_CONGESTION_RATE:Number = 0.5;
		
		public static var RTMFP_P2P_MAX_DELAY_RATIO:Number = 1.5;
		
		public static var RTMFP_P2P_MAX_WINDOW_SIZE_ALLOWED_FOR_AVOID_CONGESTION:uint = 20;
		
		public static var RTMFP_P2P_MAX_DELAY_TIME:uint = 1500;
		
		public static var TCP_DOWNLOAD_ENABLED:Boolean = true;
		
		public static var TCP_MIN_WINDOW_SIZE:uint = 4;
		
		public static var TCP_MAX_WINDOW_SIZE:uint = 20;
		
		public static var TCP_MAX_CONNECTION_COUNT:uint = 30;
		
		public static var TCP_CONNECT_MAX_PENDING_COUNT:uint = 15;
		
		public static var TCP_CONNECT_TIMEOUT:uint = 5 * 60;
		
		public static var TCP_CONNECT_RATE:Number = 5;
		
		public function BootStrapConfig()
		{
			super();
		}
	}
}
