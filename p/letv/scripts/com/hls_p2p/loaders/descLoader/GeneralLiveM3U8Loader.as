package com.hls_p2p.loaders.descLoader
{
   import com.hls_p2p.data.vo.class_2;
   import com.hls_p2p.dataManager.DataManager;
   import flash.net.URLLoader;
   import flash.utils.Timer;
   import com.p2p.utils.console;
   import flash.events.TimerEvent;
   import com.hls_p2p.data.vo.LiveVodConfig;
   import flash.net.URLRequest;
   import com.p2p.utils.ParseUrl;
   import com.hls_p2p.loaders.LoadManager;
   import flash.net.URLLoaderDataFormat;
   import flash.events.Event;
   import flash.events.SecurityErrorEvent;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import com.hls_p2p.data.vo.Clip;
   import com.hls_p2p.statistics.Statistic;
   
   class GeneralLiveM3U8Loader extends Object implements IDescLoader
   {
      
      public var isDebug:Boolean = true;
      
      private var _initData:class_2 = null;
      
      private var _dataManager:DataManager = null;
      
      private var var_149:Boolean = true;
      
      private var var_150:Boolean = false;
      
      private var var_151:int = 0;
      
      private var var_152:URLLoader;
      
      private var var_153:Timer;
      
      private var var_154:Timer;
      
      public var totalDuration:Number = 0;
      
      private var playerKbps:String = "";
      
      private var flvURL:Array;
      
      private var playLevelArr:Array;
      
      function GeneralLiveM3U8Loader(param1:DataManager)
      {
         this.flvURL = new Array();
         this.playLevelArr = new Array();
         super();
         this._dataManager = param1;
         this.var_154 = new Timer(3 * 1000,1);
         this.var_154.addEventListener(TimerEvent.TIMER,this.method_180);
      }
      
      public function start(param1:class_2) : void
      {
         var _initData:class_2 = param1;
         this._initData = _initData;
         this.var_150 = false;
         this.playerKbps = "";
         this.flvURL = new Array();
         this.playLevelArr = new Array();
         try
         {
            this.method_152();
         }
         catch(error:Error)
         {
            console.log(this,"remove error:" + error);
         }
         this.method_151();
         if(this.var_153 == null)
         {
            this.var_153 = new Timer(5);
            this.var_153.addEventListener(TimerEvent.TIMER,this.method_149);
         }
         this.var_153.delay = 5;
         this.var_153.reset();
         this.var_153.start();
         this.var_154.reset();
      }
      
      public function stop() : void
      {
         try
         {
            this.method_152();
         }
         catch(error:Error)
         {
            console.log(this,"remove error:" + error);
         }
         this.method_151();
         this.var_150 = false;
         this.var_153.delay = 6 * 1000;
         this.playerKbps = "";
         this.flvURL = new Array();
         this.playLevelArr = new Array();
      }
      
      public function clear() : void
      {
         console.log(this,"clear");
         if(this.var_153)
         {
            this.var_153.stop();
            this.var_153.removeEventListener(TimerEvent.TIMER,this.method_149);
         }
         if(this.var_154)
         {
            this.var_154.stop();
            this.var_154.removeEventListener(TimerEvent.TIMER,this.method_180);
         }
         this.method_152();
         this._dataManager = null;
         this.var_153 = null;
         this._initData = null;
         this.var_154 = null;
         this.playerKbps = "";
         this.flvURL = new Array();
         this.playLevelArr = new Array();
      }
      
      private function method_180(param1:TimerEvent) : void
      {
         console.log(this,"timeOutHandler: " + param1);
      }
      
      private function method_181() : void
      {
         this.var_149 = true;
         this.playerKbps = "";
         if("noError" != LiveVodConfig.EXT_LETV_M3U8_ERRCODE)
         {
            return;
         }
         if(false == this._initData.var_53)
         {
            try
            {
               if((this._initData.flvURL[this._initData.g_nM3U8Idx]) && -1 == this._initData.var_58.indexOf(this._initData.flvURL[this._initData.g_nM3U8Idx]))
               {
                  this._initData.var_58.push(this._initData.flvURL[this._initData.g_nM3U8Idx]);
               }
            }
            catch(err:Error)
            {
            }
            this._initData.g_nM3U8Idx++;
            if(this._initData.g_nM3U8Idx >= this._initData.flvURL.length)
            {
               this._initData.g_nM3U8Idx = 0;
            }
         }
         else if((this._initData.var_65) && (this._initData.var_65.flvURL) && false == this._initData.var_54)
         {
            this._initData.var_65.g_nM3U8Idx++;
            if(this._initData.var_65.g_nM3U8Idx >= this._initData.var_65.flvURL.length)
            {
               this._initData.var_65.g_nM3U8Idx = 0;
            }
         }
         
         if(false == this._initData.var_53)
         {
            this.var_150 = false;
            this.var_154.reset();
            this.method_152();
            this.method_151();
            this.var_153.delay = 1000;
            this.var_153.reset();
            this.var_153.start();
            if(LiveVodConfig.TYPE != LiveVodConfig.LIVE)
            {
               if(false == this._initData.var_53)
               {
                  this._dataManager.method_27();
               }
            }
            return;
         }
         this.var_150 = false;
         this.var_154.reset();
         this.method_152();
         this.method_151();
         this.var_153.delay = 1000;
         this.var_153.reset();
         this.var_153.start();
         if(LiveVodConfig.TYPE != LiveVodConfig.LIVE)
         {
            if(false == this._initData.var_53)
            {
               this._dataManager.method_27();
            }
         }
      }
      
      private function method_182(param1:String) : String
      {
         var _loc2_:String = param1;
         var _loc3_:int = _loc2_.indexOf("&rdm=");
         _loc2_ = _loc2_.substr(0,_loc3_);
         return _loc2_;
      }
      
      private function method_149(param1:TimerEvent = null) : void
      {
         var var_297:Object = null;
         var url:String = null;
         var var_301:URLRequest = null;
         var var_298:TimerEvent = param1;
         if(this._dataManager)
         {
            if(this.var_150 == true)
            {
               return;
            }
            if(false == this._initData.var_53 || false == this._initData.var_54)
            {
               if(false == this._initData.var_53)
               {
                  this._dataManager.method_29();
               }
               var_297 = this._dataManager.method_39();
               if(null == var_297)
               {
                  return;
               }
               this.var_153.delay = var_297.delaytime;
               if(!var_297.url || "" == var_297.url)
               {
                  return;
               }
               if(LiveVodConfig.TYPE == LiveVodConfig.VOD && this._initData.var_53 == true && this._initData.var_54 == true)
               {
                  return;
               }
               url = var_297.url;
               if(LiveVodConfig.TYPE == LiveVodConfig.LIVE)
               {
                  url = ParseUrl.replaceParam(url,"ext","m3u8");
               }
               else
               {
                  if(var_297.kbps)
                  {
                     this.playerKbps = String(var_297.kbps);
                  }
                  if(var_297.flvURL)
                  {
                     this.flvURL = var_297.flvURL;
                  }
                  if(var_297.playLevelArr)
                  {
                     this.playLevelArr = var_297.playLevelArr;
                  }
               }
               try
               {
                  this.method_152();
               }
               catch(error:Error)
               {
                  console.log(this,"close error:" + error);
               }
               this.method_151();
               this.var_149 = false;
               LoadManager.var_289 = url;
               console.log(this,"LiveVodConfig.ADD_DATA_TIME: " + LiveVodConfig.ADD_DATA_TIME + "LiveVodConfig.M3U8_MAXTIME: " + LiveVodConfig.method_267);
               console.log(this," GeneralLiveM3u8_url : " + url);
               var_301 = new URLRequest(url);
               this.var_154.reset();
               this.var_154.start();
               try
               {
                  this.var_150 = true;
                  this.var_152.load(var_301);
               }
               catch(error:Error)
               {
               }
            }
            else
            {
               return;
            }
         }
      }
      
      private function method_151() : void
      {
         if(this.var_152 == null)
         {
            this.var_152 = new URLLoader();
            this.var_152.dataFormat = URLLoaderDataFormat.TEXT;
            if(this._initData.encrypt)
            {
               this.var_152.dataFormat = URLLoaderDataFormat.BINARY;
            }
            this.var_152.addEventListener(Event.COMPLETE,this.method_184);
            this.var_152.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
            this.var_152.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
            this.var_152.addEventListener(ProgressEvent.PROGRESS,this.method_185);
         }
      }
      
      private function method_152() : void
      {
         if(this.var_152 != null)
         {
            try
            {
               this.var_152.close();
            }
            catch(err:Error)
            {
            }
            this.var_152.removeEventListener(Event.COMPLETE,this.method_184);
            this.var_152.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
            this.var_152.removeEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
            this.var_152.removeEventListener(ProgressEvent.PROGRESS,this.method_185);
            this.var_152 = null;
         }
      }
      
      public function method_183(param1:Clip, param2:Number = 0, param3:Array = null, param4:Array = null) : void
      {
         this._dataManager.method_23(param1,param2,param3,param4);
      }
      
      private function method_184(param1:Event) : int
      {
         trace(this,"m3u8 completeHandler_2");
         trace(LiveVodConfig.TYPE);
         this.var_154.reset();
         if(false == new ParseM3U8_uniform().method_203(param1.target.data,this._initData,this.method_183,this.playerKbps,this.flvURL,this.playLevelArr))
         {
            this.method_181();
            return 0;
         }
         if(LiveVodConfig.TYPE == LiveVodConfig.VOD)
         {
            if(false == this._initData.var_53 || true == LiveVodConfig.IS_CHANGE_KBPS)
            {
               this._initData.var_53 = true;
            }
            else if(false == this._initData.var_54)
            {
               this._initData.var_54 = true;
               Statistic.method_261().dispatchPreLoadComplete();
            }
            
         }
         if(LiveVodConfig.TYPE == LiveVodConfig.LIVE)
         {
            LiveVodConfig.IS_SEEKING = false;
         }
         this.var_150 = false;
         this.var_149 = true;
         return 0;
      }
      
      private function securityErrorHandler(param1:SecurityErrorEvent) : void
      {
         console.log(this,"securityErrorHandler" + param1);
         trace(this,"securityErrorHandler");
         this.method_181();
      }
      
      private function ioErrorHandler(param1:IOErrorEvent) : void
      {
         console.log(this,"ioErrorHandler" + param1);
         trace(this,"ioErrorHandler");
         this.method_181();
      }
      
      private function method_185(param1:ProgressEvent = null) : void
      {
         this.var_154.reset();
      }
      
      private function getTime() : Number
      {
         return Math.floor(new Date().time);
      }
      
      private function method_186(param1:Number) : Number
      {
         var _loc2_:Date = new Date(param1 * 1000);
         _loc2_ = new Date(_loc2_.fullYear,_loc2_.month,_loc2_.date,_loc2_.getHours(),_loc2_.getMinutes(),0,0);
         return Math.floor(_loc2_.time / 1000);
      }
   }
}
