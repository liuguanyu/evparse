package com.qiyi.player.core.model.impls
{
	import flash.events.EventDispatcher;
	import com.qiyi.player.core.IDestroy;
	import com.qiyi.player.core.model.IDefinitionInfo;
	import com.qiyi.player.core.model.IMovie;
	import com.qiyi.player.base.pub.EnumItem;
	import com.qiyi.player.core.model.remote.RequestMetaRemote;
	import com.qiyi.player.core.player.coreplayer.ICorePlayer;
	import com.qiyi.player.base.logging.ILogger;
	import com.qiyi.player.base.utils.Utility;
	import com.qiyi.player.core.model.def.DefinitionEnum;
	import flash.utils.*;
	import com.qiyi.player.base.utils.KeyUtils;
	import com.qiyi.player.core.model.def.StreamEnum;
	import com.qiyi.player.base.pub.ProcessesTimeRecord;
	import com.qiyi.player.base.rpc.RemoteObjectEvent;
	import flash.events.TimerEvent;
	import com.qiyi.player.base.rpc.RemoteObjectStatusEnum;
	import com.qiyi.player.core.model.events.MovieEvent;
	import com.qiyi.player.core.model.utils.ErrorCodeUtils;
	import com.qiyi.player.base.logging.Log;
	
	public class Definition extends EventDispatcher implements IDestroy, IDefinitionInfo
	{
		
		private var _audioTrack:AudioTrack;
		
		private var _movie:IMovie;
		
		private var _source:Object;
		
		private var _meta:Object;
		
		private var _type:EnumItem;
		
		private var _vid:String = "";
		
		private var _metaURL:String = "";
		
		private var _segmentVec:Vector.<Segment>;
		
		private var _duration:Number = 0;
		
		private var _flvWidth:Number = 0;
		
		private var _flvHeight:Number = 0;
		
		private var _videoConfigTag:String = "";
		
		private var _audioConfigTag:String = "";
		
		private var _ready:Boolean = false;
		
		private var _timer:Timer;
		
		private var _rm:RequestMetaRemote;
		
		private var _timeout:uint = 0;
		
		private var _timestampContinuous:Boolean = false;
		
		private var _pingBackFlag:Boolean = false;
		
		private var _holder:ICorePlayer;
		
		private var _log:ILogger;
		
		public function Definition(param1:ICorePlayer, param2:AudioTrack, param3:IMovie)
		{
			this._log = Log.getLogger("com.qiyi.player.core.model.impls.Definition");
			super();
			this._holder = param1;
			this._audioTrack = param2;
			this._movie = param3;
		}
		
		public function get type() : EnumItem
		{
			return this._type;
		}
		
		public function get vid() : String
		{
			return this._vid;
		}
		
		public function get duration() : Number
		{
			return this._duration;
		}
		
		public function get flvWidth() : Number
		{
			return this._flvWidth;
		}
		
		public function get flvHeight() : Number
		{
			return this._flvHeight;
		}
		
		public function get segmentCount() : int
		{
			if(this._segmentVec)
			{
				return this._segmentVec.length;
			}
			return 0;
		}
		
		public function get videoConfigTag() : String
		{
			return this._videoConfigTag;
		}
		
		public function get audioConfigTag() : String
		{
			return this._audioConfigTag;
		}
		
		public function get meta() : Object
		{
			return this._meta;
		}
		
		public function get ready() : Boolean
		{
			return this._ready;
		}
		
		public function get metaIsReady() : Boolean
		{
			return !(this._meta == null);
		}
		
		public function get timestampContinuous() : Boolean
		{
			return this._timestampContinuous;
		}
		
		public function initDefinition(param1:Object, param2:String, param3:String, param4:Boolean) : void
		{
			var _loc6:Object = null;
			var _loc7:* = 0;
			var _loc8:Segment = null;
			var _loc9:* = NaN;
			var _loc10:* = NaN;
			var _loc11:String = null;
			var _loc12:* = NaN;
			var _loc13:* = 0;
			if(this._source != null)
			{
				return;
			}
			this._source = param1;
			this._type = Utility.getItemById(DefinitionEnum.ITEMS,int(param1.bid));
			this._vid = param1.vid.toString();
			this._metaURL = param2 + param1.mu.toString();
			if(param1.tag)
			{
				if(param1.tag.vt)
				{
					this._videoConfigTag = param1.tag.vt;
				}
				if(param1.tag.at)
				{
					this._audioConfigTag = param1.tag.at;
				}
			}
			this._duration = 0;
			var _loc5:Array = null;
			if(param4)
			{
				_loc5 = param1.flvs as Array;
			}
			else
			{
				_loc5 = param1.fs as Array;
			}
			if(_loc5)
			{
				_loc6 = null;
				_loc7 = _loc5.length;
				_loc8 = null;
				this._segmentVec = new Vector.<Segment>(_loc7);
				_loc9 = 0;
				_loc10 = 0;
				_loc11 = "";
				_loc12 = 0;
				_loc13 = 0;
				while(_loc13 < _loc7)
				{
					_loc6 = _loc5[_loc13];
					if(this._type == DefinitionEnum.SUPER_HIGH || this._type == DefinitionEnum.FULL_HD || this._type == DefinitionEnum.FOUR_K)
					{
						if(this._movie.ver == "01")
						{
							if(String(_loc6.l).indexOf("/") == -1)
							{
								_loc11 = param3 + KeyUtils.getVrsEncodeCode(_loc6.l.toString());
							}
							else
							{
								_loc11 = param3 + _loc6.l.toString();
							}
						}
						else
						{
							_loc11 = param3 + _loc6.l.toString();
						}
					}
					else
					{
						_loc11 = param3 + _loc6.l.toString();
					}
					_loc12 = Number(_loc6.d.toString());
					if(this._movie.streamType == StreamEnum.RTMP)
					{
						_loc12 = _loc12 * 1000;
					}
					_loc8 = new Segment(this._holder,this._vid,_loc13,_loc9,_loc10,_loc11,Number(_loc6.b.toString()),_loc12);
					_loc9 = _loc9 + (_loc8.totalTime + 30);
					_loc10 = _loc10 + _loc8.totalBytes;
					this._segmentVec[_loc13] = _loc8;
					this._duration = this._duration + _loc8.totalTime;
					_loc13++;
				}
			}
		}
		
		public function findSegmentAt(param1:int) : Segment
		{
			if(param1 < 0 || param1 >= this.segmentCount)
			{
				throw new Error("out of range segments");
			}
			else
			{
				return this._segmentVec[param1];
			}
		}
		
		public function findSegmentByRid(param1:String) : Segment
		{
			var _loc2:* = 0;
			var _loc3:Segment = null;
			var _loc4:* = 0;
			if((this._segmentVec) && (param1))
			{
				_loc2 = this.segmentCount;
				_loc3 = null;
				_loc4 = 0;
				while(_loc4 < _loc2)
				{
					_loc3 = this._segmentVec[_loc4];
					if((_loc3) && _loc3.rid == param1)
					{
						return _loc3;
					}
					_loc4++;
				}
			}
			return null;
		}
		
		public function startLoadMeta() : void
		{
			if(this._rm == null && this._timer == null)
			{
				if(this._movie.streamType == StreamEnum.RTMP)
				{
					this._ready = true;
				}
				else if(this._movie.streamType == StreamEnum.HTTP)
				{
					if(this._meta == null)
					{
						if(this._timeout)
						{
							clearTimeout(this._timeout);
						}
						ProcessesTimeRecord.STime_meta = getTimer();
						this.reLoadMeta();
						this._timeout = setTimeout(this.setReady,2000);
					}
				}
				
			}
		}
		
		private function reLoadMeta() : void
		{
			if(this._rm)
			{
				this._rm.removeEventListener(RemoteObjectEvent.Evt_StatusChanged,this.onMetaStatusChanged);
				this._rm.destroy();
			}
			this._rm = new RequestMetaRemote(this._metaURL + "?tn=" + Math.random());
			this._rm.addEventListener(RemoteObjectEvent.Evt_StatusChanged,this.onMetaStatusChanged);
			this._rm.initialize();
		}
		
		private function initMeta() : void
		{
			var _loc1:XMLList = this._meta.flv.keyframesequences.keyframes;
			var _loc2:Segment = null;
			var _loc3:int = this.segmentCount;
			this._flvWidth = int(this._meta.flv.width.toString());
			this._flvHeight = int(this._meta.flv.height.toString());
			this._timestampContinuous = int(this._meta.flv.timestampcontinuous) == 1;
			var _loc4:* = 0;
			while(_loc4 < _loc3)
			{
				_loc2 = this._segmentVec[_loc4];
				_loc2.setKeyframesByXML(_loc1[_loc4],int(this._meta.flv.timestampcontinuous) == 1);
				_loc4++;
			}
			this._duration = this._segmentVec[_loc3 - 1].endTime;
		}
		
		private function onMetaStatusChanged(param1:RemoteObjectEvent) : void
		{
			var errorCode:int = 0;
			var event:RemoteObjectEvent = param1;
			if(this._timer)
			{
				this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
				this._timer.stop();
				this._timer = null;
			}
			errorCode = 0;
			try
			{
				if(this._rm.status == RemoteObjectStatusEnum.Success)
				{
					this._meta = this._rm.getData() as XML;
					this.initMeta();
					dispatchEvent(new MovieEvent(MovieEvent.Evt_Meta_Ready));
				}
				else if(this._rm.status != RemoteObjectStatusEnum.Processing)
				{
					errorCode = ErrorCodeUtils.getErrorCodeByRemoteObject(this._rm,this._rm.status);
					if((this._holder) && !this._pingBackFlag)
					{
						this._holder.pingBack.sendError(errorCode);
						this._pingBackFlag = true;
					}
					this._timer = new Timer(5000,1);
					this._timer.addEventListener(TimerEvent.TIMER,this.onTimer);
					this._timer.start();
				}
				
			}
			catch(e:Error)
			{
				errorCode = ErrorCodeUtils.getErrorCodeByRemoteObject(_rm,_rm.status);
				if((_holder) && !_pingBackFlag)
				{
					_holder.pingBack.sendError(errorCode);
					_pingBackFlag = true;
				}
				_timer = new Timer(5000,1);
				_timer.addEventListener(TimerEvent.TIMER,onTimer);
				_timer.start();
			}
			this._rm.removeEventListener(RemoteObjectEvent.Evt_StatusChanged,this.onMetaStatusChanged);
			this._rm.destroy();
			this._rm = null;
			this.setReady();
		}
		
		private function setReady() : void
		{
			if(ProcessesTimeRecord.STime_meta > 0)
			{
				ProcessesTimeRecord.usedTime_meta = getTimer() - ProcessesTimeRecord.STime_meta;
			}
			if(this._timeout)
			{
				clearTimeout(this._timeout);
			}
			this._timeout = 0;
			if(!this._ready)
			{
				this._ready = true;
				dispatchEvent(new MovieEvent(MovieEvent.Evt_Ready));
			}
		}
		
		private function onTimer(param1:TimerEvent) : void
		{
			this.reLoadMeta();
		}
		
		public function destroy() : void
		{
			var _loc1:Segment = null;
			var _loc2:* = 0;
			var _loc3:* = 0;
			this._audioTrack = null;
			this._movie = null;
			this._source = null;
			this._meta = null;
			this._type = null;
			this._vid = "";
			this._metaURL = "";
			if(this._segmentVec)
			{
				_loc1 = null;
				_loc2 = this._segmentVec.length;
				_loc3 = 0;
				while(_loc3 < _loc2)
				{
					_loc1 = this._segmentVec[_loc3];
					if(_loc1)
					{
						_loc1.destroy();
					}
					_loc3++;
				}
				this._segmentVec = null;
			}
			this._duration = 0;
			this._flvWidth = 0;
			this._flvHeight = 0;
			this._ready = false;
			this._pingBackFlag = false;
			if(this._timeout)
			{
				clearTimeout(this._timeout);
			}
			this._timeout = 0;
			if(this._timer)
			{
				this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
				this._timer.stop();
				this._timer = null;
			}
			if(this._rm)
			{
				this._rm.removeEventListener(RemoteObjectEvent.Evt_StatusChanged,this.onMetaStatusChanged);
				this._rm.destroy();
				this._rm = null;
			}
		}
	}
}
