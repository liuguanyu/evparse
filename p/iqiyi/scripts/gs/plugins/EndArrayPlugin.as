package gs.plugins
{
	import gs.*;
	import flash.display.*;
	import gs.utils.tween.*;
	
	public class EndArrayPlugin extends TweenPlugin
	{
		
		public static const VERSION:Number = 1.01;
		
		public static const API:Number = 1;
		
		protected var _a:Array;
		
		protected var _info:Array;
		
		public function EndArrayPlugin()
		{
			_info = [];
			super();
			this.propName = "endArray";
			this.overwriteProps = ["endArray"];
		}
		
		public function init(param1:Array, param2:Array) : void
		{
			_a = param1;
			var _loc3:int = param2.length - 1;
			while(_loc3 > -1)
			{
				if(!(param1[_loc3] == param2[_loc3]) && !(param1[_loc3] == null))
				{
					_info[_info.length] = new ArrayTweenInfo(_loc3,_a[_loc3],param2[_loc3] - _a[_loc3]);
				}
				_loc3--;
			}
		}
		
		override public function onInitTween(param1:Object, param2:*, param3:TweenLite) : Boolean
		{
			if(!(param1 is Array) || !(param2 is Array))
			{
				return false;
			}
			init(param1 as Array,param2);
			return true;
		}
		
		override public function set changeFactor(param1:Number) : void
		{
			var _loc2:* = 0;
			var _loc3:ArrayTweenInfo = null;
			var _loc4:* = NaN;
			var _loc5:* = 0;
			if(this.round)
			{
				_loc2 = _info.length - 1;
				while(_loc2 > -1)
				{
					_loc3 = _info[_loc2];
					_loc4 = _loc3.start + _loc3.change * param1;
					_loc5 = _loc4 < 0?-1:1;
					_a[_loc3.index] = _loc4 % 1 * _loc5 > 0.5?int(_loc4) + _loc5:int(_loc4);
					_loc2--;
				}
			}
			else
			{
				_loc2 = _info.length - 1;
				while(_loc2 > -1)
				{
					_loc3 = _info[_loc2];
					_a[_loc3.index] = _loc3.start + _loc3.change * param1;
					_loc2--;
				}
			}
		}
	}
}
