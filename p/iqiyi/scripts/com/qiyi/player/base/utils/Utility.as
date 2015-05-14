package com.qiyi.player.base.utils
{
	import flash.system.Capabilities;
	import com.qiyi.player.base.pub.EnumItem;
	
	public class Utility extends Object
	{
		
		public function Utility()
		{
			super();
		}
		
		public static function getFlashVersion() : Object
		{
			var _loc1:Object = {};
			var _loc2:String = Capabilities.version;
			var _loc3:int = _loc2.indexOf(" ");
			_loc1.platform = _loc2.substr(0,_loc3);
			_loc2 = _loc2.substr(_loc3 + 1);
			var _loc4:Array = _loc2.split(",");
			_loc1.ver1 = int(_loc4[0]);
			_loc1.ver2 = int(_loc4[1]);
			_loc1.ver3 = int(_loc4[2]);
			_loc1.ver4 = int(_loc4[3]);
			return _loc1;
		}
		
		public static function runtimeSupportsStageVideo() : Boolean
		{
			var _loc1:String = Capabilities.version;
			if(_loc1 == null)
			{
				return false;
			}
			var _loc2:Array = _loc1.split(" ");
			if(_loc2.length < 2)
			{
				return false;
			}
			var _loc3:String = _loc2[0];
			var _loc4:Array = _loc2[1].split(",");
			if(_loc4.length < 2)
			{
				return false;
			}
			var _loc5:Number = parseInt(_loc4[0]);
			var _loc6:Number = parseInt(_loc4[1]);
			return _loc5 > 10 || _loc5 == 10 && _loc6 >= 2;
		}
		
		public static function runtimeSupportsDataMode() : Boolean
		{
			var _loc1:String = Capabilities.version;
			if(_loc1 == null)
			{
				return false;
			}
			var _loc2:Array = _loc1.split(" ");
			if(_loc2.length < 2)
			{
				return false;
			}
			var _loc3:String = _loc2[0];
			var _loc4:Array = _loc2[1].split(",");
			if(_loc4.length < 2)
			{
				return false;
			}
			var _loc5:Number = parseInt(_loc4[0]);
			var _loc6:Number = parseInt(_loc4[1]);
			return _loc5 > 10 || _loc5 == 10 && _loc6 >= 1;
		}
		
		public static function getUrl(param1:String, param2:String) : String
		{
			var _loc3:String = null;
			var _loc4:* = 0;
			var _loc5:* = 0;
			while(_loc5 < param1.length)
			{
				if(param1.substr(_loc5,1) == "/")
				{
					_loc4++;
				}
				if(_loc4 == 3)
				{
					break;
				}
				_loc5++;
			}
			_loc3 = param1.substr(0,_loc5 + 1) + param2 + param1.substr(_loc5);
			return _loc3;
		}
		
		public static function getItemById(param1:Array, param2:int) : EnumItem
		{
			var _loc3:* = undefined;
			for each(_loc3 in param1)
			{
				if(_loc3.id == param2)
				{
					return _loc3;
				}
			}
			return null;
		}
		
		public static function getItemByName(param1:Array, param2:String) : EnumItem
		{
			var _loc3:* = undefined;
			for each(_loc3 in param1)
			{
				if(_loc3.name == param2)
				{
					return _loc3;
				}
			}
			return null;
		}
	}
}
