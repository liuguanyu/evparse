package gs.plugins
{
	import gs.*;
	import flash.display.*;
	
	public class VisiblePlugin extends TweenPlugin
	{
		
		public static const VERSION:Number = 1;
		
		public static const API:Number = 1;
		
		protected var _target:Object;
		
		protected var _visible:Boolean;
		
		protected var _tween:TweenLite;
		
		public function VisiblePlugin()
		{
			super();
			this.propName = "visible";
			this.overwriteProps = ["visible"];
			this.onComplete = onCompleteTween;
		}
		
		public function onCompleteTween() : void
		{
			if(!(_tween.vars.runBackwards == true) && _tween.ease == _tween.vars.ease)
			{
				_target.visible = _visible;
			}
		}
		
		override public function onInitTween(param1:Object, param2:*, param3:TweenLite) : Boolean
		{
			_target = param1;
			_tween = param3;
			_visible = Boolean(param2);
			return true;
		}
		
		override public function set changeFactor(param1:Number) : void
		{
			if(_target.visible != true)
			{
				_target.visible = true;
			}
		}
	}
}
