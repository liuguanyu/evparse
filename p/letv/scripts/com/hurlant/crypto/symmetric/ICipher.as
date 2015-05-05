package com.hurlant.crypto.symmetric
{
   import Ǻ.getBlockSize;
   import Ǻ.encrypt;
   import flash.utils.ByteArray;
   import Ǻ.decrypt;
   import Ǻ.dispose;
   import Ǻ.toString;
   
   public interface ICipher
   {
      
      Ǻ function getBlockSize() : uint;
      
      Ǻ function encrypt(param1:ByteArray) : void;
      
      Ǻ function decrypt(param1:ByteArray) : void;
      
      Ǻ function dispose() : void;
      
      Ǻ function toString() : String;
   }
}
