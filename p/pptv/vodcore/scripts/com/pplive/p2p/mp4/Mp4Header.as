package com.pplive.p2p.mp4
{
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import flash.utils.ByteArray;
	import de.polygonal.ds.ArrayUtil;
	
	class Mp4Header extends Object
	{
		
		private static var logger:ILogger = getLogger(Mp4Header);
		
		private static const VIDEO_TRAK_BOX_TYPE:int = 1;
		
		private static const AUDIO_TRAK_BOX_TYPE:int = 2;
		
		public static const VIDEO_SAMPLE_TYPE:uint = 1;
		
		public static const AUDIO_SAMPLE_TYPE:uint = 2;
		
		private var _hasError:Boolean = false;
		
		private var inputBuffer:ByteArray;
		
		private var hasFtypBox:Boolean = false;
		
		private var hasMoovBox:Boolean = false;
		
		private var trakTimeScale:uint;
		
		private var trakBoxType:int;
		
		private var videoSampleCount:uint;
		
		private var videoSampleDeltaArray:Array;
		
		private var videoSampleSize:Vector.<uint>;
		
		private var videoSampleCompositionTime:Vector.<uint>;
		
		private var videoSampleOffsetArray:Vector.<uint>;
		
		private var videoSyncSample:Array;
		
		private var videoChunkInfo:Array;
		
		private var videoChunks:Array;
		
		private var videoChunkOffset:Vector.<uint>;
		
		private var videoTimeScale:uint;
		
		private var videoDeltaSum:uint;
		
		private var videoDuration:uint;
		
		private var audioSampleCount:uint;
		
		private var audioSampleDeltaArray:Array;
		
		private var audioSampleSize:Vector.<uint>;
		
		private var audioSampleOffsetArray:Vector.<uint>;
		
		private var audioChunkInfo:Array;
		
		private var audioChunks:Array;
		
		private var audioChunkOffset:Vector.<uint>;
		
		private var audioTimeScale:uint;
		
		private var samples:Array;
		
		private var AVCDecoderConfigurationRecord:ByteArray;
		
		private var AudioSpecificConfig:ByteArray;
		
		function Mp4Header()
		{
			this.inputBuffer = new ByteArray();
			this.videoSampleSize = new Vector.<uint>();
			this.videoSampleOffsetArray = new Vector.<uint>();
			this.videoSyncSample = new Array();
			this.videoChunkInfo = new Array();
			this.videoChunks = new Array();
			this.videoChunkOffset = new Vector.<uint>();
			this.audioSampleSize = new Vector.<uint>();
			this.audioSampleOffsetArray = new Vector.<uint>();
			this.audioChunkInfo = new Array();
			this.audioChunks = new Array();
			this.audioChunkOffset = new Vector.<uint>();
			this.samples = new Array();
			super();
		}
		
		public function destroy() : void
		{
			this.inputBuffer = null;
			if(this.videoSampleDeltaArray)
			{
				this.videoSampleDeltaArray.length = 0;
				this.videoSampleDeltaArray = null;
			}
			this.videoSampleSize.length = 0;
			this.videoSampleSize = null;
			if(this.videoSampleCompositionTime != null)
			{
				this.videoSampleCompositionTime.length = 0;
				this.videoSampleCompositionTime = null;
			}
			this.videoSampleOffsetArray.length = 0;
			this.videoSampleOffsetArray = null;
			this.videoSyncSample.length = 0;
			this.videoSyncSample = null;
			this.videoChunkInfo.length = 0;
			this.videoChunkInfo = null;
			this.videoChunks.length = 0;
			this.videoChunks = null;
			this.videoChunkOffset.length = 0;
			this.videoChunkOffset = null;
			if(this.audioSampleDeltaArray)
			{
				this.audioSampleDeltaArray.length = 0;
				this.audioSampleDeltaArray = null;
			}
			this.audioSampleSize.length = 0;
			this.audioSampleSize = null;
			this.audioSampleOffsetArray.length = 0;
			this.audioSampleOffsetArray = null;
			this.audioChunkInfo.length = 0;
			this.audioChunkInfo = null;
			this.audioChunks.length = 0;
			this.audioChunks = null;
			this.audioChunkOffset.length = 0;
			this.audioChunkOffset = null;
			this.samples.length = 0;
			this.samples = null;
			this.AVCDecoderConfigurationRecord = null;
			this.AudioSpecificConfig = null;
		}
		
		public function appendBytes(param1:ByteArray) : void
		{
			var _loc2:* = 0;
			var _loc3:* = 0;
			var _loc4:uint = 0;
			logger.debug("appendBytes " + param1.length + " bytes, available:" + param1.bytesAvailable);
			if(!this.hasFtypBox && !(param1.bytesAvailable == 0))
			{
				_loc2 = param1.readInt();
				logger.debug("ftypBoxLength:" + _loc2);
				param1.position = param1.position + (_loc2 - 4);
				this.hasFtypBox = true;
			}
			if(!this.hasMoovBox && !(param1.bytesAvailable == 0))
			{
				if(this.inputBuffer.length == 0)
				{
					param1.readBytes(this.inputBuffer,0,4);
				}
				this.inputBuffer.position = 0;
				_loc3 = this.inputBuffer.readInt();
				logger.debug("moovBoxLength:" + _loc3);
				this.inputBuffer.position = this.inputBuffer.length;
				_loc4 = _loc3 - this.inputBuffer.length;
				if(param1.bytesAvailable > _loc4)
				{
					param1.readBytes(this.inputBuffer,this.inputBuffer.position,_loc4);
				}
				else
				{
					param1.readBytes(this.inputBuffer,this.inputBuffer.position);
				}
				if(this.inputBuffer.length == _loc3)
				{
					this.hasMoovBox = true;
					if(!this.parseMoovBox())
					{
						this._hasError = true;
						logger.error("Header has Error!!!");
					}
					else
					{
						logger.info("Header is OK");
					}
				}
			}
		}
		
		public function get isComplete() : Boolean
		{
			return (this.hasMoovBox) && !this._hasError;
		}
		
		public function get isValid() : Boolean
		{
			return !this._hasError;
		}
		
		public function get sampleCount() : uint
		{
			return this.samples.length;
		}
		
		public function set audioTrak(param1:uint) : void
		{
		}
		
		public function get audioTrakCount() : uint
		{
			return 0;
		}
		
		public function getSample(param1:uint) : Object
		{
			return this.samples[param1];
		}
		
		public function getVideoSampleIndexFromTime(param1:Number, param2:Number) : uint
		{
			var _loc3:uint = this.getIndexInVideoSyncSampleTable(param1);
			var _loc4:uint = this.getIndexInVideoSyncSampleTable(param2);
			if(_loc3 == _loc4)
			{
				if(param1 + 0.1 < param2)
				{
					if(_loc4 < this.videoSyncSample.length - 1)
					{
						_loc4++;
					}
				}
				else if(param2 + 0.1 < param1)
				{
					if(_loc4 > 0)
					{
						_loc4--;
					}
				}
				
			}
			return this.videoSyncSample[_loc4] - 1;
		}
		
		private function getIndexInVideoSyncSampleTable(param1:Number) : uint
		{
			var _loc2:* = 0;
			var _loc3:int = ArrayUtil.bsearchInt(this.videoSampleDeltaArray,param1 * this.videoTimeScale,0,this.videoSampleDeltaArray.length - 1);
			if(_loc3 >= 0)
			{
				_loc2 = _loc3;
			}
			else
			{
				_loc2 = ~_loc3;
				if(_loc2 > this.videoSampleDeltaArray.length - 1)
				{
					_loc2 = this.videoSampleDeltaArray.length - 1;
				}
			}
			var _loc4:int = ArrayUtil.bsearchInt(this.videoSyncSample,_loc2 + 1,0,this.videoSyncSample.length - 1);
			if(_loc4 < 0)
			{
				_loc4 = ~_loc4;
				if(_loc4 > this.videoSyncSample.length - 1)
				{
					_loc4 = this.videoSyncSample.length - 1;
				}
				else if(_loc4 > 0)
				{
					_loc4--;
				}
				
			}
			return _loc4;
		}
		
		public function getVideoSampleTime(param1:uint) : Number
		{
			return this.calcVideoTimeStamp(param1) / 1000;
		}
		
		public function get durationInMs() : uint
		{
			return this.videoDuration;
		}
		
		public function getIndexFromVideoIndex(param1:uint) : uint
		{
			var _loc2:int = this.calcVideoTimeStamp(param1) * this.audioTimeScale / 1000;
			var _loc3:int = ArrayUtil.bsearchInt(this.audioSampleDeltaArray,_loc2,0,this.audioSampleDeltaArray.length - 1);
			if(_loc3 < 0)
			{
				_loc3 = ~_loc3;
				_loc3--;
			}
			if(this.audioSampleOffsetArray[_loc3] < this.videoSampleOffsetArray[param1])
			{
				while(_loc3 < this.audioSampleOffsetArray.length && this.audioSampleOffsetArray[_loc3] < this.videoSampleOffsetArray[param1])
				{
					_loc3++;
				}
			}
			else
			{
				while(_loc3 > 0 && this.audioSampleOffsetArray[_loc3 - 1] > this.videoSampleOffsetArray[param1])
				{
					_loc3--;
				}
			}
			return param1 + _loc3;
		}
		
		public function getAudioSampleIndexFromVideoSampleIndex(param1:uint) : uint
		{
			var _loc2:int = this.calcVideoTimeStamp(param1) * this.audioTimeScale / 1000;
			var _loc3:int = ArrayUtil.bsearchInt(this.audioSampleDeltaArray,_loc2,0,this.audioSampleDeltaArray.length - 1);
			if(_loc3 < 0)
			{
				_loc3 = ~_loc3;
				_loc3--;
			}
			return _loc3;
		}
		
		public function calcVideoTimeStamp(param1:uint) : uint
		{
			return this.videoSampleDeltaArray[param1] * 1000 / this.videoTimeScale;
		}
		
		public function calcAudioTimeStamp(param1:uint) : uint
		{
			return this.audioSampleDeltaArray[param1] * 1000 / this.audioTimeScale;
		}
		
		public function getSampleOffset(param1:uint, param2:uint) : uint
		{
			if(param1 == VIDEO_SAMPLE_TYPE)
			{
				return this.videoSampleOffsetArray[param2];
			}
			return this.audioSampleOffsetArray[param2];
		}
		
		public function getSampleSize(param1:uint, param2:uint) : uint
		{
			if(param1 == VIDEO_SAMPLE_TYPE)
			{
				return this.videoSampleSize[param2];
			}
			return this.audioSampleSize[param2];
		}
		
		public function isVideoSyncSample(param1:uint) : Boolean
		{
			return ArrayUtil.bsearchInt(this.videoSyncSample,param1 + 1,0,this.videoSyncSample.length - 1) >= 0;
		}
		
		public function getVideoSampleCompositionTimeInMs(param1:uint) : uint
		{
			return this.videoSampleCompositionTime == null?0:this.videoSampleCompositionTime[param1] * 1000 / this.videoTimeScale;
		}
		
		public function getAVCDecoderConfigurationRecord() : ByteArray
		{
			return this.AVCDecoderConfigurationRecord;
		}
		
		public function getAudioSpecificConfig() : ByteArray
		{
			return this.AudioSpecificConfig;
		}
		
		private function parseMoovBox() : Boolean
		{
			this.inputBuffer.position = 0;
			if(this.recusiveParseBox(this.inputBuffer.length))
			{
				this.assembleSamples();
				this.inputBuffer.clear();
				return true;
			}
			return false;
		}
		
		private function recusiveParseBox(param1:int) : Boolean
		{
			var _loc2:uint = 0;
			var _loc3:String = null;
			while(this.inputBuffer.position < param1 && this.inputBuffer.bytesAvailable >= 8)
			{
				_loc2 = this.inputBuffer.readUnsignedInt() - 8;
				_loc3 = this.inputBuffer.readUTFBytes(4);
				if(this.inputBuffer.bytesAvailable >= _loc2 - 8)
				{
					this.parseBox(_loc3,this.inputBuffer.position + _loc2);
					continue;
				}
				return false;
			}
			return this.inputBuffer.position == param1;
		}
		
		private function parseBox(param1:String, param2:uint) : void
		{
			logger.debug("parseBox: " + param1 + ", boxEndPosition: " + param2);
			if(param1 == "moov" || param1 == "trak" || param1 == "mdia" || param1 == "minf" || param1 == "stbl")
			{
				this.recusiveParseBox(param2);
			}
			else if(param1 == "mdhd")
			{
				this.parseMdhdBox(param2);
			}
			else if(param1 == "hdlr")
			{
				this.parseHdlrBox(param2);
			}
			else if(param1 == "stsd")
			{
				this.parseStsdBox(param2);
			}
			else if(param1 == "avc1")
			{
				this.parseAvc1Box(param2);
			}
			else if(param1 == "avcC")
			{
				this.parseAvccBox(param2);
			}
			else if(param1 == "mp4a")
			{
				this.parseMp4aBox(param2);
			}
			else if(param1 == "esds")
			{
				this.parseEsdsBox(param2);
			}
			else if(param1 == "stts")
			{
				this.parseSttsBox(param2);
			}
			else if(param1 == "ctts")
			{
				this.parseCttsBox(param2);
			}
			else if(param1 == "stss")
			{
				this.parseStssBox(param2);
			}
			else if(param1 == "stsz")
			{
				this.parseStszBox(param2);
			}
			else if(param1 == "stsc")
			{
				this.parseStscBox(param2);
			}
			else if(param1 == "stco")
			{
				this.parseStcoBox(param2);
			}
			else
			{
				this.inputBuffer.position = param2;
			}
			
			
			
			
			
			
			
			
			
			
			
			
			
		}
		
		private function parseMdhdBox(param1:uint) : void
		{
			var _loc2:uint = this.inputBuffer.readUnsignedInt();
			if(_loc2 == 0)
			{
				this.inputBuffer.position = this.inputBuffer.position + 8;
				this.trakTimeScale = this.inputBuffer.readUnsignedInt();
				this.inputBuffer.position = param1;
			}
			else if(_loc2 == 1)
			{
				this.inputBuffer.position = this.inputBuffer.position + 16;
				this.trakTimeScale = this.inputBuffer.readUnsignedInt();
				this.inputBuffer.position = param1;
			}
			
		}
		
		private function parseHdlrBox(param1:uint) : void
		{
			this.inputBuffer.position = this.inputBuffer.position + 8;
			var _loc2:String = this.inputBuffer.readUTFBytes(4);
			if(_loc2 == "vide")
			{
				this.trakBoxType = VIDEO_TRAK_BOX_TYPE;
				this.videoTimeScale = this.trakTimeScale;
			}
			else if(_loc2 == "soun")
			{
				this.trakBoxType = AUDIO_TRAK_BOX_TYPE;
				this.audioTimeScale = this.trakTimeScale;
			}
			else
			{
				this.trakBoxType = -1;
			}
			
			this.inputBuffer.position = param1;
		}
		
		private function parseStsdBox(param1:uint) : void
		{
			this.inputBuffer.position = this.inputBuffer.position + 8;
			this.recusiveParseBox(param1);
		}
		
		private function parseAvc1Box(param1:uint) : void
		{
			this.inputBuffer.position = this.inputBuffer.position + 78;
			this.recusiveParseBox(param1);
		}
		
		private function parseAvccBox(param1:uint) : void
		{
			this.AVCDecoderConfigurationRecord = new ByteArray();
			this.inputBuffer.readBytes(this.AVCDecoderConfigurationRecord,0,param1 - this.inputBuffer.position);
		}
		
		private function parseMp4aBox(param1:uint) : void
		{
			this.inputBuffer.position = this.inputBuffer.position + 28;
			this.recusiveParseBox(param1);
		}
		
		private function parseEsdsBox(param1:uint) : void
		{
			var _loc2:uint = 0;
			var _loc3:uint = 0;
			var _loc4:* = 0;
			var _loc5:* = 0;
			var _loc6:* = 0;
			var _loc7:* = 0;
			var _loc8:* = 0;
			this.inputBuffer.readUnsignedInt();
			while(this.inputBuffer.position < param1)
			{
				_loc2 = this.inputBuffer.readUnsignedByte();
				switch(_loc2)
				{
					case 3:
						_loc3 = this.readVariableBitsUInt(this.inputBuffer);
						this.inputBuffer.position = this.inputBuffer.position + 2;
						_loc4 = this.inputBuffer.readUnsignedByte();
						_loc5 = _loc4 >> 7;
						_loc6 = (_loc4 & 64) >> 6;
						_loc7 = (_loc4 & 32) >> 5;
						if(_loc5)
						{
							this.inputBuffer.position = this.inputBuffer.position + 2;
						}
						if(_loc6)
						{
							_loc8 = this.inputBuffer.readUnsignedByte();
							this.inputBuffer.position = this.inputBuffer.position + _loc8;
						}
						if(_loc7)
						{
							this.inputBuffer.position = this.inputBuffer.position + 2;
						}
						continue;
					case 4:
						_loc3 = this.readVariableBitsUInt(this.inputBuffer);
						this.inputBuffer.position = this.inputBuffer.position + 13;
						continue;
					case 5:
						_loc3 = this.readVariableBitsUInt(this.inputBuffer);
						this.AudioSpecificConfig = new ByteArray();
						this.inputBuffer.readBytes(this.AudioSpecificConfig,0,_loc3);
						this.inputBuffer.position = param1;
						continue;
					default:
						continue;
				}
			}
		}
		
		private function readVariableBitsUInt(param1:ByteArray) : uint
		{
			var _loc4:uint = 0;
			var _loc2:uint = 0;
			var _loc3:uint = 0;
			do
			{
				_loc4 = param1.readUnsignedByte();
				_loc3++;
				_loc2 = _loc2 << 7 | _loc4 & 127;
			}
			while((_loc4 & 128) && _loc3 < 4);
			
			return _loc2;
		}
		
		private function parseSttsBox(param1:uint) : void
		{
			var _loc4:uint = 0;
			var _loc8:uint = 0;
			var _loc9:uint = 0;
			this.inputBuffer.position = this.inputBuffer.position + 4;
			var _loc2:uint = this.inputBuffer.readUnsignedInt();
			var _loc3:uint = 0;
			var _loc5:Array = new Array();
			var _loc6:uint = 0;
			var _loc7:uint = 0;
			while(_loc7 < _loc2)
			{
				_loc8 = this.inputBuffer.readUnsignedInt();
				_loc4 = this.inputBuffer.readUnsignedInt();
				_loc3 = _loc3 + _loc8;
				_loc9 = 0;
				while(_loc9 < _loc8)
				{
					_loc5.push(_loc6);
					_loc6 = _loc6 + _loc4;
					_loc9++;
				}
				_loc7++;
			}
			if(this.trakBoxType == VIDEO_TRAK_BOX_TYPE)
			{
				this.videoSampleCount = _loc3;
				this.videoSampleDeltaArray = _loc5;
				this.videoDeltaSum = _loc6;
			}
			else if(this.trakBoxType == AUDIO_TRAK_BOX_TYPE)
			{
				this.audioSampleCount = _loc3;
				this.audioSampleDeltaArray = _loc5;
			}
			
		}
		
		private function parseCttsBox(param1:uint) : void
		{
			var _loc4:uint = 0;
			var _loc5:uint = 0;
			var _loc6:uint = 0;
			this.videoSampleCompositionTime = new Vector.<uint>();
			this.inputBuffer.position = this.inputBuffer.position + 4;
			var _loc2:uint = this.inputBuffer.readUnsignedInt();
			var _loc3:uint = 0;
			while(_loc3 < _loc2)
			{
				_loc4 = this.inputBuffer.readUnsignedInt();
				_loc5 = this.inputBuffer.readUnsignedInt();
				_loc6 = 0;
				while(_loc6 < _loc4)
				{
					this.videoSampleCompositionTime.push(_loc5);
					_loc6++;
				}
				_loc3++;
			}
		}
		
		private function parseStssBox(param1:uint) : void
		{
			this.inputBuffer.position = this.inputBuffer.position + 4;
			var _loc2:uint = this.inputBuffer.readUnsignedInt();
			var _loc3:uint = 0;
			while(_loc3 < _loc2)
			{
				this.videoSyncSample.push(this.inputBuffer.readUnsignedInt());
				_loc3++;
			}
		}
		
		private function parseStszBox(param1:uint) : void
		{
			var _loc4:uint = 0;
			this.inputBuffer.position = this.inputBuffer.position + 4;
			var _loc2:uint = this.inputBuffer.readUnsignedInt();
			var _loc3:uint = this.inputBuffer.readUnsignedInt();
			if(this.trakBoxType == VIDEO_TRAK_BOX_TYPE)
			{
				if(_loc2 == 0)
				{
					_loc4 = 0;
					while(_loc4 < _loc3)
					{
						this.videoSampleSize.push(this.inputBuffer.readUnsignedInt());
						_loc4++;
					}
				}
				else
				{
					_loc4 = 0;
					while(_loc4 < _loc3)
					{
						this.videoSampleSize.push(_loc2);
						_loc4++;
					}
				}
			}
			else if(this.trakBoxType == AUDIO_TRAK_BOX_TYPE)
			{
				if(_loc2 == 0)
				{
					_loc4 = 0;
					while(_loc4 < _loc3)
					{
						this.audioSampleSize.push(this.inputBuffer.readUnsignedInt());
						_loc4++;
					}
				}
				else
				{
					_loc4 = 0;
					while(_loc4 < _loc3)
					{
						this.audioSampleSize.push(_loc2);
						_loc4++;
					}
				}
			}
			
		}
		
		private function parseStscBox(param1:uint) : void
		{
			var _loc4:Object = null;
			this.inputBuffer.position = this.inputBuffer.position + 4;
			var _loc2:uint = this.inputBuffer.readUnsignedInt();
			var _loc3:uint = 0;
			while(_loc3 < _loc2)
			{
				_loc4 = new Object();
				_loc4.firstChunk = this.inputBuffer.readUnsignedInt() - 1;
				_loc4.samplesPerChunk = this.inputBuffer.readUnsignedInt();
				_loc4.sampleDescriptionIndex = this.inputBuffer.readUnsignedInt();
				if(this.trakBoxType == VIDEO_TRAK_BOX_TYPE)
				{
					this.videoChunkInfo.push(_loc4);
				}
				else if(this.trakBoxType == AUDIO_TRAK_BOX_TYPE)
				{
					this.audioChunkInfo.push(_loc4);
				}
				
				_loc3++;
			}
		}
		
		private function parseStcoBox(param1:uint) : void
		{
			this.inputBuffer.position = this.inputBuffer.position + 4;
			var _loc2:uint = this.inputBuffer.readUnsignedInt();
			var _loc3:uint = 0;
			while(_loc3 < _loc2)
			{
				if(this.trakBoxType == VIDEO_TRAK_BOX_TYPE)
				{
					this.videoChunkOffset.push(this.inputBuffer.readUnsignedInt());
				}
				else if(this.trakBoxType == AUDIO_TRAK_BOX_TYPE)
				{
					this.audioChunkOffset.push(this.inputBuffer.readUnsignedInt());
				}
				
				_loc3++;
			}
		}
		
		private function assembleSamples() : void
		{
			var _loc8:* = false;
			var _loc9:uint = 0;
			var _loc10:Object = null;
			var _loc11:uint = 0;
			var _loc12:Object = null;
			this.videoDuration = this.videoDeltaSum / this.videoTimeScale * 1000;
			this.assembleChunks(VIDEO_TRAK_BOX_TYPE);
			this.assembleChunks(AUDIO_TRAK_BOX_TYPE);
			var _loc1:uint = 0;
			var _loc2:uint = 0;
			var _loc3:uint = 0;
			var _loc4:uint = 0;
			var _loc5:uint = 0;
			var _loc6:uint = this.videoChunks.length;
			var _loc7:uint = this.audioChunks.length;
			while(_loc5 < _loc6 + _loc7)
			{
				_loc8 = true;
				if(_loc1 == _loc6)
				{
					_loc8 = false;
				}
				else if(!(_loc3 == _loc7) && this.audioChunks[_loc3].offset < this.videoChunks[_loc1].offset)
				{
					_loc8 = false;
				}
				
				_loc9 = 0;
				if(_loc8)
				{
					_loc12 = this.videoChunks[_loc1];
					_loc11 = _loc12.offset;
					_loc9 = 0;
					while(_loc9 < _loc12.sampleCount)
					{
						this.videoSampleOffsetArray.push(_loc11);
						_loc11 = _loc11 + this.videoSampleSize[_loc2];
						_loc10 = new Object();
						_loc10.type = VIDEO_SAMPLE_TYPE;
						_loc10.index = _loc2++;
						this.samples.push(_loc10);
						_loc9++;
					}
					_loc1++;
				}
				else
				{
					_loc12 = this.audioChunks[_loc3];
					_loc11 = _loc12.offset;
					_loc9 = 0;
					while(_loc9 < _loc12.sampleCount)
					{
						this.audioSampleOffsetArray.push(_loc11);
						_loc11 = _loc11 + this.audioSampleSize[_loc4];
						_loc10 = new Object();
						_loc10.type = AUDIO_SAMPLE_TYPE;
						_loc10.index = _loc4++;
						this.samples.push(_loc10);
						_loc9++;
					}
					_loc3++;
				}
				_loc5++;
			}
			this.logMediaInfo();
		}
		
		private function logMediaInfo() : void
		{
			logger.info("duration: " + this.videoDuration + " ms" + "\ntotal sample count:" + this.samples.length + "\nvideo sample count: " + this.videoSampleSize.length + "\naudio sample count:" + this.audioSampleSize.length);
		}
		
		private function assembleChunks(param1:uint) : void
		{
			var _loc2:Array = null;
			var _loc3:uint = 0;
			var _loc4:Vector.<uint> = null;
			var _loc5:Array = null;
			var _loc10:Object = null;
			if(param1 == VIDEO_TRAK_BOX_TYPE)
			{
				_loc2 = this.videoChunkInfo;
				_loc3 = this.videoSampleCount;
				_loc4 = this.videoChunkOffset;
				_loc5 = this.videoChunks;
			}
			else
			{
				_loc2 = this.audioChunkInfo;
				_loc3 = this.audioSampleCount;
				_loc4 = this.audioChunkOffset;
				_loc5 = this.audioChunks;
			}
			var _loc6:uint = 0;
			var _loc7:uint = 0;
			var _loc8:uint = _loc2.length;
			var _loc9:uint = 0;
			while(_loc9 < _loc8)
			{
				while(_loc9 != _loc8 - 1?_loc7 < _loc2[_loc9 + 1].firstChunk:_loc6 < _loc3)
				{
					_loc10 = new Object();
					_loc10.firstSample = _loc6;
					_loc10.sampleCount = _loc2[_loc9].samplesPerChunk;
					_loc10.offset = _loc4[_loc7];
					_loc5.push(_loc10);
					_loc7++;
					_loc6 = _loc6 + _loc10.sampleCount;
				}
				_loc9++;
			}
		}
	}
}
