package com.adobe.serialization.json {
	public class JSONToken extends Object {
		
		public function JSONToken(param1:int = -1, param2:Object = null) {
			super();
			_type = param1;
			_value = param2;
		}
		
		private var _value:Object;
		
		public function get value() : Object {
			return _value;
		}
		
		private var _type:int;
		
		public function get type() : int {
			return _type;
		}
		
		public function set type(param1:int) : void {
			_type = param1;
		}
		
		public function set value(param1:Object) : void {
			_value = param1;
		}
	}
}
