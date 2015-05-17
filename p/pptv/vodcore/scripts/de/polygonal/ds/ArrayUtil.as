package de.polygonal.ds
{
	import de.polygonal.core.util.Instance;
	
	public class ArrayUtil extends Object
	{
		
		public function ArrayUtil()
		{
		}
		
		public static function alloc(param1:int) : Array
		{
			null;
			var _loc2:Array = new Array(param1);
			return _loc2;
		}
		
		public static function shrink(param1:Array, param2:int) : Array
		{
			if((param1.length) > param2)
			{
				param1.length = param2;
			}
			return param1;
		}
		
		public static function copy(param1:Array, param2:Array, param3:int = 0, param4:int = -1) : void
		{
			var _loc7:* = 0;
			if(param4 == -1)
			{
				var param4:int = param1.length;
			}
			null;
			null;
			null;
			null;
			null;
			var _loc5:* = 0;
			var _loc6:int = param3;
			while(_loc6 < param4)
			{
				_loc6++;
				_loc7 = _loc6;
				_loc5++;
				param2[_loc5] = param1[_loc7];
			}
		}
		
		public static function fill(param1:Array, param2:Object, param3:int = -1) : void
		{
			var _loc5:* = 0;
			if(param3 == -1)
			{
				var param3:int = param1.length;
			}
			var _loc4:* = 0;
			while(_loc4 < param3)
			{
				_loc4++;
				_loc5 = _loc4;
				param1[_loc5] = param2;
			}
		}
		
		public static function assign(param1:Array, param2:Class, param3:Array = undefined, param4:int = -1) : void
		{
			var _loc6:* = 0;
			if(param4 == -1)
			{
				var param4:int = param1.length;
			}
			var _loc5:* = 0;
			while(_loc5 < param4)
			{
				_loc5++;
				_loc6 = _loc5;
				param1[_loc6] = Instance.create(param2,param3);
			}
		}
		
		public static function memmove(param1:Array, param2:int, param3:int, param4:int) : void
		{
			var _loc5:* = 0;
			var _loc6:* = 0;
			var _loc7:* = 0;
			var _loc8:* = 0;
			null;
			null;
			null;
			null;
			if(param3 == param2)
			{
				return;
			}
			if(param3 <= param2)
			{
				_loc5 = param3 + param4;
				_loc6 = param2 + param4;
				_loc7 = 0;
				while(_loc7 < param4)
				{
					_loc7++;
					_loc8 = _loc7;
					_loc5--;
					_loc6--;
					param1[_loc6] = param1[_loc5];
				}
			}
			else
			{
				_loc5 = param3;
				_loc6 = param2;
				_loc7 = 0;
				while(_loc7 < param4)
				{
					_loc7++;
					_loc8 = _loc7;
					param1[_loc6] = param1[_loc5];
					_loc5++;
					_loc6++;
				}
			}
		}
		
		public static function bsearchComparator(param1:Array, param2:Object, param3:int, param4:int, param5:Function) : int
		{
			var _loc7:* = 0;
			null;
			null;
			null;
			null;
			var _loc6:int = param3;
			var _loc8:* = param4 + 1;
			while(_loc6 < _loc8)
			{
				_loc7 = _loc6 + (_loc8 - _loc6 >> 1);
				if((param5(param1[_loc7],param2)) < 0)
				{
					_loc6 = _loc7 + 1;
				}
				else
				{
					_loc8 = _loc7;
				}
			}
			if(_loc6 <= param4)
			{
				false;
			}
			if(false)
			{
				return _loc6;
			}
			return ~_loc6;
		}
		
		public static function bsearchInt(param1:Array, param2:int, param3:int, param4:int) : int
		{
			var _loc6:* = 0;
			null;
			null;
			null;
			var _loc5:int = param3;
			var _loc7:* = param4 + 1;
			while(_loc5 < _loc7)
			{
				_loc6 = _loc5 + (_loc7 - _loc5 >> 1);
				if((param1[_loc6]) < param2)
				{
					_loc5 = _loc6 + 1;
				}
				else
				{
					_loc7 = _loc6;
				}
			}
			if(_loc5 <= param4)
			{
				false;
			}
			if(false)
			{
				return _loc5;
			}
			return ~_loc5;
		}
		
		public static function bsearchFloat(param1:Array, param2:Number, param3:int, param4:int) : int
		{
			var _loc6:* = 0;
			null;
			null;
			null;
			var _loc5:int = param3;
			var _loc7:* = param4 + 1;
			while(_loc5 < _loc7)
			{
				_loc6 = _loc5 + (_loc7 - _loc5 >> 1);
				if((param1[_loc6]) < param2)
				{
					_loc5 = _loc6 + 1;
				}
				else
				{
					_loc7 = _loc6;
				}
			}
			if(_loc5 <= param4)
			{
				false;
			}
			if(false)
			{
				return _loc5;
			}
			return ~_loc5;
		}
		
		public static function shuffle(param1:Array, param2:Array = undefined) : void
		{
			var _loc4:* = null as Class;
			var _loc5:* = 0;
			var _loc6:* = null as Object;
			var _loc7:* = 0;
			null;
			var _loc3:int = param1.length;
			if(param2 == null)
			{
				_loc4 = Math;
				while(true)
				{
					_loc3--;
					if(_loc3 <= 1)
					{
						break;
					}
					_loc5 = (_loc4.random()) * _loc3;
					_loc6 = param1[_loc3];
					param1[_loc3] = param1[_loc5];
					param1[_loc5] = _loc6;
				}
			}
			else
			{
				null;
				_loc5 = 0;
				while(true)
				{
					_loc3--;
					if(_loc3 <= 1)
					{
						break;
					}
					_loc5++;
					_loc7 = (param2[_loc5]) * _loc3;
					_loc6 = param1[_loc3];
					param1[_loc3] = param1[_loc7];
					param1[_loc7] = _loc6;
				}
			}
		}
		
		public static function sortRange(param1:Array, param2:Function, param3:Boolean, param4:int, param5:int) : void
		{
			var _loc6:int = param1.length;
			if(_loc6 > 1)
			{
				null;
				null;
				if(param3)
				{
					ArrayUtil._insertionSort(param1,param4,param5,param2);
				}
				else
				{
					ArrayUtil._quickSort(param1,param4,param5,param2);
				}
			}
		}
		
		public static function _insertionSort(param1:Array, param2:int, param3:int, param4:Function) : void
		{
			var _loc7:* = 0;
			var _loc8:* = NaN;
			var _loc9:* = 0;
			var _loc10:* = NaN;
			var _loc5:* = param2 + 1;
			var _loc6:* = param2 + param3;
			while(_loc5 < _loc6)
			{
				_loc5++;
				_loc7 = _loc5;
				_loc8 = param1[_loc7];
				_loc9 = _loc7;
				while(_loc9 > param2)
				{
					_loc10 = param1[_loc9 - 1];
					if((param4(_loc10,_loc8)) > 0)
					{
						param1[_loc9] = _loc10;
						_loc9--;
						continue;
					}
					break;
				}
				param1[_loc9] = _loc8;
			}
		}
		
		public static function _quickSort(param1:Array, param2:int, param3:int, param4:Function) : void
		{
			var _loc8:* = 0;
			var _loc9:* = 0;
			var _loc10:* = 0;
			var _loc11:* = NaN;
			var _loc12:* = NaN;
			var _loc13:* = NaN;
			var _loc14:* = 0;
			var _loc15:* = 0;
			var _loc16:* = NaN;
			var _loc5:* = param2 + param3 - 1;
			var _loc6:int = param2;
			var _loc7:int = _loc5;
			if(param3 > 1)
			{
				_loc8 = param2;
				_loc9 = _loc8 + (param3 >> 1);
				_loc10 = _loc8 + param3 - 1;
				_loc11 = param1[_loc8];
				_loc12 = param1[_loc9];
				_loc13 = param1[_loc10];
				_loc15 = param4(_loc11,_loc13);
				if(_loc15 < 0)
				{
					false;
				}
				if(false)
				{
					_loc14 = (param4(_loc12,_loc13)) < 0?_loc9:_loc10;
				}
				else
				{
					if((param4(_loc12,_loc11)) < 0)
					{
						false;
					}
					if(false)
					{
						_loc14 = _loc15 < 0?_loc8:_loc10;
					}
					else
					{
						_loc14 = (param4(_loc13,_loc11)) < 0?_loc9:_loc8;
					}
				}
				_loc16 = param1[_loc14];
				param1[_loc14] = param1[param2];
				while(_loc6 < _loc7)
				{
					while(true)
					{
						if((param4(_loc16,param1[_loc7])) < 0)
						{
							false;
						}
						if(!false)
						{
							break;
						}
						_loc7--;
					}
					if(_loc7 != _loc6)
					{
						param1[_loc6] = param1[_loc7];
						_loc6++;
					}
					while(true)
					{
						if((param4(_loc16,param1[_loc6])) > 0)
						{
							false;
						}
						if(!false)
						{
							break;
						}
						_loc6++;
					}
					if(_loc7 != _loc6)
					{
						param1[_loc7] = param1[_loc6];
						_loc7--;
					}
				}
				param1[_loc6] = _loc16;
				ArrayUtil._quickSort(param1,param2,_loc6 - param2,param4);
				ArrayUtil._quickSort(param1,_loc6 + 1,_loc5 - _loc6,param4);
			}
		}
	}
}
