package p2pstream {
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.system.Security;
	import flash.events.*;
	import flash.utils.getTimer;
	import flash.system.Capabilities;
	
	public class FactoryReporter extends Object {
		 {
			var _loc1_:* = true;
			var _loc2_:* = false;
			_loc2_;
			_loc2_;
			_loc1_;
			_loc1_;
			_loc1_;
			_loc1_;
			_loc1_;
			_loc1_;
			_loc2_;
			_loc2_;
		}
		
		public function FactoryReporter() {
			var _loc1_:* = true;
			var _loc2_:* = false;
			_loc1_;
			_loc1_;
			_loc1_;
			_loc1_;
			super();
			_loc2_;
			_loc2_;
		}
		
		public static const BASE_URL:String = "http://realtime.monitor.ppweb.com.cn:6001/FlashP2PMonitorNew/RealTimeReport";
		
		public static const FLASH_VERSION_DEBUGER:String = "112";
		
		public static const PLANT_VERSION_NOT_SATISFIED:String = "113";
		
		public static const DOWNLOAD_TIMEOUT:String = "102";
		
		public static const DOWNLOAD_ERROR:String = "101";
		
		public static const DOWNLOAD_SUCCESS:String = "100";
		
		public static const FLASH_VERSION_OVERDUE:String = "111";
		
		public static function sendReport(param1:String, param2:Object) : void {
			var _loc8_:* = true;
			var _loc9_:* = false;
			_loc9_;
			_loc9_;
			_loc8_;
			_loc8_;
			_loc9_;
			var objectBytes:ByteArray = null;
			_loc8_;
			_loc8_;
			var o:Object = null;
			_loc8_;
			_loc8_;
			var socket:Socket = null;
			_loc9_;
			_loc9_;
			_loc8_;
			var onConnect:Function = null;
			_loc9_;
			var onError:Function = null;
			_loc9_;
			_loc9_;
			_loc8_;
			var onData:Function = null;
			_loc9_;
			_loc9_;
			_loc8_;
			_loc8_;
			var ifirst:Boolean = false;
			_loc8_;
			_loc8_;
			var io:Object = null;
			_loc9_;
			_loc8_;
			var code:String = param1;
			_loc8_;
			_loc8_;
			var info:Object = param2;
			_loc9_;
			_loc9_;
			_loc8_;
			_loc8_;
			Security.allowDomain("*");
			_loc8_;
			if(reportSended) {
				return;
			}
			reportSended = true;
			_loc8_;
			_loc8_;
			_loc8_;
			_loc8_;
			_loc8_;
			var reportObject:Object = new Object();
			_loc8_;
			reportObject.id = "swc";
			reportObject.c = XNetStreamFactory.PARTNERID + "--";
			_loc9_;
			reportObject.t = getTimer();
			reportObject.fv = Capabilities.version;
			reportObject.code = code;
			reportObject.i = info;
			_loc9_;
			_loc9_;
			_loc8_;
			_loc8_;
			objectBytes = new ByteArray();
			_loc8_;
			_loc9_;
			_loc9_;
			_loc9_;
			objectBytes.writeUTFBytes("{");
			_loc9_;
			_loc9_;
			_loc9_;
			_loc9_;
			var first:Boolean = false;
			while(reportObject hasNext _loc4_) {
				_loc9_;
				o = nextName(_loc4_,_loc5_);
				_loc8_;
				_loc8_;
				_loc8_;
				_loc8_;
				if(first) {
					_loc9_;
					_loc9_;
					_loc8_;
					_loc8_;
					objectBytes.writeUTFBytes(",");
					_loc8_;
					_loc8_;
				}
				_loc8_;
				_loc8_;
				if(o != "i") {
					_loc9_;
					_loc9_;
					objectBytes.writeUTFBytes("\"" + o + "\":\"" + reportObject[o] + "\"");
				} else {
					_loc9_;
					objectBytes.writeUTFBytes("\"i\":{");
					_loc8_;
					_loc8_;
					_loc8_;
					_loc8_;
					ifirst = false;
					_loc8_;
					_loc8_;
					_loc9_;
					while(reportObject[o] hasNext _loc6_) {
						_loc9_;
						io = nextName(_loc6_,_loc7_);
						_loc8_;
						_loc8_;
						_loc9_;
						if(ifirst) {
							_loc9_;
							_loc9_;
							_loc8_;
							objectBytes.writeUTFBytes(",");
						}
						_loc8_;
						objectBytes.writeUTFBytes("\"" + io + "\":\"" + reportObject[o][io] + "\"");
						_loc9_;
						ifirst = true;
					}
					_loc9_;
					_loc9_;
					_loc8_;
					objectBytes.writeUTFBytes("}");
					_loc9_;
				}
				_loc9_;
				first = true;
			}
			_loc8_;
			_loc8_;
			_loc9_;
			_loc9_;
			_loc9_;
			_loc9_;
			objectBytes.writeUTFBytes("}");
			_loc9_;
			_loc9_;
			socket = new Socket();
			onConnect = function(param1:Event):void {
				var _loc2_:ByteArray = new ByteArray();
				_loc2_.writeUTFBytes("POST /FlashP2PMonitorNew/RealTimeReport HTTP/1.1\r\n" + "User-Agent: flash\r\n" + "Content-Length: " + objectBytes.length + "\r\n" + "Content-Type: application/binary\r\n" + "Host: realtime.monitor.ppweb.com.cn:6001\r\n\r\n");
				_loc2_.writeBytes(objectBytes);
				socket.writeBytes(_loc2_);
				socket.flush();
			};
			onError = function(param1:Event):void {
				if(socket.connected) {
					socket.close();
				}
			};
			onData = function(param1:Event):void {
				var _loc2_:ByteArray = new ByteArray();
				socket.readBytes(_loc2_);
				if(socket.connected) {
					socket.close();
				}
			};
			_loc9_;
			_loc9_;
			_loc9_;
			_loc9_;
			_loc9_;
			socket.addEventListener(IOErrorEvent.IO_ERROR,onError);
			_loc8_;
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onError);
			_loc8_;
			_loc8_;
			_loc9_;
			socket.addEventListener(Event.CONNECT,onConnect);
			socket.addEventListener(ProgressEvent.SOCKET_DATA,onData);
			_loc8_;
			_loc8_;
			_loc8_;
			socket.connect("realtime.monitor.ppweb.com.cn",6001);
		}
		
		public static var reportSended:Boolean = false;
	}
}
