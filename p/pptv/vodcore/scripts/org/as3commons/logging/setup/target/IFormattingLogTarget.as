package org.as3commons.logging.setup.target
{
	import org.as3commons.logging.setup.ILogTarget;
	
	public interface IFormattingLogTarget extends ILogTarget
	{
		
		function set format(param1:String) : void;
	}
}
