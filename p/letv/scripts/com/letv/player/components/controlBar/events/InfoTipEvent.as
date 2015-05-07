package com.letv.player.components.controlBar.events
{
   import flash.events.Event;
   
   public class InfoTipEvent extends Event
   {
      
      public static const CHANGE:String = "change";
      
      public var dataProvider:Object;
      
      public function InfoTipEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
