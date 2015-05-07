package com.letv.player.components.errors
{
   public class ComponentError extends Error
   {
      
      public static const ENTER_INSTANCE_INVALID:String = "enterInstanceInvalid";
      
      public function ComponentError(param1:* = "", param2:* = 0)
      {
         super(param1,param2);
      }
   }
}
