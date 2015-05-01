package gs.plugins {
	import gs.*;
	import gs.utils.tween.*;
	
	public class TweenPlugin extends Object {
		
		public function TweenPlugin() {
			_tweens = [];
			super();
		}
		
		public static const VERSION:Number = 1.03;
		
		public static const API:Number = 1;
		
		public static function activate(param1:Array) : Boolean {
			var _loc2_:* = 0;
			var _loc3_:Object = null;
			_loc2_ = param1.length - 1;
			while(_loc2_ > -1) {
				_loc3_ = new param1[_loc2_]();
				TweenLite.plugins[_loc3_.propName] = param1[_loc2_];
				_loc2_--;
			}
			return true;
		}
		
		protected function updateTweens(param1:Number) : void {
			var _loc2_:* = 0;
			var _loc3_:TweenInfo = null;
			var _loc4_:* = NaN;
			var _loc5_:* = 0;
			if(this.round) {
				_loc2_ = _tweens.length - 1;
				while(_loc2_ > -1) {
					_loc3_ = _tweens[_loc2_];
					_loc4_ = _loc3_.start + _loc3_.change * param1;
					_loc5_ = _loc4_ < 0?-1:1;
					_loc3_.target[_loc3_.property] = _loc4_ % 1 * _loc5_ > 0.5?int(_loc4_) + _loc5_:int(_loc4_);
					_loc2_--;
				}
			} else {
				_loc2_ = _tweens.length - 1;
				while(_loc2_ > -1) {
					_loc3_ = _tweens[_loc2_];
					_loc3_.target[_loc3_.property] = _loc3_.start + _loc3_.change * param1;
					_loc2_--;
				}
			}
		}
		
		public var overwriteProps:Array;
		
		protected var _tweens:Array;
		
		public function set changeFactor(param1:Number) : void {
			updateTweens(param1);
			_changeFactor = param1;
		}
		
		protected function addTween(param1:Object, param2:String, param3:Number, param4:*, param5:String = null) : void {
			var _loc6_:* = NaN;
			if(param4 != null) {
				_loc6_ = typeof param4 == "number"?param4 - param3:Number(param4);
				if(_loc6_ != 0) {
					_tweens[_tweens.length] = new TweenInfo(param1,param2,param3,_loc6_,param5 || param2,false);
				}
			}
		}
		
		public function killProps(param1:Object) : void {
			var _loc2_:* = 0;
			_loc2_ = this.overwriteProps.length - 1;
			while(_loc2_ > -1) {
				if(this.overwriteProps[_loc2_] in param1) {
					this.overwriteProps.splice(_loc2_,1);
				}
				_loc2_--;
			}
			_loc2_ = _tweens.length - 1;
			while(_loc2_ > -1) {
				if(_tweens[_loc2_].name in param1) {
					_tweens.splice(_loc2_,1);
				}
				_loc2_--;
			}
		}
		
		public function onInitTween(param1:Object, param2:*, param3:TweenLite) : Boolean {
			addTween(param1,this.propName,param1[this.propName],param2,this.propName);
			return true;
		}
		
		public var propName:String;
		
		public var onComplete:Function;
		
		public var round:Boolean;
		
		protected var _changeFactor:Number = 0;
		
		public function get changeFactor() : Number {
			return _changeFactor;
		}
	}
}