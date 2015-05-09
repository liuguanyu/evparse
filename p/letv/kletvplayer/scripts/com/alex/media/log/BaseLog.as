package com.alex.media.log
{
   import flash.events.EventDispatcher;
   import com.alex.media.events.HTTPNetStreamingEvent;
   import flash.events.IEventDispatcher;
   
   public class BaseLog extends EventDispatcher
   {
      
      public function BaseLog(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public function log(param1:String, param2:String = "info") : void
      {
         dispatchEvent(new HTTPNetStreamingEvent(HTTPNetStreamingEvent.LOG,param2,0,param1));
      }
   }
}
