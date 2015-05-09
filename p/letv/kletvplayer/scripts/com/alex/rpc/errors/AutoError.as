package com.alex.rpc.errors
{
   public class AutoError extends Error
   {
      
      public static const IO_ERROR:int = 0;
      
      public static const TIMEOUT_ERROR:int = 1;
      
      public static const SECURITY_ERROR:int = 2;
      
      public static const ANALY_ERROR:int = 3;
      
      public static const OTHER_ERROR:int = 9;
      
      public function AutoError(param1:* = "", param2:* = 0)
      {
         super(param1,param2);
      }
      
      public function clone() : AutoError
      {
         return new AutoError(this.message,this.errorID);
      }
   }
}
