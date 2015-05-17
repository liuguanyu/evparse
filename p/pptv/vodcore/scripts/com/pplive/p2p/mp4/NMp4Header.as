package com.pplive.p2p.mp4
{
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import flash.utils.ByteArray;
	import com.pplive.p2p.mp4.boxes.*;
	import de.polygonal.ds.ArrayUtil;
	
	public class NMp4Header extends Object
	{
		
		private static var logger:ILogger = getLogger(NMp4Header);
		
		public static const VIDEO_SAMPLE_TYPE:uint = 1;
		
		public static const AUDIO_SAMPLE_TYPE:uint = 2;
		
		private static const VIDEO_TRAK_BOX_TYPE:int = 1;
		
		private static const AUDIO_TRAK_BOX_TYPE:int = 2;
		
		private var _boxes:Vector.<Box>;
		
		private var _input:ByteArray;
		
		private var _isValid:Boolean = true;
		
		private var _moovBox:MoovBox;
		
		private var _samples:Array;
		
		private var _video:TrakInfo;
		
		private var _audio:TrakInfo;
		
		private var _audioTable:Vector.<TrakInfo>;
		
		private var _audioIndex:uint;
		
		private var _durationInMs:uint;
		
		public function NMp4Header()
		{
			this._boxes = new Vector.<Box>();
			this._input = new ByteArray();
			this._samples = new Array();
			this._audioTable = new Vector.<TrakInfo>();
			super();
		}
		
		public function destroy() : void
		{
		}
		
		public function get isValid() : Boolean
		{
			return this._isValid;
		}
		
		public function get isComplete() : Boolean
		{
			return !(this._moovBox == null);
		}
		
		public function get audioTrakCount() : uint
		{
			return this._audioTable.length;
		}
		
		public function get durationInMs() : uint
		{
			return this._durationInMs;
		}
		
		public function set audioTrak(param1:uint) : void
		{
			this._audioIndex = param1;
			if(param1 < this._audioTable.length)
			{
				this._audio = this._audioTable[param1];
				this.assembleSamples();
			}
		}
		
		public function appendBytes(param1:ByteArray) : void
		{
			var b:Box = null;
			var box:Box = null;
			var bytes:ByteArray = param1;
			if((this.isComplete) || !this.isValid)
			{
				return;
			}
			var pos:uint = this._input.position;
			this._input.position = this._input.length;
			this._input.writeBytes(bytes);
			this._input.position = pos;
			logger.debug("append, header length: " + this._input.length);
			try
			{
				while(true)
				{
					box = Box.parseBox(this._input,this._input.length);
					if(box == null)
					{
						break;
					}
					this._boxes.push(box);
				}
				for each(b in this._boxes)
				{
					if(b.type == "moov")
					{
						this._moovBox = b as MoovBox;
						break;
					}
				}
				if(this._moovBox != null)
				{
					this.assemble();
				}
			}
			catch(e:*)
			{
				_isValid = false;
			}
		}
		
		public function get sampleCount() : uint
		{
			return this._samples.length;
		}
		
		public function getSample(param1:uint) : Object
		{
			return this._samples[param1];
		}
		
		public function getVideoSampleIndexFromTime(param1:Number) : uint
		{
			var _loc2:int = ArrayUtil.bsearchInt(this._video.sampleDeltaArray,param1 * this._video.timeScale,0,this._video.sampleDeltaArray.length - 1);
			if(_loc2 < 0)
			{
				_loc2 = ~_loc2;
				if(_loc2 > this._video.sampleDeltaArray.length - 1)
				{
					_loc2 = this._video.sampleDeltaArray.length - 1;
				}
			}
			var _loc3:int = ArrayUtil.bsearchInt(this._video.syncSample,_loc2 + 1,0,this._video.syncSample.length - 1);
			if(_loc3 >= 0)
			{
				return _loc2;
			}
			_loc3 = ~_loc3;
			if(_loc3 >= this._video.syncSample.length - 1)
			{
				return this._video.syncSample[this._video.syncSample.length - 1] - 1;
			}
			if(_loc3 == 0)
			{
				return this._video.syncSample[0] - 1;
			}
			var _loc4:uint = _loc2 + 1 - this._video.syncSample[_loc3 - 1];
			var _loc5:uint = this._video.syncSample[_loc3] - (_loc2 + 1);
			return _loc4 < _loc5?this._video.syncSample[_loc3 - 1] - 1:this._video.syncSample[_loc3] - 1;
		}
		
		public function getVideoSampleTime(param1:uint) : Number
		{
			return this.calcVideoTimeStamp(param1) / 1000;
		}
		
		public function getAudioSampleIndexFromVideoSampleIndex(param1:uint) : uint
		{
			var _loc2:int = this.calcVideoTimeStamp(param1) * this._audio.timeScale / 1000;
			var _loc3:int = ArrayUtil.bsearchInt(this._audio.sampleDeltaArray,_loc2,0,this._audio.sampleDeltaArray.length - 1);
			if(_loc3 < 0)
			{
				_loc3 = ~_loc3;
				_loc3--;
			}
			return _loc3;
		}
		
		public function calcVideoTimeStamp(param1:Number) : Number
		{
			return this._video.sampleDeltaArray[param1] * 1000 / this._video.timeScale;
		}
		
		public function calcAudioTimeStamp(param1:uint) : uint
		{
			return this._audio.sampleDeltaArray[param1] * 1000 / this._audio.timeScale;
		}
		
		public function getSampleOffset(param1:uint, param2:uint) : uint
		{
			if(param1 == VIDEO_SAMPLE_TYPE)
			{
				return this._video.sampleOffsetArray[param2];
			}
			return this._audio.sampleOffsetArray[param2];
		}
		
		public function getSampleSize(param1:uint, param2:uint) : uint
		{
			return param1 == VIDEO_SAMPLE_TYPE?this._video.sampleSize[param2]:this._audio.sampleSize[param2];
		}
		
		public function isVideoSyncSample(param1:uint) : Boolean
		{
			return ArrayUtil.bsearchInt(this._video.syncSample,param1 + 1,0,this._video.syncSample.length - 1) >= 0;
		}
		
		public function getVideoSampleCompositionTimeInMs(param1:uint) : uint
		{
			return this._video.sampleCompositionTime == null?0:this._video.sampleCompositionTime[param1] * 1000 / this._video.timeScale;
		}
		
		public function getAVCDecoderConfigurationRecord() : ByteArray
		{
			return this._video.AVCDecoderConfigurationRecord;
		}
		
		public function getAudioSpecificConfig() : ByteArray
		{
			return this._audio.AudioSpecificConfig;
		}
		
		private function assemble() : void
		{
			var _loc1:Box = null;
			var _loc2:TrakInfo = null;
			for each(_loc1 in this._moovBox.subBoxes)
			{
				if(_loc1 is TrakBox)
				{
					_loc2 = this.assembleTrakInfo(_loc1 as TrakBox);
					if(_loc2 != null)
					{
						if(_loc2.isVideo)
						{
							this._video = _loc2;
						}
						else
						{
							this._audioTable.push(_loc2);
						}
					}
				}
			}
			if(this._audioTable.length > 0)
			{
				this._audio = this._audioIndex < this._audioTable.length?this._audioTable[this._audioIndex]:this._audioTable[0];
			}
			if(this._video == null || this._audio == null)
			{
				this._isValid = false;
				return;
			}
			this._durationInMs = this._video.deltaSum / this._video.timeScale * 1000;
			this.assembleSamples();
		}
		
		private function assembleTrakInfo(param1:TrakBox) : TrakInfo
		{
			var _loc2:TrakInfo = new TrakInfo();
			var _loc3:HdlrBox = param1.getDescendant(["mdia","hdlr"]) as HdlrBox;
			if(!_loc3.isAudio && !_loc3.isVideo)
			{
				logger.warn("unknown hdlr box: " + _loc3.handler);
				return null;
			}
			_loc2.isVideo = _loc3.isVideo;
			var _loc4:MdhdBox = param1.getDescendant(["mdia","mdhd"]) as MdhdBox;
			_loc2.timeScale = _loc4.timeScale;
			var _loc5:StblBox = param1.getDescendant(["mdia","minf","stbl"]) as StblBox;
			var _loc6:SttsBox = _loc5.getChild("stts") as SttsBox;
			_loc2.sampleCount = _loc6.sampleCount;
			_loc2.sampleDeltaArray = _loc6.sampleDeltaArray;
			_loc2.deltaSum = _loc6.deltaSum;
			var _loc7:StszBox = _loc5.getChild("stsz") as StszBox;
			_loc2.sampleSize = _loc7.sampleSizeTable;
			var _loc8:CttsBox = _loc5.getChild("ctts") as CttsBox;
			if(_loc8 != null)
			{
				_loc2.sampleCompositionTime = _loc8.sampleCompositionTimeTable;
			}
			var _loc9:StssBox = _loc5.getChild("stss") as StssBox;
			if(_loc9)
			{
				_loc2.syncSample = _loc9.syncSample;
			}
			var _loc10:StscBox = _loc5.getChild("stsc") as StscBox;
			_loc2.chunkInfo = _loc10.chunkInfoTable;
			var _loc11:StcoBox = _loc5.getChild("stco") as StcoBox;
			_loc2.chunkOffset = _loc11.chunkOffsetTable;
			var _loc12:AvcCBox = param1.getDescendant(["mdia","minf","stbl","stsd","avc1","avcC"]) as AvcCBox;
			if(_loc12 != null)
			{
				_loc2.AVCDecoderConfigurationRecord = _loc12.AVCDecoderConfigurationRecord;
			}
			var _loc13:EsdsBox = param1.getDescendant(["mdia","minf","stbl","stsd","mp4a","esds"]) as EsdsBox;
			if(_loc13 != null)
			{
				_loc2.AudioSpecificConfig = _loc13.AudioSpecificConfig;
			}
			this.assembleChunks(_loc2);
			return _loc2;
		}
		
		private function assembleSamples() : void
		{
			var _loc8:* = false;
			var _loc9:uint = 0;
			var _loc10:Object = null;
			var _loc11:uint = 0;
			var _loc12:Object = null;
			this._samples.length = 0;
			var _loc1:uint = 0;
			var _loc2:uint = 0;
			var _loc3:uint = 0;
			var _loc4:uint = 0;
			var _loc5:uint = 0;
			var _loc6:uint = this._video.chunks.length;
			var _loc7:uint = this._audio.chunks.length;
			while(_loc5 < _loc6 + _loc7)
			{
				_loc8 = true;
				if(_loc1 == _loc6)
				{
					_loc8 = false;
				}
				else if(!(_loc3 == _loc7) && this._audio.chunks[_loc3].offset < this._video.chunks[_loc1].offset)
				{
					_loc8 = false;
				}
				
				_loc9 = 0;
				if(_loc8)
				{
					_loc12 = this._video.chunks[_loc1];
					_loc11 = _loc12.offset;
					_loc9 = 0;
					while(_loc9 < _loc12.sampleCount)
					{
						this._video.sampleOffsetArray.push(_loc11);
						_loc11 = _loc11 + this._video.sampleSize[_loc2];
						_loc10 = new Object();
						_loc10.type = VIDEO_SAMPLE_TYPE;
						_loc10.index = _loc2++;
						this._samples.push(_loc10);
						_loc9++;
					}
					_loc1++;
				}
				else
				{
					_loc12 = this._audio.chunks[_loc3];
					_loc11 = _loc12.offset;
					_loc9 = 0;
					while(_loc9 < _loc12.sampleCount)
					{
						this._audio.sampleOffsetArray.push(_loc11);
						_loc11 = _loc11 + this._audio.sampleSize[_loc4];
						_loc10 = new Object();
						_loc10.type = AUDIO_SAMPLE_TYPE;
						_loc10.index = _loc4++;
						this._samples.push(_loc10);
						_loc9++;
					}
					_loc3++;
				}
				_loc5++;
			}
		}
		
		private function assembleChunks(param1:TrakInfo) : void
		{
			var _loc6:Object = null;
			var _loc2:uint = 0;
			var _loc3:uint = 0;
			var _loc4:uint = param1.chunkInfo.length;
			var _loc5:uint = 0;
			while(_loc5 < _loc4)
			{
				while(_loc5 != _loc4 - 1?_loc3 < param1.chunkInfo[_loc5 + 1].firstChunk:_loc2 < param1.sampleCount)
				{
					_loc6 = new Object();
					_loc6.firstSample = _loc2;
					_loc6.sampleCount = param1.chunkInfo[_loc5].samplesPerChunk;
					_loc6.offset = param1.chunkOffset[_loc3];
					param1.chunks.push(_loc6);
					_loc3++;
					_loc2 = _loc2 + _loc6.sampleCount;
				}
				_loc5++;
			}
		}
	}
}

import flash.utils.ByteArray;

class TrakInfo extends Object
{
	
	public var isVideo:Boolean;
	
	public var sampleCount:uint;
	
	public var sampleDeltaArray:Array;
	
	public var sampleSize:Vector.<uint>;
	
	public var sampleCompositionTime:Vector.<uint>;
	
	public var sampleOffsetArray:Vector.<uint>;
	
	public var syncSample:Array;
	
	public var chunkInfo:Array;
	
	public var chunks:Array;
	
	public var chunkOffset:Vector.<uint>;
	
	public var timeScale:uint;
	
	public var deltaSum:uint;
	
	public var AVCDecoderConfigurationRecord:ByteArray;
	
	public var AudioSpecificConfig:ByteArray;
	
	function TrakInfo()
	{
		this.sampleSize = new Vector.<uint>();
		this.sampleOffsetArray = new Vector.<uint>();
		this.syncSample = new Array();
		this.chunkInfo = new Array();
		this.chunks = new Array();
		this.chunkOffset = new Vector.<uint>();
		super();
	}
}
