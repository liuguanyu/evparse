package com.qiyi.player.base.utils
{
	import flash.text.Font;
	
	public class FontUtils extends Object
	{
		
		public function FontUtils()
		{
			super();
		}
		
		public static function hasFont(param1:String) : Boolean
		{
			var _loc2:Array = Font.enumerateFonts(true);
			var _loc3:int = _loc2.length;
			var _loc4:* = 0;
			while(_loc4 < _loc3)
			{
				if(_loc2[_loc4].fontName == param1)
				{
					return true;
				}
				_loc4++;
			}
			return false;
		}
	}
}
