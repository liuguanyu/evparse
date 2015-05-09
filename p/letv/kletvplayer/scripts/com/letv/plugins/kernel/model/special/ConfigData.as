package com.letv.plugins.kernel.model.special
{
   import com.alex.utils.BrowserUtil;
   import com.letv.plugins.kernel.Kernel;
   
   public class ConfigData extends Object
   {
      
      private static var _instance:ConfigData;
      
      private var _pccs:XML;
      
      private var _flashvars:FlashVars;
      
      private var _version:String;
      
      private var _debugStatistics:Boolean;
      
      private var _typeFrom:String;
      
      private var _controlbarheight:Number = 0;
      
      private var _autoHide:Boolean = true;
      
      private var _dataMode:Boolean = true;
      
      private var _p2p:Boolean = true;
      
      private var _record:Boolean = true;
      
      private const _SHARESWFURL:String = "http://i7.imgs.letv.com/player/swfPlayer.swf?autoPlay=0";
      
      private var _heartbeatTime:Number = 180000;
      
      private var _adHearbeatTime:Number = 5000;
      
      private var _tag:String = "letv";
      
      private var _bufferTimeout:int = 30;
      
      private var _continuration:Boolean = true;
      
      private var _jump:Boolean = true;
      
      private var _forvip:Boolean = false;
      
      private var _p2ptestInterval:uint = 60;
      
      private var _p2ptestBuffer:int = 70;
      
      private var _p2pflvurl:String;
      
      private var _p2pm3u8url:String;
      
      private var _autoReplay:Boolean;
      
      private var _cc:Boolean = true;
      
      private var _cut:Boolean = false;
      
      private var _rate:String;
      
      private var _scale:Number = 0;
      
      public function ConfigData()
      {
         super();
      }
      
      public static function getInstance() : ConfigData
      {
         if(_instance == null)
         {
            _instance = new ConfigData();
         }
         return _instance;
      }
      
      public function flush(param1:Object, param2:Object = null) : void
      {
         var xml:XML = null;
         var flashvarsObj:Object = null;
         var var_1:Object = param1;
         var var_2:Object = param2;
         try
         {
            xml = XML(var_1);
            this._pccs = xml;
         }
         catch(e:Error)
         {
         }
         try
         {
            this._flashvars = new FlashVars(var_2);
         }
         catch(e:Error)
         {
         }
         try
         {
            this._version = this.pccs.version[0];
         }
         catch(e:Error)
         {
            _version = null;
         }
         try
         {
            this._heartbeatTime = Number(this.pccs.kernel.playAction) * 1000;
         }
         catch(e:Error)
         {
         }
         try
         {
            this._adHearbeatTime = Number(this.pccs.ad[0].adAction) * 1000;
         }
         catch(e:Error)
         {
         }
         if(this._adHearbeatTime < 1000)
         {
            this._adHearbeatTime = 5000;
         }
         if(this._heartbeatTime < 1000)
         {
            this._heartbeatTime = 3 * 60 * 1000;
         }
         try
         {
            this._controlbarheight = this.pccs.controlbarheight[0];
            if((isNaN(this._controlbarheight)) || this._controlbarheight < 0)
            {
               this._controlbarheight = 0;
            }
         }
         catch(e:Error)
         {
            _controlbarheight = 0;
         }
         try
         {
            this._debugStatistics = String(this.pccs.init[0].closeDebug[0]) == "1"?false:true;
         }
         catch(e:Error)
         {
            _debugStatistics = true;
         }
         try
         {
            this._typeFrom = String(this.pccs.init[0].typefrom[0]);
         }
         catch(e:Error)
         {
            _typeFrom = "letv";
         }
         try
         {
            this._tag = String(this.pccs.init[0].tag[0]);
         }
         catch(e:Error)
         {
            _tag = "letv";
         }
         try
         {
            if(this.pccs.kernel[0].hasOwnProperty("bufferTimeout"))
            {
               this._bufferTimeout = int(this.pccs.kernel[0].bufferTimeout[0]);
            }
            else
            {
               this._bufferTimeout = 30;
            }
         }
         catch(e:Error)
         {
            _bufferTimeout = 30;
         }
         try
         {
            this._autoHide = String(this.pccs.skin[0].controlBar[0].autoHide[0]) == "1"?true:false;
         }
         catch(e:Error)
         {
            _autoHide = false;
         }
         try
         {
            this._dataMode = String(this.pccs.kernel[0].dataMode[0]) == "0"?false:true;
         }
         catch(e:Error)
         {
            _dataMode = true;
         }
         try
         {
            this._p2p = String(this.pccs.kernel[0].p2p[0]) == "0"?false:true;
         }
         catch(e:Error)
         {
            _p2p = true;
         }
         try
         {
            this._record = String(this.pccs.kernel[0].record[0]) == "0"?false:true;
         }
         catch(e:Error)
         {
            _record = true;
         }
         try
         {
            this._continuration = String(this.pccs.kernel[0].continuration[0]) == "0"?false:true;
         }
         catch(e:Error)
         {
            _continuration = true;
         }
         try
         {
            this._jump = String(this.pccs.kernel[0].jump[0]) == "0"?false:true;
         }
         catch(e:Error)
         {
            _jump = true;
         }
         try
         {
            this._forvip = String(this.pccs.kernel[0].forvip[0]) == "1"?true:false;
         }
         catch(e:Error)
         {
            _forvip = false;
         }
         try
         {
            this._p2ptestInterval = Number(this.pccs.kernel[0].p2ptestInterval[0]);
            if((isNaN(this._p2ptestInterval)) || this._p2ptestInterval <= 0)
            {
               this._p2ptestInterval = 60;
            }
         }
         catch(e:Error)
         {
            _p2ptestInterval = 60;
         }
         try
         {
            this._p2ptestBuffer = Number(this.pccs.kernel[0].p2ptestBuffer[0]);
            if((isNaN(this._p2ptestBuffer)) || this._p2ptestBuffer <= 0)
            {
               this._p2ptestBuffer = 70;
            }
         }
         catch(e:Error)
         {
            _p2ptestBuffer = 70;
         }
         try
         {
            this._p2pflvurl = String(this.pccs.p2p[0].flv[0].url[0]);
         }
         catch(e:Error)
         {
            _p2pflvurl = null;
         }
         try
         {
            this._p2pm3u8url = String(this.pccs.p2p[0].m3u8[0].url[0]);
         }
         catch(e:Error)
         {
            _p2pm3u8url = null;
         }
         try
         {
            this._cut = String(this.pccs.init[0].cut[0]) == "1"?true:false;
         }
         catch(e:Error)
         {
         }
         if(this.flashvars.typeFrom != null)
         {
            this._typeFrom = this.flashvars.typeFrom;
         }
         var url:String = BrowserUtil.url;
         if(url != null)
         {
            this._cc = url.indexOf("cc=0") != -1?false:true;
            this._p2p = url.indexOf("p2p=0") != -1?false:true;
            this._dataMode = url.indexOf("dm=0") != -1?false:true;
         }
         try
         {
            flashvarsObj = this.flashvars.flashvars;
            if((flashvarsObj.hasOwnProperty("continuration")) && !(flashvarsObj["continuration"] == ""))
            {
               this._continuration = String(flashvarsObj["continuration"]) == "0"?false:true;
            }
            if((flashvarsObj.hasOwnProperty("autoReplay")) && !(flashvarsObj["autoReplay"] == ""))
            {
               this._autoReplay = String(flashvarsObj["autoReplay"]) == "1"?true:false;
            }
            if((flashvarsObj.hasOwnProperty("rate")) && !(flashvarsObj["rate"] == ""))
            {
               this._rate = "" + flashvarsObj["rate"];
            }
            else
            {
               this._rate = null;
            }
            if((flashvarsObj.hasOwnProperty("p2p")) && !(flashvarsObj["p2p"] == ""))
            {
               this._p2p = String(flashvarsObj["p2p"]) == "0"?false:true;
            }
            if(flashvarsObj.hasOwnProperty("scale"))
            {
               this._scale = (Number(flashvarsObj["scale"])) || (0);
               if(this._scale < 0)
               {
                  this._scale = 0;
               }
            }
            else
            {
               this._scale = 0;
            }
            if(flashvarsObj.hasOwnProperty("cut"))
            {
               this._cut = String(flashvarsObj["cut"]) == "1"?true:false;
            }
            if(flashvarsObj.hasOwnProperty("record"))
            {
               this._record = String(flashvarsObj["record"]) == "0"?false:true;
            }
         }
         catch(e:Error)
         {
         }
         Kernel.sendLog("KernelP2PPlugins: " + this._p2pflvurl + "\n" + this._p2pm3u8url);
      }
      
      public function get pccs() : XML
      {
         return this._pccs;
      }
      
      public function get flashvars() : FlashVars
      {
         return this._flashvars;
      }
      
      public function get version() : String
      {
         return this._version;
      }
      
      public function get tag() : String
      {
         return this._tag;
      }
      
      public function get debugStatistics() : Boolean
      {
         return this._debugStatistics;
      }
      
      public function get typeFrom() : String
      {
         return this._typeFrom;
      }
      
      public function get controlbarheight() : Number
      {
         return this._controlbarheight;
      }
      
      public function get autoHide() : Boolean
      {
         return this._autoHide;
      }
      
      public function get dataMode() : Boolean
      {
         return this._dataMode;
      }
      
      public function get p2p() : Boolean
      {
         return this._p2p;
      }
      
      public function get record() : Boolean
      {
         return this._record;
      }
      
      public function get bufferTimeout() : int
      {
         return this._bufferTimeout * 1000;
      }
      
      public function get shareSwfUrl() : String
      {
         return this._SHARESWFURL;
      }
      
      public function get hearbeatTime() : int
      {
         return this._heartbeatTime;
      }
      
      public function get adHearbeatTime() : Number
      {
         return this._adHearbeatTime;
      }
      
      public function get continuration() : Boolean
      {
         return this._continuration;
      }
      
      public function get jump() : Boolean
      {
         return this._jump;
      }
      
      public function get forvip() : Boolean
      {
         return this._forvip;
      }
      
      public function get p2ptestInterval() : uint
      {
         return this._p2ptestInterval;
      }
      
      public function get p2ptestBuffer() : uint
      {
         return this._p2ptestBuffer;
      }
      
      public function get p2pflvurl() : String
      {
         return this._p2pflvurl;
      }
      
      public function get p2pm3u8url() : String
      {
         return this._p2pm3u8url;
      }
      
      public function get autoReplay() : Boolean
      {
         return this._autoReplay;
      }
      
      public function get cc() : Boolean
      {
         return this._cc;
      }
      
      public function get rate() : String
      {
         return this._rate;
      }
      
      public function set rate(param1:String) : void
      {
         this._rate = param1;
      }
      
      public function get scale() : Number
      {
         return this._scale;
      }
      
      public function get cut() : Boolean
      {
         return this._cut;
      }
   }
}
