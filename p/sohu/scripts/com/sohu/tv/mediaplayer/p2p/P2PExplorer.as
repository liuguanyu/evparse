package com.sohu.tv.mediaplayer.p2p {
	import com.sohu.tv.mediaplayer.PlayerConfig;
	import ebing.net.*;
	import flash.utils.setInterval;
	
	public class P2PExplorer extends Object {
		
		public function P2PExplorer() {
			super();
			this._intervalId = setInterval(this.checkP2P,30000);
			this._p2pStat = new Object();
		}
		
		private static var singleton:P2PExplorer;
		
		public static function getInstance() : P2PExplorer {
			if(singleton == null) {
				singleton = new P2PExplorer();
			}
			return singleton;
		}
		
		private var _intervalId:Number = 0;
		
		private var _hasP2P:Boolean = true;
		
		private var _p2pStat:Object;
		
		private var _isFirstTime:Boolean = true;
		
		private function checkP2P() : void {
			new URLLoaderUtil().load(1,this.handshakeReport,PlayerConfig.CHECKP2PPATH + "shakehand" + "?uuid=" + PlayerConfig.uuid + "&vid=" + PlayerConfig.vid + "&r=" + (new Date().getTime() + Math.random()));
		}
		
		private function handshakeReport(param1:Object) : void {
			if(param1.info == "success") {
				this._hasP2P = true;
			} else {
				this._hasP2P = false;
			}
		}
		
		public function get hasP2P() : Boolean {
			return this._hasP2P;
		}
		
		public function set hasP2P(param1:Boolean) : void {
			this._hasP2P = param1;
		}
		
		public function callP2P(param1:Function) : void {
			if(this._isFirstTime) {
				this._isFirstTime = false;
				new URLLoaderUtil().load(2,param1,PlayerConfig.CHECKP2PPATH + "shakehand" + "?uuid=" + PlayerConfig.uuid + "&vid=" + PlayerConfig.vid + "&r=" + (new Date().getTime() + Math.random()));
			} else {
				new URLLoaderUtil().load(1,param1,PlayerConfig.CHECKP2PPATH + "shakehand" + "?uuid=" + PlayerConfig.uuid + "&vid=" + PlayerConfig.vid + "&r=" + (new Date().getTime() + Math.random()));
			}
		}
		
		public function p2pStat(param1:Object) : void {
			this._p2pStat = param1;
		}
		
		public function get statTotal() : Number {
			if(!(this._p2pStat == null) && !(this._p2pStat.t == null)) {
				return this._p2pStat.t;
			}
			return 0;
		}
		
		public function get statCdn() : Number {
			if(!(this._p2pStat == null) && !(this._p2pStat.c == null)) {
				return this._p2pStat.c;
			}
			return 0;
		}
	}
}
