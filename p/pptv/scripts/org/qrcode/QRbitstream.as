package org.qrcode
{
   import org.qrcode.utils.QRUtil;
   
   public class QRbitstream extends Object
   {
      
      public var data:Array;
      
      public function QRbitstream()
      {
         this.data = [];
         super();
      }
      
      public static function newFromNum(param1:Number, param2:Number) : QRbitstream
      {
         var _loc3_:QRbitstream = new QRbitstream();
         _loc3_.allocate(param1);
         var _loc4_:* = 1 << param1 - 1;
         var _loc5_:* = 0;
         while(_loc5_ < param1)
         {
            if(param2 & _loc4_)
            {
               _loc3_.data[_loc5_] = 1;
            }
            else
            {
               _loc3_.data[_loc5_] = 0;
            }
            _loc4_ = _loc4_ >> 1;
            _loc5_++;
         }
         return _loc3_;
      }
      
      public static function newFromBytes(param1:int, param2:Array) : QRbitstream
      {
         var _loc6_:* = NaN;
         var _loc7_:* = 0;
         var _loc3_:QRbitstream = new QRbitstream();
         _loc3_.allocate(param1 * 8);
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         while(_loc5_ < param1)
         {
            _loc6_ = 128;
            _loc7_ = 0;
            while(_loc7_ < 8)
            {
               if(param2[_loc5_] & _loc6_)
               {
                  _loc3_.data[_loc4_] = 1;
               }
               else
               {
                  _loc3_.data[_loc4_] = 0;
               }
               _loc4_++;
               _loc6_ = _loc6_ >> 1;
               _loc7_++;
            }
            _loc5_++;
         }
         return _loc3_;
      }
      
      public function get size() : int
      {
         return this.data.length;
      }
      
      public function allocate(param1:int) : void
      {
         this.data = QRUtil.array_fill(0,param1,0);
      }
      
      public function append(param1:QRbitstream) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param1.size == 0)
         {
            return;
         }
         if(this.size == 0)
         {
            this.data = param1.data;
            return;
         }
         QRUtil.array_merge(this.data,param1.data);
      }
      
      public function appendNum(param1:Number, param2:Number) : void
      {
         if(param1 == 0)
         {
            return;
         }
         var _loc3_:QRbitstream = QRbitstream.newFromNum(param1,param2);
         if(_loc3_ == null)
         {
            return;
         }
         this.append(_loc3_);
      }
      
      public function appendBytes(param1:int, param2:Array) : void
      {
         if(param1 == 0)
         {
            return;
         }
         var _loc3_:QRbitstream = QRbitstream.newFromBytes(param1,param2);
         if(_loc3_ == null)
         {
            return;
         }
         this.append(_loc3_);
      }
      
      public function toByte() : Array
      {
         var _loc6_:* = NaN;
         var _loc7_:* = 0;
         var _loc1_:int = this.size;
         if(_loc1_ == 0)
         {
            return [];
         }
         var _loc2_:Array = QRUtil.array_fill(0,(_loc1_ + 7) / 8,0);
         var _loc3_:int = _loc1_ / 8;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         while(_loc5_ < _loc3_)
         {
            _loc6_ = 0;
            _loc7_ = 0;
            while(_loc7_ < 8)
            {
               _loc6_ = _loc6_ << 1;
               _loc6_ = _loc6_ | this.data[_loc4_];
               _loc4_++;
               _loc7_++;
            }
            _loc2_[_loc5_] = _loc6_;
            _loc5_++;
         }
         if(_loc1_ & 7)
         {
            _loc6_ = 0;
            _loc7_ = 0;
            while(_loc7_ < (_loc1_ & 7))
            {
               _loc6_ = _loc6_ << 1;
               _loc6_ = _loc6_ | this.data[_loc4_];
               _loc4_++;
               _loc7_++;
            }
            _loc2_[_loc3_] = _loc6_;
         }
         return _loc2_;
      }
   }
}
