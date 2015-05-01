package com.qiyi.player.base.logging.targets {
	import com.qiyi.player.base.cookie.FixedLineCookie;
	
	public class CookieTarget extends LineFormattedTarget {
		
		public function CookieTarget(param1:String, param2:String, param3:int, param4:int, param5:String = "") {
			super();
			this.includeDate = true;
			this.includeTime = true;
			this._flag = param5;
			this._lineCookies = new FixedLineCookie(param1,param2,param3,param4);
		}
		
		private var _lineCookies:FixedLineCookie;
		
		private var _flag:String;
		
		public function getLifeLogs() : Array {
			return this._lineCookies.lines;
		}
		
		override protected function internalLog(param1:int, param2:String) : void {
			this._lineCookies.push(param2);
		}
	}
}
