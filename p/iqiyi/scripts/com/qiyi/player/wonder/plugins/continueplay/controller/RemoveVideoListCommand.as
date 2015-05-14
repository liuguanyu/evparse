package com.qiyi.player.wonder.plugins.continueplay.controller
{
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.plugins.continueplay.model.ContinuePlayProxy;
	
	public class RemoveVideoListCommand extends SimpleCommand
	{
		
		public function RemoveVideoListCommand()
		{
			super();
		}
		
		override public function execute(param1:INotification) : void
		{
			var _loc3:Array = null;
			var _loc4:* = 0;
			var _loc5:Object = null;
			var _loc6:Vector.<String> = null;
			var _loc7:Vector.<String> = null;
			var _loc8:* = 0;
			super.execute(param1);
			var _loc2:ContinuePlayProxy = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
			if(param1.getBody() == null)
			{
				_loc2.clearContinueInfo();
			}
			else
			{
				_loc3 = param1.getBody().list as Array;
				if(_loc3.length == 0)
				{
					_loc2.clearContinueInfo();
				}
				else
				{
					_loc4 = _loc3.length;
					_loc5 = null;
					_loc6 = new Vector.<String>(_loc4);
					_loc7 = new Vector.<String>(_loc4);
					_loc8 = 0;
					while(_loc8 < _loc4)
					{
						_loc5 = _loc3[_loc8];
						_loc6[_loc8] = _loc5.tvid;
						_loc7[_loc8] = _loc5.vid;
						_loc8++;
					}
					_loc2.removeContinueInfoList(_loc6,_loc7);
				}
			}
		}
	}
}
