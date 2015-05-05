package com.gridsum.VideoTracker.Core
{
   class TimeZoneProvider extends Object
   {
      
      function TimeZoneProvider()
      {
         super();
      }
      
      public function getTimeZone() : int
      {
         var _loc1_:Date = new Date();
         return Math.round(-_loc1_.getTimezoneOffset() / 60);
      }
   }
}
