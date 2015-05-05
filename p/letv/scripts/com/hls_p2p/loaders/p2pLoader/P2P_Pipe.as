package com.hls_p2p.loaders.p2pLoader
{
   import flash.events.EventDispatcher;
   import flash.net.NetStream;
   import flash.net.NetConnection;
   import flash.utils.Timer;
   import com.p2p.utils.console;
   import flash.events.TimerEvent;
   import flash.events.NetStatusEvent;
   import flash.events.AsyncErrorEvent;
   import flash.utils.ByteArray;
   import flash.net.sendToURL;
   import flash.net.URLRequest;
   
   public class P2P_Pipe extends EventDispatcher
   {
      
      public var isDebug:Boolean = true;
      
      public var var_223:Boolean = false;
      
      public var canSend:Boolean = false;
      
      public var name_6:Boolean = false;
      
      public var XNetStream:NetStream = null;
      
      public var var_233:NetConnection;
      
      private var var_113:String;
      
      protected var var_234:String;
      
      protected var var_218:Timer;
      
      public var name_7:Function = null;
      
      public var name_5:Function = null;
      
      private var var_235:String;
      
      private var var_236:Boolean = false;
      
      private var var_38:Number = 0;
      
      public function P2P_Pipe(param1:NetConnection, param2:String)
      {
         super();
         this.var_233 = param1;
         this.var_113 = param2;
      }
      
      public function get groupID() : String
      {
         return this.var_113;
      }
      
      public function get remoteID() : String
      {
         return this.var_234;
      }
      
      public function get method_243() : String
      {
         return this.var_235;
      }
      
      public function set method_243(param1:String) : void
      {
         this.var_235 = param1;
      }
      
      public function clear() : void
      {
         console.log(this,"clear");
         this.var_223 = false;
         this.canSend = false;
         this.name_6 = false;
         this.var_233 = null;
         this.name_7 = null;
         this.name_5 = null;
         this.var_236 = false;
         if(this.var_218)
         {
            this.var_218.stop();
            this.var_218.removeEventListener(TimerEvent.TIMER,this.method_245);
            this.var_218 = null;
         }
         if(this.XNetStream)
         {
            try
            {
               this.XNetStream.close();
            }
            catch(e:Error)
            {
            }
            if(this.XNetStream.hasEventListener(NetStatusEvent.NET_STATUS))
            {
               this.XNetStream.removeEventListener(NetStatusEvent.NET_STATUS,this.method_230);
            }
            if(this.XNetStream.hasEventListener(AsyncErrorEvent.ASYNC_ERROR))
            {
               this.XNetStream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,this.method_222);
            }
            this.XNetStream = null;
         }
         this.var_113 = null;
         this.var_234 = null;
         this.var_235 = null;
      }
      
      public function method_244(param1:String) : void
      {
         this.var_234 = param1;
         this.var_235 = param1;
         if(this.XNetStream)
         {
            this.name_6 = true;
            this.canSend = true;
            this.XNetStream.client = this;
            this.XNetStream["dataReliable"] = true;
            if(!this.XNetStream.hasEventListener(NetStatusEvent.NET_STATUS))
            {
               this.XNetStream.addEventListener(NetStatusEvent.NET_STATUS,this.method_230);
            }
            if(!this.XNetStream.hasEventListener(AsyncErrorEvent.ASYNC_ERROR))
            {
               this.XNetStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.method_222);
            }
            return;
         }
         if(this.var_218 == null)
         {
            this.var_218 = new Timer(200);
            this.var_218.addEventListener(TimerEvent.TIMER,this.method_245);
            this.var_218.start();
         }
      }
      
      private function method_245(param1:TimerEvent) : void
      {
         var var_308:TimerEvent = param1;
         if(this.var_218)
         {
            this.var_218.delay = 7 * 1000;
         }
         if((this.var_233) && (this.var_233.connected))
         {
            if(this.name_6 == false)
            {
               if(null == this.XNetStream)
               {
                  try
                  {
                     this.XNetStream = new NetStream(this.var_233,this.var_234);
                     this.XNetStream["dataReliable"] = true;
                     this.XNetStream.client = this;
                     this.XNetStream.addEventListener(NetStatusEvent.NET_STATUS,this.method_230);
                     this.XNetStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.method_222);
                     this.XNetStream.play(this.var_113);
                     this.var_218.stop();
                  }
                  catch(err:Error)
                  {
                     name_6 = false;
                     console.log(this,err.getStackTrace());
                     if(XNetStream)
                     {
                        try
                        {
                           XNetStream.close();
                        }
                        catch(err:Error)
                        {
                        }
                     }
                     return;
                  }
               }
               else
               {
                  if(this.XNetStream["dataReliable"] != true)
                  {
                     this.XNetStream["dataReliable"] = true;
                  }
                  if(!this.XNetStream.client || !(this.XNetStream.client == this))
                  {
                     this.XNetStream.client = this;
                  }
                  if(!this.XNetStream.hasEventListener(NetStatusEvent.NET_STATUS))
                  {
                     this.XNetStream.addEventListener(NetStatusEvent.NET_STATUS,this.method_230);
                  }
                  if(!this.XNetStream.hasEventListener(AsyncErrorEvent.ASYNC_ERROR))
                  {
                     this.XNetStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.method_222);
                  }
                  this.XNetStream.play(this.var_113);
                  this.var_218.stop();
               }
            }
            else
            {
               this.var_218.stop();
            }
         }
      }
      
      public function sendData(param1:String, param2:Object = null, param3:String = null) : void
      {
         var var_318:ByteArray = null;
         var name:String = param1;
         var data:Object = param2;
         var type:String = param3;
         var obj:Object = new Object();
         obj.name = name;
         obj.type = type;
         if(data)
         {
            var_318 = new ByteArray();
            var_318.writeObject(data);
            obj.data = var_318;
         }
         else
         {
            obj.data = new Object();
         }
         try
         {
            this.XNetStream.send("pipeprocess",obj);
         }
         catch(err:Error)
         {
            console.log(this,"sendData err:" + err + err.getStackTrace());
         }
         obj = null;
      }
      
      public function method_246(param1:Object) : void
      {
      }
      
      public function pipeprocess(... rest) : void
      {
         var obj:Object = null;
         var var_318:ByteArray = null;
         var var_178:String = null;
         var str:String = null;
         var var_319:Array = rest;
         if(this.name_5 != null)
         {
            this.name_6 = true;
            this.canSend = true;
            obj = var_319[0];
            if(!obj)
            {
               console.log(this,"!obj _groupID = " + this.var_113 + ", _remoteID = " + this.var_234);
            }
            try
            {
               var_318 = obj.data;
               obj.data = var_318.readObject() as Object;
               this.name_5(obj.name,obj.data,obj.type);
               if(false == this.var_236)
               {
                  var_178 = "http://s.webp2p.letv.com/ClientTrafficInfo?";
                  str = "";
                  if(var_319.length != 1)
                  {
                     str = String(var_178 + "clientType=" + obj.data.clientType + "&remoteID=" + this.remoteID + "&groupID=" + this.groupID + "&r=" + Math.floor(Math.random() * 100000));
                     sendToURL(new URLRequest(str));
                  }
                  else if(!obj.data)
                  {
                     str = String(var_178 + "clientType=no data" + "&remoteID=" + this.remoteID + "&groupID=" + this.groupID + "&r=" + Math.floor(Math.random() * 100000));
                     sendToURL(new URLRequest(str));
                  }
                  else if(!obj.data.clientType)
                  {
                     str = String(var_178 + "clientType=no data.clientType" + "&remoteID=" + this.remoteID + "&groupID=" + this.groupID + "&r=" + Math.floor(Math.random() * 100000));
                     sendToURL(new URLRequest(str));
                  }
                  
                  
               }
               obj = null;
            }
            catch(err:Error)
            {
               console.log(this,"pipeprocess" + err + err.getStackTrace());
            }
         }
         if(this.name_5 != null)
         {
            return;
         }
      }
      
      public function method_228(param1:*, param2:*) : void
      {
         console.log(this,"stopTransmit called",param1,param2);
      }
      
      public function method_229() : void
      {
         console.log(this,"startTransmit called");
      }
      
      private function method_222(param1:AsyncErrorEvent) : void
      {
      }
      
      private function method_230(param1:NetStatusEvent = null) : void
      {
         switch(param1.info.code)
         {
            case "NetStream.Play.Start":
               this.name_6 = true;
               this.canSend = true;
               break;
            case "NetStream.Play.Reset":
               this.name_6 = false;
               this.canSend = false;
               break;
            case "NetStream.Play.Stop":
               this.name_6 = false;
               this.canSend = false;
               break;
         }
      }
   }
}
