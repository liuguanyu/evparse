package ebing.net {
	import flash.display.Loader;
	import flash.system.LoaderContext;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import flash.events.IEventDispatcher;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.utils.clearTimeout;
	import flash.events.HTTPStatusEvent;
	
	public class LoaderUtil extends Object {
		
		public function LoaderUtil() {
			super();
		}
		
		private var _handler_fun:Function;
		
		private var K102607E19695C28B5B404A85AF328E245AAC3C373570K:Function;
		
		private var K1026074AB4A755C9814959ABFFEB0DE24063E2373570K:Loader;
		
		private var _isLoaded_boo:Boolean = false;
		
		private var _setTimeoutId_num:Number;
		
		private var K102607B3624D198BBF4F8CA90E7F9E3511D896373570K;
		
		private var _timeout:Number = 0;
		
		private var _spend_num:Number = 0;
		
		public function load(param1:Number, param2:Function, param3:Function = null, param4:String = "", param5:LoaderContext = null) : void {
			var time:Number = param1;
			var handler:Function = param2;
			var progressEvent:Function = param3;
			var url:String = param4;
			var loaderContext:LoaderContext = param5;
			try {
				this._timeout = time;
				this._handler_fun = handler;
				this.K102607E19695C28B5B404A85AF328E245AAC3C373570K = progressEvent;
				this.K1026074AB4A755C9814959ABFFEB0DE24063E2373570K = new Loader();
				this.addEvent(this.K1026074AB4A755C9814959ABFFEB0DE24063E2373570K.contentLoaderInfo);
				this.K1026074AB4A755C9814959ABFFEB0DE24063E2373570K.load(new URLRequest(url),loaderContext);
				this._spend_num = getTimer();
				this._setTimeoutId_num = setTimeout(this.K102607110A40D4F1854BF6B82416E6749EFB04373570K,time * 1000);
			}
			catch(e:Error) {
				trace(e);
			}
		}
		
		private function addEvent(param1:IEventDispatcher) : void {
			param1.addEventListener(Event.COMPLETE,this.K10260756E24EB7DF5C44198ED3ECC3A1EBE300373570K);
			param1.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
			param1.addEventListener(ProgressEvent.PROGRESS,this.K10260705E689BF75554B229440129F1BD32C84373570K);
		}
		
		private function K10260756E24EB7DF5C44198ED3ECC3A1EBE300373570K(param1:Event) : void {
			clearTimeout(this._setTimeoutId_num);
			this._isLoaded_boo = true;
			this._spend_num = getTimer() - this._spend_num;
			trace("_handler_fun:" + this._handler_fun);
			if(this._handler_fun != null) {
				this._handler_fun({
					"info":"success",
					"data":param1.currentTarget.loader,
					"target":this,
					"loaderinfo":param1.target
				});
			}
		}
		
		private function ioErrorHandler(param1:IOErrorEvent) : void {
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
		
		private function K102607110A40D4F1854BF6B82416E6749EFB04373570K() : void {
			if(!this._isLoaded_boo) {
				this._spend_num = getTimer() - this._spend_num;
				this.K1026074AB4A755C9814959ABFFEB0DE24063E2373570K.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.K10260756E24EB7DF5C44198ED3ECC3A1EBE300373570K);
				this.K1026074AB4A755C9814959ABFFEB0DE24063E2373570K.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
				if(this._handler_fun != null) {
					this._handler_fun({
						"info":"timeout",
						"target":this
					});
				}
			}
		}
		
		private function httpStatusHandler(param1:HTTPStatusEvent) : void {
		}
		
		private function K102607289C56A06B87471FAB5B97BDE07B6A63373570K(param1:Event) : void {
		}
		
		private function K1026074D00BEC6EAB34DB7AAFF97DB0F015AEB373570K(param1:Event) : void {
		}
		
		private function K10260705E689BF75554B229440129F1BD32C84373570K(param1:ProgressEvent) : void {
			if(this.K102607E19695C28B5B404A85AF328E245AAC3C373570K != null) {
				this.K102607E19695C28B5B404A85AF328E245AAC3C373570K(param1);
			}
		}
		
		private function K102607AA230B8D1F2E4E93B57AD4C30B82CD82373570K(param1:HTTPStatusEvent) : void {
		}
		
		public function set index(param1:uint) : void {
			this.K102607B3624D198BBF4F8CA90E7F9E3511D896373570K = param1;
		}
		
		public function get index() : uint {
			return this.K102607B3624D198BBF4F8CA90E7F9E3511D896373570K;
		}
		
		public function get spend() : Number {
			return this._spend_num;
		}
		
		public function get timeout() : Number {
			return this._timeout;
		}
	}
}
