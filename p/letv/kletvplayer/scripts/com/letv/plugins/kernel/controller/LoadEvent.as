package com.letv.plugins.kernel.controller
{
   import flash.events.Event;
   
   public class LoadEvent extends Event
   {
      
      public static const LOAD_COMPLETE:String = "loadComplete";
      
      public static const LOAD_ERROR:String = "loadError";
      
      public var dataProvider:Object;
      
      public var errorCode:String = "0";
      
      public function LoadEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
