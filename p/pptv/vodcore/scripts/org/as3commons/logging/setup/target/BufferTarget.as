package org.as3commons.logging.setup.target
{
	public final class BufferTarget extends Object implements IAsyncLogTarget
	{
		
		private var _logStatements:Array;
		
		private var _length:int = 0;
		
		private var _introspectDepth:uint;
		
		private var _maxStatements:uint;
		
		private var _clone:Boolean;
		
		public function BufferTarget(param1:uint = 4.294967295E9, param2:uint = 5, param3:Boolean = true)
		{
			this._logStatements = new Array();
			super();
			if(param1 == 0)
			{
				throw new Error("Buffer must have a size bigger than 0!");
			}
			else
			{
				this._maxStatements = param1;
				this._introspectDepth = param2;
				this._clone = param3;
				return;
			}
		}
		
		public function set maxStatements(param1:uint) : void
		{
			this._maxStatements = param1;
		}
		
		public function get statements() : Array
		{
			return this._logStatements;
		}
		
		public function set introspectDepth(param1:uint) : void
		{
			this._introspectDepth = param1;
		}
		
		public function log(param1:String, param2:String, param3:int, param4:Number, param5:*, param6:Array, param7:String) : void
		{
			var _loc8:LogStatement = null;
			if(this._maxStatements == this._length)
			{
				_loc8 = this._logStatements.shift();
				_loc8.name = param1;
				_loc8.shortName = param2;
				_loc8.level = param3;
				_loc8.timeStamp = param4;
				_loc8.doClone = this._clone;
				_loc8.parameters = param6;
				_loc8.message = param5;
				_loc8.person = param7;
				this._logStatements[this._length - 1] = _loc8;
			}
			else
			{
				this._logStatements[this._length++] = new LogStatement(param1,param2,param3,param4,param5,param6,param7,this._introspectDepth,this._clone);
			}
		}
		
		public function clear() : void
		{
			this._logStatements = [];
			this._length = 0;
		}
	}
}
