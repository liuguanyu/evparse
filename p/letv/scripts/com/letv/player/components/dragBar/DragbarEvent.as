package com.letv.player.components.dragBar
{
   import flash.events.Event;
   
   public class DragbarEvent extends Event
   {
      
      public static const CHANGE:String = "change";
      
      public var percent:Number = 1;
      
      public function DragbarEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
