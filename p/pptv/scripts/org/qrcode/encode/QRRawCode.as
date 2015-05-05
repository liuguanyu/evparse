package org.qrcode.encode
{
   import org.qrcode.specs.QRSpecs;
   import org.qrcode.utils.QRUtil;
   import org.qrcode.rs.QRRsItem;
   import org.qrcode.rs.QRRsBlock;
   import org.qrcode.input.QRInput;
   
   public class QRRawCode extends Object
   {
      
      public var version:int;
      
      public var datacode:Array;
      
      public var ecccode:Array;
      
      public var blocks:int;
      
      public var rsblocks:Array;
      
      public var count:int;
      
      public var dataLength:int;
      
      public var eccLength:int;
      
      public var b1:int;
      
      public function QRRawCode(param1:QRInput)
      {
         this.ecccode = [];
         super();
         this.rsblocks = [];
         var _loc2_:Array = [0,0,0,0,0];
         this.datacode = param1.getByteStream();
         if(this.datacode == null)
         {
            throw new Error("null imput string");
         }
         else
         {
            _loc2_ = QRSpecs.getEccSpec(param1.version,param1.errorCorrectionLevel,_loc2_);
            this.version = param1.version;
            this.b1 = QRSpecs.rsBlockNum1(_loc2_);
            this.dataLength = QRSpecs.rsDataLength(_loc2_);
            this.eccLength = QRSpecs.rsEccLength(_loc2_);
            this.ecccode = QRUtil.array_fill(0,this.eccLength,0);
            this.blocks = QRSpecs.rsBlockNum(_loc2_);
            var _loc3_:int = this.init(_loc2_);
            if(_loc3_ < 0)
            {
               throw new Error("block alloc error");
            }
            else
            {
               this.count = 0;
               return;
            }
         }
      }
      
      public function init(param1:Array) : int
      {
         var _loc8_:* = 0;
         var _loc9_:Array = null;
         var _loc2_:int = QRSpecs.rsDataCodes1(param1);
         var _loc3_:int = QRSpecs.rsEccCodes1(param1);
         var _loc4_:QRRsItem = QRUtil.initRs(8,285,0,1,_loc3_,255 - _loc2_ - _loc3_);
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         _loc8_ = 0;
         while(_loc8_ < QRSpecs.rsBlockNum1(param1))
         {
            _loc9_ = this.ecccode.slice(_loc6_);
            this.rsblocks[_loc8_] = new QRRsBlock(_loc2_,this.datacode.slice(_loc5_),_loc3_,_loc9_,_loc4_);
            _loc9_ = _loc4_.encode_rs_char((this.rsblocks[_loc8_] as QRRsBlock).data);
            (this.rsblocks[_loc8_] as QRRsBlock).ecc = _loc9_;
            this.ecccode = QRUtil.array_merge(this.ecccode.slice(0,_loc6_),_loc9_);
            _loc5_ = _loc5_ + _loc2_;
            _loc6_ = _loc6_ + _loc3_;
            _loc7_++;
            _loc8_++;
         }
         if(QRSpecs.rsBlockNum2(param1) == 0)
         {
            return 0;
         }
         _loc2_ = QRSpecs.rsDataCodes2(param1);
         _loc3_ = QRSpecs.rsEccCodes2(param1);
         _loc4_ = QRUtil.initRs(8,285,0,1,_loc3_,255 - _loc2_ - _loc3_);
         if(_loc4_ == null)
         {
            return -1;
         }
         _loc8_ = 0;
         while(_loc8_ < QRSpecs.rsBlockNum2(param1))
         {
            _loc9_ = this.ecccode.slice(_loc6_);
            this.rsblocks.push(new QRRsBlock(_loc2_,this.datacode.slice(_loc5_),_loc3_,_loc9_,_loc4_),_loc7_);
            this.ecccode = QRUtil.array_merge(this.ecccode.slice(0,_loc6_),_loc9_);
            _loc5_ = _loc5_ + _loc2_;
            _loc6_ = _loc6_ + _loc3_;
            _loc7_++;
            _loc8_++;
         }
         return 0;
      }
      
      public function getCode() : int
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         if(this.count < this.dataLength)
         {
            _loc2_ = this.count % this.blocks;
            _loc3_ = this.count / this.blocks;
            if(_loc3_ >= this.rsblocks[0].dataLength)
            {
               _loc2_ = _loc2_ + this.b1;
            }
            _loc1_ = this.rsblocks[_loc2_].data[_loc3_];
         }
         else if(this.count < this.dataLength + this.eccLength)
         {
            _loc2_ = (this.count - this.dataLength) % this.blocks;
            _loc3_ = (this.count - this.dataLength) / this.blocks;
            _loc1_ = this.rsblocks[_loc2_].ecc[_loc3_];
         }
         else
         {
            return 0;
         }
         
         this.count++;
         return _loc1_;
      }
   }
}
