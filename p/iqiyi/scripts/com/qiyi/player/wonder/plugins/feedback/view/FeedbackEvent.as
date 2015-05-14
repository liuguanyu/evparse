package com.qiyi.player.wonder.plugins.feedback.view
{
	import com.qiyi.player.wonder.common.event.CommonEvent;
	
	public class FeedbackEvent extends CommonEvent
	{
		
		public static const Evt_Open:String = "evtFeedbackOpen";
		
		public static const Evt_Close:String = "evtFeedbackClose";
		
		public static const Evt_Refresh:String = "evtFeedbackRefresh";
		
		public static const Evt_DownloadBtnClick:String = "evtFeedbackDownloadBtnClick";
		
		public static const Evt_FaultFeedBackSuccess:String = "evtFaultFeedBackSuccess";
		
		public static const Evt_FaultFeedbackReturn:String = "evtFaultFeedbackReturn";
		
		public static const Evt_CopyrightRecItemClick:String = "evtCopyrightRecItemClick";
		
		public static const Evt_CopyrightSearchBtnClick:String = "evtCopyrightSearchBtnClick";
		
		public static const Evt_PrivateNestVideo:String = "evtPrivateNestVideo";
		
		public static const Evt_PrivateConfirmBtnClick:String = "evtPrivateConfirmBtnClick";
		
		public static const Evt_SkipMemberAuthBtnClick:String = "evtSkipMemberAuthBtnClick";
		
		public function FeedbackEvent(param1:String, param2:Object = null)
		{
			super(param1,param2);
		}
	}
}
