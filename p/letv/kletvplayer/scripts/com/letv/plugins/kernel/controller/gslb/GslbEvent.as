package com.letv.plugins.kernel.controller.gslb
{
   import flash.events.Event;
   
   public class GslbEvent extends Event
   {
      
      public static const LOAD_SUCCESS:String = "loadSuccess";
      
      public static const LOAD_FAILED:String = "loadFailed";
      
      public var dataProvider:Object;
      
      public var utime:Number = 0;
      
      public var retry:int;
      
      public var errorCode:String = "0";
      
      public function GslbEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.dataProvider = param2;
      }
   }
}
