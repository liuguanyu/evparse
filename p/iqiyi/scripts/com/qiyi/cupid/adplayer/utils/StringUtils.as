package com.qiyi.cupid.adplayer.utils
{
	public class StringUtils extends Object
	{
		
		public function StringUtils()
		{
			super();
		}
		
		public static function trim(param1:String) : String
		{
			var _loc2:* = "";
			var _loc3:* = 0;
			while(_loc3 < param1.length)
			{
				if(param1.charAt(_loc3) != " ")
				{
					_loc2 = _loc2 + param1.charAt(_loc3);
				}
				_loc3++;
			}
			return _loc2;
		}
		
		public static function isEmpty(param1:String) : Boolean
		{
			if(param1 == null)
			{
				return true;
			}
			return StringUtils.trim(param1).length == 0;
		}
		
		public static function removeControlChars(param1:String) : String
		{
			var _loc2:String = null;
			var _loc3:Array = null;
			if(param1 != null)
			{
				_loc2 = param1;
				_loc2 = _loc2.split("\t").join(" ");
				_loc2 = _loc2.split("\r").join(" ");
				_loc2 = _loc2.split("\n").join(" ");
				return _loc2;
			}
			return param1;
		}
		
		public static function compressWhitespace(param1:String) : String
		{
			var _loc3:Array = null;
			var _loc2:String = param1;
			_loc3 = _loc2.split(" ");
			var _loc4:uint = 0;
			while(_loc4 < _loc3.length)
			{
				if(_loc3[_loc4] == "")
				{
					_loc3.splice(_loc4,1);
					_loc4--;
				}
				_loc4++;
			}
			_loc2 = _loc3.join(" ");
			return _loc2;
		}
		
		public static function concatEnsuringSeparator(param1:String, param2:String, param3:String) : String
		{
			if((StringUtils.endsWith(param1,param3)) || (StringUtils.beginsWith(param2,param3)))
			{
				return param1 + param2;
			}
			return param1 + param3 + param2;
		}
		
		public static function beginsWith(param1:String, param2:String) : Boolean
		{
			if(param1 == null)
			{
				return false;
			}
			return StringUtils.trim(param1).indexOf(param2) == 0;
		}
		
		public static function endsWith(param1:String, param2:String) : Boolean
		{
			if(param1 == null)
			{
				return false;
			}
			return param1.lastIndexOf(param2) == param1.length - param2.length;
		}
		
		public static function revertSingleQuotes(param1:String, param2:String) : String
		{
			var _loc3:RegExp = new RegExp("{quote}","g");
			return param1.replace(_loc3,param2);
		}
		
		public static function replaceSingleWithDoubleQuotes(param1:String) : String
		{
			var _loc2:RegExp = new RegExp("\'","g");
			return param1.replace(_loc2,"\"");
		}
		
		public static function escapeString(param1:String) : String
		{
			var _loc2:RegExp = new RegExp("([\'\\\"\\\\])","g");
			return param1.replace(_loc2,"\\$1");
		}
		
		public static function getQuery(param1:String, param2:String) : String
		{
			var _loc3:RegExp = new RegExp("(^|&|\\?|#)" + param2 + "=([^&]*)(&|$)");
			var _loc4:Array = param1.match(_loc3);
			if(_loc4)
			{
				return _loc4[2];
			}
			return "";
		}
	}
}
