package com.letv.aiLoader.errors
{
   public class AIError extends Error
   {
      
      public static const IO_ERROR:int = 0;
      
      public static const TIMEOUT_ERROR:int = 1;
      
      public static const SECURITY_ERROR:int = 2;
      
      public static const ANALY_ERROR:int = 3;
      
      public static const OTHER_ERROR:int = 9;
      
      public function AIError(param1:* = "", param2:* = 0)
      {
         super(param1,param2);
      }
      
      public function clone() : AIError
      {
         return new AIError(this.message,this.errorID);
      }
   }
}
