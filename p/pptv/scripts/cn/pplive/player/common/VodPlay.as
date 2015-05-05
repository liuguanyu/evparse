package cn.pplive.player.common
{
   import cn.pplive.player.view.source.StreamListItem;
   
   public class VodPlay extends Object
   {
      
      private static var _markObj:Object = null;
      
      private static var _barrage:Object = null;
      
      private static var _fd:Number = NaN;
      
      private static var _isFd:Boolean = false;
      
      private static var _rid:String = null;
      
      private static var _cl:String = null;
      
      private static var _id:String = null;
      
      private static var _nm:String = null;
      
      private static var _lk:String = null;
      
      private static var _vt:String = null;
      
      private static var _streamVec:Vector.<StreamListItem> = null;
      
      private static var _delay:Number = 30;
      
      private static var _interval:Number = 5;
      
      private static var _cft:Number = 0;
      
      private static var _bwt:Number = 0;
      
      private static var _key:String = null;
      
      private static var _st:String = null;
      
      private static var _addr:Array;
      
      private static var _streamIndex:Number = 0;
      
      private static var _cdnIndex:Number = 0;
      
      private static var _contentPoint:Array;
      
      private static var _adverPoint:Array;
      
      private static var _smartItem:Array;
      
      private static var _olt:Number;
      
      private static var _ts:Number;
      
      private static var _draghost:String;
      
      private static var _serverTime:Number = 0;
      
      private static var _localTime:Number = 0;
      
      private static var _duration:Number = NaN;
      
      private static var _posi:Number = NaN;
      
      private static var _start:Number = NaN;
      
      private static var _xml:XML = null;
      
      private static var _shareDisable:Boolean = false;
      
      public function VodPlay()
      {
         super();
      }
      
      public static function get draghost() : String
      {
         return _draghost;
      }
      
      public static function set draghost(param1:String) : void
      {
         _draghost = param1;
      }
      
      public static function get olt() : Number
      {
         return _olt;
      }
      
      public static function set olt(param1:Number) : void
      {
         _olt = param1;
      }
      
      public static function get ts() : Number
      {
         return _ts;
      }
      
      public static function set ts(param1:Number) : void
      {
         _ts = param1;
      }
      
      public static function get localTime() : Number
      {
         return _localTime;
      }
      
      public static function set localTime(param1:Number) : void
      {
         _localTime = param1;
      }
      
      public static function get contentPoint() : Array
      {
         return _contentPoint;
      }
      
      public static function set contentPoint(param1:Array) : void
      {
         _contentPoint = param1;
      }
      
      public static function get adverPoint() : Array
      {
         return _adverPoint;
      }
      
      public static function set adverPoint(param1:Array) : void
      {
         _adverPoint = param1;
      }
      
      public static function get smartItem() : Array
      {
         return _smartItem;
      }
      
      public static function set smartItem(param1:Array) : void
      {
         _smartItem = param1;
      }
      
      public static function get start() : Number
      {
         return _start;
      }
      
      public static function set start(param1:Number) : void
      {
         _start = param1;
      }
      
      public static function get posi() : Number
      {
         return _posi;
      }
      
      public static function set posi(param1:Number) : void
      {
         _posi = param1;
      }
      
      public static function get serverTime() : Number
      {
         return _serverTime;
      }
      
      public static function set serverTime(param1:Number) : void
      {
         _serverTime = param1;
      }
      
      public static function get cdnIndex() : Number
      {
         return _cdnIndex;
      }
      
      public static function set cdnIndex(param1:Number) : void
      {
         _cdnIndex = param1;
      }
      
      public static function get streamIndex() : Number
      {
         return _streamIndex;
      }
      
      public static function set streamIndex(param1:Number) : void
      {
         _streamIndex = param1;
      }
      
      public static function get addr() : Array
      {
         return _addr;
      }
      
      public static function set addr(param1:Array) : void
      {
         _addr = param1;
      }
      
      public static function get st() : String
      {
         return _st;
      }
      
      public static function set st(param1:String) : void
      {
         _st = param1;
      }
      
      public static function get delay() : Number
      {
         return _delay;
      }
      
      public static function set delay(param1:Number) : void
      {
         _delay = param1;
      }
      
      public static function get interval() : Number
      {
         return _interval;
      }
      
      public static function set interval(param1:Number) : void
      {
         _interval = param1;
      }
      
      public static function get vt() : String
      {
         return _vt;
      }
      
      public static function set vt(param1:String) : void
      {
         _vt = param1;
      }
      
      public static function get key() : String
      {
         return _key;
      }
      
      public static function set key(param1:String) : void
      {
         _key = param1;
      }
      
      public static function get cft() : Number
      {
         return _cft;
      }
      
      public static function set cft(param1:Number) : void
      {
         _cft = param1;
      }
      
      public static function get bwt() : Number
      {
         return _bwt;
      }
      
      public static function set bwt(param1:Number) : void
      {
         _bwt = param1;
      }
      
      public static function get lk() : String
      {
         return _lk;
      }
      
      public static function set lk(param1:String) : void
      {
         _lk = param1;
      }
      
      public static function get nm() : String
      {
         return _nm;
      }
      
      public static function set nm(param1:String) : void
      {
         _nm = param1;
      }
      
      public static function get rid() : String
      {
         return _rid;
      }
      
      public static function set rid(param1:String) : void
      {
         _rid = param1;
      }
      
      public static function get id() : String
      {
         return _id;
      }
      
      public static function set id(param1:String) : void
      {
         _id = param1;
      }
      
      public static function get cl() : String
      {
         return _cl;
      }
      
      public static function set cl(param1:String) : void
      {
         _cl = param1;
      }
      
      public static function get fd() : Number
      {
         return _fd;
      }
      
      public static function set fd(param1:Number) : void
      {
         _fd = param1;
      }
      
      public static function get duration() : Number
      {
         return _duration;
      }
      
      public static function set duration(param1:Number) : void
      {
         _duration = param1;
      }
      
      public static function get markObj() : Object
      {
         return _markObj;
      }
      
      public static function set markObj(param1:Object) : void
      {
         _markObj = param1;
      }
      
      public static function get barrage() : Object
      {
         return _barrage;
      }
      
      public static function set barrage(param1:Object) : void
      {
         _barrage = param1;
      }
      
      public static function get streamVec() : Vector.<StreamListItem>
      {
         return _streamVec;
      }
      
      public static function set streamVec(param1:Vector.<StreamListItem>) : void
      {
         _streamVec = param1;
      }
      
      public static function get xml() : XML
      {
         return _xml;
      }
      
      public static function set xml(param1:XML) : void
      {
         _xml = param1;
      }
      
      public static function get shareDisable() : Boolean
      {
         return _shareDisable;
      }
      
      public static function set shareDisable(param1:Boolean) : void
      {
         _shareDisable = param1;
      }
      
      public static function get isFd() : Boolean
      {
         return _isFd;
      }
      
      public static function set isFd(param1:Boolean) : void
      {
         _isFd = param1;
      }
   }
}
