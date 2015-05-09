package com.letv.speed
{
   import flash.events.Event;
   
   public class SpeedEvent extends Event
   {
      
      public static const GSLB_SUCCESS:String = "gslbSuccess";
      
      public static const GSLB_FAILED:String = "gslbFailed";
      
      public static const ONE_PROGRESS:String = "onProgress";
      
      public static const ONE_SUCCESS:String = "oneSuccess";
      
      public static const ONE_FAILED:String = "oneFailed";
      
      public static const COMPLETE:String = "complete";
      
      public var dataProvider:Object;
      
      public function SpeedEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
