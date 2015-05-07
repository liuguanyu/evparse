package com.letv.pluginsAPI
{
   import flash.events.Event;
   
   public class PlayerEvent extends Event
   {
      
      public static const PLAY_STATE:String = "playState";
      
      public var state:String;
      
      public var dataProvider:Object;
      
      public function PlayerEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      override public function clone() : Event
      {
         var _loc1_:PlayerEvent = new PlayerEvent(type,bubbles,cancelable);
         _loc1_.dataProvider = this.dataProvider;
         _loc1_.state = this.state;
         return _loc1_;
      }
   }
}
