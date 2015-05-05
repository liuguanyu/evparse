package com.hurlant.crypto.symmetric
{
   import flash.utils.ByteArray;
   import com.hurlant.crypto.tls.TLSError;
   
   public class SSLPad extends Object implements IPad
   {
      
      private var blockSize:uint;
      
      public function SSLPad(param1:uint = 0)
      {
         super();
         this.blockSize = param1;
      }
      
      public function pad(param1:ByteArray) : void
      {
         var _loc2_:uint = this.blockSize - (param1.length + 1) % this.blockSize;
         var _loc3_:uint = 0;
         while(_loc3_ <= _loc2_)
         {
            param1[param1.length] = _loc2_;
            _loc3_++;
         }
      }
      
      public function unpad(param1:ByteArray) : void
      {
         var _loc4_:uint = 0;
         var _loc2_:uint = param1.length % this.blockSize;
         if(_loc2_ != 0)
         {
            throw new TLSError("SSLPad::unpad: ByteArray.length isn\'t a multiple of the blockSize",TLSError.bad_record_mac);
         }
         else
         {
            _loc2_ = param1[param1.length - 1];
            var _loc3_:uint = _loc2_;
            while(_loc3_ > 0)
            {
               _loc4_ = param1[param1.length - 1];
               param1.length--;
               _loc3_--;
            }
            param1.length--;
            return;
         }
      }
      
      public function setBlockSize(param1:uint) : void
      {
         this.blockSize = param1;
      }
   }
}
