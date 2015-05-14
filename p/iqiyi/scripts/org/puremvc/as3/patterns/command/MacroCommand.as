package org.puremvc.as3.patterns.command
{
	import org.puremvc.as3.patterns.observer.Notifier;
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotifier;
	import org.puremvc.as3.interfaces.INotification;
	
	public class MacroCommand extends Notifier implements ICommand, INotifier
	{
		
		private var subCommands:Array;
		
		public function MacroCommand()
		{
			super();
			subCommands = new Array();
			initializeMacroCommand();
		}
		
		public final function execute(param1:INotification) : void
		{
			var _loc2:Class = null;
			var _loc3:ICommand = null;
			while(subCommands.length > 0)
			{
				_loc2 = subCommands.shift();
				_loc3 = new _loc2();
				_loc3.execute(param1);
			}
		}
		
		protected function addSubCommand(param1:Class) : void
		{
			subCommands.push(param1);
		}
		
		protected function initializeMacroCommand() : void
		{
		}
	}
}
