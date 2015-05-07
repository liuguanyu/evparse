package com.letv.store.events
{
   import flash.events.Event;
   
   public class ExtendEvent extends Event
   {
      
      public static const EXTEND_COMMAND:String = "extendCommand";
      
      public static const EXTEND_INFOTIP:String = "extendInotip";
      
      public var eventid:String;
      
      public var command:String;
      
      public var dataProvider:Object;
      
      public function ExtendEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
