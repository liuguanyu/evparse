package net.httpstreaming.flv
{
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class FLVHeader extends Object
   {
      
      public static const MIN_FILE_HEADER_BYTE_COUNT:int = 9;
      
      private var _hasVideoTags:Boolean = true;
      
      private var _hasAudioTags:Boolean = true;
      
      private var offset:uint;
      
      public function FLVHeader(param1:IDataInput = null)
      {
         super();
         if(param1 != null)
         {
            this.readHeader(param1);
            this.readRest(param1);
         }
      }
      
      public function get hasAudioTags() : Boolean
      {
         return this._hasAudioTags;
      }
      
      public function set hasAudioTags(param1:Boolean) : void
      {
         this._hasAudioTags = param1;
      }
      
      public function get hasVideoTags() : Boolean
      {
         return this._hasVideoTags;
      }
      
      public function set hasVideoTags(param1:Boolean) : void
      {
         this._hasVideoTags = param1;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeByte(70);
         param1.writeByte(76);
         param1.writeByte(86);
         param1.writeByte(1);
         var _loc2_:uint = 0;
         if(this._hasAudioTags)
         {
            _loc2_ = _loc2_ | 4;
         }
         if(this._hasVideoTags)
         {
            _loc2_ = _loc2_ | 1;
         }
         param1.writeByte(_loc2_);
         var _loc3_:uint = MIN_FILE_HEADER_BYTE_COUNT;
         param1.writeUnsignedInt(_loc3_);
         var _loc4_:uint = 0;
         param1.writeUnsignedInt(_loc4_);
         var _loc5_:* = "";
         var _loc6_:* = 0;
         while(_loc6_ < (param1 as ByteArray).length)
         {
            _loc5_ = _loc5_ + ((param1 as ByteArray)[_loc6_].toString(16) + " ");
            _loc6_++;
         }
      }
      
      function readHeader(param1:IDataInput) : void
      {
         if(param1.bytesAvailable < MIN_FILE_HEADER_BYTE_COUNT)
         {
            throw new Error("FLVHeader() input too short");
         }
         else if(param1.readByte() != 70)
         {
            throw new Error("FLVHeader readHeader() Signature[0] not \'F\'");
         }
         else if(param1.readByte() != 76)
         {
            throw new Error("FLVHeader readHeader() Signature[1] not \'L\'");
         }
         else if(param1.readByte() != 86)
         {
            throw new Error("FLVHeader readHeader() Signature[2] not \'V\'");
         }
         else if(param1.readByte() != 1)
         {
            throw new Error("FLVHeader readHeader() Version not 0x01");
         }
         else
         {
            var _loc2_:int = param1.readByte();
            this._hasAudioTags = _loc2_ & 4?true:false;
            this._hasVideoTags = _loc2_ & 1?true:false;
            this.offset = param1.readUnsignedInt();
            if(this.offset < MIN_FILE_HEADER_BYTE_COUNT)
            {
               throw new Error("FLVHeader() offset smaller than minimum");
            }
            else
            {
               return;
            }
         }
         
         
         
         
      }
      
      function readRest(param1:IDataInput) : void
      {
         var _loc2_:ByteArray = null;
         if(this.offset > MIN_FILE_HEADER_BYTE_COUNT)
         {
            if(this.offset - MIN_FILE_HEADER_BYTE_COUNT < param1.bytesAvailable - FLVTag.PREV_TAG_BYTE_COUNT)
            {
               throw new Error("FLVHeader() input too short for nonstandard offset");
            }
            else
            {
               _loc2_ = new ByteArray();
               param1.readBytes(_loc2_,0,this.offset - MIN_FILE_HEADER_BYTE_COUNT);
            }
         }
         if(param1.bytesAvailable < FLVTag.PREV_TAG_BYTE_COUNT)
         {
            throw new Error("FLVHeader() input too short for previousTagSize0");
         }
         else
         {
            param1.readUnsignedInt();
            return;
         }
      }
      
      function get restBytesNeeded() : int
      {
         return FLVTag.PREV_TAG_BYTE_COUNT + (this.offset - MIN_FILE_HEADER_BYTE_COUNT);
      }
   }
}
