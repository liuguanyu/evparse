package com.alex.error
{
   public class FrameworkError extends Error
   {
      
      public static const APP_UNIQUE_ERROR:String = "framework_1000";
      
      public static const APP_METHOD_ERROR:String = "framework_1001";
      
      public function FrameworkError(param1:* = "", param2:* = 0)
      {
         super(param1,param2);
      }
   }
}
