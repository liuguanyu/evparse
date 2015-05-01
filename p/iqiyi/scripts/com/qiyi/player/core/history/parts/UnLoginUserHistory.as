package com.qiyi.player.core.history.parts {
	import flash.events.EventDispatcher;
	import com.qiyi.player.core.player.coreplayer.ICorePlayer;
	import com.qiyi.player.user.IUser;
	import com.qiyi.player.base.logging.ILogger;
	import com.qiyi.player.base.rpc.RemoteObjectEvent;
	import com.qiyi.player.core.player.def.StatusEnum;
	import com.qiyi.player.core.player.events.PlayerEvent;
	import com.qiyi.player.base.rpc.RemoteObjectStatusEnum;
	import com.qiyi.player.core.history.events.HistoryEvent;
	import com.qiyi.player.base.logging.Log;
	
	public class UnLoginUserHistory extends EventDispatcher {
		
		public function UnLoginUserHistory(param1:ICorePlayer) {
			this._log = Log.getLogger("com.qiyi.player.core.history.parts.UnLoginUserHistory");
			super();
			this._ready = false;
			this._firstUpdate = false;
			this._videoPlayTime = -1;
			this._holder = param1;
			this._holder.addEventListener(PlayerEvent.Evt_StatusChanged,this.onVideoStatusChanged);
		}
		
		private var _holder:ICorePlayer;
		
		private var _user:IUser = null;
		
		private var _firstUpdate:Boolean = false;
		
		private var _tvid:String;
		
		private var _videoPlayTime:int;
		
		private var _lastUploadTime:int = -2.147483648E9;
		
		private var _ready:Boolean;
		
		private var _downloadServer:DownloadServer;
		
		private var _uploadServer:UploadServer;
		
		private var _log:ILogger;
		
		public function getReady() : Boolean {
			return this._ready;
		}
		
		public function get videoPlayTime() : int {
			return this._videoPlayTime;
		}
		
		public function loadRecord(param1:String) : void {
			if(this._tvid == param1) {
				return;
			}
			this._tvid = param1;
			this._downloadServer = new DownloadServer(this._holder.uuid,this._tvid);
			this._downloadServer.addEventListener(RemoteObjectEvent.Evt_StatusChanged,this.onDownloadServerStatusChanged);
			this._downloadServer.initialize();
		}
		
		public function reset() : void {
			this._tvid = null;
			this._ready = false;
			this._firstUpdate = false;
			this._videoPlayTime = -1;
			this._lastUploadTime = int.MIN_VALUE;
			if(this._downloadServer) {
				this._downloadServer.removeEventListener(RemoteObjectEvent.Evt_StatusChanged,this.onDownloadServerStatusChanged);
				this._downloadServer.destroy();
				this._downloadServer = null;
			}
		}
		
		public function load(param1:IUser) : void {
			this._user = param1;
			if((this._holder.hasStatus(StatusEnum.ALREADY_PLAY)) && !this._holder.hasStatus(StatusEnum.STOPED) && !this._holder.hasStatus(StatusEnum.FAILED)) {
				this.update(this._holder.currentTime);
				this.upload();
			}
		}
		
		public function update(param1:int) : void {
			if(this._tvid == null) {
				return;
			}
			if(this._holder.hasStatus(StatusEnum.STOPPING)) {
				this._videoPlayTime = 0;
			} else {
				this._videoPlayTime = param1 >= LoginUserHistory.MIN_HISTORY_TIME?int(param1 / 1000):-1;
			}
		}
		
		public function upload() : void {
			var _loc1_:Object = null;
			if((this._holder) && (this._holder.runtimeData.recordHistory)) {
				if(this._lastUploadTime != this._videoPlayTime) {
					if(this._uploadServer) {
						this._uploadServer.destroy();
					}
					_loc1_ = new Object();
					_loc1_.tvId = this._tvid;
					_loc1_.terminalId = LoginUserHistory.TERMINAL_ID;
					_loc1_.videoPlayTime = this._videoPlayTime;
					this._uploadServer = new UploadServer(this._holder.uuid,_loc1_);
					this._uploadServer.initialize();
					this._lastUploadTime = this._videoPlayTime;
				}
			}
		}
		
		public function destroy() : void {
			this.reset();
			if(this._uploadServer) {
				this._uploadServer.destroy();
				this._uploadServer = null;
			}
			if(this._holder) {
				this._holder.removeEventListener(PlayerEvent.Evt_StatusChanged,this.onVideoStatusChanged);
				this._holder = null;
			}
		}
		
		private function onFirstUpdate() : void {
			if(!this._firstUpdate) {
				this._firstUpdate = true;
				this.upload();
			}
		}
		
		private function onDownloadServerStatusChanged(param1:RemoteObjectEvent) : void {
			var _loc2_:DownloadServer = param1.target as DownloadServer;
			if(_loc2_.status == RemoteObjectStatusEnum.Processing) {
				return;
			}
			this._ready = true;
			var _loc3_:String = _loc2_.tvid;
			var _loc4_:Object = _loc2_.getData();
			this.update((_loc4_) && (_loc4_.hasOwnProperty("tvId"))?_loc4_.videoPlayTime * 1000:-1);
			_loc2_.destroy();
			_loc2_.removeEventListener(RemoteObjectEvent.Evt_StatusChanged,this.onDownloadServerStatusChanged);
			this._downloadServer = null;
			dispatchEvent(new HistoryEvent(HistoryEvent.Evt_Ready,_loc3_));
		}
		
		private function onVideoStatusChanged(param1:PlayerEvent) : void {
			if((this._holder.runtimeData.recordHistory) && (this._holder.hasStatus(StatusEnum.ALREADY_PLAY)) && (Boolean(param1.data.isAdd))) {
				switch(param1.data.status) {
					case StatusEnum.PAUSED:
					case StatusEnum.FAILED:
						if(this._holder.currentTime >= LoginUserHistory.MIN_HISTORY_TIME) {
							this._videoPlayTime = this._holder.currentTime / 1000;
						}
						this.upload();
						break;
					case StatusEnum.PLAYING:
						this.onFirstUpdate();
						break;
				}
			}
		}
	}
}
import com.qiyi.player.base.rpc.impl.BaseRemoteObject;
import com.qiyi.player.base.logging.ILogger;
import flash.net.URLRequest;
import com.qiyi.player.core.Config;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.events.Event;
import flash.utils.clearTimeout;
import com.adobe.serialization.json.JSON;
import com.qiyi.player.base.rpc.RemoteObjectStatusEnum;
import com.qiyi.player.base.logging.Log;

class UploadServer extends BaseRemoteObject {
	
	function UploadServer(param1:String, param2:Object) {
		this._log = Log.getLogger("com.qiyi.player.core.history");
		super(0,"UnLoginUserHistoryUploadServer");
		this._updateData = param2;
		this._uuid = param1;
		_retryMaxCount = 5;
	}
	
	private var _uuid:String;
	
	private var _updateData:Object;
	
	private var _log:ILogger;
	
	override protected function getRequest() : URLRequest {
		var _loc1_:URLRequest = new URLRequest(Config.HISTORY_UNLOGIN_USER_UPLOAD_URL);
		_loc1_.method = URLRequestMethod.POST;
		var _loc2_:URLVariables = new URLVariables();
		_loc2_.ckuid = this._uuid;
		_loc2_.tvId = this._updateData.tvId;
		_loc2_.terminalId = this._updateData.terminalId;
		_loc2_.videoPlayTime = this._updateData.videoPlayTime;
		this._log.debug("UnLoginUserHistoryUploadServer upload time:" + _loc2_.videoPlayTime);
		_loc1_.data = _loc2_;
		return _loc1_;
	}
	
	override protected function onComplete(param1:Event) : void {
		var obj:Object = null;
		var event:Event = param1;
		clearTimeout(_waitingResponse);
		_waitingResponse = 0;
		try {
			obj = com.adobe.serialization.json.JSON.decode(_loader.data);
			if(obj.code != "A00000") {
				this._log.info("UnLoginUserHistoryUploadServer failed to upload history! errorcode: " + obj.code);
			} else {
				this._log.info("UnLoginUserHistoryUploadServer success to upload history!");
			}
			super.onComplete(event);
		}
		catch(e:Error) {
			_log.warn(_name + ": failed to parse data--> " + _loader.data.substr(0,100));
			setStatus(RemoteObjectStatusEnum.DataError);
		}
	}
}
import com.qiyi.player.base.rpc.impl.BaseRemoteObject;
import com.qiyi.player.base.logging.ILogger;
import com.qiyi.player.base.pub.ProcessesTimeRecord;
import flash.utils.getTimer;
import flash.net.URLRequest;
import com.qiyi.player.core.Config;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.events.Event;
import flash.utils.clearTimeout;
import com.adobe.serialization.json.JSON;
import com.qiyi.player.base.rpc.RemoteObjectStatusEnum;
import com.qiyi.player.base.logging.Log;

class DownloadServer extends BaseRemoteObject {
	
	function DownloadServer(param1:String, param2:String) {
		this._log = Log.getLogger("com.qiyi.player.core.history");
		super(0,"UnLoginUserHistoryDownloadServer");
		this._tvid = param2;
		this._uuid = param1;
		_timeout = 1500;
	}
	
	private var _uuid:String;
	
	private var _tvid:String;
	
	private var _log:ILogger;
	
	public function get tvid() : String {
		return this._tvid;
	}
	
	override public function initialize() : void {
		ProcessesTimeRecord.STime_history = getTimer();
		super.initialize();
	}
	
	override protected function getRequest() : URLRequest {
		var _loc1_:URLRequest = new URLRequest(Config.HISTORY_UNLOGIN_USER_READ_RECORD);
		_loc1_.method = URLRequestMethod.POST;
		var _loc2_:URLVariables = new URLVariables();
		_loc2_.ckuid = this._uuid;
		_loc2_.tvId = this._tvid;
		_loc1_.data = _loc2_;
		return _loc1_;
	}
	
	override protected function onComplete(param1:Event) : void {
		var obj:Object = null;
		var historyItem:Object = null;
		var historyTimeData:Object = null;
		var event:Event = param1;
		clearTimeout(_waitingResponse);
		_waitingResponse = 0;
		ProcessesTimeRecord.usedTime_history = getTimer() - ProcessesTimeRecord.STime_history;
		try {
			obj = com.adobe.serialization.json.JSON.decode(_loader.data);
			if(obj.code != "A00000") {
				this._log.info("UnLoginUserHistoryDownloadServer failed to load history! errorcode: " + obj.code);
				super.onComplete(event);
			} else {
				historyItem = obj.data;
				historyTimeData = {};
				historyTimeData.tvId = historyItem.tvId;
				historyTimeData.videoPlayTime = int(historyItem.videoPlayTime);
				_data = historyTimeData;
				this._log.debug("UnLoginUserHistoryDownloadServer download histroy time:" + historyItem.videoPlayTime);
				super.onComplete(event);
			}
		}
		catch(e:Error) {
			_log.warn(_name + ": failed to parse data--> " + _loader.data.substr(0,100));
			setStatus(RemoteObjectStatusEnum.DataError);
		}
	}
}
