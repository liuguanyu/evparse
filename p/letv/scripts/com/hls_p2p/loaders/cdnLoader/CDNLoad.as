package com.hls_p2p.loaders.cdnLoader
{
   import com.hls_p2p.data.vo.class_2;
   import com.hls_p2p.dataManager.DataManager;
   import flash.utils.Timer;
   import com.hls_p2p.data.class_1;
   import flash.utils.ByteArray;
   import com.hls_p2p.loaders.LoadManager;
   import com.hls_p2p.data.Piece;
   import com.hls_p2p.data.vo.LiveVodConfig;
   import com.hls_p2p.statistics.Statistic;
   import flash.events.*;
   import flash.net.*;
   import com.p2p.utils.console;
   import com.p2p.utils.ParseUrl;
   
   public class CDNLoad extends Object implements IStreamLoader
   {
      
      public var isDebug:Boolean = true;
      
      public var var_155:Number = 0;
      
      public var id:int = 0;
      
      protected var _initData:class_2 = null;
      
      protected var var_156:DataManager;
      
      protected var var_157:URLStream;
      
      protected var var_158:Timer;
      
      protected var var_159:class_1 = null;
      
      protected var url:String = "";
      
      protected var var_160:ByteArray;
      
      protected var var_161:LoadManager = null;
      
      protected var var_162:Piece;
      
      protected var var_163:int = 0;
      
      private var var_164:Number = 0;
      
      private var var_165:Boolean = true;
      
      private var var_166:Number = 0;
      
      private var isBuffer:Boolean = false;
      
      protected var var_167:Array;
      
      protected var var_168:Number = -1;
      
      protected var var_169:Number = -1;
      
      protected var var_170:Boolean = false;
      
      public function CDNLoad(param1:DataManager, param2:LoadManager, param3:Boolean = true)
      {
         this.var_160 = new ByteArray();
         super();
         this.var_156 = param1;
         this.var_165 = param3;
         this.var_161 = param2;
         console.log(this,"CDNLoad" + this.id);
         this.method_151();
         if(this.var_158 == null)
         {
            this.var_158 = new Timer(50);
            this.var_158.addEventListener(TimerEvent.TIMER,this.method_157);
         }
      }
      
      protected function method_157(param1:TimerEvent = null) : void
      {
         var _loc2_:Object = null;
         var _loc3_:* = NaN;
         if(LiveVodConfig.cdnDisable == 1 && Statistic.method_261().var_80 == true)
         {
            return;
         }
         if(this.var_159 == null)
         {
            if(this.var_161)
            {
               _loc2_ = this.var_161.method_160(this.var_165);
               if(_loc2_)
               {
                  this.var_159 = _loc2_["block"];
                  this.isBuffer = _loc2_["isBuffer"];
                  _loc2_["block"] = null;
                  delete _loc2_["block"];
                  true;
                  _loc2_["isBuffer"] = null;
                  delete _loc2_["isBuffer"];
                  true;
                  _loc2_ = null;
                  this.method_188();
               }
            }
         }
         else if(this.var_168 > 0 && this.var_159.duration > 0 && this.var_166 > 0 && this.var_167.length > 0)
         {
            _loc3_ = (this.var_167[0] as Piece).duration;
            if(this.getTime() - this.var_166 > _loc3_)
            {
               this._initData.cdnDownloadSlow = true;
            }
            else
            {
               this._initData.cdnDownloadSlow = false;
            }
         }
         
      }
      
      public function start(param1:class_2) : void
      {
         var _initData:class_2 = param1;
         if(!this._initData)
         {
            this._initData = _initData;
         }
         if(this.var_159)
         {
            try
            {
               if(this.var_157.connected)
               {
                  this.var_157.close();
               }
            }
            catch(error:Error)
            {
               console.log(this,"close error:" + error);
            }
            this.method_187();
            this.method_152();
            this.method_151();
         }
         if(this.var_159)
         {
            this.var_163 = 0;
            if(this.var_158)
            {
               this.var_158.reset();
               this.var_158.delay = 200;
               this.var_158.start();
               console.log(this,"time start ");
            }
            console.log(this,"start");
            return;
         }
         this.var_163 = 0;
         if(this.var_158)
         {
            this.var_158.reset();
            this.var_158.delay = 200;
            this.var_158.start();
            console.log(this,"time start ");
         }
         console.log(this,"start");
      }
      
      public function pause() : void
      {
         if((this.var_158) && true == this.var_158.running)
         {
            if(this.var_157.connected)
            {
               try
               {
                  this.var_157.close();
               }
               catch(e:Error)
               {
                  console.log(this,"pause _mediaStream close error");
               }
            }
            this.var_158.reset();
            this.var_158.delay = 200;
         }
      }
      
      public function resume() : void
      {
         if((this.var_158) && false == this.var_158.running)
         {
            this.var_158.reset();
            this.var_158.delay = 200;
            this.var_158.start();
         }
      }
      
      private function method_187() : void
      {
         var _loc2_:Piece = null;
         var _loc3_:* = 0;
         var _loc1_:* = "";
         if((this.var_167) && this.var_167.length > 0)
         {
            _loc3_ = this.var_167.length - 1;
            while(_loc3_ >= 0)
            {
               _loc2_ = this.var_167[_loc3_] as Piece;
               if((_loc2_) && (false == _loc2_.name_1) && 1 == _loc2_.iLoadType)
               {
                  _loc2_.iLoadType = 0;
                  _loc1_ = _loc1_ + (" " + _loc2_.id + " " + _loc2_.pieceKey);
               }
               this.var_167.pop();
               _loc3_--;
            }
         }
         console.log(this,this.id + " set stopDownloadingTask " + this.var_159.id + " " + _loc1_);
         this.var_159 = null;
         this.isBuffer = false;
         this.var_166 = 0;
      }
      
      public function method_188() : void
      {
         var var_301:URLRequest = null;
         var piece:Piece = null;
         var var_303:String = null;
         var i:int = 0;
         if(this.var_159 == null)
         {
            return;
         }
         this.var_155 = 0;
         if(LiveVodConfig.TYPE == LiveVodConfig.LIVE)
         {
            if(this.var_159.url_ts.indexOf("http://") == 0)
            {
               this.url = this.var_159.url_ts;
            }
            else
            {
               this.url = this.getDataURL(this.var_159.groupID,this.var_159.url_ts);
            }
         }
         else if(this.var_159.url_ts.indexOf("http://") == 0)
         {
            this.url = this.method_191(this.var_159.groupID,this.var_159.name,this.var_159.method_1());
         }
         else
         {
            this.url = this.getDataURL(this.var_159.groupID,this.var_159.url_ts);
         }
         
         if(!this.url || this.url == "")
         {
            return;
         }
         this.var_167 = new Array();
         var var_302:String = this.method_193(this.var_167,-1);
         if(var_302 != null)
         {
            this.url = this.url + "&ch=" + LiveVodConfig.CH + "&p1=" + LiveVodConfig.P1 + "&p2=" + LiveVodConfig.P2 + "&p3=" + LiveVodConfig.P3;
            this.url = this.url + "&appid=500";
            this.url = ParseUrl.replaceParam(this.url + var_302,"rd","" + this.getTime());
            var_301 = new URLRequest(this.url);
            console.log(this,this.id + "cdn url:" + this.url);
            LiveVodConfig.USING_TS_URL = this.url;
            try
            {
               this.method_152();
               this.method_151();
               this.var_168 = this.getTime();
               this.var_166 = this.getTime();
               this.var_157.load(var_301);
               piece = null;
               var_303 = "";
               i = 0;
               while(i < this.var_159.var_6.length)
               {
                  piece = this.var_156.method_5(this.var_159.var_6[i]);
                  if((piece) && piece.name_1 == false)
                  {
                     this.var_156.method_28(this.var_159.id,piece.id);
                     break;
                  }
                  i++;
               }
            }
            catch(error:Error)
            {
               console.log(this,"Unable to load requested document.");
               method_187();
            }
         }
         else
         {
            console.log(this,this.id + "range = null" + this.var_159.id + " " + this.var_159.name);
            this.method_181(false);
         }
      }
      
      protected function getTime() : Number
      {
         return Math.floor(new Date().time);
      }
      
      protected function method_189(param1:String) : String
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc2_:String = this._initData.flvURL[this._initData.g_nM3U8Idx];
         var _loc3_:int = _loc2_.indexOf("?");
         if(_loc3_ != -1)
         {
            _loc4_ = _loc2_.substr(_loc3_ + 1,_loc2_.length);
            _loc5_ = _loc2_.substring(0,_loc2_.indexOf("/",7));
            if((_loc4_) && (_loc5_))
            {
               var param1:String = param1.replace(param1.substring(0,param1.indexOf("/",7)),_loc5_);
               param1 = param1.replace(param1.substring(param1.indexOf("?") + 1,param1.length),_loc4_);
            }
         }
         return param1;
      }
      
      protected function method_190(param1:String) : Array
      {
         if(LiveVodConfig.TYPE != LiveVodConfig.LIVE)
         {
            if(param1 == LiveVodConfig.currentVid)
            {
               return this._initData.flvURL;
            }
            return this._initData.method_68;
         }
         return this._initData.flvURL;
      }
      
      protected function method_191(param1:String, param2:String, param3:Array) : String
      {
         var _loc4_:* = "";
         if(param3)
         {
            _loc4_ = param3[this._initData.g_nM3U8Idx];
            if(_loc4_)
            {
               return _loc4_.replace(".m3u8?","_mp4/" + param2 + "?");
            }
         }
         return null;
      }
      
      protected function method_192(param1:String, param2:String) : String
      {
         var _loc3_:* = "";
         var _loc4_:Array = this.method_190(param1);
         if(_loc4_)
         {
            _loc3_ = _loc4_[this._initData.g_nM3U8Idx];
            if(_loc3_)
            {
               return _loc3_.replace(".m3u8?","_mp4/" + param2 + "?");
            }
         }
         return null;
      }
      
      protected function getDataURL(param1:String, param2:String) : String
      {
         var _loc3_:* = 0;
         var _loc6_:Object = null;
         var _loc4_:* = "";
         var _loc5_:Array = this.method_190(param1);
         if(!_loc5_)
         {
            return null;
         }
         console.log(this,"getDataURL",typeof _loc5_[this._initData.g_nM3U8Idx],this._initData.g_nM3U8Idx);
         console.log(this,"getDataURL",_loc5_);
         console.log(this,"getDataURL",_loc5_[this._initData.g_nM3U8Idx]);
         if((_loc5_[this._initData.g_nM3U8Idx]) && (typeof _loc5_[this._initData.g_nM3U8Idx] == "xml" || typeof _loc5_[this._initData.g_nM3U8Idx] == "string"))
         {
            _loc6_ = ParseUrl.parseUrl(_loc5_[this._initData.g_nM3U8Idx]);
            if(param2.indexOf("/") == 0)
            {
               return _loc6_.protocol + _loc6_.hostName + param2;
            }
            _loc3_ = String(_loc6_.path).lastIndexOf("/");
            _loc4_ = _loc6_.protocol + _loc6_.hostName + String(_loc6_.path).substr(0,_loc3_ + 1);
         }
         return _loc4_ + param2;
      }
      
      protected function method_193(param1:Array, param2:int = -1) : String
      {
         this.var_168 = -1;
         this.var_169 = -1;
         this.var_166 = 0;
         var _loc3_:Number = -1;
         var _loc4_:Number = -1;
         var _loc5_:Piece = null;
         var _loc6_:* = "";
         var _loc7_:* = 0;
         while(_loc7_ < this.var_159.var_6.length)
         {
            _loc5_ = this.var_156.method_5(this.var_159.var_6[_loc7_]);
            if((_loc5_) && (_loc5_.name_1 == false && _loc5_.var_26 <= 3) && (!(_loc5_.iLoadType == 1) && true == this.isBuffer || LiveVodConfig.TYPE == LiveVodConfig.LIVE && _loc5_.var_25 == true))
            {
               _loc5_.iLoadType = 1;
               if(_loc3_ == -1)
               {
                  _loc3_ = this.method_194(this.var_159,_loc7_);
                  _loc6_ = _loc6_ + (" start:" + _loc7_);
               }
               _loc4_ = this.method_195(this.var_159,_loc7_);
               param1.push(_loc5_);
               if(_loc7_ == this.var_159.var_6.length - 1)
               {
                  _loc6_ = _loc6_ + ("-end:" + _loc7_);
                  console.log(this,"-id:" + this.id + _loc6_ + " Taskid: " + this.var_159.id);
                  if(_loc3_ == 0)
                  {
                     return "";
                  }
                  if(this.url.indexOf("?") > 0)
                  {
                     return String("&rstart=" + _loc3_ + "&rend=" + _loc4_);
                  }
                  return String("?rstart=" + _loc3_ + "&rend=" + _loc4_);
               }
            }
            else if(!(_loc3_ == -1) && !(_loc4_ == -1))
            {
               _loc6_ = _loc6_ + ("-end:" + (_loc7_ - 1));
               console.log(this,"*id:" + this.id + _loc6_ + " Taskid: " + this.var_159.id);
               if(this.url.indexOf("?") > 0)
               {
                  return String("&rstart=" + _loc3_ + "&rend=" + _loc4_);
               }
               return String("?rstart=" + _loc3_ + "&rend=" + _loc4_);
            }
            
            _loc7_++;
         }
         console.log(this,this.id + " range is null pieceId:" + param2 + this.var_159.name_1,this.var_159);
         var _loc8_:* = 0;
         while(_loc8_ < this.var_159.var_6.length)
         {
            _loc5_ = this.var_156.method_5(this.var_159.var_6[_loc8_]);
            console.log(this,_loc8_ + "piece:",_loc5_);
            _loc8_++;
         }
         return null;
      }
      
      private function method_194(param1:class_1, param2:Number) : Number
      {
         var _loc3_:Number = 0;
         var _loc4_:* = 0;
         while(_loc4_ < param2)
         {
            _loc3_ = _loc3_ + this.var_156.method_5(param1.var_6[_loc4_]).size;
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function method_195(param1:class_1, param2:Number) : Number
      {
         var _loc3_:Number = 0;
         var _loc4_:* = 0;
         while(_loc4_ <= param2)
         {
            _loc3_ = _loc3_ + this.var_156.method_5(param1.var_6[_loc4_]).size;
            _loc4_++;
         }
         _loc3_--;
         return _loc3_;
      }
      
      protected function method_151() : void
      {
         if(this.var_157 == null)
         {
            this.var_157 = new URLStream();
            this.var_157.addEventListener(ProgressEvent.PROGRESS,this.method_185);
            this.var_157.addEventListener(Event.COMPLETE,this.method_150);
            this.var_157.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
            this.var_157.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
         }
      }
      
      protected function method_152() : void
      {
         if(this.var_157 != null)
         {
            try
            {
               this.var_157.close();
            }
            catch(err:Error)
            {
            }
            this.var_157.removeEventListener(Event.COMPLETE,this.method_150);
            this.var_157.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
            this.var_157.removeEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
            this.var_157.removeEventListener(ProgressEvent.PROGRESS,this.method_185);
            this.var_157 = null;
         }
      }
      
      protected function method_181(param1:Boolean = true) : void
      {
         var _loc2_:Piece = null;
         var _loc3_:* = 0;
         if((this.var_159) && (this.var_159.var_6) && (this.var_156))
         {
            _loc2_ = null;
            _loc3_ = 0;
            while(_loc3_ < this.var_159.var_6.length)
            {
               _loc2_ = this.var_156.method_5(this.var_159.var_6[_loc3_]);
               if((_loc2_) && _loc2_.name_1 == false)
               {
                  this.var_156.method_26(this.var_159.id,_loc2_.id);
                  break;
               }
               _loc3_++;
            }
            console.log(this,"CDN downloadError " + this.var_159.id + ", " + String(this.var_159.groupID).substr(0,5));
         }
         this.method_152();
         this.var_170 = false;
         while(this.var_167.length > 0)
         {
            this.var_167[0].iLoadType = 0;
            this.var_167.shift();
         }
         this.var_155 = 0;
         if(this.var_160)
         {
            this.var_160.clear();
         }
         if((param1) && LiveVodConfig.BlockID > 0 && LiveVodConfig.BlockID == this.var_159.id)
         {
            if(LiveVodConfig.TYPE == LiveVodConfig.LIVE || LiveVodConfig.TYPE == LiveVodConfig.VOD && LiveVodConfig.currentVid == this.var_159.groupID)
            {
               LiveVodConfig.USING_ERROR_TS_URL = this.url;
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
            }
            if(LiveVodConfig.TYPE == LiveVodConfig.LIVE || LiveVodConfig.TYPE == LiveVodConfig.VOD && LiveVodConfig.currentVid == this.var_159.groupID)
            {
            }
         }
         this._initData.g_nM3U8Idx++;
         if(this._initData.g_nM3U8Idx >= this._initData.flvURL.length)
         {
            this._initData.g_nM3U8Idx = 0;
         }
         if(this.var_159)
         {
            this.method_187();
         }
         this.var_166 = 0;
         this.method_151();
      }
      
      protected function method_196(param1:Boolean = false) : void
      {
         var var_304:Boolean = param1;
         this.var_169 = this.getTime();
         var var_305:Number = 0;
         var var_306:int = this.var_167.length;
         var var_307:Number = Math.round((this.var_169 - this.var_168) / var_306);
         try
         {
            while((this.var_167.length > 0 && this.var_167[0]) && (this.var_157) && this.var_157.bytesAvailable >= this.var_167[0].size)
            {
               this.var_170 = true;
               this.var_160.clear();
               var_305 = this.var_167[0].size;
               this.var_155 = this.var_155 + var_305;
               this.var_157.readBytes(this.var_160,0,var_305);
               this.var_162 = this.var_167[0];
               if((this.var_162) && (this.var_162.name_1 == false) && !(this.var_162.iLoadType == 3))
               {
                  this.var_162.from = "http";
                  this.var_162.var_23 = this.var_168 + this.var_163 * var_307;
                  this.var_162.end = this.var_162.var_23 + var_307;
                  this.var_162.method_48(this.var_160);
                  this.var_163++;
                  this.method_197(this.var_162);
                  console.log(this,"http load = " + this.var_162.blockIDArray + ", " + this.var_162.id);
               }
               this.var_167.shift();
               this.var_166 = this.getTime();
            }
            this.var_170 = false;
            if(var_304)
            {
               if((this.var_167[0]) && (this.var_157.bytesAvailable > 0) && this.var_157.bytesAvailable <= this.var_167[0].size)
               {
                  this.var_160.clear();
                  this.var_157.readBytes(this.var_160);
                  var_305 = this.var_167[0].size;
                  this.var_155 = this.var_155 + this.var_160.length;
                  this.var_162 = this.var_167[0];
                  if((this.var_162) && (this.var_162.name_1 == false) && !(this.var_162.iLoadType == 3))
                  {
                     this.var_162.from = "http";
                     this.var_162.var_23 = this.var_168 + this.var_163 * var_307;
                     this.var_162.end = this.var_162.var_23 + var_307;
                     this.var_162.method_48(this.var_160);
                     this.method_197(this.var_162);
                     console.log(this,"http load = " + this.var_162.blockIDArray + ", " + this.var_162.id);
                  }
                  this.var_167.shift();
                  this.var_166 = this.getTime();
               }
            }
         }
         catch(err:Error)
         {
            if(var_159)
            {
               console.log(this,"bID:" + this.var_159.id);
            }
            console.log(this,this.id + "http解析数据错误" + err.getStackTrace());
            method_181();
         }
      }
      
      protected function method_185(param1:ProgressEvent = null) : void
      {
         this.var_164 = param1.bytesLoaded;
         if(!this.var_170)
         {
            this.method_196();
         }
      }
      
      protected function securityErrorHandler(param1:SecurityErrorEvent) : void
      {
         console.log(this,this.id + "securityErrorHandler: " + param1);
         console.log(this,this.url);
         this.method_181();
      }
      
      protected function ioErrorHandler(param1:IOErrorEvent) : void
      {
         console.log(this,this.id + "ioErrorHandler: " + param1);
         console.log(this,this.url);
         this.method_181();
      }
      
      protected function method_150(param1:Event) : void
      {
         this.method_196(true);
         if(this.var_159)
         {
            console.log(this,this.id + " completeHandler Taskid: " + this.var_159.id + " name:" + this.var_159.name + " isCheck:" + this.var_159.name_1);
            this.method_187();
         }
         this.var_167 = null;
      }
      
      private function method_197(param1:Piece) : void
      {
         if((param1.end - param1.var_23) / 1000 <= param1.duration)
         {
            if(param1.id != 0)
            {
               this._initData.cdnDownloadSlow = true;
            }
         }
         else
         {
            this._initData.cdnDownloadSlow = false;
         }
      }
      
      public function clear() : void
      {
         this.var_158.stop();
         this.var_158 = null;
         this.method_152();
         this._initData = null;
         this.var_156 = null;
         this.var_159 = null;
         this.var_167 = null;
         this.var_160 = null;
         this.var_165 = true;
         this.isBuffer = false;
      }
   }
}
