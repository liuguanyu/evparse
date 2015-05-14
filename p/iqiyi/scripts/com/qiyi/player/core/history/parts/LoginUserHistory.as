package com.qiyi.player.core.history.parts
{
	import flash.events.EventDispatcher;
	import com.qiyi.player.core.player.coreplayer.ICorePlayer;
	import com.qiyi.player.user.IUser;
	import flash.utils.Timer;
	import com.qiyi.player.base.logging.ILogger;
	import com.qiyi.player.base.rpc.RemoteObjectEvent;
	import com.qiyi.player.core.Config;
	import flash.events.TimerEvent;
	import com.qiyi.player.core.player.def.StatusEnum;
	import com.qiyi.player.core.player.events.PlayerEvent;
	import com.qiyi.player.base.rpc.RemoteObjectStatusEnum;
	import com.qiyi.player.core.history.events.HistoryEvent;
	import com.qiyi.player.base.logging.Log;
	
	public class LoginUserHistory extends EventDispatcher
	{
		
		static const TERMINAL_ID:String = "11";
		
		static const MIN_HISTORY_TIME:int = 15000;
		
		private var _holder:ICorePlayer;
		
		private var _user:IUser = null;
		
		private var _tvid:String;
		
		private var _timer:Timer;
		
		private var _firstUpdate:Boolean;
		
		private var _ready:Boolean;
		
		private var _videoPlayTime:int;
		
		private var _lastUploadTime:int = -2.147483648E9;
		
		private var _downloadServer:DownloadServer;
		
		private var _uploadServer:UploadServer;
		
		private var _log:ILogger;
		
		public function LoginUserHistory(param1:ICorePlayer)
		{
			this._log = Log.getLogger("com.qiyi.player.core.history.parts.LoginUserHistory");
			super();
			this._ready = false;
			this._firstUpdate = false;
			this._videoPlayTime = -1;
			this._holder = param1;
			this._holder.addEventListener(PlayerEvent.Evt_StatusChanged,this.onVideoStatusChanged);
		}
		
		public function getReady() : Boolean
		{
			return this._ready;
		}
		
		public function get videoPlayTime() : int
		{
			return this._videoPlayTime;
		}
		
		public function loadRecord(param1:String) : void
		{
			if(this._tvid == param1)
			{
				return;
			}
			this._tvid = param1;
			if(this._downloadServer)
			{
				this._downloadServer.removeEventListener(RemoteObjectEvent.Evt_StatusChanged,this.onDownloadServerStatusChanged);
				this._downloadServer.destroy();
			}
			this._downloadServer = new DownloadServer(this._tvid);
			this._downloadServer.addEventListener(RemoteObjectEvent.Evt_StatusChanged,this.onDownloadServerStatusChanged);
			this._downloadServer.initialize();
			if(this._timer == null)
			{
				this._timer = new Timer(Config.HISTORY_LOGIN_USER_UPLOAD_RATE);
				this._timer.addEventListener(TimerEvent.TIMER,this.onTimer);
			}
		}
		
		public function load(param1:IUser) : void
		{
			this._user = param1;
			if((this._holder.hasStatus(StatusEnum.ALREADY_PLAY)) && !this._holder.hasStatus(StatusEnum.STOPED) && !this._holder.hasStatus(StatusEnum.FAILED))
			{
				this.update(this._holder.currentTime);
				this.upload();
			}
		}
		
		public function update(param1:int) : void
		{
			if(this._tvid == null)
			{
				return;
			}
			if(this._holder.hasStatus(StatusEnum.STOPPING))
			{
				this._videoPlayTime = 0;
			}
			else
			{
				this._videoPlayTime = param1 >= MIN_HISTORY_TIME?int(param1 / 1000):-1;
			}
		}
		
		public function upload() : void
		{
			var _loc1:Object = null;
			if(this._lastUploadTime != this._videoPlayTime)
			{
				if(this._uploadServer)
				{
					this._uploadServer.destroy();
				}
				_loc1 = new Object();
				_loc1.tvId = this._tvid;
				_loc1.terminalId = TERMINAL_ID;
				_loc1.videoPlayTime = this._videoPlayTime;
				this._uploadServer = new UploadServer(_loc1);
				this._uploadServer.initialize();
				this._lastUploadTime = this._videoPlayTime;
			}
		}
		
		public function reset() : void
		{
			this._tvid = null;
			this._ready = false;
			this._firstUpdate = false;
			this._videoPlayTime = -1;
			this._lastUploadTime = int.MIN_VALUE;
			if(this._timer)
			{
				this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
				this._timer.stop();
				this._timer = null;
			}
			if(this._downloadServer)
			{
				this._downloadServer.removeEventListener(RemoteObjectEvent.Evt_StatusChanged,this.onDownloadServerStatusChanged);
				this._downloadServer.destroy();
				this._downloadServer = null;
			}
		}
		
		public function destroy() : void
		{
			this.reset();
			if(this._uploadServer)
			{
				this._uploadServer.destroy();
				this._uploadServer = null;
			}
			if(this._holder)
			{
				this._holder.removeEventListener(PlayerEvent.Evt_StatusChanged,this.onVideoStatusChanged);
				this._holder = null;
			}
		}
		
		private function onTimer(param1:TimerEvent) : void
		{
			this.upload();
		}
		
		private function onFirstUpdate() : void
		{
			if(!this._firstUpdate)
			{
				this._firstUpdate = true;
				this.upload();
			}
		}
		
		private function onDownloadServerStatusChanged(param1:RemoteObjectEvent) : void
		{
			var _loc2:DownloadServer = param1.target as DownloadServer;
			if(_loc2.status == RemoteObjectStatusEnum.Processing)
			{
				return;
			}
			this._ready = true;
			var _loc3:String = _loc2.tvid;
			var _loc4:Object = _loc2.getData();
			this.update((_loc4) && (_loc4.hasOwnProperty("tvId"))?_loc4.videoPlayTime * 1000:-1);
			_loc2.destroy();
			_loc2.removeEventListener(RemoteObjectEvent.Evt_StatusChanged,this.onDownloadServerStatusChanged);
			this._downloadServer = null;
			dispatchEvent(new HistoryEvent(HistoryEvent.Evt_Ready,_loc3));
		}
		
		private function onVideoStatusChanged(param1:PlayerEvent) : void
		{
			if((this._holder.runtimeData.recordHistory) && (this._holder.hasStatus(StatusEnum.ALREADY_PLAY)) && (Boolean(param1.data.isAdd)))
			{
				switch(param1.data.status)
				{
					case StatusEnum.PAUSED:
					case StatusEnum.FAILED:
						this._timer.stop();
						if(this._holder.currentTime >= MIN_HISTORY_TIME)
						{
							this._videoPlayTime = this._holder.currentTime / 1000;
						}
						this.upload();
						break;
					case StatusEnum.PLAYING:
						this._timer.reset();
						this._timer.start();
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

class UploadServer extends BaseRemoteObject
{
	
	private var _updateData:Object;
	
	private var _log:ILogger;
	
	function UploadServer(param1:Object)
	{
		this._log = Log.getLogger("com.qiyi.player.core.history");
		super(0,"LoginUserHistoryUploadServer");
		this._updateData = param1;
		_retryMaxCount = 5;
	}
	
	override protected function getRequest() : URLRequest
	{
		var _loc1:URLRequest = new URLRequest(Config.HISTORY_LOGIN_USER_UPLOAD_URL);
		_loc1.method = URLRequestMethod.POST;
		var _loc2:URLVariables = new URLVariables();
		_loc2.tvId = this._updateData.tvId;
		_loc2.terminalId = this._updateData.terminalId;
		_loc2.videoPlayTime = this._updateData.videoPlayTime;
		this._log.debug("upload time:" + _loc2.videoPlayTime);
		_loc1.data = _loc2;
		return _loc1;
	}
	
	override protected function onComplete(param1:Event) : void
	{
		var obj:Object = null;
		var event:Event = param1;
		clearTimeout(_waitingResponse);
		_waitingResponse = 0;
		try
		{
			obj = com.adobe.serialization.json.JSON.decode(_loader.data);
			if(obj.code != "A00000")
			{
				this._log.info("failed to upload history! errorcode: " + obj.code);
			}
			else
			{
				this._log.info("success to upload history!");
			}
			super.onComplete(event);
		}
		catch(e:Error)
		{
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

class DownloadServer extends BaseRemoteObject
{
	
	private var _tvid:String;
	
	private var _log:ILogger;
	
	function DownloadServer(param1:String)
	{
		this._log = Log.getLogger("com.qiyi.player.core.history");
		super(0,"LoginUserHistoryDownloadServer");
		this._tvid = param1;
		_timeout = 1500;
	}
	
	public function get tvid() : String
	{
		return this._tvid;
	}
	
	override public function initialize() : void
	{
		ProcessesTimeRecord.STime_history = getTimer();
		super.initialize();
	}
	
	override protected function getRequest() : URLRequest
	{
		var _loc1:URLRequest = new URLRequest(Config.HISTORY_LOGIN_USER_READ_RECORD);
		_loc1.method = URLRequestMethod.POST;
		var _loc2:URLVariables = new URLVariables();
		_loc2.tvId = this._tvid;
		_loc2.limit = 15;
		_loc1.data = _loc2;
		return _loc1;
	}
	
	override protected function onComplete(param1:Event) : void
	{
		var obj:Object = null;
		var historyItem:Object = null;
		var historyTimeData:Object = null;
		var event:Event = param1;
		clearTimeout(_waitingResponse);
		_waitingResponse = 0;
		ProcessesTimeRecord.usedTime_history = getTimer() - ProcessesTimeRecord.STime_history;
		try
		{
			obj = com.adobe.serialization.json.JSON.decode(_loader.data);
			if(obj.code != "A00000")
			{
				this._log.info("LoginUserHistoryDownloadServer failed to load history! errorcode: " + obj.code);
				super.onComplete(event);
			}
			else
			{
				historyItem = obj.data;
				historyTimeData = {};
				historyTimeData.tvId = historyItem.tvId;
				historyTimeData.videoPlayTime = int(historyItem.videoPlayTime);
				this._data = historyTimeData;
				this._log.debug("download histroy time:" + historyItem.videoPlayTime);
				super.onComplete(event);
			}
		}
		catch(e:Error)
		{
			_log.warn(_name + ": failed to parse data--> " + _loader.data.substr(0,100));
			setStatus(RemoteObjectStatusEnum.DataError);
		}
	}
}
