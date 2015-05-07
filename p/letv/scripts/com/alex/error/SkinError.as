package com.alex.error
{
   public class SkinError extends Error
   {
      
      public static const SKIN_CONFIG_ERROR:String = "skin_1100";
      
      public static const SKIN_EXTRACT_ERROR:String = "skin_1101";
      
      public static const SKIN_SET_ERROR:String = "skin_1102";
      
      public function SkinError(param1:* = "", param2:* = 0)
      {
         super(param1,param2);
      }
   }
}
