package com.gridsum.VideoTracker.Util
{
   public class StringCompresser extends Object
   {
      
      private static const _cvcsFormatter:Array = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"];
      
      public function StringCompresser()
      {
         super();
      }
      
      public static function compress(param1:String) : String
      {
         var _loc7_:* = 0;
         var _loc2_:int = param1.length;
         var _loc3_:String = null;
         var _loc4_:* = 0;
         var _loc5_:* = "";
         var _loc6_:* = 0;
         while(_loc6_ < _loc2_)
         {
            _loc4_ = 1;
            _loc3_ = param1.charAt(_loc6_);
            _loc6_++;
            while(_loc6_ < _loc2_ && param1.charAt(_loc6_) == _loc3_ && _loc4_ < _cvcsFormatter.length - 1)
            {
               _loc6_++;
               _loc4_++;
            }
            if(_loc4_ > 3)
            {
               _loc5_ = _loc5_ + ("#" + _cvcsFormatter[_loc4_] + _loc3_);
            }
            else
            {
               _loc7_ = 0;
               while(_loc7_ < _loc4_)
               {
                  _loc5_ = _loc5_ + _loc3_;
                  _loc7_++;
               }
            }
         }
         return _loc5_;
      }
   }
}
