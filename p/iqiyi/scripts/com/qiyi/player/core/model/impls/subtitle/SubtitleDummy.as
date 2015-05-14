package com.qiyi.player.core.model.impls.subtitle
{
	import flash.events.EventDispatcher;
	import com.qiyi.player.core.model.remote.SubtitleRemote;
	import com.qiyi.player.base.logging.ILogger;
	import com.qiyi.player.base.rpc.RemoteObjectEvent;
	import com.qiyi.player.base.rpc.RemoteObjectStatusEnum;
	import com.qiyi.player.base.logging.Log;
	
	public class SubtitleDummy extends EventDispatcher
	{
		
		private var _language:Language;
		
		private var _curSubtitle:SubtitleRemote;
		
		private var _sentences:Vector.<Sentence>;
		
		protected var _log:ILogger;
		
		public function SubtitleDummy()
		{
			this._log = Log.getLogger("com.qiyi.player.core.model.impls.subtitle.SubtitleDummy");
			super();
		}
		
		public function hasSentence() : Boolean
		{
			return !(this._sentences == null) && this._sentences.length > 0;
		}
		
		public function clear() : void
		{
			if(this._curSubtitle != null)
			{
				this._curSubtitle.removeEventListener(RemoteObjectEvent.Evt_StatusChanged,this.onStatausChanged);
				this._curSubtitle.destroy();
			}
			this._language = null;
			this._curSubtitle = null;
			this._sentences = null;
		}
		
		public function loadLanguage(param1:Language) : void
		{
			if(!(param1 == null) && !(param1 == this._language))
			{
				this._log.debug("Subtitle URL:" + param1.url);
				this._language = param1;
				if(this._curSubtitle != null)
				{
					this._curSubtitle.removeEventListener(RemoteObjectEvent.Evt_StatusChanged,this.onStatausChanged);
					this._curSubtitle.destroy();
				}
				this._curSubtitle = new SubtitleRemote();
				this._curSubtitle.addEventListener(RemoteObjectEvent.Evt_StatusChanged,this.onStatausChanged);
				this._curSubtitle.loadLanguage(param1);
			}
		}
		
		public function findSentence(param1:uint) : Sentence
		{
			var _loc2:* = 0;
			var _loc3:* = 0;
			var _loc4:* = 0;
			var _loc5:Sentence = null;
			if(this.hasSentence())
			{
				_loc2 = 0;
				_loc3 = this._sentences.length - 1;
				_loc4 = 0;
				_loc5 = null;
				while(_loc2 <= _loc3)
				{
					_loc4 = (_loc2 + _loc3) / 2;
					_loc5 = this._sentences[_loc4];
					if(param1 >= _loc5.startTime && param1 <= _loc5.endTime)
					{
						return _loc5;
					}
					if(param1 < _loc5.startTime)
					{
						_loc3 = _loc4 - 1;
					}
					else
					{
						_loc2 = _loc4 + 1;
					}
				}
			}
			return null;
		}
		
		private function onStatausChanged(param1:RemoteObjectEvent) : void
		{
			if(this._curSubtitle.status == RemoteObjectStatusEnum.Success)
			{
				this._sentences = this._curSubtitle.sentences;
			}
		}
	}
}
