package com.letv.pluginsAPI.kernel
{
   import flash.events.Event;
   
   public class PlayerErrorEvent extends Event
   {
      
      public static const PLAYER_ERROR:String = "playerError";
      
      public static const P2P_ERROR:String = "p2pError";
      
      public var errorCode:String;
      
      public var dataProvider:Object;
      
      public function PlayerErrorEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.dataProvider = param2;
      }
   }
}
