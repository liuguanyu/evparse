package com.qiyi.player.core.video.engine.http {
	import flash.events.EventDispatcher;
	import com.qiyi.player.core.IDestroy;
	import com.qiyi.player.core.player.coreplayer.ICorePlayer;
	import com.qiyi.player.core.model.IMovie;
	import com.qiyi.player.core.model.impls.Segment;
	import flash.net.NetConnection;
	import com.qiyi.player.core.video.decoder.Decoder;
	import com.qiyi.player.core.model.impls.Keyframe;
	import flash.utils.Timer;
	import com.qiyi.player.core.video.engine.dispatcher.Dispatcher;
	import com.qiyi.player.base.logging.ILogger;
	import com.qiyi.player.core.video.events.DispatcherEvent;
	import flash.events.TimerEvent;
	import com.qiyi.player.core.model.impls.pub.Settings;
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.IOErrorEvent;
	import com.qiyi.player.core.Config;
	import flash.events.Event;
	import flash.media.SoundTransform;
	import com.qiyi.player.core.video.events.ProviderEvent;
	import com.qiyi.player.base.logging.Log;
	
	public class HttpStream extends EventDispatcher implements IDestroy {
		
		public function HttpStream(param1:ICorePlayer, param2:IMovie) {
			this._log = Log.getLogger("com.qiyi.player.core.video.engine.http.HttpStream");
			super();
			this._holder = param1;
			this._movie = param2;
			this._dispatcher = new Dispatcher(this._holder);
			this._dispatcher.addEventListener(DispatcherEvent.Evt_Success,this.onDispatcherSuccess);
			this._dispatcher.addEventListener(DispatcherEvent.Evt_Failed,this.onDispatcherFailed);
			Settings.instance.addEventListener(Settings.Evt_MuteChanged,this.onVolumeChanged);
			Settings.instance.addEventListener(Settings.Evt_VolumeChanged,this.onVolumeChanged);
		}
		
		private var _holder:ICorePlayer;
		
		private var _movie:IMovie;
		
		private var _segment:Segment;
		
		private var _cn:NetConnection;
		
		private var _ns:Decoder;
		
		private var _ready:Boolean = false;
		
		private var _paused:Boolean = false;
		
		private var _bufferEmpty:Boolean = false;
		
		private var _loadComplete:Boolean = false;
		
		private var _failed:Boolean = false;
		
		private var _stopped:Boolean = false;
		
		private var _seeking:Boolean = false;
		
		private var _startKeyframe:Keyframe;
		
		private var _retryCount:int = 0;
		
		private var _timer:Timer;
		
		private var _dispatcher:Dispatcher;
		
		private var _log:ILogger;
		
		public function get ready() : Boolean {
			return this._ready;
		}
		
		public function get loadComplete() : Boolean {
			return this._loadComplete;
		}
		
		public function get segment() : Segment {
			return this._segment;
		}
		
		public function get time() : Number {
			if((this._seeking) || this._ns == null || this._ns.time == 0) {
				if(this._startKeyframe) {
					return this._startKeyframe.time;
				}
				return this._segment.startTime;
			}
			return this._segment.startTime + this._ns.time * 1000;
		}
		
		public function get bufferTime() : Number {
			if(this._ns == null) {
				if(this._startKeyframe) {
					return this._startKeyframe.time;
				}
				return this._segment.startTime;
			}
			if(this._ns.bytesLoaded == this._ns.bytesTotal) {
				return this._segment.startTime + this._segment.totalTime;
			}
			if(this._startKeyframe == null || this._segment.keyframes == null) {
				return this._segment.startTime + this._segment.totalTime * this._ns.bytesLoaded / this._ns.bytesTotal;
			}
			var _loc1_:Number = this._startKeyframe.position + this._ns.bytesLoaded - this._segment.keyframes[0].position;
			var _loc2_:Keyframe = this._segment.getKeyframeByPosition(_loc1_);
			return _loc2_.time + (_loc1_ - _loc2_.position) / _loc2_.lenPos * _loc2_.lenTime;
		}
		
		public function get bufferRate() : Number {
			var _loc1_:Number = this._ns?this._ns.bufferLength / this._ns.bufferTime:0;
			return _loc1_ >= 1?1:_loc1_;
		}
		
		public function get failed() : Boolean {
			return this._failed;
		}
		
		public function get startTime() : int {
			return this._startKeyframe?this._startKeyframe.segmentTime:0;
		}
		
		public function get decoder() : Decoder {
			return this._ns;
		}
		
		public function bind(param1:Segment) : void {
			this._segment = param1;
		}
		
		public function pause() : void {
			this._paused = true;
			if(this._ready) {
				this._ns.pause();
				this._log.debug("HttpStream (" + this._segment.index + ") is paused");
			}
		}
		
		public function resume() : void {
			this._paused = false;
			if(this._ready) {
				this._ns.resume();
				this._log.debug("HttpStream (" + this._segment.index + ") is resume");
			}
		}
		
		public function seek(param1:int = -1) : void {
			var _loc2_:Keyframe = null;
			var _loc3_:* = 0;
			if(this._failed) {
				return;
			}
			this._stopped = false;
			this._seeking = true;
			if(this._ns) {
				_loc2_ = this._segment.currentKeyframe;
				if(_loc2_ == null) {
					this._seeking = false;
					this.reload();
				} else {
					_loc3_ = this._startKeyframe?this._startKeyframe.position:0;
					if(_loc2_.position >= _loc3_ && _loc2_.position < _loc3_ + this._ns.bytesLoaded) {
						this._ns.seek(_loc2_.segmentTime);
					} else {
						this.reload();
					}
				}
			} else {
				this.reload();
			}
		}
		
		public function stopLoad() : void {
			this.destroyStream();
		}
		
		public function destroy() : void {
			this.destroyStream();
			this._holder = null;
			this._movie = null;
			this._segment = null;
			this._startKeyframe = null;
			if(this._dispatcher) {
				this._dispatcher.removeEventListener(DispatcherEvent.Evt_Success,this.onDispatcherSuccess);
				this._dispatcher.removeEventListener(DispatcherEvent.Evt_Failed,this.onDispatcherFailed);
				this._dispatcher.stop();
				this._dispatcher = null;
			}
			if(this._timer) {
				this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
				this._timer.stop();
				this._timer = null;
			}
			Settings.instance.removeEventListener(Settings.Evt_MuteChanged,this.onVolumeChanged);
			Settings.instance.removeEventListener(Settings.Evt_VolumeChanged,this.onVolumeChanged);
		}
		
		private function createStream() : void {
			this.destroyStream();
			this._cn = new NetConnection();
			this._cn.client = this;
			this._cn.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.onConnectionAasyncError);
			this._cn.connect(null);
			this._ns = new Decoder(this._cn);
			this._ns.addEventListener(NetStatusEvent.NET_STATUS,this.onNetStatus);
			this._ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.onAsyncError);
			this._ns.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
			this._ns.bufferTime = Config.STREAM_NORMAL_BUFFER_TIME / 1000;
			this.onVolumeChanged();
		}
		
		private function destroyStream() : void {
			if(this._ns) {
				this._ns.removeEventListener(NetStatusEvent.NET_STATUS,this.onNetStatus);
				this._ns.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,this.onAsyncError);
				this._ns.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
				this._ns.destroy();
				this._ns = null;
			}
			if(this._cn) {
				this._cn.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,this.onConnectionAasyncError);
				this._cn.close();
				this._cn = null;
			}
		}
		
		private function onVolumeChanged(param1:Event = null) : void {
			var _loc2_:SoundTransform = null;
			if(this._ns) {
				_loc2_ = new SoundTransform();
				_loc2_.volume = Settings.instance.mute?0:Settings.instance.volumn / 100;
				this._ns.soundTransform = _loc2_;
			}
		}
		
		private function onConnectionAasyncError(param1:AsyncErrorEvent) : void {
		}
		
		private function onTimer(param1:TimerEvent) : void {
			if(!this._ns) {
				return;
			}
			if(this._bufferEmpty) {
				if(this._ns.bufferLength >= this._ns.bufferTime || this._ns.bytesLoaded > 2 << 20 && this._ns.time < 1) {
					this.onBufferFull();
				}
			}
			if(!this._loadComplete && this._ns.bytesLoaded == this._ns.bytesTotal) {
				this._log.info("HttpStream(" + this._segment.index + ") load complete!");
				this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
				this._timer.stop();
				this._timer = null;
				this._loadComplete = true;
			}
		}
		
		private function onNetStatus(param1:NetStatusEvent) : void {
			this._log.debug(param1.info.code);
			switch(param1.info.code) {
				case "NetStream.Play.Start":
					this.onStart();
					break;
				case "NetStream.Buffer.Full":
					if(this._stopped) {
						return;
					}
					this.onBufferFull();
					break;
				case "NetStream.Buffer.Empty":
					if(this._stopped) {
						return;
					}
					this._bufferEmpty = true;
					break;
				case "NetStream.Seek.Notify":
					this._seeking = false;
					this.onSeekSuccess();
					break;
				case "NetStream.Play.Stop":
					this._stopped = true;
					this.dispatchEvent(new ProviderEvent(ProviderEvent.Evt_Stop));
					break;
				case "NetStream.Play.Failed":
					this.retry();
					break;
				case "NetStream.Play.FileStructureInvalid":
					this.retry();
					break;
				case "NetStream.Play.NoSupportedTrackFound":
					this.retry();
					break;
				case "NetStream.Play.StreamNotFound":
					this.retry();
					break;
				case "NetStream.Seek.Failed":
				case "NetStream.Seek.InvalidTime":
					this.onSeekFailed(param1.info);
					break;
			}
		}
		
		private function onStart() : void {
			if(!this._ready) {
				this._ready = true;
				if(this._paused) {
					this._ns.pause();
				} else {
					this._ns.resume();
				}
				if(this._timer == null) {
					this._timer = new Timer(100);
					this._timer.addEventListener(TimerEvent.TIMER,this.onTimer);
				}
				this._timer.start();
				dispatchEvent(new ProviderEvent(ProviderEvent.Evt_Connected));
			}
		}
		
		private function onBufferFull() : void {
			this._bufferEmpty = false;
			this._seeking = false;
		}
		
		private function onSeekSuccess() : void {
			this._retryCount = 0;
			this._bufferEmpty = this._ns.bufferLength < this._ns.bufferTime;
		}
		
		private function onDispatcherSuccess(param1:DispatcherEvent) : void {
			var _loc2_:String = param1.data as String;
			this._ns.play(_loc2_);
		}
		
		private function onDispatcherFailed(param1:DispatcherEvent) : void {
			this._failed = true;
			dispatchEvent(new ProviderEvent(ProviderEvent.Evt_Failed));
		}
		
		private function onSeekFailed(param1:Object) : void {
			this._log.info("HttpStream failed to seek: " + param1.code + ", " + param1.details);
			this._retryCount++;
			if(this._retryCount >= Config.STREAM_MAX_RETRY) {
				this._failed = true;
				dispatchEvent(new ProviderEvent(ProviderEvent.Evt_Failed));
			} else {
				this._ns.seek(parseFloat(param1.details));
			}
		}
		
		private function retry() : void {
			this._log.info("HttpStream(index: " + this._segment.index + ") failed, errno=" + this._holder.runtimeData.preErrorCode);
			if(this._retryCount >= Config.STREAM_MAX_RETRY) {
				this._failed = true;
				dispatchEvent(new ProviderEvent(ProviderEvent.Evt_Failed));
			} else {
				this._retryCount++;
				this._holder.runtimeData.retryCount = this._retryCount;
				if(this._ns) {
					this._movie.seek(this._ns.time * 1000 + this._segment.startTime);
				}
				this.reload();
			}
		}
		
		private function onAsyncError(param1:AsyncErrorEvent) : void {
		}
		
		private function onIOError(param1:IOErrorEvent) : void {
			this.retry();
		}
		
		private function reload() : void {
			this._ready = false;
			this._bufferEmpty = true;
			this._loadComplete = false;
			this._failed = false;
			this._stopped = false;
			this._seeking = false;
			this._startKeyframe = this._segment.currentKeyframe;
			this.createStream();
			if(this._holder.runtimeData.cacheServerIP == "" || this._holder.runtimeData.cacheServerIP == null) {
				this._dispatcher.stop();
				this._dispatcher.start(this._segment);
			} else {
				this._ns.play(this._segment.url);
			}
			dispatchEvent(new ProviderEvent(ProviderEvent.Evt_Retry));
		}
	}
}
