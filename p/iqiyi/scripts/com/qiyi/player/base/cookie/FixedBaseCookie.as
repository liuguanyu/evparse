package com.qiyi.player.base.cookie {
	import flash.net.SharedObject;
	import flash.events.NetStatusEvent;
	
	public class FixedBaseCookie extends Object {
		
		public function FixedBaseCookie(param1:String, param2:String, param3:int) {
			var name_4:String = param1;
			var name_5:String = param2;
			var name_6:int = param3;
			super();
			this._maxSize = name_6 << 10;
			this._fieldName = name_5;
			this._fileName = name_4;
			try {
				this._so = SharedObject.getLocal(name_4,"/");
				this._so.addEventListener(NetStatusEvent.NET_STATUS,this.onNetStatus);
				this._data = this._so.data[name_5];
			}
			catch(e:Error) {
				_forbidden = true;
			}
		}
		
		protected var _maxSize:int;
		
		protected var _so:SharedObject;
		
		protected var _data:Object;
		
		protected var _forbidden:Boolean = false;
		
		protected var _fieldName:String;
		
		protected var _fileName:String;
		
		public function destroy() : void {
			if(this._so) {
				this._so.removeEventListener(NetStatusEvent.NET_STATUS,this.onNetStatus);
				this._so.close();
				this._so = null;
			}
		}
		
		protected function onNetStatus(param1:NetStatusEvent) : void {
			if(param1.info.code == "SharedObject.Flush.Failed") {
				this.clear();
			} else if(param1.info.code == "SharedObject.Flush.Success") {
			}
			
		}
		
		public function clear() : void {
		}
		
		public function get data() : Object {
			return this._data;
		}
		
		public function set data(param1:Object) : void {
			this._data = param1;
		}
		
		public function flush() : void {
			try {
				this._so.flush();
			}
			catch(e:Error) {
				_forbidden = true;
			}
		}
	}
}
