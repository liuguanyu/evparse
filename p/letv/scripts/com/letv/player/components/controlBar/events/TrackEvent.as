package com.letv.player.components.controlBar.events
{
   import flash.events.Event;
   
   public class TrackEvent extends Event
   {
      
      public static const CHANGE_PREVIEW:String = "changePrivew";
      
      public static const CHANGE_TRACK:String = "changeTrack";
      
      public static const SEEK:String = "seek";
      
      public var dataProvider:Object;
      
      public function TrackEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
