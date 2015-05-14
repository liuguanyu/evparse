package com.iqiyi.components.global
{
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	
	public class GlobalStage extends Object
	{
		
		private static var _stage:Stage;
		
		private static var _customStage:ICustomStage;
		
		public function GlobalStage()
		{
			super();
		}
		
		public static function get stage() : Stage
		{
			return _stage;
		}
		
		public static function get customStage() : ICustomStage
		{
			return _customStage;
		}
		
		public static function isFullScreen() : Boolean
		{
			if(_customStage)
			{
				return _customStage.isFullScreen();
			}
			return _stage.displayState == StageDisplayState.FULL_SCREEN;
		}
		
		public static function setFullScreen() : void
		{
			if(_customStage)
			{
				_customStage.setFullScreen();
			}
			else if(_stage.displayState == StageDisplayState.NORMAL)
			{
				_stage.displayState = StageDisplayState.FULL_SCREEN;
			}
			
		}
		
		public static function setNormalScreen() : void
		{
			if(_customStage)
			{
				_customStage.setNormalScreen();
			}
			else if(_stage.displayState == StageDisplayState.FULL_SCREEN)
			{
				_stage.displayState = StageDisplayState.NORMAL;
			}
			
		}
		
		public static function initStage(param1:Stage) : void
		{
			if(param1)
			{
				_stage = param1;
			}
		}
		
		public static function initCustomStage(param1:ICustomStage) : void
		{
			if(param1)
			{
				_customStage = param1;
			}
		}
	}
}
