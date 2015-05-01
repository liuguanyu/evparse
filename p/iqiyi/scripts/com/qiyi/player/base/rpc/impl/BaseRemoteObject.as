package com.qiyi.player.base.rpc.impl {
	import flash.events.EventDispatcher;
	import com.qiyi.player.base.rpc.IRemoteObject;
	import flash.net.URLLoader;
	import com.qiyi.player.base.pub.EnumItem;
	import com.qiyi.player.base.logging.ILogger;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.ProgressEvent;
	import com.qiyi.player.base.rpc.RemoteObjectStatusEnum;
	import flash.utils.*;
	import com.qiyi.player.base.rpc.RemoteObjectEvent;
	import com.qiyi.player.base.logging.Log;
	
	public class BaseRemoteObject extends EventDispatcher implements IRemoteObject {
		
		public function BaseRemoteObject(param1:Number = 0, param2:String = "") {
			this.__log = Log.getLogger("com.qiyi.player.base.rpc.impl.BaseRemoteObject");
			super();
			this._id = param1;
			this._name = param2;
			this.__log.debug(this._name + " has been created!");
		}
		
		protected var _loader:URLLoader;
		
		protected var _inited:Boolean;
		
		protected var _id:Number;
		
		protected var _name:String;
		
		protected var _status:EnumItem;
		
		protected var _data:Object;
		
		protected var _url:String;
		
		protected var _retryMaxCount:int = 0;
		
		protected var _retryCount:int = 0;
		
		protected var _tempStatus:EnumItem;
		
		protected var _timeout:int;
		
		private var _lastRequestTime:int = 0;
		
		private var _timeForCallUpdate:int = 0;
		
		protected var _waitingResponse:uint = 0;
		
		private var __log:ILogger;
		
		public function destroy() : void {
			if(this._waitingResponse) {
				clearTimeout(this._waitingResponse);
			}
			this._waitingResponse = 0;
			if(this._timeForCallUpdate) {
				clearTimeout(this._timeForCallUpdate);
			}
			this._timeForCallUpdate = 0;
			if(this._loader) {
				this.removeListeners();
				try {
					this._loader.close();
				}
				catch(e:Error) {
				}
				this._loader = null;
			}
			this.__log.debug(this._name + " has been destroyed!");
		}
		
		protected function getRequest() : URLRequest {
			return null;
		}
		
		public function get url() : String {
			return this._url;
		}
		
		public function get retryMaxCount() : int {
			return this._retryMaxCount;
		}
		
		public function get retryCount() : int {
			return this._retryCount;
		}
		
		public function get id() : Number {
			return this._id;
		}
		
		public function get name() : String {
			return this._name;
		}
		
		public function get status() : EnumItem {
			return this._status;
		}
		
		public function initialize() : void {
			this.update();
		}
		
		private function addListeners() : void {
			if(this._loader == null) {
				return;
			}
			this._loader.addEventListener(Event.COMPLETE,this.onComplete);
			this._loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.onHttpStatus);
			this._loader.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
			this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
			this._loader.addEventListener(ProgressEvent.PROGRESS,this.onProgress);
		}
		
		private function removeListeners() : void {
			if(this._loader == null) {
				return;
			}
			this._loader.removeEventListener(Event.COMPLETE,this.onComplete);
			this._loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS,this.onHttpStatus);
			this._loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
			this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
			this._loader.removeEventListener(ProgressEvent.PROGRESS,this.onProgress);
		}
		
		public function update() : void {
			var req:URLRequest = null;
			if(this._timeForCallUpdate) {
				clearTimeout(this._timeForCallUpdate);
			}
			this._timeForCallUpdate = 0;
			if(this._waitingResponse) {
				clearTimeout(this._waitingResponse);
			}
			this._waitingResponse = 0;
			try {
				this.__log.debug(this._name + ": prepare to update");
				if(this._loader) {
					this.removeListeners();
					try {
						this._loader.close();
						this._loader = null;
					}
					catch(e:Error) {
					}
				}
				this._loader = new URLLoader();
				req = this.getRequest();
				if(req) {
					this.__log.info(this._name + ": " + req.url);
					this._url = req.url;
					this.addListeners();
					this._loader.load(req);
					this._lastRequestTime = getTimer();
					if(this._timeout > 0) {
						this._waitingResponse = setTimeout(this.onTimeout,this._timeout);
					}
				} else {
					this.__log.warn(this._name + ": the request param is null, failed to load!");
				}
				this._status = RemoteObjectStatusEnum.Processing;
			}
			catch(e:SecurityError) {
				_tempStatus = RemoteObjectStatusEnum.SecurityError;
				__log.warn(this._name + ": catch security error:" + e.message);
				this.dispatchEvent(new RemoteObjectEvent(RemoteObjectEvent.Evt_Exception,e));
				if(!exceptionHandler()) {
					setStatus(RemoteObjectStatusEnum.SecurityError);
				}
			}
		}
		
		public function getData() : Object {
			return this._data;
		}
		
		private function onTimeout() : void {
			this.__log.info(this._name + ": timeout");
			this.dispatchEvent(new RemoteObjectEvent(RemoteObjectEvent.Evt_Exception,null));
			this._loader.close();
			this._tempStatus = RemoteObjectStatusEnum.Timeout;
			if(!this.exceptionHandler()) {
				this.setStatus(RemoteObjectStatusEnum.Timeout);
			}
		}
		
		protected function setStatus(param1:EnumItem) : void {
			this.__log.debug(this._name + " status changed: " + param1.name);
			this._status = param1;
			this.dispatchEvent(new RemoteObjectEvent(RemoteObjectEvent.Evt_StatusChanged));
		}
		
		protected function onComplete(param1:Event) : void {
			this.__log.info(this._name + ": success to load data");
			clearTimeout(this._waitingResponse);
			this._waitingResponse = 0;
			if(!this._inited) {
				this._inited = true;
			}
			this.setStatus(RemoteObjectStatusEnum.Success);
		}
		
		protected function onHttpStatus(param1:HTTPStatusEvent) : void {
			clearTimeout(this._waitingResponse);
			this._waitingResponse = 0;
		}
		
		protected function retry() : void {
			this.__log.info(this._name + ": retry NO. " + (this._retryCount + 1));
			this._retryCount++;
			this.dispatchEvent(new RemoteObjectEvent(RemoteObjectEvent.Evt_Retry,this._retryCount));
			if(getTimer() - this._lastRequestTime > 3000) {
				this.update();
			} else {
				if(this._timeForCallUpdate) {
					clearTimeout(this._timeForCallUpdate);
				}
				this._timeForCallUpdate = setTimeout(this.update,3000 - (getTimer() - this._lastRequestTime));
			}
		}
		
		protected function exceptionHandler() : Boolean {
			clearTimeout(this._waitingResponse);
			this._waitingResponse = 0;
			if(this._retryCount < this._retryMaxCount) {
				this.retry();
				return true;
			}
			return false;
		}
		
		protected function onIOError(param1:IOErrorEvent) : void {
			this._tempStatus = RemoteObjectStatusEnum.ConnectError;
			this.__log.warn(this._name + ": io error");
			this.dispatchEvent(new RemoteObjectEvent(RemoteObjectEvent.Evt_Exception,param1));
			if(!this.exceptionHandler()) {
				this.setStatus(RemoteObjectStatusEnum.ConnectError);
			}
		}
		
		protected function onSecurityError(param1:SecurityErrorEvent) : void {
			this._tempStatus = RemoteObjectStatusEnum.SecurityError;
			this.__log.warn(this._name + ": security error");
			this.dispatchEvent(new RemoteObjectEvent(RemoteObjectEvent.Evt_Exception,param1));
			if(!this.exceptionHandler()) {
				this.setStatus(RemoteObjectStatusEnum.SecurityError);
			}
		}
		
		protected function onProgress(param1:ProgressEvent) : void {
		}
	}
}
