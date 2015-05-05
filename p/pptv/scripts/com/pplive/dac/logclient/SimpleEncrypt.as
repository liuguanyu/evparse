package com.pplive.dac.logclient
{
   import flash.utils.ByteArray;
   
   class SimpleEncrypt extends Object
   {
      
      private var _keyBytes:ByteArray;
      
      function SimpleEncrypt(param1:ByteArray)
      {
         super();
         this._keyBytes = new ByteArray();
         this._keyBytes.writeBytes(param1);
         this._keyBytes.position = 0;
      }
      
      public function Encrypt(param1:String) : ByteArray
      {
         return this.EncryptImpl(param1,this._keyBytes);
      }
      
      private function EncryptImpl(param1:String, param2:ByteArray) : ByteArray
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeUTFBytes(param1);
         _loc3_.position = 0;
         var _loc4_:ByteArray = new ByteArray();
         _loc4_.length = _loc3_.length;
         _loc4_.position = 0;
         param2.position = 0;
         var _loc5_:* = 0;
         while(_loc5_ < _loc3_.length)
         {
            _loc4_[_loc5_] = _loc3_[_loc5_] + param2[_loc5_ % param2.length];
            _loc5_ = _loc5_ + 1;
         }
         _loc4_.position = 0;
         return _loc4_;
      }
   }
}
