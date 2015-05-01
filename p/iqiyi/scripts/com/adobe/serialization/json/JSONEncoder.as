package com.adobe.serialization.json {
	import flash.utils.describeType;
	
	public class JSONEncoder extends Object {
		
		public function JSONEncoder(param1:*) {
			super();
			jsonString = convertToString(param1);
		}
		
		private function escapeString(param1:String) : String {
			var _loc3_:String = null;
			var _loc6_:String = null;
			var _loc7_:String = null;
			var _loc2_:* = "";
			var _loc4_:Number = param1.length;
			var _loc5_:* = 0;
			while(_loc5_ < _loc4_) {
				_loc3_ = param1.charAt(_loc5_);
				switch(_loc3_) {
					case "\"":
						_loc2_ = _loc2_ + "\\\"";
						break;
					case "\\":
						_loc2_ = _loc2_ + "\\\\";
						break;
					case "\b":
						_loc2_ = _loc2_ + "\\b";
						break;
					case "\f":
						_loc2_ = _loc2_ + "\\f";
						break;
					case "\n":
						_loc2_ = _loc2_ + "\\n";
						break;
					case "\r":
						_loc2_ = _loc2_ + "\\r";
						break;
					case "\t":
						_loc2_ = _loc2_ + "\\t";
						break;
					default:
						if(_loc3_ < " ") {
							_loc6_ = _loc3_.charCodeAt(0).toString(16);
							_loc7_ = _loc6_.length == 2?"00":"000";
							_loc2_ = _loc2_ + ("\\u" + _loc7_ + _loc6_);
						} else {
							_loc2_ = _loc2_ + _loc3_;
						}
				}
				_loc5_++;
			}
			return "\"" + _loc2_ + "\"";
		}
		
		private function arrayToString(param1:Array) : String {
			var _loc2_:* = "";
			var _loc3_:* = 0;
			while(_loc3_ < param1.length) {
				if(_loc2_.length > 0) {
					_loc2_ = _loc2_ + ",";
				}
				_loc2_ = _loc2_ + convertToString(param1[_loc3_]);
				_loc3_++;
			}
			return "[" + _loc2_ + "]";
		}
		
		public function getString() : String {
			return jsonString;
		}
		
		private var jsonString:String;
		
		private function objectToString(param1:Object) : String {
			/*
			 * Decompilation error
			 * Code may be obfuscated
			 * Deobfuscation is activated but decompilation still failed. If the file is NOT obfuscated, disable "Automatic deobfuscation" for better results.
			 * Error type: TranslateException
			 */
			throw new flash.errors.IllegalOperationError("Not decompiled due to error");
		}
		
		private function convertToString(param1:*) : String {
			if(param1 is String) {
				return escapeString(param1 as String);
			}
			if(param1 is Number) {
				return isFinite(param1 as Number)?param1.toString():"null";
			}
			if(param1 is Boolean) {
				return param1?"true":"false";
			}
			if(param1 is Array) {
				return arrayToString(param1 as Array);
			}
			if(param1 is Object && !(param1 == null)) {
				return objectToString(param1);
			}
			return "null";
		}
	}
}
