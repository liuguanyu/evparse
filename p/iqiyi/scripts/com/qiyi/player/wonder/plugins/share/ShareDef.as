package com.qiyi.player.wonder.plugins.share
{
	public class ShareDef extends Object
	{
		
		private static var statusBegin:int = 0;
		
		public static const STATUS_BEGIN:int = statusBegin;
		
		public static const STATUS_VIEW_INIT:int = statusBegin;
		
		public static const STATUS_OPEN:int = ++statusBegin;
		
		public static const STATUS_END:int = ++statusBegin;
		
		public static const STATUS_COUNT:int = STATUS_END - STATUS_BEGIN;
		
		public static const NOTIFIC_ADD_STATUS:String = "shareAddStatus";
		
		public static const NOTIFIC_REMOVE_STATUS:String = "shareRemoveStatus";
		
		public static const NOTIFIC_OPEN_CLOSE:String = "shareOpenClose";
		
		public static const SHARE_PLATFORM_SINA_URI:String = "http://v.t.sina.com.cn/share/share.php";
		
		public static const SHARE_PLATFORM_RENREN_URI:String = "http://share.renren.com/share/buttonshare";
		
		public static const SHARE_PLATFORM_TENCENT_URI:String = "http://v.t.qq.com/share/share.php";
		
		public static const SHARE_PLATFORM_QQ_URI:String = "http://sns.qzone.qq.com/cgi-bin/qzshare/cgi_qzshare_onekey";
		
		public static const SHARE_TYPE_SINA:String = "www.weibo.com";
		
		public static const SHARE_TYPE_RENREN:String = "share.renren.com";
		
		public static const SHARE_TYPE_TENCENT:String = "v.t.qq.com";
		
		public static const SHARE_TYPE_QQ:String = "sns.qzone.qq.com";
		
		public function ShareDef()
		{
			super();
		}
	}
}
