package com.hurlant.crypto.symmetric
{
   import ʞ.pad;
   import flash.utils.ByteArray;
   import ʞ.unpad;
   import ʞ.setBlockSize;
   
   public interface IPad
   {
      
      ʞ function pad(param1:ByteArray) : void;
      
      ʞ function unpad(param1:ByteArray) : void;
      
      ʞ function setBlockSize(param1:uint) : void;
   }
}
