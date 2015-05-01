package com.qiyi.player.core.video.engine {
	import flash.events.EventDispatcher;
	import com.qiyi.player.core.player.coreplayer.ICorePlayer;
	import com.qiyi.player.core.model.IMovie;
	import com.qiyi.player.core.video.render.IRender;
	import com.qiyi.player.core.video.decoder.IDecoder;
	import com.qiyi.player.base.pub.EnumItem;
	import com.qiyi.player.core.model.impls.SkipPointInfo;
	import com.qiyi.player.base.logging.ILogger;
	import com.qiyi.player.core.player.def.StatusEnum;
	import flash.net.NetStreamInfo;
	import com.qiyi.player.core.model.events.MovieEvent;
	import com.qiyi.player.core.model.impls.Keyframe;
	import com.qiyi.player.core.model.impls.Segment;
	import com.qiyi.player.core.model.def.StreamEnum;
	import flash.utils.*;
	import com.qiyi.player.core.model.impls.pub.Settings;
	import com.qiyi.player.core.Config;
	import com.qiyi.player.core.history.events.HistoryEvent;
	import flash.events.TimerEvent;
	import com.qiyi.player.core.video.def.StopReasonEnum;
	import com.qiyi.player.core.video.def.DecoderStatusEnum;
	import com.qiyi.player.core.player.def.PlayerUseTypeEnum;
	import com.qiyi.player.core.model.impls.pub.Statistics;
	import com.qiyi.player.core.video.events.EngineEvent;
	import flash.events.Event;
	import com.qiyi.player.base.logging.Log;
	
	public class BaseEngine extends EventDispatcher implements IEngine {
		
		public function BaseEngine(param1:ICorePlayer) {
			this._log = Log.getLogger("com.qiyi.player.core.video.engine.BaseEngine");
			super();
			this._holder = param1;
			this._timer = new Timer(200);
			this._timer.addEventListener(TimerEvent.TIMER,this.onTimer);
			this._timer.start();
			Settings.instance.addEventListener(Settings.Evt_SkipTitleChanged,this.onSkipTitleChanged);
			Settings.instance.addEventListener(Settings.Evt_SkipTrailerChanged,this.onSkipTrailerChanged);
			if(this._holder.history) {
				this._holder.history.addEventListener(HistoryEvent.Evt_Ready,this.onHistoryReady);
			}
		}
		
		protected var _holder:ICorePlayer;
		
		protected var _movie:IMovie;
		
		protected var _render:IRender;
		
		protected var _decoder:IDecoder;
		
		protected var _seekTime:int;
		
		protected var _startTime:int;
		
		private var _timer:Timer;
		
		private var _playingDuration:int = 0;
		
		private var _playingDurationStartTime:int = 0;
		
		private var _startPlayTime:int = 0;
		
		private var _stopPlayTime:int = 0;
		
		private var _lastDuration:int = 0;
		
		private var _stopReason:EnumItem;
		
		private var _stopTimeOut:uint;
		
		private var _needDispatchPrepareStop:Boolean = true;
		
		private var _needDispatchPrepareSkipPoint:Boolean = true;
		
		private var _needDispatchEnterSkipPoint:Boolean = true;
		
		private var _curSkipPointInfo:SkipPointInfo;
		
		private var _oldCurrentTime:uint = 0;
		
		protected var _log:ILogger;
		
		public function get movie() : IMovie {
			return this._movie;
		}
		
		public function get status() : EnumItem {
			return null;
		}
		
		public function get currentTime() : int {
			return 0;
		}
		
		public function get bufferTime() : int {
			return 0;
		}
		
		public function get bufferRate() : Number {
			return 0;
		}
		
		public function get waitingDuration() : int {
			if((this._holder.hasStatus(StatusEnum.STOPPING)) || (this._holder.hasStatus(StatusEnum.STOPED))) {
				return this._stopPlayTime - this._startPlayTime - this.playingDuration;
			}
			return getTimer() - this.playingDuration - this._startPlayTime;
		}
		
		public function get playingDuration() : int {
			if(this._holder.hasStatus(StatusEnum.PLAYING)) {
				return this._playingDuration + getTimer() - this._playingDurationStartTime;
			}
			return this._playingDuration;
		}
		
		public function get stopReason() : EnumItem {
			return this._stopReason;
		}
		
		public function get frameRate() : int {
			return this._decoder?this._decoder.netstream.currentFPS:0;
		}
		
		public function get decoderInfo() : NetStreamInfo {
			try {
				return this._decoder?this._decoder.netstream.info:null;
			}
			catch(error:Error) {
			}
			return null;
		}
		
		public function set openSelectPlay(param1:Boolean) : void {
		}
		
		public function bind(param1:IMovie, param2:IRender) : void {
			if(this._movie) {
				this._movie.removeEventListener(MovieEvent.Evt_Ready,this.onMovieReady);
			}
			this._movie = param1;
			this._movie.addEventListener(MovieEvent.Evt_Ready,this.onMovieReady);
			this._render = param2;
			this._startTime = 0;
			this._oldCurrentTime = 0;
			this._seekTime = 0;
			this._holder.runtimeData.currentDefinition = this._movie.curDefinition.type.id.toString();
			this._holder.runtimeData.movieInfo = "tv_" + this._movie.albumId + "_" + this._movie.tvid + "_" + this._movie.vid;
			this._holder.runtimeData.endTime = 0;
			if(this._holder.runtimeData.originalEndTime > 0) {
				this._holder.runtimeData.endTime = this._holder.runtimeData.originalEndTime;
				if(this._holder.runtimeData.endTime >= this._movie.duration) {
					this._holder.runtimeData.endTime = 0;
				}
			}
		}
		
		public function startLoadMeta() : void {
			if(this._holder.hasStatus(StatusEnum.META_START_LOAD_CALLED)) {
				return;
			}
			this._holder.addStatus(StatusEnum.META_START_LOAD_CALLED,false);
			if(this._movie.curDefinition) {
				if(!this._movie.curDefinition.ready) {
					this._movie.startLoadMeta();
					if(this._movie.curDefinition.ready) {
						this.onMovieReady(null);
					}
				} else {
					this.onMovieReady(null);
				}
			}
		}
		
		public function startLoadHistory() : void {
			if((this._holder.hasStatus(StatusEnum.HISTORY_START_LOAD_CALLED)) || this._holder.history == null) {
				return;
			}
			this._holder.addStatus(StatusEnum.HISTORY_START_LOAD_CALLED,false);
			if(this._movie.curDefinition) {
				if(this._holder.history.getReady() == false) {
					this._holder.history.loadRecord(this._movie.tvid);
				} else {
					this.onHistoryReady(null);
				}
			}
		}
		
		public function startLoadP2PCore() : void {
		}
		
		public function startLoad() : void {
			if(this._holder.hasStatus(StatusEnum.IDLE)) {
				throw new Error("please execute function of \'bind\' firstly!");
			} else {
				if(this._startTime == 0) {
					this._startTime = this._holder.strategy.getStartTime();
				}
				this._log.info("Engine:startLoad, startTime(" + this._startTime + ")" + ",preloader(" + this._holder.runtimeData.isPreload + ")");
				return;
			}
		}
		
		public function stopLoad() : void {
			this._holder.removeStatus(StatusEnum.WAITING_START_LOAD,false);
			this._holder.removeStatus(StatusEnum.ALREADY_START_LOAD);
			this._log.info("Engine:stopLoad, preloader(" + this._holder.runtimeData.isPreload + ")");
		}
		
		public function play() : void {
			if(this._holder.hasStatus(StatusEnum.IDLE)) {
				throw new Error("please execute function of \'bind\' firstly!");
			} else if((this._holder.hasStatus(StatusEnum.STOPPING)) || (this._holder.hasStatus(StatusEnum.STOPED))) {
				throw new Error("failed to play, the status of engine is stopped");
			} else {
				this._holder.runtimeData.bufferEmpty = 0;
				this._startPlayTime = getTimer();
				if(this.checkEngineIsReady()) {
					this.updateVideoStartTime();
					this.onStartPlay();
				}
				this.setStatus(StatusEnum.ALREADY_PLAY);
				this._log.info("Engine:play called");
				return;
			}
			
		}
		
		public function replay() : void {
			this._startTime = this._holder.strategy.getStartTime();
			this._oldCurrentTime = this._startTime;
			this.seek(this._startTime);
			this.resume();
		}
		
		public function pause(param1:int = 0) : void {
			if(this._decoder) {
				this._decoder.pause();
			}
		}
		
		public function resume() : void {
			if(this._decoder) {
				this._decoder.resume();
			}
		}
		
		public function stop(param1:EnumItem) : void {
			if(this._holder.hasStatus(StatusEnum.IDLE)) {
				return;
			}
			this._seekTime = 0;
			if(this._movie) {
				this._movie.removeEventListener(MovieEvent.Evt_Ready,this.onMovieReady);
			}
			if(!this._holder.hasStatus(StatusEnum.STOPPING) && !this._holder.hasStatus(StatusEnum.STOPED)) {
				this._stopReason = param1;
			}
			this.setStatus(StatusEnum.STOPPING);
			this._playingDurationStartTime = 0;
			this._playingDuration = 0;
			this._lastDuration = 0;
			this._stopPlayTime = 0;
			this._startPlayTime = 0;
			this._startTime = 0;
			this._oldCurrentTime = 0;
		}
		
		public function seek(param1:uint, param2:int = 0) : void {
			var _loc6_:Keyframe = null;
			if(this._holder.hasStatus(StatusEnum.IDLE)) {
				throw new Error("please execute function of \'bind\' firstly!");
			} else {
				if(this._movie == null || !this._movie.curDefinition) {
					return;
				}
				this._log.info("Engine:seek(" + param1 + ")");
				this._movie.seek(param1);
				var _loc3_:Segment = this._movie.curSegment;
				var _loc4_:Keyframe = _loc3_.currentKeyframe;
				if(this._movie.streamType == StreamEnum.HTTP) {
					if(_loc4_) {
						if(_loc3_.keyframes.length >= 2 && _loc4_.index == _loc3_.keyframes.length - 1) {
							_loc6_ = _loc3_.keyframes[_loc3_.keyframes.length - 2];
							this._seekTime = _loc6_.time;
							this._movie.seek(this._seekTime);
							_loc3_ = this._movie.curSegment;
							_loc4_ = _loc3_.currentKeyframe;
							this._seekTime = _loc4_.time;
						} else {
							this._seekTime = _loc4_.time;
						}
					} else {
						this._seekTime = _loc3_.startTime;
					}
				} else {
					this._seekTime = param1;
				}
				if(this._seekTime > this._holder.runtimeData.endTime) {
					this._holder.runtimeData.endTime = 0;
				}
				var _loc5_:int = this._holder.runtimeData.endTime > 0?this._holder.runtimeData.endTime:this._movie.duration;
				if(_loc5_ - this._seekTime < this._holder.runtimeData.prepareToPlayEnd) {
					this._needDispatchPrepareStop = true;
				}
				if(Settings.instance.skipTrailer) {
					if(this._movie.streamType == StreamEnum.HTTP) {
						if((this._movie.trailerTime > 0) && (_loc4_) && _loc4_.time < this._movie.trailerTime) {
							this._holder.runtimeData.skipTrailer = true;
						} else {
							this._holder.runtimeData.skipTrailer = false;
						}
					} else if(this._movie.trailerTime > 0 && this._seekTime < this._movie.trailerTime) {
						this._holder.runtimeData.skipTrailer = true;
					} else {
						this._holder.runtimeData.skipTrailer = false;
					}
					
				} else {
					this._holder.runtimeData.skipTrailer = false;
				}
				if(this._decoder) {
					if(_loc5_ - this._seekTime < Config.STREAM_NORMAL_BUFFER_TIME && _loc5_ - this._seekTime > 0) {
						this._decoder.bufferTime = Config.STREAM_SHORT_BUFFER_TIME / 1000;
					} else {
						this._decoder.bufferTime = Config.STREAM_NORMAL_BUFFER_TIME / 1000;
					}
				}
				return;
			}
		}
		
		public function destroy() : void {
			Settings.instance.removeEventListener(Settings.Evt_SkipTitleChanged,this.onSkipTitleChanged);
			Settings.instance.removeEventListener(Settings.Evt_SkipTrailerChanged,this.onSkipTrailerChanged);
			if(this._movie) {
				this._movie.removeEventListener(MovieEvent.Evt_Ready,this.onMovieReady);
				this._movie = null;
			}
			if(this._holder.history) {
				this._holder.history.removeEventListener(HistoryEvent.Evt_Ready,this.onHistoryReady);
			}
			this._holder = null;
			this._render = null;
			if(this._stopTimeOut != 0) {
				clearTimeout(this._stopTimeOut);
				this._stopTimeOut = 0;
			}
			this._timer.stop();
			this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
			this._timer = null;
		}
		
		protected function setStatus(param1:int) : void {
			var _loc2_:uint = 0;
			var _loc3_:* = 0;
			if((this._holder.hasStatus(StatusEnum.STOPED)) && param1 == StatusEnum.STOPPING) {
				return;
			}
			if(!this._holder.hasStatus(param1)) {
				_loc2_ = 0;
				_loc3_ = getTimer();
				switch(param1) {
					case StatusEnum.ALREADY_READY:
						this._holder.removeStatus(StatusEnum.IDLE);
						this._holder.removeStatus(StatusEnum.ALREADY_LOAD_MOVIE);
						this._holder.removeStatus(StatusEnum.STOPPING);
						this._holder.removeStatus(StatusEnum.STOPED);
						this._log.info("engine status changed: already ready");
						break;
					case StatusEnum.ALREADY_START_LOAD:
						this._log.info("engine status changed: already startLoad");
						break;
					case StatusEnum.ALREADY_PLAY:
						this._holder.removeStatus(StatusEnum.WAITING_START_LOAD,false);
						this._log.info("engine status changed: already play");
						break;
					case StatusEnum.PLAYING:
						this._holder.removeStatus(StatusEnum.PAUSED);
						this._holder.removeStatus(StatusEnum.SEEKING);
						this._holder.removeStatus(StatusEnum.WAITING);
						this._holder.removeStatus(StatusEnum.STOPPING);
						this._holder.removeStatus(StatusEnum.STOPED);
						this._holder.removeStatus(StatusEnum.FAILED);
						this._log.info("engine status changed: playing");
						break;
					case StatusEnum.PAUSED:
						this._holder.removeStatus(StatusEnum.PLAYING);
						this._holder.removeStatus(StatusEnum.STOPPING);
						this._holder.removeStatus(StatusEnum.STOPED);
						this._holder.removeStatus(StatusEnum.FAILED);
						this._log.info("engine status changed: paused");
						break;
					case StatusEnum.SEEKING:
						this._holder.removeStatus(StatusEnum.PLAYING);
						this._holder.removeStatus(StatusEnum.WAITING);
						this._holder.removeStatus(StatusEnum.STOPPING);
						this._holder.removeStatus(StatusEnum.STOPED);
						this._holder.removeStatus(StatusEnum.FAILED);
						this._log.info("engine status changed: seeking");
						break;
					case StatusEnum.WAITING:
						this._holder.removeStatus(StatusEnum.PLAYING);
						this._holder.removeStatus(StatusEnum.SEEKING);
						this._holder.removeStatus(StatusEnum.STOPPING);
						this._holder.removeStatus(StatusEnum.STOPED);
						this._holder.removeStatus(StatusEnum.FAILED);
						this._log.info("engine status changed: waiting");
						break;
					case StatusEnum.STOPPING:
						this._holder.removeStatus(StatusEnum.PLAYING);
						this._holder.removeStatus(StatusEnum.PAUSED);
						this._holder.removeStatus(StatusEnum.SEEKING);
						this._holder.removeStatus(StatusEnum.WAITING);
						this._holder.removeStatus(StatusEnum.STOPED);
						this._holder.removeStatus(StatusEnum.FAILED);
						this._holder.removeStatus(StatusEnum.WAITING_START_LOAD,false);
						this._holder.removeStatus(StatusEnum.WAITING_PLAY,false);
						this._log.info("engine status changed: stopping");
						break;
					case StatusEnum.STOPED:
						this._holder.removeStatus(StatusEnum.PLAYING);
						this._holder.removeStatus(StatusEnum.PAUSED);
						this._holder.removeStatus(StatusEnum.SEEKING);
						this._holder.removeStatus(StatusEnum.WAITING);
						this._holder.removeStatus(StatusEnum.STOPPING);
						this._holder.removeStatus(StatusEnum.FAILED);
						this._holder.removeStatus(StatusEnum.WAITING_START_LOAD,false);
						this._holder.removeStatus(StatusEnum.WAITING_PLAY,false);
						this._log.info("engine status changed: stopped");
						break;
					case StatusEnum.FAILED:
						this._holder.removeStatus(StatusEnum.PLAYING);
						this._holder.removeStatus(StatusEnum.PAUSED);
						this._holder.removeStatus(StatusEnum.SEEKING);
						this._holder.removeStatus(StatusEnum.WAITING);
						this._holder.removeStatus(StatusEnum.STOPPING);
						this._holder.removeStatus(StatusEnum.STOPED);
						this._holder.removeStatus(StatusEnum.WAITING_START_LOAD,false);
						this._holder.removeStatus(StatusEnum.WAITING_PLAY,false);
						this._log.info("engine status changed: failed");
						break;
				}
				if(param1 == StatusEnum.STOPPING) {
					this._stopPlayTime = _loc3_;
				} else {
					this._stopPlayTime = 0;
				}
				this._holder.addStatus(param1);
				if(param1 == StatusEnum.PLAYING) {
					this._playingDurationStartTime = _loc3_;
					this._seekTime = -1;
				} else {
					if(this._playingDurationStartTime > 0) {
						this._playingDuration = this._playingDuration + (_loc3_ - this._playingDurationStartTime);
					}
					this._playingDurationStartTime = 0;
				}
				if(param1 == StatusEnum.STOPPING && (this._holder.history)) {
					if(this.stopReason == StopReasonEnum.SKIP_TRAILER || this.stopReason == StopReasonEnum.STOP) {
						this._holder.history.update(0);
					}
					this._holder.history.flush();
					if(this._stopTimeOut != 0) {
						clearTimeout(this._stopTimeOut);
						this._stopTimeOut = 0;
					}
					this._stopTimeOut = setTimeout(this.stopedHandler,60);
				} else if(this._stopTimeOut != 0) {
					clearTimeout(this._stopTimeOut);
					this._stopTimeOut = 0;
				}
				
			}
		}
		
		protected function selfStop(param1:EnumItem) : void {
			if(this._holder.hasStatus(StatusEnum.IDLE)) {
				return;
			}
			this._seekTime = 0;
			if(!this._holder.hasStatus(StatusEnum.STOPPING) && !this._holder.hasStatus(StatusEnum.STOPED)) {
				this._stopReason = param1;
			}
			this.setStatus(StatusEnum.STOPPING);
			this._playingDurationStartTime = 0;
			this._playingDuration = 0;
			this._lastDuration = 0;
			this._stopPlayTime = 0;
			this._startPlayTime = 0;
			this._startTime = 0;
			this._oldCurrentTime = 0;
		}
		
		protected function updateStatusByDecoder() : void {
			if(this._decoder) {
				switch(this._decoder.status) {
					case DecoderStatusEnum.PLAYING:
						this.setStatus(StatusEnum.PLAYING);
						break;
					case DecoderStatusEnum.PAUSED:
						this.setStatus(StatusEnum.PAUSED);
						break;
					case DecoderStatusEnum.SEEKING:
						this.setStatus(StatusEnum.SEEKING);
						break;
					case DecoderStatusEnum.WAITING:
						this.setStatus(StatusEnum.WAITING);
						break;
					case DecoderStatusEnum.FAILED:
						this.setStatus(StatusEnum.FAILED);
						break;
				}
			}
		}
		
		protected function onTimer(param1:TimerEvent) : void {
			if(this._holder.runtimeData.playerUseType != PlayerUseTypeEnum.MAIN) {
				return;
			}
			if((this._holder.hasStatus(StatusEnum.STOPPING)) || (this._holder.hasStatus(StatusEnum.STOPED)) || (this._holder.hasStatus(StatusEnum.FAILED))) {
				return;
			}
			var _loc2_:uint = this.currentTime;
			if(((this._holder.hasStatus(StatusEnum.PLAYING)) || (this._holder.hasStatus(StatusEnum.SEEKING)) || (this._holder.hasStatus(StatusEnum.WAITING))) && this.playingDuration > 1000) {
				if((this._holder.runtimeData.recordHistory && _loc2_ > 1000) && (this._holder.history) && (this._holder.hasStatus(StatusEnum.ALREADY_PLAY))) {
					this._holder.history.update(_loc2_);
				}
				Statistics.instance.addDuration(this.playingDuration - this._lastDuration);
				this._lastDuration = this.playingDuration;
			}
			if(!this._holder.hasStatus(StatusEnum.PLAYING)) {
				return;
			}
			if(_loc2_ > this._movie.duration + 100000) {
				this._log.warn("Decoder currentTime error! currentTime:" + _loc2_ + ",oldCurrentTime:" + this._oldCurrentTime + ",duration:" + this._movie.duration);
				this.seek(this._oldCurrentTime);
				return;
			}
			this._oldCurrentTime = _loc2_;
			var _loc3_:int = this._movie.skipPointInfoCount;
			var _loc4_:SkipPointInfo = null;
			var _loc5_:* = 0;
			while(_loc5_ < _loc3_) {
				_loc4_ = this._movie.getSkipPointInfoAt(_loc5_) as SkipPointInfo;
				if(_loc4_ == null) {
					break;
				}
				if(this._holder.runtimeData.prepareToSkipPoint > 0 && _loc4_.startTime - _loc2_ <= this._holder.runtimeData.prepareToSkipPoint && _loc4_.startTime - _loc2_ > 0) {
					_loc4_.inCurPrepareSkipPoint = true;
					_loc4_.outPrepareSkipPointFlag = false;
					if(!_loc4_.enterPrepareSkipPointFlag) {
						_loc4_.enterPrepareSkipPointFlag = true;
						dispatchEvent(new EngineEvent(EngineEvent.Evt_EnterPrepareSkipPoint,_loc4_));
					}
				} else {
					if(_loc4_.inCurPrepareSkipPoint) {
						if(!_loc4_.outPrepareSkipPointFlag) {
							_loc4_.outPrepareSkipPointFlag = true;
							dispatchEvent(new EngineEvent(EngineEvent.Evt_OutPrepareSkipPoint,_loc4_));
						}
					}
					_loc4_.inCurPrepareSkipPoint = false;
					_loc4_.enterPrepareSkipPointFlag = false;
				}
				if(this._holder.runtimeData.prepareLeaveSkipPoint > 0 && _loc4_.endTime - _loc2_ < this._holder.runtimeData.prepareLeaveSkipPoint && _loc4_.endTime - _loc2_ >= 0) {
					_loc4_.inCurPrepareLeaveSkipPoint = true;
					_loc4_.outPrepareLeaveSkipPointFlag = false;
					if(!_loc4_.enterPrepareLeaveSkipPointFlag) {
						_loc4_.enterPrepareLeaveSkipPointFlag = true;
						dispatchEvent(new EngineEvent(EngineEvent.Evt_EnterPrepareLeaveSkipPoint,_loc4_));
					}
				} else {
					if(_loc4_.inCurPrepareLeaveSkipPoint) {
						if(!_loc4_.outPrepareLeaveSkipPointFlag) {
							_loc4_.outPrepareLeaveSkipPointFlag = true;
							dispatchEvent(new EngineEvent(EngineEvent.Evt_OutPrepareLeaveSkipPoint,_loc4_));
						}
					}
					_loc4_.inCurPrepareLeaveSkipPoint = false;
					_loc4_.enterPrepareLeaveSkipPointFlag = false;
				}
				if(_loc2_ >= _loc4_.startTime && _loc2_ < _loc4_.endTime) {
					_loc4_.inCurSkipPoint = true;
					_loc4_.outSkipPointFlag = false;
					if(!_loc4_.enterSkipPointFlag) {
						_loc4_.enterSkipPointFlag = true;
						dispatchEvent(new EngineEvent(EngineEvent.Evt_EnterSkipPoint,_loc4_));
					}
				} else {
					if(_loc4_.inCurSkipPoint) {
						if(!_loc4_.outSkipPointFlag) {
							_loc4_.outSkipPointFlag = true;
							dispatchEvent(new EngineEvent(EngineEvent.Evt_OutSkipPoint,_loc4_));
						}
					}
					_loc4_.inCurSkipPoint = false;
					_loc4_.enterSkipPointFlag = false;
				}
				_loc5_++;
			}
			if((this._holder.hasStatus(StatusEnum.STOPPING)) || (this._holder.hasStatus(StatusEnum.STOPED)) || (this._holder.hasStatus(StatusEnum.FAILED))) {
				return;
			}
			var _loc6_:* = 0;
			if(this._holder.runtimeData.originalEndTime > 0) {
				_loc6_ = this._holder.runtimeData.originalEndTime;
			} else if(this._movie.trailerTime > 0 && (this._holder.runtimeData.skipTrailer)) {
				_loc6_ = this._movie.trailerTime;
			} else {
				_loc6_ = this._movie.duration;
			}
			
			if(this._holder.runtimeData.prepareToPlayEnd > 0 && _loc6_ - _loc2_ <= this._holder.runtimeData.prepareToPlayEnd) {
				if(this._needDispatchPrepareStop) {
					this._needDispatchPrepareStop = false;
					this._log.info("prepare to end,curTime:" + _loc2_ + ",duration:" + this._movie.duration + ",endTime:" + _loc6_);
					dispatchEvent(new EngineEvent(EngineEvent.Evt_PreparePlayEnd));
				}
			} else {
				this._needDispatchPrepareStop = true;
			}
			if(this._holder.runtimeData.originalEndTime > 0) {
				if(_loc2_ >= this._holder.runtimeData.originalEndTime) {
					this._log.info("arrive at endTime,curTime:" + _loc2_ + ",duration:" + this._movie.duration + ",appdata.endTime:" + this._holder.runtimeData.originalEndTime);
					this.selfStop(StopReasonEnum.REACH_ASSIGN);
				}
				return;
			}
			if((this._holder.runtimeData.skipTrailer) && this._movie.trailerTime > 0) {
				if(_loc2_ >= this._movie.trailerTime) {
					this._log.info("skip trailer,curTime:" + _loc2_ + ",duration:" + this._movie.duration + ",trailerTime:" + this._movie.trailerTime);
					dispatchEvent(new EngineEvent(EngineEvent.Evt_SkipTrailer));
					this.selfStop(StopReasonEnum.SKIP_TRAILER);
				}
			}
		}
		
		protected function stopedHandler() : void {
			if(this._stopTimeOut != 0) {
				clearTimeout(this._stopTimeOut);
				this._stopTimeOut = 0;
			}
			this.setStatus(StatusEnum.STOPED);
		}
		
		protected function onSkipTitleChanged(param1:Event) : void {
			if((Settings.instance.skipTitle) && this.currentTime <= this._movie.titlesTime && this._movie.titlesTime > 0) {
				this.seek(this._movie.titlesTime);
			}
		}
		
		protected function onSkipTrailerChanged(param1:Event) : void {
			if((this._holder.hasStatus(StatusEnum.STOPPING)) || (this._holder.hasStatus(StatusEnum.STOPED)) || this._movie == null) {
				return;
			}
			if((Settings.instance.skipTrailer) && this._movie.trailerTime > 0 && this.currentTime < this._movie.trailerTime) {
				this._holder.runtimeData.skipTrailer = true;
			} else {
				this._holder.runtimeData.skipTrailer = false;
			}
			if((Settings.instance.skipTrailer) && this._movie.trailerTime > 0 && this.currentTime >= this._movie.trailerTime) {
				dispatchEvent(new EngineEvent(EngineEvent.Evt_SkipTrailer));
				this.selfStop(StopReasonEnum.SKIP_TRAILER);
			}
		}
		
		protected function onMovieReady(param1:Event) : void {
			this._log.debug("Engine.onMovieReady, has status waiting startLoad or play : " + (this._holder.hasStatus(StatusEnum.WAITING_START_LOAD) || this._holder.hasStatus(StatusEnum.WAITING_PLAY)));
			this.checkNeedStartLoad();
			this.checkNeedPlay();
		}
		
		protected function onHistoryReady(param1:Event) : void {
			this._log.debug("Engine.onHistoryReady, has status waiting startLoad or play : " + (this._holder.hasStatus(StatusEnum.WAITING_START_LOAD) || this._holder.hasStatus(StatusEnum.WAITING_PLAY)));
			this.updateVideoStartTime();
			this.checkNeedStartLoad();
			this.checkNeedPlay();
		}
		
		protected function checkNeedStartLoad() : void {
			if((this._holder.hasStatus(StatusEnum.WAITING_START_LOAD)) && (this.checkEngineIsReady())) {
				this._holder.removeStatus(StatusEnum.WAITING_START_LOAD,false);
				this.seek(this._startTime);
			}
		}
		
		protected function checkNeedPlay() : void {
			if((this._holder.hasStatus(StatusEnum.WAITING_PLAY)) && (this.checkEngineIsReady())) {
				this._holder.removeStatus(StatusEnum.WAITING_PLAY,false);
				this.onStartPlay();
				this._log.info("Engine.checkNeedPlay, startTime = " + (this._seekTime > 0?this._seekTime:this._startTime));
				this.seek(this._seekTime > 0?this._seekTime:this._startTime);
			}
		}
		
		protected function checkEngineIsReady() : Boolean {
			var _loc1_:Boolean = (this._movie) && (this._movie.curDefinition) && (this._movie.curDefinition.ready);
			var _loc2_:Boolean = (this._holder.history) && (this._holder.history.getReady()) || !(this._holder.runtimeData.playerUseType == PlayerUseTypeEnum.MAIN);
			return (_loc1_) && (_loc2_);
		}
		
		private function updateVideoStartTime() : void {
			if(!this._holder.hasStatus(StatusEnum.ALREADY_READY) || this._holder.movie == null) {
				return;
			}
			if(this._startTime == 0) {
				this._startTime = this._holder.strategy.getStartTime();
			}
			this._holder.runtimeData.startPlayTime = this._startTime;
			this._oldCurrentTime = this._startTime;
			this._log.info("Engine:updateVideoStartTime, startTime(" + this._startTime + ")");
		}
		
		private function onStartPlay() : void {
			if(this._holder.runtimeData.startFromHistory) {
				dispatchEvent(new EngineEvent(EngineEvent.Evt_StartFromHistory,this._startTime));
			} else if((Settings.instance.skipTitle) && this._movie.titlesTime > 0 && this._movie.titlesTime == this._startTime) {
				dispatchEvent(new EngineEvent(EngineEvent.Evt_SkipTitle));
			}
			
		}
	}
}
