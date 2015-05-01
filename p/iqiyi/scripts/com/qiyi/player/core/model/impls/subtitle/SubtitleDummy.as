package com.qiyi.player.core.model.impls.subtitle {
	import flash.events.EventDispatcher;
	import com.qiyi.player.core.model.remote.SubtitleRemote;
	import com.qiyi.player.base.logging.ILogger;
	import com.qiyi.player.base.rpc.RemoteObjectEvent;
	import com.qiyi.player.base.rpc.RemoteObjectStatusEnum;
	import com.qiyi.player.base.logging.Log;
	
	public class SubtitleDummy extends EventDispatcher {
		
		public function SubtitleDummy() {
			this._log = Log.getLogger("com.qiyi.player.core.model.impls.subtitle.SubtitleDummy");
			super();
		}
		
		private var _language:Language;
		
		private var _curSubtitle:SubtitleRemote;
		
		private var _sentences:Vector.<Sentence>;
		
		protected var _log:ILogger;
		
		public function hasSentence() : Boolean {
			return !(this._sentences == null) && this._sentences.length > 0;
		}
		
		public function clear() : void {
			if(this._curSubtitle != null) {
				this._curSubtitle.removeEventListener(RemoteObjectEvent.Evt_StatusChanged,this.onStatausChanged);
				this._curSubtitle.destroy();
			}
			this._language = null;
			this._curSubtitle = null;
			this._sentences = null;
		}
		
		public function loadLanguage(param1:Language) : void {
			if(!(param1 == null) && !(param1 == this._language)) {
				this._log.debug("Subtitle URL:" + param1.url);
				this._language = param1;
				if(this._curSubtitle != null) {
					this._curSubtitle.removeEventListener(RemoteObjectEvent.Evt_StatusChanged,this.onStatausChanged);
					this._curSubtitle.destroy();
				}
				this._curSubtitle = new SubtitleRemote();
				this._curSubtitle.addEventListener(RemoteObjectEvent.Evt_StatusChanged,this.onStatausChanged);
				this._curSubtitle.loadLanguage(param1);
			}
		}
		
		public function findSentence(param1:uint) : Sentence {
			var _loc2_:* = 0;
			var _loc3_:* = 0;
			var _loc4_:* = 0;
			var _loc5_:Sentence = null;
			if(this.hasSentence()) {
				_loc2_ = 0;
				_loc3_ = this._sentences.length - 1;
				_loc4_ = 0;
				_loc5_ = null;
				while(_loc2_ <= _loc3_) {
					_loc4_ = (_loc2_ + _loc3_) / 2;
					_loc5_ = this._sentences[_loc4_];
					if(param1 >= _loc5_.startTime && param1 <= _loc5_.endTime) {
						return _loc5_;
					}
					if(param1 < _loc5_.startTime) {
						_loc3_ = _loc4_ - 1;
					} else {
						_loc2_ = _loc4_ + 1;
					}
				}
			}
			return null;
		}
		
		private function onStatausChanged(param1:RemoteObjectEvent) : void {
			if(this._curSubtitle.status == RemoteObjectStatusEnum.Success) {
				this._sentences = this._curSubtitle.sentences;
			}
		}
	}
}
