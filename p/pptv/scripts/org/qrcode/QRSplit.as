package org.qrcode
{
   import org.qrcode.input.QRInput;
   import org.qrcode.enum.QRCodeEncodeType;
   import org.qrcode.specs.QRSpecs;
   
   public class QRSplit extends Object
   {
      
      public var dataStr:Array;
      
      public var input:QRInput;
      
      public var modeHint:int;
      
      public function QRSplit(param1:String, param2:QRInput, param3:int)
      {
         this.dataStr = [];
         super();
         this.dataStr = param1.split("");
         this.input = param2;
         this.modeHint = param3;
      }
      
      public static function isdigitat(param1:Array, param2:int) : Boolean
      {
         if(param2 >= param1.length)
         {
            return false;
         }
         return param1[param2].toString().charCodeAt() >= "0".charCodeAt() && param1[param2].toString().charCodeAt() <= "9".charCodeAt();
      }
      
      public static function isalnumat(param1:Array, param2:int) : Boolean
      {
         if(param2 >= param1.length)
         {
            return false;
         }
         return QRInput.lookAnTable(param1[param2].toString().charCodeAt()) >= 0;
      }
      
      public static function splitStringToQRinput(param1:String, param2:QRInput, param3:int, param4:Boolean = true) : QRInput
      {
         if(param1 == null || param1 == "0" || param1 == "")
         {
            throw new Error("empty string!!!");
         }
         else
         {
            var _loc5_:QRSplit = new QRSplit(param1,param2,param3);
            if(!param4)
            {
               _loc5_.toUpper();
            }
            _loc5_.splitString();
            return _loc5_.input;
         }
      }
      
      public function identifyMode(param1:int) : int
      {
         var _loc3_:String = null;
         var _loc4_:* = 0;
         if(param1 >= this.dataStr.length)
         {
            return -1;
         }
         var _loc2_:String = this.dataStr[param1];
         if(isdigitat(this.dataStr,param1))
         {
            return QRCodeEncodeType.QRCODE_ENCODE_NUMERIC;
         }
         if(isalnumat(this.dataStr,param1))
         {
            return QRCodeEncodeType.QRCODE_ENCODE_ALPHA_NUMERIC;
         }
         if(this.modeHint == QRCodeEncodeType.QRCODE_ENCODE_KANJI)
         {
            if(param1 + 1 < this.dataStr.length)
            {
               _loc3_ = this.dataStr[param1 + 1];
               _loc4_ = _loc2_.charCodeAt() << 8 | _loc3_.charCodeAt();
               if(_loc4_ >= 33088 && _loc4_ <= 40956 || _loc4_ >= 57408 && _loc4_ <= 60351)
               {
                  return QRCodeEncodeType.QRCODE_ENCODE_KANJI;
               }
            }
         }
         return QRCodeEncodeType.QRCODE_ENCODE_BYTES;
      }
      
      public function eatNum() : int
      {
         var _loc6_:* = 0;
         var _loc1_:int = QRSpecs.lengthIndicator(QRCodeEncodeType.QRCODE_ENCODE_NUMERIC,this.input.version);
         var _loc2_:* = 0;
         while(isdigitat(this.dataStr,_loc2_))
         {
            _loc2_++;
         }
         var _loc3_:int = _loc2_;
         var _loc4_:int = this.identifyMode(_loc2_);
         if(_loc4_ == QRCodeEncodeType.QRCODE_ENCODE_BYTES)
         {
            _loc6_ = QRInput.estimateBitsModeNum(_loc3_) + 4 + _loc1_ + QRInput.estimateBitsMode8(1) - QRInput.estimateBitsMode8(_loc3_ + 1);
            if(_loc6_ > 0)
            {
               return this.eat8();
            }
         }
         if(_loc4_ == QRCodeEncodeType.QRCODE_ENCODE_ALPHA_NUMERIC)
         {
            _loc6_ = QRInput.estimateBitsModeNum(_loc3_) + 4 + _loc1_ + QRInput.estimateBitsModeAn(1) - QRInput.estimateBitsModeAn(_loc3_ + 1);
            if(_loc6_ > 0)
            {
               return this.eatAn();
            }
         }
         var _loc5_:int = this.input.append(QRCodeEncodeType.QRCODE_ENCODE_NUMERIC,_loc3_,this.dataStr);
         if(_loc5_ < 0)
         {
            return -1;
         }
         return _loc3_;
      }
      
      public function eatAn() : int
      {
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         var _loc1_:int = QRSpecs.lengthIndicator(QRCodeEncodeType.QRCODE_ENCODE_ALPHA_NUMERIC,this.input.version);
         var _loc2_:int = QRSpecs.lengthIndicator(QRCodeEncodeType.QRCODE_ENCODE_NUMERIC,this.input.version);
         var _loc3_:* = 0;
         while(isalnumat(this.dataStr,_loc3_))
         {
            if(isdigitat(this.dataStr,_loc3_))
            {
               _loc6_ = _loc3_;
               while(isdigitat(this.dataStr,_loc6_))
               {
                  _loc6_++;
               }
               _loc7_ = QRInput.estimateBitsModeAn(_loc3_) + QRInput.estimateBitsModeNum(_loc6_ - _loc3_) + 4 + _loc2_ - QRInput.estimateBitsModeAn(_loc6_);
               if(_loc7_ < 0)
               {
                  break;
               }
               _loc3_ = _loc6_;
            }
            else
            {
               _loc3_++;
            }
         }
         var _loc4_:int = _loc3_;
         if(!isalnumat(this.dataStr,_loc3_))
         {
            _loc7_ = QRInput.estimateBitsModeAn(_loc4_) + 4 + _loc1_ + QRInput.estimateBitsMode8(1) - QRInput.estimateBitsMode8(_loc4_ + 1);
            if(_loc7_ > 0)
            {
               return this.eat8();
            }
         }
         var _loc5_:int = this.input.append(QRCodeEncodeType.QRCODE_ENCODE_ALPHA_NUMERIC,_loc4_,this.dataStr);
         if(_loc5_ < 0)
         {
            return -1;
         }
         return _loc4_;
      }
      
      public function eatKanji() : int
      {
         var _loc1_:* = 0;
         while(this.identifyMode(_loc1_) == QRCodeEncodeType.QRCODE_ENCODE_KANJI)
         {
            _loc1_ = _loc1_ + 2;
         }
         var _loc2_:int = _loc1_;
         var _loc3_:int = this.input.append(QRCodeEncodeType.QRCODE_ENCODE_KANJI,_loc1_,this.dataStr);
         if(_loc3_ < 0)
         {
            return -1;
         }
         return _loc2_;
      }
      
      public function eat8() : int
      {
         var _loc7_:* = 0;
         var _loc8_:* = 0;
         var _loc9_:* = 0;
         var _loc1_:int = QRSpecs.lengthIndicator(QRCodeEncodeType.QRCODE_ENCODE_ALPHA_NUMERIC,this.input.version);
         var _loc2_:int = QRSpecs.lengthIndicator(QRCodeEncodeType.QRCODE_ENCODE_NUMERIC,this.input.version);
         var _loc3_:* = 1;
         var _loc4_:int = this.dataStr.length;
         while(_loc3_ < _loc4_)
         {
            _loc7_ = this.identifyMode(_loc3_);
            if(_loc7_ == QRCodeEncodeType.QRCODE_ENCODE_KANJI)
            {
               break;
            }
            if(_loc7_ == QRCodeEncodeType.QRCODE_ENCODE_NUMERIC)
            {
               _loc8_ = _loc3_;
               while(isdigitat(this.dataStr,_loc8_))
               {
                  _loc8_++;
               }
               _loc9_ = QRInput.estimateBitsMode8(_loc3_) + QRInput.estimateBitsModeNum(_loc8_ - _loc3_) + 4 + _loc2_ - QRInput.estimateBitsMode8(_loc8_);
               if(_loc9_ < 0)
               {
                  break;
               }
               _loc3_ = _loc8_;
            }
            else if(_loc7_ == QRCodeEncodeType.QRCODE_ENCODE_ALPHA_NUMERIC)
            {
               _loc8_ = _loc3_;
               while(isalnumat(this.dataStr,_loc8_))
               {
                  _loc8_++;
               }
               _loc9_ = QRInput.estimateBitsMode8(_loc3_) + QRInput.estimateBitsModeAn(_loc8_ - _loc3_) + 4 + _loc1_ - QRInput.estimateBitsMode8(_loc8_);
               if(_loc9_ < 0)
               {
                  break;
               }
               _loc3_ = _loc8_;
            }
            else
            {
               _loc3_++;
            }
            
         }
         var _loc5_:int = _loc3_;
         var _loc6_:int = this.input.append(QRCodeEncodeType.QRCODE_ENCODE_BYTES,_loc5_,this.dataStr);
         if(_loc6_ < 0)
         {
            return -1;
         }
         return _loc5_;
      }
      
      public function splitString() : int
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         while(this.dataStr.length > 0)
         {
            _loc1_ = this.identifyMode(0);
            switch(_loc1_)
            {
               case QRCodeEncodeType.QRCODE_ENCODE_NUMERIC:
                  _loc2_ = this.eatNum();
                  break;
               case QRCodeEncodeType.QRCODE_ENCODE_ALPHA_NUMERIC:
                  _loc2_ = this.eatAn();
                  break;
               case QRCodeEncodeType.QRCODE_ENCODE_KANJI:
                  if(this.modeHint == QRCodeEncodeType.QRCODE_ENCODE_KANJI)
                  {
                     _loc2_ = this.eatKanji();
                  }
                  else
                  {
                     _loc2_ = this.eat8();
                  }
                  break;
               default:
                  _loc2_ = this.eat8();
            }
            if(_loc2_ == 0)
            {
               return 0;
            }
            if(_loc2_ < 0)
            {
               return -1;
            }
            this.dataStr = this.dataStr.slice(_loc2_);
         }
         return _loc2_;
      }
      
      public function toUpper() : Array
      {
         var _loc3_:* = 0;
         var _loc1_:int = this.dataStr.length;
         var _loc2_:* = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.identifyMode(this.modeHint);
            if(_loc3_ == QRCodeEncodeType.QRCODE_ENCODE_KANJI)
            {
               _loc2_ = _loc2_ + 2;
            }
            else
            {
               if(this.dataStr[_loc2_].charCodeAt() >= "a".charCodeAt() && this.dataStr[_loc2_].charCodeAt() <= "z".charCodeAt())
               {
                  this.dataStr[_loc2_] = String.fromCharCode(this.dataStr[_loc2_].charCodeAt() - 32);
               }
               _loc2_++;
            }
         }
         return this.dataStr;
      }
   }
}
