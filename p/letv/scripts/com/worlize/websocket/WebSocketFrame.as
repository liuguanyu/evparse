package com.worlize.websocket
{
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.Endian;
   import flash.utils.IDataOutput;
   
   public class WebSocketFrame extends Object
   {
      
      private static const NEW_FRAME:int = 0;
      
      private static const WAITING_FOR_16_BIT_LENGTH:int = 1;
      
      private static const WAITING_FOR_64_BIT_LENGTH:int = 2;
      
      private static const WAITING_FOR_PAYLOAD:int = 3;
      
      private static const COMPLETE:int = 4;
      
      private static var _tempMaskBytes:Vector.<uint> = new Vector.<uint>(4);
      
      {
         _tempMaskBytes = new Vector.<uint>(4);
      }
      
      public var fin:Boolean;
      
      public var rsv1:Boolean;
      
      public var rsv2:Boolean;
      
      public var rsv3:Boolean;
      
      public var opcode:int;
      
      public var mask:Boolean;
      
      public var useNullMask:Boolean;
      
      private var _length:int;
      
      public var binaryPayload:ByteArray;
      
      public var closeStatus:int;
      
      public var protocolError:Boolean = false;
      
      public var frameTooLarge:Boolean = false;
      
      public var dropReason:String;
      
      private var parseState:int = 0;
      
      public function WebSocketFrame()
      {
         super();
      }
      
      public function get length() : int
      {
         return this._length;
      }
      
      public function addData(param1:IDataInput, param2:int, param3:WebSocketConfig) : Boolean
      {
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:uint = 0;
         if(param1.bytesAvailable >= 2)
         {
            if(this.parseState === NEW_FRAME)
            {
               _loc4_ = param1.readByte();
               _loc5_ = param1.readByte();
               this.fin = Boolean(_loc4_ & 128);
               this.rsv1 = Boolean(_loc4_ & 64);
               this.rsv2 = Boolean(_loc4_ & 32);
               this.rsv3 = Boolean(_loc4_ & 16);
               this.mask = Boolean(_loc5_ & 128);
               this.opcode = _loc4_ & 15;
               this._length = _loc5_ & 127;
               if(this.mask)
               {
                  this.protocolError = true;
                  this.dropReason = "Received an illegal masked frame from the server.";
                  return true;
               }
               if(this.opcode > 7)
               {
                  if(this._length > 125)
                  {
                     this.protocolError = true;
                     this.dropReason = "Illegal control frame larger than 125 bytes.";
                     return true;
                  }
                  if(!this.fin)
                  {
                     this.protocolError = true;
                     this.dropReason = "Received illegal fragmented control message.";
                     return true;
                  }
               }
               if(this._length === 126)
               {
                  this.parseState = WAITING_FOR_16_BIT_LENGTH;
               }
               else if(this._length === 127)
               {
                  this.parseState = WAITING_FOR_64_BIT_LENGTH;
               }
               else
               {
                  this.parseState = WAITING_FOR_PAYLOAD;
               }
               
            }
            if(this.parseState === WAITING_FOR_16_BIT_LENGTH)
            {
               if(param1.bytesAvailable >= 2)
               {
                  this._length = param1.readUnsignedShort();
                  this.parseState = WAITING_FOR_PAYLOAD;
               }
            }
            else if(this.parseState === WAITING_FOR_64_BIT_LENGTH)
            {
               if(param1.bytesAvailable >= 8)
               {
                  _loc6_ = param1.readUnsignedInt();
                  if(_loc6_ > 0)
                  {
                     this.frameTooLarge = true;
                     this.dropReason = "Unsupported 64-bit length frame received.";
                     return true;
                  }
                  this._length = param1.readUnsignedInt();
                  this.parseState = WAITING_FOR_PAYLOAD;
               }
            }
            
            if(this.parseState === WAITING_FOR_PAYLOAD)
            {
               if(this._length > param3.maxReceivedFrameSize)
               {
                  this.frameTooLarge = true;
                  this.dropReason = "Received frame size of " + this._length + "exceeds maximum accepted frame size of " + param3.maxReceivedFrameSize;
                  return true;
               }
               if(this._length === 0)
               {
                  this.binaryPayload = new ByteArray();
                  this.parseState = COMPLETE;
                  return true;
               }
               if(param1.bytesAvailable >= this._length)
               {
                  this.binaryPayload = new ByteArray();
                  this.binaryPayload.endian = Endian.BIG_ENDIAN;
                  param1.readBytes(this.binaryPayload,0,this._length);
                  this.binaryPayload.position = 0;
                  this.parseState = COMPLETE;
                  return true;
               }
            }
         }
         return false;
      }
      
      private function throwAwayPayload(param1:IDataInput) : void
      {
         var _loc2_:* = 0;
         if(param1.bytesAvailable >= this._length)
         {
            _loc2_ = 0;
            while(_loc2_ < this._length)
            {
               param1.readByte();
               _loc2_++;
            }
            this.parseState = COMPLETE;
         }
      }
      
      public function send(param1:IDataOutput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ByteArray = null;
         var _loc6_:* = 0;
         var _loc7_:uint = 0;
         if((this.mask) && !this.useNullMask)
         {
            _loc2_ = Math.ceil(Math.random() * 4.294967295E9);
            _tempMaskBytes[0] = _loc2_ >> 24 & 255;
            _tempMaskBytes[1] = _loc2_ >> 16 & 255;
            _tempMaskBytes[2] = _loc2_ >> 8 & 255;
            _tempMaskBytes[3] = _loc2_ & 255;
         }
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         if(this.fin)
         {
            _loc4_ = _loc4_ | 128;
         }
         if(this.rsv1)
         {
            _loc4_ = _loc4_ | 64;
         }
         if(this.rsv2)
         {
            _loc4_ = _loc4_ | 32;
         }
         if(this.rsv3)
         {
            _loc4_ = _loc4_ | 16;
         }
         if(this.mask)
         {
            _loc5_ = _loc5_ | 128;
         }
         _loc4_ = _loc4_ | this.opcode & 15;
         if(this.opcode === WebSocketOpcode.CONNECTION_CLOSE)
         {
            _loc3_ = new ByteArray();
            _loc3_.endian = Endian.BIG_ENDIAN;
            _loc3_.writeShort(this.closeStatus);
            if(this.binaryPayload)
            {
               this.binaryPayload.position = 0;
               _loc3_.writeBytes(this.binaryPayload);
            }
            _loc3_.position = 0;
            this._length = _loc3_.length;
         }
         else if(this.binaryPayload)
         {
            _loc3_ = this.binaryPayload;
            _loc3_.endian = Endian.BIG_ENDIAN;
            _loc3_.position = 0;
            this._length = _loc3_.length;
         }
         else
         {
            _loc3_ = new ByteArray();
            this._length = 0;
         }
         
         if(this.opcode >= 8)
         {
            if(this._length > 125)
            {
               throw new Error("Illegal control frame longer than 125 bytes");
            }
            else if(!this.fin)
            {
               throw new Error("Control frames must not be fragmented.");
            }
            
         }
         if(this._length <= 125)
         {
            _loc5_ = _loc5_ | this._length & 127;
         }
         else if(this._length > 125 && this._length <= 65535)
         {
            _loc5_ = _loc5_ | 126;
         }
         else if(this._length > 65535)
         {
            _loc5_ = _loc5_ | 127;
         }
         
         
         param1.writeByte(_loc4_);
         param1.writeByte(_loc5_);
         if(this._length > 125 && this._length <= 65535)
         {
            param1.writeShort(this._length);
         }
         else if(this._length > 65535)
         {
            param1.writeUnsignedInt(0);
            param1.writeUnsignedInt(this._length);
         }
         
         if(this.mask)
         {
            if(this.useNullMask)
            {
               param1.writeUnsignedInt(0);
               param1.writeBytes(_loc3_,0,_loc3_.length);
            }
            else
            {
               param1.writeUnsignedInt(_loc2_);
               _loc6_ = 0;
               _loc7_ = _loc3_.bytesAvailable;
               while(_loc7_ >= 4)
               {
                  param1.writeUnsignedInt(_loc3_.readUnsignedInt() ^ _loc2_);
                  _loc7_ = _loc7_ - 4;
               }
               while(_loc7_ > 0)
               {
                  param1.writeByte(_loc3_.readByte() ^ _tempMaskBytes[_loc6_]);
                  _loc6_ = _loc6_ + 1;
                  _loc7_--;
               }
            }
         }
         else
         {
            param1.writeBytes(_loc3_,0,_loc3_.length);
         }
      }
   }
}
