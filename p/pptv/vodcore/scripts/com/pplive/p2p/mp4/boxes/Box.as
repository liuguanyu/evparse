package com.pplive.p2p.mp4.boxes
{
	import flash.utils.ByteArray;
	
	public class Box extends Object
	{
		
		public function Box()
		{
			super();
		}
		
		public static function readVariableBitsUInt(param1:ByteArray) : uint
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
		
		public static function parseBox(param1:ByteArray, param2:uint) : Box
		{
			if(param2 < param1.position + 8)
			{
				return null;
			}
			var _loc3:uint = param1.readUnsignedInt();
			if(_loc3 < 8)
			{
				throw new InvalidBoxError();
			}
			else
			{
				if(param2 < param1.position + _loc3 - 4)
				{
					param1.position = param1.position - 4;
					return null;
				}
				var _loc4:String = param1.readUTFBytes(4);
				var _loc5:Box = createBox(_loc4);
				var param2:uint = param1.position + _loc3 - 8;
				_loc5.parse(param1,param2);
				if(param1.position > param2)
				{
					throw new InvalidBoxError();
				}
				else
				{
					param1.position = param2;
					return _loc5;
				}
			}
		}
		
		public static function createBox(param1:String) : Box
		{
			switch(param1)
			{
				case "ftyp":
					return new FtypBox();
				case "moov":
					return new MoovBox();
				case "trak":
					return new TrakBox();
				case "mdia":
					return new MdiaBox();
				case "minf":
					return new MinfBox();
				case "stbl":
					return new StblBox();
				case "mdhd":
					return new MdhdBox();
				case "hdlr":
					return new HdlrBox();
				case "stsd":
					return new StsdBox();
				case "avc1":
					return new Avc1Box();
				case "avcC":
					return new AvcCBox();
				case "mp4a":
					return new Mp4aBox();
				case "esds":
					return new EsdsBox();
				case "stts":
					return new SttsBox();
				case "ctts":
					return new CttsBox();
				case "stss":
					return new StssBox();
				case "stsz":
					return new StszBox();
				case "stsc":
					return new StscBox();
				case "stco":
					return new StcoBox();
				default:
					return new UnusedBox();
			}
		}
		
		public function get type() : String
		{
			return "";
		}
		
		public function parse(param1:ByteArray, param2:uint) : void
		{
		}
	}
}

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
	
	public function destory() : void
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
				if(!false)
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
	
	public function isComplete() : Boolean
	{
		return (this.hasMoovBox) && !this._hasError;
	}
	
	public function hasError() : Boolean
	{
		return this._hasError;
	}
	
	public function getSampleCount() : uint
	{
		return this.samples.length;
	}
	
	public function getSample(param1:uint) : Object
	{
		return this.samples[param1];
	}
	
	public function getVideoSampleIndexFromTime(param1:uint) : uint
	{
		var _loc2:* = 0;
		var _loc5:uint = 0;
		var _loc6:uint = 0;
		var _loc7:uint = 0;
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
		if(_loc4 >= 0)
		{
			_loc5 = _loc2;
		}
		else
		{
			_loc4 = ~_loc4;
			if(_loc4 > this.videoSyncSample.length - 1)
			{
				_loc5 = this.videoSyncSample[this.videoSyncSample.length - 1] - 1;
			}
			else
			{
				_loc6 = _loc2 + 1 - this.videoSyncSample[_loc4 - 1];
				_loc7 = this.videoSyncSample[_loc4] - (_loc2 + 1);
				if(_loc6 < _loc7)
				{
					_loc5 = this.videoSyncSample[_loc4 - 1] - 1;
				}
				else
				{
					_loc5 = this.videoSyncSample[_loc4] - 1;
				}
			}
		}
		return _loc5;
	}
	
	public function getVideoSampleTime(param1:uint) : Number
	{
		return this.calcVideoTimeStamp(param1) / 1000;
	}
	
	public function getDurationInMs() : uint
	{
		return this.videoDuration;
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
