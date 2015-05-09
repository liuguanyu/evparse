package com.alex.encrypt.abc
{
   public class LenDecoder extends Object
   {
      
      private var lowCoder:Vector.<BitTreeDecoder>;
      
      private var midCoder:Vector.<BitTreeDecoder>;
      
      private var highCoder:BitTreeDecoder;
      
      private var choice:Vector.<int>;
      
      public function LenDecoder(param1:int)
      {
         this.lowCoder = new Vector.<BitTreeDecoder>(16,true);
         this.midCoder = new Vector.<BitTreeDecoder>(16,true);
         this.highCoder = new BitTreeDecoder(8);
         this.choice = new Vector.<int>(2,true);
         super();
         this.initBitModels(this.choice);
         var _loc2_:* = 0;
         while(_loc2_ < param1)
         {
            this.lowCoder[_loc2_] = new BitTreeDecoder(3);
            this.midCoder[_loc2_] = new BitTreeDecoder(3);
            _loc2_++;
         }
      }
      
      public function decode(param1:Decoder, param2:int) : int
      {
         if(param1.decodeBit(this.choice,0) == 0)
         {
            return this.lowCoder[param2].decode(param1);
         }
         var _loc3_:* = 8;
         if(param1.decodeBit(this.choice,1) == 0)
         {
            _loc3_ = _loc3_ + this.midCoder[param2].decode(param1);
         }
         else
         {
            _loc3_ = _loc3_ + (8 + this.highCoder.decode(param1));
         }
         return _loc3_;
      }
      
      private function initBitModels(param1:Vector.<int>) : void
      {
         var _loc2_:* = 0;
         var _loc3_:int = param1.length;
         while(_loc2_ < _loc3_)
         {
            param1[_loc2_] = 1024;
            _loc2_++;
         }
      }
   }
}
