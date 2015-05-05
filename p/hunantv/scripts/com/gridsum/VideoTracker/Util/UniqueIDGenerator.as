package com.gridsum.VideoTracker.Util
{
   public class UniqueIDGenerator extends Object
   {
      
      private static const LAST_CHAR_NUM:int = 6;
      
      private static const ZERO_CHAR:int = 48;
      
      private static const NINE_CHAR:int = 57;
      
      private static const a_CHAR:int = 97;
      
      private static const z_CHAR:int = 122;
      
      public function UniqueIDGenerator()
      {
         super();
      }
      
      public static function Generate() : String
      {
         var _loc1_:Date = new Date();
         var _loc2_:Date = new Date(1980,0,1,0,0,0,0);
         var _loc3_:Number = _loc1_.time - _loc2_.time;
         if(_loc3_ < 0)
         {
            _loc3_ = 0;
         }
         var _loc4_:String = Math.round(_loc3_ * 1.01 / 1000).toString();
         var _loc5_:Array = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","0","1","2","3","4","5","6","7","8","9"];
         var _loc6_:uint = 8;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         while(_loc8_ < _loc6_)
         {
            _loc7_ = Math.floor(Math.random() * _loc5_.length);
            if(_loc7_ >= _loc5_.length)
            {
               _loc7_ = _loc5_.length - 1;
            }
            _loc4_ = _loc4_ + _loc5_[_loc7_];
            _loc8_++;
         }
         return _loc4_;
      }
      
      public static function GetCodeOfID(param1:String) : uint
      {
         var _loc5_:String = null;
         var _loc2_:int = param1.length;
         var _loc3_:uint = 0;
         var _loc4_:* = 0;
         while(_loc4_ < LAST_CHAR_NUM)
         {
            _loc5_ = param1.charAt(_loc2_ - LAST_CHAR_NUM + _loc4_);
            if(_loc5_.charCodeAt() >= ZERO_CHAR && _loc5_.charCodeAt() <= NINE_CHAR)
            {
               _loc3_ = _loc3_ * 36 + (_loc5_.charCodeAt() - ZERO_CHAR);
            }
            else if(_loc5_.charCodeAt() >= a_CHAR && _loc5_.charCodeAt() <= z_CHAR)
            {
               _loc3_ = _loc3_ * 36 + (_loc5_.charCodeAt() - a_CHAR + 10);
            }
            
            _loc4_++;
         }
         return _loc3_;
      }
   }
}
