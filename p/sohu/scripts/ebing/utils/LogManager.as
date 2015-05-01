package ebing.utils {
	import flash.text.TextField;
	
	public class LogManager extends Object {
		
		public function LogManager() {
			super();
		}
		
		private static var K10260742AC09AE6C564A588BC3336556E49389373570K:String = "";
		
		private static var K102607284B1F1523614314AE01CF7F584392B3373570K:TextField;
		
		public static function msg(... rest) : void {
			var _loc3_:String = null;
			trace(rest);
			var _loc2_:uint = 0;
			while(_loc2_ < rest.length) {
				_loc3_ = rest[_loc2_] + "|" + new Date().toLocaleTimeString() + "\n";
				K10260742AC09AE6C564A588BC3336556E49389373570K = K10260742AC09AE6C564A588BC3336556E49389373570K + _loc3_;
				if(K102607284B1F1523614314AE01CF7F584392B3373570K != null) {
					K10260712F745D019674DAD8B923083D78DA74A373570K(_loc3_);
				}
				_loc2_++;
			}
		}
		
		public static function getMsg() : String {
			return K10260742AC09AE6C564A588BC3336556E49389373570K;
		}
		
		private static function K10260712F745D019674DAD8B923083D78DA74A373570K(param1:String) : void {
			K102607284B1F1523614314AE01CF7F584392B3373570K.appendText(param1);
			K102607284B1F1523614314AE01CF7F584392B3373570K.scrollV = K102607284B1F1523614314AE01CF7F584392B3373570K.maxScrollV - K102607284B1F1523614314AE01CF7F584392B3373570K.scrollV + 1;
		}
		
		public static function set logsText(param1:TextField) : void {
			K102607284B1F1523614314AE01CF7F584392B3373570K = param1;
			K10260712F745D019674DAD8B923083D78DA74A373570K(K10260742AC09AE6C564A588BC3336556E49389373570K);
		}
	}
}
