package com.qiyi.cupid.adplayer.events
{
	import flash.events.Event;
	
	public class AdPlayerEvent extends Event
	{
		
		public static const VIDEO_PAUSE:String = "video_pause";
		
		public static const VIDEO_RESUME:String = "video_resume";
		
		public static const VIDEO_CHANGE_VOLUME:String = "video_change_volume";
		
		public static const VIDEO_FULLSCREEN:String = "video_fullscreen";
		
		public static const VIDEO_NORMALSCREEN:String = "video_normalscreen";
		
		public static const VIDEO_CHANGE_SIZE:String = "video_change_size";
		
		public static const VIDEO_PLAY_OVER:String = "video_play_over";
		
		public static const VIDEO_TIME_CHANGE:String = "video_time_change";
		
		public static const VIDEO_INFO:String = "video_info";
		
		public static const PRELOAD_AD_NEXT:String = "preload_ad_next";
		
		public static const NEXT_VIDEO_INFO:String = "next_video_info";
		
		public static const VIDEO_VIEW_SWITCH:String = "video_view_switch";
		
		public static const VIDEO_FORCE_AD_STOP:String = "video_force_ad_stop";
		
		public static const VIDEO_NOTIFICATION:String = "video_notification";
		
		public static const VIDEO_LIGHT_TURN_ON:String = "video_light_turn_on";
		
		public static const VIDEO_LIGHT_TURN_OFF:String = "video_light_turn_off";
		
		public static const VIDEO_DOCK_SHOW:String = "video_dock_show";
		
		public static const VIDEO_DOCK_HIDE:String = "video_dock_hide";
		
		public static const VIDEO_DIALOG_POPUP:String = "video_dialog_popup";
		
		public static const VIDEO_DIALOG_CLOSE:String = "video_dialog_close";
		
		public static const CONTROL_VIDEO_PAUSE:String = "control_video_pause";
		
		public static const CONTROL_VIDEO_RESUME:String = "control_video_resume";
		
		public static const CONTROL_VIDEO_START_LOADING:String = "control_video_start_loading";
		
		public static const CONTROL_VIDEO_START:String = "control_video_start";
		
		public static const CONTROL_VIDEO_END:String = "control_video_end";
		
		public static const CONTROL_VIDEO_NOTIFICATION:String = "control_video_notification";
		
		public static const CONTROL_VIDEO_START_P2P:String = "control_video_start_p2p";
		
		public static const CONTROL_VIDEO_LOGIN_POPUP:String = "control_video_login_popup";
		
		public static const ADPLAYER_LOADING_SUCCESS:String = "adplayer_loading_success";
		
		public static const ADPLAYER_LOADING_FAILURE:String = "adplayer_loading_failure";
		
		public static const ADPLAYER_AD_START:String = "adplayer_ad_start";
		
		public static const ADPLAYER_AD_BLOCK:String = "adplayer_ad_block";
		
		public static const ADPLAYER_AD_SHOW:String = "adplayer_ad_show";
		
		public static const ADPLAYER_AD_HIDE:String = "adplayer_ad_hide";
		
		public static const ADPLAYER_AD_IMPRESSION:String = "adplayer_ad_impression";
		
		public static const ADPLAYER_AD_CLICK:String = "adplayer_ad_click";
		
		public static const ADPLAYER_AD_VIDEO:String = "adplayer_ad_video";
		
		public static const ADPLAYER_AD_INFO:String = "adplayer_ad_info";
		
		public static const ADPLAYER_AD_TRACKING:String = "adplayer_ad_tracking";
		
		public static const VIDEO_SEEK:String = "video_seek";
		
		public static const VIDEO_ON_MUTE:String = "video_on_mute";
		
		public static const VIDEO_OFF_MUTE:String = "video_off_mute";
		
		public static const VIDEO_CHANGE_DEFINITION:String = "video_change_definition";
		
		public static const VIDEO_CHANGE_POPOUT:String = "video_change_popout";
		
		public static const VIDEO_SHARE_ON:String = "video_share_on";
		
		public static const VIDEO_SHARE_OFF:String = "video_share_off";
		
		public static const VIDEO_ERROR:String = "video_error";
		
		public static const VIDEO_LOG:String = "video_log";
		
		public static const VIDEO_STAGE_MOUSE_OVER:String = "video_stage_mouse_over";
		
		public static const VIDEO_STAGE_MOUSE_OUT:String = "video_stage_mouse_out";
		
		public static const VIDEO_PLAY_STOP:String = "video_play_stop";
		
		public static const VIDEO_BUFF_FULL:String = "video_buff_full";
		
		public static const VIDEO_BUFF_EMPTY:String = "video_buff_empty";
		
		public static const CONTROL_VIDEO_ENABLE_CONTROLBAR:String = "control_video_enable_controlbar";
		
		public static const CONTROL_VIDEO_DISABLE_CONTROLBAR:String = "control_video_disable_controlbar";
		
		public static const CONTROL_VIDEO_DISPLAY_CONTROLBAR:String = "control_video_display_controlbar";
		
		public static const CONTROL_VIDEO_HIDE_CONTROLBAR:String = "control_video_hide_controlbar";
		
		public static const CONTROL_VIDEO_DISPLAY_AD_TIP:String = "control_video_display_ad_tip";
		
		public static const CONTROL_VIDEO_HIDE_AD_TIP:String = "control_video_hide_ad_tip";
		
		public static const CONTROL_VIDEO_SHOW:String = "control_video_show";
		
		public static const CONTROL_VIDEO_HIDE:String = "control_video_hide";
		
		public static const CONTROL_VIDEO_SEEK:String = "control_video_seek";
		
		public static const CONTROL_VIDEO_ON_MUTE:String = "control_video_on_mute";
		
		public static const CONTROL_VIDEO_OFF_MUTE:String = "control_video_off_mute";
		
		public static const CONTROL_VIDEO_CHANGE_VOLUME:String = "control_video_change_volume";
		
		public static const CONTROL_VIDEO_FULLSCREEN:String = "control_video_fullscreen";
		
		public static const CONTROL_VIDEO_NORMALSCREEN:String = "control_video_normalscreen";
		
		public static const CONTROL_VIDEO_CHANGE_SIZE:String = "control_video_change_size";
		
		private var _data:Object;
		
		public function AdPlayerEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false)
		{
			super(param1,param3,param4);
			this._data = param2;
		}
		
		public function get data() : Object
		{
			return this._data;
		}
	}
}
