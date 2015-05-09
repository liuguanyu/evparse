package com.as3.hls.es
{
   import flash.utils.ByteArray;
   import com.as3.hls.flv.FLVTagVideo;
   
   public final class MP2PESVideo extends MP2PESBase
   {
      
      private var _nalData:ByteArray;
      
      private var _vTag:FLVTagVideo;
      
      private var _vTagData:ByteArray;
      
      private var _scState:int;
      
      public function MP2PESVideo()
      {
         super();
         this._scState = 0;
         this._nalData = new ByteArray();
         this._vTag = null;
         this._vTagData = null;
      }
      
      override public function processES(param1:Boolean, param2:ByteArray, param3:Boolean = false) : ByteArray
      {
         var _loc5_:H264NALU = null;
         var _loc8_:Vector.<FLVTagVideo> = null;
         var _loc9_:FLVTagVideo = null;
         var _loc10_:FLVTagVideo = null;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc14_:* = NaN;
         var _loc15_:* = NaN;
         var _loc16_:uint = 0;
         var _loc17_:uint = 0;
         var _loc18_:* = NaN;
         var _loc19_:* = NaN;
         var _loc20_:ByteArray = null;
         if(param1)
         {
            if(param2.readUnsignedInt() != 480)
            {
               throw new Error("PES start code not found or not AAC/AVC");
            }
            else
            {
               param2.position = param2.position + 3;
               _loc12_ = (param2.readUnsignedByte() & 192) >> 6;
               if(_loc12_ & !(3 === 3))
               {
                  trace("video PES packet without both PTS and DTS");
               }
               if(!(_loc12_ == 3) && !(_loc12_ == 2))
               {
                  throw new Error("video PES packet without PTS cannot be decoded");
               }
               else
               {
                  _loc13_ = param2.readUnsignedByte();
                  _loc14_ = ((param2.readUnsignedByte() & 14) << 29) + ((param2.readUnsignedShort() & 65534) << 14) + ((param2.readUnsignedShort() & 65534) >> 1);
                  _loc13_ = _loc13_ - 5;
                  if(_loc12_ == 3)
                  {
                     _loc15_ = ((param2.readUnsignedByte() & 14) << 29) + ((param2.readUnsignedShort() & 65534) << 14) + ((param2.readUnsignedShort() & 65534) >> 1);
                     _timestamp = Math.round(_loc15_ / 90);
                     _compositionTime = Math.round(_loc14_ / 90) - _timestamp;
                     _loc13_ = _loc13_ - 5;
                  }
                  else
                  {
                     _timestamp = Math.round(_loc14_ / 90);
                     _compositionTime = 0;
                  }
                  param2.position = param2.position + _loc13_;
               }
            }
         }
         if(!param3)
         {
            _loc16_ = param2.position;
         }
         var _loc4_:Vector.<H264NALU> = new Vector.<H264NALU>();
         if(param3)
         {
            _loc5_ = new H264NALU(this._nalData);
            if(_loc5_.NALtype != 0)
            {
               _loc4_.push(_loc5_);
               trace("pushed one flush nal of type " + _loc5_.NALtype.toString());
            }
            this._nalData = new ByteArray();
         }
         else
         {
            while(param2.bytesAvailable > 0)
            {
               _loc17_ = param2.readUnsignedByte();
               switch(this._scState)
               {
                  case 0:
                     if(_loc17_ == 0)
                     {
                        this._scState = 1;
                     }
                     continue;
                  case 1:
                     if(_loc17_ == 0)
                     {
                        this._scState = 2;
                     }
                     else
                     {
                        this._scState = 0;
                     }
                     continue;
                  case 2:
                     if(_loc17_ != 0)
                     {
                        if(_loc17_ == 1)
                        {
                           this._nalData.writeBytes(param2,_loc16_,param2.position - _loc16_);
                           _loc16_ = param2.position;
                           if(this._nalData.length > 4)
                           {
                              this._nalData.length = this._nalData.length - 3;
                              _loc5_ = new H264NALU(this._nalData);
                              if(_loc5_.NALtype != 0)
                              {
                                 _loc4_.push(_loc5_);
                              }
                           }
                           else
                           {
                              trace("length too short! = " + this._nalData.length.toString());
                           }
                           this._nalData = new ByteArray();
                           this._scState = 0;
                        }
                        else
                        {
                           this._scState = 0;
                        }
                     }
                     continue;
                  default:
                     this._scState = 0;
                     continue;
               }
            }
         }
         if(!param3 && param2.position - _loc16_ > 0)
         {
            this._nalData.writeBytes(param2,_loc16_,param2.position - _loc16_);
         }
         var _loc6_:H264NALU = null;
         var _loc7_:H264NALU = null;
         for each(_loc5_ in _loc4_)
         {
            switch(_loc5_.NALtype)
            {
               case 7:
                  _loc6_ = _loc5_;
                  continue;
               case 8:
                  _loc7_ = _loc5_;
                  continue;
               default:
                  continue;
            }
         }
         _loc8_ = new Vector.<FLVTagVideo>();
         _loc10_ = null;
         if((_loc6_) && (_loc7_))
         {
            _loc18_ = _loc6_.length;
            _loc19_ = _loc7_.length;
            _loc9_ = new FLVTagVideo();
            _loc9_.timestamp = _timestamp;
            _loc9_.codecID = FLVTagVideo.CODEC_ID_AVC;
            _loc9_.frameType = FLVTagVideo.FRAME_TYPE_KEYFRAME;
            _loc9_.avcPacketType = FLVTagVideo.AVC_PACKET_TYPE_SEQUENCE_HEADER;
            _loc20_ = new ByteArray();
            _loc20_.writeByte(1);
            _loc20_.writeBytes(_loc6_.NALdata,1,3);
            _loc20_.writeByte(255);
            _loc20_.writeByte(225);
            _loc20_.writeByte(_loc18_ >> 8);
            _loc20_.writeByte(_loc18_);
            _loc20_.writeBytes(_loc6_.NALdata,0,_loc18_);
            _loc20_.writeByte(1);
            _loc20_.writeByte(_loc19_ >> 8);
            _loc20_.writeByte(_loc19_);
            _loc20_.writeBytes(_loc7_.NALdata,0,_loc19_);
            _loc9_.data = _loc20_;
            _loc8_.push(_loc9_);
            _loc10_ = _loc9_;
         }
         for each(_loc5_ in _loc4_)
         {
            if(_loc5_.NALtype == 9)
            {
               if((this._vTag) && this._vTagData.length == 0)
               {
                  trace("zero-length vtag");
                  if(_loc10_)
                  {
                     trace(" avccts " + _loc10_.timestamp.toString() + " vtagts " + this._vTag.timestamp.toString());
                  }
               }
               if((this._vTag) && this._vTagData.length > 0)
               {
                  this._vTag.data = this._vTagData;
                  _loc8_.push(this._vTag);
                  if(_loc10_)
                  {
                     _loc10_.timestamp = this._vTag.timestamp;
                     _loc10_ = null;
                  }
               }
               this._vTag = new FLVTagVideo();
               this._vTagData = new ByteArray();
               this._vTagData.writeUnsignedInt(_loc5_.length);
               this._vTagData.writeBytes(_loc5_.NALdata);
               this._vTag.codecID = FLVTagVideo.CODEC_ID_AVC;
               this._vTag.frameType = FLVTagVideo.FRAME_TYPE_INTER;
               this._vTag.avcPacketType = FLVTagVideo.AVC_PACKET_TYPE_NALU;
               this._vTag.timestamp = _timestamp;
               this._vTag.avcCompositionTimeOffset = _compositionTime;
            }
            else if(!(_loc5_.NALtype == 7) && !(_loc5_.NALtype == 8))
            {
               if(this._vTag == null)
               {
                  trace("needed to create vtag");
                  this._vTag = new FLVTagVideo();
                  this._vTagData = new ByteArray();
                  this._vTag.codecID = FLVTagVideo.CODEC_ID_AVC;
                  this._vTag.frameType = FLVTagVideo.FRAME_TYPE_INTER;
                  this._vTag.avcPacketType = FLVTagVideo.AVC_PACKET_TYPE_NALU;
                  this._vTag.timestamp = _timestamp;
                  this._vTag.avcCompositionTimeOffset = _compositionTime;
               }
               if(_loc5_.NALtype == 5)
               {
                  this._vTag.frameType = FLVTagVideo.FRAME_TYPE_KEYFRAME;
               }
               this._vTagData.writeUnsignedInt(_loc5_.length);
               this._vTagData.writeBytes(_loc5_.NALdata);
            }
            
         }
         if(param3)
         {
            trace(" *** VIDEO FLUSH CALLED");
            if((this._vTag) && this._vTagData.length > 0)
            {
               this._vTag.data = this._vTagData;
               _loc8_.push(this._vTag);
               if(_loc10_)
               {
                  _loc10_.timestamp = this._vTag.timestamp;
                  _loc10_ = null;
               }
               trace("flushing one vtag");
            }
            this._vTag = null;
         }
         var _loc11_:ByteArray = new ByteArray();
         for each(_loc9_ in _loc8_)
         {
            _loc9_.write(_loc11_);
         }
         return _loc11_;
      }
   }
}
