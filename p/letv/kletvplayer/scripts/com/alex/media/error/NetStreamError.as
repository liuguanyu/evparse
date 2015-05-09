package com.alex.media.error
{
   public class NetStreamError extends Error
   {
      
      public static const VERSION_ERROR:String = "运行时版本过低";
      
      public static const FAULT_FUNCTION:String = "不被使用的方法";
      
      public static const APPEND_ERROR:String = "导入数据之前必须调用resetBegin";
      
      public function NetStreamError(param1:* = "", param2:* = 0)
      {
         super(param1,param2);
      }
   }
}
