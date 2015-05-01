package loader.vod {
	import flash.utils.ByteArray;
	
	public class VideoData extends Object {
		
		public function VideoData() {
			super();
		}
		
		public var data:Object;
		
		public function get headers() : ByteArray {
			return this.data["headers"];
		}
		
		public function get time() : Number {
			return this.data["time"];
		}
		
		public function get bytes() : ByteArray {
			return this.data["bytes"];
		}
		
		public function get duration() : Number {
			return this.data["duration"];
		}
		
		public function get jumpFragment() : Boolean {
			return this.data["jumpFragment"];
		}
	}
}
