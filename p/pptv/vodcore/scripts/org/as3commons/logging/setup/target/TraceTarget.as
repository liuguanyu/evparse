package org.as3commons.logging.setup.target
{
	import org.as3commons.logging.util.LogMessageFormatter;
	
	public final class TraceTarget extends Object implements IFormattingLogTarget
	{
		
		public static const DEFAULT_FORMAT:String = "{time} {logLevel} - {shortName}{atPerson} - {message}";
		
		private var _formatter:LogMessageFormatter;
		
		public function TraceTarget(param1:String = null)
		{
			super();
			this.format = param1;
		}
		
		public function set format(param1:String) : void
		{
			this._formatter = new LogMessageFormatter(param1 || DEFAULT_FORMAT);
		}
		
		public function log(param1:String, param2:String, param3:int, param4:Number, param5:*, param6:Array, param7:String) : void
		{
			trace(this._formatter.format(param1,param2,param3,param4,param5,param6,param7));
		}
	}
}
