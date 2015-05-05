package com.hls_p2p.loaders.p2pLoader
{
   import flash.events.EventDispatcher;
   import flash.net.URLLoader;
   import com.p2p.utils.console;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import com.hls_p2p.data.vo.LiveVodConfig;
   import flash.net.URLRequest;
   import com.p2p.utils.json.JSONDOC;
   import flash.events.IEventDispatcher;
   
   public class Selector_Loader extends EventDispatcher
   {
      
      public var isDebug:Boolean = true;
      
      public var var_237:String;
      
      public var var_238:uint;
      
      public var var_207:uint;
      
      public var var_239:String;
      
      public var var_240:String;
      
      public var var_241:uint;
      
      public var var_242:Boolean;
      
      public var var_243:Boolean;
      
      public var var_244:Boolean;
      
      public var error:Boolean;
      
      public var var_245:String;
      
      public var var_246:String;
      
      public var var_247:Boolean = false;
      
      public var sharePeers:Boolean;
      
      public var maxQPeers:uint = 6;
      
      public var hbInterval:uint = 11;
      
      private var var_39:String = "";
      
      private var var_248:String;
      
      private var var_210:uint = 80;
      
      private var var_249:int = 0;
      
      public var urgentSize:uint = 10;
      
      public var urgentLevel1:uint = 300;
      
      private var var_192:URLLoader;
      
      private var _type:String = "gather";
      
      private var var_250:int = 1;
      
      public var var_251:Array;
      
      private var var_183:String = "";
      
      public function Selector_Loader(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public function init(param1:String, param2:String, param3:uint, param4:String = "gather", param5:String = "", param6:int = 0) : void
      {
         console.log(this,"groupName:" + param1 + " selectorIP:" + param2 + " selectorPort:" + param3 + " type:" + param4 + " geo:" + param5 + " loadProtocl:" + param6);
         this.var_39 = param1;
         this.var_248 = param2;
         this.var_210 = param3;
         this._type = param4;
         this.var_250 = param6;
         this.var_183 = param5;
         this.method_247(this.var_248,this.var_210,param6);
         this.var_251 = [];
      }
      
      private function method_247(param1:String, param2:uint, param3:int = 0) : void
      {
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc7_:String = null;
         var _loc8_:* = 0;
         var _loc9_:Array = null;
         var _loc10_:String = null;
         this.var_243 = false;
         this.var_242 = true;
         if(this.var_192 == null)
         {
            this.var_192 = new URLLoader();
            this.var_192.addEventListener(Event.COMPLETE,this.method_213);
            this.var_192.addEventListener(IOErrorEvent.IO_ERROR,this.loader_ERROR);
            this.var_192.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.loader_ERROR);
         }
         var _loc4_:* = "";
         if(param3 == 0)
         {
            _loc4_ = String("http://" + param1 + ":" + param2 + "/query?groupId=" + this.var_39 + "&ran=" + Math.floor(Math.random() * 10000));
         }
         else
         {
            _loc5_ = 4;
            if(param3 == 1)
            {
               _loc5_ = 4;
            }
            else if(param3 == 2)
            {
               _loc5_ = 16;
            }
            
            _loc6_ = 1;
            _loc7_ = LiveVodConfig.method_263();
            if(LiveVodConfig.TYPE == LiveVodConfig.LIVE)
            {
               _loc6_ = 2;
            }
            if(this.var_183 != "")
            {
               _loc9_ = this.var_183.split(".");
               _loc10_ = "";
               if(_loc9_.length >= 4)
               {
                  _loc10_ = _loc9_[3];
               }
            }
            _loc8_ = 1;
            _loc4_ = String("http://" + param1 + "/query?type=" + _loc5_ + "&playtype=" + _loc6_ + "&module=flash&ver=" + _loc7_ + "&streamid=" + this.var_39 + "&ispid=" + _loc10_ + "&expect=" + _loc8_ + "&ran=" + Math.floor(Math.random() * 10000));
         }
         console.log(this,"开始请求 selector: " + _loc4_);
         this.var_192.load(new URLRequest(_loc4_));
      }
      
      private function method_213(param1:Event) : void
      {
         var obj:Object = null;
         var var_314:Array = null;
         var var_320:Array = null;
         var var_321:Array = null;
         var e:Event = param1;
         try
         {
            obj = JSONDOC.decode(String(this.var_192.data));
            console.log(this,"loadComplete",String(this.var_192.data));
         }
         catch(e:Error)
         {
            loader_ERROR("dataError");
            return;
         }
         if(this._type == "rtmfp")
         {
            if(obj["status"] == "0")
            {
               this.var_251 = obj["items"];
               if(this.var_250 != 2)
               {
                  this.var_239 = String(this.var_251[0]["serviceUrls"].split(":")[1]).substr(2);
                  this.var_207 = String(this.var_251[0]["serviceUrls"]).split(":")[2];
               }
               else
               {
                  this.var_237 = String(this.var_251[0]["serviceUrls"].split(":")[1]).substr(2);
                  this.var_238 = String(this.var_251[0]["serviceUrls"]).split(":")[2];
               }
               this.setDataTo(obj);
               this.var_243 = true;
               this.var_242 = false;
               this.var_244 = false;
               console.log(this,"selector 成功返回 ：" + this.var_239 + ":" + this.var_207 + " " + this.var_237 + ":" + this.var_238);
            }
            return;
         }
         if(obj["result"] == "success")
         {
            var_314 = String(obj["value"]["rtmfpId"]).split(":");
            var_320 = String(obj["value"]["proxyId"]).split(":");
            this.var_239 = var_314[0];
            this.var_207 = var_314[1];
            this.var_237 = var_320[0];
            this.var_238 = var_320[1];
            this.setDataTo(obj["value"]);
            this.var_243 = true;
            this.var_242 = false;
            this.var_244 = false;
            console.log(this,"selector 成功返回 ：" + this.var_239 + ":" + this.var_207 + " " + this.var_237 + ":" + this.var_238);
         }
         else if(obj["result"] == "redirect")
         {
            var_321 = String(obj["value"]["mselectorId"]).split(":");
            this.var_240 = var_321[0];
            this.var_241 = var_321[1];
            this.var_242 = false;
            this.var_244 = true;
         }
         else if(obj["result"] == "failed")
         {
            this.var_247 = true;
         }
         else
         {
            this.loader_ERROR("dataError");
            return;
         }
         
         
      }
      
      private function setDataTo(param1:Object) : void
      {
         console.log(this,"setDataTo",param1);
         if(param1.hasOwnProperty("fetchRate"))
         {
            LiveVodConfig.DAT_LOAD_RATE = Number(param1["fetchRate"]);
         }
         if(param1.hasOwnProperty("maxPeers"))
         {
            LiveVodConfig.var_286 = Number(param1["maxPeers"]);
         }
         if((param1.hasOwnProperty("maxMem")) && uint(param1["maxMem"]) > 0)
         {
            LiveVodConfig.method_262 = uint(param1["maxMem"]);
         }
         if(param1.hasOwnProperty("urgentSize"))
         {
            LiveVodConfig.method_266 = param1["urgentSize"];
         }
         if(param1.hasOwnProperty("urgentLevel1"))
         {
            LiveVodConfig.var_284 = param1["urgentLevel1"];
         }
         if(param1.hasOwnProperty("sharePeers"))
         {
            this.sharePeers = param1["sharePeers"];
         }
         if(param1.hasOwnProperty("maxQPeers"))
         {
            this.maxQPeers = param1["maxQPeers"];
         }
         if(param1.hasOwnProperty("hbInterval"))
         {
            this.hbInterval = param1["hbInterval"];
         }
         if(param1.hasOwnProperty("cdnDisable"))
         {
            LiveVodConfig.cdnDisable = int(param1["cdnDisable"]);
         }
         if(param1.hasOwnProperty("cdnStartTime"))
         {
            LiveVodConfig.var_288 = int(param1["cdnStartTime"]);
         }
      }
      
      private function loader_ERROR(param1:* = null) : void
      {
         this.var_244 = false;
         this.var_243 = false;
         this.var_242 = false;
         this.error = true;
      }
      
      public function clear() : void
      {
         if(this.var_192)
         {
            if(this.var_192.hasEventListener(Event.COMPLETE))
            {
               try
               {
                  this.var_192.close();
               }
               catch(err:Error)
               {
               }
               this.var_192.removeEventListener(Event.COMPLETE,this.method_213);
               this.var_192.removeEventListener(IOErrorEvent.IO_ERROR,this.loader_ERROR);
               this.var_192.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.loader_ERROR);
            }
         }
         this.var_192 = null;
         this.loader_ERROR();
      }
   }
}
