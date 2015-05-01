package com.qiyi.player.wonder.body.model.remote {
	import flash.net.URLLoader;
	import com.qiyi.player.wonder.common.config.SystemConfig;
	import com.qiyi.player.wonder.body.BodyDef;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	
	public class BonusRemote extends Object {
		
		public function BonusRemote() {
			super();
		}
		
		private var _urlLoader:URLLoader;
		
		public function sendOneMinute(param1:String, param2:String, param3:int, param4:String, param5:String) : void {
			var _loc6_:* = "";
			_loc6_ = SystemConfig.BONUS_API_URL + "?eventid=" + "view_video" + "&count=1" + "&pid=0" + "&cid=0" + "&uuid=" + param1 + "&tvid=" + param2 + "&channelid=" + param3 + "&vvsourceid=" + param5 + "&albumid=" + param4;
			this.startService(_loc6_);
		}
		
		public function sendPlayOver(param1:String, param2:String, param3:int, param4:String, param5:String) : void {
			var _loc6_:* = "";
			_loc6_ = SystemConfig.BONUS_API_URL + "?eventid=" + "view_video" + "&count=1" + "&pid=0" + "&cid=0" + "&uuid=" + param1 + "&tvid=" + param2 + "&channelid=" + param3 + "&vvsourceid=" + param5 + "&albumid=" + param4;
			this.startService(_loc6_);
		}
		
		public function sendSavedTotalBonus(param1:uint, param2:String, param3:String) : void {
			var _loc4_:int = param1 / BodyDef.BONUS_DEFAULT_COUNT_ONCE;
			var _loc5_:* = "";
			_loc5_ = SystemConfig.BONUS_API_URL + "?eventid=" + "nologin_import" + "&count=" + _loc4_ + "&pid=0" + "&cid=0" + "&vvsourceid=" + param3 + "&uuid=" + param2;
			this.startService(_loc5_);
		}
		
		private function startService(param1:String) : void {
			var var_4:String = param1;
			if(this._urlLoader) {
				this._urlLoader.removeEventListener(Event.COMPLETE,this.onCompleteHandler);
				this._urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOErrorHandler);
				this._urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityErrorHandler);
				try {
					this._urlLoader.close();
				}
				catch(e:Error) {
				}
			}
			var urlRequest:URLRequest = new URLRequest(var_4 + "&n=" + Math.random());
			this._urlLoader = new URLLoader();
			this._urlLoader.addEventListener(Event.COMPLETE,this.onCompleteHandler);
			this._urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onIOErrorHandler);
			this._urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityErrorHandler);
			this._urlLoader.load(urlRequest);
		}
		
		private function onCompleteHandler(param1:Event) : void {
		}
		
		private function onIOErrorHandler(param1:IOErrorEvent) : void {
		}
		
		private function onSecurityErrorHandler(param1:Event) : void {
		}
	}
}
