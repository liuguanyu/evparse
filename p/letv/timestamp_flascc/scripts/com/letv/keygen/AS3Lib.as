package com.letv.keygen
{
   import com.adobe.crypto.MD5;
   
   public class AS3Lib extends Object
   {
      
      public function AS3Lib()
      {
         super();
      }
      
      private function ror(param1:int, param2:int) : int
      {
         var _loc3_:* = 0;
         while(_loc3_ < param2)
         {
            var param1:int = (param1 >>> 1) + ((param1 & 1) << 31);
            _loc3_++;
         }
         return param1;
      }
      
      public function calcTimeKey(param1:int) : int
      {
         var _loc2_:* = 773625421;
         var _loc3_:int = this.ror(param1,_loc2_ % 13);
         _loc3_ = _loc3_ ^ _loc2_;
         _loc3_ = this.ror(_loc3_,_loc2_ % 17);
         return _loc3_;
      }
      
      public function calcURLKey(param1:String, param2:String, param3:int) : String
      {
         var _loc4_:* = "drwfad012b0580d706";
         return MD5.hash(param1 + param2 + param3 + _loc4_);
      }
      
      public function calcLiveKey(param1:String, param2:int) : String
      {
         var _loc3_:* = "a2915e518ba60169f77";
         return MD5.hash(param1 + "," + param2 + "," + _loc3_);
      }
   }
}
