package com.pplive.mx
{
	import flash.events.Event;
	
	public class PropertyChangeEvent extends Event
	{
		
		public static const PROPERTY_CHANGE:String = "propertyChange";
		
		public var kind:String;
		
		public var newValue:Object;
		
		public var oldValue:Object;
		
		public var property:Object;
		
		public var source:Object;
		
		public function PropertyChangeEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:String = null, param5:Object = null, param6:Object = null, param7:Object = null, param8:Object = null)
		{
			super(param1,param2,param3);
			this.kind = param4;
			this.property = param5;
			this.oldValue = param6;
			this.newValue = param7;
			this.source = param8;
		}
		
		public static function createUpdateEvent(param1:Object, param2:Object, param3:Object, param4:Object) : PropertyChangeEvent
		{
			var _loc5:PropertyChangeEvent = new PropertyChangeEvent(PROPERTY_CHANGE);
			_loc5.kind = PropertyChangeEventKind.UPDATE;
			_loc5.oldValue = param3;
			_loc5.newValue = param4;
			_loc5.source = param1;
			_loc5.property = param2;
			return _loc5;
		}
		
		override public function clone() : Event
		{
			return new PropertyChangeEvent(type,bubbles,cancelable,this.kind,this.property,this.oldValue,this.newValue,this.source);
		}
	}
}
