package com.hurlant.util.der
{
   import ȋ.getType;
   import ȋ.getLength;
   import ȋ.toDER;
   import flash.utils.ByteArray;
   
   public interface IAsn1Type
   {
      
      ȋ function getType() : uint;
      
      ȋ function getLength() : uint;
      
      ȋ function toDER() : ByteArray;
   }
}
