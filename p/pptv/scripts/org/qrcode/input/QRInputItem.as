package org.qrcode.input
{
   import org.qrcode.QRbitstream;
   import org.qrcode.specs.QRSpecs;
   import org.qrcode.enum.QRCodeEncodeType;
   import org.qrcode.utils.QRUtil;
   
   public class QRInputItem extends Object
   {
      
      public static const STRUCTURE_HEADER_BITS:int = 20;
      
      public static const MAX_STRUCTURED_SYMBOLS:int = 16;
      
      public var mode:int;
      
      public var size:int;
      
      public var data:Array;
      
      public var bstream:QRbitstream;
      
      public function QRInputItem(param1:int, param2:int, param3:Array, param4:QRbitstream = null)
      {
         super();
         var _loc5_:Array = param3.slice(0,param2);
         if(_loc5_.length < param2)
         {
            _loc5_ = QRUtil.array_merge(_loc5_,QRUtil.array_fill(0,param2 - _loc5_.length,0));
         }
         if(!QRInput.check(param1,param2,_loc5_))
         {
            throw new Error("Error m:" + param1 + ",s:" + param2 + ",d:" + _loc5_.join(","));
         }
         else
         {
            this.mode = param1;
            this.size = param2;
            this.data = _loc5_;
            this.bstream = param4;
            return;
         }
      }
      
      public function encodeModeNum(param1:int) : int
      {
         var words:int = 0;
         var bs:QRbitstream = null;
         var val:int = 0;
         var i:int = 0;
         var version:int = param1;
         try
         {
            words = this.size / 3;
            bs = new QRbitstream();
            val = 1;
            bs.appendNum(4,val);
            bs.appendNum(QRSpecs.lengthIndicator(QRCodeEncodeType.QRCODE_ENCODE_NUMERIC,version),this.size);
            i = 0;
            while(i < words)
            {
               val = (this.data[i * 3].toString().charCodeAt() - "0".charCodeAt()) * 100;
               val = val + (this.data[i * 3 + 1].toString().charCodeAt() - "0".charCodeAt()) * 10;
               val = val + (this.data[i * 3 + 2].toString().charCodeAt() - "0".charCodeAt());
               bs.appendNum(10,val);
               i++;
            }
            if(this.size - words * 3 == 1)
            {
               val = this.data[words * 3].toString().charCodeAt() - "0".charCodeAt();
               bs.appendNum(4,val);
            }
            else if(this.size - words * 3 == 2)
            {
               val = (this.data[words * 3].toString().charCodeAt() - "0".charCodeAt()) * 10;
               val = val + (this.data[words * 3 + 1].toString().charCodeAt() - "0".charCodeAt());
               bs.appendNum(7,val);
            }
            
            this.bstream = bs;
            return 0;
         }
         catch(e:Error)
         {
            return -1;
         }
         return 0;
      }
      
      public function encodeModeAn(param1:int) : int
      {
         var words:int = 0;
         var bs:QRbitstream = null;
         var i:int = 0;
         var val:int = 0;
         var version:int = param1;
         try
         {
            words = this.size / 2;
            bs = new QRbitstream();
            bs.appendNum(4,2);
            bs.appendNum(QRSpecs.lengthIndicator(QRCodeEncodeType.QRCODE_ENCODE_ALPHA_NUMERIC,version),this.size);
            i = 0;
            while(i < words)
            {
               val = QRInput.lookAnTable(this.data[i * 2].toString().charCodeAt()) * 45;
               val = val + QRInput.lookAnTable(this.data[i * 2 + 1].toString().charCodeAt());
               bs.appendNum(11,val);
               i++;
            }
            if(this.size & 1)
            {
               val = QRInput.lookAnTable(this.data[words * 2].toString().charCodeAt());
               bs.appendNum(6,val);
            }
            this.bstream = bs;
            return 0;
         }
         catch(e:Error)
         {
            return -1;
         }
         return 0;
      }
      
      public function encodeMode8(param1:int) : int
      {
         var bs:QRbitstream = null;
         var i:int = 0;
         var version:int = param1;
         try
         {
            bs = new QRbitstream();
            bs.appendNum(4,4);
            bs.appendNum(QRSpecs.lengthIndicator(QRCodeEncodeType.QRCODE_ENCODE_BYTES,version),this.size);
            i = 0;
            while(i < this.size)
            {
               bs.appendNum(8,this.data[i].toString().charCodeAt());
               i++;
            }
            this.bstream = bs;
            return 0;
         }
         catch(e:Error)
         {
            return -1;
         }
         return 0;
      }
      
      public function encodeModeKanji(param1:int) : int
      {
         var bs:QRbitstream = null;
         var i:int = 0;
         var val:int = 0;
         var h:int = 0;
         var version:int = param1;
         try
         {
            bs = new QRbitstream();
            bs.appendNum(4,8);
            bs.appendNum(QRSpecs.lengthIndicator(QRCodeEncodeType.QRCODE_ENCODE_KANJI,version),this.size / 2);
            i = 0;
            while(i < this.size)
            {
               val = this.data[i].toString().charCodeAt() << 8 | this.data[i + 1].toString().charCodeAt();
               if(val <= 40956)
               {
                  val = val - 33088;
               }
               else
               {
                  val = val - 49472;
               }
               h = (val >> 8) * 192;
               val = (val & 255) + h;
               bs.appendNum(13,val);
               i = i + 2;
            }
            this.bstream = bs;
            return 0;
         }
         catch(e:Error)
         {
            return -1;
         }
         return 0;
      }
      
      public function encodeModeStructure() : int
      {
         var bs:QRbitstream = null;
         try
         {
            bs = new QRbitstream();
            bs.appendNum(4,3);
            bs.appendNum(4,this.data[1].toString().charCodeAt() - 1);
            bs.appendNum(4,this.data[0].toString().charCodeAt() - 1);
            bs.appendNum(8,this.data[2].toString().charCodeAt());
            this.bstream = bs;
            return 0;
         }
         catch(e:Error)
         {
            return -1;
         }
         return 0;
      }
      
      public function estimateBitStreamSizeOfEntry(param1:int) : int
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         if(param1 == 0)
         {
            var param1:* = 1;
         }
         switch(this.mode)
         {
            case QRCodeEncodeType.QRCODE_ENCODE_NUMERIC:
               _loc2_ = QRInput.estimateBitsModeNum(this.size);
               break;
            case QRCodeEncodeType.QRCODE_ENCODE_ALPHA_NUMERIC:
               _loc2_ = QRInput.estimateBitsModeAn(this.size);
               break;
            case QRCodeEncodeType.QRCODE_ENCODE_BYTES:
               _loc2_ = QRInput.estimateBitsMode8(this.size);
               break;
            case QRCodeEncodeType.QRCODE_ENCODE_KANJI:
               _loc2_ = QRInput.estimateBitsModeKanji(this.size);
               break;
            case QRCodeEncodeType.QRCODE_ENCODE_STRUCTURE:
               return STRUCTURE_HEADER_BITS;
            default:
               return 0;
         }
         var _loc3_:int = QRSpecs.lengthIndicator(this.mode,param1);
         var _loc4_:* = 1 << _loc3_;
         var _loc5_:int = (this.size + _loc4_ - 1) / _loc4_;
         _loc2_ = _loc2_ + _loc5_ * (4 + _loc3_);
         return _loc2_;
      }
      
      public function encodeBitStream(param1:int) : int
      {
         var words:int = 0;
         var st1:QRInputItem = null;
         var st2:QRInputItem = null;
         var ret:int = 0;
         var version:int = param1;
         try
         {
            this.bstream = null;
            words = QRSpecs.maximumWords(this.mode,version);
            if(this.size > words)
            {
               st1 = new QRInputItem(this.mode,words,this.data);
               st2 = new QRInputItem(this.mode,this.size - words,this.data.slice(words));
               st1.encodeBitStream(version);
               st2.encodeBitStream(version);
               this.bstream = new QRbitstream();
               this.bstream.append(st1.bstream);
               this.bstream.append(st2.bstream);
            }
            else
            {
               ret = 0;
               switch(this.mode)
               {
                  case QRCodeEncodeType.QRCODE_ENCODE_NUMERIC:
                     ret = this.encodeModeNum(version);
                     break;
                  case QRCodeEncodeType.QRCODE_ENCODE_ALPHA_NUMERIC:
                     ret = this.encodeModeAn(version);
                     break;
                  case QRCodeEncodeType.QRCODE_ENCODE_BYTES:
                     ret = this.encodeMode8(version);
                     break;
                  case QRCodeEncodeType.QRCODE_ENCODE_KANJI:
                     ret = this.encodeModeKanji(version);
                  case QRCodeEncodeType.QRCODE_ENCODE_STRUCTURE:
                     ret = this.encodeModeStructure();
                  default:
                     return 0;
               }
               if(ret < 0)
               {
                  return -1;
               }
            }
            return this.bstream.size;
         }
         catch(e:Error)
         {
            return -1;
         }
         return 0;
      }
   }
}
