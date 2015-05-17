package org.as3commons.logging.setup.target
{
	import flash.text.TextField;
	import org.as3commons.logging.util.LogMessageFormatter;
	
	public final class TextFieldTarget extends TextField implements IFormattingLogTarget
	{
		
		public static const DEFAULT_FORMAT:String = "{time} {logLevel} - {shortName}{atPerson} - {message}\n";
		
		private var _formatter:LogMessageFormatter;
		
		private var _textField:TextField;
		
		public function TextFieldTarget(param1:String = null, param2:TextField = null)
		{
			super();
			this.format = param1;
			this._textField = param2 || this;
		}
		
		public function log(param1:String, param2:String, param3:int, param4:Number, param5:*, param6:Array, param7:String) : void
		{
			this._textField.appendText(this._formatter.format(param1,param2,param3,param4,param5,param6,param7));
		}
		
		public function set format(param1:String) : void
		{
			this._formatter = new LogMessageFormatter(param1 || DEFAULT_FORMAT);
		}
	}
}
