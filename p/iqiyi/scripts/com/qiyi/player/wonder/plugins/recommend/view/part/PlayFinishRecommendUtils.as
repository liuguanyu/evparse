package com.qiyi.player.wonder.plugins.recommend.view.part
{
	import flash.geom.Rectangle;
	import com.qiyi.player.wonder.plugins.recommend.RecommendDef;
	import flash.geom.Point;
	
	public class PlayFinishRecommendUtils extends Object
	{
		
		public static const MAX_COL:uint = 6;
		
		public static const MAX_ROW:uint = 5;
		
		public static const GAP_BORDER_LEFT:uint = 20;
		
		public static const GAP_BORDER_UP:uint = 40;
		
		public function PlayFinishRecommendUtils()
		{
			super();
		}
		
		public static function getRecommendItemRectangle(param1:uint) : Rectangle
		{
			var _loc2:uint = 0;
			var _loc3:uint = 0;
			var _loc4:uint = 1;
			var _loc5:uint = 1;
			if(param1 <= MAX_COL - 2)
			{
				if(param1 == 0)
				{
					_loc2 = 0;
					_loc5 = 1;
				}
				else
				{
					_loc2 = RecommendDef.PLAY_FINISH_BIG_ITEM_WIDTH + (param1 - 1) * RecommendDef.PLAY_FINISH_SMALL_ITEM_WIDTH + param1 * RecommendDef.PLAY_FINISH_ITEM_GAP;
					_loc5 = param1 + 2;
				}
				_loc3 = 0;
				_loc4 = 1;
			}
			else if(param1 <= MAX_COL * 2 - 4)
			{
				_loc2 = RecommendDef.PLAY_FINISH_BIG_ITEM_WIDTH + (param1 - MAX_COL + 1) * RecommendDef.PLAY_FINISH_SMALL_ITEM_WIDTH + (param1 - MAX_COL + 2) * RecommendDef.PLAY_FINISH_ITEM_GAP;
				_loc3 = RecommendDef.PLAY_FINISH_SMALL_ITEM_HEIGHT + RecommendDef.PLAY_FINISH_ITEM_GAP;
				_loc5 = param1 - (MAX_COL - 4);
				_loc4 = 2;
			}
			else
			{
				_loc4 = Math.ceil((param1 + 4) / MAX_COL);
				_loc2 = (param1 - (MAX_COL * (_loc4 - 1) - 4) - 1) * (RecommendDef.PLAY_FINISH_SMALL_ITEM_WIDTH + RecommendDef.PLAY_FINISH_ITEM_GAP);
				_loc3 = (RecommendDef.PLAY_FINISH_SMALL_ITEM_HEIGHT + RecommendDef.PLAY_FINISH_ITEM_GAP) * (_loc4 - 1);
				_loc5 = param1 - (MAX_COL * (_loc4 - 1) - 4);
			}
			
			return new Rectangle(_loc2,_loc3,_loc4,_loc5);
		}
		
		public static function getShowPoint(param1:Number, param2:Number) : Point
		{
			var _loc3:uint = Math.floor((param1 - GAP_BORDER_LEFT * 2) / (RecommendDef.PLAY_FINISH_SMALL_ITEM_WIDTH + RecommendDef.PLAY_FINISH_ITEM_GAP));
			var _loc4:uint = Math.floor((param2 - GAP_BORDER_UP * 2) / (RecommendDef.PLAY_FINISH_SMALL_ITEM_HEIGHT + RecommendDef.PLAY_FINISH_ITEM_GAP));
			if(_loc3 < 3 || _loc4 < 2)
			{
				_loc3 = _loc4 = 0;
			}
			_loc3 = _loc3 > MAX_COL?MAX_COL:_loc3;
			_loc4 = _loc4 > MAX_ROW?MAX_ROW:_loc4;
			return new Point(_loc4,_loc3);
		}
		
		public static function getUpdate(param1:String, param2:Number, param3:Number, param4:Number) : String
		{
			if((param2) && (param4))
			{
				switch(param1)
				{
					case "1":
						return updateDisPlayTime(param2 * 1000);
					case "2":
						return getUpdateSets("集",param2,param3,param4);
					case "3":
						return getUpdateSets("期",param2,param3,param4);
					case "4":
						return getUpdateSets("集",param2,param3,param4);
					case "5":
						return updateDisPlayTime(param2 * 1000);
					case "6":
						return updateDisPlayTime(param2 * 1000);
					case "7":
						return updateDisPlayTime(param2 * 1000);
					case "9":
						return getUpdateSets("期",param2,param3,param4);
					case "10":
						return updateDisPlayTime(param2 * 1000);
					default:
						return updateDisPlayTime(param2 * 1000);
				}
			}
			else
			{
				return "";
			}
		}
		
		private static function getUpdateSets(param1:String, param2:Number, param3:Number, param4:Number) : String
		{
			if(param4 == 1)
			{
				return updateDisPlayTime(param2 * 1000);
			}
			if(param3 == 1)
			{
				return param4 + param1 + "全";
			}
			return "更新至第" + param4 + param1;
		}
		
		private static function updateDisPlayTime(param1:Number) : String
		{
			if(param1 >= 3600000)
			{
				return digits(param1);
			}
			return digits2(param1);
		}
		
		private static function digits(param1:Number) : String
		{
			var _loc2:* = "";
			var _loc3:* = "";
			var _loc4:Number = param1 / 1000;
			if(Math.floor(_loc4 / 60) < 10)
			{
				_loc2 = "00:0" + Math.floor(_loc4 / 60);
			}
			else if(Math.floor(_loc4 / 60) >= 60)
			{
				_loc3 = String(Math.floor(_loc4 / 3600) < 10?"0" + Math.floor(_loc4 / 3600):Math.floor(_loc4 / 3600));
				_loc2 = _loc3 + ":" + String(_loc4 / 60 % 60 < 10?"0" + Math.floor(_loc4 / 60 % 60):Math.floor(_loc4 / 60 % 60));
			}
			else
			{
				_loc2 = "00:" + Math.floor(_loc4 / 60);
			}
			
			var _loc5:String = String(_loc4 % 60 < 10?"0" + Math.floor(_loc4 % 60):Math.floor(_loc4 % 60));
			return _loc2 + ":" + _loc5;
		}
		
		private static function digits2(param1:uint) : String
		{
			var param1:uint = param1 / 1000;
			var _loc2:String = String(Math.floor(param1 / 60) < 10?"0" + Math.floor(param1 / 60):Math.floor(param1 / 60));
			var _loc3:String = String(param1 % 60 < 10?"0" + Math.floor(param1 % 60):Math.floor(param1 % 60));
			return _loc2 + ":" + _loc3;
		}
		
		public static function getChannelChineseName(param1:String) : String
		{
			switch(param1)
			{
				case "1":
					return "电影";
				case "2":
					return "电视剧";
				case "3":
					return "纪录片";
				case "4":
					return "动漫";
				case "5":
					return "音乐";
				case "6":
					return "综艺";
				case "7":
					return "娱乐";
				case "8":
					return "游戏";
				case "9":
					return "旅游";
				case "10":
					return "片花";
				case "11":
					return "公开课";
				case "12":
					return "教育";
				case "13":
					return "时尚";
				case "14":
					return "时尚综艺";
				case "15":
					return "少儿";
				case "16":
					return "微电影";
				case "17":
					return "体育";
				case "18":
					return "奥运";
				case "20":
					return "广告";
				case "21":
					return "生活";
				case "22":
					return "搞笑";
				case "23":
					return "UGC";
				case "24":
					return "财经";
				case "25":
					return "资讯";
				case "26":
					return "汽车";
				case "27":
					return "原创";
				case "32":
					return "健康";
				case "91":
					return "淘米";
				case "95":
					return "直播";
				case "97":
					return "其他";
				case "99":
					return "测试频道";
				default:
					return "";
			}
		}
	}
}
