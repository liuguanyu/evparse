package deng.fzip
{
   import flash.utils.*;
   import deng.utils.ChecksumUtil;
   
   public class FZipFile extends Object
   {
      
      public static const COMPRESSION_NONE:int = 0;
      
      public static const COMPRESSION_SHRUNK:int = 1;
      
      public static const COMPRESSION_REDUCED_1:int = 2;
      
      public static const COMPRESSION_REDUCED_2:int = 3;
      
      public static const COMPRESSION_REDUCED_3:int = 4;
      
      public static const COMPRESSION_REDUCED_4:int = 5;
      
      public static const COMPRESSION_IMPLODED:int = 6;
      
      public static const COMPRESSION_TOKENIZED:int = 7;
      
      public static const COMPRESSION_DEFLATED:int = 8;
      
      public static const COMPRESSION_DEFLATED_EXT:int = 9;
      
      public static const COMPRESSION_IMPLODED_PKWARE:int = 10;
      
      protected static var HAS_UNCOMPRESS:Boolean = describeType(ByteArray).factory.method.(@name == "uncompress").parameter.length() > 0;
      
      protected static var HAS_INFLATE:Boolean = describeType(ByteArray).factory.method.(@name == "inflate").length() > 0;
      
      protected var _versionHost:int = 0;
      
      protected var _versionNumber:String = "2.0";
      
      protected var _compressionMethod:int = 8;
      
      protected var _encrypted:Boolean = false;
      
      protected var _implodeDictSize:int = -1;
      
      protected var _implodeShannonFanoTrees:int = -1;
      
      protected var _deflateSpeedOption:int = -1;
      
      protected var _hasDataDescriptor:Boolean = false;
      
      protected var _hasCompressedPatchedData:Boolean = false;
      
      protected var _date:Date;
      
      protected var _adler32:uint;
      
      protected var _hasAdler32:Boolean = false;
      
      protected var _sizeFilename:uint = 0;
      
      protected var _sizeExtra:uint = 0;
      
      protected var _filename:String = "";
      
      protected var _filenameEncoding:String;
      
      protected var _extraFields:Dictionary;
      
      protected var _comment:String = "";
      
      protected var _content:ByteArray;
      
      var _crc32:uint;
      
      var _sizeCompressed:uint = 0;
      
      var _sizeUncompressed:uint = 0;
      
      protected var isCompressed:Boolean = false;
      
      protected var parseFunc:Function;
      
      public function FZipFile(param1:String = "utf-8")
      {
         this.parseFunc = this.parseFileHead;
         super();
         this._filenameEncoding = param1;
         this._extraFields = new Dictionary();
         this._content = new ByteArray();
         this._content.endian = Endian.BIG_ENDIAN;
      }
      
      public function get date() : Date
      {
         return this._date;
      }
      
      public function set date(param1:Date) : void
      {
         this._date = param1 != null?param1:new Date();
      }
      
      public function get filename() : String
      {
         return this._filename;
      }
      
      public function set filename(param1:String) : void
      {
         this._filename = param1;
      }
      
      function get hasDataDescriptor() : Boolean
      {
         return this._hasDataDescriptor;
      }
      
      public function get content() : ByteArray
      {
         if(this.isCompressed)
         {
            this.uncompress();
         }
         return this._content;
      }
      
      public function set content(param1:ByteArray) : void
      {
         this.setContent(param1);
      }
      
      public function setContent(param1:ByteArray, param2:Boolean = true) : void
      {
         if(!(param1 == null) && param1.length > 0)
         {
            param1.position = 0;
            param1.readBytes(this._content,0,param1.length);
            this._crc32 = ChecksumUtil.CRC32(this._content);
            this._hasAdler32 = false;
         }
         else
         {
            this._content.length = 0;
            this._content.position = 0;
            this.isCompressed = false;
         }
         if(param2)
         {
            this.compress();
         }
         else
         {
            this._sizeUncompressed = this._sizeCompressed = this._content.length;
         }
      }
      
      public function get versionNumber() : String
      {
         return this._versionNumber;
      }
      
      public function get sizeCompressed() : uint
      {
         return this._sizeCompressed;
      }
      
      public function get sizeUncompressed() : uint
      {
         return this._sizeUncompressed;
      }
      
      public function getContentAsString(param1:Boolean = true, param2:String = "utf-8") : String
      {
         var _loc3_:String = null;
         if(this.isCompressed)
         {
            this.uncompress();
         }
         this._content.position = 0;
         if(param2 == "utf-8")
         {
            _loc3_ = this._content.readUTFBytes(this._content.bytesAvailable);
         }
         else
         {
            _loc3_ = this._content.readMultiByte(this._content.bytesAvailable,param2);
         }
         this._content.position = 0;
         if(param1)
         {
            this.compress();
         }
         return _loc3_;
      }
      
      public function setContentAsString(param1:String, param2:String = "utf-8", param3:Boolean = true) : void
      {
         this._content.length = 0;
         this._content.position = 0;
         this.isCompressed = false;
         if(!(param1 == null) && param1.length > 0)
         {
            if(param2 == "utf-8")
            {
               this._content.writeUTFBytes(param1);
            }
            else
            {
               this._content.writeMultiByte(param1,param2);
            }
            this._crc32 = ChecksumUtil.CRC32(this._content);
            this._hasAdler32 = false;
         }
         if(param3)
         {
            this.compress();
         }
         else
         {
            this._sizeUncompressed = this._sizeCompressed = this._content.length;
         }
      }
      
      public function serialize(param1:IDataOutput, param2:Boolean, param3:Boolean = false, param4:uint = 0) : uint
      {
         var _loc10_:Object = null;
         var _loc15_:ByteArray = null;
         var _loc16_:* = false;
         if(param1 == null)
         {
            return 0;
         }
         if(param3)
         {
            param1.writeUnsignedInt(FZip.SIG_CENTRAL_FILE_HEADER);
            param1.writeShort(this._versionHost << 8 | 20);
         }
         else
         {
            param1.writeUnsignedInt(FZip.SIG_LOCAL_FILE_HEADER);
         }
         param1.writeShort(this._versionHost << 8 | 20);
         param1.writeShort(this._filenameEncoding == "utf-8"?2048:0);
         param1.writeShort(this.isCompressed?COMPRESSION_DEFLATED:COMPRESSION_NONE);
         var _loc5_:Date = this._date != null?this._date:new Date();
         var _loc6_:uint = uint(_loc5_.getSeconds()) | uint(_loc5_.getMinutes()) << 5 | uint(_loc5_.getHours()) << 11;
         var _loc7_:uint = uint(_loc5_.getDate()) | uint(_loc5_.getMonth() + 1) << 5 | uint(_loc5_.getFullYear() - 1980) << 9;
         param1.writeShort(_loc6_);
         param1.writeShort(_loc7_);
         param1.writeUnsignedInt(this._crc32);
         param1.writeUnsignedInt(this._sizeCompressed);
         param1.writeUnsignedInt(this._sizeUncompressed);
         var _loc8_:ByteArray = new ByteArray();
         _loc8_.endian = Endian.LITTLE_ENDIAN;
         if(this._filenameEncoding == "utf-8")
         {
            _loc8_.writeUTFBytes(this._filename);
         }
         else
         {
            _loc8_.writeMultiByte(this._filename,this._filenameEncoding);
         }
         var _loc9_:uint = _loc8_.position;
         for(_loc10_ in this._extraFields)
         {
            _loc15_ = this._extraFields[_loc10_] as ByteArray;
            if(_loc15_ != null)
            {
               _loc8_.writeShort(uint(_loc10_));
               _loc8_.writeShort(uint(_loc15_.length));
               _loc8_.writeBytes(_loc15_);
            }
         }
         if(param2)
         {
            if(!this._hasAdler32)
            {
               _loc16_ = this.isCompressed;
               if(_loc16_)
               {
                  this.uncompress();
               }
               this._adler32 = ChecksumUtil.Adler32(this._content,0,this._content.length);
               this._hasAdler32 = true;
               if(_loc16_)
               {
                  this.compress();
               }
            }
            _loc8_.writeShort(56026);
            _loc8_.writeShort(4);
            _loc8_.writeUnsignedInt(this._adler32);
         }
         var _loc11_:uint = _loc8_.position - _loc9_;
         if((param3) && this._comment.length > 0)
         {
            if(this._filenameEncoding == "utf-8")
            {
               _loc8_.writeUTFBytes(this._comment);
            }
            else
            {
               _loc8_.writeMultiByte(this._comment,this._filenameEncoding);
            }
         }
         var _loc12_:uint = _loc8_.position - _loc9_ - _loc11_;
         param1.writeShort(_loc9_);
         param1.writeShort(_loc11_);
         if(param3)
         {
            param1.writeShort(_loc12_);
            param1.writeShort(0);
            param1.writeShort(0);
            param1.writeUnsignedInt(0);
            param1.writeUnsignedInt(param4);
         }
         if(_loc9_ + _loc11_ + _loc12_ > 0)
         {
            param1.writeBytes(_loc8_);
         }
         var _loc13_:uint = 0;
         if(!param3 && this._content.length > 0)
         {
            if(this.isCompressed)
            {
               if((HAS_UNCOMPRESS) || (HAS_INFLATE))
               {
                  _loc13_ = this._content.length;
                  param1.writeBytes(this._content,0,_loc13_);
               }
               else
               {
                  _loc13_ = this._content.length - 6;
                  param1.writeBytes(this._content,2,_loc13_);
               }
            }
            else
            {
               _loc13_ = this._content.length;
               param1.writeBytes(this._content,0,_loc13_);
            }
         }
         var _loc14_:uint = 30 + _loc9_ + _loc11_ + _loc12_ + _loc13_;
         if(param3)
         {
            _loc14_ = _loc14_ + 16;
         }
         return _loc14_;
      }
      
      function parse(param1:IDataInput) : Boolean
      {
         while((param1.bytesAvailable) && (this.parseFunc(param1)))
         {
         }
         return this.parseFunc === this.parseFileIdle;
      }
      
      protected function parseFileIdle(param1:IDataInput) : Boolean
      {
         return false;
      }
      
      protected function parseFileHead(param1:IDataInput) : Boolean
      {
         if(param1.bytesAvailable >= 30)
         {
            this.parseHead(param1);
            if(this._sizeFilename + this._sizeExtra > 0)
            {
               this.parseFunc = this.parseFileHeadExt;
            }
            else
            {
               this.parseFunc = this.parseFileContent;
            }
            return true;
         }
         return false;
      }
      
      protected function parseFileHeadExt(param1:IDataInput) : Boolean
      {
         if(param1.bytesAvailable >= this._sizeFilename + this._sizeExtra)
         {
            this.parseHeadExt(param1);
            this.parseFunc = this.parseFileContent;
            return true;
         }
         return false;
      }
      
      protected function parseFileContent(param1:IDataInput) : Boolean
      {
         var _loc2_:* = true;
         if(this._hasDataDescriptor)
         {
            this.parseFunc = this.parseFileIdle;
            _loc2_ = false;
         }
         else if(this._sizeCompressed == 0)
         {
            this.parseFunc = this.parseFileIdle;
         }
         else if(param1.bytesAvailable >= this._sizeCompressed)
         {
            this.parseContent(param1);
            this.parseFunc = this.parseFileIdle;
         }
         else
         {
            _loc2_ = false;
         }
         
         
         return _loc2_;
      }
      
      protected function parseHead(param1:IDataInput) : void
      {
         var _loc2_:uint = param1.readUnsignedShort();
         this._versionHost = _loc2_ >> 8;
         this._versionNumber = Math.floor((_loc2_ & 255) / 10) + "." + (_loc2_ & 255) % 10;
         var _loc3_:uint = param1.readUnsignedShort();
         this._compressionMethod = param1.readUnsignedShort();
         this._encrypted = !((_loc3_ & 1) === 0);
         this._hasDataDescriptor = !((_loc3_ & 8) === 0);
         this._hasCompressedPatchedData = !((_loc3_ & 32) === 0);
         if((_loc3_ & 800) !== 0)
         {
            this._filenameEncoding = "utf-8";
         }
         if(this._compressionMethod === COMPRESSION_IMPLODED)
         {
            this._implodeDictSize = (_loc3_ & 2) !== 0?8192:4096;
            this._implodeShannonFanoTrees = (_loc3_ & 4) !== 0?3:2;
         }
         else if(this._compressionMethod === COMPRESSION_DEFLATED)
         {
            this._deflateSpeedOption = (_loc3_ & 6) >> 1;
         }
         
         var _loc4_:uint = param1.readUnsignedShort();
         var _loc5_:uint = param1.readUnsignedShort();
         var _loc6_:* = _loc4_ & 31;
         var _loc7_:* = (_loc4_ & 2016) >> 5;
         var _loc8_:* = (_loc4_ & 63488) >> 11;
         var _loc9_:* = _loc5_ & 31;
         var _loc10_:* = (_loc5_ & 480) >> 5;
         var _loc11_:int = ((_loc5_ & 65024) >> 9) + 1980;
         this._date = new Date(_loc11_,_loc10_ - 1,_loc9_,_loc8_,_loc7_,_loc6_,0);
         this._crc32 = param1.readUnsignedInt();
         this._sizeCompressed = param1.readUnsignedInt();
         this._sizeUncompressed = param1.readUnsignedInt();
         this._sizeFilename = param1.readUnsignedShort();
         this._sizeExtra = param1.readUnsignedShort();
      }
      
      protected function parseHeadExt(param1:IDataInput) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:ByteArray = null;
         if(this._filenameEncoding == "utf-8")
         {
            this._filename = param1.readUTFBytes(this._sizeFilename);
         }
         else
         {
            this._filename = param1.readMultiByte(this._sizeFilename,this._filenameEncoding);
         }
         var _loc2_:uint = this._sizeExtra;
         while(_loc2_ > 4)
         {
            _loc3_ = param1.readUnsignedShort();
            _loc4_ = param1.readUnsignedShort();
            if(_loc4_ > _loc2_)
            {
               throw new Error("Parse error in file " + this._filename + ": Extra field data size too big.");
            }
            else
            {
               if(_loc3_ === 56026 && _loc4_ === 4)
               {
                  this._adler32 = param1.readUnsignedInt();
                  this._hasAdler32 = true;
               }
               else if(_loc4_ > 0)
               {
                  _loc5_ = new ByteArray();
                  param1.readBytes(_loc5_,0,_loc4_);
                  this._extraFields[_loc3_] = _loc5_;
               }
               
               _loc2_ = _loc2_ - (_loc4_ + 4);
               continue;
            }
         }
         if(_loc2_ > 0)
         {
            param1.readBytes(new ByteArray(),0,_loc2_);
         }
      }
      
      function parseContent(param1:IDataInput) : void
      {
         var _loc2_:uint = 0;
         if(this._compressionMethod === COMPRESSION_DEFLATED && !this._encrypted)
         {
            if((HAS_UNCOMPRESS) || (HAS_INFLATE))
            {
               param1.readBytes(this._content,0,this._sizeCompressed);
            }
            else if(this._hasAdler32)
            {
               this._content.writeByte(120);
               _loc2_ = ~this._deflateSpeedOption << 6 & 192;
               _loc2_ = _loc2_ + (31 - (120 << 8 | _loc2_) % 31);
               this._content.writeByte(_loc2_);
               param1.readBytes(this._content,2,this._sizeCompressed);
               this._content.position = this._content.length;
               this._content.writeUnsignedInt(this._adler32);
            }
            else
            {
               throw new Error("Adler32 checksum not found.");
            }
            
            this.isCompressed = true;
         }
         else if(this._compressionMethod == COMPRESSION_NONE)
         {
            param1.readBytes(this._content,0,this._sizeCompressed);
            this.isCompressed = false;
         }
         else
         {
            throw new Error("Compression method " + this._compressionMethod + " is not supported.");
         }
         
         this._content.position = 0;
      }
      
      protected function compress() : void
      {
         if(!this.isCompressed)
         {
            if(this._content.length > 0)
            {
               this._content.position = 0;
               this._sizeUncompressed = this._content.length;
               if(HAS_INFLATE)
               {
                  this._content.deflate();
                  this._sizeCompressed = this._content.length;
               }
               else if(HAS_UNCOMPRESS)
               {
                  this._content.compress.apply(this._content,["deflate"]);
                  this._sizeCompressed = this._content.length;
               }
               else
               {
                  this._content.compress();
                  this._sizeCompressed = this._content.length - 6;
               }
               
               this._content.position = 0;
               this.isCompressed = true;
            }
            else
            {
               this._sizeCompressed = 0;
               this._sizeUncompressed = 0;
            }
         }
      }
      
      protected function uncompress() : void
      {
         if((this.isCompressed) && this._content.length > 0)
         {
            this._content.position = 0;
            if(HAS_INFLATE)
            {
               this._content.inflate();
            }
            else if(HAS_UNCOMPRESS)
            {
               this._content.uncompress.apply(this._content,["deflate"]);
            }
            else
            {
               this._content.uncompress();
            }
            
            this._content.position = 0;
            this.isCompressed = false;
         }
      }
      
      public function toString() : String
      {
         return "[FZipFile]" + "\n  name:" + this._filename + "\n  date:" + this._date + "\n  sizeCompressed:" + this._sizeCompressed + "\n  sizeUncompressed:" + this._sizeUncompressed + "\n  versionHost:" + this._versionHost + "\n  versionNumber:" + this._versionNumber + "\n  compressionMethod:" + this._compressionMethod + "\n  encrypted:" + this._encrypted + "\n  hasDataDescriptor:" + this._hasDataDescriptor + "\n  hasCompressedPatchedData:" + this._hasCompressedPatchedData + "\n  filenameEncoding:" + this._filenameEncoding + "\n  crc32:" + this._crc32.toString(16) + "\n  adler32:" + this._adler32.toString(16);
      }
   }
}
