package loader.vod {
	public class FileState extends Object {
		
		public function FileState(param1:String) {
			super();
			this._key = param1;
		}
		
		public static const FirstDispatch:uint = 10;
		
		public static const SecondDispatch:uint = 20;
		
		public static const AuthChecker:uint = 30;
		
		public static const AuthDispatch:uint = 40;
		
		public static const CDNRequest:uint = 50;
		
		public static var State_Success:uint = 0;
		
		public static var State_Timeout:uint = 1;
		
		public static var State_ConnectError:uint = 2;
		
		public static var State_DataError:uint = 3;
		
		public static var State_SecurityError:uint = 4;
		
		public static var State_AuthenticationError:uint = 5;
		
		public static var State_UnknownError:uint = 6;
		
		private var _key:String;
		
		public function get stateCode() : int {
			return this._data["stateCode"];
		}
		
		public function get cdnUrl() : String {
			return this._data["cdnUrl"];
		}
		
		public function get index() : uint {
			return this._data["segmentIndex"];
		}
		
		public function get sourceID() : String {
			return this._data["sourceID"];
		}
		
		public function get retryCount() : uint {
			return this._data["retryCount"];
		}
		
		public function get averageSpeed() : int {
			return this._data["averageSpeed"];
		}
		
		public function get data() : String {
			return this._data["data"];
		}
		
		private function get _data() : Object {
			return P2PFileLoader.instance.method_1(this._key)["fileState"];
		}
	}
}
