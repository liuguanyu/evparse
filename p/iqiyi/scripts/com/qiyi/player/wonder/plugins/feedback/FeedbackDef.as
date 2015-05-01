package com.qiyi.player.wonder.plugins.feedback {
	public class FeedbackDef extends Object {
		
		public function FeedbackDef() {
			super();
		}
		
		private static var statusBegin:int = 0;
		
		public static const STATUS_BEGIN:int = statusBegin;
		
		public static const STATUS_VIEW_INIT:int = statusBegin;
		
		public static const STATUS_OPEN:int = ++statusBegin;
		
		public static const STATUS_END:int = ++statusBegin;
		
		public static const STATUS_COUNT:int = STATUS_END - STATUS_BEGIN;
		
		public static const NOTIFIC_ADD_STATUS:String = "feedbackAddStatus";
		
		public static const NOTIFIC_REMOVE_STATUS:String = "feedbackRemoveStatus";
		
		public static const NOTIFIC_OPEN_CLOSE:String = "feedbackOpenClose";
		
		public static const FEEDBACK_HELP_URL:String = "http://www.qiyi.com/common/helpandsuggest.html?entry=shouye";
		
		public static const FEEDBACK_GET_TICKET_URL:String = "http://feedback.qiyi.com/f/b/p.html";
		
		public static const FEEDBACK_GET_LOCATION_URL:String = "http://iplocation.geo.qiyi.com/cityjson";
		
		public static const FEEDBACK_FEED_BACK_URL:String = "http://feedback.qiyi.com/f/b/s.html";
		
		public static const OPEN_VIDEOS:XML = <items>
											<item video_url="http://yule.iqiyi.com/zbj.html" pic_url="http://pic3.qiyipic.com/image/20140925/b6/7d/09/a_50909637_m_601_m3_120_160.jpg" title="爱奇艺早班机"/>
											<item video_url="http://www.iqiyi.com/a_19rrgu9owx.html" pic_url="http://pic4.qiyipic.com/image/20140728/53/a5/e1/a_50908187_m_601_m3_120_160.jpg" title="娱乐猛回头"/>
											<item video_url="http://www.iqiyi.com/a_19rrgued6t.html" pic_url="http://pic2.qiyipic.com/image/20140922/49/7c/ea/a_50909242_p_601_m1_120_160.jpg" title="笑霸来了"/>
											<item video_url="http://www.iqiyi.com/a_19rrgifngp.html" pic_url="http://pic5.qiyipic.com/image/20141013/ea/fe/05/a_100004790_m_601_m8_120_160.jpg" title="晓松奇谈"/>
											<item video_url="http://www.iqiyi.com/a_19rrhc0l5p.html" pic_url="http://pic1.qiyipic.com/image/20140926/28/52/a_100006871_m_601_m1_120_160.jpg" title="爱奇艺爱电影"/>
											<item video_url="http://www.iqiyi.com/v_19rrmk3upc.html" pic_url="http://pic7.qiyipic.com/image/20140911/74/f9/a_100006341_m_601_m11_120_160.jpg" title="不可思议的夏天"/>
											<item video_url="http://www.iqiyi.com/v_19rrne9qsw.html" pic_url="http://pic5.qiyipic.com/image/20140918/ab/02/a_100007025_m_601_m2_120_160.jpg" title="来自星星的继承者们"/>
											<item video_url="http://www.iqiyi.com/business/wxbpd.html" pic_url="http://pic8.qiyipic.com/image/20140505/de/60/ae/a_100004157_m_601_m1_120_160.jpg" title="吴晓波频道"/>
									</items>;
		
		public static const OPEN_VIDEOS_LIST_URL:String = "http://list.iqiyi.com/";
		
		public static const FEEDBACK_RESUBMIT_TIME_GAP:int = 300 * 1000;
		
		public static const FEEDBACK_RESUBMIT_INPUT_MAXCHAR:int = 500;
		
		public static const FEEDBACK_RESUBMIT_ENTRY_CLASS:String = "ksfankui";
		
		public static const FEEDBACK_RESUBMIT_FB_CLASS:String = "故障投诉";
		
		public static const NUM_HEIGHT_SHOW_LIST_PANEL:Number = 340;
		
		public static const NUM_HEIGHT_SHOW_SEARCH_PART:Number = 230;
		
		public static const NUM_WIDTH_SHOW_SEARCH_PART:Number = 385;
		
		public static const FEEDBACK_LIMITED_PLATFORM:uint = 501;
		
		public static const FEEDBACK_LIMITED_AREA:uint = 502;
		
		public static const FEEDBACK_PRIVATEVIDEO_COUNTDOWN:uint = 15;
	}
}
