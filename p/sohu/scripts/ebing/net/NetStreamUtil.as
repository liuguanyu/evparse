package ebing.net {
	import flash.net.NetStream;
	import flash.net.URLVariables;
	import ebing.Utils;
	import flash.utils.getTimer;
	import flash.events.*;
	import flash.net.NetConnection;
	
	public class NetStreamUtil extends NetStream {
		
		public function NetStreamUtil(param1:NetConnection, param2:Boolean = false) {
			this._is200 = param2;
			super(param1);
			this.sysInit("start");
		}
		
		protected const GSLB_TIMEOUT:uint = 6;
		
		protected var _url:String;
		
		protected var _gone:String;
		
		protected var _node:String;
		
		protected var _checkP2P:URLLoaderUtil;
		
		protected var _cdnuse:Number = -1;
		
		protected var _spend_num:Number = 0;
		
		protected var _gslbUrl:String;
		
		protected var _isPlay:Boolean = true;
		
		protected var _location:String = "";
		
		protected var _playUrl:String = "";
		
		protected var _parameterString:String = "";
		
		protected var _parameter:URLVariables;
		
		protected var _bufferNum:uint = 0;
		
		protected var _cdnNum:Number = 0;
		
		protected var _gslbNum:Number = 0;
		
		protected var _dragTime:Number = 0;
		
		protected var _isDrag:Boolean = false;
		
		protected var _is200:Boolean = false;
		
		protected var _gslbLoader:URLLoaderUtil;
		
		protected var _clipNo:uint = 0;
		
		protected var _gotMetaData:Boolean = false;
		
		protected function sysInit(param1:String) : void {
			if(param1 == "start") {
				this.newFunc();
			}
		}
		
		protected function newFunc() : void {
		}
		
		public function set clipNo(param1:uint) : void {
			this._clipNo = param1;
		}
		
		protected function doPlay(param1:String) : void {
			Utils.debug("_isPlay:" + this._isPlay);
			this._cdnuse = getTimer();
			this.gotMetaData = false;
			if(this._isPlay) {
				super.play(param1);
			} else {
				super.play(param1);
				this.pause();
				seek(0);
			}
			this._playUrl = param1;
			this.bufferNum = 0;
			var _loc2_:RegExp = new RegExp("start=");
			this._isDrag = _loc2_.test(param1)?true:false;
		}
		
		public function set gotMetaData(param1:Boolean) : void {
			this._gotMetaData = param1;
		}
		
		public function get gotMetaData() : Boolean {
			return this._gotMetaData;
		}
		
		override public function play(... rest) : void {
			var p:URLVariables = null;
			var arguments:Array = rest;
			this._isPlay = true;
			this._gslbUrl = arguments[0];
			try {
				p = new URLVariables(this._gslbUrl.split("?")[1]);
				this._dragTime = p.start != undefined?Number(p.start):this._dragTime;
			}
			catch(evt:Error) {
				_dragTime = 0;
			}
			if(this._is200) {
				this.loadLocationAndPlay();
			} else {
				this.doPlay(this._gslbUrl);
			}
		}
		
		override public function close() : void {
			super.close();
			this._isPlay = false;
			try {
				if(this._gslbLoader != null) {
					this._gslbLoader.close();
				}
			}
			catch(evt:Event) {
				trace("NetStreamUtil evt:" + evt);
			}
		}
		
		protected function loadLocationAndPlay() : void {
			var url:String = null;
			var K102607C939D77E372B425F9B2092364BF65E81373570K:String = null;
			var K1025555F8D5C586B1E4F64BF49F473C1F3B52C373518K:Boolean = false;
			var sp:String = null;
			var K10255269C23FDCE8B24503A67C29619F006FF3373515K:* = undefined;
			var p:URLVariables = null;
			var K102607C6F57607D07E473DAF7A03C59160D558373570K:RegExp = new RegExp("\\?start=");
			var boo:Boolean = K102607C6F57607D07E473DAF7A03C59160D558373570K.test(this._gslbUrl);
			if(this._location == "") {
				url = boo?this._gslbUrl + "&prot=2":this._gslbUrl + "?prot=2";
				this._gslbLoader = new URLLoaderUtil();
				this._gslbLoader.load(this.GSLB_TIMEOUT,function(param1:Object):void {
					var _loc2_:Array = null;
					_spend_num = param1.target.spend;
					if(param1.info == "success") {
						_url = param1.data;
						_url = _url.split("|")[0];
						_loc2_ = _url.split("?");
						_location = _loc2_[0];
						_parameterString = _loc2_[1];
						if(_loc2_.length > 1) {
							_parameter = new URLVariables(_loc2_[1]);
						}
						doPlay(_url);
						dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS,false,false,{"code":"GSLB.Success"}));
					} else if(param1.info == "timeout") {
						dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS,false,false,{
							"code":"GSLB.Failed",
							"reason":"timeout"
						}));
					} else {
						dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS,false,false,{
							"code":"GSLB.Failed",
							"reason":"ioerror"
						}));
					}
					
				},url,null);
			} else {
				this._spend_num = 0;
				K102607C939D77E372B425F9B2092364BF65E81373570K = "";
				if(boo) {
					K102607C939D77E372B425F9B2092364BF65E81373570K = this._location;
					K1025555F8D5C586B1E4F64BF49F473C1F3B52C373518K = true;
					sp = "?";
					for(K10255269C23FDCE8B24503A67C29619F006FF3373515K in this._parameter) {
						if(K10255269C23FDCE8B24503A67C29619F006FF3373515K.toString() != "start") {
							if(K1025555F8D5C586B1E4F64BF49F473C1F3B52C373518K) {
								K1025555F8D5C586B1E4F64BF49F473C1F3B52C373518K = false;
								sp = "?";
							} else {
								sp = "&";
							}
							K102607C939D77E372B425F9B2092364BF65E81373570K = K102607C939D77E372B425F9B2092364BF65E81373570K + (sp + K10255269C23FDCE8B24503A67C29619F006FF3373515K.toString() + "=" + this._parameter[K10255269C23FDCE8B24503A67C29619F006FF3373515K]);
						}
					}
					sp = K1025555F8D5C586B1E4F64BF49F473C1F3B52C373518K?"?":"&";
					p = new URLVariables(this._gslbUrl.split("?")[1]);
					K102607C939D77E372B425F9B2092364BF65E81373570K = K102607C939D77E372B425F9B2092364BF65E81373570K + (sp + "start=" + p.start);
				} else {
					K102607C939D77E372B425F9B2092364BF65E81373570K = this._location + "?" + this._parameterString;
				}
				this.doPlay(K102607C939D77E372B425F9B2092364BF65E81373570K);
			}
		}
		
		public function retry(param1:String) : void {
			this._gslbUrl = param1;
			this.play(this._gslbUrl);
			this.pause();
		}
		
		override public function pause() : void {
			this._isPlay = false;
			super.pause();
		}
		
		override public function resume() : void {
			this._isPlay = true;
			super.resume();
		}
		
		public function get gone() : String {
			return this._gone;
		}
		
		public function get location() : String {
			return this._url;
		}
		
		public function get node() : String {
			return this._node;
		}
		
		public function get gslbSpendTime() : Number {
			return this._spend_num;
		}
		
		public function destroyLocation() : void {
			this._location = "";
		}
		
		public function get bufferNum() : uint {
			return this._bufferNum;
		}
		
		public function set bufferNum(param1:uint) : void {
			this._bufferNum = param1;
		}
		
		public function get playUrl() : String {
			return this._playUrl;
		}
		
		public function get isDrag() : Boolean {
			return this._isDrag;
		}
		
		public function get dragTime() : Number {
			return this._dragTime;
		}
		
		public function set dragTime(param1:Number) : void {
			this._dragTime = param1;
		}
		
		public function get cdnNum() : Number {
			return this._cdnNum;
		}
		
		public function set cdnNum(param1:Number) : void {
			this._cdnNum = param1;
		}
		
		public function get gslbNum() : Number {
			return this._gslbNum;
		}
		
		public function set gslbNum(param1:Number) : void {
			this._gslbNum = param1;
		}
		
		public function get gslbUrl() : String {
			return this._gslbUrl;
		}
		
		public function get cdnuse() : Number {
			var _loc1_:Number = this._cdnuse != -1?getTimer() - this._cdnuse:-1;
			this._cdnuse = -1;
			return _loc1_;
		}
		
		public function set is200(param1:Boolean) : void {
			this._is200 = param1;
		}
		
		public function get is200() : Boolean {
			return this._is200;
		}
		
		protected function superPlay(param1:*) : void {
			super.play(param1);
		}
		
		public function get isPlay() : Boolean {
			return this._isPlay;
		}
	}
}
