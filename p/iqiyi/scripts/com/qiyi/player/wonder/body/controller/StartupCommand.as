package com.qiyi.player.wonder.body.controller {
	import org.puremvc.as3.patterns.command.MacroCommand;
	import com.qiyi.player.wonder.body.controller.initcommand.InitLoginStateCommand;
	
	public class StartupCommand extends MacroCommand {
		
		public function StartupCommand() {
			super();
		}
		
		override protected function initializeMacroCommand() : void {
			super.initializeMacroCommand();
			addSubCommand(PrepModelCommand);
			addSubCommand(PrepViewCommand);
			addSubCommand(InitLoginStateCommand);
		}
	}
}
