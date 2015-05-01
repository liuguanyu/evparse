package com.qiyi.player.wonder.plugins.setting {
	public class SettingDef extends Object {
		
		public function SettingDef() {
			super();
		}
		
		private static var statusBegin:int = 0;
		
		public static const STATUS_BEGIN:int = statusBegin;
		
		public static const STATUS_VIEW_INIT:int = statusBegin;
		
		public static const STATUS_DEFINITION_VIEW_INIT:int = ++statusBegin;
		
		public static const STATUS_FILTER_VIEW_INIT:int = ++statusBegin;
		
		public static const STATUS_OPEN:int = ++statusBegin;
		
		public static const STATUS_DEFINITION_OPEN:int = ++statusBegin;
		
		public static const STATUS_FILTER_OPEN:int = ++statusBegin;
		
		public static const STATUS_END:int = ++statusBegin;
		
		public static const STATUS_COUNT:int = STATUS_END - STATUS_BEGIN;
		
		public static const NOTIFIC_ADD_STATUS:String = "settingAddStatus";
		
		public static const NOTIFIC_REMOVE_STATUS:String = "settingRemoveStatus";
		
		public static const NOTIFIC_NORMAL_VIDEO_RATE_CHANGE:String = "settingNormalVideoRateChange";
		
		public static const NOTIFIC_OPEN_CLOSE:String = "settingOpenClose";
		
		public static const NOTIFIC_DEFINITION_OPEN_CLOSE:String = "settingDefinitionOpenClose";
		
		public static const NOTIFIC_FILTER_OPEN_CLOSE:String = "settingFilterOpenClose";
		
		public static const NOTIFIC_FILTER_SKIP_MOVIECLIP:String = "settingFilterPlaySkipMC";
		
		public static const DEFAULT_SUBTITLE_POS:int = 17;
		
		public static const FONT_COLOR_LIST:Array = [16777215,16776960];
		
		public static const FONT_COLOR_SHOW_LIST:Array = ["白色","黄色"];
		
		public static const FONT_SIZE_LIST:Array = [16,22,28,34,40];
		
		public static const DEFAULT_SUBTITLE_SIZE_INDEX:int = 2;
		
		public static const DEFAULT_SUBTITLE_COLOR_INDEX:int = 0;
		
		public static const DEFAULT_SUBTITLE_LANG_INDEX:int = 0;
		
		public static const DEFAULT_SOUND_TRACK_INDEX:int = 0;
		
		public static const VIDEO_PAGE_ASPECT_RAW:int = 0;
		
		public static const VIDEO_PAGE_ASPECT_4BY3:int = 1;
		
		public static const VIDEO_PAGE_ASPECT_16BY9:int = 2;
		
		public static const VIDEO_PAGE_ASPECT_FILL:int = 3;
		
		public static const DEFINITION_PANEL_WIDTH:uint = 100;
		
		public static const DEFINITION_PANEL_ITEM_HEIGHT:uint = 27;
		
		public static const DEFINITION_PANEL_RADIUS:uint = 25;
		
		public static const DEFINITION_COLOR:uint = 5865493;
	}
}
