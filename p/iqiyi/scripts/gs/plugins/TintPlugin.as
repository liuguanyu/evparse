package gs.plugins
{
	import flash.geom.ColorTransform;
	import flash.display.*;
	import gs.*;
	import gs.utils.tween.TweenInfo;
	
	public class TintPlugin extends TweenPlugin
	{
		
		protected static var _props:Array = ["redMultiplier","greenMultiplier","blueMultiplier","alphaMultiplier","redOffset","greenOffset","blueOffset","alphaOffset"];
		
		public static const VERSION:Number = 1.1;
		
		public static const API:Number = 1;
		
		protected var _target:DisplayObject;
		
		protected var _ct:ColorTransform;
		
		protected var _ignoreAlpha:Boolean;
		
		public function TintPlugin()
		{
			super();
			this.propName = "tint";
			this.overwriteProps = ["tint"];
		}
		
		public function init(param1:DisplayObject, param2:ColorTransform) : void
		{
			var _loc3:* = 0;
			var _loc4:String = null;
			_target = param1;
			_ct = _target.transform.colorTransform;
			_loc3 = _props.length - 1;
			while(_loc3 > -1)
			{
				_loc4 = _props[_loc3];
				if(_ct[_loc4] != param2[_loc4])
				{
					_tweens[_tweens.length] = new TweenInfo(_ct,_loc4,_ct[_loc4],param2[_loc4] - _ct[_loc4],"tint",false);
				}
				_loc3--;
			}
		}
		
		override public function onInitTween(param1:Object, param2:*, param3:TweenLite) : Boolean
		{
			if(!(param1 is DisplayObject))
			{
				return false;
			}
			var _loc4:ColorTransform = new ColorTransform();
			if(!(param2 == null) && !(param3.exposedVars.removeTint == true))
			{
				_loc4.color = uint(param2);
			}
			_ignoreAlpha = true;
			init(param1 as DisplayObject,_loc4);
			return true;
		}
		
		override public function set changeFactor(param1:Number) : void
		{
			var _loc2:ColorTransform = null;
			updateTweens(param1);
			if(_ignoreAlpha)
			{
				_loc2 = _target.transform.colorTransform;
				_ct.alphaMultiplier = _loc2.alphaMultiplier;
				_ct.alphaOffset = _loc2.alphaOffset;
			}
			_target.transform.colorTransform = _ct;
		}
	}
}
