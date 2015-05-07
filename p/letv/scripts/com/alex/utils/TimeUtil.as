package com.alex.utils
{
   public class TimeUtil extends Object
   {
      
      public function TimeUtil()
      {
         super();
      }
      
      public static function swap(param1:Number) : String
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(int(param1 / 60) < 10)
         {
            _loc2_ = "0" + int(param1 / 60) + ":";
         }
         else
         {
            _loc2_ = int(param1 / 60) + ":";
         }
         if(int(param1 % 60) < 10)
         {
            _loc3_ = "0" + int(param1 % 60) + "";
         }
         else
         {
            _loc3_ = int(param1 % 60) + "";
         }
         return _loc2_ + _loc3_;
      }
      
      public static function swapArray(param1:Number) : Array
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(int(param1 / 60) < 10)
         {
            _loc2_ = "0" + int(param1 / 60);
         }
         else
         {
            _loc2_ = int(param1 / 60) + "";
         }
         if(int(param1 % 60) < 10)
         {
            _loc3_ = "0" + int(param1 % 60) + "";
         }
         else
         {
            _loc3_ = int(param1 % 60) + "";
         }
         return [_loc2_,_loc3_];
      }
      
      public static function swap10Number(param1:int) : String
      {
         var _loc2_:String = param1 <= 9?"0" + param1:String(param1);
         return _loc2_;
      }
      
      public static function getTime() : Array
      {
         var _loc1_:Date = new Date();
         return [swap10Number(_loc1_.hours),swap10Number(_loc1_.minutes),_loc1_.seconds];
      }
   }
}
