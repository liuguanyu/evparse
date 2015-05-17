package com.pplive.p2p.mp4
{
	import flash.events.EventDispatcher;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import flash.utils.ByteArray;
	import flash.events.ProgressEvent;
	import com.pplive.p2p.events.SegmentCompleteEvent;
	import com.pplive.util.EventUtil;
	
	public class Mp4Stream extends EventDispatcher
	{
		
		private static var logger:ILogger = getLogger(Mp4Stream);
		
		private static const AVC_SEQUENCE_HEADER_PACKET:uint = 0;
		
		private static const AVC_NALU_PACKET:uint = 1;
		
		private static const AAC_SEQUENCE_HEADER_PACKET:uint = 0;
		
		private static const AAC_RAW_PACKET:uint = 1;
		
		private var hasError:Boolean = false;
		
		private var inputBuffer:ByteArray;
		
		private var outputBuffer:ByteArray;
		
		private var outputBufferPosition:uint;
		
		private var inputDataOffset:uint = 0;
		
		private var header:Mp4Header;
		
		private var hasMdatBoxHeader:Boolean = false;
		
		private var mdatBoxSize:uint;
		
		private var currentSample:Object;
		
		private var currentSampleIndex:uint = 0;
		
		private var currentSampleOffset:uint = 0;
		
		private var audioSyncSample:uint = 0;
		
		private var isSeek:Boolean = false;
		
		private var hasSendFlvHeader:Boolean = false;
		
		private var baseVideoTimeStamp:uint = 0;
		
		private var baseAudioTimeStamp:uint = 0;
		
		public function Mp4Stream()
		{
			this.inputBuffer = new ByteArray();
			this.outputBuffer = new ByteArray();
			super();
			this.header = new Mp4Header();
		}
		
		public function destroy() : void
		{
			this.inputBuffer = null;
			this.outputBuffer = null;
			this.header.destroy();
			this.header = null;
			this.currentSample = null;
		}
		
		public function get audioTrakCount() : uint
		{
			return this.header.audioTrakCount;
		}
		
		public function set audioTrak(param1:uint) : void
		{
			this.header.audioTrak = param1;
		}
		
		public function appendBytes(param1:ByteArray) : void
		{
			var _loc2:uint = param1.position;
			logger.debug("appendBytes " + param1.bytesAvailable + " bytes");
			if(!this.header.isComplete)
			{
				this.header.appendBytes(param1);
			}
			if(!this.header.isValid)
			{
				logger.error("header has Error!!!");
				return;
			}
			if(!this.isSeek && !this.hasMdatBoxHeader && !(param1.bytesAvailable == 0))
			{
				this.readAtMost(param1,this.inputBuffer,this.inputBuffer.length,8 - this.inputBuffer.length);
				if(this.inputBuffer.length == 8)
				{
					this.inputBuffer.position = 0;
					this.mdatBoxSize = this.inputBuffer.readUnsignedInt();
					this.hasMdatBoxHeader = true;
					this.inputBuffer.clear();
				}
			}
			this.inputDataOffset = this.inputDataOffset + (param1.position - _loc2);
			while(param1.bytesAvailable != 0)
			{
				_loc2 = param1.position;
				this.readOneSample(param1);
				this.inputDataOffset = this.inputDataOffset + (param1.position - _loc2);
			}
		}
		
		public function readBytes() : ByteArray
		{
			var _loc1:ByteArray = this.outputBuffer;
			_loc1.position = 0;
			this.outputBuffer = new ByteArray();
			return _loc1;
		}
		
		public function setBaseTimeStamp(param1:uint, param2:uint) : void
		{
			this.baseVideoTimeStamp = param1;
			this.baseAudioTimeStamp = param2;
			this.hasSendFlvHeader = true;
		}
		
		public function hasMp4Header() : Boolean
		{
			return this.header.isComplete;
		}
		
		public function getRealSeekTime(param1:Number, param2:Number) : Number
		{
			return this.header.getVideoSampleTime(this.header.getVideoSampleIndexFromTime(param1,param2));
		}
		
		public function seek(param1:Number, param2:Number) : uint
		{
			this.inputBuffer.clear();
			this.outputBuffer.clear();
			this.hasSendFlvHeader = false;
			this.currentSample = null;
			this.isSeek = true;
			var _loc3:uint = this.header.getVideoSampleIndexFromTime(param1,param2);
			var _loc4:int = this.header.getAudioSampleIndexFromVideoSampleIndex(_loc3);
			this.audioSyncSample = _loc4;
			var _loc5:uint = this.header.getSampleOffset(NMp4Header.VIDEO_SAMPLE_TYPE,_loc3);
			var _loc6:uint = this.header.getSampleOffset(NMp4Header.AUDIO_SAMPLE_TYPE,_loc4);
			if(_loc5 < _loc6)
			{
				while(_loc6 > _loc5 && _loc4 > 0)
				{
					_loc4--;
					_loc6 = this.header.getSampleOffset(NMp4Header.AUDIO_SAMPLE_TYPE,_loc4);
				}
				if(_loc4 == 0)
				{
					this.currentSampleIndex = _loc3;
				}
				else
				{
					this.currentSampleIndex = _loc3 + _loc4 + 1;
				}
				this.inputDataOffset = _loc5;
				return _loc5;
			}
			while(_loc5 > _loc6 && _loc3 > 0)
			{
				_loc3--;
				_loc5 = this.header.getSampleOffset(NMp4Header.VIDEO_SAMPLE_TYPE,_loc3);
			}
			if(_loc3 == 0)
			{
				this.currentSampleIndex = _loc4;
			}
			else
			{
				this.currentSampleIndex = _loc3 + _loc4 + 1;
			}
			this.inputDataOffset = _loc6;
			return _loc6;
		}
		
		public function get durationInMs() : uint
		{
			return this.header.durationInMs;
		}
		
		private function readOneSample(param1:ByteArray) : void
		{
			var _loc2:uint = 0;
			if(!this.hasSendFlvHeader)
			{
				this.assembleFlvHeader();
				this.hasSendFlvHeader = true;
			}
			if(this.currentSampleIndex < this.header.sampleCount)
			{
				if(!this.currentSample)
				{
					this.currentSample = this.header.getSample(this.currentSampleIndex);
					this.currentSampleOffset = this.header.getSampleOffset(this.currentSample.type,this.currentSample.index);
				}
				if(this.inputDataOffset < this.currentSampleOffset)
				{
					if(this.inputDataOffset + param1.bytesAvailable <= this.currentSampleOffset)
					{
						logger.debug("throw rubbish data " + param1.bytesAvailable + " bytes");
						param1.position = param1.length;
						return;
					}
					logger.debug("throw rubbish data " + (this.currentSampleOffset - this.inputDataOffset) + " bytes");
					param1.position = param1.position + (this.currentSampleOffset - this.inputDataOffset);
				}
				_loc2 = this.header.getSampleSize(this.currentSample.type,this.currentSample.index);
				this.readAtMost(param1,this.inputBuffer,this.inputBuffer.length,_loc2 - this.inputBuffer.length);
				if(this.inputBuffer.length == _loc2)
				{
					if(this.currentSample.type == NMp4Header.VIDEO_SAMPLE_TYPE)
					{
						this.assembleVideoTag();
					}
					else
					{
						this.assembleAudioTag();
					}
					this.inputBuffer.clear();
					this.currentSample = null;
					dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS,false,false));
					logger.debug("send sample " + this.currentSampleIndex + "/" + this.header.sampleCount);
					this.currentSampleIndex++;
					if(this.currentSampleIndex == this.header.sampleCount)
					{
						this.reportSegmentCompelete();
					}
				}
			}
			else
			{
				param1.position = param1.length;
				this.reportSegmentCompelete();
			}
		}
		
		private function reportSegmentCompelete() : void
		{
			var _loc1:SegmentCompleteEvent = new SegmentCompleteEvent(this.baseVideoTimeStamp + this.header.durationInMs,this.baseAudioTimeStamp + this.header.durationInMs);
			logger.info("moive complete! timestamp: " + _loc1.videoTimeStamp + ":" + _loc1.audioTimeStamp);
			EventUtil.deferDispatch(this,_loc1,50);
		}
		
		private function saveOutputPosition() : void
		{
			this.outputBufferPosition = this.outputBuffer.position;
			this.outputBuffer.position = this.outputBuffer.length;
		}
		
		private function restoreOutputPosition() : void
		{
			this.outputBuffer.position = this.outputBufferPosition;
		}
		
		private function assembleFlvHeader() : void
		{
			logger.info("assembleFlvHeader");
			this.saveOutputPosition();
			this.outputBuffer.writeByte(70);
			this.outputBuffer.writeByte(76);
			this.outputBuffer.writeByte(86);
			this.outputBuffer.writeByte(1);
			this.outputBuffer.writeByte(5);
			this.outputBuffer.writeInt(9);
			this.outputBuffer.writeInt(0);
			this.restoreOutputPosition();
		}
		
		private function assembleVideoTag() : void
		{
			var _loc1:Boolean = this.header.isVideoSyncSample(this.currentSample.index);
			var _loc2:uint = this.baseVideoTimeStamp + this.header.calcVideoTimeStamp(this.currentSample.index);
			if(_loc1)
			{
				this.assembleFlvTag(9,this.getAvcTagHeader(true,AVC_SEQUENCE_HEADER_PACKET,0,this.header.getAVCDecoderConfigurationRecord()),_loc2);
			}
			logger.debug("video sample " + this.currentSample.index + " ready, timestamp:" + _loc2 + "ms.");
			this.assembleFlvTag(9,this.getAvcTagHeader(_loc1,AVC_NALU_PACKET,this.header.getVideoSampleCompositionTimeInMs(this.currentSample.index),this.inputBuffer),_loc2);
		}
		
		private function getAvcTagHeader(param1:Boolean, param2:uint, param3:uint, param4:ByteArray) : ByteArray
		{
			var _loc5:ByteArray = new ByteArray();
			if(param1)
			{
				_loc5.writeByte(23);
			}
			else
			{
				_loc5.writeByte(39);
			}
			_loc5.writeByte(param2);
			_loc5.writeByte(param3 >> 16);
			_loc5.writeByte(param3 >> 8);
			_loc5.writeByte(param3);
			_loc5.writeBytes(param4);
			return _loc5;
		}
		
		private function assembleAudioTag() : void
		{
			var _loc1:uint = this.baseAudioTimeStamp + this.header.calcAudioTimeStamp(this.currentSample.index);
			if(this.currentSample.index == this.audioSyncSample)
			{
				this.assembleFlvTag(8,this.getAacTagHeader(AAC_SEQUENCE_HEADER_PACKET,this.header.getAudioSpecificConfig()),_loc1);
			}
			logger.debug("audio sample " + this.currentSample.index + " ready, timestamp:" + _loc1 + "ms.");
			this.assembleFlvTag(8,this.getAacTagHeader(AAC_RAW_PACKET,this.inputBuffer),_loc1);
		}
		
		private function getAacTagHeader(param1:uint, param2:ByteArray) : ByteArray
		{
			var _loc3:ByteArray = new ByteArray();
			_loc3.writeByte(10 << 4 | 3 << 2 | 2 | 1);
			_loc3.writeByte(param1);
			_loc3.writeBytes(param2);
			return _loc3;
		}
		
		private function assembleFlvTag(param1:uint, param2:ByteArray, param3:uint) : void
		{
			this.saveOutputPosition();
			this.outputBuffer.writeByte(param1);
			this.outputBuffer.writeByte(param2.length >> 16);
			this.outputBuffer.writeByte(param2.length >> 8);
			this.outputBuffer.writeByte(param2.length >> 0);
			this.outputBuffer.writeByte(param3 >> 16);
			this.outputBuffer.writeByte(param3 >> 8);
			this.outputBuffer.writeByte(param3 >> 0);
			this.outputBuffer.writeByte(param3 >> 24);
			this.outputBuffer.writeByte(0);
			this.outputBuffer.writeByte(0);
			this.outputBuffer.writeByte(0);
			this.outputBuffer.writeBytes(param2);
			this.outputBuffer.writeUnsignedInt(param2.length + 11);
			this.restoreOutputPosition();
		}
		
		private function readAtMost(param1:ByteArray, param2:ByteArray, param3:uint, param4:uint) : void
		{
			if(param1.bytesAvailable > param4)
			{
				param1.readBytes(param2,param3,param4);
			}
			else
			{
				param1.readBytes(param2,param3);
			}
		}
	}
}
