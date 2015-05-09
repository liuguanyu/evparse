package com.as3.hls.plugin
{
   import com.as3.hls.es.MP2PESAudio;
   import com.as3.hls.es.MP2PESVideo;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class HLSPlugin extends Object
   {
      
      private var _cpuControl:uint = 30000;
      
      private var _syncFound:Boolean;
      
      private var _pmtPID:uint;
      
      private var _audioPID:uint;
      
      private var _videoPID:uint;
      
      private var _audioPES:MP2PESAudio;
      
      private var _videoPES:MP2PESVideo;
      
      private var _doubleBuffer:ByteArray;
      
      private var _cachedOutputBytes:ByteArray;
      
      private var alternatingYieldCounter:int = 0;
      
      public function HLSPlugin()
      {
         super();
         this._audioPES = new MP2PESAudio();
         this._videoPES = new MP2PESVideo();
         this._doubleBuffer = new ByteArray();
         this.alternatingYieldCounter = 0;
      }
      
      public function destroy() : void
      {
         this._audioPES = null;
         this._videoPES = null;
         if(this._doubleBuffer)
         {
            this._doubleBuffer.clear();
         }
         this._doubleBuffer = null;
         if(this._cachedOutputBytes)
         {
            this._cachedOutputBytes.clear();
         }
         this._cachedOutputBytes = null;
      }
      
      public function set cpuControl(param1:uint) : void
      {
         this._cpuControl = param1;
      }
      
      public function get cpuControl() : uint
      {
         return this._cpuControl;
      }
      
      public function processFileSegment(param1:IDataInput) : ByteArray
      {
         var _loc3_:ByteArray = null;
         var _loc4_:ByteArray = null;
         var _loc5_:ByteArray = null;
         var _loc2_:uint = param1.bytesAvailable;
         if(this._cachedOutputBytes !== null)
         {
            _loc3_ = this._cachedOutputBytes;
            this._cachedOutputBytes = null;
         }
         else
         {
            _loc3_ = new ByteArray();
         }
         while(true)
         {
            if(!this._syncFound)
            {
               if(param1.bytesAvailable < 1)
               {
                  break;
               }
               if(param1.readByte() == 71)
               {
                  this._syncFound = true;
               }
            }
            else
            {
               if(param1.bytesAvailable < 187)
               {
                  break;
               }
               this._syncFound = false;
               _loc4_ = new ByteArray();
               param1.readBytes(_loc4_,0,187);
               _loc5_ = this.processPacket(_loc4_);
               if(_loc5_ !== null)
               {
                  _loc3_.writeBytes(_loc5_);
               }
               if(_loc2_ - param1.bytesAvailable > this.cpuControl)
               {
                  this.alternatingYieldCounter = this.alternatingYieldCounter + 1 & 3;
                  if(this.alternatingYieldCounter & 1 === 1)
                  {
                     this._cachedOutputBytes = _loc3_;
                     return null;
                  }
                  break;
               }
            }
         }
         return _loc3_.length === 0?null:_loc3_;
      }
      
      public function endProcessFile(param1:IDataInput) : ByteArray
      {
         return null;
      }
      
      private function processPacket(param1:ByteArray) : ByteArray
      {
         var _loc11_:uint = 0;
         var _loc2_:uint = param1.readUnsignedByte();
         var _loc3_:Boolean = Boolean(_loc2_ & 128);
         var _loc4_:Boolean = Boolean(_loc2_ & 64);
         var _loc5_:Boolean = Boolean(_loc2_ & 32);
         _loc2_ = _loc2_ << 8;
         _loc2_ = _loc2_ + param1.readUnsignedByte();
         var _loc6_:uint = _loc2_ & 8191;
         _loc2_ = param1.readUnsignedByte();
         var _loc7_:uint = _loc2_ >> 6 & 3;
         var _loc8_:Boolean = Boolean(_loc2_ & 32);
         var _loc9_:Boolean = Boolean(_loc2_ & 16);
         var _loc10_:uint = _loc2_ & 15;
         if(_loc8_)
         {
            _loc11_ = param1.readUnsignedByte();
            param1.position = param1.position + _loc11_;
         }
         if(_loc9_)
         {
            return this.processES(_loc6_,_loc4_,param1);
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
            trace("PAT pointed to PMT that isn\'t PMT");
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
                  trace("unsupported type " + _loc7_.toString(16) + " in PMT");
                  continue;
            }
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
