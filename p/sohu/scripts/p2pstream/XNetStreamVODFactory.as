package p2pstream {
	import flash.net.NetStream;
	
	public class XNetStreamVODFactory extends XNetStreamFactory {
		
		public function XNetStreamVODFactory(param1:Function, param2:String = null) {
			var _loc3_:* = false;
			var _loc4_:* = true;
			_loc3_;
			_loc3_;
			_loc3_;
			_loc3_;
			_loc4_;
			_loc4_;
			_loc3_;
			_loc3_;
			var_1 = "http://192.168.0.103/lib/xnetvod.flv";
			_loc3_;
			_loc3_;
			super(param1,param2);
		}
		
		public static function checkCompatibility() : Boolean {
			var _loc1_:* = false;
			var _loc2_:* = true;
			_loc1_;
			_loc1_;
			_loc1_;
			return XNetStreamFactory.checkCompatibility();
		}
		
		public static function get defaultFactory() : XNetStreamVODFactory {
			var _loc2_:* = false;
			var _loc3_:* = true;
			_loc3_;
			_loc3_;
			_loc2_;
			_loc2_;
			_loc2_;
			var _loc1_:XNetStreamVODFactory = new XNetStreamVODFactory(null);
			_loc3_;
			_loc2_;
			_loc1_.var_4 = true;
			_loc3_;
			_loc2_;
			method_11();
			_loc2_;
			return _loc1_;
		}
		
		public function newNetStreamVOD(param1:String, param2:String, param3:int, param4:int, param5:String = null) : NetStream {
			var _loc7_:* = false;
			var _loc8_:* = true;
			_loc7_;
			var _loc6_:Class = null;
			_loc7_;
			_loc8_;
			_loc8_;
			_loc8_;
			_loc7_;
			_loc7_;
			_loc8_;
			_loc8_;
			if((param1 == null) || (!(param1.indexOf(PARTNERID) == 0))) {
				_loc7_;
				var param1:String = PARTNERID + param1;
			}
			if(var_5) {
				_loc7_;
				_loc7_;
				_loc6_ = loader.getClass("p2ptest.XNetStreamVOD");
				return new _loc6_(param1,param2,param3,param4,param5) as NetStream;
			}
			return null;
		}
	}
}
