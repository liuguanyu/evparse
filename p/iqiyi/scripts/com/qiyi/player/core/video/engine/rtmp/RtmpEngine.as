package com.qiyi.player.core.video.engine.rtmp {
	import com.qiyi.player.core.video.engine.BaseEngine;
	import com.qiyi.player.core.IDestroy;
	import com.qiyi.player.core.model.IMovie;
	import com.qiyi.player.core.video.render.IRender;
	import com.qiyi.player.core.player.def.StatusEnum;
	import com.qiyi.player.base.pub.EnumItem;
	import com.qiyi.player.core.video.events.DecoderEvent;
	import com.qiyi.player.core.model.impls.pub.Settings;
	import com.qiyi.player.core.video.events.ProviderEvent;
	import com.qiyi.player.core.video.events.EngineEvent;
	import com.qiyi.player.core.video.def.StopReasonEnum;
	import flash.events.Event;
	import com.qiyi.player.core.model.utils.DefinitionUtils;
	import com.qiyi.player.core.player.coreplayer.ICorePlayer;
	
	public class RtmpEngine extends BaseEngine implements IDestroy {
		
		public function RtmpEngine(param1:ICorePlayer) {
			super(param1);
			Settings.instance.addEventListener(Settings.Evt_AudioTrackChanged,this.onAudioTrackChanged);
			Settings.instance.addEventListener(Settings.Evt_DefinitionChanged,this.onDefinitionChanged);
		}
		
		private var _stream:RtmpStream;
		
		private var _paused:Boolean = true;
		
		override public function get currentTime() : int {
			if(this._stream) {
				return this._stream.time;
			}
			return 0;
		}
		
		override public function get bufferTime() : int {
			if(this._stream) {
				return this._stream.bufferTime;
			}
			return 0;
		}
		
		override public function bind(param1:IMovie, param2:IRender) : void {
			super.bind(param1,param2);
			this.createStream();
			this._stream.bind(_movie.curDefinition.findSegmentAt(0));
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
		
		override public function seek(param1:uint, param2:int = 0) : void {
			if(_movie == null) {
				throw new Error("RtmpEngine error! bind firstly!");
			} else {
				if(this._stream == null) {
					this.createStream();
					this._stream.bind(_movie.curDefinition.findSegmentAt(0));
				}
				_seekTime = param1;
				if(checkEngineIsReady()) {
					super.seek(_seekTime,param2);
					this._stream.seek(_seekTime);
				}
				return;
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
		
		override public function play() : void {
			if(!_holder.hasStatus(StatusEnum.ALREADY_PLAY)) {
				if(_movie == null) {
					throw new Error("RtmpEngine error! bind firstly!");
				} else {
					super.play();
					if(checkEngineIsReady()) {
						this.seek(_startTime);
					} else {
						_holder.addStatus(StatusEnum.WAITING_PLAY,false);
						startLoadHistory();
						startLoadMeta();
					}
					this.resume();
				}
			}
		}
		
		override public function pause(param1:int = 0) : void {
			super.pause(param1);
			this._paused = true;
			if(this._stream) {
				this._stream.pause();
			}
		}
		
		override public function resume() : void {
			super.resume();
			this._paused = false;
			if(this._stream) {
				this._stream.resume();
			}
		}
		
		override public function destroy() : void {
			super.destroy();
			Settings.instance.removeEventListener(Settings.Evt_AudioTrackChanged,this.onAudioTrackChanged);
			Settings.instance.removeEventListener(Settings.Evt_DefinitionChanged,this.onDefinitionChanged);
			this.destroyStream();
			if(_decoder) {
				_decoder.removeEventListener(DecoderEvent.Evt_StatusChanged,this.onDecoderStatusChanged);
				_decoder = null;
			}
		}
		
		private function createDecoder() : void {
			if(_decoder) {
				_decoder.removeEventListener(DecoderEvent.Evt_StatusChanged,this.onDecoderStatusChanged);
			}
			_decoder = this._stream.decoder;
			_decoder.addEventListener(DecoderEvent.Evt_StatusChanged,this.onDecoderStatusChanged);
		}
		
		private function createStream() : void {
			this.destroyStream();
			this._stream = new RtmpStream(_holder);
			this._stream.addEventListener(ProviderEvent.Evt_Failed,this.onStreamFailed);
			this._stream.addEventListener(ProviderEvent.Evt_Connected,this.onStreamConnected);
			this._stream.addEventListener(ProviderEvent.Evt_Stop,this.onStreamStop);
			this._stream.addEventListener(RtmpStream.Evt_Stuck,this.onStreamStuck);
			if(this._paused) {
				this._stream.pause();
			} else {
				this._stream.resume();
			}
		}
		
		private function destroyStream() : void {
			if(this._stream) {
				this._stream.removeEventListener(ProviderEvent.Evt_Failed,this.onStreamFailed);
				this._stream.removeEventListener(ProviderEvent.Evt_Connected,this.onStreamConnected);
				this._stream.removeEventListener(ProviderEvent.Evt_Stop,this.onStreamStop);
				this._stream.removeEventListener(RtmpStream.Evt_Stuck,this.onStreamStuck);
				this._stream.destroy();
				this._stream = null;
			}
		}
		
		private function onDecoderStatusChanged(param1:DecoderEvent) : void {
			updateStatusByDecoder();
		}
		
		private function onStreamFailed(param1:ProviderEvent) : void {
			setStatus(StatusEnum.FAILED);
			dispatchEvent(new EngineEvent(EngineEvent.Evt_Error));
		}
		
		private function onStreamConnected(param1:ProviderEvent) : void {
			this.createDecoder();
			_render.bind(this,_decoder,_movie);
			updateStatusByDecoder();
		}
		
		private function onStreamStop(param1:ProviderEvent) : void {
			this.selfStop(StopReasonEnum.STOP);
		}
		
		private function onStreamStuck(param1:Event) : void {
			dispatchEvent(new EngineEvent(EngineEvent.Evt_Stuck));
		}
		
		private function onAudioTrackChanged(param1:Event) : void {
			var _loc2_:* = 0;
			if((_holder.hasStatus(StatusEnum.ALREADY_READY)) && !_holder.hasStatus(StatusEnum.STOPPING) && !_holder.hasStatus(StatusEnum.STOPED) && !_holder.hasStatus(StatusEnum.FAILED)) {
				_movie.setCurAudioTrack(Settings.instance.audioTrack,DefinitionUtils.getCurrentDefinition(_holder));
				if((_movie.curDefinition) && (_movie.curDefinition.type)) {
					_holder.runtimeData.currentDefinition = _movie.curDefinition.type.id.toString();
				}
				_holder.runtimeData.vid = _movie.vid;
				_loc2_ = this.currentTime;
				this.destroyStream();
				this.seek(_loc2_);
				dispatchEvent(new EngineEvent(EngineEvent.Evt_AudioTrackSwitched,1));
			}
		}
		
		private function onDefinitionChanged(param1:Event) : void {
			var _loc2_:* = 0;
			if((_holder.hasStatus(StatusEnum.ALREADY_READY)) && !_holder.hasStatus(StatusEnum.STOPPING) && !_holder.hasStatus(StatusEnum.STOPED) && !_holder.hasStatus(StatusEnum.FAILED)) {
				_movie.setCurDefinition(Settings.instance.definition);
				if((_movie.curDefinition) && (_movie.curDefinition.type)) {
					_holder.runtimeData.currentDefinition = _movie.curDefinition.type.id.toString();
				}
				_holder.runtimeData.vid = _movie.vid;
				_loc2_ = this.currentTime;
				this.destroyStream();
				this.seek(_loc2_);
				dispatchEvent(new EngineEvent(EngineEvent.Evt_DefinitionSwitched,1));
			}
		}
	}
}
