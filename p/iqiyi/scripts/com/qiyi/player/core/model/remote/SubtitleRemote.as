package com.qiyi.player.core.model.remote {
	import com.qiyi.player.base.rpc.impl.BaseRemoteObject;
	import com.qiyi.player.core.model.impls.subtitle.Sentence;
	import com.qiyi.player.core.model.impls.subtitle.Language;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.utils.clearTimeout;
	import com.qiyi.player.base.rpc.RemoteObjectStatusEnum;
	import com.qiyi.player.core.Config;
	
	public class SubtitleRemote extends BaseRemoteObject {
		
		public function SubtitleRemote() {
			super(0,"SubtitleRemote");
			_timeout = Config.SUBTITLE_TIMEOUT;
			_retryMaxCount = Config.SUBTITLE_MAX_RETRY;
		}
		
		private var _sentences:Vector.<Sentence>;
		
		private var _language:Language;
		
		public function loadLanguage(param1:Language) : void {
			this._language = param1;
			this.initialize();
		}
		
		public function get sentences() : Vector.<Sentence> {
			return this._sentences;
		}
		
		public function get language() : Language {
			return this._language;
		}
		
		override protected function getRequest() : URLRequest {
			return new URLRequest(this._language.url + "?tn=" + Math.random());
		}
		
		private function parser() : Boolean {
			var root:XML = null;
			var items:XMLList = null;
			var i:int = 0;
			var n:int = 0;
			var item:XML = null;
			var sentence:Sentence = null;
			try {
				root = new XML(this._loader.data);
				items = root.dia;
				this._sentences = new Vector.<Sentence>(items.length(),true);
				i = 0;
				n = items.length();
				while(i < n) {
					item = items[i];
					sentence = new Sentence();
					sentence.startTime = Number(item.st);
					sentence.endTime = Number(item.et);
					sentence.content = String(item.sub);
					this._sentences[i] = sentence;
					i++;
				}
				this._sentences = this._sentences.sort(this.compare);
			}
			catch(e:Error) {
				return false;
			}
			return true;
		}
		
		private function compare(param1:Sentence, param2:Sentence) : Number {
			return param1.startTime - param2.startTime;
		}
		
		override protected function onComplete(param1:Event) : void {
			clearTimeout(_waitingResponse);
			_waitingResponse = 0;
			_data = _loader.data;
			if(this.parser()) {
				super.onComplete(param1);
			} else if(!this.exceptionHandler()) {
				this._status = RemoteObjectStatusEnum.DataError;
			}
			
		}
	}
}
