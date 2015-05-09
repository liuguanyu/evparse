package com.letv.speed
{
   import flash.events.Event;
   
   public class GslbEvent extends Event
   {
      
      public static const LOAD_SUCCESS:String = "loadSuccess";
      
      public static const LOAD_FAILED:String = "loadFailed";
      
      public var dataProvider:Object;
      
      public var errorCode:String = "0";
      
      public function GslbEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
