package com.pplive.util
{
	import flash.display.DisplayObjectContainer;
	import flash.system.Capabilities;
	import flash.events.KeyboardEvent;
	import org.as3commons.logging.api.LOGGER_FACTORY;
	import org.as3commons.logging.util.LogMessageFormatter;
	import org.as3commons.logging.setup.target.*;
	import org.as3commons.logging.setup.*;
	
	public class LogTarget extends Object
	{
		
		private static var textTarget:TextFieldTarget;
		
		private static var bufferTarget:BufferTarget;
		
		public function LogTarget()
		{
			super();
		}
		
		public static function set container(param1:DisplayObjectContainer) : void
		{
			var _loc2:TraceTarget = null;
			if(param1 != null)
			{
				textTarget = new TextFieldTarget();
				textTarget.visible = false;
				textTarget.x = -Capabilities.screenResolutionX / 2;
				textTarget.y = -Capabilities.screenResolutionY / 2;
				textTarget.width = Capabilities.screenResolutionX;
				textTarget.height = Capabilities.screenResolutionY;
				if(param1.stage)
				{
					param1.stage.addEventListener(KeyboardEvent.KEY_DOWN,keyEventHandler);
				}
				LOGGER_FACTORY.setup = new LevelTargetSetup(textTarget,LogSetupLevel.INFO);
				param1.addChild(textTarget);
			}
			else
			{
				_loc2 = new TraceTarget();
				LOGGER_FACTORY.setup = new LevelTargetSetup(_loc2,LogSetupLevel.DEBUG);
			}
		}
		
		public static function useBufferTarget(param1:uint = 2000) : void
		{
			if(bufferTarget == null)
			{
				bufferTarget = new BufferTarget(param1);
			}
			LOGGER_FACTORY.setup = new LevelTargetSetup(bufferTarget,LogSetupLevel.INFO);
		}
		
		public static function get statements() : Vector.<String>
		{
			var _loc2:Array = null;
			var _loc3:LogMessageFormatter = null;
			var _loc4:uint = 0;
			var _loc5:uint = 0;
			var _loc6:LogStatement = null;
			var _loc1:Vector.<String> = new Vector.<String>();
			if(bufferTarget != null)
			{
				_loc2 = bufferTarget.statements;
				_loc3 = new LogMessageFormatter(TextFieldTarget.DEFAULT_FORMAT);
				_loc4 = 0;
				_loc5 = _loc2.length;
				while(_loc4 < _loc5)
				{
					_loc6 = _loc2[_loc4];
					_loc1.push(_loc3.format(_loc6.name,_loc6.shortName,_loc6.level,_loc6.timeStamp,_loc6.message,_loc6.parameters,_loc6.person));
					_loc4++;
				}
			}
			return _loc1;
		}
		
		private static function keyEventHandler(param1:KeyboardEvent) : void
		{
			if((param1.altKey) && (param1.ctrlKey) && param1.keyCode == 80)
			{
				textTarget.visible = !textTarget.visible;
			}
		}
	}
}
