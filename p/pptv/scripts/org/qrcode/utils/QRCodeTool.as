package org.qrcode.utils
{
   public class QRCodeTool extends Object
   {
      
      public function QRCodeTool()
      {
         super();
      }
      
      public static function binarize(param1:Array) : Array
      {
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:* = 0;
         var _loc2_:int = param1.length;
         for(_loc3_ in param1)
         {
            _loc4_ = param1[_loc3_];
            _loc5_ = 0;
            while(_loc5_ < _loc2_)
            {
               _loc4_[_loc5_] = _loc4_[_loc5_] & 1;
               _loc5_++;
            }
            param1[_loc3_] = _loc4_;
         }
         return param1;
      }
      
      public static function dumpMask(param1:Array) : String
      {
         var _loc5_:* = 0;
         var _loc2_:* = "";
         var _loc3_:int = param1.length;
         var _loc4_:* = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc3_)
            {
               _loc2_ = _loc2_ + (param1[_loc4_][_loc5_].toString().charCodeAt() + ",");
               _loc5_++;
            }
            _loc4_++;
         }
         return _loc2_;
      }
   }
}
