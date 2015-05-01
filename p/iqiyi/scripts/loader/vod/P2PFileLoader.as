package loader.vod {
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.events.Event;
	import flash.utils.setTimeout;
	import flash.system.Security;
	import flash.net.URLLoaderDataFormat;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	import flash.display.Loader;
	import flash.system.LoaderContext;
	import flash.net.sendToURL;
	import flash.utils.ByteArray;
	import flash.utils.clearTimeout;
	
	public class P2PFileLoader extends EventDispatcher {
		
		public function P2PFileLoader(param1:SingletonClass) {
			super();
			this._dict = new Dictionary();
		}
		
		public static const LoadCorePingBack:String = "http://msg.video.qiyi.com/vodpb.gif?url=";
		
		public static const retryMaxCount:int = 3;
		
		public static const Evt_LoadDone:String = "Evt_LoadDone";
		
		public static const Evt_LoadError:String = "Evt_LoadError";
		
		private static var _instance:P2PFileLoader;
		
		public static function get instance() : P2PFileLoader {
			if(_instance == null) {
				_instance = new P2PFileLoader(new SingletonClass());
			}
			return _instance;
		}
		
		private var _loader:URLLoader;
		
		private var _loadErr:Boolean = false;
		
		private var _loadDone:Boolean = false;
		
		private var _isLoading:Boolean = false;
		
		private var _retryCount:int = 0;
		
		private var _retryTimeout:uint;
		
		private var _url:String = "http://dispatcher.video.qiyi.com/dispn/flashppdp.swf";
		
		private var _instanceClass:Class = null;
		
		private var _domain:ApplicationDomain = null;
		
		private var _startTime:uint = 0;
		
		private var _fileIndex:uint = 0;
		
		private var _dict:Dictionary;
		
		public function loadCore(param1:String = "") : void {
			var done:Function = null;
			var var_4:String = param1;
			done = function():void {
				_isLoading = false;
				_loadDone = true;
				dispatchEvent(new Event(Evt_LoadDone));
			};
			if(this._domain != null) {
				try {
					this._instanceClass = this._domain.getDefinition("com.iqiyi.file.File") as Class;
					if(this._instanceClass != null) {
						this._isLoading = true;
						setTimeout(done,10);
						return;
					}
				}
				catch(name_1:*) {
					_instanceClass = null;
				}
			}
			if(this._domain != null) {
				try {
					this._instanceClass = ApplicationDomain.currentDomain.getDefinition("com.iqiyi.file.File") as Class;
					if(this._instanceClass != null) {
						this._isLoading = true;
						setTimeout(done,10);
						return;
					}
				}
				catch(name_1:*) {
					_instanceClass = null;
				}
				if(var_4 != "") {
					this._url = var_4;
				}
				Security.allowDomain("*");
				this._loader = new URLLoader();
				this._loader.dataFormat = URLLoaderDataFormat.BINARY;
				this._loader.addEventListener(Event.COMPLETE,this.onCoreComplete);
				this._loader.addEventListener(IOErrorEvent.IO_ERROR,this.onError);
				this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
				this._loader.load(new URLRequest(this._url));
				this._isLoading = true;
				this._startTime = getTimer();
				return;
			}
			this._instanceClass = ApplicationDomain.currentDomain.getDefinition("com.iqiyi.file.File") as Class;
			if(this._instanceClass != null) {
				this._isLoading = true;
				setTimeout(done,10);
				return;
			}
			if(var_4 != "") {
				this._url = var_4;
			}
			Security.allowDomain("*");
			this._loader = new URLLoader();
			this._loader.dataFormat = URLLoaderDataFormat.BINARY;
			this._loader.addEventListener(Event.COMPLETE,this.onCoreComplete);
			this._loader.addEventListener(IOErrorEvent.IO_ERROR,this.onError);
			this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
			this._loader.load(new URLRequest(this._url));
			this._isLoading = true;
			this._startTime = getTimer();
		}
		
		private function onCoreComplete(param1:Event) : void {
			var swfLoader:Loader = null;
			var done:Function = null;
			var var_5:Event = param1;
			done = function(param1:Event):void {
				sendToURL(new URLRequest(LoadCorePingBack + _url + "&tag=done&curl=" + _url + "&useTime=" + (getTimer() - _startTime) + "&dur=" + getTimer()));
				_isLoading = false;
				swfLoader.removeEventListener(Event.COMPLETE,done);
				_instanceClass = _domain.getDefinition("com.iqiyi.file.File") as Class;
				_loadDone = true;
				dispatchEvent(new Event(Evt_LoadDone));
			};
			this._loader.removeEventListener(Event.COMPLETE,this.onCoreComplete);
			this._loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
			this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
			swfLoader = new Loader();
			swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,done);
			this._domain = new ApplicationDomain();
			var context:LoaderContext = new LoaderContext(false,this._domain);
			swfLoader.loadBytes(this._loader.data as ByteArray,context);
		}
		
		private function onError(param1:*) : void {
			this._loader.removeEventListener(Event.COMPLETE,this.onCoreComplete);
			this._loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
			this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
			clearTimeout(this._retryTimeout);
			this._retryTimeout = setTimeout(this.retry,1000);
		}
		
		private function retry() : void {
			clearTimeout(this._retryTimeout);
			this._retryCount++;
			if(this._retryCount > retryMaxCount) {
				sendToURL(new URLRequest(LoadCorePingBack + this._url + "&tag=lost&curl=" + this._url + "&useTime=" + (getTimer() - this._startTime) + "&dur=" + getTimer()));
				this._loadErr = true;
				this._isLoading = false;
				this._loadDone = false;
				dispatchEvent(new Event(Evt_LoadError));
				return;
			}
			this._loader.load(new URLRequest(this._url + "?rn=" + getTimer()));
		}
		
		public function getFile() : File {
			if(this._instanceClass == null) {
				return null;
			}
			this._dict[this._fileIndex.toString()] = new this._instanceClass();
			var _loc1_:File = new File(this._fileIndex.toString());
			this._fileIndex++;
			return _loc1_;
		}
		
		public function method_1(param1:String) : Object {
			return this._dict[param1];
		}
		
		public function deleteFile(param1:String) : void {
			var _loc2_:* = undefined;
			if(param1 in this._dict) {
				_loc2_ = this._dict[param1];
				_loc2_["clear"]();
				delete this._dict[param1];
				true;
			}
		}
		
		public function get loadDone() : Boolean {
			return this._loadDone;
		}
		
		public function get loadErr() : Boolean {
			return this._loadErr;
		}
		
		public function get isLoading() : Boolean {
			return this._isLoading;
		}
		
		public function get version() : String {
			if(this._instanceClass == null) {
				return "";
			}
			return this._instanceClass["version"];
		}
	}
}
class SingletonClass extends Object {
	
	function SingletonClass() {
		super();
	}
}
