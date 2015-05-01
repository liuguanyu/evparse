package com.qiyi.player.core.model.remote {
	import com.qiyi.player.base.rpc.impl.BaseRemoteObject;
	import com.qiyi.player.base.logging.ILogger;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.utils.clearTimeout;
	import com.qiyi.player.base.rpc.RemoteObjectStatusEnum;
	import com.qiyi.player.base.logging.Log;
	import com.qiyi.player.core.Config;
	
	public class RequestMetaRemote extends BaseRemoteObject {
		
		public function RequestMetaRemote(param1:String) {
			this._log = Log.getLogger("com.qiyi.player.core.model.remote.RequestMetaRemote");
			super(0,"RequestMetaRemote");
			this._metaUrl = param1;
			_timeout = Config.META_TIMEOUT;
		}
		
		private var _metaUrl:String;
		
		private var _log:ILogger;
		
		override protected function getRequest() : URLRequest {
			if(this._metaUrl == "") {
				this._log.warn("metaUrl is empty!");
			}
			return new URLRequest(this._metaUrl);
		}
		
		override protected function onComplete(param1:Event) : void {
			var s:String = null;
			var event:Event = param1;
			clearTimeout(_waitingResponse);
			_waitingResponse = 0;
			try {
				if((_loader.data) && !(_loader.data == "")) {
					_data = new XML(_loader.data);
					super.onComplete(event);
				} else {
					throw new Error("");
				}
			}
			catch(e:Error) {
				_log.warn("RequestMetaRemote: failed to parse data");
				s = _loader.data;
				if(s) {
					_log.info(s.substr(0,100));
				}
				setStatus(RemoteObjectStatusEnum.DataError);
			}
		}
	}
}
