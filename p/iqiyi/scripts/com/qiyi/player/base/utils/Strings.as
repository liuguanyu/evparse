package com.qiyi.player.base.utils
{
	public class Strings extends Object
	{
		
		public function Strings()
		{
			super();
		}
		
		public static function parseTime(param1:String) : Number
		{
			var _loc4:* = 0;
			var _loc2:Number = 0;
			var _loc3:Array = param1.split(":");
			if(_loc3.length > 1)
			{
				_loc2 = _loc3[0] * 3600;
				_loc2 = _loc2 + _loc3[1] * 60;
				_loc2 = _loc2 + Number(_loc3[2]);
			}
			else
			{
				_loc4 = 0;
				switch(param1.charAt(param1.length - 1))
				{
					case "h":
						_loc4 = 3600;
						break;
					case "m":
						_loc4 = 60;
						break;
					case "s":
						_loc4 = 1;
						break;
				}
				if(_loc4)
				{
					_loc2 = Number(param1.substr(0,param1.length - 1)) * _loc4;
				}
				else
				{
					_loc2 = Number(param1);
				}
			}
			return _loc2;
		}
		
		public static function formatAsTimeCode(param1:Number, param2:Boolean = true) : String
		{
			var _loc3:Number = Math.floor(param1 / 3600);
			_loc3 = isNaN(_loc3)?0:_loc3;
			var _loc4:Number = Math.floor(param1 % 3600 / 60);
			_loc4 = isNaN(_loc4)?0:_loc4;
			var _loc5:Number = Math.floor(param1 % 3600 % 60);
			_loc5 = isNaN(_loc5)?0:_loc5;
			return (_loc3 == 0?param2?"00:":"":_loc3 < 10?"0" + _loc3.toString() + ":":_loc3.toString() + ":") + (_loc4 < 10?"0" + _loc4.toString():_loc4.toString()) + ":" + (_loc5 < 10?"0" + _loc5.toString():_loc5.toString());
		}
		
		public static function trim(param1:String) : String
		{
			var _loc4:* = 0;
			var _loc2:String = param1;
			var _loc3:* = 0;
			while(_loc3 != param1.length)
			{
				_loc4 = param1.charCodeAt(_loc3);
				if(_loc4 > 32)
				{
					break;
				}
				_loc3++;
			}
			_loc2 = param1.substr(_loc3);
			_loc3 = _loc2.length;
			while(_loc3 >= 0)
			{
				_loc4 = param1.charCodeAt(_loc3);
				if(_loc4 > 32)
				{
					break;
				}
				_loc3--;
			}
			_loc2 = _loc2.substr(0,_loc3);
			return _loc2;
		}
		
		public static function getFileExtension(param1:String) : String
		{
			var _loc2:int = param1.lastIndexOf(".");
			if(_loc2 == -1)
			{
				return "";
			}
			return param1.substr(_loc2 + 1);
		}
		
		public static function getFileName(param1:String) : String
		{
			var _loc2:int = param1.lastIndexOf("/");
			if(_loc2 == -1)
			{
				_loc2 = param1.lastIndexOf("\\");
				if(_loc2 == -1)
				{
					return param1;
				}
			}
			return param1.substr(_loc2 + 1);
		}
	}
}
