package com.letv.pluginsAPI.kernel
{
   public class DefinitionType extends Object
   {
      
      public static const STACK:Array = ["350","1000","1300","k4","yuanhua","720p","1080p"];
      
      public static const FREE_STACK:Array = ["350","1000","1300","k4","yuanhua"];
      
      public static const VIP_QUEUE:Array = ["720p","1080p"];
      
      public static const VIP_STACK:Object = {
         "720p":1,
         "1080p":1
      };
      
      public static const AUTO:String = "auto";
      
      public static const LW:String = "350";
      
      public static const SD:String = "1000";
      
      public static const HD:String = "1300";
      
      public static const K4:String = "k4";
      
      public static const P720:String = "720p";
      
      public static const P1080:String = "1080p";
      
      public static const YUANHUA:String = "yuanhua";
      
      public function DefinitionType()
      {
         super();
      }
   }
}
