package cn.pplive.player.common
{
   public class VodParser extends Object
   {
      
      private static var _aplus:String = "http://player.aplus.pptv.com/config/v1";
      
      private static var _cid:String = null;
      
      private static var _clid:String = "0";
      
      private static var _paramObj:Object = null;
      
      private static var _vw:Number = NaN;
      
      private static var _vh:Number = NaN;
      
      private static var _os:String = "-1";
      
      private static var _stime:Number = NaN;
      
      private static var _etime:Number = NaN;
      
      private static var _advars:String;
      
      private static var _rp:Boolean = false;
      
      private static var _ap:Boolean = true;
      
      private static var _ph:Array = ["http://web-play.pptv.com","http://web-play.pplive.cn","http://211.151.82.252"];
      
      private static var _vodcore:String = null;
      
      private static var _livecore:String = "http://player.pplive.cn/livecore/[vs]/LiveCore.swf";
      
      private static var _am:Boolean = false;
      
      private static var _bray:Boolean = false;
      
      private static var _sv:Number = NaN;
      
      private static var _sa:String = "1";
      
      private static var _ads:Object = {};
      
      private static var _stat:Object = {};
      
      private static var _lm:Boolean = true;
      
      private static var _ctx:String = null;
      
      private static var _un:String = "";
      
      private static var _source:String = "1";
      
      private static var _ru:String;
      
      private static var _hl:Boolean = false;
      
      private static var _fimg:String = null;
      
      private static var _lu:String = null;
      
      private static var _markAdv:String = null;
      
      private static var _barrage:String = null;
      
      private static var _acb:String = null;
      
      private static var _afp:String = null;
      
      private static var _subTitle:String = null;
      
      public function VodParser()
      {
         super();
      }
      
      public static function get livecore() : String
      {
         return _livecore;
      }
      
      public static function set livecore(param1:String) : void
      {
         _livecore = param1;
      }
      
      public static function get ru() : String
      {
         return _ru;
      }
      
      public static function set ru(param1:String) : void
      {
         _ru = param1;
      }
      
      public static function get source() : String
      {
         return _source;
      }
      
      public static function set source(param1:String) : void
      {
         _source = param1;
      }
      
      public static function get paramObj() : Object
      {
         return _paramObj;
      }
      
      public static function set paramObj(param1:Object) : void
      {
         _paramObj = param1;
      }
      
      public static function get un() : String
      {
         return _un;
      }
      
      public static function set un(param1:String) : void
      {
         _un = param1;
      }
      
      public static function get cid() : String
      {
         return _cid;
      }
      
      public static function set cid(param1:String) : void
      {
         _cid = param1;
      }
      
      public static function get clid() : String
      {
         return _clid;
      }
      
      public static function set clid(param1:String) : void
      {
         _clid = param1;
      }
      
      public static function get ctx() : String
      {
         return _ctx;
      }
      
      public static function set ctx(param1:String) : void
      {
         _ctx = param1;
      }
      
      public static function get lm() : Boolean
      {
         return _lm;
      }
      
      public static function set lm(param1:Boolean) : void
      {
         _lm = param1;
      }
      
      public static function get stat() : Object
      {
         return _stat;
      }
      
      public static function set stat(param1:Object) : void
      {
         _stat = param1;
      }
      
      public static function get sa() : String
      {
         return _sa;
      }
      
      public static function set sa(param1:String) : void
      {
         _sa = param1;
      }
      
      public static function get ads() : Object
      {
         return _ads;
      }
      
      public static function set ads(param1:Object) : void
      {
         _ads = param1;
      }
      
      public static function get sv() : Number
      {
         return _sv;
      }
      
      public static function set sv(param1:Number) : void
      {
         _sv = param1;
      }
      
      public static function get am() : Boolean
      {
         return _am;
      }
      
      public static function set am(param1:Boolean) : void
      {
         _am = param1;
      }
      
      public static function get bray() : Boolean
      {
         return _bray;
      }
      
      public static function set bray(param1:Boolean) : void
      {
         _bray = param1;
      }
      
      public static function get vodcore() : String
      {
         return _vodcore;
      }
      
      public static function set vodcore(param1:String) : void
      {
         _vodcore = param1;
      }
      
      public static function get ph() : Array
      {
         return _ph;
      }
      
      public static function set ph(param1:Array) : void
      {
         _ph = param1;
      }
      
      public static function get fimg() : String
      {
         return _fimg;
      }
      
      public static function set fimg(param1:String) : void
      {
         _fimg = param1;
      }
      
      public static function get lu() : String
      {
         return _lu;
      }
      
      public static function set lu(param1:String) : void
      {
         _lu = param1;
      }
      
      public static function get barrage() : String
      {
         return _barrage;
      }
      
      public static function set barrage(param1:String) : void
      {
         _barrage = param1;
      }
      
      public static function get acb() : String
      {
         return _acb;
      }
      
      public static function set acb(param1:String) : void
      {
         _acb = param1;
      }
      
      public static function get afp() : String
      {
         return _afp;
      }
      
      public static function set afp(param1:String) : void
      {
         _afp = param1;
      }
      
      public static function get aplus() : String
      {
         return _aplus;
      }
      
      public static function set aplus(param1:String) : void
      {
         _aplus = param1;
      }
      
      public static function get vw() : Number
      {
         return _vw;
      }
      
      public static function set vw(param1:Number) : void
      {
         _vw = param1;
      }
      
      public static function get vh() : Number
      {
         return _vh;
      }
      
      public static function set vh(param1:Number) : void
      {
         _vh = param1;
      }
      
      public static function get os() : String
      {
         return _os;
      }
      
      public static function set os(param1:String) : void
      {
         _os = param1;
      }
      
      public static function get stime() : Number
      {
         return _stime;
      }
      
      public static function set stime(param1:Number) : void
      {
         _stime = param1;
      }
      
      public static function get etime() : Number
      {
         return _etime;
      }
      
      public static function set etime(param1:Number) : void
      {
         _etime = param1;
      }
      
      public static function get advars() : String
      {
         return _advars;
      }
      
      public static function set advars(param1:String) : void
      {
         _advars = param1;
      }
      
      public static function get rp() : Boolean
      {
         return _rp;
      }
      
      public static function set rp(param1:Boolean) : void
      {
         _rp = param1;
      }
      
      public static function get ap() : Boolean
      {
         return _ap;
      }
      
      public static function set ap(param1:Boolean) : void
      {
         _ap = param1;
      }
      
      public static function get hl() : Boolean
      {
         return _hl;
      }
      
      public static function set hl(param1:Boolean) : void
      {
         _hl = param1;
      }
      
      public static function get markAdv() : String
      {
         return _markAdv;
      }
      
      public static function set markAdv(param1:String) : void
      {
         _markAdv = param1;
      }
      
      public static function get subTitle() : String
      {
         return _subTitle;
      }
      
      public static function set subTitle(param1:String) : void
      {
         _subTitle = param1;
      }
   }
}
