package cn.pplive.player.common
{
   public class VIPPrivilege extends Object
   {
      
      private static var $isVip:Boolean;
      
      private static var $isNoad:Boolean;
      
      private static var $isRtmp:Boolean;
      
      private static var $isSpdup:Boolean;
      
      public function VIPPrivilege()
      {
         super();
      }
      
      public static function get isVip() : Boolean
      {
         return $isVip;
      }
      
      public static function set isVip(param1:Boolean) : void
      {
         $isVip = param1;
      }
      
      public static function get isNoad() : Boolean
      {
         return $isNoad;
      }
      
      public static function set isNoad(param1:Boolean) : void
      {
         $isNoad = param1;
      }
      
      public static function get isRtmp() : Boolean
      {
         return $isRtmp;
      }
      
      public static function set isRtmp(param1:Boolean) : void
      {
         $isRtmp = param1;
      }
      
      public static function get isSpdup() : Boolean
      {
         return $isSpdup;
      }
      
      public static function set isSpdup(param1:Boolean) : void
      {
         $isSpdup = param1;
      }
   }
}
