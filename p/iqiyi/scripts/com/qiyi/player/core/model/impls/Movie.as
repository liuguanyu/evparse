package com.qiyi.player.core.model.impls
{
	import flash.events.EventDispatcher;
	import com.qiyi.player.core.model.IMovie;
	import com.qiyi.player.base.pub.EnumItem;
	import flash.utils.Dictionary;
	import com.qiyi.player.core.model.remote.RequestEnjoyableSkipPointsRemote;
	import com.qiyi.player.core.player.coreplayer.ICorePlayer;
	import com.qiyi.player.base.logging.ILogger;
	import com.qiyi.player.core.model.IAudioTrackInfo;
	import com.qiyi.player.core.model.IDefinitionInfo;
	import com.qiyi.player.core.model.events.MovieEvent;
	import com.qiyi.player.core.model.ISkipPointInfo;
	import com.qiyi.player.base.rpc.RemoteObjectEvent;
	import com.qiyi.player.user.impls.UserManager;
	import com.qiyi.player.user.impls.UserLocalSex;
	import com.qiyi.player.user.UserDef;
	import com.qiyi.player.core.model.def.SkipPointEnum;
	import flash.events.Event;
	import com.qiyi.player.user.UserManagerEvent;
	import com.qiyi.player.base.utils.Utility;
	import com.qiyi.player.core.model.def.StreamEnum;
	import com.qiyi.player.core.model.def.ScreenEnum;
	import com.qiyi.player.core.model.def.DefinitionControlTypeEnum;
	import flash.utils.getTimer;
	import com.qiyi.player.core.model.def.DefinitionEnum;
	import com.qiyi.player.base.rpc.RemoteObjectStatusEnum;
	import com.qiyi.player.base.logging.Log;
	
	public class Movie extends EventDispatcher implements IMovie
	{
		
		private var _ver:String = "0";
		
		private var _nextVid:String;
		
		private var _nextTvid:String;
		
		private var _status:String;
		
		private var _source:Object;
		
		private var _audioTrackVec:Vector.<AudioTrack>;
		
		private var _curAudioTrack:AudioTrack;
		
		private var _curDefinition:Definition;
		
		private var _curSegment:Segment;
		
		private var _streamType:EnumItem;
		
		private var _screenType:EnumItem;
		
		private var _screenInfoVec:Vector.<ScreenInfo>;
		
		private var _tvid:String;
		
		private var _albumId:String;
		
		private var _logoId:String = "";
		
		private var _logoPosition:int;
		
		private var _ctgId:int;
		
		private var _ipLimited:Boolean = false;
		
		private var _titleTime:int = -1;
		
		private var _trailerTime:int = -1;
		
		private var _member:Boolean = false;
		
		private var _channelID:int;
		
		private var _forceAD:Boolean = false;
		
		private var _skipPointVec:Vector.<SkipPointInfo>;
		
		private var _enjoyableMap:Dictionary;
		
		private var _enjoyableDurationMap:Dictionary;
		
		private var _curEnjoyableSubType:EnumItem;
		
		private var _curEnjoyableSubDurationIndex:int = -1;
		
		private var _requestEnjoyableSkipPointsRemote:RequestEnjoyableSkipPointsRemote;
		
		private var _uploaderID:String = "";
		
		private var _exclusive:Boolean = false;
		
		private var _holder:ICorePlayer;
		
		private var _seekTime:Number = 0;
		
		private var _defControlType:EnumItem;
		
		private var _defControlList:Array;
		
		private var _defControlStartTime:int = -1;
		
		private var _defControlEndTime:int = -1;
		
		private var _log:ILogger;
		
		public function Movie(param1:Object, param2:Boolean, param3:ICorePlayer)
		{
			this._log = Log.getLogger("com.qiyi.player.core.model.impls.Movie");
			super();
			this._source = param1;
			this._member = param2;
			this._holder = param3;
			this._enjoyableMap = new Dictionary();
			this._enjoyableDurationMap = new Dictionary();
			this._defControlType = DefinitionControlTypeEnum.NONE;
			this._defControlList = new Array();
			this.parse();
		}
		
		public function get ver() : String
		{
			return this._ver;
		}
		
		public function get nextVid() : String
		{
			return this._nextVid;
		}
		
		public function get nextTvid() : String
		{
			return this._nextTvid;
		}
		
		public function get status() : String
		{
			return this._status;
		}
		
		public function get source() : Object
		{
			return this._source;
		}
		
		public function get audioTrackCount() : int
		{
			if(this._audioTrackVec)
			{
				return this._audioTrackVec.length;
			}
			return 0;
		}
		
		public function get curAudioTrack() : AudioTrack
		{
			return this._curAudioTrack;
		}
		
		public function get curAudioTrackInfo() : IAudioTrackInfo
		{
			return this._curAudioTrack;
		}
		
		public function get curDefinition() : Definition
		{
			return this._curDefinition;
		}
		
		public function get curDefinitionInfo() : IDefinitionInfo
		{
			return this._curDefinition;
		}
		
		public function get ready() : Boolean
		{
			if(this._curDefinition)
			{
				return this._curDefinition.ready;
			}
			return false;
		}
		
		public function get logoId() : String
		{
			return this._logoId;
		}
		
		public function get logoPosition() : int
		{
			return this._logoPosition;
		}
		
		public function get ctgId() : int
		{
			return this._ctgId;
		}
		
		public function get channelID() : int
		{
			return this._channelID;
		}
		
		public function get member() : Boolean
		{
			return this._member;
		}
		
		public function get vid() : String
		{
			if(this._curDefinition)
			{
				return this._curDefinition.vid;
			}
			return "";
		}
		
		public function get tvid() : String
		{
			return this._tvid;
		}
		
		public function get albumId() : String
		{
			return this._albumId;
		}
		
		public function get curSegment() : Segment
		{
			return this._curSegment;
		}
		
		public function get ipLimited() : Boolean
		{
			return this._ipLimited;
		}
		
		public function get duration() : Number
		{
			if(this._curDefinition)
			{
				return this._curDefinition.duration;
			}
			return 0;
		}
		
		public function get streamType() : EnumItem
		{
			return this._streamType;
		}
		
		public function get screenType() : EnumItem
		{
			return this._screenType;
		}
		
		public function get screenInfoCount() : int
		{
			if(this._screenInfoVec)
			{
				return this._screenInfoVec.length;
			}
			return 0;
		}
		
		public function get skipPointInfoCount() : int
		{
			if(this._skipPointVec)
			{
				return this._skipPointVec.length;
			}
			return 0;
		}
		
		public function get curEnjoyableSubDurationIndex() : int
		{
			return this._curEnjoyableSubDurationIndex;
		}
		
		public function get width() : int
		{
			if(this._curDefinition)
			{
				return this._curDefinition.flvWidth;
			}
			return 0;
		}
		
		public function get height() : int
		{
			if(this._curDefinition)
			{
				return this._curDefinition.flvHeight;
			}
			return 0;
		}
		
		public function get titlesTime() : Number
		{
			return this._titleTime;
		}
		
		public function get trailerTime() : Number
		{
			return this._trailerTime;
		}
		
		public function get forceAD() : Boolean
		{
			return this._forceAD;
		}
		
		public function get uploaderID() : String
		{
			return this._uploaderID;
		}
		
		public function get exclusive() : Boolean
		{
			return this._exclusive;
		}
		
		public function get curEnjoyableSubType() : EnumItem
		{
			return this._curEnjoyableSubType;
		}
		
		public function get qualityDefinitionControlType() : EnumItem
		{
			return this._defControlType;
		}
		
		public function get qualityDefinitionControlList() : Array
		{
			return this._defControlList;
		}
		
		public function get qualityDefinitionControlTimeRange() : Object
		{
			return {
				"st":this._defControlStartTime,
				"et":this._defControlEndTime
			};
		}
		
		public function setCurAudioTrack(param1:EnumItem, param2:EnumItem) : void
		{
			var _loc3:AudioTrack = this.getAudioTrackByType(param1);
			if((_loc3) && !(_loc3 == this._curAudioTrack))
			{
				this._curAudioTrack = _loc3;
				this.setCurDefinition(param2);
			}
		}
		
		public function setCurDefinition(param1:EnumItem) : void
		{
			var _loc2:Definition = null;
			if(this._curAudioTrack)
			{
				_loc2 = this._curAudioTrack.findDefinitionByType(param1);
				if((_loc2) && !(_loc2 == this._curDefinition))
				{
					if(this._curDefinition)
					{
						this._curDefinition.removeEventListener(MovieEvent.Evt_Ready,this.onDefinitionReady);
						this._curDefinition.removeEventListener(MovieEvent.Evt_Meta_Ready,this.onDefinitionMetaReady);
					}
					this._curDefinition = _loc2;
					this._curDefinition.addEventListener(MovieEvent.Evt_Ready,this.onDefinitionReady);
					this._curDefinition.addEventListener(MovieEvent.Evt_Meta_Ready,this.onDefinitionMetaReady);
					if(this._curDefinition.metaIsReady)
					{
						this.updateSkipPointInfo();
						dispatchEvent(new MovieEvent(MovieEvent.Evt_UpdateSkipPoint));
					}
					this.seek(this._seekTime);
				}
			}
		}
		
		public function hasVid(param1:String) : Boolean
		{
			var _loc2:Definition = null;
			if(this._curAudioTrack)
			{
				_loc2 = this._curAudioTrack.findDefinitionByVid(param1);
				return !(_loc2 == null);
			}
			return false;
		}
		
		public function hasDefinitionByType(param1:EnumItem) : Boolean
		{
			var _loc2:Definition = null;
			if(this._curAudioTrack)
			{
				_loc2 = this._curAudioTrack.findDefinitionByType(param1,true);
				return !(_loc2 == null);
			}
			return false;
		}
		
		public function seek(param1:Number) : void
		{
			this._seekTime = param1;
			this._curSegment = this.getSegmentByTime(param1);
			if(this._curSegment)
			{
				this._curSegment.seek(param1);
			}
		}
		
		public function getSeekTime() : Number
		{
			return this._seekTime;
		}
		
		public function getAudioTrackAt(param1:int) : AudioTrack
		{
			var _loc2:* = 0;
			if(this._audioTrackVec)
			{
				_loc2 = this._audioTrackVec.length;
				if(param1 >= 0 && param1 < _loc2)
				{
					return this._audioTrackVec[param1];
				}
			}
			return null;
		}
		
		public function getAudioTrackInfoAt(param1:int) : IAudioTrackInfo
		{
			return this.getAudioTrackAt(param1);
		}
		
		public function getAudioTrackByType(param1:EnumItem) : AudioTrack
		{
			var _loc2:* = 0;
			var _loc3:AudioTrack = null;
			var _loc4:* = 0;
			if(this._audioTrackVec)
			{
				_loc2 = this._audioTrackVec.length;
				_loc3 = null;
				_loc4 = 0;
				_loc4 = 0;
				while(_loc4 < _loc2)
				{
					_loc3 = this._audioTrackVec[_loc4];
					if((_loc3) && _loc3.type == param1)
					{
						return _loc3;
					}
					_loc4++;
				}
				_loc4 = 0;
				while(_loc4 < _loc2)
				{
					_loc3 = this._audioTrackVec[_loc4];
					if((_loc3) && (_loc3.isDefault))
					{
						return _loc3;
					}
					_loc4++;
				}
				if(_loc2 > 0)
				{
					return this._audioTrackVec[0];
				}
			}
			return null;
		}
		
		public function getAudioTrackInfoByType(param1:EnumItem) : IAudioTrackInfo
		{
			return this.getAudioTrackByType(param1);
		}
		
		public function getSegmentByTime(param1:Number) : Segment
		{
			var _loc3:* = 0;
			var _loc4:* = 0;
			var _loc2:Segment = null;
			if(this._curDefinition)
			{
				_loc3 = this._curDefinition.segmentCount;
				_loc4 = 0;
				while(_loc4 < _loc3)
				{
					_loc2 = this._curDefinition.findSegmentAt(_loc4);
					if((_loc2) && param1 <= _loc2.endTime)
					{
						return _loc2;
					}
					_loc4++;
				}
				_loc2 = this._curDefinition.findSegmentAt(_loc3 - 1);
			}
			return _loc2;
		}
		
		public function getKeyframeByTime(param1:Number) : Keyframe
		{
			var _loc2:Segment = this.getSegmentByTime(param1);
			if(_loc2)
			{
				return _loc2.getKeyframeByTime(param1);
			}
			return null;
		}
		
		public function getVidByDefinition(param1:EnumItem, param2:Boolean = false) : String
		{
			var _loc3:Definition = null;
			if(this._curAudioTrack)
			{
				_loc3 = this._curAudioTrack.findDefinitionByType(param1,param2);
				if(_loc3)
				{
					return _loc3.vid;
				}
			}
			return "";
		}
		
		public function getScreenInfoAt(param1:int) : ScreenInfo
		{
			if(this._screenInfoVec)
			{
				if(param1 >= 0 && param1 < this.screenInfoCount)
				{
					return this._screenInfoVec[param1];
				}
			}
			return null;
		}
		
		public function getSkipPointInfoAt(param1:int) : ISkipPointInfo
		{
			if(this._skipPointVec)
			{
				if(param1 >= 0 && param1 < this.skipPointInfoCount)
				{
					return this._skipPointVec[param1];
				}
			}
			return null;
		}
		
		public function startLoadAddedSkipPoints() : void
		{
			if(this._requestEnjoyableSkipPointsRemote)
			{
				this._requestEnjoyableSkipPointsRemote.removeEventListener(RemoteObjectEvent.Evt_StatusChanged,this.onRequestAddedSkipPoints);
				this._requestEnjoyableSkipPointsRemote.destroy();
			}
			this._requestEnjoyableSkipPointsRemote = new RequestEnjoyableSkipPointsRemote(this._holder,this._tvid);
			this._requestEnjoyableSkipPointsRemote.addEventListener(RemoteObjectEvent.Evt_StatusChanged,this.onRequestAddedSkipPoints);
			this._requestEnjoyableSkipPointsRemote.initialize();
		}
		
		public function hasEnjoyableSubType(param1:EnumItem) : Boolean
		{
			return !(this._enjoyableMap[param1] == null);
		}
		
		public function getEnjoyableSubDurationList(param1:EnumItem) : Array
		{
			if(this._enjoyableDurationMap[param1] != null)
			{
				return this._enjoyableDurationMap[param1] as Array;
			}
			return null;
		}
		
		public function setEnjoyableSubType(param1:EnumItem, param2:int = -1) : void
		{
			var _loc4:* = 0;
			var _loc5:* = 0;
			var _loc6:Vector.<SkipPointInfo> = null;
			var _loc7:* = 0;
			var _loc8:* = false;
			var _loc3:UserLocalSex = UserManager.getInstance().userLocalSex;
			if(_loc3.state == UserDef.USER_LOCAL_SEX_STATE_NONE || _loc3.state == UserDef.USER_LOCAL_SEX_STATE_COMPLETE)
			{
				if(!this.hasEnjoyableSubType(param1))
				{
					return;
				}
				_loc4 = this.adjustDurationIndexOfCurEnjoyableSubType(param1,param2);
				if(_loc4 < 0)
				{
					return;
				}
				_loc5 = this._enjoyableDurationMap[param1][_loc4];
				_loc6 = this._enjoyableMap[param1][_loc5];
				if((_loc6) && _loc6.length > 0)
				{
					this._curEnjoyableSubType = param1;
					this._curEnjoyableSubDurationIndex = _loc4;
					_loc7 = 0;
					_loc7 = this._skipPointVec.length - 1;
					while(_loc7 >= 0)
					{
						if(this._skipPointVec[_loc7].skipPointType == SkipPointEnum.ENJOYABLE)
						{
							this._skipPointVec[_loc7].reset();
							this._skipPointVec.splice(_loc7,1);
						}
						_loc7--;
					}
					_loc7 = 0;
					while(_loc7 < _loc6.length)
					{
						this._skipPointVec.push(_loc6[_loc7]);
						_loc7++;
					}
					_loc8 = false;
					if(_loc6.length > 0)
					{
						this._skipPointVec.sort(this.compare);
						if(this._curDefinition.metaIsReady)
						{
							this.updateSkipPointInfo();
							_loc8 = true;
						}
					}
					this._log.info("movie dispatchEvent: Evt_EnjoyableSubTypeChanged");
					dispatchEvent(new MovieEvent(MovieEvent.Evt_EnjoyableSubTypeChanged));
					if(_loc8)
					{
						this._log.info("movie dispatchEvent: Evt_UpdateSkipPoint");
						dispatchEvent(new MovieEvent(MovieEvent.Evt_UpdateSkipPoint));
					}
				}
			}
		}
		
		public function startLoadMeta() : void
		{
			if(this._curDefinition)
			{
				this._curDefinition.startLoadMeta();
			}
		}
		
		private function onDefinitionReady(param1:Event) : void
		{
			dispatchEvent(new MovieEvent(MovieEvent.Evt_Ready));
		}
		
		private function onDefinitionMetaReady(param1:Event) : void
		{
			this.updateSkipPointInfo();
			dispatchEvent(new MovieEvent(MovieEvent.Evt_Meta_Ready));
			dispatchEvent(new MovieEvent(MovieEvent.Evt_UpdateSkipPoint));
		}
		
		public function destroy() : void
		{
			var _loc1:* = 0;
			var _loc2:AudioTrack = null;
			var _loc3:* = 0;
			if(this._audioTrackVec)
			{
				_loc1 = this._audioTrackVec.length;
				_loc2 = null;
				_loc3 = 0;
				while(_loc3 < _loc1)
				{
					_loc2 = this._audioTrackVec[_loc3];
					if(_loc2)
					{
						_loc2.destroy();
					}
					_loc3++;
				}
				this._audioTrackVec = null;
			}
			this._screenInfoVec = null;
			this._skipPointVec = null;
			this._curAudioTrack = null;
			if(this._curDefinition)
			{
				this._curDefinition.removeEventListener(MovieEvent.Evt_Ready,this.onDefinitionReady);
				this._curDefinition.removeEventListener(MovieEvent.Evt_Meta_Ready,this.onDefinitionMetaReady);
				this._curDefinition = null;
			}
			this._curSegment = null;
			this._enjoyableMap = null;
			this._enjoyableDurationMap = null;
			UserManager.getInstance().userLocalSex.removeEventListener(UserManagerEvent.Evt_LocalSexInitComplete,this.onLocalSexInitComplete);
		}
		
		private function parse() : void
		{
			var _loc8:ScreenInfo = null;
			var _loc9:SkipPointInfo = null;
			var _loc1:* = false;
			if(this._source.ver != undefined)
			{
				this._ver = this._source.ver;
			}
			this._status = this._source.st;
			this._ipLimited = this._status == "109";
			this._streamType = Utility.getItemById(StreamEnum.ITEMS,int(this._source.t));
			if((this._holder && this._streamType == StreamEnum.RTMP) && (this._holder.runtimeData.smallOperators) && (this._source.du))
			{
				this._streamType = StreamEnum.HTTP;
				_loc1 = true;
			}
			this._nextVid = String(this._source.nvid);
			this._nextTvid = String(this._source.ntvd);
			this._tvid = String(this._source.tvid);
			this._albumId = String(this._source.aid);
			this._titleTime = (int(this._source.bt) <= 0?0:int(this._source.bt)) * 1000;
			this._trailerTime = (int(this._source.et) <= 0?0:int(this._source.et)) * 1000;
			this._logoId = String(this._source.lgd);
			this._logoPosition = int(this._source.lgp);
			this._ctgId = int(this._source.ctgid);
			this._channelID = int(this._source.cid);
			this._screenType = Utility.getItemById(ScreenEnum.ITEMS,int(this._source.tht));
			if(this._source.ca != undefined)
			{
				this._forceAD = int(this._source.ca) == 1;
			}
			if(this._source.uid != undefined)
			{
				this._uploaderID = String(this._source.uid);
			}
			if(this._source.exclusive != undefined)
			{
				this._exclusive = int(this._source.exclusive) == 1;
			}
			if(this._holder)
			{
				this._holder.runtimeData.albumId = this._albumId;
			}
			if(this._source.ctl != undefined)
			{
				this.parseDefinitionControl(this._source.ctl);
			}
			var _loc2:String = String(this._source.dm);
			var _loc3:String = _loc1?String(this._source.du):String(this._source.dd);
			var _loc4:Array = this._source.tkl as Array;
			var _loc5:AudioTrack = null;
			var _loc6:int = _loc4.length;
			var _loc7:* = 0;
			this._audioTrackVec = new Vector.<AudioTrack>(_loc6);
			_loc7 = 0;
			while(_loc7 < _loc6)
			{
				_loc5 = new AudioTrack(this._holder,this);
				_loc5.initAudioTrack(_loc4[_loc7],_loc2,_loc3,_loc1);
				this._audioTrackVec[_loc7] = _loc5;
				_loc7++;
			}
			this._screenInfoVec = new Vector.<ScreenInfo>();
			_loc4 = this._source.t3d as Array;
			if(_loc4)
			{
				_loc6 = _loc4.length;
				_loc8 = null;
				_loc7 = 0;
				while(_loc7 < _loc6)
				{
					if(!(_loc4[_loc7].tid == 0) && !(_loc4[_loc7].vtp == 0) && !(_loc4[_loc7].vid == ""))
					{
						_loc8 = new ScreenInfo();
						_loc8.screenType = Utility.getItemById(ScreenEnum.ITEMS,int(_loc4[_loc7].vtp));
						_loc8.tvid = _loc4[_loc7].tid;
						_loc8.vid = _loc4[_loc7].vid;
						this._screenInfoVec.push(_loc8);
					}
					_loc7++;
				}
			}
			this._skipPointVec = new Vector.<SkipPointInfo>();
			_loc4 = this._source.tsl as Array;
			if(_loc4)
			{
				_loc6 = _loc4.length;
				_loc9 = null;
				_loc7 = 0;
				for(; _loc7 < _loc6; _loc7++)
				{
					_loc9 = new SkipPointInfo();
					_loc9.skipPointType = Utility.getItemById(SkipPointEnum.ITEMS,int(_loc4[_loc7].stp));
					_loc9.startTime = Number(_loc4[_loc7].stm) * 1000;
					_loc9.endTime = Number(_loc4[_loc7].etm) * 1000;
					if(_loc9.skipPointType == SkipPointEnum.TITLE)
					{
						if(_loc9.startTime == 0)
						{
							this._titleTime = _loc9.endTime;
							continue;
						}
						this._titleTime = 0;
					}
					else if(_loc9.skipPointType == SkipPointEnum.TRAILER)
					{
						if(_loc9.endTime == -1)
						{
							this._trailerTime = _loc9.startTime;
							continue;
						}
						this._trailerTime = 0;
					}
					
					this._skipPointVec.push(_loc9);
				}
			}
		}
		
		private function parseDefinitionControl(param1:Object) : void
		{
			var _loc3:Array = null;
			var _loc4:Array = null;
			var _loc5:* = 0;
			this._defControlType = Utility.getItemById(DefinitionControlTypeEnum.ITEMS,int(param1.type));
			this._holder.runtimeData.serverTime = uint(param1.timestamp * 0.001);
			this._holder.runtimeData.serverTimeGetTimer = getTimer();
			if(param1.duration)
			{
				if(param1.duration.start)
				{
					_loc3 = String(param1.duration.start).split(":");
					if((_loc3) && _loc3.length >= 2)
					{
						this._defControlStartTime = int(_loc3[0]) * 3600 + int(_loc3[1]) * 60;
					}
				}
				if(param1.duration.end)
				{
					_loc4 = String(param1.duration.end).split(":");
					if((_loc4) && _loc4.length >= 2)
					{
						this._defControlEndTime = int(_loc4[0]) * 3600 + int(_loc4[1]) * 60;
					}
				}
			}
			var _loc2:Array = param1.bids as Array;
			if(_loc2)
			{
				_loc5 = 0;
				while(_loc5 < _loc2.length)
				{
					this._defControlList.push(Utility.getItemById(DefinitionEnum.ITEMS,int(_loc2[_loc5])));
					_loc5++;
				}
			}
		}
		
		private function updateSkipPointInfo() : void
		{
			var _loc1:Segment = null;
			var _loc2:Keyframe = null;
			var _loc3:* = 0;
			var _loc4:SkipPointInfo = null;
			var _loc5:SkipPointInfo = null;
			var _loc6:* = 0;
			if((this._skipPointVec) && (this._curDefinition.metaIsReady))
			{
				_loc1 = null;
				_loc2 = null;
				_loc3 = this.skipPointInfoCount;
				_loc4 = null;
				_loc5 = null;
				_loc6 = 0;
				_loc6 = _loc3 - 1;
				while(_loc6 >= 0)
				{
					_loc4 = this.getSkipPointInfoAt(_loc6) as SkipPointInfo;
					_loc1 = this.getSegmentByTime(_loc4.endTime);
					_loc2 = _loc1.getKeyframeByTime(_loc4.endTime);
					_loc4.endTime = _loc2.time;
					_loc1 = this.getSegmentByTime(_loc4.startTime);
					_loc2 = _loc1.getKeyframeByTime(_loc4.startTime);
					if(_loc2.time < _loc4.endTime)
					{
						_loc4.startTime = _loc2.time;
					}
					else if(_loc2.index != 0)
					{
						_loc4.startTime = _loc1.keyframes[_loc2.index - 1].time;
						if(_loc4.endTime <= _loc4.startTime)
						{
							this._skipPointVec.splice(_loc6,1);
						}
					}
					else if(_loc1.index != 0)
					{
						_loc1 = this._curDefinition.findSegmentAt(_loc1.index - 1);
						_loc4.startTime = _loc1.keyframes[_loc1.keyframes.length - 1].time;
						if(_loc4.endTime <= _loc4.startTime)
						{
							this._skipPointVec.splice(_loc6,1);
						}
					}
					else
					{
						this._skipPointVec.splice(_loc6,1);
					}
					
					
					_loc6--;
				}
				_loc3 = this.skipPointInfoCount;
				_loc6 = _loc3 - 1;
				while(_loc6 > 0)
				{
					_loc4 = this.getSkipPointInfoAt(_loc6) as SkipPointInfo;
					_loc5 = this.getSkipPointInfoAt(_loc6 - 1) as SkipPointInfo;
					if(_loc5.endTime > _loc4.startTime)
					{
						_loc4.startTime = _loc5.endTime;
						if(_loc4.startTime >= _loc4.endTime)
						{
							this._skipPointVec.splice(_loc6,1);
						}
					}
					_loc6--;
				}
			}
		}
		
		private function onRequestAddedSkipPoints(param1:RemoteObjectEvent) : void
		{
			var _loc2:* = 0;
			var _loc3:UserLocalSex = null;
			if(this._requestEnjoyableSkipPointsRemote.status == RemoteObjectStatusEnum.Success)
			{
				_loc2 = this._requestEnjoyableSkipPointsRemote.skipPointTypeArr.length;
				if(_loc2 > 0)
				{
					this._enjoyableMap = this._requestEnjoyableSkipPointsRemote.skipPointMap;
					this._enjoyableDurationMap = this._requestEnjoyableSkipPointsRemote.skipPointInfoDurationMap;
					_loc3 = UserManager.getInstance().userLocalSex;
					if(_loc3.state == UserDef.USER_LOCAL_SEX_STATE_NONE || _loc3.state == UserDef.USER_LOCAL_SEX_STATE_COMPLETE)
					{
						this.initEnjoyableSubSkipPoint();
					}
					else if(_loc3.state == UserDef.USER_LOCAL_SEX_STATE_LOADING)
					{
						_loc3.addEventListener(UserManagerEvent.Evt_LocalSexInitComplete,this.onLocalSexInitComplete);
					}
					
				}
			}
		}
		
		private function initEnjoyableSubSkipPoint() : void
		{
			var _loc1:* = 0;
			var _loc2:* = 0;
			var _loc3:Vector.<SkipPointInfo> = null;
			var _loc4:* = 0;
			var _loc5:* = false;
			if((this._holder) && (this._holder.runtimeData.userEnjoyableSubType))
			{
				if(this.hasEnjoyableSubType(this._holder.runtimeData.userEnjoyableSubType))
				{
					this._curEnjoyableSubType = this._holder.runtimeData.userEnjoyableSubType;
				}
				else
				{
					this.initCurEnjoyableSubTypeBySex();
				}
			}
			else
			{
				this.initCurEnjoyableSubTypeBySex();
			}
			if(this._curEnjoyableSubType)
			{
				_loc1 = this.adjustDurationIndexOfCurEnjoyableSubType(this._curEnjoyableSubType,this._holder?this._holder.runtimeData.userEnjoyableDurationIndex:-1);
				if(_loc1 >= 0)
				{
					this._curEnjoyableSubDurationIndex = _loc1;
					_loc2 = this._enjoyableDurationMap[this._curEnjoyableSubType][_loc1];
					_loc3 = this._enjoyableMap[this._curEnjoyableSubType][_loc2];
					if((_loc3) && _loc3.length > 0)
					{
						_loc4 = 0;
						while(_loc4 < _loc3.length)
						{
							this._skipPointVec.push(_loc3[_loc4]);
							_loc4++;
						}
						_loc5 = false;
						if(_loc3.length > 0)
						{
							this._skipPointVec.sort(this.compare);
							if(this._curDefinition.metaIsReady)
							{
								this.updateSkipPointInfo();
								_loc5 = true;
							}
						}
						this._log.info("movie dispatchEvent: Evt_EnjoyableSubTypeInited");
						dispatchEvent(new MovieEvent(MovieEvent.Evt_EnjoyableSubTypeInited));
						if(_loc5)
						{
							this._log.info("movie dispatchEvent: Evt_UpdateSkipPoint");
							dispatchEvent(new MovieEvent(MovieEvent.Evt_UpdateSkipPoint));
						}
					}
				}
			}
		}
		
		private function initCurEnjoyableSubTypeBySex() : void
		{
			var _loc1:UserLocalSex = UserManager.getInstance().userLocalSex;
			if(_loc1.getSex() == UserDef.USER_SEX_MALE)
			{
				if(this.hasEnjoyableSubType(SkipPointEnum.ENJOYABLE_SUB_MALE))
				{
					this._curEnjoyableSubType = SkipPointEnum.ENJOYABLE_SUB_MALE;
				}
				else if(this.hasEnjoyableSubType(SkipPointEnum.ENJOYABLE_SUB_COMMON))
				{
					this._curEnjoyableSubType = SkipPointEnum.ENJOYABLE_SUB_COMMON;
				}
				else if(this.hasEnjoyableSubType(SkipPointEnum.ENJOYABLE_SUB_FEMALE))
				{
					this._curEnjoyableSubType = SkipPointEnum.ENJOYABLE_SUB_FEMALE;
				}
				else
				{
					this._curEnjoyableSubType = null;
				}
				
				
			}
			else if(this.hasEnjoyableSubType(SkipPointEnum.ENJOYABLE_SUB_FEMALE))
			{
				this._curEnjoyableSubType = SkipPointEnum.ENJOYABLE_SUB_FEMALE;
			}
			else if(this.hasEnjoyableSubType(SkipPointEnum.ENJOYABLE_SUB_COMMON))
			{
				this._curEnjoyableSubType = SkipPointEnum.ENJOYABLE_SUB_COMMON;
			}
			else if(this.hasEnjoyableSubType(SkipPointEnum.ENJOYABLE_SUB_MALE))
			{
				this._curEnjoyableSubType = SkipPointEnum.ENJOYABLE_SUB_MALE;
			}
			else
			{
				this._curEnjoyableSubType = null;
			}
			
			
			
		}
		
		private function adjustDurationIndexOfCurEnjoyableSubType(param1:EnumItem, param2:int = -1) : int
		{
			var _loc3:Array = this.getEnjoyableSubDurationList(param1);
			if(_loc3 == null || _loc3.length == 0)
			{
				return -1;
			}
			var _loc4:int = param2;
			if(_loc4 < 0 || _loc4 >= _loc3.length || this._enjoyableMap[param1][_loc3[_loc4]] == null)
			{
				_loc4 = _loc3.length > 2?int(_loc3.length * 0.5):0;
			}
			return _loc4;
		}
		
		private function compare(param1:SkipPointInfo, param2:SkipPointInfo) : int
		{
			return param1.startTime - param2.startTime;
		}
		
		private function onLocalSexInitComplete(param1:Event) : void
		{
			UserManager.getInstance().userLocalSex.removeEventListener(UserManagerEvent.Evt_LocalSexInitComplete,this.onLocalSexInitComplete);
			this.initEnjoyableSubSkipPoint();
		}
	}
}
