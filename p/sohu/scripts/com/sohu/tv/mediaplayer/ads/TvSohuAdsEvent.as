package com.sohu.tv.mediaplayer.ads {
	import flash.events.Event;
	
	public class TvSohuAdsEvent extends Event {
		
		public function TvSohuAdsEvent(param1:String) {
			super(param1);
		}
		
		public static const SCREENSHOWN:String = "screen_shown";
		
		public static const SCREENFINISH:String = "screen_finish";
		
		public static const SELECTORFINISH:String = "selector_finish";
		
		public static const SCREEN_LOAD_FAILED:String = "screen_load_failed";
		
		public static const START_AD_ILLEGAL:String = "start_ad_illegal";
		
		public static const START_AD_LOADED:String = "start_ad_loaded";
		
		public static const MIDDLE_LOAD_FAILED:String = "middle_load_failed";
		
		public static const PAUSECLOSED:String = "pause_closed";
		
		public static const PAUSESHOWN:String = "pause_shown";
		
		public static const TOPSHOWN:String = "top_shown";
		
		public static const BOTTOMSHOWN:String = "bottom_shown";
		
		public static const MIDDLESHOWN:String = "middle_shown";
		
		public static const BOTTOMHIDE:String = "bottom_hide";
		
		public static const SOGOUSHOWN:String = "sogou_shown";
		
		public static const LOGOSHOWN:String = "logo_shown";
		
		public static const LOGOFINISH:String = "logo_finish";
		
		public static const ENDSHOWN:String = "end_shown";
		
		public static const ENDFINISH:String = "end_finish";
		
		public static const MIDDLEFINISH:String = "middle_finish";
		
		public static const SCREEN_PLAY_PROGRESS:String = "screen_ad_progress";
		
		public static const SELECTOR_PLAY_PROGRESS:String = "selector_ad_progress";
		
		public static const CTRLBARSHOWN:String = "ctrlbarad_shown";
		
		public static const FINISH:String = "ad_finish";
		
		public static const LOAD_SUCCESS:String = "load_success";
		
		public static const LOAD_FAILED:String = "load_failed";
		
		public static const LOAD_TIMEOUT:String = "load_timeout";
		
		public static const FORBID_OVERTIME:String = "forbid_overtime";
		
		public static const FORBID_SWF:String = "forbid_swf";
		
		private var _data_obj:Object;
		
		public function set obj(param1:Object) : void {
			this._data_obj = param1;
		}
		
		public function get obj() : Object {
			return this._data_obj;
		}
	}
}
