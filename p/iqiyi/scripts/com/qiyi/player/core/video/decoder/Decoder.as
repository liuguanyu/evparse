package com.qiyi.player.core.video.decoder {
	import flash.net.NetStream;
	import com.qiyi.player.base.pub.EnumItem;
	import com.qiyi.player.base.logging.ILogger;
	import flash.events.NetStatusEvent;
	import com.qiyi.player.core.video.def.DecoderStatusEnum;
	import com.qiyi.player.core.video.events.DecoderEvent;
	import flash.net.NetConnection;
	import com.qiyi.player.base.logging.Log;
	
	public class Decoder extends NetStream implements IDecoder {
		
		public function Decoder(param1:NetConnection, param2:String = "connectToFMS") {
			this._status = DecoderStatusEnum.STOPPED;
			this._log = Log.getLogger("com.qiyi.player.core.video.decoder.Decoder");
			super(param1,param2);
			client = new NetClient(this);
			addEventListener(NetStatusEvent.NET_STATUS,this.onNetStatus,false,int.MAX_VALUE);
		}
		
		private var _paused:Boolean = false;
		
		private var _bufferEmplty:Boolean = true;
		
		private var _metadata:Object;
		
		private var _status:EnumItem;
		
		protected var _log:ILogger;
		
		public function get status() : EnumItem {
			return this._status;
		}
		
		public function get paused() : Boolean {
			return this._paused;
		}
		
		public function get netstream() : NetStream {
			return this;
		}
		
		public function get metadata() : Object {
			return this._metadata;
		}
		
		public function destroy() : void {
			this.stop();
			removeEventListener(NetStatusEvent.NET_STATUS,this.onNetStatus);
		}
		
		override public function play(... rest) : void {
			if(this._status != DecoderStatusEnum.STOPPED) {
				return;
			}
			super.play.apply(null,rest);
			this._paused = false;
			this._bufferEmplty = true;
			this.setStatus(DecoderStatusEnum.WAITING);
		}
		
		override public function pause() : void {
			if(this._status == DecoderStatusEnum.STOPPED || (this._paused)) {
				return;
			}
			super.pause();
			this._paused = true;
			this.setStatus(DecoderStatusEnum.PAUSED);
		}
		
		override public function resume() : void {
			if(this._status == DecoderStatusEnum.STOPPED || !this._paused) {
				return;
			}
			super.resume();
			this._paused = false;
			if(!this._bufferEmplty) {
				this.setStatus(DecoderStatusEnum.PLAYING);
			} else {
				this.setStatus(DecoderStatusEnum.WAITING);
			}
		}
		
		override public function togglePause() : void {
		}
		
		override public function seek(param1:Number) : void {
			if(this.status == DecoderStatusEnum.SEEKING || this.status == DecoderStatusEnum.STOPPED) {
				return;
			}
			this._bufferEmplty = true;
			this.setStatus(DecoderStatusEnum.SEEKING);
			super.seek(param1 / 1000);
		}
		
		protected function onNetStatus(param1:NetStatusEvent) : void {
			switch(param1.info.code) {
				case "NetStream.Seek.Notify":
					if(super.bufferLength < super.bufferTime) {
						this._bufferEmplty = true;
						this.setStatus(DecoderStatusEnum.WAITING);
					} else if(this._paused) {
						this.setStatus(DecoderStatusEnum.PAUSED);
					} else {
						this.setStatus(DecoderStatusEnum.PLAYING);
					}
					
					break;
				case "NetStream.Buffer.Empty":
					if(super.bufferLength < super.bufferTime) {
						this._bufferEmplty = true;
						this.setStatus(DecoderStatusEnum.WAITING);
					}
					break;
				case "NetStream.Buffer.Full":
					if(this._paused) {
						this.setStatus(DecoderStatusEnum.PAUSED);
					} else {
						this.setStatus(DecoderStatusEnum.PLAYING);
					}
					this._bufferEmplty = false;
					break;
				case "NetStream.Play.FileStructureInvalid":
				case "NetStream.Play.NoSupportedTrackFound":
				case "NetStream.Play.StreamNotFound":
				case "NetStream.Seek.InvalidTime":
					this.setStatus(DecoderStatusEnum.FAILED);
					break;
			}
		}
		
		protected function setStatus(param1:EnumItem) : void {
			if(this._status == param1) {
				return;
			}
			this._log.info("decoder status changed: " + param1.name);
			this._status = param1;
			dispatchEvent(new DecoderEvent(DecoderEvent.Evt_StatusChanged));
		}
		
		public function stop() : void {
			this._status = DecoderStatusEnum.STOPPED;
			super.close();
		}
		
		public function onMetaData(param1:Object) : void {
			this._metadata = param1;
			dispatchEvent(new DecoderEvent(DecoderEvent.Evt_MetaData));
		}
	}
}
