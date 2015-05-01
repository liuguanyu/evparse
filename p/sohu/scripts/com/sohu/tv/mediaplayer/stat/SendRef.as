package com.sohu.tv.mediaplayer.stat {
	import flash.events.EventDispatcher;
	import com.sohu.tv.mediaplayer.PlayerConfig;
	import flash.net.URLVariables;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.sendToURL;
	
	public class SendRef extends EventDispatcher {
		
		public function SendRef() {
			super();
		}
		
		public static var singleton:SendRef;
		
		public static function getInstance() : SendRef {
			if(SendRef.singleton == null) {
				SendRef.singleton = new SendRef();
			}
			return SendRef.singleton;
		}
		
		public function sendPQ(param1:String, param2:Number = 0) : void {
			var _loc3_:* = "http://click.hd.sohu.com.cn/s.gif?";
			var _loc4_:String = PlayerConfig.currentPageUrl == ""?escape(PlayerConfig.outReferer):escape(PlayerConfig.currentPageUrl);
			var _loc5_:URLVariables = new URLVariables();
			_loc5_.type = param1;
			_loc5_.s = PlayerConfig.stype;
			_loc5_.ref = _loc4_;
			if(param2 != 0) {
				_loc5_.code = param2;
			}
			_loc5_.timestamp = new Date().getTime();
			var _loc6_:URLRequest = new URLRequest(_loc3_);
			_loc6_.method = URLRequestMethod.GET;
			_loc6_.data = _loc5_;
			sendToURL(_loc6_);
		}
		
		public function sendPQVPC(param1:String) : void {
			var _loc2_:* = "http://click.hd.sohu.com.cn/s.gif?";
			var _loc3_:String = PlayerConfig.currentPageUrl == ""?escape(PlayerConfig.outReferer):escape(PlayerConfig.currentPageUrl);
			var _loc4_:URLVariables = new URLVariables();
			_loc4_.type = param1;
			_loc4_.ref = _loc3_;
			_loc4_.vid = PlayerConfig.vid;
			_loc4_.tvid = PlayerConfig.tvid;
			_loc4_.pid = PlayerConfig.vrsPlayListId;
			_loc4_.cid = PlayerConfig.caid;
			_loc4_.s = PlayerConfig.stype;
			_loc4_.timestamp = new Date().getTime();
			var _loc5_:URLRequest = new URLRequest(_loc2_);
			_loc5_.method = URLRequestMethod.GET;
			_loc5_.data = _loc4_;
			sendToURL(_loc5_);
		}
		
		public function sendPQVPCU(param1:String) : void {
			var _loc2_:* = "http://click.hd.sohu.com.cn/s.gif?";
			var _loc3_:String = PlayerConfig.currentPageUrl == ""?escape(PlayerConfig.outReferer):escape(PlayerConfig.currentPageUrl);
			var _loc4_:URLVariables = new URLVariables();
			_loc4_.type = param1;
			_loc4_.ref = _loc3_;
			_loc4_.vid = PlayerConfig.vid;
			_loc4_.tvid = PlayerConfig.tvid;
			_loc4_.pid = PlayerConfig.vrsPlayListId;
			_loc4_.cid = PlayerConfig.caid;
			_loc4_.uuid = PlayerConfig.uuid;
			_loc4_.s = PlayerConfig.stype;
			_loc4_.timestamp = new Date().getTime();
			var _loc5_:URLRequest = new URLRequest(_loc2_);
			_loc5_.method = URLRequestMethod.GET;
			_loc5_.data = _loc4_;
			sendToURL(_loc5_);
		}
		
		public function sendPQDrog(param1:String) : void {
			var _loc2_:URLRequest = new URLRequest(param1);
			_loc2_.method = URLRequestMethod.GET;
			sendToURL(_loc2_);
		}
		
		public function sendPlayerTest(param1:String) : void {
			var _loc2_:* = "http://click2.hd.sohu.com/x.gif?";
			var _loc3_:URLVariables = new URLVariables();
			_loc3_.type = param1;
			_loc3_.plat = "flash";
			_loc3_.uid = PlayerConfig.userId;
			_loc3_.hotvrs = PlayerConfig.hotVrsSpend;
			_loc3_.adinfo = PlayerConfig.adinfoSpend;
			_loc3_.adget = PlayerConfig.adgetSpend;
			_loc3_.allot = PlayerConfig.allotSpend;
			_loc3_.cdnget = PlayerConfig.cdngetSpend;
			_loc3_.version = PlayerConfig.VERSION;
			_loc3_.allotip = PlayerConfig.allotip;
			_loc3_.cdnip = PlayerConfig.cdnIp;
			_loc3_.cdnid = PlayerConfig.cdnId;
			_loc3_.clientip = PlayerConfig.clientIp;
			if(PlayerConfig.jsgetSpend != 0) {
				_loc3_.jsget = PlayerConfig.jsgetSpend;
			}
			if(PlayerConfig.playerSpend != 0) {
				_loc3_.playerget = PlayerConfig.playerSpend;
			}
			_loc3_.url = PlayerConfig.currentPageUrl == ""?escape(PlayerConfig.outReferer):escape(PlayerConfig.currentPageUrl);
			_loc3_.timestamp = new Date().getTime();
			var _loc4_:URLRequest = new URLRequest(_loc2_);
			_loc4_.method = URLRequestMethod.GET;
			_loc4_.data = _loc3_;
			sendToURL(_loc4_);
		}
	}
}
