package com.qiyi.player.base.logging.targets {
	import com.qiyi.player.base.logging.AbstractTarget;
	import com.qiyi.player.base.logging.LogEvent;
	import com.qiyi.player.base.logging.ILogger;
	
	public class LineFormattedTarget extends AbstractTarget {
		
		public function LineFormattedTarget() {
			super();
			this.includeTime = false;
			this.includeDate = false;
			this.includeCategory = false;
			this.includeLevel = false;
		}
		
		public var fieldSeparator:String = " ";
		
		public var includeCategory:Boolean;
		
		public var includeDate:Boolean;
		
		public var includeLevel:Boolean;
		
		public var includeTime:Boolean;
		
		override public function logEvent(param1:LogEvent) : void {
			var _loc5_:Date = null;
			var _loc2_:* = "";
			if((this.includeDate) || (this.includeTime)) {
				_loc5_ = new Date();
				if(this.includeDate) {
					_loc2_ = Number(_loc5_.getMonth() + 1).toString() + "/" + _loc5_.getDate().toString() + "/" + _loc5_.getFullYear() + this.fieldSeparator;
				}
				if(this.includeTime) {
					_loc2_ = _loc2_ + (this.padTime(_loc5_.getHours()) + ":" + this.padTime(_loc5_.getMinutes()) + ":" + this.padTime(_loc5_.getSeconds()) + "." + this.padTime(_loc5_.getMilliseconds(),true) + this.fieldSeparator);
				}
			}
			var _loc3_:* = "";
			if(this.includeLevel) {
				_loc3_ = "[" + LogEvent.getLevelString(param1.level) + "]" + this.fieldSeparator;
			}
			var _loc4_:String = this.includeCategory?ILogger(param1.target).category + this.fieldSeparator:"";
			this.internalLog(param1.level,_loc2_ + _loc3_ + _loc4_ + param1.message);
		}
		
		private function padTime(param1:Number, param2:Boolean = false) : String {
			if(param2) {
				if(param1 < 10) {
					return "00" + param1.toString();
				}
				if(param1 < 100) {
					return "0" + param1.toString();
				}
				return param1.toString();
			}
			return param1 > 9?param1.toString():"0" + param1.toString();
		}
		
		protected function internalLog(param1:int, param2:String) : void {
		}
	}
}
