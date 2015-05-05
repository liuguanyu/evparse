package at.matthew.httpstreaming
{
   import flash.events.EventDispatcher;
   import flash.utils.IDataInput;
   import flash.utils.ByteArray;
   
   public class HTTPStreamingMP2TSFileHandler extends EventDispatcher
   {
      
      private var _syncFound:Boolean;
      
      private var _pmtPID:uint;
      
      private var _audioPID:uint;
      
      private var _videoPID:uint;
      
      private var _audioPES:HTTPStreamingMP2PESAudio;
      
      private var _videoPES:HTTPStreamingMP2PESVideo;
      
      private var _tmpInput:IDataInput;
      
      private var _cachedOutputBytes:ByteArray;
      
      private var alternatingYieldCounter:int = 0;
      
      private var endParse:Boolean = false;
      
      private var output:ByteArray;
      
      private var packet:ByteArray;
      
      public function HTTPStreamingMP2TSFileHandler()
      {
         this.output = new ByteArray();
         this.packet = new ByteArray();
         super();
         this._audioPES = new HTTPStreamingMP2PESAudio();
         this._videoPES = new HTTPStreamingMP2PESVideo();
         this.alternatingYieldCounter = 0;
      }
      
      public function beginProcessFile() : void
      {
         this._syncFound = false;
         this.endParse = false;
      }
      
      public function endProcessFile(param1:IDataInput) : ByteArray
      {
         this.endParse = true;
         if((this._tmpInput) && this._tmpInput.bytesAvailable > 0)
         {
            (this._tmpInput as ByteArray).clear();
         }
         this._pmtPID = 0;
         this._audioPES = null;
         this._videoPES = null;
         this._audioPES = new HTTPStreamingMP2PESAudio();
         this._videoPES = new HTTPStreamingMP2PESVideo();
         return null;
      }
      
      public function get inputBytesNeeded() : Number
      {
         return this._syncFound?187:1;
      }
      
      public function processFileSegment(param1:IDataInput) : ByteArray
      {
         var _loc3_:ByteArray = null;
         this.output.clear();
         var _loc2_:Number = this.getTime();
         while(param1.bytesAvailable > 187)
         {
            if(this.endParse)
            {
               (param1 as ByteArray).clear();
               break;
            }
            if(param1.readByte() == 71)
            {
               if(param1.bytesAvailable < 187)
               {
                  return this.output;
               }
               this.packet.clear();
               param1.readBytes(this.packet,0,187);
               _loc3_ = this.processPacket(this.packet);
               if(_loc3_ !== null)
               {
                  this.output.writeBytes(_loc3_);
               }
               if(this.getTime() - _loc2_ > 7)
               {
                  return this.output;
               }
            }
         }
         return this.output;
      }
      
      protected function getTime() : Number
      {
         return Math.floor(new Date().time);
      }
      
      private function processPacket(param1:ByteArray) : ByteArray
      {
         var _loc9_:uint = 0;
         var _loc2_:uint = param1.readUnsignedByte();
         var _loc3_:Boolean = Boolean(_loc2_ & 64);
         _loc2_ = _loc2_ << 8;
         _loc2_ = _loc2_ + param1.readUnsignedByte();
         var _loc4_:uint = _loc2_ & 8191;
         _loc2_ = param1.readUnsignedByte();
         var _loc5_:uint = _loc2_ >> 6 & 3;
         var _loc6_:Boolean = Boolean(_loc2_ & 32);
         var _loc7_:Boolean = Boolean(_loc2_ & 16);
         var _loc8_:uint = _loc2_ & 15;
         if(_loc6_)
         {
            _loc9_ = param1.readUnsignedByte();
            param1.position = param1.position + _loc9_;
         }
         if(_loc7_)
         {
            return this.processES(_loc4_,_loc3_,param1);
         }
         return null;
      }
      
      private function processES(param1:uint, param2:Boolean, param3:ByteArray) : ByteArray
      {
         if(param1 == 0)
         {
            if(param2)
            {
               this.processPAT(param3);
            }
            return new ByteArray();
         }
         if(param1 == this._pmtPID)
         {
            if(param2)
            {
               this.processPMT(param3);
            }
            return new ByteArray();
         }
         if(param1 == this._audioPID)
         {
            return this._audioPES.processES(param2,param3);
         }
         if(param1 == this._videoPID)
         {
            return this._videoPES.processES(param2,param3);
         }
         return new ByteArray();
      }
      
      private function processPAT(param1:ByteArray) : void
      {
         var _loc2_:uint = param1.readUnsignedByte();
         var _loc3_:uint = param1.readUnsignedByte();
         var _loc4_:uint = param1.readUnsignedShort() & 1023;
         var _loc5_:uint = _loc4_;
         param1.position = param1.position + 5;
         _loc5_ = _loc5_ - 5;
         while(_loc5_ > 4)
         {
            if(this.endParse)
            {
               param1.clear();
               break;
            }
            param1.readUnsignedShort();
            this._pmtPID = param1.readUnsignedShort() & 8191;
            _loc5_ = _loc5_ - 4;
         }
      }
      
      private function processPMT(param1:ByteArray) : void
      {
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc2_:uint = param1.readUnsignedByte();
         var _loc3_:uint = param1.readUnsignedByte();
         if(_loc3_ != 2)
         {
            return;
         }
         var _loc4_:uint = param1.readUnsignedShort() & 1023;
         var _loc5_:uint = _loc4_;
         param1.position = param1.position + 7;
         _loc5_ = _loc5_ - 7;
         var _loc6_:uint = param1.readUnsignedShort() & 4095;
         _loc5_ = _loc5_ - 2;
         param1.position = param1.position + _loc6_;
         _loc5_ = _loc5_ - _loc6_;
         while(_loc5_ > 4)
         {
            if(this.endParse)
            {
               param1.clear();
               break;
            }
            _loc7_ = param1.readUnsignedByte();
            _loc8_ = param1.readUnsignedShort() & 8191;
            _loc9_ = param1.readUnsignedShort() & 4095;
            _loc5_ = _loc5_ - 5;
            param1.position = param1.position + _loc9_;
            _loc5_ = _loc5_ - _loc9_;
            switch(_loc7_)
            {
               case 27:
                  this._videoPID = _loc8_;
                  continue;
               case 15:
                  this._audioPID = _loc8_;
                  continue;
               default:
                  continue;
            }
            break;
         }
      }
      
      public function flushFileSegment(param1:IDataInput) : ByteArray
      {
         var _loc2_:ByteArray = null;
         _loc2_ = new ByteArray();
         var _loc3_:ByteArray = null;
         var _loc4_:ByteArray = null;
         _loc3_ = this._videoPES.processES(false,null,true);
         _loc4_ = this._audioPES.processES(false,null,true);
         if(_loc3_)
         {
            _loc2_.readBytes(_loc3_);
         }
         if(_loc4_)
         {
            _loc2_.readBytes(_loc4_);
         }
         return _loc2_;
      }
   }
}
