package com.qiyi.player.core.video.engine.http {
	import com.qiyi.player.core.video.engine.BaseEngine;
	import com.qiyi.player.core.model.IMovie;
	import com.qiyi.player.core.video.render.IRender;
	import com.qiyi.player.core.player.def.StatusEnum;
	import com.qiyi.player.base.pub.EnumItem;
	import com.qiyi.player.core.video.events.DecoderEvent;
	import com.qiyi.player.core.model.impls.pub.Settings;
	import com.qiyi.player.core.model.impls.Segment;
	import com.qiyi.player.core.model.impls.Definition;
	import com.qiyi.player.core.video.events.ProviderEvent;
	import flash.events.TimerEvent;
	import com.qiyi.player.core.video.def.StopReasonEnum;
	import com.qiyi.player.core.video.events.EngineEvent;
	import flash.events.Event;
	import com.qiyi.player.core.player.coreplayer.ICorePlayer;
	
	public class HttpEngine extends BaseEngine {
		
		public function HttpEngine(param1:ICorePlayer) {
			super(param1);
			Settings.instance.addEventListener(Settings.Evt_AudioTrackChanged,this.onAudioTrackChanged);
			Settings.instance.addEventListener(Settings.Evt_DefinitionChanged,this.onDefinitionChanged);
		}
		
		private var _streams:Vector.<HttpStream>;
		
		private var _loadingStream:HttpStream;
		
		private var _playingStream:HttpStream;
		
		private var _paused:Boolean = false;
		
		private var _definitionIsSwitched:Boolean;
		
		override public function get bufferTime() : int {
			if(this._streams == null || this._playingStream == null) {
				return 0;
			}
			if(!this._playingStream.loadComplete) {
				return this._playingStream.bufferTime;
			}
			var _loc1_:int = this._playingStream.bufferTime;
			var _loc2_:HttpStream = null;
			var _loc3_:int = this._playingStream.segment.index + 1;
			while(_loc3_ < this._streams.length) {
				_loc2_ = this._streams[_loc3_];
				if((_loc2_.loadComplete) && _loc2_.startTime == 0) {
					_loc1_ = _loc2_.segment.endTime;
					_loc3_++;
					continue;
				}
				if(_loc2_ == this._loadingStream) {
					_loc1_ = this._loadingStream.bufferTime;
				}
				break;
			}
			return _loc1_;
		}
		
		override public function get currentTime() : int {
			if(this._playingStream) {
				return this._playingStream.time;
			}
			return 0;
		}
		
		override public function bind(param1:IMovie, param2:IRender) : void {
			super.bind(param1,param2);
			this._definitionIsSwitched = false;
			this.createStream();
			setStatus(StatusEnum.ALREADY_READY);
		}
		
		override public function startLoad() : void {
			super.startLoad();
			this.pause();
			if(checkEngineIsReady()) {
				this.seek(_startTime);
			} else {
				_holder.addStatus(StatusEnum.WAITING_START_LOAD,false);
				startLoadHistory();
				startLoadMeta();
			}
			setStatus(StatusEnum.ALREADY_START_LOAD);
		}
		
		override public function play() : void {
			super.play();
			this.resume();
			if(checkEngineIsReady()) {
				this.seek(_startTime);
			} else {
				_holder.addStatus(StatusEnum.WAITING_PLAY,false);
				startLoadHistory();
				startLoadMeta();
			}
		}
		
		override public function pause(param1:int = 0) : void {
			this._paused = true;
			if((this._playingStream) && !this._playingStream.failed) {
				this._playingStream.pause();
			}
		}
		
		override public function resume() : void {
			this._paused = false;
			if((this._playingStream) && !this._playingStream.failed) {
				this._playingStream.resume();
			}
		}
		
		override public function seek(param1:uint, param2:int = 0) : void {
			_seekTime = param1;
			if(this._streams == null) {
				this.createStream();
			}
			if(checkEngineIsReady()) {
				super.seek(_seekTime,param2);
				if(this._loadingStream == null || !(this._loadingStream.segment == _movie.curSegment)) {
					this.switchLoadSegment(this._streams[_movie.curSegment.index]);
				}
				if(this._playingStream == null || !(this._playingStream.segment == _movie.curSegment)) {
					this.switchPlaySegment(this._streams[_movie.curSegment.index]);
				} else {
					this._playingStream.seek(_seekTime);
				}
			}
		}
		
		override public function stop(param1:EnumItem) : void {
			if(_decoder) {
				_decoder.removeEventListener(DecoderEvent.Evt_StatusChanged,this.onDecoderStatusChanged);
				_decoder.stop();
				_decoder = null;
			}
			this.destroyStream();
			super.stop(param1);
		}
		
		override protected function selfStop(param1:EnumItem) : void {
			if(_decoder) {
				_decoder.removeEventListener(DecoderEvent.Evt_StatusChanged,this.onDecoderStatusChanged);
				_decoder.stop();
				_decoder = null;
			}
			this.destroyStream();
			super.selfStop(param1);
		}
		
		override public function destroy() : void {
			if(_decoder) {
				_decoder.removeEventListener(DecoderEvent.Evt_StatusChanged,this.onDecoderStatusChanged);
				_decoder = null;
			}
			Settings.instance.removeEventListener(Settings.Evt_AudioTrackChanged,this.onAudioTrackChanged);
			Settings.instance.removeEventListener(Settings.Evt_DefinitionChanged,this.onDefinitionChanged);
			this.destroyStream();
			super.destroy();
		}
		
		private function createDecoder() : void {
			if(_decoder) {
				_decoder.removeEventListener(DecoderEvent.Evt_StatusChanged,this.onDecoderStatusChanged);
			}
			_decoder = this._playingStream.decoder;
			_decoder.addEventListener(DecoderEvent.Evt_StatusChanged,this.onDecoderStatusChanged);
		}
		
		private function createStream() : void {
			this.destroyStream();
			this._streams = new Vector.<HttpStream>();
			var _loc1_:Segment = null;
			var _loc2_:HttpStream = null;
			var _loc3_:Definition = _movie.curDefinition;
			var _loc4_:int = _loc3_.segmentCount;
			this._streams.length = _loc4_;
			var _loc5_:* = 0;
			while(_loc5_ < _loc4_) {
				_loc1_ = _loc3_.findSegmentAt(_loc5_);
				_loc2_ = new HttpStream(_holder,_movie);
				_loc2_.bind(_loc1_);
				this._streams[_loc5_] = _loc2_;
				_loc5_++;
			}
		}
		
		private function destroyStream() : void {
			var _loc1_:HttpStream = null;
			var _loc2_:* = 0;
			var _loc3_:* = 0;
			if(this._streams) {
				_loc1_ = null;
				_loc2_ = this._streams.length;
				_loc3_ = 0;
				while(_loc3_ < _loc2_) {
					_loc1_ = this._streams[_loc3_];
					_loc1_.removeEventListener(ProviderEvent.Evt_Stop,this.onPlayingStop);
					_loc1_.removeEventListener(ProviderEvent.Evt_Connected,this.onPlayingDecoderConnected);
					_loc1_.removeEventListener(ProviderEvent.Evt_Connected,this.onLoadingDecoderConnected);
					_loc1_.removeEventListener(ProviderEvent.Evt_Retry,this.onPlayingDecoderChanged);
					_loc1_.removeEventListener(ProviderEvent.Evt_Failed,this.onPlayingFailed);
					_loc1_.destroy();
					_loc3_++;
				}
				this._streams = null;
				this._playingStream = null;
				this._loadingStream = null;
			}
		}
		
		private function addPlayingListeners() : void {
			if(!this._playingStream.hasEventListener(ProviderEvent.Evt_Stop)) {
				this._playingStream.addEventListener(ProviderEvent.Evt_Stop,this.onPlayingStop);
				this._playingStream.addEventListener(ProviderEvent.Evt_Connected,this.onPlayingDecoderConnected);
				this._playingStream.addEventListener(ProviderEvent.Evt_Retry,this.onPlayingDecoderChanged);
				this._playingStream.addEventListener(ProviderEvent.Evt_Failed,this.onPlayingFailed);
			}
		}
		
		private function removePlayingListeners() : void {
			if(this._playingStream) {
				this._playingStream.removeEventListener(ProviderEvent.Evt_Stop,this.onPlayingStop);
				this._playingStream.removeEventListener(ProviderEvent.Evt_Connected,this.onPlayingDecoderConnected);
				this._playingStream.removeEventListener(ProviderEvent.Evt_Retry,this.onPlayingDecoderChanged);
				this._playingStream.removeEventListener(ProviderEvent.Evt_Failed,this.onPlayingFailed);
			}
		}
		
		private function switchPlaySegment(param1:HttpStream) : void {
			if(this._playingStream) {
				this.removePlayingListeners();
				if(!this._playingStream.failed) {
					if(_decoder) {
						_decoder.removeEventListener(DecoderEvent.Evt_StatusChanged,this.onDecoderStatusChanged);
					}
					this._playingStream.pause();
				}
			}
			this._playingStream = param1;
			this._playingStream.seek();
			this.addPlayingListeners();
			this.onPlayingDecoderChanged(null);
			if(this._playingStream.ready) {
				this.onPlayingDecoderConnected(null);
			}
			if(this._playingStream.failed) {
				this.onPlayingFailed(null);
			}
		}
		
		private function addLoadingListeners() : void {
			this._loadingStream.addEventListener(ProviderEvent.Evt_Connected,this.onLoadingDecoderConnected);
		}
		
		private function removeLoadingListeners() : void {
			if(this._loadingStream) {
				this._loadingStream.removeEventListener(ProviderEvent.Evt_Connected,this.onLoadingDecoderConnected);
			}
		}
		
		private function switchLoadSegment(param1:HttpStream) : void {
			if(this._loadingStream) {
				this.removeLoadingListeners();
				if(this._loadingStream != this._playingStream) {
					this._loadingStream.stopLoad();
				}
			}
			this._loadingStream = param1;
			this._loadingStream.seek();
			this.addLoadingListeners();
			if(this._loadingStream.ready) {
				this.onLoadingDecoderConnected(null);
			}
		}
		
		override protected function onTimer(param1:TimerEvent) : void {
			var _loc4_:Segment = null;
			var _loc5_:HttpStream = null;
			super.onTimer(param1);
			if(this._streams == null || this._playingStream == null || (this._playingStream) && (!this._playingStream.loadComplete)) {
				return;
			}
			var _loc2_:uint = this.currentTime;
			var _loc3_:Definition = _movie.curDefinition;
			if(!(this._playingStream.segment.index == _loc3_.segmentCount - 1) && _loc2_ > this._playingStream.segment.endTime - 120000) {
				_loc4_ = _loc3_.findSegmentAt(this._playingStream.segment.index + 1);
				_loc5_ = this._streams[this._playingStream.segment.index + 1];
				if(_loc5_.failed) {
					return;
				}
				if((_loc4_.currentKeyframe) && !(_loc4_.currentKeyframe.index == 0)) {
					_loc4_.seek(_loc4_.startTime);
				}
				if(this._loadingStream != _loc5_) {
					this.switchLoadSegment(_loc5_);
				}
			}
		}
		
		private function onDecoderStatusChanged(param1:DecoderEvent) : void {
			updateStatusByDecoder();
		}
		
		private function onPlayingStop(param1:ProviderEvent) : void {
			var _loc2_:Definition = _movie.curDefinition;
			if(_loc2_.segmentCount - 1 == this._playingStream.segment.index) {
				this.selfStop(StopReasonEnum.STOP);
			} else {
				this.switchPlaySegment(this._streams[this._playingStream.segment.index + 1]);
			}
		}
		
		private function onPlayingFailed(param1:ProviderEvent) : void {
			setStatus(StatusEnum.FAILED);
			dispatchEvent(new EngineEvent(EngineEvent.Evt_Error));
		}
		
		private function onPlayingDecoderConnected(param1:ProviderEvent) : void {
			if(this._paused) {
				this._playingStream.pause();
			} else {
				this._playingStream.resume();
			}
		}
		
		private function onPlayingDecoderChanged(param1:ProviderEvent) : void {
			this.createDecoder();
			_render.bind(this,_decoder,_movie);
			updateStatusByDecoder();
		}
		
		private function onLoadingDecoderConnected(param1:ProviderEvent) : void {
			if(this._loadingStream != this._playingStream) {
				this._loadingStream.pause();
			}
		}
		
		private function onAudioTrackChanged(param1:Event) : void {
			if((_holder.hasStatus(StatusEnum.ALREADY_READY)) && !_holder.hasStatus(StatusEnum.STOPPING) && !_holder.hasStatus(StatusEnum.STOPED) && !_holder.hasStatus(StatusEnum.FAILED)) {
				_seekTime = this.currentTime;
				this.destroyStream();
				_movie.setCurAudioTrack(Settings.instance.audioTrack,_movie.curDefinition.type);
				if((_movie.curDefinition) && (_movie.curDefinition.type)) {
					_holder.runtimeData.currentDefinition = _movie.curDefinition.type.id.toString();
				}
				_holder.runtimeData.vid = _movie.vid;
				this.seek(_seekTime);
				dispatchEvent(new EngineEvent(EngineEvent.Evt_AudioTrackSwitched,1));
			}
		}
		
		private function onDefinitionChanged(param1:Event) : void {
			if((_holder.hasStatus(StatusEnum.ALREADY_READY)) && !_holder.hasStatus(StatusEnum.STOPPING) && !_holder.hasStatus(StatusEnum.STOPED) && !_holder.hasStatus(StatusEnum.FAILED)) {
				_seekTime = this.currentTime;
				this.destroyStream();
				_movie.setCurDefinition(Settings.instance.definition);
				if((_movie.curDefinition) && (_movie.curDefinition.type)) {
					_holder.runtimeData.currentDefinition = _movie.curDefinition.type.id.toString();
				}
				_holder.runtimeData.vid = _movie.vid;
				this._definitionIsSwitched = true;
				if(_movie.curDefinition.ready) {
					this.onMovieReady(null);
				} else {
					_movie.startLoadMeta();
					if(_movie.curDefinition.ready) {
						this.onMovieReady(null);
					}
				}
			}
		}
		
		override protected function onMovieReady(param1:Event) : void {
			if(this._definitionIsSwitched) {
				this.seek(_seekTime);
				dispatchEvent(new EngineEvent(EngineEvent.Evt_DefinitionSwitched,1));
				this._definitionIsSwitched = false;
			}
			super.onMovieReady(param1);
		}
	}
}
