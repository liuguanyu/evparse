package com.qiyi.player.core.video.decoder {
	import com.qiyi.player.core.player.coreplayer.ICorePlayer;
	import flash.events.Event;
	import flash.media.SoundTransform;
	import com.qiyi.player.core.model.impls.pub.Settings;
	import com.qiyi.player.core.player.def.PlayerUseTypeEnum;
	import com.qiyi.player.core.video.engine.dm.provider.MediaData;
	import flash.utils.ByteArray;
	import com.qiyi.player.base.pub.EnumItem;
	import com.qiyi.player.core.video.def.DecoderStatusEnum;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	
	public class DataModeDecoder extends Decoder {
		
		public function DataModeDecoder(param1:ICorePlayer = null) {
			this._holder = param1;
			var _loc2_:NetConnection = new NetConnection();
			_loc2_.connect(null);
			super(_loc2_);
			Settings.instance.addEventListener(Settings.Evt_MuteChanged,this.onVolumeChanged);
			Settings.instance.addEventListener(Settings.Evt_VolumeChanged,this.onVolumeChanged);
			this.onVolumeChanged(null);
		}
		
		private static const RESET_BEGIN:String = "resetBegin";
		
		private static const RESET_SEEK:String = "resetSeek";
		
		private static const END_SEQUENCE:String = "endSequence";
		
		private var _startTime:int = 0;
		
		private var _allowGetTime:Boolean = true;
		
		private var _endOfFile:Boolean = false;
		
		private var _holder:ICorePlayer;
		
		override public function get time() : Number {
			if(this._allowGetTime) {
				return this._startTime + super.time * 1000;
			}
			return this._startTime;
		}
		
		private function onVolumeChanged(param1:Event) : void {
			var _loc2_:SoundTransform = new SoundTransform();
			if((Settings.instance.mute) || this._holder.runtimeData.playerUseType == PlayerUseTypeEnum.PREVIEW) {
				_loc2_.volume = 0;
			} else {
				_loc2_.volume = Settings.instance.volumn / 100;
			}
			soundTransform = _loc2_;
		}
		
		override public function play(... rest) : void {
			super.play(null);
			this._allowGetTime = true;
		}
		
		override public function destroy() : void {
			Settings.instance.removeEventListener(Settings.Evt_MuteChanged,this.onVolumeChanged);
			Settings.instance.removeEventListener(Settings.Evt_VolumeChanged,this.onVolumeChanged);
			super.destroy();
		}
		
		override public function seek(param1:Number) : void {
			if(param1 < 100 || !(Math.ceil(param1) == param1)) {
				return;
			}
			this._startTime = param1;
			this._endOfFile = false;
			this._allowGetTime = false;
			_log.info("decoder seek:" + param1);
			super.seek(param1);
		}
		
		public function endSequence() : void {
			if(this._endOfFile) {
				return;
			}
			this._endOfFile = true;
			this.tryAppendBytesAction(END_SEQUENCE);
			_log.debug("appendByteAction:" + END_SEQUENCE);
		}
		
		public function appendData(param1:MediaData) : void {
			if(param1 == null) {
				return;
			}
			this._endOfFile = false;
			if(param1.headers) {
				this.tryAppendBytesAction(RESET_BEGIN);
				_log.debug("appendByteAction:" + RESET_BEGIN);
				this.tryAppendBytes(param1.headers);
				_log.debug("append headers");
				this.tryAppendBytesAction(RESET_SEEK);
				_log.debug("appendByteAction:" + RESET_SEEK);
			}
			if((param1.bytes) && (param1.bytes.length)) {
				this.tryAppendBytes(param1.bytes);
				_log.debug("append bytes: " + param1.bytes.length);
			}
		}
		
		private function tryAppendBytesAction(param1:String) : void {
			var action:String = param1;
			if(this.hasOwnProperty("appendBytesAction")) {
				try {
					this["appendBytesAction"](action);
				}
				catch(e:Error) {
					_log.warn("appendBytesAction Error: " + action);
				}
			}
		}
		
		private function tryAppendBytes(param1:ByteArray) : void {
			if(this.hasOwnProperty("appendBytes")) {
				this["appendBytes"](param1);
			}
		}
		
		override protected function setStatus(param1:EnumItem) : void {
			if(param1 == DecoderStatusEnum.PLAYING) {
				this._allowGetTime = true;
			}
			super.setStatus(param1);
		}
		
		override public function stop() : void {
			this._allowGetTime = true;
			super.stop();
		}
		
		override protected function onNetStatus(param1:NetStatusEvent) : void {
			_log.debug(param1.info.code);
			switch(param1.info.code) {
				case "NetStream.Buffer.Empty":
					break;
				case "NetStream.Seek.Notify":
					this.tryAppendBytesAction(RESET_SEEK);
					break;
				case "NetStream.Buffer.Full":
					this._allowGetTime = true;
					break;
			}
			super.onNetStatus(param1);
		}
	}
}
