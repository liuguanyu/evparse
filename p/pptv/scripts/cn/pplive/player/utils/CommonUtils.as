package cn.pplive.player.utils
{
   import flash.utils.ByteArray;
   import flash.text.TextField;
   import flash.net.LocalConnection;
   import flash.system.Capabilities;
   import flash.external.ExternalInterface;
   import flash.net.navigateToURL;
   import flash.net.URLRequest;
   
   public class CommonUtils extends Object
   {
      
      public function CommonUtils()
      {
         super();
      }
      
      public static function getActionStr(param1:String, param2:Number = 30) : String
      {
         var _loc3_:* = "utf-8";
         var _loc4_:ByteArray = new ByteArray();
         _loc4_.writeMultiByte(param1,_loc3_);
         if(_loc4_.length > param2)
         {
            _loc4_.position = 0;
            var param1:String = _loc4_.readMultiByte(param2,_loc3_);
            return param1.substr(0,param1.length - 1) + " ...";
         }
         return param1;
      }
      
      public static function addDynamicTxt() : TextField
      {
         var _loc1_:TextField = new TextField();
         _loc1_.autoSize = "left";
         _loc1_.mouseEnabled = false;
         _loc1_.wordWrap = _loc1_.multiline = true;
         return _loc1_;
      }
      
      public static function getHtml(param1:String, param2:String = "#999999", param3:Number = 12) : String
      {
         return "<font color=\"" + param2 + "\" face=\"Microsoft YaHei,微软雅黑,Arial,Tahoma\" size=\"" + param3 + "\">" + param1 + "</font>";
      }
      
      public static function setTimeFormat(param1:Number, param2:Boolean) : String
      {
         var millisecond:Number = param1;
         var isTimestamp:Boolean = param2;
         var date:Date = new Date(millisecond);
         var hou:Number = isTimestamp?date.hours:Math.floor(millisecond / 3600);
         var min:Number = isTimestamp?date.minutes:Math.floor(millisecond % 3600 / 60);
         var sec:Number = isTimestamp?date.seconds:Math.floor(millisecond % 3600 % 60);
         var int2str:Function = function(param1:int):String
         {
            return (param1 < 10?"0":"") + param1;
         };
         return [int2str(hou),int2str(min),int2str(sec)].join(":");
      }
      
      public static function getNetSpeed(param1:Number = 0) : String
      {
         var _loc2_:* = "";
         var _loc3_:Number = param1;
         if(_loc3_ > 0)
         {
            if(_loc3_ > 900)
            {
               _loc3_ = _loc3_ / 1024;
               if(_loc3_ > 1024)
               {
                  _loc2_ = Math.floor(_loc3_ / 1024 * 10) / 10 + "MB/BS";
               }
               else
               {
                  _loc2_ = Math.floor(_loc3_ * 10) / 10 + "KB/S";
               }
            }
            else
            {
               _loc2_ = Math.floor(_loc3_ * 10) / 10 + "Byte/S";
            }
         }
         return _loc2_;
      }
      
      public static function bool(param1:*) : Boolean
      {
         if(typeof param1 == "number")
         {
            return !(param1 == 0);
         }
         if(typeof param1 == "string")
         {
            return !(param1 == "" || param1 == "false" || param1 == "0");
         }
         if(typeof param1 == "object")
         {
            return !(param1 == null);
         }
         if(typeof param1 == "boolean")
         {
            return param1;
         }
         return true;
      }
      
      public static function match(param1:Object, param2:String = null) : Boolean
      {
         var _loc3_:* = undefined;
         for(_loc3_ in param1)
         {
            if(param2)
            {
               if(_loc3_ == param2 && (Boolean(param1[_loc3_])))
               {
                  return true;
               }
               continue;
            }
            return true;
         }
         return false;
      }
      
      public static function mix(param1:Object, param2:Object) : Object
      {
         var _loc3_:String = null;
         for(_loc3_ in param2)
         {
            if(param2[_loc3_].constructor != Object)
            {
               param1[_loc3_] = param2[_loc3_];
            }
            else
            {
               param1[_loc3_] = mix(param1[_loc3_],param2[_loc3_]);
            }
         }
         return param1;
      }
      
      public static function gc() : void
      {
         var _loc1_:LocalConnection = null;
         var _loc2_:LocalConnection = null;
         try
         {
            _loc1_ = new LocalConnection();
            _loc2_ = new LocalConnection();
            _loc1_.connect("gc");
            _loc2_.connect("gc");
         }
         catch(e:Error)
         {
         }
      }
      
      public static function getSum(param1:Array) : Number
      {
         var sum:Number = NaN;
         var foo:Function = null;
         var arr:Array = param1;
         foo = function(param1:*, param2:int, param3:Array):Boolean
         {
            if(param1 is Number)
            {
               sum = sum + param1;
               return true;
            }
            return false;
         };
         sum = 0;
         arr.filter(foo);
         return sum;
      }
      
      public static function getVersion() : Number
      {
         var _loc1_:String = Capabilities.version;
         var _loc2_:Array = [];
         _loc2_ = _loc1_.split(" ");
         _loc2_ = _loc2_[1].split(",");
         _loc1_ = _loc2_[0] + "." + _loc2_[1];
         _loc2_ = null;
         return Number(_loc1_);
      }
      
      public static function getOnair(param1:ByteArray) : Boolean
      {
         var _loc2_:Array = [111,110,97,105,114,1,0];
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         while(_loc4_ < _loc2_.length)
         {
            if("0x" + param1[_loc4_].toString(16) == _loc2_[_loc4_])
            {
               _loc3_++;
               if(_loc3_ == _loc2_.length)
               {
                  return true;
               }
            }
            _loc4_++;
         }
         return false;
      }
      
      public static function addHttp(param1:String) : String
      {
         var _loc2_:String = param1.indexOf("http://") != -1?"":"http://";
         return _loc2_ + param1;
      }
      
      public static function getURL(param1:String, param2:String = "_blank") : void
      {
         var _loc3_:String = null;
         var _loc4_:RegExp = null;
         if(param1 == null || param1 == "")
         {
            return;
         }
         try
         {
            _loc3_ = ExternalInterface.call("eval","navigator.userAgent.toLowerCase()");
            _loc4_ = new RegExp("(msie |firefox\\/)([\\d.]+)","g");
            if(_loc4_.test(_loc3_))
            {
               ExternalInterface.call("eval","window.open(\'" + param1 + "\',\'" + param2 + "\')");
               return;
            }
         }
         catch(e:Error)
         {
         }
         navigateToURL(new URLRequest(param1),param2);
      }
   }
}
