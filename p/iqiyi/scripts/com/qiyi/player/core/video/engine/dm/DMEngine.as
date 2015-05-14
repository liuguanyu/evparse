package com.qiyi.player.core.video.engine.dm
{
	import com.qiyi.player.core.video.engine.BaseEngine;
	import com.qiyi.player.core.video.engine.dm.provider.Provider;
	import com.qiyi.player.core.video.engine.dm.provider.ProviderStateHandler;
	import com.qiyi.player.core.video.engine.dm.agents.RateAgent;
	import com.qiyi.player.core.model.IMovie;
	import com.qiyi.player.core.video.render.IRender;
	import com.qiyi.player.core.model.events.MovieEvent;
	import com.qiyi.player.core.player.def.StatusEnum;
	import com.qiyi.player.core.player.def.PauseTypeEnum;
	import com.qiyi.player.base.pub.EnumItem;
	import flash.utils.clearTimeout;
	import loader.vod.P2PFileLoader;
	import com.qiyi.player.base.pub.ProcessesTimeRecord;
	import flash.utils.getTimer;
	import flash.events.Event;
	import com.qiyi.player.core.model.impls.pub.Settings;
	import com.qiyi.player.core.video.decoder.DataModeDecoder;
	import com.qiyi.player.core.Config;
	import flash.events.NetStatusEvent;
	import com.qiyi.player.core.video.events.DecoderEvent;
	import com.qiyi.player.core.video.events.ProviderEvent;
	import com.qiyi.player.core.player.def.PlayerUseTypeEnum;
	import com.qiyi.player.core.model.impls.AudioTrack;
	import com.qiyi.player.core.model.impls.Definition;
	import com.qiyi.player.core.model.impls.Segment;
	import com.qiyi.player.core.model.ISkipPointInfo;
	import com.qiyi.player.core.model.def.SkipPointEnum;
	import com.qiyi.player.core.video.def.StopReasonEnum;
	import com.qiyi.player.core.video.def.DecoderStatusEnum;
	import flash.utils.setTimeout;
	import com.qiyi.player.core.video.events.EngineEvent;
	import com.qiyi.player.core.video.events.RateAgentEvent;
	import flash.events.TimerEvent;
	import com.qiyi.player.core.video.engine.dm.provider.MediaData;
	import com.qiyi.player.core.Version;
	import com.qiyi.player.core.player.coreplayer.ICorePlayer;
	
	public class DMEngine extends BaseEngine
	{
		
		private var _provider:Provider;
		
		private var _providerStateHandler:ProviderStateHandler;
		
		private var _openCheckDecoderData:Boolean = false;
		
		private var _rateAgent:RateAgent;
		
		private var _seeked:Boolean = false;
		
		private var _timeoutForWaiting:uint = 0;
		
		private var _timeoutForEmpty:uint = 0;
		
		private var _provierIsCreated:Boolean;
		
		private var _definitionIsSwitched:Boolean;
		
		public function DMEngine(param1:ICorePlayer)
		{
			super(param1);
			this._providerStateHandler = new ProviderStateHandler(param1);
			this._rateAgent = new RateAgent(_holder);
			this._rateAgent.addEventListener(RateAgentEvent.Evt_AudioTrackChanged,this.onAudioTrackChanged);
			this._rateAgent.addEventListener(RateAgentEvent.Evt_DefinitionChanged,this.onDefinitionChanged);
		}
		
		public function get provider() : Provider
		{
			return this._provider;
		}
		
		override public function get currentTime() : int
		{
			if(_decoder)
			{
				return _decoder.time;
			}
			return 0;
		}
		
		override public function get bufferTime() : int
		{
			if(this._provider)
			{
				return this._provider.bufferLength;
			}
			return 0;
		}
		
		override public function set openSelectPlay(param1:Boolean) : void
		{
			this.updateSelectFragments();
		}
		
		override public function bind(param1:IMovie, param2:IRender) : void
		{
			if(_movie)
			{
				_movie.removeEventListener(MovieEvent.Evt_UpdateSkipPoint,this.onUpdateSkipPoint);
			}
			this._definitionIsSwitched = false;
			super.bind(param1,param2);
			this.destroyProvider();
			this.createDecoder();
			this.openListenDecoder();
			_render.bind(this,_decoder,_movie);
			setStatus(StatusEnum.ALREADY_READY);
		}
		
		override public function startLoad() : void
		{
			super.startLoad();
			var _loc1:Boolean = this.checkEngineIsReady();
			if(!_holder.hasStatus(StatusEnum.ALREADY_PLAY))
			{
				_decoder.play(null);
				if(_loc1)
				{
					this.seek(_startTime);
					this._rateAgent.startAutoAdjustRate();
				}
			}
			if(!_loc1)
			{
				_holder.addStatus(StatusEnum.WAITING_START_LOAD,false);
				startLoadHistory();
				startLoadMeta();
				this.startLoadP2PCore();
			}
			this.pause();
			setStatus(StatusEnum.ALREADY_START_LOAD);
		}
		
		override public function stopLoad() : void
		{
			super.stopLoad();
			if(this._provider)
			{
				this._provider.setLoadToggle(false);
			}
		}
		
		override public function play() : void
		{
			var _loc1:* = false;
			if(!_holder.hasStatus(StatusEnum.ALREADY_PLAY))
			{
				super.play();
				_loc1 = this.checkEngineIsReady();
				if(!_holder.hasStatus(StatusEnum.ALREADY_START_LOAD))
				{
					_decoder.play(null);
					if(_loc1)
					{
						this.seek(_startTime);
						this._rateAgent.startAutoAdjustRate();
					}
				}
				else if(this._provider)
				{
					this._provider.setLoadToggle(true);
				}
				
				if(this._provider)
				{
					this._provider.setOpenPlay(true);
				}
				this.resume();
				if(!_loc1)
				{
					_holder.addStatus(StatusEnum.WAITING_PLAY,false);
					startLoadHistory();
					startLoadMeta();
					this.startLoadP2PCore();
				}
			}
		}
		
		override public function resume() : void
		{
			super.resume();
			if(this._provider)
			{
				this._provider.setUserPauseToggle(false);
			}
		}
		
		override public function replay() : void
		{
			if(_holder.hasStatus(StatusEnum.STOPED))
			{
				this.openListenDecoder();
				_decoder.play(null);
				super.replay();
			}
		}
		
		override public function seek(param1:uint, param2:int = 0) : void
		{
			if(_movie == null || !_movie.curDefinition)
			{
				return;
			}
			this.openListenDecoder();
			this._seeked = true;
			_seekTime = param1;
			if(this.checkEngineIsReady())
			{
				super.seek(_seekTime,param2);
				this._provider.seek(_seekTime,_movie.curAudioTrack.type.id,_movie.curDefinition.type.id,param2);
				this._openCheckDecoderData = true;
			}
			_decoder.seek(_seekTime == 0?100:_seekTime);
		}
		
		override public function pause(param1:int = 0) : void
		{
			super.pause(param1);
			if((this._provider) && !((param1 & PauseTypeEnum.USER) == 0))
			{
				this._provider.setUserPauseToggle(true);
			}
		}
		
		override public function stop(param1:EnumItem) : void
		{
			this._openCheckDecoderData = false;
			if(this._provider)
			{
				this._provider.setLoadToggle(false);
			}
			if(this._timeoutForWaiting)
			{
				clearTimeout(this._timeoutForWaiting);
				this._timeoutForWaiting = 0;
			}
			this.closeListenDecoder();
			super.stop(param1);
		}
		
		override public function startLoadP2PCore() : void
		{
			_log.info("DMEngine.startLoadP2PCore(" + _holder.runtimeData.flashP2PCoreURL + "), has P2P_CORE_START_LOAD_CALLED:" + _holder.hasStatus(StatusEnum.P2P_CORE_START_LOAD_CALLED) + ", isLoading:" + P2PFileLoader.instance.isLoading + ", isDone:" + P2PFileLoader.instance.loadDone + ", isError:" + P2PFileLoader.instance.loadErr);
			if(_holder.hasStatus(StatusEnum.P2P_CORE_START_LOAD_CALLED))
			{
				return;
			}
			_holder.addStatus(StatusEnum.P2P_CORE_START_LOAD_CALLED,false);
			if(!P2PFileLoader.instance.isLoading)
			{
				if(P2PFileLoader.instance.loadDone)
				{
					this.onP2PReady(null);
					return;
				}
				if(P2PFileLoader.instance.loadErr)
				{
					this.onP2PError(null);
					return;
				}
			}
			if(ProcessesTimeRecord.STime_P2PCore == 0)
			{
				ProcessesTimeRecord.STime_P2PCore = getTimer();
			}
			P2PFileLoader.instance.addEventListener(P2PFileLoader.Evt_LoadDone,this.onP2PReady);
			P2PFileLoader.instance.addEventListener(P2PFileLoader.Evt_LoadError,this.onP2PError);
			if(!P2PFileLoader.instance.isLoading && !P2PFileLoader.instance.loadDone && !P2PFileLoader.instance.loadErr)
			{
				P2PFileLoader.instance.loadCore(_holder.runtimeData.flashP2PCoreURL);
			}
		}
		
		override protected function selfStop(param1:EnumItem) : void
		{
			this._openCheckDecoderData = false;
			if(this._provider)
			{
				this._provider.setLoadToggle(false);
			}
			if(this._timeoutForWaiting)
			{
				clearTimeout(this._timeoutForWaiting);
				this._timeoutForWaiting = 0;
			}
			this.closeListenDecoder();
			super.selfStop(param1);
		}
		
		override protected function stopedHandler() : void
		{
			if(_decoder)
			{
				_decoder.stop();
			}
			super.stopedHandler();
		}
		
		override protected function onSkipTrailerChanged(param1:Event) : void
		{
			var _loc2:* = 0;
			if(this._provider)
			{
				_loc2 = 0;
				if(_holder.runtimeData.originalEndTime > 0)
				{
					_loc2 = _holder.runtimeData.originalEndTime;
				}
				else if(_movie.trailerTime > 0 && (Settings.instance.skipTrailer))
				{
					_loc2 = _movie.trailerTime;
				}
				
				this._provider.setEndTime(_loc2);
			}
			super.onSkipTrailerChanged(param1);
		}
		
		override protected function onMovieReady(param1:Event) : void
		{
			this.updateProvider();
			super.onMovieReady(param1);
		}
		
		override protected function checkNeedStartLoad() : void
		{
			if((_holder.hasStatus(StatusEnum.WAITING_START_LOAD)) && (this.checkEngineIsReady()))
			{
				this._rateAgent.startAutoAdjustRate();
			}
			super.checkNeedStartLoad();
		}
		
		override protected function checkNeedPlay() : void
		{
			if((_holder.hasStatus(StatusEnum.WAITING_PLAY)) && (this.checkEngineIsReady()))
			{
				this._rateAgent.startAutoAdjustRate();
				if(this._provider)
				{
					this._provider.setOpenPlay(true);
				}
			}
			super.checkNeedPlay();
		}
		
		override protected function checkEngineIsReady() : Boolean
		{
			var _loc1:Boolean = !P2PFileLoader.instance.isLoading && (P2PFileLoader.instance.loadDone);
			return (_loc1) && (super.checkEngineIsReady());
		}
		
		override protected function onHistoryReady(param1:Event) : void
		{
			super.onHistoryReady(param1);
			if((this._provider) && (_holder.movie))
			{
				this._provider.setStartTime(_holder.strategy.getStartTime());
			}
		}
		
		private function createDecoder() : void
		{
			if(_decoder)
			{
				this.closeListenDecoder();
				_decoder.destroy();
			}
			_decoder = new DataModeDecoder(_holder);
			_decoder.bufferTime = Config.STREAM_NORMAL_BUFFER_TIME / 1000;
		}
		
		private function openListenDecoder() : void
		{
			if(_decoder)
			{
				_decoder.addEventListener(NetStatusEvent.NET_STATUS,this.onDecoderNetStatus);
				_decoder.addEventListener(DecoderEvent.Evt_StatusChanged,this.onDecoderStatusChanged);
				this.updateStatusByDecoder();
			}
		}
		
		private function closeListenDecoder() : void
		{
			if(_decoder)
			{
				_decoder.removeEventListener(NetStatusEvent.NET_STATUS,this.onDecoderNetStatus);
				_decoder.removeEventListener(DecoderEvent.Evt_StatusChanged,this.onDecoderStatusChanged);
			}
		}
		
		private function createProvider() : void
		{
			_holder.pingBack.stopFlashP2PFailedCDN();
			this._provider = new Provider();
			this._provider.addEventListener(ProviderEvent.Evt_Failed,this.onProviderFailed);
			this._provider.addEventListener(ProviderEvent.Evt_StateChanged,this.onProviderStateChanged);
			var _loc1:Number = 0;
			if(_holder.runtimeData.dispatcherServerTime > 0)
			{
				_loc1 = uint(getTimer() / 1000) - _holder.runtimeData.dispatchFlashRunTime + _holder.runtimeData.dispatcherServerTime;
				_loc1 = _loc1 * 1000;
			}
			var _loc2:* = 0;
			if(_holder.runtimeData.originalEndTime > 0)
			{
				_loc2 = _holder.runtimeData.originalEndTime;
			}
			else if(_movie.trailerTime > 0 && (Settings.instance.skipTrailer))
			{
				_loc2 = _movie.trailerTime;
			}
			
			var _loc3:* = "";
			if(_holder.movieInfo)
			{
				_loc3 = _holder.movieInfo.source;
			}
			var _loc4:* = -1;
			var _loc5:Boolean = (_holder.history) && (_holder.history.getReady()) || !(_holder.runtimeData.playerUseType == PlayerUseTypeEnum.MAIN);
			if(_loc5)
			{
				_loc4 = _holder.strategy.getStartTime();
			}
			this._provider.initProvider(_decoder,_holder.runtimeData.stratusIP,_loc1,this.createVideoInfo(),this.createCurMetaInfo(),_movie.curAudioTrack.type.id,_movie.curDefinition.type.id,_loc3,_movie.channelID,_movie.albumId,_movie.tvid,_loc4,_loc2,_holder.runtimeData.playerType.name,_holder.runtimeData.movieIsMember,_holder.runtimeData.openFlashP2P,_holder.uuid,_holder.runtimeData.userArea,_holder.hasStatus(StatusEnum.ALREADY_PLAY),_holder.runtimeData.platform.id.toString());
			_holder.runtimeData.stratusIP = "";
			this.updateSelectFragments();
			_movie.addEventListener(MovieEvent.Evt_UpdateSkipPoint,this.onUpdateSkipPoint);
			this._provierIsCreated = true;
		}
		
		private function destroyProvider() : void
		{
			if(this._provider)
			{
				this._provider.removeEventListener(ProviderEvent.Evt_Failed,this.onProviderFailed);
				this._provider.removeEventListener(ProviderEvent.Evt_StateChanged,this.onProviderStateChanged);
				this._provider.destroy();
				this._provider = null;
				this._provierIsCreated = false;
			}
		}
		
		private function createVideoInfo() : Array
		{
			var _loc3:AudioTrack = null;
			var _loc4:* = 0;
			var _loc5:* = 0;
			var _loc6:Definition = null;
			var _loc7:* = 0;
			var _loc8:Array = null;
			var _loc9:* = 0;
			var _loc10:Object = null;
			var _loc11:Segment = null;
			var _loc1:Array = [];
			var _loc2:* = 0;
			while(_loc2 < _movie.audioTrackCount)
			{
				_loc3 = _movie.getAudioTrackAt(_loc2);
				_loc4 = _loc3.definitionCount;
				_loc5 = 0;
				while(_loc5 < _loc4)
				{
					_loc6 = _loc3.findDefinitionAt(_loc5);
					_loc7 = _loc6.segmentCount;
					_loc8 = new Array(_loc7);
					_loc9 = 0;
					while(_loc9 < _loc7)
					{
						_loc11 = _loc6.findSegmentAt(_loc9);
						_loc8[_loc9] = {
							"url":_loc11.url,
							"totalBytes":_loc11.totalBytes,
							"vid":_loc11.vid,
							"index":_loc11.index,
							"startTime":_loc11.startTime,
							"totalTime":_loc11.totalTime
						};
						_loc9++;
					}
					_loc10 = {};
					_loc10.lid = _loc3.type.id;
					_loc10.bid = _loc6.type.id;
					_loc10.vid = _loc6.vid;
					_loc10.videoConfigTag = _loc6.videoConfigTag;
					_loc10.audioConfigTag = _loc6.audioConfigTag;
					_loc10.segments = _loc8;
					_loc1.push(_loc10);
					_loc5++;
				}
				_loc2++;
			}
			return _loc1;
		}
		
		private function createCurMetaInfo() : Array
		{
			var _loc1:Definition = null;
			var _loc2:* = 0;
			var _loc3:Array = null;
			var _loc4:* = 0;
			var _loc5:Segment = null;
			var _loc6:Array = null;
			var _loc7:Array = null;
			var _loc8:* = 0;
			var _loc9:Object = null;
			if(_movie.curDefinition.metaIsReady)
			{
				_loc1 = _movie.curDefinition;
				_loc2 = _loc1.segmentCount;
				_loc3 = new Array(_loc2);
				_loc4 = 0;
				while(_loc4 < _loc2)
				{
					_loc5 = _loc1.findSegmentAt(_loc4);
					_loc6 = new Array(_loc5.keyframes.length + 1);
					_loc7 = new Array(_loc5.keyframes.length + 1);
					_loc6[0] = _loc5.firstKeyframe.segmentTime;
					_loc7[0] = _loc5.firstKeyframe.position;
					_loc8 = 0;
					while(_loc8 < _loc5.keyframes.length)
					{
						_loc6[_loc8 + 1] = _loc5.keyframes[_loc8].segmentTime;
						_loc7[_loc8 + 1] = _loc5.keyframes[_loc8].position;
						_loc8++;
					}
					_loc9 = {
						"keyframes":{
							"times":_loc6,
							"filepositions":_loc7
						},
						"tsc":_loc1.timestampContinuous
					};
					_loc3[_loc4] = _loc9;
					_loc4++;
				}
				return _loc3;
			}
			return null;
		}
		
		private function updateSelectFragments() : void
		{
			var _loc1:Array = null;
			var _loc2:* = 0;
			var _loc3:ISkipPointInfo = null;
			var _loc4:Object = null;
			var _loc5:* = 0;
			if(this._provider)
			{
				if(_holder.runtimeData.openSelectPlay)
				{
					if((_movie) && (_movie.curDefinition) && (_movie.curDefinition.metaIsReady))
					{
						_loc1 = [];
						_loc2 = _movie.skipPointInfoCount;
						_loc3 = null;
						_loc4 = null;
						_loc5 = 0;
						_loc5 = 0;
						while(_loc5 < _loc2)
						{
							_loc3 = _movie.getSkipPointInfoAt(_loc5);
							if(_loc3.skipPointType == SkipPointEnum.ENJOYABLE)
							{
								_loc4 = new Object();
								_loc4.type = 6;
								_loc4.startTime = _loc3.startTime;
								_loc4.endTime = _loc3.endTime;
								_loc1.push(_loc4);
							}
							_loc5++;
						}
						if(_loc1.length > 0)
						{
							this._provider.setFragments(_loc1);
						}
					}
				}
				else
				{
					this._provider.setFragments(null);
				}
			}
		}
		
		private function onUpdateSkipPoint(param1:MovieEvent) : void
		{
			this.updateSelectFragments();
		}
		
		private function onDecoderNetStatus(param1:NetStatusEvent) : void
		{
			var _loc2:* = 0;
			var _loc3:EnumItem = null;
			switch(param1.info.code)
			{
				case "NetStream.Buffer.Flush":
					_decoder.bufferTime = Config.STREAM_SHORT_BUFFER_TIME / 1000;
					if(_decoder.bufferLength > _decoder.bufferTime)
					{
						break;
					}
				case "NetStream.Buffer.Empty":
					if(_decoder.bufferLength >= _decoder.bufferTime)
					{
						break;
					}
					if(this._provider.eof)
					{
						this.selfStop(StopReasonEnum.STOP);
					}
					else
					{
						_loc2 = _holder.runtimeData.endTime;
						_loc3 = StopReasonEnum.REACH_ASSIGN;
						if(_loc2 == 0 && (_holder.runtimeData.skipTrailer))
						{
							_loc2 = _movie.trailerTime;
							_loc3 = StopReasonEnum.SKIP_TRAILER;
						}
						if(_loc2 > 0 && Math.abs(_decoder.time - _loc2) < 1000)
						{
							this.selfStop(_loc3);
						}
						else if(this._provider.loadingFailed)
						{
							this.executeFail();
						}
						else
						{
							if(_decoder.status != DecoderStatusEnum.STOPPED)
							{
								this.pushDataToDecoder();
							}
							if(_decoder.bufferLength < 1)
							{
								if(!this._seeked)
								{
									clearTimeout(this._timeoutForEmpty);
									this._timeoutForEmpty = setTimeout(this.onBufferEmpty,500);
									dispatchEvent(new EngineEvent(EngineEvent.Evt_Stuck));
								}
								if(this._timeoutForWaiting)
								{
									clearTimeout(this._timeoutForWaiting);
								}
								this._timeoutForWaiting = setTimeout(this.waitingLongTime,Config.SCREEN_BLANK_MAX);
							}
						}
						
					}
					break;
				case "NetStream.Buffer.Full":
					clearTimeout(this._timeoutForEmpty);
					this._timeoutForEmpty = 0;
					if(this._timeoutForWaiting)
					{
						clearTimeout(this._timeoutForWaiting);
						this._timeoutForWaiting = 0;
					}
					this._seeked = false;
					if(this._provider)
					{
						this._provider.setStuckToggle(false);
					}
					break;
				case "NetStream.Seek.Notify":
					if(_decoder.status != DecoderStatusEnum.STOPPED)
					{
						this.pushDataToDecoder();
					}
					break;
			}
		}
		
		private function onBufferEmpty() : void
		{
			clearTimeout(this._timeoutForEmpty);
			this._timeoutForEmpty = 0;
			if(this._provider)
			{
				this._provider.setStuckToggle(true);
			}
			_holder.runtimeData.bufferEmpty++;
			_holder.pingBack.sendError(4015);
		}
		
		private function onDecoderStatusChanged(param1:DecoderEvent) : void
		{
			this.updateStatusByDecoder();
		}
		
		private function onProviderFailed(param1:Event) : void
		{
			this._providerStateHandler.onFinalError(this._provider);
			this.executeFail();
		}
		
		private function executeFail() : void
		{
			if(this._provider)
			{
				this._provider.setLoadToggle(false);
			}
			if(this._timeoutForWaiting)
			{
				clearTimeout(this._timeoutForWaiting);
				this._timeoutForWaiting = 0;
			}
			if(_decoder.bufferLength <= _decoder.bufferTime)
			{
				this._openCheckDecoderData = false;
				this.closeListenDecoder();
				setStatus(StatusEnum.FAILED);
				dispatchEvent(new EngineEvent(EngineEvent.Evt_Error));
			}
		}
		
		private function waitingLongTime() : void
		{
			clearTimeout(this._timeoutForWaiting);
			this._timeoutForWaiting = 0;
			_holder.pingBack.sendError(4013);
			_holder.runtimeData.errorCode = 4013;
		}
		
		private function onAudioTrackChanged(param1:RateAgentEvent) : void
		{
			if((_holder.hasStatus(StatusEnum.ALREADY_READY)) && !_holder.hasStatus(StatusEnum.STOPPING) && !_holder.hasStatus(StatusEnum.STOPED) && !_holder.hasStatus(StatusEnum.FAILED))
			{
				dispatchEvent(new EngineEvent(EngineEvent.Evt_AudioTrackSwitched,param1.data));
				this.prepareSwitchMediaData();
			}
		}
		
		private function onDefinitionChanged(param1:RateAgentEvent) : void
		{
			if((_holder.hasStatus(StatusEnum.ALREADY_READY)) && !_holder.hasStatus(StatusEnum.STOPPING) && !_holder.hasStatus(StatusEnum.STOPED) && !_holder.hasStatus(StatusEnum.FAILED))
			{
				dispatchEvent(new EngineEvent(EngineEvent.Evt_DefinitionSwitched,param1.data));
				if(int(param1.data) >= 0)
				{
					this.prepareSwitchMediaData();
				}
			}
		}
		
		private function prepareSwitchMediaData() : void
		{
			this._definitionIsSwitched = true;
			if((_movie.curDefinition) && (_movie.curDefinition.ready))
			{
				this.onMovieMetaUpdate();
			}
			else
			{
				this._openCheckDecoderData = false;
				_movie.startLoadMeta();
				if(_movie.curDefinition.ready)
				{
					this.onMovieMetaUpdate();
				}
			}
		}
		
		private function onMovieMetaUpdate() : void
		{
			var _loc1:* = NaN;
			if(!this._provider.loadingFailed && !_holder.hasStatus(StatusEnum.IDLE) && !_holder.hasStatus(StatusEnum.STOPPING) && !_holder.hasStatus(StatusEnum.STOPED) && !_holder.hasStatus(StatusEnum.FAILED))
			{
				this.openListenDecoder();
				_loc1 = _decoder.time + _decoder.bufferLength * 1000;
				_movie.seek(_loc1);
				if(_movie.curSegment.currentKeyframe)
				{
					_loc1 = _movie.getSeekTime();
					this._provider.seek(_loc1,_movie.curAudioTrack.type.id,_movie.curDefinition.type.id);
				}
				else
				{
					_loc1 = _movie.curSegment.startTime;
					this._provider.seek(_loc1,_movie.curAudioTrack.type.id,_movie.curDefinition.type.id);
					_decoder.seek(_loc1 == 0?100:_loc1);
				}
				this._provider.setMetaInfo(this.createCurMetaInfo());
				this._openCheckDecoderData = true;
			}
		}
		
		override protected function updateStatusByDecoder() : void
		{
			if(_decoder)
			{
				switch(_decoder.status)
				{
					case DecoderStatusEnum.PLAYING:
						setStatus(StatusEnum.PLAYING);
						break;
					case DecoderStatusEnum.PAUSED:
						setStatus(StatusEnum.PAUSED);
						break;
					case DecoderStatusEnum.SEEKING:
						setStatus(StatusEnum.SEEKING);
						break;
					case DecoderStatusEnum.WAITING:
						setStatus(StatusEnum.WAITING);
						break;
				}
			}
		}
		
		override protected function onTimer(param1:TimerEvent) : void
		{
			if((_holder.hasStatus(StatusEnum.ALREADY_READY)) && !_holder.hasStatus(StatusEnum.STOPED))
			{
				super.onTimer(param1);
				this.checkDecoderData();
				if((this._provider) && (this._provider.fileState))
				{
					_holder.runtimeData.currentSpeed = this._provider.fileState.averageSpeed;
					_holder.runtimeData.currentAverageSpeed = this._provider.fileState.averageSpeed;
				}
			}
		}
		
		private function checkDecoderData() : void
		{
			if(this._openCheckDecoderData)
			{
				if((_decoder) && (!(_decoder.status == DecoderStatusEnum.STOPPED)) && _decoder.bufferLength * 1000 < Config.STREAM_NORMAL_BUFFER_TIME + 2000)
				{
					this.pushDataToDecoder();
				}
			}
		}
		
		private function pushDataToDecoder() : void
		{
			var _loc1:MediaData = null;
			if((this._provider) && (_decoder) && !this._provider.eof)
			{
				_loc1 = this._provider.sequenceReadData();
				if(_loc1)
				{
					DataModeDecoder(_decoder).appendData(_loc1);
					_log.info("decoder bufferLength: " + _decoder.bufferLength * 1000);
				}
				if(this._provider.eof)
				{
					DataModeDecoder(_decoder).endSequence();
				}
				if(this._provider.loadingFailed)
				{
					if(_decoder.bufferLength <= _decoder.bufferTime)
					{
						_log.debug("DMEngine pushDataToDecoder : provider is failed!");
						this.executeFail();
					}
				}
			}
		}
		
		private function onProviderStateChanged(param1:Event) : void
		{
			this._providerStateHandler.onStateChanged(this._provider);
		}
		
		private function onP2PReady(param1:Event) : void
		{
			_log.debug("DMEngine.onP2PReady, has status waiting startLoad or play : " + (_holder.hasStatus(StatusEnum.WAITING_START_LOAD) || _holder.hasStatus(StatusEnum.WAITING_PLAY)));
			if(ProcessesTimeRecord.usedTime_P2PCore == 0)
			{
				ProcessesTimeRecord.usedTime_P2PCore = getTimer() - ProcessesTimeRecord.STime_P2PCore;
			}
			if(Version.VERSION_FLASH_P2P == "")
			{
				Version.VERSION_FLASH_P2P = P2PFileLoader.instance.version;
				_log.info("P2P core load success, version: " + Version.VERSION_FLASH_P2P);
			}
			this.updateProvider();
			this.checkNeedStartLoad();
			this.checkNeedPlay();
		}
		
		private function onP2PError(param1:Event) : void
		{
			if(ProcessesTimeRecord.usedTime_P2PCore == 0)
			{
				ProcessesTimeRecord.usedTime_P2PCore = getTimer() - ProcessesTimeRecord.STime_P2PCore;
			}
			_log.info("P2P core load error!");
			this.executeFail();
		}
		
		private function updateProvider() : void
		{
			var _loc1:Boolean = !P2PFileLoader.instance.isLoading && (P2PFileLoader.instance.loadDone);
			var _loc2:Boolean = (_movie) && (_movie.curDefinition) && (_movie.curDefinition.ready);
			if((_loc1) && (_loc2))
			{
				_log.info("DMEngine.updateProvider, holder is preload : " + _holder.isPreload + " , _provider is null : " + !this._provider + " , switch definition : " + this._definitionIsSwitched);
				if(!this._provierIsCreated)
				{
					this.createProvider();
					this._rateAgent.bind(_decoder,_render,this._provider,_movie);
				}
				else if(this._definitionIsSwitched)
				{
					this.onMovieMetaUpdate();
				}
				
				this._definitionIsSwitched = false;
			}
		}
		
		override public function destroy() : void
		{
			if((_holder) && (_holder.pingBack))
			{
				_holder.pingBack.stopFlashP2PFailedCDN();
			}
			this._rateAgent.removeEventListener(RateAgentEvent.Evt_AudioTrackChanged,this.onAudioTrackChanged);
			this._rateAgent.removeEventListener(RateAgentEvent.Evt_DefinitionChanged,this.onDefinitionChanged);
			this._rateAgent.destroy();
			this._rateAgent = null;
			if(this._provider)
			{
				this._provider.removeEventListener(ProviderEvent.Evt_Failed,this.onProviderFailed);
				this._provider.removeEventListener(ProviderEvent.Evt_StateChanged,this.onProviderStateChanged);
				this._provider.destroy();
				this._provider = null;
			}
			this._providerStateHandler = null;
			if(_movie)
			{
				_movie.removeEventListener(MovieEvent.Evt_UpdateSkipPoint,this.onUpdateSkipPoint);
			}
			if(_decoder)
			{
				_decoder.removeEventListener(NetStatusEvent.NET_STATUS,this.onDecoderNetStatus);
				_decoder.removeEventListener(DecoderEvent.Evt_StatusChanged,this.onDecoderStatusChanged);
				_decoder.destroy();
				_decoder = null;
			}
			if(this._timeoutForWaiting)
			{
				clearTimeout(this._timeoutForWaiting);
				this._timeoutForWaiting = 0;
			}
			if(this._timeoutForEmpty)
			{
				clearTimeout(this._timeoutForEmpty);
				this._timeoutForEmpty = 0;
			}
			P2PFileLoader.instance.removeEventListener(P2PFileLoader.Evt_LoadDone,this.onP2PReady);
			P2PFileLoader.instance.removeEventListener(P2PFileLoader.Evt_LoadError,this.onP2PError);
			super.destroy();
		}
	}
}
