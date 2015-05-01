package com.qiyi.player.wonder.plugins.continueplay.controller {
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.plugins.continueplay.model.ContinuePlayProxy;
	
	public class RemoveVideoListCommand extends SimpleCommand {
		
		public function RemoveVideoListCommand() {
			super();
		}
		
		override public function execute(param1:INotification) : void {
			var _loc3_:Array = null;
			var _loc4_:* = 0;
			var _loc5_:Object = null;
			var _loc6_:Vector.<String> = null;
			var _loc7_:Vector.<String> = null;
			var _loc8_:* = 0;
			super.execute(param1);
			var _loc2_:ContinuePlayProxy = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
			if(param1.getBody() == null) {
				_loc2_.clearContinueInfo();
			} else {
				_loc3_ = param1.getBody().list as Array;
				if(_loc3_.length == 0) {
					_loc2_.clearContinueInfo();
				} else {
					_loc4_ = _loc3_.length;
					_loc5_ = null;
					_loc6_ = new Vector.<String>(_loc4_);
					_loc7_ = new Vector.<String>(_loc4_);
					_loc8_ = 0;
					while(_loc8_ < _loc4_) {
						_loc5_ = _loc3_[_loc8_];
						_loc6_[_loc8_] = _loc5_.tvid;
						_loc7_[_loc8_] = _loc5_.vid;
						_loc8_++;
					}
					_loc2_.removeContinueInfoList(_loc6_,_loc7_);
				}
			}
		}
	}
}
