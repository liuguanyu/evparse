package com.alex.rpc.events
{
   import flash.events.Event;
   
   public class BufferCheckEvent extends Event
   {
      
      public static const VIDEO_LOAD_COMPLETE:String = "videoLoadComplete";
      
      public function BufferCheckEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}