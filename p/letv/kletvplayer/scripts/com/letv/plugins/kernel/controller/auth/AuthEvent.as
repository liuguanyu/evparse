package com.letv.plugins.kernel.controller.auth
{
   import flash.events.Event;
   
   public class AuthEvent extends Event
   {
      
      public static const AUTH_VALID:String = "authValid";
      
      public static const AUTH_INVALID:String = "authInvalid";
      
      public var dataProvider:Object;
      
      public var errorCode:String = "0";
      
      public function AuthEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
