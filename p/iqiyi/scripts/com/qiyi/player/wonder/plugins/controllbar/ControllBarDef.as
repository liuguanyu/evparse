package com.qiyi.player.wonder.plugins.controllbar
{
	import flash.text.TextFormat;
	import flash.geom.Point;
	
	public class ControllBarDef extends Object
	{
		
		private static var statusBegin:int = 0;
		
		public static const STATUS_BEGIN:int = statusBegin;
		
		public static const STATUS_VIEW_INIT:int = statusBegin;
		
		public static const STATUS_BTNS_INIT_ENABLE:int = ++statusBegin;
		
		public static const STATUS_OPEN:int = ++statusBegin;
		
		public static const STATUS_SHOW:int = ++statusBegin;
		
		public static const STATUS_SEEK_BAR_SHOW:int = ++statusBegin;
		
		public static const STATUS_SEEK_BAR_THICK:int = ++statusBegin;
		
		public static const STATUS_FF_SHOW:int = ++statusBegin;
		
		public static const STATUS_VOLUME_BAR_SHOW:int = ++statusBegin;
		
		public static const STATUS_TRIGGER_BTN_SHOW:int = ++statusBegin;
		
		public static const STATUS_TRIGGER_BTN_PAUSE:int = ++statusBegin;
		
		public static const STATUS_LOAD_BTN_SHOW:int = ++statusBegin;
		
		public static const STATUS_REPLAY_BTN_SHOW:int = ++statusBegin;
		
		public static const STATUS_FULL_SCREEN_BTN_SHOW:int = ++statusBegin;
		
		public static const STATUS_TIME_SHOW:int = ++statusBegin;
		
		public static const STATUS_LOOP_PLAY_BTN_SHOW:int = ++statusBegin;
		
		public static const STATUS_NEXT_BTN_SHOW:int = ++statusBegin;
		
		public static const STATUS_LIST_BTN_SHOW:int = ++statusBegin;
		
		public static const STATUS_TVLIST_BTN_SHOW:int = ++statusBegin;
		
		public static const STATUS_EXPAND_BTN_SHOW:int = ++statusBegin;
		
		public static const STATUS_EXPAND_UNFOLD:int = ++statusBegin;
		
		public static const STATUS_3D_BTN_SHOW:int = ++statusBegin;
		
		public static const STATUS_CAPTION_BTN_SHOW:int = ++statusBegin;
		
		public static const STATUS_TRACK_BTN_SHOW:int = ++statusBegin;
		
		public static const STATUS_FILTER_BTN_SHOW:int = ++statusBegin;
		
		public static const STATUS_FILTER_OPEN:int = ++statusBegin;
		
		public static const STATUS_LOAD_TIPS_SHOW:int = ++statusBegin;
		
		public static const STATUS_DEFINITION_SHOW:int = ++statusBegin;
		
		public static const STATUS_IMAGE_PREVIEW_SHOW:int = ++statusBegin;
		
		public static const STATUS_END:int = ++statusBegin;
		
		public static const STATUS_COUNT:int = STATUS_END - STATUS_BEGIN;
		
		public static const NOTIFIC_ADD_STATUS:String = "controllBarAddStatus";
		
		public static const NOTIFIC_REMOVE_STATUS:String = "controllBarRemoveStatus";
		
		public static const NOTIFIC_DEF_BTN_POS_CHANGE:String = "controllBarDefBtnChange";
		
		public static const NOTIFIC_SCENE_TILE_TOOL_TIP:String = "controllBarSceneTileToolTip";
		
		public static const NOTIFIC_FILTER_OPEN:String = "controllBarFilterOpen";
		
		public static const SEEKBAR_THIN_DELAY:int = 3000;
		
		public static const VOLUMETIP_DISAPPEARE_DELAY:int = 1000;
		
		public static const FF_BUTTONDOWNED_DELAY:int = 200;
		
		public static const FILTER_SEEK_COUNT:uint = 3;
		
		public static const DEFAULT_FONT_COLOR:TextFormat = new TextFormat(null,12,10066329);
		
		public static const HOVER_FONT_COLOR:TextFormat = new TextFormat(null,12,3355443);
		
		public static const SELECTED_FONT_COLOR:TextFormat = new TextFormat(null,12,16777215);
		
		public static const GAP_BG_MOUSE:uint = 8;
		
		public static const GAP_BG_TEXT:uint = 8;
		
		public static const BAR_WIDTH_WIDE:uint = 16;
		
		public static const BAR_WIDTH_NARROW:uint = 3;
		
		public static const IMAGE_PRE_SMALL_SIZE:Point = new Point(160,90);
		
		public static const IMAGE_PRE_BIG_WH_SIZE:Point = new Point(197,110);
		
		public static const IMAGE_PRE_FOCUS_TIP_SIZE:Point = new Point(157,40);
		
		public static const IMAGE_PRE_TIME_SIZE:Point = new Point(60,22);
		
		public static const IMAGE_PRE_BIG_ROW:int = 10;
		
		public static const IMAGE_PRE_BIG_COL:int = 10;
		
		public static const IMAGE_PRE_DELAYEDCALL:int = 500;
		
		public function ControllBarDef()
		{
			super();
		}
	}
}
