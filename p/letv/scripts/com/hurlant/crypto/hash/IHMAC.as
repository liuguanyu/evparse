package com.hurlant.crypto.hash
{
   import ˝.getHashSize;
   import ˝.compute;
   import flash.utils.ByteArray;
   import ˝.dispose;
   import ˝.toString;
   
   public interface IHMAC
   {
      
      ˝ function getHashSize() : uint;
      
      ˝ function compute(param1:ByteArray, param2:ByteArray) : ByteArray;
      
      ˝ function dispose() : void;
      
      ˝ function toString() : String;
   }
}
