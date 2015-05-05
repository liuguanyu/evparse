package org.qrcode.input
{
   import org.qrcode.enum.QRCodeEncodeType;
   import org.qrcode.specs.QRSpecs;
   import org.qrcode.enum.QRCodeErrorLevel;
   import org.qrcode.QRbitstream;
   
   public class QRInput extends Object
   {
      
      public static const anTable:Array = [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,36,-1,-1,-1,37,38,-1,-1,-1,-1,39,40,-1,41,42,43,0,1,2,3,4,5,6,7,8,9,44,-1,-1,-1,-1,-1,-1,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1];
      
      public var items:Array;
      
      private var _version:int;
      
      private var _level:int;
      
      public function QRInput(param1:int = 0, param2:int = 0.0)
      {
         super();
         if(param1 < 0 || param1 > QRSpecs.QRSPEC_VERSION_MAX || param2 > QRCodeErrorLevel.QRCODE_ERROR_LEVEL_HIGH)
         {
            throw new Error("Invalid version no");
         }
         else
         {
            this.items = [];
            this._version = param1;
            this._level = param2;
            return;
         }
      }
      
      public static function checkModeNum(param1:int, param2:Array) : Boolean
      {
         var _loc3_:* = 0;
         while(_loc3_ < param1)
         {
            if(param2[_loc3_].toString().charCodeAt() < "0".charCodeAt() || param2[_loc3_].toString().charCodeAt() > "9".charCodeAt())
            {
               return false;
            }
            _loc3_++;
         }
         return true;
      }
      
      public static function estimateBitsModeNum(param1:int) : int
      {
         var _loc2_:int = param1 / 3;
         var _loc3_:int = _loc2_ * 10;
         switch(param1 - _loc2_ * 3)
         {
            case 1:
               _loc3_ = _loc3_ + 4;
               break;
            case 2:
               _loc3_ = _loc3_ + 7;
               break;
         }
         return _loc3_;
      }
      
      public static function lookAnTable(param1:int) : int
      {
         return param1 > 127?-1:anTable[param1];
      }
      
      public static function checkModeAn(param1:int, param2:Array) : Boolean
      {
         var _loc3_:* = 0;
         while(_loc3_ < param1)
         {
            if(lookAnTable(param2[_loc3_].toString().charCodeAt()) == -1)
            {
               return false;
            }
            _loc3_++;
         }
         return true;
      }
      
      public static function estimateBitsModeAn(param1:int) : int
      {
         var _loc2_:int = param1 / 2;
         var _loc3_:int = _loc2_ * 11;
         if(param1 & 1)
         {
            _loc3_ = _loc3_ + 6;
         }
         return _loc3_;
      }
      
      public static function estimateBitsMode8(param1:int) : int
      {
         return param1 * 8;
      }
      
      public static function estimateBitsModeKanji(param1:int) : int
      {
         return param1 / 2 * 13;
      }
      
      public static function checkModeKanji(param1:int, param2:Array) : Boolean
      {
         var _loc4_:* = 0;
         if(param1 & 1)
         {
            return false;
         }
         var _loc3_:* = 0;
         while(_loc3_ < param1)
         {
            _loc4_ = param2[_loc3_] << 8 | param2[_loc3_ + 1];
            if(_loc4_ < 33088 || _loc4_ > 40956 && _loc4_ < 57408 || _loc4_ > 60351)
            {
               return false;
            }
            _loc3_ = _loc3_ + 2;
         }
         return true;
      }
      
      public static function check(param1:int, param2:int, param3:Array) : Boolean
      {
         if(param2 <= 0)
         {
            return false;
         }
         switch(param1)
         {
            case QRCodeEncodeType.QRCODE_ENCODE_NUMERIC:
               return checkModeNum(param2,param3);
            case QRCodeEncodeType.QRCODE_ENCODE_ALPHA_NUMERIC:
               return checkModeAn(param2,param3);
            case QRCodeEncodeType.QRCODE_ENCODE_KANJI:
               return checkModeKanji(param2,param3);
            case QRCodeEncodeType.QRCODE_ENCODE_BYTES:
               return true;
            case QRCodeEncodeType.QRCODE_ENCODE_STRUCTURE:
               return true;
            default:
               return false;
         }
      }
      
      public static function lengthOfCode(param1:int, param2:int, param3:int) : int
      {
         var _loc5_:* = 0;
         var _loc6_:* = NaN;
         var _loc7_:* = 0;
         var _loc4_:int = param3 - 4 - QRSpecs.lengthIndicator(param1,param2);
         switch(param1)
         {
            case QRCodeEncodeType.QRCODE_ENCODE_NUMERIC:
               _loc5_ = _loc4_ / 10;
               _loc6_ = _loc4_ - _loc5_ * 10;
               _loc7_ = _loc5_ * 3;
               if(_loc6_ >= 7)
               {
                  _loc7_ = _loc7_ + 2;
               }
               else if(_loc6_ >= 4)
               {
                  _loc7_ = _loc7_ + 1;
               }
               
               break;
            case QRCodeEncodeType.QRCODE_ENCODE_ALPHA_NUMERIC:
               _loc5_ = _loc4_ / 11;
               _loc6_ = _loc4_ - _loc5_ * 11;
               _loc7_ = _loc5_ * 2;
               if(_loc6_ >= 6)
               {
                  _loc7_++;
               }
               break;
            case QRCodeEncodeType.QRCODE_ENCODE_BYTES:
               _loc7_ = _loc4_ / 8;
               break;
            case QRCodeEncodeType.QRCODE_ENCODE_KANJI:
               _loc7_ = _loc4_ / 13 * 2;
               break;
            case QRCodeEncodeType.QRCODE_ENCODE_STRUCTURE:
               _loc7_ = _loc4_ / 8;
               break;
            default:
               _loc7_ = 0;
         }
         var _loc8_:int = QRSpecs.maximumWords(param1,param2);
         if(_loc7_ < 0)
         {
            _loc7_ = 0;
         }
         if(_loc7_ > _loc8_)
         {
            _loc7_ = _loc8_;
         }
         return _loc7_;
      }
      
      public function get version() : int
      {
         return this._version;
      }
      
      public function set version(param1:int) : void
      {
         if(param1 < 0 || param1 > QRSpecs.QRSPEC_VERSION_MAX)
         {
            throw new Error("Invalid version no");
         }
         else
         {
            this._version = param1;
            return;
         }
      }
      
      public function get errorCorrectionLevel() : int
      {
         return this._level;
      }
      
      public function set errorCorrectionLevel(param1:int) : void
      {
         if(param1 > QRCodeErrorLevel.QRCODE_ERROR_LEVEL_HIGH)
         {
            throw new Error("Invalid ECLEVEL");
         }
         else
         {
            this._level = param1;
            return;
         }
      }
      
      public function appendEntry(param1:QRInputItem) : void
      {
         this.items.addItem(param1);
      }
      
      public function append(param1:int, param2:int, param3:Array) : int
      {
         var entry:QRInputItem = null;
         var mode:int = param1;
         var size:int = param2;
         var data:Array = param3;
         try
         {
            entry = new QRInputItem(mode,size,data);
            this.items.push(entry);
            return 0;
         }
         catch(e:Error)
         {
            return -1;
         }
         return 0;
      }
      
      public function insertStructuredAppendHeader(param1:int, param2:int, param3:int) : int
      {
         var entry:QRInputItem = null;
         var size:int = param1;
         var index:int = param2;
         var parity:int = param3;
         if(size > QRInputItem.MAX_STRUCTURED_SYMBOLS)
         {
            throw new Error("insertStructuredAppendHeader wrong size");
         }
         else if(index <= 0 || index > QRInputItem.MAX_STRUCTURED_SYMBOLS)
         {
            throw new Error("insertStructuredAppendHeader wrong index");
         }
         else
         {
            var buf:Array = [size,index,parity];
            try
            {
               entry = new QRInputItem(QRCodeEncodeType.QRCODE_ENCODE_STRUCTURE,3,buf);
               this.items.unshift(entry);
               return 0;
            }
            catch(e:Error)
            {
               return -1;
            }
            return 0;
         }
         
      }
      
      public function calcParity() : Number
      {
         var _loc2_:QRInputItem = null;
         var _loc3_:* = 0;
         var _loc1_:Number = 0;
         for each(_loc2_ in this.items)
         {
            if(_loc2_.mode != QRCodeEncodeType.QRCODE_ENCODE_STRUCTURE)
            {
               _loc3_ = _loc2_.size - 1;
               while(_loc3_ >= 0)
               {
                  _loc1_ = _loc1_ ^ _loc2_.data[_loc3_];
                  _loc3_--;
               }
            }
         }
         return _loc1_;
      }
      
      public function estimateBitStreamSize(param1:int) : int
      {
         var _loc3_:QRInputItem = null;
         var _loc2_:* = 0;
         for each(_loc3_ in this.items)
         {
            _loc2_ = _loc2_ + _loc3_.estimateBitStreamSizeOfEntry(param1);
         }
         return _loc2_;
      }
      
      public function estimateVersion() : int
      {
         var _loc3_:* = 0;
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         while(true)
         {
            _loc2_ = _loc1_;
            _loc3_ = this.estimateBitStreamSize(_loc2_);
            _loc1_ = QRSpecs.getMinimumVersion((_loc3_ + 7) / 8,this._level);
            if(_loc1_ < 0)
            {
               break;
            }
            if(_loc1_ <= _loc2_)
            {
               return _loc1_;
            }
         }
         return -1;
      }
      
      public function createBitStream() : int
      {
         var _loc2_:QRInputItem = null;
         var _loc3_:* = 0;
         var _loc1_:* = 0;
         for each(_loc2_ in this.items)
         {
            _loc3_ = _loc2_.encodeBitStream(this.version);
            if(_loc3_ < 0)
            {
               return -1;
            }
            _loc1_ = _loc1_ + _loc3_;
         }
         return _loc1_;
      }
      
      public function convertData() : int
      {
         var _loc2_:* = 0;
         var _loc1_:int = this.estimateVersion();
         if(_loc1_ > this.version)
         {
            this.version = _loc1_;
         }
         while(true)
         {
            _loc2_ = this.createBitStream();
            if(_loc2_ < 0)
            {
               break;
            }
            _loc1_ = QRSpecs.getMinimumVersion((_loc2_ + 7) / 8,this._level);
            if(_loc1_ < 0)
            {
               throw new Error("WRONG VERSION");
            }
            else
            {
               if(_loc1_ > this.version)
               {
                  this.version = _loc1_;
                  continue;
               }
               return 0;
            }
         }
         return -1;
      }
      
      public function appendPaddingBit(param1:QRbitstream) : QRbitstream
      {
         var _loc8_:Array = null;
         var _loc9_:* = 0;
         var _loc2_:int = param1.size;
         var _loc3_:int = QRSpecs.getDataLength(this._version,this._level);
         var _loc4_:int = _loc3_ * 8;
         if(_loc4_ == _loc2_)
         {
            return param1;
         }
         if(_loc4_ - _loc2_ < 5)
         {
            param1.appendNum(_loc4_ - _loc2_,0);
            return param1;
         }
         _loc2_ = _loc2_ + 4;
         var _loc5_:int = (_loc2_ + 7) / 8;
         var _loc6_:QRbitstream = new QRbitstream();
         _loc6_.appendNum(_loc5_ * 8 - _loc2_ + 4,0);
         var _loc7_:int = _loc3_ - _loc5_;
         if(_loc7_ > 0)
         {
            _loc8_ = [];
            _loc9_ = 0;
            while(_loc9_ < _loc7_)
            {
               _loc8_[_loc9_] = _loc9_ & 1?17:236;
               _loc9_++;
            }
            _loc6_.appendBytes(_loc7_,_loc8_);
         }
         param1.append(_loc6_);
         return param1;
      }
      
      public function mergeBitStream() : QRbitstream
      {
         var _loc2_:QRInputItem = null;
         if(this.convertData() < 0)
         {
            return null;
         }
         var _loc1_:QRbitstream = new QRbitstream();
         for each(_loc2_ in this.items)
         {
            _loc1_.append(_loc2_.bstream);
         }
         return _loc1_;
      }
      
      public function getBitStream() : QRbitstream
      {
         var _loc1_:QRbitstream = this.mergeBitStream();
         if(_loc1_ == null)
         {
            return null;
         }
         this.appendPaddingBit(_loc1_);
         return _loc1_;
      }
      
      public function getByteStream() : Array
      {
         var _loc1_:QRbitstream = this.getBitStream();
         if(_loc1_ == null)
         {
            return null;
         }
         return _loc1_.toByte();
      }
   }
}
