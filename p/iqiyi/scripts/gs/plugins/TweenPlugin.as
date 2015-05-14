package gs.plugins
{
	import gs.*;
	import gs.utils.tween.*;
	
	public class TweenPlugin extends Object
	{
		
		public static const VERSION:Number = 1.03;
		
		public static const API:Number = 1;
		
		public var overwriteProps:Array;
		
		protected var _tweens:Array;
		
		public var propName:String;
		
		public var onComplete:Function;
		
		public var round:Boolean;
		
		protected var _changeFactor:Number = 0;
		
		public function TweenPlugin()
		{
			_tweens = [];
			super();
		}
		
		public static function activate(param1:Array) : Boolean
		{
			var _loc2:* = 0;
			var _loc3:Object = null;
			_loc2 = param1.length - 1;
			while(_loc2 > -1)
			{
				_loc3 = new param1[_loc2]();
				TweenLite.plugins[_loc3.propName] = param1[_loc2];
				_loc2--;
			}
			return true;
		}
		
		protected function updateTweens(param1:Number) : void
		{
			var _loc2:* = 0;
			var _loc3:TweenInfo = null;
			var _loc4:* = NaN;
			var _loc5:* = 0;
			if(this.round)
			{
				_loc2 = _tweens.length - 1;
				while(_loc2 > -1)
				{
					_loc3 = _tweens[_loc2];
					_loc4 = _loc3.start + _loc3.change * param1;
					_loc5 = _loc4 < 0?-1:1;
					_loc3.target[_loc3.property] = _loc4 % 1 * _loc5 > 0.5?int(_loc4) + _loc5:int(_loc4);
					_loc2--;
				}
			}
			else
			{
				_loc2 = _tweens.length - 1;
				while(_loc2 > -1)
				{
					_loc3 = _tweens[_loc2];
					_loc3.target[_loc3.property] = _loc3.start + _loc3.change * param1;
					_loc2--;
				}
			}
		}
		
		public function set changeFactor(param1:Number) : void
		{
			updateTweens(param1);
			_changeFactor = param1;
		}
		
		protected function addTween(param1:Object, param2:String, param3:Number, param4:*, param5:String = null) : void
		{
			var _loc6:* = NaN;
			if(param4 != null)
			{
				_loc6 = typeof param4 == "number"?param4 - param3:Number(param4);
				if(_loc6 != 0)
				{
					_tweens[_tweens.length] = new TweenInfo(param1,param2,param3,_loc6,param5 || param2,false);
				}
			}
		}
		
		public function killProps(param1:Object) : void
		{
			var _loc2:* = 0;
			_loc2 = this.overwriteProps.length - 1;
			while(_loc2 > -1)
			{
				if(this.overwriteProps[_loc2] in param1)
				{
					this.overwriteProps.splice(_loc2,1);
				}
				_loc2--;
			}
			_loc2 = _tweens.length - 1;
			while(_loc2 > -1)
			{
				if(_tweens[_loc2].name in param1)
				{
					_tweens.splice(_loc2,1);
				}
				_loc2--;
			}
		}
		
		public function onInitTween(param1:Object, param2:*, param3:TweenLite) : Boolean
		{
			addTween(param1,this.propName,param1[this.propName],param2,this.propName);
			return true;
		}
		
		public function get changeFactor() : Number
		{
			return _changeFactor;
		}
	}
}
