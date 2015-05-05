package com.hls_p2p.events
{
   import flash.events.Event;
   
   public class EventExtensions extends Event
   {
      
      public var data:Object;
      
      public function EventExtensions(param1:String, param2:Object, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         if(param2 != null)
         {
            this.data = param2;
         }
      }
      
      public function get info() : Object
      {
         return this.data;
      }
      
      override public function clone() : Event
      {
         return new EventExtensions(this.type,this.data);
      }
      
      override public function toString() : String
      {
         return "[PlayerEvent type=\"" + type + "\"" + " message=\"" + this.data + "\"" + "]";
      }
   }
}
