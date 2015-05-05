package com.hurlant.crypto.hash
{
   import ȴ.getInputSize;
   import ȴ.getHashSize;
   import ȴ.hash;
   import flash.utils.ByteArray;
   import ȴ.toString;
   import ȴ.getPadSize;
   
   public interface IHash
   {
      
      ȴ function getInputSize() : uint;
      
      ȴ function getHashSize() : uint;
      
      ȴ function hash(param1:ByteArray) : ByteArray;
      
      ȴ function toString() : String;
      
      ȴ function getPadSize() : int;
   }
}
