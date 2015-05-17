package de.polygonal.core.util
{
	import flash.Boot;
	
	public class Instance extends Object
	{
		
		public function Instance()
		{
		}
		
		public static function create(param1:Class, param2:Array = undefined) : Object
		{
			if(param2 == null)
			{
				return new param1();
			}
		}
		
		public static function createEmpty(param1:Class) : Object
		{
			var _loc3:* = null as Object;
			var _loc4:* = null;
			try
			{
				Boot.skip_constructor = true;
				_loc3 = new param1();
				Boot.skip_constructor = false;
				return _loc3;
			}
		}
	}
}
