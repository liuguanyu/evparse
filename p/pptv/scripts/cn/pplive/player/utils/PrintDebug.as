package cn.pplive.player.utils
{
   import flash.external.ExternalInterface;
   
   public class PrintDebug extends Object
   {
      
      public static var log:String = "";
      
      public static var line:int = 0;
      
      public function PrintDebug()
      {
         super();
      }
      
      public static function Trace(... rest) : void
      {
         if(line > 1000)
         {
            line = 0;
            log = "";
            CommonUtils.gc();
         }
         var _loc2_:String = debug(rest);
         log = log + (_loc2_ + "\n");
         line++;
         try
         {
            if(PageURLQuery.getParam("debug") == "ikan")
            {
               ExternalInterface.call("console.log",_loc2_);
            }
         }
         catch(evt:Error)
         {
         }
      }
      
      private static function debug(param1:*) : String
      {
         var _loc4_:String = null;
         var _loc2_:* = "";
         var _loc3_:Object = null;
         for(_loc4_ in param1)
         {
            if(typeof param1[_loc4_] == "object")
            {
               _loc3_ = param1[_loc4_];
            }
            else
            {
               _loc2_ = _loc2_ + param1[_loc4_];
            }
         }
         _loc2_ = getCurrentTime() + "  >>>>>>>>  " + _loc2_;
         if(_loc3_)
         {
            _loc2_ = _loc2_ + mix(_loc3_);
         }
         return _loc2_;
      }
      
      private static function mix(param1:Object) : String
      {
         var sign:Array = null;
         var i:String = null;
         var $class:Class = null;
         var obj:Object = param1;
         var str:String = "";
         for(i in obj)
         {
            try
            {
               $class = obj[i].constructor;
               if($class == Object)
               {
                  sign = "{,}".split(",");
               }
               if($class == Array)
               {
                  sign = "[,]".split(",");
               }
               if($class == Object || $class == Array)
               {
                  str = str + ("\"" + i + "\":" + sign[0] + mix(obj[i]) + sign[1] + ",\r\n");
               }
               else
               {
                  str = str + ("\"" + i + "\":" + obj[i] + ",");
               }
            }
            catch(e:Error)
            {
               continue;
            }
         }
         return str;
      }
      
      private static function getCurrentTime() : String
      {
         var _loc1_:Date = new Date();
         return _loc1_.toLocaleTimeString() + "-" + (_loc1_.getMilliseconds() < 100?"0" + _loc1_.getMilliseconds():_loc1_.getMilliseconds());
      }
   }
}
