package com.sohu.tv.mediaplayer.net {
	import ebing.net.*;
	import ebing.utils.*;
	import flash.events.*;
	import flash.utils.*;
	
	public class TvSohuURLLoaderUtil extends URLLoaderUtil {
		
		public function TvSohuURLLoaderUtil() {
			this._errCdnIds = new Array();
			super();
		}
		
		private var _cdn301TimeLimit:int = 15;
		
		private var _cdn200TimeLimit:int = 10;
		
		private var _p2pTimeLimit:int = 20;
		
		private var _cdnTimeoutId:Number = 0;
		
		private var _cdnIP:String = "";
		
		private var _cdnID:String = "";
		
		private var _errCdnIds:Array;
		
		private var _hasP2P:Boolean = false;
		
		private var _urlloader:URLLoaderUtil;
		
		private var _isnp:Boolean = false;
		
		private var _isWriteLog:Boolean = false;
		
		private var _statusCode:int = 0;
		
		override public function multiSend(param1:String) : void {
			if(param1 == null || param1 == "") {
				return;
			}
			var _loc2_:RegExp = new RegExp("http:\\/\\/atyt.tv.sohu.com");
			var _loc3_:RegExp = new RegExp("http:\\/\\/atyg.tv.sohu.com");
			var _loc4_:RegExp = new RegExp("http:\\/\\/aty.tv.sohu.com");
			var _loc5_:Array = param1.split("|http:");
			var _loc6_:* = "";
			var _loc7_:* = 0;
			while(_loc7_ < _loc5_.length) {
				_loc6_ = _loc7_ > 0?"http:":"";
				_loc6_ = _loc6_ + _loc5_[_loc7_];
				_loc6_ = (_loc2_.test(_loc6_)) || (_loc3_.test(_loc6_)) || (_loc4_.test(_loc6_))?_loc6_ + "&t=" + new Date().time:_loc6_;
				send(_loc6_);
				_loc7_++;
			}
		}
		
		public function multiSendAndCallBack(param1:String, param2:Function) : void {
			var _loc10_:* = false;
			if(param1 == null || param1 == "") {
				return;
			}
			var _loc3_:RegExp = new RegExp("http:\\/\\/atyt.tv.sohu.com");
			var _loc4_:RegExp = new RegExp("http:\\/\\/atyg.tv.sohu.com");
			var _loc5_:RegExp = new RegExp("http:\\/\\/aty.tv.sohu.com");
			var _loc6_:RegExp = new RegExp("http:\\/\\/vm\\.aty\\.sohu\\.com");
			var _loc7_:Array = param1.split("|http:");
			var _loc8_:* = "";
			var _loc9_:* = 0;
			while(_loc9_ < _loc7_.length) {
				_loc8_ = _loc9_ > 0?"http:":"";
				_loc8_ = _loc8_ + _loc7_[_loc9_];
				_loc8_ = (_loc3_.test(_loc8_)) || (_loc4_.test(_loc8_)) || (_loc5_.test(_loc8_))?_loc8_ + "&t=" + new Date().time:_loc8_;
				_loc10_ = _loc8_.split("http://vm.aty.sohu.com/pvlog?").length > 1;
				if(_loc10_) {
					param2(_loc8_);
				} else {
					send(_loc8_);
				}
				_loc9_++;
			}
		}
		
		override protected function ioErrorHandler(param1:IOErrorEvent) : void {
			if(!_isDispatched) {
				_isDispatched = true;
				close();
				clearTimeout(_setTimeoutId_num);
				_isLoaded_boo = false;
				_spend_num = getTimer() - _spend_num;
				if(this._handler_fun != null) {
					this._handler_fun({
						"info":"ioError",
						"err":param1,
						"target":this,
						"status":this._statusCode
					});
				}
			}
		}
		
		override protected function httpStatusHandler(param1:HTTPStatusEvent) : void {
			this._statusCode = param1.status;
		}
	}
}
