package ebing.utils {
	import flash.net.*;
	import flash.events.*;
	
	public class Srt extends Object {
		
		public function Srt() {
			this.K1026087DB5D46CF00E4946ADD70064900AD34A373571K = new Array();
			super();
		}
		
		private var K1026087DB5D46CF00E4946ADD70064900AD34A373571K:Array;
		
		private var K102608C9867403C3624E3DBD55A89C02AEF5A4373571K:uint = 0;
		
		private var K102608811AE68541504F3689CC25511821DD95373571K:uint = 0;
		
		private var K10260876D4B11921C04F57B20712418C68CA54373571K:String = "";
		
		public function loadSrtFile(param1:String) : void {
			var _loc2_:URLRequest = new URLRequest(param1);
			var _loc3_:URLLoader = new URLLoader();
			_loc3_.addEventListener(Event.COMPLETE,this.K102608F763F30B2D3E4538A2377E80D8A641EF373571K);
			_loc3_.load(_loc2_);
		}
		
		private function K102608F763F30B2D3E4538A2377E80D8A641EF373571K(param1:Event) : void {
			var _loc4_:String = null;
			var _loc5_:RegExp = null;
			var _loc6_:Object = null;
			var _loc7_:Object = null;
			var _loc2_:URLLoader = URLLoader(param1.target);
			var _loc3_:String = _loc2_.data;
			if(_loc3_ != "") {
				_loc4_ = "\\d+\\r\\n(\\d{2}:\\d{2}:\\d{2},\\d{3}) --> (\\d{2}:\\d{2}:\\d{2},\\d{3})\\r\\n(.*?)\\r\\n\\r\\n";
				_loc5_ = new RegExp(_loc4_,"gism");
				_loc6_ = null;
				while(true) {
					_loc6_ = _loc5_.exec(_loc3_);
					if(_loc6_ != null) {
						_loc7_ = {
							"bt":this.K10260846A3B017889B42E4A7628EBBBC26469B373571K(_loc6_[1]),
							"et":this.K10260846A3B017889B42E4A7628EBBBC26469B373571K(_loc6_[2]),
							"txt":_loc6_[3]
						};
						this.K1026087DB5D46CF00E4946ADD70064900AD34A373571K.push(_loc7_);
						continue;
					}
					break;
				}
			}
		}
		
		public function get hasData() : Boolean {
			var _loc1_:* = false;
			if(!(this.K1026087DB5D46CF00E4946ADD70064900AD34A373571K == null) && this.K1026087DB5D46CF00E4946ADD70064900AD34A373571K.length > 0) {
				_loc1_ = true;
			}
			return _loc1_;
		}
		
		private function K10260846A3B017889B42E4A7628EBBBC26469B373571K(param1:String) : uint {
			var _loc3_:Array = null;
			var _loc4_:uint = 0;
			var _loc5_:Array = null;
			var _loc6_:uint = 0;
			var _loc7_:uint = 0;
			var _loc8_:uint = 0;
			var _loc2_:uint = 0;
			if(param1 != "") {
				_loc3_ = param1.split(",");
				_loc4_ = parseInt(_loc3_[1]);
				_loc5_ = _loc3_[0].split(":");
				_loc6_ = parseInt(_loc5_[0]);
				_loc7_ = parseInt(_loc5_[1]);
				_loc8_ = parseInt(_loc5_[2]);
				_loc2_ = _loc2_ + _loc8_ * 1000;
				_loc2_ = _loc2_ + _loc7_ * 60 * 1000;
				_loc2_ = _loc2_ + _loc6_ * 60 * 60 * 1000;
				_loc2_ = _loc2_ + _loc4_;
			}
			return _loc2_;
		}
		
		public function getText(param1:uint) : String {
			var _loc4_:Object = null;
			var _loc2_:* = "";
			if(param1 < this.K102608C9867403C3624E3DBD55A89C02AEF5A4373571K) {
				this.K102608811AE68541504F3689CC25511821DD95373571K = 0;
			}
			var _loc3_:uint = this.K102608811AE68541504F3689CC25511821DD95373571K;
			while(_loc3_ < this.K1026087DB5D46CF00E4946ADD70064900AD34A373571K.length) {
				_loc4_ = this.K1026087DB5D46CF00E4946ADD70064900AD34A373571K[_loc3_];
				if(_loc4_.bt <= param1 && param1 <= _loc4_.et) {
					_loc2_ = _loc4_.txt;
					this.K102608C9867403C3624E3DBD55A89C02AEF5A4373571K = _loc4_.bt;
					this.K102608811AE68541504F3689CC25511821DD95373571K = _loc3_;
					break;
				}
				_loc3_++;
			}
			return _loc2_;
		}
	}
}
