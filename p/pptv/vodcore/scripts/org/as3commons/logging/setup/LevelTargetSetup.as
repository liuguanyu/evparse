package org.as3commons.logging.setup
{
	import org.as3commons.logging.api.ILogSetup;
	import org.as3commons.logging.api.Logger;
	
	public class LevelTargetSetup extends Object implements ILogSetup
	{
		
		private var _level:LogSetupLevel;
		
		private var _target:ILogTarget;
		
		public function LevelTargetSetup(param1:ILogTarget, param2:LogSetupLevel)
		{
			super();
			this._target = param1;
			this._level = param2;
		}
		
		public function applyTo(param1:Logger) : void
		{
			this._level.applyTo(param1,this._target);
		}
	}
}
