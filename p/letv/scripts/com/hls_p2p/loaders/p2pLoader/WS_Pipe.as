package com.hls_p2p.loaders.p2pLoader
{
   import com.worlize.websocket.WebSocket;
   import flash.utils.ByteArray;
   import flash.errors.IOError;
   import com.worlize.websocket.WebSocketEvent;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import com.worlize.websocket.WebSocketErrorEvent;
   import com.worlize.websocket.WebSocketMessage;
   import com.p2p.utils.console;
   import flash.events.Event;
   import flash.system.Capabilities;
   import com.hls_p2p.data.vo.LiveVodConfig;
   
   public class WS_Pipe extends Object
   {
      
      public var isDebug:Boolean = true;
      
      public var groupID:String;
      
      public var remoteID:String;
      
      public var canSend:Boolean;
      
      public var name_6:Boolean;
      
      public var name_5:Function = null;
      
      public var name_7:Function = null;
      
      public var var_256:String;
      
      public var var_257:String;
      
      private var host:String;
      
      private var port:int;
      
      private var var_258:WebSocket;
      
      private var var_259:ByteArray;
      
      public var origin:String = "*";
      
      public var timeout:uint = 30000;
      
      public var protocols;
      
      public var handleExtensions:Object;
      
      private var var_260:Number = 0;
      
      public function WS_Pipe(param1:String, param2:String, param3:String, param4:int, param5:String)
      {
         super();
         this.groupID = param1;
         this.remoteID = param2;
         this.host = param3;
         this.port = param4;
         this.var_256 = param5;
         var _loc6_:String = Capabilities.os.split(" ")[0];
         var _loc7_:String = LiveVodConfig.method_263();
         this.handleExtensions = {
            "X-MTEP-Client-Id":LiveVodConfig.uuid,
            "X-MTEP-Client-Module":"flash",
            "X-MTEP-Client-Version":_loc7_,
            "X-MTEP-Protocol-Version":"1.0",
            "X-MTEP-Business-Params":"playType=" + LiveVodConfig.TYPE + "&p2pGroupId=" + this.groupID,
            "X-MTEP-OS-Platform":_loc6_,
            "X-MTEP-Hardware-Platform":"pc"
         };
      }
      
      public function init() : void
      {
         this.clear();
         this.var_259 = new ByteArray();
         try
         {
            this.var_257 = "ws://" + this.host + ":" + this.port;
            this.var_258 = new WebSocket(this.var_257,this.origin,this.protocols,this.timeout,this.handleExtensions);
            this.var_258.debug = true;
            this.var_258.addEventListener(WebSocketEvent.CLOSED,this.handleWebSocket);
            this.var_258.addEventListener(WebSocketEvent.OPEN,this.handleWebSocket);
            this.var_258.addEventListener(WebSocketEvent.MESSAGE,this.handleWebSocket);
            this.var_258.addEventListener(WebSocketEvent.PONG,this.handleWebSocket);
            this.var_258.addEventListener(IOErrorEvent.IO_ERROR,this.handleError);
            this.var_258.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleError);
            this.var_258.addEventListener(WebSocketErrorEvent.CONNECTION_FAIL,this.handleError);
            this.var_258.connect();
         }
         catch(e:IOError)
         {
            onError(new IOErrorEvent(IOErrorEvent.IO_ERROR));
         }
         catch(e:SecurityError)
         {
            onError(new SecurityErrorEvent(SecurityErrorEvent.SECURITY_ERROR));
         }
         catch(e:Error)
         {
            onError();
         }
      }
      
      private function handleWebSocket(param1:WebSocketEvent) : void
      {
         var _loc3_:String = null;
         var _loc4_:WebSocketMessage = null;
         var _loc2_:String = param1.type;
         switch(_loc2_)
         {
            case WebSocketEvent.CLOSED:
               console.log(this,"Websocket closed.");
               break;
            case WebSocketEvent.OPEN:
               _loc3_ = String(param1.dataProvider);
               console.log(this,"Websocket OPen");
               this.onConnect(_loc3_);
               break;
            case WebSocketEvent.MESSAGE:
               this.name_6 = true;
               _loc4_ = param1.message;
               switch(_loc4_.type)
               {
                  case WebSocketMessage.TYPE_BINARY:
                     if(this.name_5 != null)
                     {
                        this.name_5(_loc4_.binaryData);
                     }
                     break;
                  case WebSocketMessage.TYPE_UTF8:
                     break;
               }
               break;
            case WebSocketEvent.PONG:
               break;
         }
      }
      
      private function method_254(param1:ByteArray, param2:int) : String
      {
         var _loc4_:* = 0;
         var _loc3_:String = new String();
         while(param2-- > 0)
         {
            _loc4_ = param1.readByte() & 255;
            if(_loc4_ < 16)
            {
               _loc3_ = _loc3_ + "0";
            }
            _loc3_ = _loc3_ + _loc4_.toString(16);
         }
         return _loc3_;
      }
      
      private function handleError(param1:Event) : void
      {
         var _loc2_:String = param1.type;
         switch(_loc2_)
         {
            case IOErrorEvent.IO_ERROR:
               break;
            case SecurityErrorEvent.SECURITY_ERROR:
               break;
            case WebSocketErrorEvent.CONNECTION_FAIL:
               console.log(this,"Connection Failure: " + param1["text"]);
               break;
         }
      }
      
      public function sendData(param1:String, param2:ByteArray) : void
      {
         if(this.var_258)
         {
            this.var_258[param1](param2);
         }
      }
      
      private function onConnect(param1:String) : void
      {
         this.canSend = true;
         this.name_6 = true;
         this.name_7(param1);
      }
      
      private function onError(param1:* = null) : void
      {
         console.log(this,"web_socket error:" + param1 + " " + param1["text"]);
      }
      
      private function onClose(param1:Event) : void
      {
         console.log(this,"web_socket Close:" + param1);
         this.clear();
      }
      
      public function clear() : void
      {
         console.log(this,"web_socket clear" + this.host + ":" + this.port);
         try
         {
            if((this.var_258) && (this.var_258.connected))
            {
               this.var_258.close();
            }
         }
         catch(var_298:Error)
         {
            console.log(this,"catch UTP_socket close erro!r" + var_298.message);
         }
         if(this.var_258)
         {
            this.var_258.removeEventListener(WebSocketEvent.CLOSED,this.handleWebSocket);
            this.var_258.removeEventListener(WebSocketEvent.OPEN,this.handleWebSocket);
            this.var_258.removeEventListener(WebSocketEvent.MESSAGE,this.handleWebSocket);
            this.var_258.removeEventListener(WebSocketEvent.PONG,this.handleWebSocket);
            this.var_258.removeEventListener(IOErrorEvent.IO_ERROR,this.handleError);
            this.var_258.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleError);
            this.var_258.removeEventListener(WebSocketErrorEvent.CONNECTION_FAIL,this.handleError);
            this.var_258.close(true);
         }
         this.var_258 = null;
         if((this.var_259) && this.var_259.length > 0)
         {
            this.var_259.clear();
         }
         this.var_259 = null;
      }
   }
}
