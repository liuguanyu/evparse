package org.as3commons.logging.setup.target
{
	import org.as3commons.logging.util.clone;
	
	public final class LogStatement extends Object
	{
		
		public var name:String;
		
		public var shortName:String;
		
		public var level:int;
		
		public var timeStamp:Number;
		
		public var person:String;
		
		public var doClone:Boolean;
		
		private var _message;
		
		private var _parameters:Array;
		
		private var introspectDepth:uint;
		
		public function LogStatement(param1:String, param2:String, param3:int, param4:Number, param5:*, param6:Array, param7:String, param8:uint, param9:Boolean = true)
		{
			super();
			this.introspectDepth = param8;
			this.name = param1;
			this.shortName = param2;
			this.level = param3;
			this.timeStamp = param4;
			this.message = param5;
			this.parameters = param6;
			this.person = param7;
			this.doClone = param9;
		}
		
		public function get message() : *
		{
			return this._message;
		}
		
		public function set message(param1:*) : void
		{
			if(this.doClone)
			{
				this._message = clone(param1,this.introspectDepth);
			}
			else
			{
				this._message = param1;
			}
		}
		
		public function get parameters() : Array
		{
			return this._parameters;
		}
		
		public function set parameters(param1:Array) : void
		{
			if(this.doClone)
			{
				this._parameters = clone(param1,this.introspectDepth);
			}
			else
			{
				this._parameters = param1;
			}
		}
	}
}
