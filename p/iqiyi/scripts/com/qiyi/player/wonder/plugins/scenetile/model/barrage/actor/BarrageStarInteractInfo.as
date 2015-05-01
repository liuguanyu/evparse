package com.qiyi.player.wonder.plugins.scenetile.model.barrage.actor {
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import com.qiyi.player.base.logging.ILogger;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import com.qiyi.player.wonder.common.config.SystemConfig;
	import com.adobe.serialization.json.JSON;
	import com.qiyi.player.wonder.common.event.CommonEvent;
	import com.qiyi.player.base.logging.Log;
	
	public class BarrageStarInteractInfo extends EventDispatcher {
		
		public function BarrageStarInteractInfo() {
			this._starInteractDic = new Dictionary();
			this._log = Log.getLogger("com.qiyi.player.wonder.plugins.scenetile.model.barrage.actor.BarrageStarInteractInfo");
			super();
		}
		
		public static const Evt_LoaderBarrageInteractInfoComplete:String = "evtLoaderBarrageInteractInfoComplete";
		
		private var _loader:URLLoader;
		
		private var _request:URLRequest;
		
		private var _isLoading:Boolean = false;
		
		private var _isReady:Boolean = false;
		
		private var _starInteractObj:Object = null;
		
		private var _starInteractDic:Dictionary;
		
		private var _log:ILogger;
		
		public function get starInteractObj() : Object {
			return this._starInteractObj;
		}
		
		public function get isLoading() : Boolean {
			return this._isLoading;
		}
		
		public function get isReady() : Boolean {
			return this._isReady;
		}
		
		public function startLoad() : void {
			if(this._isLoading) {
				return;
			}
			this._isLoading = true;
			if(this._loader) {
				this._loader.removeEventListener(Event.COMPLETE,this.onCompleteHandler);
				this._loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onErrorHander);
				this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onErrorHander);
				try {
					this._loader.close();
				}
				catch(e:Error) {
				}
				this._request = null;
				this._loader = null;
			}
			this._isReady = false;
			var url:String = SystemConfig.BARRAGE_STAR_INTERACT_URL + "?rn=" + Math.random();
			this._request = new URLRequest(url);
			this._loader = new URLLoader();
			this._loader.addEventListener(Event.COMPLETE,this.onCompleteHandler);
			this._loader.addEventListener(IOErrorEvent.IO_ERROR,this.onErrorHander);
			this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onErrorHander);
			this._loader.load(this._request);
			this._log.info("BarrageStarInteractInfo start request json data");
		}
		
		private function onCompleteHandler(param1:Event) : void {
			var obj:Object = null;
			var obj1:Object = null;
			var event:Event = param1;
			this._isLoading = false;
			this._isReady = true;
			try {
				obj = com.adobe.serialization.json.JSON.decode(this._loader.data);
				for each(obj1 in obj.list) {
					if((obj1.id) && (obj1.data)) {
						this._starInteractDic[obj1.id] = obj1.data;
					}
				}
				this._starInteractObj = obj;
				dispatchEvent(new CommonEvent(Evt_LoaderBarrageInteractInfoComplete,obj));
				this._log.info("BarrageStarInteractInfo respond json data");
			}
			catch(e:Error) {
				_log.info("BarrageStarInteractInfo json data analyze fail");
			}
		}
		
		private function onErrorHander(param1:*) : void {
			this._isLoading = false;
		}
		
		public function getStarInteractByTvid(param1:String) : Object {
			var _loc2_:Object = this._starInteractDic[param1];
			return _loc2_;
		}
	}
}
