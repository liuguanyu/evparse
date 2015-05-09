package com.letv.aiLoader.type
{
   import flash.system.Capabilities;
   
   public class PlayerVersion extends Object
   {
      
      public static const VERSION_INVALID:String = "versionInvalid";
      
      public static const VERSION_10_0:String = "version10,0";
      
      public static const VERSION_10_1:String = "version10,1";
      
      public static const VERSION_10_2:String = "version10,2";
      
      public static const VERSION_11:String = "version11";
      
      public function PlayerVersion()
      {
         super();
      }
      
      public static function get support() : String
      {
         var _loc1_:String = Capabilities.version;
         _loc1_ = _loc1_.split(" ")[1];
         var _loc2_:Array = _loc1_.split(",");
         var _loc3_:int = int(_loc2_[0]);
         var _loc4_:int = int(_loc2_[1]);
         if(_loc3_ >= 10 && _loc3_ < 11)
         {
            if(_loc4_ == 0)
            {
               return VERSION_10_0;
            }
            if(_loc4_ == 1)
            {
               return VERSION_10_1;
            }
            if(_loc4_ >= 2)
            {
               return VERSION_10_2;
            }
         }
         else if(_loc3_ == 11)
         {
            return VERSION_11;
         }
         
         return VERSION_INVALID;
      }
      
      public static function get is_10_0() : Boolean
      {
         if(support == VERSION_10_0)
         {
            return true;
         }
         return false;
      }
      
      public static function get supportP2P() : Boolean
      {
         switch(support)
         {
            case VERSION_INVALID:
            case VERSION_10_0:
               return false;
            default:
               return true;
         }
      }
      
      public static function get supportStageVideo() : Boolean
      {
         switch(support)
         {
            case VERSION_10_2:
            case VERSION_11:
               return true;
            default:
               return false;
         }
      }
      
      public static function get supportStage3D() : Boolean
      {
         switch(support)
         {
            case VERSION_11:
               return true;
            default:
               return false;
         }
      }
   }
}
