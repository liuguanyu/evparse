package com.alex.encrypt.abc
{
   public class BitTreeDecoder extends Object
   {
      
      private var numBitLevels:int;
      
      private var models:Vector.<int>;
      
      public function BitTreeDecoder(param1:int)
      {
         super();
         this.models = new Vector.<int>(1 << param1,true);
         this.initBitModels(this.models);
         this.numBitLevels = param1;
      }
      
      public function decode(param1:Decoder) : int
      {
         var _loc2_:* = 1;
         var _loc3_:int = this.numBitLevels;
         while(_loc3_ != 0)
         {
            _loc2_ = (_loc2_ << 1) + param1.decodeBit(this.models,_loc2_);
            _loc3_--;
         }
         return _loc2_ - (1 << this.numBitLevels);
      }
      
      public function reverseDecode(param1:Decoder) : int
      {
         var _loc5_:* = 0;
         var _loc2_:* = 1;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         while(_loc4_ < this.numBitLevels)
         {
            _loc5_ = param1.decodeBit(this.models,_loc2_);
            _loc2_ = _loc2_ << 1;
            _loc2_ = _loc2_ + _loc5_;
            _loc3_ = _loc3_ | _loc5_ << _loc4_;
            _loc4_++;
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
