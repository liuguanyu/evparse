package com.worlize.websocket
{
   import flash.events.EventDispatcher;
   import com.adobe.net.URI;
   import flash.net.Socket;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import com.hurlant.crypto.tls.TLSConfig;
   import com.hurlant.crypto.tls.TLSSocket;
   import com.adobe.net.URIEncodingBitmap;
   import flash.events.TimerEvent;
   import com.hurlant.crypto.tls.TLSEngine;
   import com.hurlant.crypto.tls.TLSSecurityParameters;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.ProgressEvent;
   import com.p2p.utils.console;
   import com.hurlant.util.Base64;
   import flash.utils.Endian;
   import com.hurlant.crypto.hash.SHA1;
   import com.adobe.utils.StringUtil;
   
   public class WebSocket extends EventDispatcher
   {
      
      private static const MODE_UTF8:int = 0;
      
      private static const MODE_BINARY:int = 0;
      
      private static const MAX_HANDSHAKE_BYTES:int = 10 * 1024;
      
      public static var logger:Function = function(param1:String):void
      {
         trace(param1);
      };
      
      {
         logger = function(param1:String):void
         {
            trace(param1);
         };
      }
      
      public var isDebug:Boolean = true;
      
      private var _bufferedAmount:int = 0;
      
      private var _readyState:int;
      
      private var _uri:URI;
      
      private var _protocols:Array;
      
      private var _serverProtocol:String;
      
      private var _host:String;
      
      private var _port:uint;
      
      private var _resource:String;
      
      private var _secure:Boolean;
      
      private var _origin:String;
      
      private var _handleExtension:Object;
      
      private var _useNullMask:Boolean = false;
      
      private var rawSocket:Socket;
      
      private var socket:Socket;
      
      private var timeout:uint;
      
      private var fatalError:Boolean = false;
      
      private var nonce:ByteArray;
      
      private var base64nonce:String;
      
      private var serverHandshakeResponse:String;
      
      private var serverExtensions:Array;
      
      private var currentFrame:WebSocketFrame;
      
      private var frameQueue:Vector.<WebSocketFrame>;
      
      private var fragmentationOpcode:int = 0;
      
      private var fragmentationSize:uint = 0;
      
      private var waitingForServerClose:Boolean = false;
      
      private var closeTimeout:int = 5000;
      
      private var closeTimer:Timer;
      
      private var handshakeBytesReceived:int;
      
      private var handshakeTimer:Timer;
      
      private var handshakeTimeout:int = 10000;
      
      private var tlsConfig:TLSConfig;
      
      private var tlsSocket:TLSSocket;
      
      private var URIpathExcludedBitmap:URIEncodingBitmap;
      
      public var config:WebSocketConfig;
      
      public var debug:Boolean = true;
      
      public function WebSocket(param1:String, param2:String, param3:* = null, param4:uint = 10000, param5:Object = null)
      {
         var _loc6_:* = 0;
         this.URIpathExcludedBitmap = new URIEncodingBitmap(URI.URIpathEscape);
         this.config = new WebSocketConfig();
         super(null);
         this._uri = new URI(param1);
         if(param3 is String)
         {
            this._protocols = [param3];
         }
         else
         {
            this._protocols = param3;
         }
         if(this._protocols)
         {
            _loc6_ = 0;
            while(_loc6_ < this._protocols.length)
            {
               this._protocols[_loc6_] = StringUtil.trim(this._protocols[_loc6_]);
               _loc6_++;
            }
         }
         this._origin = param2;
         this._handleExtension = param5;
         this.timeout = param4;
         this.handshakeTimeout = param4;
         this.init();
      }
      
      private function init() : void
      {
         this.parseUrl();
         this.validateProtocol();
         this.frameQueue = new Vector.<WebSocketFrame>();
         this.fragmentationOpcode = 0;
         this.fragmentationSize = 0;
         this.currentFrame = new WebSocketFrame();
         this.fatalError = false;
         this.closeTimer = new Timer(this.closeTimeout,1);
         this.closeTimer.addEventListener(TimerEvent.TIMER,this.handleCloseTimer);
         this.handshakeTimer = new Timer(this.handshakeTimeout,1);
         this.handshakeTimer.addEventListener(TimerEvent.TIMER,this.handleHandshakeTimer);
         this.rawSocket = this.socket = new Socket();
         this.socket.timeout = this.timeout;
         if(this.secure)
         {
            this.tlsConfig = new TLSConfig(TLSEngine.CLIENT,null,null,null,null,null,TLSSecurityParameters.PROTOCOL_VERSION);
            this.tlsConfig.trustAllCertificates = true;
            this.tlsConfig.ignoreCommonNameMismatch = true;
            this.socket = this.tlsSocket = new TLSSocket();
         }
         this.rawSocket.addEventListener(Event.CONNECT,this.handleSocketConnect);
         this.rawSocket.addEventListener(IOErrorEvent.IO_ERROR,this.handleSocketIOError);
         this.rawSocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleSocketSecurityError);
         this.socket.addEventListener(Event.CLOSE,this.handleSocketClose);
         this.socket.addEventListener(ProgressEvent.SOCKET_DATA,this.handleSocketData);
         this._readyState = WebSocketState.INIT;
      }
      
      private function validateProtocol() : void
      {
         var _loc1_:Array = null;
         var _loc2_:* = 0;
         var _loc3_:String = null;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:String = null;
         if(this._protocols)
         {
            _loc1_ = ["(",")","<",">","@",",",";",":","\\","\"","/","[","]","?","=","{","}"," ",String.fromCharCode(9)];
            _loc2_ = 0;
            while(_loc2_ < this._protocols.length)
            {
               _loc3_ = this._protocols[_loc2_];
               _loc4_ = 0;
               while(_loc4_ < _loc3_.length)
               {
                  _loc5_ = _loc3_.charCodeAt(_loc4_);
                  _loc6_ = _loc3_.charAt(_loc4_);
                  if(_loc5_ < 33 || _loc5_ > 126 || !(_loc1_.indexOf(_loc6_) === -1))
                  {
                     throw new WebSocketError("Illegal character \'" + String.fromCharCode(_loc6_) + "\' in subprotocol.");
                  }
                  else
                  {
                     _loc4_++;
                     continue;
                  }
               }
               _loc2_++;
            }
         }
      }
      
      public function connect() : void
      {
         if(this._readyState === WebSocketState.INIT || this._readyState === WebSocketState.CLOSED)
         {
            this._readyState = WebSocketState.CONNECTING;
            this.generateNonce();
            this.handshakeBytesReceived = 0;
            this.rawSocket.connect(this._host,this._port);
            console.log(this,"Connecting to " + this._host + ":" + this._port);
         }
      }
      
      private function parseUrl() : void
      {
         this._host = this._uri.authority;
         var _loc1_:String = this._uri.scheme.toLocaleLowerCase();
         if(_loc1_ === "wss")
         {
            this._secure = true;
            this._port = 443;
         }
         else if(_loc1_ === "ws")
         {
            this._secure = false;
            this._port = 80;
         }
         else
         {
            throw new Error("Unsupported scheme: " + _loc1_);
         }
         
         var _loc2_:uint = parseInt(this._uri.port,10);
         if(!isNaN(_loc2_) && !(_loc2_ === 0))
         {
            this._port = _loc2_;
         }
         var _loc3_:String = URI.fastEscapeChars(this._uri.path,this.URIpathExcludedBitmap);
         if(_loc3_.length === 0)
         {
            _loc3_ = "/";
         }
         var _loc4_:String = this._uri.queryRaw;
         if(_loc4_.length > 0)
         {
            _loc4_ = "?" + _loc4_;
         }
         this._resource = _loc3_ + _loc4_;
      }
      
      private function generateNonce() : void
      {
         this.nonce = new ByteArray();
         var _loc1_:* = 0;
         while(_loc1_ < 16)
         {
            this.nonce.writeByte(Math.round(Math.random() * 255));
            _loc1_++;
         }
         this.nonce.position = 0;
         this.base64nonce = Base64.encodeByteArray(this.nonce);
      }
      
      public function get readyState() : int
      {
         return this._readyState;
      }
      
      public function get bufferedAmount() : int
      {
         return this._bufferedAmount;
      }
      
      public function get uri() : String
      {
         var _loc1_:String = null;
         _loc1_ = this._secure?"wss://":"ws://";
         _loc1_ = _loc1_ + this._host;
         if((this._secure) && !(this._port === 443) || !this._secure && !(this._port === 80))
         {
            _loc1_ = _loc1_ + (":" + this._port.toString());
         }
         _loc1_ = _loc1_ + this._resource;
         return _loc1_;
      }
      
      public function get protocol() : String
      {
         return this._serverProtocol;
      }
      
      public function get extensions() : Array
      {
         return [];
      }
      
      public function get host() : String
      {
         return this._host;
      }
      
      public function get port() : uint
      {
         return this._port;
      }
      
      public function get resource() : String
      {
         return this._resource;
      }
      
      public function get secure() : Boolean
      {
         return this._secure;
      }
      
      public function get connected() : Boolean
      {
         return this.readyState === WebSocketState.OPEN;
      }
      
      public function set useNullMask(param1:Boolean) : void
      {
         this._useNullMask = param1;
      }
      
      public function get useNullMask() : Boolean
      {
         return this._useNullMask;
      }
      
      private function verifyConnectionForSend() : void
      {
         if(this._readyState === WebSocketState.CONNECTING)
         {
            throw new WebSocketError("Invalid State: Cannot send data before connected.");
         }
         else
         {
            return;
         }
      }
      
      public function sendUTF(param1:String) : void
      {
         this.verifyConnectionForSend();
         var _loc2_:WebSocketFrame = new WebSocketFrame();
         _loc2_.opcode = WebSocketOpcode.TEXT_FRAME;
         _loc2_.binaryPayload = new ByteArray();
         _loc2_.binaryPayload.writeMultiByte(param1,"utf-8");
         this.fragmentAndSend(_loc2_);
      }
      
      public function sendBytes(param1:ByteArray) : void
      {
         this.verifyConnectionForSend();
         var _loc2_:WebSocketFrame = new WebSocketFrame();
         _loc2_.opcode = WebSocketOpcode.BINARY_FRAME;
         _loc2_.binaryPayload = param1;
         this.fragmentAndSend(_loc2_);
      }
      
      public function ping(param1:ByteArray = null) : void
      {
         this.verifyConnectionForSend();
         var _loc2_:WebSocketFrame = new WebSocketFrame();
         _loc2_.fin = true;
         _loc2_.opcode = WebSocketOpcode.PING;
         if(param1)
         {
            _loc2_.binaryPayload = param1;
         }
         this.sendFrame(_loc2_);
      }
      
      private function pong(param1:ByteArray = null) : void
      {
         this.verifyConnectionForSend();
         var _loc2_:WebSocketFrame = new WebSocketFrame();
         _loc2_.fin = true;
         _loc2_.opcode = WebSocketOpcode.PONG;
         _loc2_.binaryPayload = param1;
         this.sendFrame(_loc2_);
      }
      
      private function fragmentAndSend(param1:WebSocketFrame) : void
      {
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:WebSocketFrame = null;
         var _loc7_:* = 0;
         if(param1.opcode > 7)
         {
            throw new WebSocketError("You cannot fragment control frames.");
         }
         else
         {
            var _loc2_:uint = this.config.fragmentationThreshold;
            if((this.config.fragmentOutgoingMessages) && (param1.binaryPayload) && param1.binaryPayload.length > _loc2_)
            {
               param1.binaryPayload.position = 0;
               _loc3_ = param1.binaryPayload.length;
               _loc4_ = Math.ceil(_loc3_ / _loc2_);
               _loc5_ = 1;
               while(_loc5_ <= _loc4_)
               {
                  _loc6_ = new WebSocketFrame();
                  _loc6_.opcode = _loc5_ === 1?param1.opcode:0;
                  _loc6_.fin = _loc5_ === _loc4_;
                  _loc7_ = _loc5_ === _loc4_?_loc3_ - _loc2_ * (_loc5_ - 1):_loc2_;
                  param1.binaryPayload.position = _loc2_ * (_loc5_ - 1);
                  _loc6_.binaryPayload = new ByteArray();
                  param1.binaryPayload.readBytes(_loc6_.binaryPayload,0,_loc7_);
                  this.sendFrame(_loc6_);
                  _loc5_++;
               }
            }
            else
            {
               param1.fin = true;
               this.sendFrame(param1);
            }
            return;
         }
      }
      
      private function sendFrame(param1:WebSocketFrame, param2:Boolean = false) : void
      {
         param1.mask = true;
         param1.useNullMask = this._useNullMask;
         var _loc3_:ByteArray = new ByteArray();
         param1.send(_loc3_);
         this.sendData(_loc3_);
      }
      
      private function sendData(param1:ByteArray, param2:Boolean = false) : void
      {
         if(!this.connected)
         {
            return;
         }
         param1.position = 0;
         this.socket.writeBytes(param1,0,param1.bytesAvailable);
         this.socket.flush();
         param1.clear();
      }
      
      public function close(param1:Boolean = true) : void
      {
         var _loc2_:WebSocketFrame = null;
         var _loc3_:ByteArray = null;
         if(!this.socket.connected && this._readyState === WebSocketState.CONNECTING)
         {
            this._readyState = WebSocketState.CLOSED;
            try
            {
               this.socket.close();
            }
            catch(e:Error)
            {
            }
         }
         if(this.socket.connected)
         {
            _loc2_ = new WebSocketFrame();
            _loc2_.rsv1 = _loc2_.rsv2 = _loc2_.rsv3 = _loc2_.mask = false;
            _loc2_.fin = true;
            _loc2_.opcode = WebSocketOpcode.CONNECTION_CLOSE;
            _loc2_.closeStatus = WebSocketCloseStatus.NORMAL;
            _loc3_ = new ByteArray();
            _loc2_.mask = true;
            _loc2_.send(_loc3_);
            this.sendData(_loc3_,true);
            if(param1)
            {
               this.waitingForServerClose = true;
               this.closeTimer.stop();
               this.closeTimer.reset();
               this.closeTimer.start();
            }
            this.dispatchClosedEvent();
         }
      }
      
      private function handleCloseTimer(param1:TimerEvent) : void
      {
         if(this.waitingForServerClose)
         {
            if(this.socket.connected)
            {
               this.socket.close();
            }
         }
      }
      
      private function handleSocketConnect(param1:Event) : void
      {
         console.log(this,"Socket Connected");
         if(this.secure)
         {
            console.log(this,"starting ssl/tls");
            this.tlsSocket.startTLS(this.rawSocket,this._host,this.tlsConfig);
         }
         this.socket.endian = Endian.BIG_ENDIAN;
         this.sendHandshake();
      }
      
      private function handleSocketClose(param1:Event) : void
      {
         console.log(this,"Socket disconnected");
         this.dispatchClosedEvent();
      }
      
      private function handleSocketData(param1:ProgressEvent = null) : void
      {
         var _loc2_:WebSocketEvent = null;
         console.log(this,"handleSocketData:" + param1);
         if(this._readyState === WebSocketState.CONNECTING)
         {
            this.readServerHandshake();
            return;
         }
         while((this.socket.connected) && (this.currentFrame.addData(this.socket,this.fragmentationOpcode,this.config)) && !this.fatalError)
         {
            if(this.currentFrame.protocolError)
            {
               this.drop(WebSocketCloseStatus.PROTOCOL_ERROR,this.currentFrame.dropReason);
               return;
            }
            if(this.currentFrame.frameTooLarge)
            {
               this.drop(WebSocketCloseStatus.MESSAGE_TOO_LARGE,this.currentFrame.dropReason);
               return;
            }
            if(!this.config.assembleFragments)
            {
               _loc2_ = new WebSocketEvent(WebSocketEvent.FRAME);
               _loc2_.frame = this.currentFrame;
               dispatchEvent(_loc2_);
            }
            this.processFrame(this.currentFrame);
            this.currentFrame = new WebSocketFrame();
         }
      }
      
      private function processFrame(param1:WebSocketFrame) : void
      {
         var _loc2_:WebSocketEvent = null;
         var _loc3_:* = 0;
         var _loc4_:WebSocketFrame = null;
         var _loc5_:WebSocketEvent = null;
         var _loc6_:WebSocketEvent = null;
         var _loc7_:* = 0;
         var _loc8_:ByteArray = null;
         var _loc9_:* = 0;
         if((param1.rsv1) || (param1.rsv2) || (param1.rsv3))
         {
            this.drop(WebSocketCloseStatus.PROTOCOL_ERROR,"Received frame with reserved bit set without a negotiated extension.");
            return;
         }
         switch(param1.opcode)
         {
            case WebSocketOpcode.BINARY_FRAME:
               if(this.config.assembleFragments)
               {
                  if(this.frameQueue.length === 0)
                  {
                     if(param1.fin)
                     {
                        _loc2_ = new WebSocketEvent(WebSocketEvent.MESSAGE);
                        _loc2_.message = new WebSocketMessage();
                        _loc2_.message.type = WebSocketMessage.TYPE_BINARY;
                        _loc2_.message.binaryData = param1.binaryPayload;
                        dispatchEvent(_loc2_);
                     }
                     else if(this.frameQueue.length === 0)
                     {
                        this.frameQueue.push(param1);
                        this.fragmentationOpcode = param1.opcode;
                     }
                     
                  }
                  else
                  {
                     this.drop(WebSocketCloseStatus.PROTOCOL_ERROR,"Illegal BINARY_FRAME received in the middle of a fragmented message.  Expected a continuation or control frame.");
                     return;
                  }
               }
               break;
            case WebSocketOpcode.TEXT_FRAME:
               if(this.config.assembleFragments)
               {
                  if(this.frameQueue.length === 0)
                  {
                     if(param1.fin)
                     {
                        _loc2_ = new WebSocketEvent(WebSocketEvent.MESSAGE);
                        _loc2_.message = new WebSocketMessage();
                        _loc2_.message.type = WebSocketMessage.TYPE_UTF8;
                        _loc2_.message.utf8Data = param1.binaryPayload.readMultiByte(param1.length,"utf-8");
                        dispatchEvent(_loc2_);
                     }
                     else
                     {
                        this.frameQueue.push(param1);
                        this.fragmentationOpcode = param1.opcode;
                     }
                  }
                  else
                  {
                     this.drop(WebSocketCloseStatus.PROTOCOL_ERROR,"Illegal TEXT_FRAME received in the middle of a fragmented message.  Expected a continuation or control frame.");
                     return;
                  }
               }
               break;
            case WebSocketOpcode.CONTINUATION:
               if(this.config.assembleFragments)
               {
                  if(this.fragmentationOpcode === WebSocketOpcode.CONTINUATION && param1.opcode === WebSocketOpcode.CONTINUATION)
                  {
                     this.drop(WebSocketCloseStatus.PROTOCOL_ERROR,"Unexpected continuation frame.");
                     return;
                  }
                  this.fragmentationSize = this.fragmentationSize + param1.length;
                  if(this.fragmentationSize > this.config.maxMessageSize)
                  {
                     this.drop(WebSocketCloseStatus.MESSAGE_TOO_LARGE,"Maximum message size exceeded.");
                     return;
                  }
                  this.frameQueue.push(param1);
                  if(param1.fin)
                  {
                     _loc2_ = new WebSocketEvent(WebSocketEvent.MESSAGE);
                     _loc2_.message = new WebSocketMessage();
                     _loc7_ = this.frameQueue[0].opcode;
                     _loc8_ = new ByteArray();
                     _loc9_ = 0;
                     _loc3_ = 0;
                     while(_loc3_ < this.frameQueue.length)
                     {
                        _loc9_ = _loc9_ + this.frameQueue[_loc3_].length;
                        _loc3_++;
                     }
                     if(_loc9_ > this.config.maxMessageSize)
                     {
                        this.drop(WebSocketCloseStatus.MESSAGE_TOO_LARGE,"Message size of " + _loc9_ + " bytes exceeds maximum accepted message size of " + this.config.maxMessageSize + " bytes.");
                        return;
                     }
                     _loc3_ = 0;
                     while(_loc3_ < this.frameQueue.length)
                     {
                        _loc4_ = this.frameQueue[_loc3_];
                        _loc8_.writeBytes(_loc4_.binaryPayload,0,_loc4_.binaryPayload.length);
                        _loc4_.binaryPayload.clear();
                        _loc3_++;
                     }
                     _loc8_.position = 0;
                     switch(_loc7_)
                     {
                        case WebSocketOpcode.BINARY_FRAME:
                           _loc2_.message.type = WebSocketMessage.TYPE_BINARY;
                           _loc2_.message.binaryData = _loc8_;
                           break;
                        case WebSocketOpcode.TEXT_FRAME:
                           _loc2_.message.type = WebSocketMessage.TYPE_UTF8;
                           _loc2_.message.utf8Data = _loc8_.readMultiByte(_loc8_.length,"utf-8");
                           break;
                        default:
                           this.drop(WebSocketCloseStatus.PROTOCOL_ERROR,"Unexpected first opcode in fragmentation sequence: 0x" + _loc7_.toString(16));
                           return;
                     }
                     this.frameQueue = new Vector.<WebSocketFrame>();
                     this.fragmentationOpcode = 0;
                     this.fragmentationSize = 0;
                     dispatchEvent(_loc2_);
                  }
               }
               break;
            case WebSocketOpcode.PING:
               console.log(this,"received ping");
               _loc5_ = new WebSocketEvent(WebSocketEvent.PING,false,true);
               _loc5_.frame = param1;
               if(dispatchEvent(_loc5_))
               {
                  this.pong(param1.binaryPayload);
               }
               break;
            case WebSocketOpcode.PONG:
               if(this.debug)
               {
               }
               console.log(this,"Received Pong");
               _loc6_ = new WebSocketEvent(WebSocketEvent.PONG);
               _loc6_.frame = param1;
               dispatchEvent(_loc6_);
               break;
            case WebSocketOpcode.CONNECTION_CLOSE:
               if(this.debug)
               {
                  console.log(this,"Received close frame");
               }
               if(this.waitingForServerClose)
               {
                  if(this.debug)
                  {
                     console.log(this,"Got close confirmation from server.");
                  }
                  this.closeTimer.stop();
                  this.waitingForServerClose = false;
                  this.socket.close();
               }
               else
               {
                  if(this.debug)
                  {
                     console.log(this,"Sending close response to server.");
                  }
                  this.close(false);
                  this.socket.close();
               }
               break;
            default:
               if(this.debug)
               {
                  console.log(this,"Unrecognized Opcode: 0x" + param1.opcode.toString(16));
               }
               this.drop(WebSocketCloseStatus.PROTOCOL_ERROR,"Unrecognized Opcode: 0x" + param1.opcode.toString(16));
         }
      }
      
      private function handleSocketIOError(param1:IOErrorEvent) : void
      {
         if(this.debug)
         {
            console.log(this,"IO Error: " + param1);
         }
         dispatchEvent(param1);
         this.dispatchClosedEvent();
      }
      
      private function handleSocketSecurityError(param1:SecurityErrorEvent) : void
      {
         if(this.debug)
         {
            console.log(this,"Security Error: " + param1);
         }
         dispatchEvent(param1.clone());
         this.dispatchClosedEvent();
      }
      
      private function sendHandshake() : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         this.serverHandshakeResponse = "";
         var _loc1_:String = this.host;
         if((this._secure) && !(this._port === 443) || !this._secure && !(this._port === 80))
         {
            _loc1_ = _loc1_ + (":" + this._port.toString());
         }
         var _loc2_:* = "";
         _loc2_ = _loc2_ + ("GET " + this.resource + " HTTP/1.1\r\n");
         _loc2_ = _loc2_ + ("Host: " + _loc1_ + "\r\n");
         _loc2_ = _loc2_ + "Upgrade: websocket\r\n";
         _loc2_ = _loc2_ + "Connection: Upgrade\r\n";
         _loc2_ = _loc2_ + ("Sec-WebSocket-Key: " + this.base64nonce + "\r\n");
         if(this._origin)
         {
            _loc2_ = _loc2_ + ("Origin: " + this._origin + "\r\n");
         }
         _loc2_ = _loc2_ + "Sec-WebSocket-Version: 13\r\n";
         if(this._protocols)
         {
            _loc4_ = this._protocols.join(", ");
            _loc2_ = _loc2_ + ("Sec-WebSocket-Protocol: " + _loc4_ + "\r\n");
         }
         for(_loc3_ in this._handleExtension)
         {
            _loc2_ = _loc2_ + (_loc3_ + ":" + this._handleExtension[_loc3_] + "\r\n");
         }
         _loc2_ = _loc2_ + "\r\n";
         if(this.debug)
         {
            logger(_loc2_);
         }
         this.socket.writeMultiByte(_loc2_,"us-ascii");
         this.handshakeTimer.stop();
         this.handshakeTimer.reset();
         this.handshakeTimer.start();
      }
      
      private function failHandshake(param1:String = "Unable to complete websocket handshake.") : void
      {
         if(this.debug)
         {
            logger(param1);
         }
         this._readyState = WebSocketState.CLOSED;
         if(this.socket.connected)
         {
            this.socket.close();
         }
         this.handshakeTimer.stop();
         this.handshakeTimer.reset();
         var _loc2_:WebSocketErrorEvent = new WebSocketErrorEvent(WebSocketErrorEvent.CONNECTION_FAIL);
         _loc2_.text = param1;
         dispatchEvent(_loc2_);
         var _loc3_:WebSocketEvent = new WebSocketEvent(WebSocketEvent.CLOSED);
         dispatchEvent(_loc3_);
      }
      
      private function failConnection(param1:String) : void
      {
         this._readyState = WebSocketState.CLOSED;
         if(this.socket.connected)
         {
            this.socket.close();
         }
         var _loc2_:WebSocketErrorEvent = new WebSocketErrorEvent(WebSocketErrorEvent.CONNECTION_FAIL);
         _loc2_.text = param1;
         dispatchEvent(_loc2_);
         var _loc3_:WebSocketEvent = new WebSocketEvent(WebSocketEvent.CLOSED);
         dispatchEvent(_loc3_);
      }
      
      private function drop(param1:uint = 1002, param2:String = null) : void
      {
         var _loc4_:WebSocketErrorEvent = null;
         if(!this.connected)
         {
            return;
         }
         this.fatalError = true;
         var _loc3_:String = "WebSocket: Dropping Connection. Code: " + param1.toString(10);
         if(param2)
         {
            _loc3_ = _loc3_ + (" - " + param2);
         }
         logger(_loc3_);
         this.frameQueue = new Vector.<WebSocketFrame>();
         this.fragmentationSize = 0;
         if(param1 !== WebSocketCloseStatus.NORMAL)
         {
            _loc4_ = new WebSocketErrorEvent(WebSocketErrorEvent.ABNORMAL_CLOSE);
            _loc4_.text = "Close reason: " + param1;
            dispatchEvent(_loc4_);
         }
         this.sendCloseFrame(param1,param2,true);
         this.dispatchClosedEvent();
         this.socket.close();
      }
      
      private function sendCloseFrame(param1:uint = 1000, param2:String = null, param3:Boolean = false) : void
      {
         var _loc4_:WebSocketFrame = new WebSocketFrame();
         _loc4_.fin = true;
         _loc4_.opcode = WebSocketOpcode.CONNECTION_CLOSE;
         _loc4_.closeStatus = param1;
         if(param2)
         {
            _loc4_.binaryPayload = new ByteArray();
            _loc4_.binaryPayload.writeUTFBytes(param2);
         }
         this.sendFrame(_loc4_,param3);
      }
      
      private function readServerHandshake() : void
      {
         var var_329:String = null;
         var header:Object = null;
         var var_334:String = null;
         var var_335:String = null;
         var var_336:Array = null;
         var var_291:ByteArray = null;
         var var_337:String = null;
         var protocol:String = null;
         var var_323:Boolean = false;
         var var_324:Boolean = false;
         var var_325:Boolean = false;
         var var_326:Boolean = false;
         var var_327:int = -1;
         while(var_327 === -1 && (this.readHandshakeLine()))
         {
            if(this.handshakeBytesReceived > MAX_HANDSHAKE_BYTES)
            {
               this.failHandshake("Received more than " + MAX_HANDSHAKE_BYTES + " bytes during handshake.");
               return;
            }
            var_327 = this.serverHandshakeResponse.search(new RegExp("\\r?\\n\\r?\\n"));
         }
         if(var_327 === -1)
         {
            return;
         }
         if(this.debug)
         {
            logger("Server Response Headers:\n" + this.serverHandshakeResponse);
         }
         this.serverHandshakeResponse = this.serverHandshakeResponse.slice(0,var_327);
         var var_328:Array = this.serverHandshakeResponse.split(new RegExp("\\r?\\n"));
         var_329 = var_328.shift();
         var var_330:Array = var_329.match(new RegExp("^(HTTP\\/\\d\\.\\d) (\\d{3}) ?(.*)$","i"));
         if(var_330.length === 0)
         {
            this.failHandshake("Unable to find correctly-formed HTTP status line.");
            return;
         }
         var var_331:String = var_330[1];
         var var_332:int = parseInt(var_330[2],10);
         var var_333:String = var_330[3];
         if(this.debug)
         {
            logger("HTTP Status Received: " + var_332 + " " + var_333);
         }
         if(var_332 !== 101)
         {
            this.failHandshake("An HTTP response code other than 101 was received.  Actual Response Code: " + var_332 + " " + var_333);
            return;
         }
         this.serverExtensions = [];
         try
         {
            while(var_328.length > 0)
            {
               var_329 = var_328.shift();
               header = this.parseHTTPHeader(var_329);
               var_334 = header.name.toLocaleLowerCase();
               var_335 = header.value.toLocaleLowerCase();
               if(var_334 === "upgrade" && var_335 === "websocket")
               {
                  var_323 = true;
               }
               else if(var_334 === "connection" && var_335 === "upgrade")
               {
                  var_324 = true;
               }
               else if(var_334 === "sec-websocket-extensions" && (header.value))
               {
                  var_336 = header.value.split(",");
                  this.serverExtensions = this.serverExtensions.concat(var_336);
               }
               else if(var_334 === "sec-websocket-accept")
               {
                  var_291 = new ByteArray();
                  var_291.writeUTFBytes(this.base64nonce + "258EAFA5-E914-47DA-95CA-C5AB0DC85B11");
                  var_337 = Base64.encodeByteArray(new SHA1().hash(var_291));
                  if(this.debug)
                  {
                     logger("Expected Sec-WebSocket-Accept value: " + var_337);
                  }
                  if(header.value === var_337)
                  {
                     var_326 = true;
                  }
               }
               else if(var_334 === "sec-websocket-protocol")
               {
                  if(this._protocols)
                  {
                     for each(protocol in this._protocols)
                     {
                        if(protocol == header.value)
                        {
                           this._serverProtocol = protocol;
                        }
                     }
                  }
               }
               
               
               
               
            }
         }
         catch(e:Error)
         {
            failHandshake("There was an error while parsing the following HTTP Header line:\n" + var_329);
            return;
         }
         if(!var_323)
         {
            this.failHandshake("The server response did not include a valid Upgrade: websocket header.");
            return;
         }
         if(!var_324)
         {
            this.failHandshake("The server response did not include a valid Connection: upgrade header.");
            return;
         }
         if(!var_326)
         {
            this.failHandshake("Unable to validate server response for Sec-Websocket-Accept header.");
            return;
         }
         if((this._protocols) && !this._serverProtocol)
         {
            this.failHandshake("The server can not respond in any of our requested protocols");
            return;
         }
         if(this.debug)
         {
            logger("Server Extensions: " + this.serverExtensions.join(" | "));
         }
         this.handshakeTimer.stop();
         this.handshakeTimer.reset();
         this._readyState = WebSocketState.OPEN;
         this.currentFrame = new WebSocketFrame();
         this.frameQueue = new Vector.<WebSocketFrame>();
         var var_298:WebSocketEvent = new WebSocketEvent(WebSocketEvent.OPEN);
         var_298.dataProvider = this.serverHandshakeResponse;
         dispatchEvent(var_298);
         this.serverHandshakeResponse = null;
         this.handleSocketData();
      }
      
      private function handleHandshakeTimer(param1:TimerEvent) : void
      {
         this.failHandshake("Timed out waiting for server response.");
      }
      
      private function parseHTTPHeader(param1:String) : Object
      {
         var _loc2_:Array = param1.split(new RegExp("\\: +"));
         return _loc2_.length === 2?{
            "name":_loc2_[0],
            "value":_loc2_[1]
         }:null;
      }
      
      private function readHandshakeLine() : Boolean
      {
         var _loc1_:String = null;
         while(this.socket.bytesAvailable)
         {
            _loc1_ = this.socket.readMultiByte(1,"us-ascii");
            this.handshakeBytesReceived++;
            this.serverHandshakeResponse = this.serverHandshakeResponse + _loc1_;
            if(_loc1_ == "\n")
            {
               return true;
            }
         }
         return false;
      }
      
      private function dispatchClosedEvent() : void
      {
         var _loc1_:WebSocketEvent = null;
         if(this.handshakeTimer.running)
         {
            this.handshakeTimer.stop();
         }
         if(this._readyState !== WebSocketState.CLOSED)
         {
            this._readyState = WebSocketState.CLOSED;
            _loc1_ = new WebSocketEvent(WebSocketEvent.CLOSED);
            dispatchEvent(_loc1_);
         }
      }
   }
}
