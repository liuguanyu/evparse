package com.qiyi.player.core.video.engine.dm.provider
{
	import flash.events.EventDispatcher;
	import com.qiyi.player.core.IDestroy;
	import loader.vod.File;
	import com.qiyi.player.base.logging.ILogger;
	import loader.vod.FileState;
	import com.qiyi.player.core.video.decoder.IDecoder;
	import loader.vod.P2PFileLoader;
	import com.iqiyi.components.global.GlobalStage;
	import flash.net.NetStream;
	import com.qiyi.player.core.player.def.SeekTypeEnum;
	import loader.vod.VideoData;
	import flash.events.Event;
	import com.qiyi.player.core.video.events.ProviderEvent;
	import com.qiyi.player.base.logging.Log;
	
	public class Provider extends EventDispatcher implements IDestroy
	{
		
		private var _file:File;
		
		private var _loadingFailed:Boolean = false;
		
		private var _stuckToggle:Boolean = false;
		
		private var _userPauseToggle:Boolean = false;
		
		private var _isStopLoadingCalled:Boolean = false;
		
		private var _log:ILogger;
		
		public function Provider()
		{
			this._log = Log.getLogger("com.qiyi.player.core.video.provider.Provider");
			super();
		}
		
		public function get fileState() : FileState
		{
			if(this._file)
			{
				return this._file.fileState;
			}
			return null;
		}
		
		public function get bufferLength() : int
		{
			if(this._file)
			{
				return this._file.bufferLength;
			}
			return 0;
		}
		
		public function get eof() : Boolean
		{
			if(this._file)
			{
				return this._file.eof;
			}
			return false;
		}
		
		public function get loadingFailed() : Boolean
		{
			return this._loadingFailed;
		}
		
		public function get loadComplete() : Boolean
		{
			if(this._file)
			{
				return this._file.done;
			}
			return false;
		}
		
		public function initProvider(param1:IDecoder, param2:String, param3:Number, param4:Array, param5:Array, param6:int, param7:int, param8:String, param9:int, param10:String, param11:String, param12:Number, param13:int, param14:String, param15:Boolean, param16:Boolean, param17:String, param18:String, param19:Boolean, param20:String) : void
		{
			if(this._file == null)
			{
				this._isStopLoadingCalled = false;
				this._file = P2PFileLoader.instance.getFile();
				this._file.addEventListener(File.Evt_P2P_StateChange,this.onStateChanged);
				this._file.addEventListener(File.Evt_P2P_Final_Error,this.onError);
				this._file.initFile(GlobalStage.stage,param1 as NetStream,param2,param18,param12,param3,param4,param5,param7,param8,param6,param9,param10,param11,param13,param14,param15,param16,param17,this._log,param19,param20);
			}
		}
		
		public function setOpenPlay(param1:Boolean) : void
		{
			if(this._file)
			{
				this._log.info("p2p provider setOpenPlay: " + param1);
				this._file.playing = param1;
			}
		}
		
		public function setExpectTime(param1:int) : void
		{
			if(this._file)
			{
				this._file.expectPlayTime = param1;
			}
		}
		
		public function setMetaInfo(param1:Array) : void
		{
			if(this._file)
			{
				this._file.metaInfo = param1;
			}
		}
		
		public function setStartTime(param1:int) : void
		{
			if(this._file)
			{
				this._file.startTime = param1;
			}
		}
		
		public function setEndTime(param1:int) : void
		{
			if(this._file)
			{
				this._file.endTime = param1;
			}
		}
		
		public function seek(param1:int, param2:int, param3:int, param4:int = 0) : void
		{
			var _loc5:* = 0;
			if(this._file)
			{
				this._isStopLoadingCalled = false;
				_loc5 = 0;
				if((param4 & SeekTypeEnum.SKIP_ENJOYABLE_POINT) != 0)
				{
					_loc5 = -1;
				}
				else
				{
					_loc5 = 0;
				}
				this._file.seek(param1,param3,param2,_loc5);
			}
		}
		
		public function sequenceReadData() : MediaData
		{
			var _loc1:VideoData = null;
			var _loc2:MediaData = null;
			if(this._file)
			{
				_loc1 = this._file.read();
				if(_loc1)
				{
					_loc2 = new MediaData();
					_loc2.headers = _loc1.headers;
					_loc2.duration = _loc1.duration;
					_loc2.time = _loc1.time;
					_loc2.jumpFragment = _loc1.jumpFragment;
					_loc2.bytes = _loc1.bytes;
					return _loc2;
				}
			}
			return null;
		}
		
		public function sequenceReadDataFrom(param1:int) : MediaData
		{
			var _loc2:VideoData = null;
			var _loc3:MediaData = null;
			if(this._file)
			{
				_loc2 = this._file.readFrom(param1);
				if(_loc2)
				{
					_loc3 = new MediaData();
					_loc3.headers = _loc2.headers;
					_loc3.duration = _loc2.duration;
					_loc3.time = _loc2.time;
					_loc3.jumpFragment = _loc2.jumpFragment;
					_loc3.bytes = _loc2.bytes;
					return _loc3;
				}
			}
			return null;
		}
		
		public function setFragments(param1:Array) : void
		{
			if(this._file)
			{
				this._file.fragments = param1;
			}
		}
		
		public function setStuckToggle(param1:Boolean) : void
		{
			if(this._stuckToggle != param1)
			{
				this._stuckToggle = param1;
				if(this._file)
				{
					this._file.lag = param1;
				}
			}
		}
		
		public function setUserPauseToggle(param1:Boolean) : void
		{
			if(this._userPauseToggle != param1)
			{
				this._userPauseToggle = param1;
				if(this._file)
				{
					this._file.userPause = param1;
				}
			}
		}
		
		public function setLoadToggle(param1:Boolean) : void
		{
			if((this._isStopLoadingCalled) && !param1)
			{
				return;
			}
			if(this._file)
			{
				this._log.info("call setLoadToggle value:" + param1);
				this._isStopLoadingCalled = !param1;
				this._file.setToggleLoading(param1);
			}
		}
		
		public function destroy() : void
		{
			if(this._file)
			{
				this._file.removeEventListener(File.Evt_P2P_StateChange,this.onStateChanged);
				this._file.removeEventListener(File.Evt_P2P_Final_Error,this.onError);
				this._file.clear();
				this._file = null;
			}
		}
		
		private function onStateChanged(param1:Event) : void
		{
			dispatchEvent(new ProviderEvent(ProviderEvent.Evt_StateChanged));
		}
		
		private function onError(param1:Event) : void
		{
			this._isStopLoadingCalled = false;
			this._loadingFailed = true;
			dispatchEvent(new ProviderEvent(ProviderEvent.Evt_Failed));
		}
	}
}
