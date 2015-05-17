package com.pplive.util
{
	import flash.events.IEventDispatcher;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class EventUtil extends Object
	{
		
		public function EventUtil()
		{
			super();
		}
		
		public static function deferDispatch(param1:IEventDispatcher, param2:Event, param3:uint) : void
		{
			var dispatcher:IEventDispatcher = param1;
			var event:Event = param2;
			var delay:uint = param3;
			var timer:Timer = new Timer(delay,1);
			timer.addEventListener(TimerEvent.TIMER,function():void
			{
				dispatcher.dispatchEvent(event);
			});
			timer.start();
		}
	}
}
