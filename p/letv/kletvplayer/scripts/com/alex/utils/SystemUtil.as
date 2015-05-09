package com.alex.utils
{
   import flash.system.Capabilities;
   
   public class SystemUtil extends Object
   {
      
      public function SystemUtil()
      {
         super();
      }
      
      public static function get os() : String
      {
         var _loc1_:String = Capabilities.os.toLowerCase();
         if(_loc1_.indexOf("windows xp") >= 0)
         {
            return "winxp";
         }
         if(_loc1_.indexOf("windows 7") >= 0)
         {
            return "win7";
         }
         if(_loc1_.indexOf("windows 8") >= 0)
         {
            return "win8";
         }
         if(_loc1_.indexOf("windows vista") >= 0)
         {
            return "vista";
         }
         if(_loc1_.indexOf("windows ce") >= 0)
         {
            return "wince";
         }
         if(_loc1_.indexOf("linux") >= 0)
         {
            return "linux";
         }
         return _loc1_;
      }
   }
}
