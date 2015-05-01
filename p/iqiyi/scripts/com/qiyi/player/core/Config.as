package com.qiyi.player.core {
	public class Config extends Object {
		
		public function Config() {
			super();
		}
		
		public static const CHECK_LIMIT_URL:String = "http://cache.vip.qiyi.com/ip/";
		
		public static const CHECK_V_INFO_URL:String = "http://data.video.qiyi.com/v.f4v";
		
		public static const VIP_AUTH_URL:String = "http://api.vip.iqiyi.com/services/ck.action";
		
		public static const MIXER_VX_URL:String = "http://cache.video.qiyi.com/vms";
		
		public static const MIXER_VX_VIP_URL:String = "http://cache.vip.qiyi.com/vms";
		
		public static const ENJOYABLE_SKIP_POINT_URL:String = "http://cache.video.qiyi.com/sci/gm/3/";
		
		public static const LOGO_URL:String = "http://cache.video.qiyi.com/logo/";
		
		public static const BRAND_URL:String = "http://www.iqiyi.com/player/cupid/common/icon.swf";
		
		public static const BRAND_EXCLUSIVE_URL:String = "http://www.iqiyi.com/player/cupid/common/icon_exclusive.swf";
		
		public static const BRAND_QIYIPRODUCED_URL:String = "http://www.iqiyi.com/player/cupid/common/icon_qiyi_produced.swf";
		
		public static const CLIENT_P2P_IP:String = "127.0.0.1";
		
		public static const FIRST_DISPATCH_URL:String = "http://data.video.qiyi.com/t";
		
		public static const HISTORY_LOGIN_USER_UPLOAD_URL:String = "http://l.rcd.iqiyi.com/apis/qiyirc/setrc.php";
		
		public static const HISTORY_UNLOGIN_USER_UPLOAD_URL:String = "http://nl.rcd.iqiyi.com/apis/urc/setrc";
		
		public static const HISTORY_LOGIN_USER_READ_RECORD:String = "http://l.rcd.iqiyi.com/apis/qiyirc/getvplay";
		
		public static const HISTORY_UNLOGIN_USER_READ_RECORD:String = "http://nl.rcd.iqiyi.com/apis/urc/getvplay";
		
		public static const HISTORY_LOGIN_USER_UPLOAD_RATE:int = 90000;
		
		public static const CAPTURE_URL:String = "screen.video.qiyi.com";
		
		public static const MIXER_TIMEOUT:int = 10000;
		
		public static const MIXER_MAX_RETRY:int = 2;
		
		public static var requestSkipPointsTimeout:int = 10000;
		
		public static var requestSkipPointsMaxRetry:int = 2;
		
		public static const VRS_INFO_TIMEOUT:int = 10000;
		
		public static const VRS_INFO_MAX_RETRY:int = 2;
		
		public static const META_TIMEOUT:int = 10000;
		
		public static const DISPATCH_TIMEOUT:int = 10000;
		
		public static const DISPATCH_MAX_RETRY:int = 2;
		
		public static const SUBTITLE_TIMEOUT:int = 10000;
		
		public static const SUBTITLE_MAX_RETRY:int = 3;
		
		public static const STREAM_TIMEOUT:int = 20000;
		
		public static const STREAM_MAX_RETRY:int = 3;
		
		public static const STREAM_SHORT_BUFFER_TIME:int = 100;
		
		public static const STREAM_NORMAL_BUFFER_TIME:int = 3000;
		
		public static const SCREEN_BLANK_MAX:int = 20000;
		
		public static const PRELOAD_NEXT_SEGMENT:int = 120000;
		
		public static const LOG_COOKIE:String = "qiyi_log";
		
		public static const MAX_LOG_COOKIE_SIZE:int = 40;
		
		public static const SETTINGS_COOKIE:String = "qiyi_settings";
		
		public static const STATISTICS_COOKIE:String = "qiyi_statistics";
		
		public static const CLIENT_P2P_COOKIE:String = "QiyiService";
	}
}
