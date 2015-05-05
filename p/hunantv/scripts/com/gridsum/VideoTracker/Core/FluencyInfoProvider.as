package com.gridsum.VideoTracker.Core
{
   class FluencyInfoProvider extends Object
   {
      
      function FluencyInfoProvider()
      {
         super();
      }
      
      public static function getFluency(param1:Array, param2:Number) : int
      {
         if(param2 < 1)
         {
            var param2:Number = 1;
         }
         var _loc3_:int = getStickTimes(param1);
         var _loc4_:* = 0;
         var _loc5_:Number = getTotalStickDuration(param1);
         var _loc6_:Number = _loc3_ * 2 + _loc5_ * 1;
         _loc4_ = Math.round(100 * param2 / (2 * _loc6_ + param2));
         return _loc4_;
      }
      
      public static function getStickTimes(param1:Array) : int
      {
         if(param1 == null)
         {
            return 0;
         }
         return param1.length;
      }
      
      public static function getTotalStickDuration(param1:Array) : Number
      {
         var _loc2_:* = NaN;
         var _loc3_:* = 0;
         if(param1 == null)
         {
            return 0;
         }
         _loc2_ = 0;
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ = _loc2_ + (param1[_loc3_] as Number);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function getRecentStickTimes(param1:Array, param2:Number) : int
      {
         var _loc4_:Date = null;
         if(param2 <= 0)
         {
            return 0;
         }
         var _loc3_:Number = param2 * 60 * 1000;
         if(param1 == null)
         {
            return 0;
         }
         _loc4_ = new Date();
         while(param1.length > 0 && _loc4_.getTime() - (param1[0] as Date).getTime() > _loc3_)
         {
            param1.shift();
         }
         return param1.length;
      }
      
      public static function getRecentFluency(param1:Array, param2:int, param3:Number) : int
      {
         if(param3 < 1)
         {
            var param3:Number = 1;
         }
         var _loc4_:* = 0;
         var _loc5_:Number = getRecentTotalStickDuration(param1,param2);
         var _loc6_:Number = param2 * 2 + _loc5_ * 1;
         _loc4_ = Math.round(100 * param3 / (2 * _loc6_ + param3));
         return _loc4_;
      }
      
      public static function getRecentTotalStickDuration(param1:Array, param2:int) : Number
      {
         var _loc3_:* = NaN;
         var _loc4_:* = 0;
         if(param1 == null)
         {
            return 0;
         }
         if(param1.length < param2)
         {
            var param2:int = param1.length;
         }
         _loc3_ = 0;
         _loc4_ = 0;
         while(_loc4_ < param2)
         {
            _loc3_ = _loc3_ + (param1[param1.length - 1 - _loc4_] as Number);
            _loc4_++;
         }
         return _loc3_;
      }
   }
}
