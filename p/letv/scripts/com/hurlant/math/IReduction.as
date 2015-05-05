package com.hurlant.math
{
   import ȵ.convert;
   import ȵ.revert;
   import ȵ.reduce;
   import ȵ.mulTo;
   import ȵ.sqrTo;
   
   interface IReduction
   {
      
      ȵ function convert(param1:BigInteger) : BigInteger;
      
      ȵ function revert(param1:BigInteger) : BigInteger;
      
      ȵ function reduce(param1:BigInteger) : void;
      
      ȵ function mulTo(param1:BigInteger, param2:BigInteger, param3:BigInteger) : void;
      
      ȵ function sqrTo(param1:BigInteger, param2:BigInteger) : void;
   }
}
