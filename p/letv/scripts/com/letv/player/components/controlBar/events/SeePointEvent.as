package com.letv.player.components.controlBar.events
{
   import flash.events.Event;
   
   public class SeePointEvent extends Event
   {
      
      public static const SHOW_SEE_POINT:String = "showSeePoint";
      
      public static const HIDE_SEE_POINT:String = "hideSeePoint";
      
      public static const SELECT_SEE_POINT:String = "selectSeePoint";
      
      public static const SET_JUMP:String = "setJump";
      
      public var time:Number = 0;
      
      public var dataProvider:Object;
      
      public function SeePointEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
