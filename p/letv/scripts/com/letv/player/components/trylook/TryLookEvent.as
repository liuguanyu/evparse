package com.letv.player.components.trylook
{
   import flash.events.Event;
   
   public class TryLookEvent extends Event
   {
      
      public static const BUY_VIDEO:String = "buyVideo";
      
      public var dataProvider:Object;
      
      public function TryLookEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
