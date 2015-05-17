package flash
{
	import flash.display.MovieClip;
	import flash.utils.getTimer;
	import flash.utils.getDefinitionByName;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.fscommand;
	
	public class Lib extends Object
	{
		
		public static var current:MovieClip;
		
		public function Lib()
		{
		}
		
		public static function getTimer() : int
		{
			return flash.utils.getTimer();
		}
		
		public static function eval(param1:String) : *
		{
			var _loc6:* = null;
			var _loc8:* = null as String;
			var _loc3:Array = param1.split(".");
			var _loc4:Array = [];
			var _loc5:* = null;
			if((_loc3.length) > 0)
			{
				try
				{
					_loc5 = getDefinitionByName(_loc3.join("."));
				}
			}
			var _loc7:* = 0;
			while(_loc7 < (_loc4.length))
			{
				_loc8 = _loc4[_loc7];
				_loc7++;
				if(_loc5 == null)
				{
					return null;
				}
				_loc5 = _loc5[_loc8];
			}
			return _loc5;
		}
		
		public static function getURL(param1:URLRequest, param2:String = undefined) : void
		{
			var _loc3:Function = navigateToURL;
			if(param2 == null)
			{
				_loc3(param1);
			}
			else
			{
				_loc3(param1,param2);
			}
		}
		
		public static function fscommand(param1:String, param2:String = undefined) : void
		{
			flash.system.fscommand(param1,param2 == null?"":param2);
		}
		
		public static function trace(param1:*) : void
		{
			trace(param1);
		}
		
		public static function attach(param1:String) : MovieClip
		{
			var _loc2:* = getDefinitionByName(param1) as Class;
			return new _loc2();
		}
		
		public static function method_1(param1:*, param2:Class) : Object
		{
			return param1 as param2;
		}
	}
}
