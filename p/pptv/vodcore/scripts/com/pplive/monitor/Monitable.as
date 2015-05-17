package com.pplive.monitor
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	public class Monitable extends EventDispatcher implements IMonitable
	{
		
		protected var _monitor:Monitor;
		
		public function Monitable(param1:String)
		{
			super();
			this._monitor = new Monitor(param1,this);
		}
		
		public function get monitor() : Monitor
		{
			return this._monitor;
		}
		
		public function updateMonitedAttributes(param1:Dictionary) : void
		{
		}
	}
}
