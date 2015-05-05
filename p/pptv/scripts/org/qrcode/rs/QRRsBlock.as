package org.qrcode.rs
{
   public class QRRsBlock extends Object
   {
      
      public var dataLength:int;
      
      public var data:Array;
      
      public var eccLength:int;
      
      public var ecc:Array;
      
      public function QRRsBlock(param1:int, param2:Array, param3:int, param4:Array, param5:QRRsItem)
      {
         this.data = [];
         this.ecc = [];
         super();
         param5.encode_rs_char(param2);
         this.dataLength = param1;
         this.data = param2;
         this.eccLength = param3;
         this.ecc = param4;
      }
   }
}
