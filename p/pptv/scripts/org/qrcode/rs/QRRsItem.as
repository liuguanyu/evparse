package org.qrcode.rs
{
   import org.qrcode.utils.QRUtil;
   
   public class QRRsItem extends Object
   {
      
      private static var A0:uint;
      
      private static var NN:uint;
      
      public var mm:uint;
      
      public var nn:uint;
      
      public var alpha_to:Array;
      
      public var index_of:Array;
      
      public var genpoly:Array;
      
      public var nroots:uint;
      
      public var fcr:uint;
      
      public var prim:uint;
      
      public var iprim:uint;
      
      public var pad:uint;
      
      public var gfpoly:uint;
      
      public function QRRsItem()
      {
         this.alpha_to = [];
         this.index_of = [];
         this.genpoly = [];
         super();
      }
      
      public static function init_rs_char(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int) : QRRsItem
      {
         var _loc9_:* = 0;
         var _loc10_:uint = 0;
         var _loc12_:* = 0;
         var _loc7_:QRRsItem = null;
         if(param1 < 0 || param1 > 8)
         {
            return _loc7_;
         }
         if(param3 < 0 || param3 >= 1 << param1)
         {
            return _loc7_;
         }
         if(param4 <= 0 || param4 >= 1 << param1)
         {
            return _loc7_;
         }
         if(param5 < 0 || param5 >= 1 << param1)
         {
            return _loc7_;
         }
         if(param6 < 0 || param6 > 1 << param1 - 1 - param5)
         {
            return _loc7_;
         }
         _loc7_ = new QRRsItem();
         _loc7_.mm = param1;
         _loc7_.nn = 1 << param1 - 1;
         _loc7_.pad = param6;
         _loc7_.alpha_to = QRUtil.array_fill(0,_loc7_.nn + 1,0);
         _loc7_.index_of = QRUtil.array_fill(0,_loc7_.nn + 1,0);
         NN = _loc7_.nn;
         A0 = NN;
         _loc7_.index_of[0] = A0;
         _loc7_.alpha_to[A0] = 0;
         var _loc8_:* = 1;
         _loc9_ = 0;
         while(_loc9_ < _loc7_.nn)
         {
            _loc7_.index_of[_loc8_] = _loc9_;
            _loc7_.alpha_to[_loc9_] = _loc8_;
            _loc8_ = _loc8_ << 1;
            if(_loc8_ & 1 << param1)
            {
               _loc8_ = _loc8_ ^ param2;
            }
            _loc8_ = _loc8_ & _loc7_.nn;
            _loc9_++;
         }
         if(_loc8_ != 1)
         {
            _loc7_ = null;
            return _loc7_;
         }
         _loc7_.genpoly = QRUtil.array_fill(0,param5 + 1,0);
         _loc7_.fcr = param3;
         _loc7_.prim = param4;
         _loc7_.nroots = param5;
         _loc7_.gfpoly = param2;
         _loc10_ = 1;
         while(_loc10_ % param4 != 0)
         {
            _loc10_ = _loc10_ + _loc7_.nn;
         }
         _loc7_.iprim = int(_loc10_ / param4);
         _loc7_.genpoly[0] = 1;
         _loc9_ = 0;
         var _loc11_:* = param3 * param4;
         while(_loc9_ < param5)
         {
            _loc7_.genpoly[_loc9_ + 1] = 1;
            _loc12_ = _loc9_;
            while(_loc12_ > 0)
            {
               if(_loc7_.genpoly[_loc12_] != 0)
               {
                  _loc7_.genpoly[_loc12_] = _loc7_.genpoly[_loc12_ - 1] ^ _loc7_.alpha_to[_loc7_.modnn(_loc7_.index_of[_loc7_.genpoly[_loc12_]] + _loc11_)];
               }
               else
               {
                  _loc7_.genpoly[_loc12_] = _loc7_.genpoly[_loc12_ - 1];
               }
               _loc12_--;
            }
            _loc7_.genpoly[0] = _loc7_.alpha_to[_loc7_.modnn(_loc7_.index_of[_loc7_.genpoly[0]] + _loc11_)];
            _loc9_++;
            _loc11_ = _loc11_ + param4;
         }
         _loc9_ = 0;
         while(_loc9_ <= param5)
         {
            _loc7_.genpoly[_loc9_] = _loc7_.index_of[_loc7_.genpoly[_loc9_]];
            _loc9_++;
         }
         return _loc7_;
      }
      
      public function modnn(param1:int) : int
      {
         while(param1 >= this.nn)
         {
            var param1:int = param1 - this.nn;
            param1 = (param1 >> this.mm) + (param1 & this.nn);
         }
         return param1;
      }
      
      public function encode_rs_char(param1:Array) : Array
      {
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         var _loc2_:QRRsItem = this;
         var _loc3_:Number = _loc2_.nn;
         var _loc4_:Array = QRUtil.array_fill(0,_loc2_.nroots,0);
         var _loc5_:* = 0;
         while(_loc5_ < _loc2_.nn - _loc2_.nroots - _loc2_.pad)
         {
            _loc6_ = _loc2_.index_of[param1[_loc5_] ^ _loc4_[0]];
            if(_loc6_ != _loc3_)
            {
               _loc6_ = this.modnn(_loc2_.nn - _loc2_.genpoly[_loc2_.nroots] + _loc6_);
               _loc7_ = 1;
               while(_loc7_ < _loc2_.nroots)
               {
                  _loc4_[_loc7_] = _loc4_[_loc7_] ^ _loc2_.alpha_to[this.modnn(_loc6_ + _loc2_.genpoly[_loc2_.nroots - _loc7_])];
                  _loc7_++;
               }
            }
            _loc4_.shift();
            if(_loc6_ != this.nn)
            {
               _loc4_.push(_loc2_.alpha_to[this.modnn(_loc6_ + _loc2_.genpoly[0])]);
            }
            else
            {
               _loc4_.push(0);
            }
            _loc5_++;
         }
         return _loc4_;
      }
   }
}
