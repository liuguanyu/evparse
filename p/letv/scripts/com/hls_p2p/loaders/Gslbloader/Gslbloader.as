package com.hls_p2p.loaders.Gslbloader
{
   import flash.events.EventDispatcher;
   import flash.net.URLLoader;
   import com.hls_p2p.data.vo.class_2;
   import flash.utils.Timer;
   import com.hls_p2p.dataManager.DataManager;
   import com.p2p.utils.console;
   import com.p2p.utils.ParseUrl;
   import flash.events.TimerEvent;
   import com.hls_p2p.data.vo.LiveVodConfig;
   import flash.net.URLRequest;
   import flash.events.Event;
   import flash.events.SecurityErrorEvent;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoaderDataFormat;
   
   public class Gslbloader extends EventDispatcher
   {
      
      public var isDebug:Boolean = false;
      
      private var var_100:Boolean = false;
      
      private var var_101:URLLoader = null;
      
      private var _initData:class_2;
      
      private var var_102:Timer;
      
      protected var var_103:DataManager = null;
      
      public function Gslbloader(param1:DataManager)
      {
         super();
         this.var_103 = param1;
         if(this.var_102 == null)
         {
            this.var_102 = new Timer(0,1);
            this.var_102.addEventListener(TimerEvent.TIMER,this.method_149);
         }
         this.method_151();
      }
      
      public function start(param1:class_2) : void
      {
         this._initData = param1;
         if(!this.var_102.running)
         {
            this.var_102.start();
         }
      }
      
      private function method_148(param1:String) : String
      {
         var var_297:Object = null;
         var var_296:String = param1;
         if(this._initData.var_50)
         {
            try
            {
               var_297 = this._initData.var_50.getKey();
               if(var_297)
               {
                  console.log(this,"tm: " + var_297.tm + " key:" + var_297.key);
                  var_296 = ParseUrl.replaceParam(var_296,"tm",var_297.tm);
                  var_296 = ParseUrl.replaceParam(var_296,"key",var_297.key);
               }
            }
            catch(error:Error)
            {
               console.log(this,"_initData.keyCreater is null ");
            }
         }
         if(this._initData.var_50)
         {
            return var_296;
         }
         return var_296;
      }
      
      private function method_149(param1:TimerEvent = null) : void
      {
         var var_299:String = null;
         var var_298:TimerEvent = param1;
         if(LiveVodConfig.TYPE != LiveVodConfig.LIVE)
         {
            this.var_102.stop();
         }
         if(this._initData.gslbURL != "")
         {
            try
            {
               this.var_100 = true;
               var_299 = this._initData.gslbURL;
               console.log(this,"gslb: " + var_299);
               var_299 = this.method_148(var_299);
               console.log(this,"new gslb: " + var_299);
               this.var_101.load(new URLRequest(var_299));
            }
            catch(err:Error)
            {
               var_102.delay = 1000;
               var_102.reset();
               var_102.start();
            }
         }
      }
      
      private function method_150(param1:Event) : void
      {
         var _loc3_:XML = null;
         this.var_100 = false;
         var _loc2_:XML = new XML(param1.target.data);
         if(_loc2_.hasOwnProperty("nodelist"))
         {
            if(_loc2_.nodelist.child("node").length())
            {
               this._initData.flvURL = new Array();
               this._initData.method_66(0);
               for each(_loc3_ in _loc2_.nodelist.children())
               {
                  console.log(this,"gslb xml_node" + _loc3_.toString());
                  this._initData.flvURL.push(_loc3_.toString());
                  trace(this,"gslb xml_node" + _loc3_.toString());
               }
               this._initData.var_52 = true;
            }
         }
         if(_loc2_.hasOwnProperty("forcegslb"))
         {
            this.var_102.delay = Number(_loc2_.forcegslb) * 1000;
            this.var_102.reset();
            this.var_102.start();
         }
         else
         {
            this.var_102.delay = 3000;
            this.var_102.reset();
            this.var_102.start();
         }
      }
      
      private function securityErrorHandler(param1:SecurityErrorEvent) : void
      {
         this.var_100 = false;
         this.var_102.delay = 3000;
         this.var_102.reset();
         this.var_102.start();
      }
      
      private function ioErrorHandler(param1:IOErrorEvent) : void
      {
         this.var_100 = false;
         this.var_102.delay = 3000;
         this.var_102.reset();
         this.var_102.start();
      }
      
      private function method_151() : void
      {
         if(this.var_101 == null)
         {
            this.var_101 = new URLLoader();
            this.var_101.dataFormat = URLLoaderDataFormat.TEXT;
            this.var_101.addEventListener(Event.COMPLETE,this.method_150);
            this.var_101.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
            this.var_101.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
         }
      }
      
      private function method_152() : void
      {
         if(this.var_101 != null)
         {
            try
            {
               this.var_101.close();
            }
            catch(err:Error)
            {
            }
            this.var_101.removeEventListener(Event.COMPLETE,this.method_150);
            this.var_101.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
            this.var_101.removeEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
            this.var_101 = null;
         }
      }
      
      public function clear() : void
      {
         this.var_100 = false;
         this.var_102.stop();
         this.var_102.removeEventListener(TimerEvent.TIMER,this.method_149);
         this.method_152();
         this.var_102 = null;
         this._initData = null;
      }
   }
}
