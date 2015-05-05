package com.hurlant.crypto.prng
{
   import ˮ.getPoolSize;
   import ˮ.init;
   import flash.utils.ByteArray;
   import ˮ.next;
   import ˮ.dispose;
   import ˮ.toString;
   
   public interface IPRNG
   {
      
      ˮ function getPoolSize() : uint;
      
      ˮ function init(param1:ByteArray) : void;
      
      ˮ function next() : uint;
      
      ˮ function dispose() : void;
      
      ˮ function toString() : String;
   }
}
