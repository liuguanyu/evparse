package ebing {
	import flash.utils.ByteArray;
	import flash.display.BitmapData;
	import com.adobe.crypto.Base64;
	import flash.geom.Rectangle;
	
	public class BitmapBytes extends Object {
		
		public function BitmapBytes() {
			super();
			throw new Error("BitmapBytes类只是一个静态类!");
		}
		
		public static function encodeByteArray(param1:BitmapData) : ByteArray {
			if(param1 == null) {
				throw new Error("data参数不能为空!");
			} else {
				var _loc2_:ByteArray = param1.getPixels(param1.rect);
				_loc2_.writeShort(param1.width);
				_loc2_.writeShort(param1.height);
				_loc2_.writeBoolean(param1.transparent);
				_loc2_.compress();
				return _loc2_;
			}
		}
		
		public static function encodeBase64(param1:BitmapData) : String {
			return Base64.encodeByteArray(encodeByteArray(param1));
		}
		
		public static function decodeByteArray(param1:ByteArray) : BitmapData {
			if(param1 == null) {
				throw new Error("bytes参数不能为空!");
			} else {
				param1.uncompress();
				if(param1.length < 6) {
					throw new Error("bytes参数为无效值!");
				} else {
					param1.position = param1.length - 1;
					var _loc2_:Boolean = param1.readBoolean();
					param1.position = param1.length - 3;
					var _loc3_:int = param1.readShort();
					param1.position = param1.length - 5;
					var _loc4_:int = param1.readShort();
					param1.position = 0;
					var _loc5_:ByteArray = new ByteArray();
					param1.readBytes(_loc5_,0,param1.length - 5);
					var _loc6_:BitmapData = new BitmapData(_loc4_,_loc3_,_loc2_,0);
					_loc6_.setPixels(new Rectangle(0,0,_loc4_,_loc3_),_loc5_);
					return _loc6_;
				}
			}
		}
		
		public static function decodeBase64(param1:String) : BitmapData {
			return decodeByteArray(Base64.decodeToByteArray(param1));
		}
	}
}
