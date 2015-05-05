package com.gridsum.VideoTracker.Core
{
   import com.gridsum.VideoTracker.Config.VideoTrackerConfig;
   
   class BounceInfoProvider extends Object
   {
      
      function BounceInfoProvider()
      {
         super();
      }
      
      public function getVodVideoIsBounce(param1:Array, param2:Number) : Boolean
      {
         if(param1 == null || param1.length == 0)
         {
            return true;
         }
         var _loc3_:int = param1.length;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         while(_loc5_ < _loc3_)
         {
            if((param1[_loc5_] as ClipView).getViewCount() > 0)
            {
               _loc4_++;
            }
            _loc5_++;
         }
         var _loc6_:Number = VideoTrackerConfig.bounceThreasholdRate;
         var _loc7_:Number = _loc4_ / _loc3_;
         if(_loc7_ < _loc6_ && param2 < VideoTrackerConfig.bounceThreasholdTime)
         {
            return true;
         }
         return false;
      }
      
      public function getLiveVideoIsBounce(param1:Number) : Boolean
      {
         return param1 < VideoTrackerConfig.bounceThreasholdTime;
      }
      
      public function getShiftVideoIsBounce(param1:Number) : Boolean
      {
         return param1 < VideoTrackerConfig.bounceThreasholdTime;
      }
   }
}
