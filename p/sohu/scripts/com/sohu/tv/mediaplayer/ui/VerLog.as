package com.sohu.tv.mediaplayer.ui {
	import flash.text.TextField;
	
	public class VerLog extends Object {
		
		public function VerLog() {
			super();
		}
		
		private static var _logs:String = "";
		
		private static var _logsText:TextField;
		
		public static function msg(... rest) : void {
			var _loc3_:String = null;
			var _loc2_:uint = 0;
			while(_loc2_ < rest.length) {
				_loc3_ = rest[_loc2_] + "\n";
				_logs = _logs + _loc3_;
				if(_logsText != null) {
					textAddContent(_loc3_);
				}
				_loc2_++;
			}
		}
		
		public static function getMsg() : String {
			return _logs;
		}
		
		private static function textAddContent(param1:String) : void {
			_logsText.appendText(param1);
			_logsText.scrollV = _logsText.maxScrollV - _logsText.scrollV + 1;
		}
		
		public static function set logsText(param1:TextField) : void {
			_logsText = param1;
			textAddContent(_logs);
		}
	}
}
