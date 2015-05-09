package com.alex.utils
{
   import flash.system.Capabilities;
   
   public class PlayerVersion extends Object
   {
      
      private static var _bigCode:int;
      
      private static var _smallCode:int;
      
      public function PlayerVersion()
      {
         super();
      }
      
      private static function initialize() : void
      {
         var _loc1_:String = null;
         var _loc2_:Array = null;
         if(_bigCode == 0)
         {
            _loc1_ = Capabilities.version;
            _loc1_ = _loc1_.split(" ")[1];
            _loc2_ = _loc1_.split(",");
            _bigCode = int(_loc2_[0]);
            _smallCode = int(_loc2_[1]);
         }
      }
      
      public static function get supportP2P() : Boolean
      {
         initialize();
         if(_bigCode > 10)
         {
            return true;
         }
         if(_bigCode == 10 && _smallCode >= 1)
         {
            return true;
         }
         return false;
      }
      
      public static function get supportStageVideo() : Boolean
      {
         initialize();
         if(_bigCode > 10)
         {
            return true;
         }
         if(_bigCode == 10 && _smallCode >= 2)
         {
            return true;
         }
         return false;
      }
      
      public static function get supportLZMA() : Boolean
      {
         initialize();
         if(_bigCode > 11)
         {
            return true;
         }
         if(_bigCode == 11 && _smallCode >= 4)
         {
            return true;
         }
         return false;
      }
      
      public static function get supportFullscreenInput() : Boolean
      {
         initialize();
         if(_bigCode > 11)
         {
            return true;
         }
         if(_bigCode == 11 && _smallCode >= 3)
         {
            return true;
         }
         return false;
      }
   }
}
