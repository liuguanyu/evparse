package com.p2p.utils
{
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   
   public class CheckSum extends Object
   {
      
      private const step:int = 47;
      
      public function CheckSum()
      {
         super();
      }
      
      public function checkSum(param1:ByteArray) : uint
      {
         param1.position = 0;
         param1.endian = Endian.BIG_ENDIAN;
         var _loc2_:uint = 4.294967295E9;
         var _loc3_:* = 0;
         if(param1.bytesAvailable >= 188)
         {
            param1.position = param1.position + 4;
            while(param1.bytesAvailable > this.step)
            {
               _loc2_ = _loc2_ ^ param1.readUnsignedInt();
               param1.position = param1.position + (this.step - 4);
            }
         }
         _loc2_ = (_loc2_ >> 16 & 65535) + (_loc2_ & 65535);
         return ~_loc2_ & 65535;
      }
   }
}
