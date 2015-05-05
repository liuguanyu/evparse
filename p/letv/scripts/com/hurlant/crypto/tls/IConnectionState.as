package com.hurlant.crypto.tls
{
   import ȁ.decrypt;
   import flash.utils.ByteArray;
   import ȁ.encrypt;
   
   public interface IConnectionState
   {
      
      ȁ function decrypt(param1:uint, param2:uint, param3:ByteArray) : ByteArray;
      
      ȁ function encrypt(param1:uint, param2:ByteArray) : ByteArray;
   }
}
