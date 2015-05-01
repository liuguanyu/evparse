package com.qiyi.player.wonder.plugins.scenetile.model.barrage.socket {
	import flash.events.EventDispatcher;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import com.qiyi.player.base.logging.ILogger;
	import flash.system.Security;
	import flash.events.Event;
	import com.qiyi.player.wonder.common.event.CommonEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.utils.Endian;
	import com.qiyi.player.user.impls.UserManager;
	import com.qiyi.player.base.uuid.UUIDManager;
	import com.adobe.serialization.json.JSON;
	import com.qiyi.player.base.logging.Log;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	
	public class BarrageSocket extends EventDispatcher {
		
		public function BarrageSocket() {
			this._log = Log.getLogger("com.qiyi.player.wonder.plugins.scenetile.model.barrage.socket.BarrageSocket");
			super();
			this._socket = new Socket();
			this._socket.endian = Endian.BIG_ENDIAN;
			this._socket.addEventListener(Event.CONNECT,this.onConnectHandler);
			this._socket.addEventListener(IOErrorEvent.IO_ERROR,this.onIOErrorHandler);
			this._socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityErrorHandler);
			this._socket.addEventListener(Event.CLOSE,this.onCloseHandler);
			this._socket.addEventListener(ProgressEvent.SOCKET_DATA,this.onSocketDataHandler);
			this._socketData = new ByteArray();
			this._socketData.endian = Endian.BIG_ENDIAN;
			this._cacheData = new ByteArray();
			this._cacheData.endian = Endian.BIG_ENDIAN;
			this._timer = new Timer(this.HEART_BEAT_TIME);
			this._timer.addEventListener(TimerEvent.TIMER,this.onHeartBeat);
		}
		
		public static const Evt_BarrageSocketConnected:String = "evtBarrageSocketConnected";
		
		public static const Evt_BarrageSocketIOError:String = "evtBarrageSocketIOError";
		
		public static const Evt_BarrageSocketSecurityError:String = "evtBarrageSocketSecurityError";
		
		public static const Evt_BarrageSocketClose:String = "evtBarrageSocketClose";
		
		public static const Evt_BarrageSocketReceiveData:String = "evtBarrageSocketReceiveData";
		
		public static const TVL_TYPE_LOGIN:int = 1;
		
		public static const TVL_TYPE_LOGOUT:int = 2;
		
		public static const TVL_TYPE_PRIVATE:int = 3;
		
		public static const TVL_TYPE_MULTICAST:int = 4;
		
		public static const TVL_TYPE_HEART_BEAT:int = 5;
		
		public static const TVL_TYPE_SEND_MESSAGE:int = 6;
		
		public static const APPID:int = 21;
		
		private const DOMAIN:String = "buffalo.sns.iqiyi.com";
		
		private const PORT_SOCKET:int = 9527;
		
		private const PORT_CROSSDOMAIN:int = 9528;
		
		private const HEAD_BYTE_SIZE:int = 8;
		
		private const TVL_TYPE_BYTE_SIZE:int = 1;
		
		private const TVL_CONTENTSIZE_BYTE_SIZE:int = 4;
		
		private const HEART_BEAT_TIME:int = 5000;
		
		private var _socket:Socket;
		
		private var _socketData:ByteArray;
		
		private var _cacheData:ByteArray;
		
		private var _timer:Timer;
		
		private var _tvid:String = "";
		
		private var _isConnecting:Boolean = false;
		
		private var _log:ILogger;
		
		public function get connected() : Boolean {
			return this._socket.connected;
		}
		
		public function get isConnecting() : Boolean {
			return this._isConnecting;
		}
		
		public function open(param1:String) : void {
			this._tvid = param1;
			if(!this._socket.connected && !this._isConnecting) {
				this._log.info("BarrageSocket start connect!");
				this._isConnecting = true;
				Security.loadPolicyFile("xmlsocket://" + this.DOMAIN + ":" + this.PORT_CROSSDOMAIN);
				this._socket.connect(this.DOMAIN,this.PORT_SOCKET);
			}
		}
		
		public function close() : void {
			this._isConnecting = false;
			this._timer.stop();
			this.sendLogout();
			try {
				this._socket.close();
				this._log.info("BarrageSocket closed!");
			}
			catch(error:Error) {
			}
			this.clearBytes();
		}
		
		private function clearBytes() : void {
			this._socketData.length = 0;
			this._socketData.position = 0;
			this._cacheData.length = 0;
			this._cacheData.position = 0;
		}
		
		private function onConnectHandler(param1:Event) : void {
			this._log.info("BarrageSocket connect successful!");
			this._isConnecting = false;
			this.clearBytes();
			this.sendLogin();
			this._timer.start();
			dispatchEvent(new CommonEvent(Evt_BarrageSocketConnected));
		}
		
		private function onIOErrorHandler(param1:IOErrorEvent) : void {
			this._log.info("BarrageSocket IO error!");
			this._isConnecting = false;
			this._timer.stop();
			this.clearBytes();
			dispatchEvent(new CommonEvent(Evt_BarrageSocketIOError));
		}
		
		private function onSecurityErrorHandler(param1:Event) : void {
			this._log.info("BarrageSocket security error!");
			this._isConnecting = false;
			this._timer.stop();
			this.clearBytes();
			dispatchEvent(new CommonEvent(Evt_BarrageSocketSecurityError));
		}
		
		private function onCloseHandler(param1:Event) : void {
			this._log.info("BarrageSocket server close!");
			this._isConnecting = false;
			this._timer.stop();
			this.clearBytes();
			dispatchEvent(new CommonEvent(Evt_BarrageSocketClose));
		}
		
		private function onSocketDataHandler(param1:ProgressEvent) : void {
			var _loc2_:* = 0;
			var _loc3_:* = 0;
			var _loc4_:* = 0;
			var _loc5_:* = 0;
			this._socket.readBytes(this._socketData,this._socketData.length);
			while(this._socketData.length >= this.HEAD_BYTE_SIZE) {
				this._socketData.position = 0;
				_loc2_ = this._socketData.readUnsignedShort();
				_loc3_ = this._socketData.readUnsignedShort();
				_loc4_ = this._socketData.readUnsignedInt();
				_loc5_ = this._socketData.length - this.HEAD_BYTE_SIZE - _loc4_;
				if(_loc5_ >= 0) {
					this.parse(_loc3_);
					if(_loc5_ > 0) {
						this._cacheData.writeBytes(this._socketData,this.HEAD_BYTE_SIZE + _loc4_);
						this._socketData.position = 0;
						this._socketData.length = 0;
						this._socketData.writeBytes(this._cacheData);
						this._cacheData.length = 0;
						this._cacheData.position = 0;
					} else {
						this._socketData.length = 0;
					}
					this._socketData.position = 0;
					continue;
				}
				break;
			}
		}
		
		private function parse(param1:int) : void {
			var _loc2_:Array = null;
			var _loc3_:* = 0;
			var _loc4_:* = 0;
			var _loc5_:* = 0;
			var _loc6_:String = null;
			var _loc7_:Object = null;
			if(param1 > 0) {
				_loc2_ = [];
				this._socketData.position = this.HEAD_BYTE_SIZE;
				_loc3_ = 0;
				while(_loc3_ < param1) {
					_loc4_ = this._socketData.readUnsignedByte();
					_loc5_ = this._socketData.readUnsignedInt();
					_loc6_ = this._socketData.readMultiByte(_loc5_,"utf-8");
					_loc7_ = new Object();
					_loc7_.TVLType = _loc4_;
					_loc7_.TVLContent = _loc6_;
					_loc2_.push(_loc7_);
					_loc3_++;
				}
				dispatchEvent(new CommonEvent(Evt_BarrageSocketReceiveData,_loc2_));
			}
		}
		
		private function onHeartBeat(param1:Event) : void {
			this.sendHeartBeat();
		}
		
		public function send(param1:int, param2:String) : void {
			var _loc3_:* = 0;
			var _loc4_:* = 0;
			var _loc5_:ByteArray = null;
			if(this._socket.connected) {
				_loc3_ = 1;
				_loc4_ = 1;
				_loc5_ = new ByteArray();
				_loc5_.endian = Endian.BIG_ENDIAN;
				_loc5_.writeMultiByte(param2,"utf-8");
				this._socket.writeShort(_loc3_);
				this._socket.writeShort(_loc4_);
				this._socket.writeInt(this.TVL_TYPE_BYTE_SIZE + this.TVL_CONTENTSIZE_BYTE_SIZE + _loc5_.length);
				this._socket.writeByte(param1);
				this._socket.writeInt(_loc5_.length);
				this._socket.writeBytes(_loc5_);
				this._socket.flush();
			}
		}
		
		public function sendLogin(param1:Boolean = true) : void {
			this.send(TVL_TYPE_LOGIN,this.createSendContent(TVL_TYPE_LOGIN,param1));
		}
		
		private function sendLogout() : void {
			this.send(TVL_TYPE_LOGOUT,this.createSendContent(TVL_TYPE_LOGOUT));
		}
		
		private function sendHeartBeat() : void {
			this.send(TVL_TYPE_HEART_BEAT,this.createSendContent(TVL_TYPE_HEART_BEAT));
		}
		
		private function createSendContent(param1:int, param2:Boolean = true) : String {
			var _loc3_:* = "";
			if(UserManager.getInstance().user) {
				_loc3_ = UserManager.getInstance().user.P00001;
			}
			var _loc4_:Object = new Object();
			_loc4_.msgType = param1;
			var _loc5_:Object = new Object();
			_loc5_.tvid = Number(this._tvid);
			_loc5_.addTime = new Date().getTime();
			_loc5_.authcookie = _loc3_;
			_loc5_.udid = UUIDManager.instance.uuid;
			_loc5_.appid = APPID;
			_loc5_.history = param2?1:0;
			_loc4_.data = [_loc5_];
			return com.adobe.serialization.json.JSON.encode(_loc4_);
		}
	}
}
