package com.letv.aiLoader.utils
{
   import flash.utils.ByteArray;
   import flash.system.Capabilities;
   
   public class DeCompress extends Object
   {
      
      public function DeCompress()
      {
         super();
      }
      
      public static function decode(param1:ByteArray) : ByteArray
      {
         if(param1 == null || param1.length < 16)
         {
            return null;
         }
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.length = param1[5] | param1[6] << 8 | param1[7] << 16 | param1[8] << 24;
         return new Decoder().decode(param1[0],param1,13,_loc2_,0,_loc2_.length)?_loc2_:null;
      }
      
      public static function decodeSWF(param1:ByteArray) : ByteArray
      {
         if(int(Capabilities.version.split(new RegExp("[ ,]+"))[1]) > 10)
         {
            return param1;
         }
         if(param1 == null || param1.length < 32)
         {
            return null;
         }
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.length = param1[4] | param1[5] << 8 | param1[6] << 16 | param1[7] << 24;
         if(!new Decoder().decode(param1[12],param1,17,_loc2_,8,_loc2_.length - 8))
         {
            return null;
         }
         var _loc3_:* = 0;
         while(_loc3_ < 8)
         {
            _loc2_[_loc3_] = param1[_loc3_];
            _loc3_++;
         }
         _loc2_[0] = 70;
         _loc2_[3] = param1[13] > 0?param1[13]:10;
         return _loc2_;
      }
   }
}

import flash.utils.ByteArray;

class Decoder extends Object
{
   
   private var code:int = 0;
   
   private var range:int = -1;
   
   private var inputPos:int = 5;
   
   private var inputData:ByteArray;
   
   function Decoder()
   {
      super();
   }
   
   public function decode(param1:int, param2:ByteArray, param3:int, param4:ByteArray, param5:int, param6:int) : Boolean
   {
      var _loc7_:* = 0;
      var _loc8_:* = 0;
      var _loc9_:* = 0;
      var _loc10_:* = 0;
      var _loc11_:* = 0;
      var _loc12_:* = 0;
      var _loc13_:* = 0;
      var _loc14_:* = 0;
      var _loc15_:* = 0;
      var _loc16_:* = 0;
      var _loc34_:* = 0;
      var _loc35_:* = 0;
      var _loc36_:* = 0;
      var _loc37_:* = 0;
      var _loc38_:* = 0;
      var _loc39_:* = 0;
      var _loc40_:* = 0;
      var _loc41_:* = 0;
      var _loc42_:* = 0;
      var _loc43_:* = 0;
      var _loc17_:* = 1 << param1 / 9 / 5;
      var _loc18_:int = param1 / 9 % 5;
      var _loc19_:int = param1 % 9;
      var _loc20_:int = 1 << _loc18_ - 1;
      var _loc21_:* = 1 << _loc19_ + _loc18_;
      var _loc22_:Vector.<int> = new Vector.<int>(114,true);
      var _loc23_:Vector.<int> = new Vector.<int>(12,true);
      var _loc24_:Vector.<int> = new Vector.<int>(12,true);
      var _loc25_:Vector.<int> = new Vector.<int>(12,true);
      var _loc26_:Vector.<int> = new Vector.<int>(12,true);
      var _loc27_:Vector.<int> = new Vector.<int>(192,true);
      var _loc28_:Vector.<int> = new Vector.<int>(192,true);
      var _loc29_:Vector.<Vector.<int>> = new Vector.<Vector.<int>>(_loc21_,true);
      var _loc30_:Vector.<BitTreeDecoder> = new Vector.<Decoder>(4,true);
      var _loc31_:BitTreeDecoder = new BitTreeDecoder(4);
      var _loc32_:LenDecoder = new LenDecoder(_loc17_);
      var _loc33_:LenDecoder = new LenDecoder(_loc17_--);
      initBitModels(_loc28_);
      initBitModels(_loc24_);
      initBitModels(_loc25_);
      initBitModels(_loc26_);
      initBitModels(_loc27_);
      initBitModels(_loc23_);
      initBitModels(_loc22_);
      _loc12_ = 0;
      while(_loc12_ < _loc21_)
      {
         initBitModels(_loc29_[_loc12_] = new Vector.<int>(768,true));
         _loc12_++;
      }
      _loc12_ = 0;
      while(_loc12_ < 4)
      {
         _loc30_[_loc12_] = new BitTreeDecoder(6);
         _loc12_++;
      }
      _loc12_ = 0;
      while(_loc12_ < 5)
      {
         this.code = this.code << 8 | param2[param3 + _loc12_];
         _loc12_++;
      }
      this.inputPos = this.inputPos + param3;
      this.inputData = param2;
      while(_loc11_ < param6)
      {
         _loc34_ = _loc11_ & _loc17_;
         if(this.decodeBit(_loc27_,(_loc9_ << 4) + _loc34_) == 0)
         {
            _loc12_ = ((_loc11_ & _loc20_) << _loc19_) + ((_loc10_ & 255) >>> 8 - _loc19_);
            if(_loc9_ < 7)
            {
               _loc10_ = 1;
               while(_loc10_ < 256)
               {
                  _loc10_ = _loc10_ << 1 | this.decodeBit(_loc29_[_loc12_],_loc10_);
               }
            }
            else
            {
               _loc35_ = param4[param5 - _loc13_ - 1];
               _loc10_ = 1;
               while(_loc10_ < 256)
               {
                  _loc36_ = _loc35_ >> 7 & 1;
                  _loc7_ = this.decodeBit(_loc29_[_loc12_],(1 + _loc36_ << 8) + _loc10_);
                  _loc10_ = _loc10_ << 1 | _loc7_;
                  if(_loc36_ != _loc7_)
                  {
                     while(_loc10_ < 256)
                     {
                        _loc10_ = _loc10_ << 1 | this.decodeBit(_loc29_[_loc12_],_loc10_);
                     }
                     break;
                  }
                  _loc35_ = _loc35_ << 1;
               }
            }
            _loc9_ = _loc9_ < 4?0:_loc9_ < 10?_loc9_ - 3:_loc9_ - 6;
            param4[param5++] = _loc10_;
            _loc11_++;
         }
         else
         {
            if(this.decodeBit(_loc23_,_loc9_) == 1)
            {
               _loc8_ = 0;
               if(this.decodeBit(_loc24_,_loc9_) == 0)
               {
                  if(this.decodeBit(_loc28_,(_loc9_ << 4) + _loc34_) == 0)
                  {
                     _loc9_ = _loc9_ < 7?9:11;
                     _loc8_ = 1;
                  }
               }
               else
               {
                  if(this.decodeBit(_loc25_,_loc9_) == 0)
                  {
                     _loc37_ = _loc14_;
                  }
                  else
                  {
                     if(this.decodeBit(_loc26_,_loc9_) == 0)
                     {
                        _loc37_ = _loc15_;
                     }
                     else
                     {
                        _loc37_ = _loc16_;
                        _loc16_ = _loc15_;
                     }
                     _loc15_ = _loc14_;
                  }
                  _loc14_ = _loc13_;
                  _loc13_ = _loc37_;
               }
               if(_loc8_ == 0)
               {
                  _loc8_ = _loc32_.decode(this,_loc34_) + 2;
                  _loc9_ = _loc9_ < 7?8:11;
               }
            }
            else
            {
               _loc16_ = _loc15_;
               _loc15_ = _loc14_;
               _loc14_ = _loc13_;
               _loc9_ = _loc9_ < 7?7:10;
               _loc8_ = _loc33_.decode(this,_loc34_) + 2;
               _loc38_ = _loc30_[_loc8_ - 2 < 4?_loc8_ - 2:3].decode(this);
               if(_loc38_ >= 4)
               {
                  _loc39_ = _loc38_ >> 1 - 1;
                  _loc13_ = (2 | _loc38_ & 1) << _loc39_;
                  if(_loc38_ < 14)
                  {
                     _loc40_ = 1;
                     _loc41_ = 0;
                     _loc42_ = _loc13_ - _loc38_ - 1;
                     _loc43_ = 0;
                     while(_loc43_ < _loc39_)
                     {
                        _loc7_ = this.decodeBit(_loc22_,_loc42_ + _loc40_);
                        _loc40_ = _loc40_ << 1;
                        _loc40_ = _loc40_ + _loc7_;
                        _loc41_ = _loc41_ | _loc7_ << _loc43_;
                        _loc43_++;
                     }
                     _loc13_ = _loc13_ + _loc41_;
                  }
                  else
                  {
                     _loc13_ = _loc13_ + (this.decodeDirectBits(_loc39_ - 4) << 4);
                     _loc13_ = _loc13_ + _loc31_.reverseDecode(this);
                     if(_loc13_ < 0)
                     {
                        if(_loc13_ == -1)
                        {
                           break;
                        }
                        return false;
                     }
                  }
               }
               else
               {
                  _loc13_ = _loc38_;
               }
            }
            _loc12_ = 0;
            while(_loc12_ < _loc8_)
            {
               param4[param5] = param4[param5 - _loc13_ - 1];
               param5++;
               _loc12_++;
            }
            _loc11_ = _loc11_ + _loc8_;
            _loc10_ = param4[param5 - 1];
         }
      }
      var param2:ByteArray = null;
      return true;
   }
   
   public function decodeBit(param1:Vector.<int>, param2:int) : int
   {
      var _loc3_:int = param1[param2];
      var _loc4_:int = (this.range >>> 11) * _loc3_;
      if((this.code ^ 2.147483648E9) < (_loc4_ ^ 2.147483648E9))
      {
         this.range = _loc4_;
         param1[param2] = _loc3_ + (2048 - _loc3_ >>> 5);
         if((this.range & 4.27819008E9) == 0)
         {
            this.code = this.code << 8 | this.inputData[this.inputPos];
            this.inputPos++;
            this.range = this.range << 8;
         }
         return 0;
      }
      this.range = this.range - _loc4_;
      this.code = this.code - _loc4_;
      param1[param2] = _loc3_ - (_loc3_ >>> 5);
      if((this.range & 4.27819008E9) == 0)
      {
         this.code = this.code << 8 | this.inputData[this.inputPos];
         this.inputPos++;
         this.range = this.range << 8;
      }
      return 1;
   }
   
   public function decodeDirectBits(param1:int) : int
   {
      var _loc4_:* = 0;
      var _loc2_:* = 0;
      var _loc3_:int = param1;
      while(_loc3_ != 0)
      {
         this.range = this.range >>> 1;
         _loc4_ = this.code - this.range >>> 31;
         this.code = this.code - (this.range & _loc4_ - 1);
         _loc2_ = _loc2_ << 1 | 1 - _loc4_;
         if((this.range & 4.27819008E9) == 0)
         {
            this.code = this.code << 8 | this.inputData[this.inputPos];
            this.inputPos++;
            this.range = this.range << 8;
         }
         _loc3_--;
      }
      return _loc2_;
   }
}

class LenDecoder extends Object
{
   
   private var lowCoder:Vector.<BitTreeDecoder>;
   
   private var midCoder:Vector.<BitTreeDecoder>;
   
   private var highCoder:BitTreeDecoder;
   
   private var choice:Vector.<int>;
   
   function LenDecoder(param1:int)
   {
      this.lowCoder = new Vector.<LenDecoder>(16,true);
      this.midCoder = new Vector.<LenDecoder>(16,true);
      this.highCoder = new BitTreeDecoder(8);
      this.choice = new Vector.<int>(2,true);
      super();
      initBitModels(this.choice);
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
}

class BitTreeDecoder extends Object
{
   
   private var numBitLevels:int;
   
   private var models:Vector.<int>;
   
   function BitTreeDecoder(param1:int)
   {
      super();
      this.models = new Vector.<int>(1 << param1,true);
      initBitModels(this.models);
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
}

const initBitModels:Function;
