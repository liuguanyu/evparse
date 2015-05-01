package ebing.net {
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequestMethod;
	import flash.net.URLRequestHeader;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import flash.net.sendToURL;
	import flash.events.IEventDispatcher;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.clearTimeout;
	
	public class URLLoaderUtil extends Object {
		
		public function URLLoaderUtil() {
			super();
			this._obj = new Object();
		}
		
		protected var _handler_fun:Function;
		
		protected var _loader_url:URLLoader;
		
		protected var _isLoaded_boo:Boolean = false;
		
		protected var _setTimeoutId_num:Number;
		
		protected var _spend_num:Number = 0;
		
		protected var _timeout:Number = 0;
		
		protected var _obj:Object;
		
		protected var _url:String = "";
		
		protected var _isDispatched:Boolean = false;
		
		public function load(param1:Number, param2:Function, param3:String, param4:Object = null, param5:String = "null", param6:Array = null) : void {
			var K102607D8EF8BC6FDD448F88BE243DF5073A734373570K:URLRequest = null;
			var K1026071A844329504142D79D48353D044BBFA7373570K:URLVariables = null;
			var K10255269C23FDCE8B24503A67C29619F006FF3373515K:* = undefined;
			var i:uint = 0;
			var time:Number = param1;
			var handler:Function = param2;
			var url:String = param3;
			var method:Object = param4;
			var df:String = param5;
			var headers:Array = param6;
			try {
				this._handler_fun = handler;
				this._loader_url = new URLLoader();
				this.addEvent(this._loader_url);
				switch(df) {
					case "text":
					case "null":
						this._loader_url.dataFormat = URLLoaderDataFormat.TEXT;
						break;
					case "binary":
						this._loader_url.dataFormat = URLLoaderDataFormat.BINARY;
						break;
					case "var":
						this._loader_url.dataFormat = URLLoaderDataFormat.VARIABLES;
						break;
				}
				this._url = url;
				K102607D8EF8BC6FDD448F88BE243DF5073A734373570K = new URLRequest(url);
				if(method != null) {
					K102607D8EF8BC6FDD448F88BE243DF5073A734373570K.method = method.method == "POST"?URLRequestMethod.POST:URLRequestMethod.GET;
					switch(method.dataType) {
						case "u":
							K1026071A844329504142D79D48353D044BBFA7373570K = new URLVariables();
							for(K10255269C23FDCE8B24503A67C29619F006FF3373515K in method.data) {
								K1026071A844329504142D79D48353D044BBFA7373570K[K10255269C23FDCE8B24503A67C29619F006FF3373515K] = method.data[K10255269C23FDCE8B24503A67C29619F006FF3373515K];
							}
							K102607D8EF8BC6FDD448F88BE243DF5073A734373570K.data = K1026071A844329504142D79D48353D044BBFA7373570K;
							break;
						case "b":
							K102607D8EF8BC6FDD448F88BE243DF5073A734373570K.data = method.data;
							break;
					}
				}
				if(headers != null) {
					i = 0;
					while(i < headers.length) {
						K102607D8EF8BC6FDD448F88BE243DF5073A734373570K.requestHeaders.push(new URLRequestHeader(String(headers[i].name),String(headers[i].value)));
						i++;
					}
				}
				this._isDispatched = false;
				this._loader_url.load(K102607D8EF8BC6FDD448F88BE243DF5073A734373570K);
				this._spend_num = getTimer();
				this._setTimeoutId_num = setTimeout(this.K102607110A40D4F1854BF6B82416E6749EFB04373570K,time * 1000);
			}
			catch(e:*) {
				trace("error");
			}
		}
		
		public function send(param1:String, param2:Object = null) : void {
			var _loc4_:URLVariables = null;
			var _loc5_:* = undefined;
			var _loc3_:URLRequest = new URLRequest(param1);
			if(param2 != null) {
				_loc3_.method = param2.method == "POST"?URLRequestMethod.POST:URLRequestMethod.GET;
				switch(param2.dataType) {
					case "u":
						_loc4_ = new URLVariables();
						for(_loc5_ in param2.data) {
							_loc4_[_loc5_] = param2.data[_loc5_];
						}
						_loc3_.data = _loc4_;
						break;
					case "b":
						_loc3_.data = param2.data;
						break;
				}
			}
			sendToURL(_loc3_);
		}
		
		public function multiSend(param1:String) : void {
			if(param1 == null || param1 == "") {
				return;
			}
			var _loc2_:Array = param1.split("|http:");
			var _loc3_:* = "";
			var _loc4_:* = 0;
			while(_loc4_ < _loc2_.length) {
				_loc3_ = _loc4_ > 0?"http:":"";
				_loc3_ = _loc3_ + _loc2_[_loc4_];
				this.send(_loc3_);
				_loc4_++;
			}
		}
		
		private function removeEvent(param1:IEventDispatcher) : void {
			param1.removeEventListener(Event.COMPLETE,this.K10260756E24EB7DF5C44198ED3ECC3A1EBE300373570K);
			param1.removeEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
			param1.removeEventListener(HTTPStatusEvent.HTTP_STATUS,this.httpStatusHandler);
		}
		
		private function addEvent(param1:IEventDispatcher) : void {
			if(!param1.hasEventListener(Event.COMPLETE)) {
				param1.addEventListener(Event.COMPLETE,this.K10260756E24EB7DF5C44198ED3ECC3A1EBE300373570K);
				param1.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
				param1.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
				param1.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.httpStatusHandler);
			}
		}
		
		private function securityErrorHandler(param1:SecurityErrorEvent) : void {
			if(!this._isDispatched) {
				this._isDispatched = true;
				this.close();
				clearTimeout(this._setTimeoutId_num);
				this._isLoaded_boo = false;
				this._spend_num = getTimer() - this._spend_num;
				if(this._handler_fun != null) {
					this._handler_fun({
						"info":"securityError",
						"err":param1,
						"target":this
					});
				}
			}
		}
		
		private function K10260756E24EB7DF5C44198ED3ECC3A1EBE300373570K(param1:Event) : void {
			if(!this._isDispatched) {
				this._isDispatched = true;
				this.close();
				clearTimeout(this._setTimeoutId_num);
				this._isLoaded_boo = true;
				this._spend_num = getTimer() - this._spend_num;
				if(this._handler_fun != null) {
					this._handler_fun({
						"info":"success",
						"data":param1.target.data,
						"target":this,
						"urlloader":param1.target
					});
				}
			}
		}
		
		protected function ioErrorHandler(param1:IOErrorEvent) : void {
			if(!this._isDispatched) {
				this._isDispatched = true;
				this.close();
				clearTimeout(this._setTimeoutId_num);
				this._isLoaded_boo = false;
				this._spend_num = getTimer() - this._spend_num;
				if(this._handler_fun != null) {
					this._handler_fun({
						"info":"ioError",
						"err":param1,
						"target":this
					});
				}
			}
		}
		
		private function K102607110A40D4F1854BF6B82416E6749EFB04373570K() : void {
			if(!this._isDispatched) {
				this._isDispatched = true;
				trace("timeout");
				if(!this._isLoaded_boo) {
					this.close();
					this._spend_num = getTimer() - this._spend_num;
					if(this._handler_fun != null) {
						this._handler_fun({
							"info":"timeout",
							"target":this
						});
					}
				}
			}
		}
		
		protected function httpStatusHandler(param1:HTTPStatusEvent) : void {
		}
		
		public function close() : void {
			try {
				this._loader_url.close();
			}
			catch(evt:*) {
			}
			this.removeEvent(this._loader_url);
		}
		
		public function get spend() : Number {
			return this._spend_num;
		}
		
		public function get timeLimit() : Number {
			return this._timeout;
		}
		
		public function set obj(param1:Object) : void {
			this._obj = param1;
		}
		
		public function get obj() : Object {
			return this._obj;
		}
		
		public function get url() : String {
			return this._url;
		}
	}
}
