package com.p2p.utils
{
   public class TimeTranslater extends Object
   {
      
      public function TimeTranslater()
      {
         super();
      }
      
      public static function getHourMinObj(param1:Number) : Object
      {
         var _loc2_:Object = new Object();
         _loc2_.minutes = Math.floor(param1 / 60);
         return _loc2_;
      }
      
      public static function getTime(param1:Number) : String
      {
         var _loc2_:Date = new Date(param1 * 1000);
         return _loc2_.getHours() + ":" + _loc2_.getMinutes() + ":" + _loc2_.getSeconds() + "." + _loc2_.milliseconds;
      }
   }
}
