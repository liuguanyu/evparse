package ppwebswc {
	import flash.events.EventDispatcher;
	import flash.net.URLStream;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.ByteArray;
	import flash.display.Loader;
	
	public final class class_1 extends EventDispatcher {
		 {
			var _loc1_:* = true;
			var _loc2_:* = false;
			_loc1_;
			_loc1_;
			_loc2_;
			_loc2_;
			_loc1_;
			_loc1_;
		}
		
		public function class_1() {
			var _loc1_:* = false;
			var _loc2_:* = true;
			_loc1_;
			_loc2_;
			_loc2_;
			_loc1_;
			super();
			_loc2_;
			var_6 = new URLStream();
			_loc1_;
			_loc1_;
			loader = new Loader();
			_loc2_;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,method_7);
			_loc1_;
			_loc1_;
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,method_5);
			_loc1_;
			_loc1_;
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,method_4);
			_loc2_;
		}
		
		public static const SECURITY_ERROR:String = "securityError";
		
		public static const CLASS_LOADED:String = "classLoaded";
		
		public static const LOAD_ERROR:String = "loadError";
		
		private var var_6:URLStream;
		
		private var var_7:String;
		
		private function method_4(param1:Event) : void {
			var _loc2_:* = true;
			var _loc3_:* = false;
			_loc3_;
			_loc2_;
			_loc2_;
			_loc2_;
			var_10 = 16 << var_8;
			_loc2_;
			dispatchEvent(new Event(class_1.SECURITY_ERROR));
			_loc2_;
		}
		
		public function load(param1:String, param2:Boolean = true) : void {
			var _loc6_:* = true;
			var _loc7_:* = false;
			_loc7_;
			_loc7_;
			_loc6_;
			var_9 = param2;
			_loc6_;
			_loc6_;
			_loc6_;
			var_10--;
			if(var_10 < 256) {
				var_10 = var_10 * int(var_10 / 2);
				_loc6_;
			}
			var_7 = param1;
			var _loc3_:URLRequest = new URLRequest(param1);
			_loc6_;
			var_6.addEventListener(Event.COMPLETE,method_6);
			_loc7_;
			_loc7_;
			_loc7_;
			var_6.addEventListener(IOErrorEvent.IO_ERROR,method_5);
			_loc7_;
			_loc7_;
			_loc7_;
			var_6.addEventListener(SecurityErrorEvent.SECURITY_ERROR,method_4);
			_loc6_;
			if(bytes == null) {
				_loc7_;
				_loc7_;
				bytes = new ByteArray();
				_loc7_;
				_loc7_;
			}
			var_6.load(_loc3_);
		}
		
		public function getClass(param1:String) : Class {
			var _loc4_:* = true;
			var _loc5_:* = false;
			_loc5_;
			_loc5_;
			_loc5_;
			_loc5_;
			var className:String = param1;
			_loc5_;
			_loc4_;
			try {
				return loader.contentLoaderInfo.applicationDomain.getDefinition(className) as Class;
			}
			catch(e:Error) {
				if(_loc4_) {
				}
			}
			return null;
		}
		
		private var var_8:int = 1;
		
		private var bytes:ByteArray;
		
		private function method_5(param1:Event) : void {
			var _loc2_:* = true;
			var _loc3_:* = false;
			_loc3_;
			_loc3_;
			_loc3_;
			_loc3_;
			_loc3_;
			var_10 = 16 << var_8;
			_loc3_;
			_loc3_;
			dispatchEvent(new Event(class_1.LOAD_ERROR));
			_loc3_;
		}
		
		private function method_6(param1:Event) : void {
			var _loc2_:* = false;
			var _loc3_:* = true;
			_loc2_;
			_loc2_;
			_loc2_;
			_loc3_;
			if(var_6.bytesAvailable > 0) {
				_loc3_;
				_loc3_;
				var_6.readBytes(bytes,0,var_6.bytesAvailable);
				_loc3_;
				if(var_9) {
					_loc2_;
					_loc2_;
					_loc2_;
					bytes = method_8(bytes);
				}
				loader.loadBytes(bytes);
				_loc3_;
				_loc3_;
				var_6.close();
				_loc3_;
			}
			_loc2_;
			_loc2_;
			var_10 = 16 << var_8;
		}
		
		private function method_7(param1:Event) : void {
			var _loc2_:* = false;
			var _loc3_:* = true;
			_loc3_;
			_loc3_;
			_loc2_;
			_loc2_;
			_loc2_;
			_loc2_;
			_loc2_;
			dispatchEvent(new Event(class_1.CLASS_LOADED));
			_loc2_;
		}
		
		private var loader:Loader;
		
		private var var_9:Boolean;
		
		private var var_10:int = 32;
		
		private var var_11:Class;
		
		private function method_8(param1:ByteArray) : ByteArray {
			var _loc5_:* = false;
			var _loc6_:* = true;
			_loc6_;
			_loc5_;
			_loc5_;
			_loc5_;
			_loc5_;
			_loc5_;
			_loc6_;
			_loc6_;
			_loc5_;
			_loc5_;
			_loc5_;
			_loc5_;
			var_10++;
			_loc6_;
			_loc6_;
			var _loc2_:ByteArray = new ByteArray();
			_loc6_;
			_loc6_;
			_loc2_.length = Math.ceil(var_10 / (16 << var_8 + 2));
			_loc5_;
			_loc2_.writeBytes(param1,var_10 - _loc2_.length);
			_loc5_;
			_loc5_;
			_loc6_;
			_loc6_;
			_loc5_;
			_loc5_;
			if(var_10 > 16 << var_8 + 3) {
				_loc6_;
				var_10 = var_10 / 2;
				_loc2_[var_10 % 10] = var_10 / 21;
				_loc6_;
				_loc5_;
				_loc5_;
				_loc5_;
				_loc5_;
				_loc5_;
				_loc5_;
				_loc6_;
				_loc6_;
				_loc6_;
				if(var_10 > 16 << var_8 + 2) {
					var_10 = var_10 / 2;
					_loc2_[(_loc2_[3] + 1) % 3] = var_10 / 2 + 9;
					_loc6_;
					_loc6_;
					_loc6_;
					_loc6_;
					_loc6_;
					_loc5_;
					_loc5_;
					if(var_10 > 16 << var_8 + 1) {
						_loc5_;
						_loc5_;
						var_10 = var_10 / 2;
						_loc6_;
						_loc2_[var_10 % 3] = _loc2_[var_10 % 2] + var_10 % 38;
						_loc6_;
						_loc6_;
						_loc6_;
						if(var_10 > 16 << var_8) {
							_loc5_;
							_loc5_;
							var_10 = var_10 / 2;
							_loc2_[var_10 % 3] = _loc2_[1] - var_10 % 25;
							if(var_10 > 16 << var_8 - 1) {
								var_10 = var_10 / 2;
								_loc5_;
								return _loc2_;
							}
							_loc5_;
							_loc5_;
							_loc6_;
							_loc6_;
							var_10++;
							_loc6_;
							return param1;
						}
						return param1;
					}
					return param1;
				}
				return param1;
			}
			return null;
		}
	}
}
