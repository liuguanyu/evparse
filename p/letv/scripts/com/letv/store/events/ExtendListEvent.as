package com.letv.store.events
{
   import flash.events.Event;
   
   public class ExtendListEvent extends Event
   {
      
      public static const CHANGE:String = "change";
      
      public static const CLOSE_PLUGIN:String = "closePlugin";
      
      public var eventid:String;
      
      public var id:String;
      
      public function ExtendListEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
