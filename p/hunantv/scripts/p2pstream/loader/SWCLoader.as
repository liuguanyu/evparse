package p2pstream.loader
{
   import flash.events.EventDispatcher;
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   import com.adobe.net.URI;
   import flash.system.Security;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.events.Event;
   import flash.events.ProgressEvent;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import deng.fzip.FZip;
   import deng.fzip.FZipErrorEvent;
   import deng.fzip.FZipFile;
   import flash.display.Loader;
   import flash.system.LoaderContext;
   import flash.system.ApplicationDomain;
   import flash.net.URLRequestMethod;
   import flash.net.sendToURL;
   import p2pstream.mango.SSNetStream;
   import flash.system.Capabilities;
   
   public class SWCLoader extends EventDispatcher
   {
      
      public static const COMPLETE:String = "swcLoadComplete";
      
      public static const ERROR:String = "swcLoadError";
      
      public static const STATUS_SUCCESS:int = 0;
      
      public static const STATUS_TIMEOUT:int = -1;
      
      public static const STATUS_URL_ERROR:int = -2;
      
      public static const STATUS_SWC_ERROR:int = -3;
      
      public static const STATUS_SWF_ERROR:int = -4;
      
      public static const STATUS_VER_ERROR:int = -5;
      
      private static var CHANNEL:String = "2f247330e7de34ef281f9caff5d7060f";
      
      private static var _LoggerURL:String = "http://slt.imgo.ss3w.com/log.html";
      
      private static var _SwfURL:String = "http://swf.imgo.ss3w.com/2f247330e7de34ef281f9caff5d7060f/ss.swf";
      
      private var i:uint = 0;
      
      private var j:uint = 0;
      
      private var S:ByteArray = null;
      
      private var _isSWC:Boolean = false;
      
      private var _startTime:Number = 0;
      
      private var _timeout:Number = 0;
      
      private var _urlTimer:Timer = null;
      
      private var _urlLoader:URLLoader = null;
      
      private var _data:ByteArray = null;
      
      private var _swcErrors:int = 0;
      
      private var _swfErrors:int = 0;
      
      private var _rawSWC:FZip = null;
      
      private var _loader:Loader = null;
      
      public function SWCLoader()
      {
         super();
      }
      
      public function load(param1:String = null, param2:Number = 6000) : void
      {
         if(param1 == null)
         {
            var param1:String = _SwfURL;
         }
         if(!this.checkVersion())
         {
            this.notifyStatus(STATUS_VER_ERROR);
            return;
         }
         var _loc3_:RegExp = new RegExp("\\.(swf$|swf\\?)","i");
         this._isSWC = _loc3_.exec(param1) == null;
         if(param2 != 0)
         {
            this._urlTimer = new Timer(param2,1);
            this._urlTimer.addEventListener(TimerEvent.TIMER,this.onURLTimeout);
            this._urlTimer.start();
         }
         this._timeout = param2;
         this._startTime = new Date().time;
         var _loc4_:URI = new URI(param1);
         var _loc5_:String = _loc4_.authority;
         var _loc6_:int = Number(_loc4_.port);
         if(!_loc6_)
         {
            _loc6_ = 80;
         }
         Security.loadPolicyFile("http://" + _loc5_ + ":" + _loc6_ + "/crossdomain.xml");
         this._urlLoader = new URLLoader();
         this._urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
         this._urlLoader.addEventListener(Event.COMPLETE,this.onURLLoaded);
         this._urlLoader.addEventListener(ProgressEvent.PROGRESS,this.onURLProgress);
         this._urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onURLError);
         this._urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onURLError);
         try
         {
            this._urlLoader.load(new URLRequest(param1));
         }
         catch(e:Error)
         {
         }
      }
      
      private function onURLProgress(param1:Event) : void
      {
         if(this._urlTimer != null)
         {
            this._urlTimer.reset();
            this._urlTimer.start();
         }
      }
      
      private function onURLTimeout(param1:Event) : void
      {
         if(this._urlTimer != null)
         {
            this._urlTimer.stop();
            this._urlTimer.removeEventListener(TimerEvent.TIMER,this.onURLTimeout);
            this._urlTimer = null;
         }
         this.notifyStatus(STATUS_TIMEOUT);
      }
      
      private function onURLError(param1:Event) : void
      {
         if(this._urlTimer != null)
         {
            this._urlTimer.stop();
            this._urlTimer.removeEventListener(TimerEvent.TIMER,this.onURLTimeout);
            this._urlTimer = null;
         }
         this.notifyStatus(STATUS_URL_ERROR);
      }
      
      private function onURLLoaded(param1:Event) : void
      {
         if(this._urlTimer != null)
         {
            this._urlTimer.stop();
            this._urlTimer.removeEventListener(TimerEvent.TIMER,this.onURLTimeout);
            this._urlTimer = null;
         }
         if(this._urlLoader.bytesLoaded > 0 && this._urlLoader.bytesLoaded == this._urlLoader.bytesTotal)
         {
            this._data = this._urlLoader.data as ByteArray;
            if(this._isSWC)
            {
               this.loadSWC();
            }
            else
            {
               this.loadSWF();
            }
         }
         else
         {
            this.notifyStatus(STATUS_URL_ERROR);
         }
      }
      
      private function loadSWC() : void
      {
         this._rawSWC = new FZip();
         this._rawSWC.addEventListener(Event.COMPLETE,this.onSWCLoaded);
         this._rawSWC.addEventListener(FZipErrorEvent.PARSE_ERROR,this.onSWCError);
         try
         {
            this._rawSWC.loadBytes(this._data);
         }
         catch(e:Error)
         {
            onSWCError(null);
         }
      }
      
      private function onSWCError(param1:Event) : void
      {
         this._rawSWC.removeEventListener(Event.COMPLETE,this.onSWCLoaded);
         this._rawSWC.removeEventListener(FZipErrorEvent.PARSE_ERROR,this.onSWCError);
         if(++this._swcErrors == 1 && (this.decipher()))
         {
            this.loadSWC();
         }
         else
         {
            this.notifyStatus(STATUS_SWC_ERROR);
         }
      }
      
      private function onSWCLoaded(param1:Event) : void
      {
         var codeSWF:FZipFile = null;
         var e:Event = param1;
         this._rawSWC.removeEventListener(Event.COMPLETE,this.onSWCLoaded);
         this._rawSWC.removeEventListener(FZipErrorEvent.PARSE_ERROR,this.onSWCError);
         try
         {
            this._data = null;
            codeSWF = this._rawSWC.getFileByName("library.swf");
            this._data = codeSWF.content;
         }
         catch(e:Error)
         {
            notifyStatus(STATUS_SWC_ERROR);
         }
         if(this._data != null)
         {
            this.loadSWF();
         }
         else
         {
            this.notifyStatus(STATUS_SWC_ERROR);
         }
      }
      
      private function loadSWF() : void
      {
         this._loader = new Loader();
         this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onSWFLoaded);
         this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onSWFError);
         var _loc1_:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
         this._loader.loadBytes(this._data,_loc1_);
      }
      
      private function onSWFError(param1:Event) : void
      {
         this._loader.removeEventListener(Event.COMPLETE,this.onSWFLoaded);
         this._loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onSWFError);
         if(++this._swfErrors == 1 && (this.decipher()))
         {
            this.loadSWF();
         }
         else
         {
            this.notifyStatus(STATUS_SWF_ERROR);
         }
      }
      
      private function onSWFLoaded(param1:Event) : void
      {
         this._loader.removeEventListener(Event.COMPLETE,this.onSWFLoaded);
         this._loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onSWFError);
         this.notifyStatus(STATUS_SUCCESS);
      }
      
      private function notifyStatus(param1:int) : void
      {
         var _loc2_:Number = new Date().time;
         var _loc3_:Number = param1 == STATUS_SUCCESS?_loc2_ - this._startTime:param1;
         var _loc4_:uint = Math.random() * uint(4.294967295E9);
         var _loc5_:uint = uint(uint(_loc4_ ^ uint(_loc2_ / 1000)) * 1725243750) ^ 883767687;
         var _loc6_:Object = {
            "version":0,
            "StartTime":this._startTime,
            "EndTime":_loc2_,
            "ID":_loc4_,
            "MAC":_loc5_,
            "reportId":0,
            "swcLoadTime":_loc3_,
            "Channel":CHANNEL
         };
         var _loc7_:Object = this.getFormatV0();
         var _loc8_:String = this.encodeReportObject(_loc6_,_loc7_);
         trace(_loc8_);
         var _loc9_:* = _LoggerURL + "?v=" + uint(Math.random() * 4.294967296E9) + "&c=mango";
         var _loc10_:URLRequest = new URLRequest(_loc9_);
         _loc10_.method = URLRequestMethod.POST;
         _loc10_.data = _loc8_;
         try
         {
            sendToURL(_loc10_);
         }
         catch(e:Error)
         {
         }
         if(param1 == STATUS_SUCCESS)
         {
            dispatchEvent(new Event(SWCLoader.COMPLETE));
         }
         else
         {
            SSNetStream.swcLoaded = false;
            dispatchEvent(new Event(SWCLoader.ERROR));
         }
      }
      
      private function decipher() : Boolean
      {
         var _loc1_:* = "4e30d" + "0314e4" + "9552a3" + "0fb70" + "06c7" + "d48d70";
         var _loc2_:int = parseInt("1393") + parseInt("1607") + parseInt("72");
         if(this._data.length < 4)
         {
            return false;
         }
         var _loc3_:uint = this._data[0] << 24 | this._data[1] << 16 | this._data[2] << 8 | this._data[3];
         if(this._data.length < 4 + _loc3_)
         {
            return false;
         }
         var _loc4_:ByteArray = new ByteArray();
         _loc4_.length = _loc3_ + _loc1_.length;
         var _loc5_:* = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_[_loc5_] = this._data[4 + _loc5_];
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < _loc1_.length)
         {
            _loc4_[_loc3_ + _loc5_] = _loc1_.charCodeAt(_loc5_);
            _loc5_++;
         }
         var _loc6_:ByteArray = new ByteArray();
         this._data.position = 4 + _loc3_;
         this._data.readBytes(_loc6_);
         this.ksa(_loc4_);
         this.i = 0;
         this.j = 0;
         var _loc7_:int = this.prga(_loc2_);
         _loc5_ = 0;
         while(_loc5_ < _loc6_.length)
         {
            _loc6_[_loc5_] = uint(_loc6_[_loc5_] ^ _loc7_);
            _loc7_ = this.prga(uint(_loc7_ & 31) + 1);
            _loc5_++;
         }
         this._data = _loc6_;
         return true;
      }
      
      private function ksa(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         this.S = new ByteArray();
         this.i = 0;
         while(this.i < 256)
         {
            this.S[this.i] = this.i;
            this.i++;
         }
         _loc2_ = param1.length;
         this.i = 0;
         this.j = 0;
         while(this.i < 256)
         {
            this.j = this.j + this.S[this.i] + param1[this.i % _loc2_] & 255;
            this.swap(this.i,this.j);
            this.i++;
         }
      }
      
      private function prga(param1:int) : int
      {
         var _loc2_:uint = 0;
         _loc2_ = 0;
         while(_loc2_ < param1)
         {
            this.i = this.i + 1 & 255;
            this.j = this.j + this.S[this.i] & 255;
            this.swap(this.i,this.j);
            _loc2_++;
         }
         return this.S[this.S[this.i] + this.S[this.j] & 255];
      }
      
      private function swap(param1:int, param2:int) : void
      {
         var _loc3_:uint = this.S[param1];
         this.S[param1] = this.S[param2];
         this.S[param2] = _loc3_;
      }
      
      private function checkVersion() : Boolean
      {
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc1_:String = Capabilities.version.split(" ")[1];
         var _loc2_:Array = _loc1_.split(",");
         if(_loc2_.length >= 2)
         {
            _loc3_ = int(_loc2_[0]);
            _loc4_ = int(_loc2_[1]);
            if(_loc3_ > 10 || _loc3_ == 10 && _loc4_ >= 1)
            {
               return true;
            }
         }
         return false;
      }
      
      private function getFormatV0() : Object
      {
         var _loc1_:Object = {
            "version":0,
            "StartTime":1,
            "EndTime":2,
            "ID":3,
            "MAC":4,
            "reportId":5,
            "swcLoadTime":6,
            "Channel":7
         };
         return _loc1_;
      }
      
      private function encodeReportObject(param1:Object, param2:Object) : String
      {
         var _loc4_:String = null;
         var _loc5_:* = 0;
         var _loc6_:ByteArray = null;
         var _loc7_:Array = null;
         var _loc8_:* = 0;
         var _loc3_:Array = new Array();
         for(_loc3_[param2[_loc4_]] in param2)
         {
         }
         _loc5_ = _loc3_.length;
         _loc6_ = new ByteArray();
         _loc6_.length = Math.ceil(_loc5_ / 8);
         _loc7_ = new Array();
         _loc8_ = 0;
         while(_loc8_ < _loc5_)
         {
            if(param1.hasOwnProperty(_loc3_[_loc8_]))
            {
               _loc6_[uint(_loc8_ / 8)] = _loc6_[uint(_loc8_ / 8)] | 1 << _loc8_ % 8;
               _loc7_.push(param1[_loc3_[_loc8_]]);
            }
            _loc8_++;
         }
         var _loc9_:* = "";
         _loc9_ = _loc9_ + ("0" + _loc5_.toString(16)).substr(-2);
         _loc8_ = 0;
         while(_loc8_ < _loc6_.length)
         {
            _loc9_ = _loc9_ + ("0" + _loc6_[_loc8_].toString(16)).substr(-2);
            _loc8_++;
         }
         return "\t" + _loc9_ + "\t" + _loc7_.join("\t");
      }
   }
}
