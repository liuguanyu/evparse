package com.letv.plugins.kernel.controller.auth.transfer
{
   import flash.events.Event;
   
   public class TransferEvent extends Event
   {
      
      public static const LOAD_SUCCESS:String = "loadSuccess";
      
      public static const LOAD_FAILED:String = "loadFailed";
      
      public static const LOAD_OVERSEA:String = "loadOverSea";
      
      public var dataProvider:Object;
      
      public var errorCode:String = "0";
      
      public function TransferEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
