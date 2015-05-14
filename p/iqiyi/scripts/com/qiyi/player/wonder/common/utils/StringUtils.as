package com.qiyi.player.wonder.common.utils
{
	import flash.utils.ByteArray;
	
	public class StringUtils extends Object
	{
		
		public function StringUtils()
		{
			super();
		}
		
		public static function encodeGBK(param1:String) : String
		{
			var _loc4:* = 0;
			var _loc2:* = "";
			var _loc3:ByteArray = new ByteArray();
			_loc3.writeMultiByte(param1,"gbk");
			while(_loc4 < _loc3.length)
			{
				_loc2 = _loc2 + escape(String.fromCharCode(_loc3[_loc4]));
				_loc4++;
			}
			return _loc2;
		}
		
		public static function remainWord(param1:String, param2:uint, param3:String = "...") : String
		{
			var _loc4:* = "";
			if(param1.length > param2)
			{
				_loc4 = param1.substr(0,param2) + param3;
			}
			else
			{
				_loc4 = param1;
			}
			return _loc4;
		}
		
		public static function substitute(param1:String, ... rest) : String
		{
			if(param1 == null)
			{
				return "";
			}
			var _loc3:uint = rest.length;
			var _loc4:Array = null;
			if(_loc3 == 1 && rest[0] is Array)
			{
				_loc4 = rest[0] as Array;
				_loc3 = _loc4.length;
			}
			else
			{
				_loc4 = rest;
			}
			var _loc5:* = 0;
			while(_loc5 < _loc3)
			{
				var param1:String = param1.replace(new RegExp("\\{" + _loc5 + "\\}","g"),_loc4[_loc5]);
				_loc5++;
			}
			return param1;
		}
	}
}
