package com.letv.player.components.outter.warn
{
   import flash.events.Event;
   
   public class OutterWarnEvent extends Event
   {
      
      public static const CHANGE_NODE:String = "changeNode";
      
      public static const FEEDBACK:String = "feedback";
      
      public static const REFRESH:String = "refresh";
      
      public static const RETURN_BACK:String = "returnBack";
      
      public static const MAIN_PAGE:String = "mainPage";
      
      public static const FAQ_PAGE:String = "faqPage";
      
      public static const LETV_PAGE_PLAY:String = "letvPagePlay";
      
      public var dataProvider:Object;
      
      public function OutterWarnEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
