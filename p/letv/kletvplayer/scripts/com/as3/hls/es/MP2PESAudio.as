package com.as3.hls.es
{
   import flash.utils.ByteArray;
   import com.as3.hls.flv.FLVTagAudio;
   
   public final class MP2PESAudio extends MP2PESBase
   {
      
      private var _state:int;
      
      private var _haveNewTimestamp:Boolean = false;
      
      private var _audioTime:Number;
      
      private var _audioTimeIncr:Number;
      
      private var _profile:int;
      
      private var _sampleRateIndex:int;
      
      private var _channelConfig:int;
      
      private var _frameLength:int;
      
      private var _remaining:int;
      
      private var _adtsHeader:ByteArray;
      
      private var _needACHeader:Boolean;
      
      private var _audioData:ByteArray;
      
      private var srMap:Array;
      
      public function MP2PESAudio()
      {
         this.srMap = [96000,88200,64000,48000,44100,32000,24000,22050,16000,12000,11025,8000,7350];
         super();
         this._state = 0;
         this._adtsHeader = new ByteArray();
         this._needACHeader = true;
      }
      
      private function getIncrForSRI(param1:uint) : Number
      {
         var _loc2_:Number = this.srMap[param1];
         return 1024000 / _loc2_;
      }
      
      override public function processES(param1:Boolean, param2:ByteArray, param3:Boolean = false) : ByteArray
      {
         var _loc4_:uint = 0;
         var _loc5_:FLVTagAudio = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:* = NaN;
         var _loc11_:uint = 0;
         var _loc12_:ByteArray = null;
         var _loc13_:uint = 0;
         if(param1)
         {
            _loc4_ = param2.readUnsignedInt();
            param2.position = param2.position - 4;
            _loc7_ = param2.readUnsignedInt();
            if(!(_loc7_ == 448) && !(_loc7_ == 464))
            {
               throw new Error("PES start code not found or not AAC/AVC");
            }
            else
            {
               param2.position = param2.position + 3;
               _loc8_ = (param2.readUnsignedByte() & 192) >> 6;
               if(_loc8_ != 2)
               {
                  throw new Error("No PTS in this audio PES packet");
               }
               else
               {
                  _loc9_ = param2.readUnsignedByte();
                  _loc10_ = ((param2.readUnsignedByte() & 14) << 29) + ((param2.readUnsignedShort() & 65534) << 14) + ((param2.readUnsignedShort() & 65534) >> 1);
                  _timestamp = Math.round(_loc10_ / 90);
                  this._haveNewTimestamp = true;
                  _loc9_ = _loc9_ - 5;
                  param2.position = param2.position + _loc9_;
               }
            }
         }
         var _loc6_:ByteArray = new ByteArray();
         if(!param3)
         {
            _loc11_ = param2.position;
         }
         if(param3)
         {
            trace("audio flush at state " + this._state.toString());
         }
         else
         {
            while(param2.bytesAvailable > 0)
            {
               if(this._state < 7)
               {
                  _loc4_ = param2.readUnsignedByte();
                  this._adtsHeader[this._state] = _loc4_;
               }
               switch(this._state)
               {
                  case 0:
                     if(this._haveNewTimestamp)
                     {
                        this._audioTime = _timestamp;
                        this._haveNewTimestamp = false;
                     }
                     if(_loc4_ == 255)
                     {
                        this._state = 1;
                     }
                     else
                     {
                        trace("adts seek 0");
                     }
                     continue;
                  case 1:
                     if((_loc4_ & 240) != 240)
                     {
                        trace("adts seek 1");
                        this._state = 0;
                     }
                     else
                     {
                        this._state = 2;
                     }
                     continue;
                  case 2:
                     this._state = 3;
                     this._profile = _loc4_ >> 6 & 3;
                     this._sampleRateIndex = _loc4_ >> 2 & 15;
                     this._audioTimeIncr = this.getIncrForSRI(this._sampleRateIndex);
                     this._channelConfig = (_loc4_ & 1) << 2;
                     continue;
                  case 3:
                     this._state = 4;
                     this._channelConfig = this._channelConfig + (_loc4_ >> 6 & 3);
                     this._frameLength = (_loc4_ & 3) << 11;
                     continue;
                  case 4:
                     this._state = 5;
                     this._frameLength = this._frameLength + (_loc4_ << 3);
                     continue;
                  case 5:
                     this._state = 6;
                     this._frameLength = this._frameLength + ((_loc4_ & 224) >> 5);
                     this._remaining = this._frameLength - 7;
                     continue;
                  case 6:
                     this._state = 7;
                     _loc11_ = param2.position;
                     this._audioData = new ByteArray();
                     if(this._needACHeader)
                     {
                        _loc5_ = new FLVTagAudio();
                        _loc5_.timestamp = this._audioTime;
                        _loc5_.soundFormat = FLVTagAudio.SOUND_FORMAT_AAC;
                        _loc5_.soundChannels = FLVTagAudio.SOUND_CHANNELS_STEREO;
                        _loc5_.soundRate = FLVTagAudio.SOUND_RATE_44K;
                        _loc5_.soundSize = FLVTagAudio.SOUND_SIZE_16BITS;
                        _loc5_.isAACSequenceHeader = true;
                        _loc12_ = new ByteArray();
                        this._adtsHeader.length = 4;
                        _loc5_.data = this._adtsHeader;
                        this._needACHeader = false;
                        _loc5_.write(_loc6_);
                     }
                     continue;
                  case 7:
                     if(param2.length - _loc11_ >= this._remaining)
                     {
                        param2.position = param2.position + this._remaining;
                        this._remaining = 0;
                     }
                     else
                     {
                        _loc13_ = param2.length - _loc11_;
                        param2.position = param2.position + _loc13_;
                        this._remaining = this._remaining - _loc13_;
                        this._audioData.writeBytes(param2,_loc11_,param2.position - _loc11_);
                     }
                     if(this._remaining <= 0)
                     {
                        this._audioData.writeBytes(param2,_loc11_,param2.position - _loc11_);
                        this._state = 0;
                        _loc5_ = new FLVTagAudio();
                        _loc5_.timestamp = this._audioTime;
                        this._audioTime = this._audioTime + this._audioTimeIncr;
                        _loc5_.soundChannels = FLVTagAudio.SOUND_CHANNELS_STEREO;
                        _loc5_.soundFormat = FLVTagAudio.SOUND_FORMAT_AAC;
                        _loc5_.isAACSequenceHeader = false;
                        _loc5_.soundRate = FLVTagAudio.SOUND_RATE_44K;
                        _loc5_.soundSize = FLVTagAudio.SOUND_SIZE_16BITS;
                        _loc5_.data = this._audioData;
                        _loc5_.write(_loc6_);
                     }
                     continue;
                  default:
                     continue;
               }
            }
         }
         _loc6_.position = 0;
         return _loc6_;
      }
   }
}
