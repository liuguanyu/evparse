package com.qiyi.player.wonder.plugins.scenetile
{
	public class SceneTileDef extends Object
	{
		
		private static var statusBegin:int = 0;
		
		public static const STATUS_BEGIN:int = statusBegin;
		
		public static const STATUS_TOOL_VIEW_INIT:int = statusBegin;
		
		public static const STATUS_BARRAGE_VIEW_INIT:int = ++statusBegin;
		
		public static const STATUS_SCORE_VIEW_INIT:int = ++statusBegin;
		
		public static const STATUS_STREAM_LIMIT_VIEW_INIT:int = ++statusBegin;
		
		public static const STATUS_TOOL_OPEN:int = ++statusBegin;
		
		public static const STATUS_BARRAGE_OPEN:int = ++statusBegin;
		
		public static const STATUS_STREAM_LIMIT_OPEN:int = ++statusBegin;
		
		public static const STATUS_SCORE_OPEN:int = ++statusBegin;
		
		public static const STATUS_SCORE_SUCCESS_OPEN:int = ++statusBegin;
		
		public static const STATUS_PLAY_BTN_SHOW:int = ++statusBegin;
		
		public static const STATUS_BARRAGE_STAR_HEAD_SHOW:int = ++statusBegin;
		
		public static const STATUS_SCENE_TILE_TIP_SHOW:int = ++statusBegin;
		
		public static const STATUS_VIDEO_NAME_SHOW:int = ++statusBegin;
		
		public static const STATUS_END:int = ++statusBegin;
		
		public static const STATUS_COUNT:int = STATUS_END - STATUS_BEGIN;
		
		public static const NOTIFIC_ADD_STATUS:String = "sceneTileAddStatus";
		
		public static const NOTIFIC_REMOVE_STATUS:String = "sceneTileRemoveStatus";
		
		public static const NOTIFIC_OPEN_CLOSE_SCORE:String = "sceneTileOpenCloseScore";
		
		public static const NOTIFIC_OPEN_CLOSE_STREAM_LIMIT:String = "sceneTileOpenCloseStreamLimit";
		
		public static const NOTIFIC_RECEIVE_BARRAGE_INFO:String = "sceneTileReceiveBarrageInfo";
		
		public static const NOTIFIC_STAR_HEAD_SHOW:String = "sceneTileStarHeadShow";
		
		public static const SCORE_PLAYING_DURATION:Number = 10 * 60 * 1000;
		
		public static const SCORE_PLAYING_POINT:Number = 0.8;
		
		public static const SCORE_PLAYING_END_POINT:Number = 10 * 60 * 1000;
		
		public static const SCORE_MAX_LEVEL:uint = 5;
		
		public static const SCORE_LEVEL_DESCRIBE:Array = ["讨厌","不喜欢","喜欢","很喜欢","超赞"];
		
		public static const SCORE_SHOW_TIME:uint = 30;
		
		public static const BARRAGE_BUFFER_BARRAGEINFO_NUM:uint = 100;
		
		public static const BARRAGE_REQUEST_INTERVAL_TIME:int = 5 * 60 * 1000;
		
		public static const BARRAGE_MAX_SHOW_ROW_NUM:uint = 6;
		
		public static const BARRAGE_STAR_ROW_NUM:uint = 2;
		
		public static const BARRAGE_MIN_SHOW_ROW_NUM:uint = 3;
		
		public static const BARRAGE_POSITION_ROW:Array = [[1,1,1],[1,2,1],[2,1,2],[2,2,2]];
		
		public static const BARRAGE_ROW_SPEED:Array = [3,3,3,3,3,3];
		
		public static const BARRAGE_IN_FLY_SPEED:uint = 100;
		
		public static const BARRAGE_OUT_FLY_SPEED:uint = 30;
		
		public static const BARRAGE_ITEM_GAP:uint = 100;
		
		public static const BARRAGE_DELETE_PERCENT:uint = 30;
		
		public static const BARRAGE_DEFAULT_FONT_SIZE:uint = 30;
		
		public static const BARRAGE_DEFAULT_FONT_COLOR:String = "ffffff";
		
		public static const BARRAGE_DEFAULT_ALPHA:uint = 90;
		
		public static const BARRAGE_FONT_SIZE_ARRAY:Array = [18,21,24];
		
		public static const BARRAGE_FONT_SIZE_SIGN_ARRAY:Array = [10,20,30];
		
		public static const BARRAGE_POSITION_NONE:uint = 0;
		
		public static const BARRAGE_POSITION_UP:uint = 1;
		
		public static const BARRAGE_POSITION_CENTRE:uint = 2;
		
		public static const BARRAGE_POSITION_DOWN:uint = 3;
		
		public static const BARRAGE_CONTENT_TYPE_NONE:uint = 0;
		
		public static const BARRAGE_CONTENT_TYPE_PERSON:uint = 1;
		
		public static const BARRAGE_CONTENT_TYPE_STAR:uint = 2;
		
		public static const BARRAGE_CONTENT_TYPE_RESTAR:uint = 3;
		
		public static const BARRAGE_BG_TYPE_NONE:uint = 100;
		
		public static const BARRAGE_BG_TYPE_PALEBLUE:uint = 0;
		
		public static const BARRAGE_BG_TYPE_GREY:uint = 1;
		
		public static const BARRAGE_BG_TYPE_GREEN:uint = 2;
		
		public static const BARRAGE_BG_TYPE_PINK:uint = 3;
		
		public static const BARRAGE_BG_TYPE_LIGHTBLUE:uint = 4;
		
		public static const BARRAGE_BG_TYPE_BLACK:uint = 5;
		
		public static const SCENE_TILE_TIP_DELAY_TIME:int = 15 * 1000;
		
		public static const STAGE_GAP_1:int = 28;
		
		public static const STAGE_GAP_2:int = 0;
		
		public function SceneTileDef()
		{
			super();
		}
	}
}
