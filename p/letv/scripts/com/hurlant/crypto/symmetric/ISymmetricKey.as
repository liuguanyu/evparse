package com.hurlant.crypto.symmetric
{
   import Ƀ.getBlockSize;
   import Ƀ.encrypt;
   import flash.utils.ByteArray;
   import Ƀ.decrypt;
   import Ƀ.dispose;
   import Ƀ.toString;
   
   public interface ISymmetricKey
   {
      
      Ƀ function getBlockSize() : uint;
      
      Ƀ function encrypt(param1:ByteArray, param2:uint = 0) : void;
      
      Ƀ function decrypt(param1:ByteArray, param2:uint = 0) : void;
      
      Ƀ function dispose() : void;
      
      Ƀ function toString() : String;
   }
}
