package com.pplive.play
{
	import flash.events.EventDispatcher;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	import flash.utils.ByteArray;
	import com.pplive.vod.events.*;
	import flash.events.TimerEvent;
	import flash.events.NetStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	
	public class MultiSolutionPlayManager extends EventDispatcher implements IPlayManager
	{
		
		private static var logger:ILogger = getLogger(MultiSolutionPlayManager);
		
		private static const SWITCH_DELAY:Number = 3;
		
		private var _video;
		
		private var _netConnection:NetConnection;
		
		private var _netStream:NetStream;
		
		private var _playInfos:Vector.<PlayInfo>;
		
		private var _initFT:String;
		
		private var _isVip:Boolean = false;
		
		private var _curPlayManager:P2PPlayManager;
		
		private var _newPlayManager:P2PPlayManager;
		
		private var _switchTime:Number = -1;
		
		private var _timer:Timer;
		
		private var _haveDispatchPlayStartEvent:Boolean = false;
		
		public function MultiSolutionPlayManager(param1:Vector.<PlayInfo>, param2:String = "0")
		{
			this._netConnection = new NetConnection();
			this._playInfos = new Vector.<PlayInfo>();
			this._timer = new Timer(100);
			super();
			this._playInfos = param1;
			this._initFT = param2;
			if(this._playInfos.length == 0)
			{
				throw Error("invalid playinfos");
			}
			else
			{
				this._timer.addEventListener(TimerEvent.TIMER,this.onTimer,false,0,true);
				this._netConnection.addEventListener(NetStatusEvent.NET_STATUS,this.netStatusHandler,false,0,true);
				this._netConnection.connect(null);
				return;
			}
		}
		
		public function destroy() : void
		{
			try
			{
				this._netStream.close();
				this._netConnection.close();
			}
			catch(e:*)
			{
			}
			this._video = null;
			this._timer.stop();
			this._curPlayManager.destroy();
			this.removeListeners(this._curPlayManager);
			if(this._newPlayManager)
			{
				this._newPlayManager.destroy();
				this._newPlayManager = null;
			}
		}
		
		public function get playInfo() : PlayInfo
		{
			return this._curPlayManager.playInfo;
		}
		
		public function attachVideo(param1:*) : void
		{
			this._video = param1;
			this._curPlayManager.attachVideo(param1);
		}
		
		public function switchFT(param1:String) : void
		{
			logger.info("switch ft: " + param1);
			var _loc2:PlayInfo = this.getPlayInfoByFT(param1);
			if((_loc2) && !(_loc2 == this._curPlayManager.playInfo))
			{
				this.doSwitch(_loc2,this._curPlayManager.time);
			}
		}
		
		public function play(param1:Number = 0) : void
		{
			this._curPlayManager.play(param1);
			if(this._newPlayManager)
			{
				this._newPlayManager.play(param1);
			}
		}
		
		public function seek(param1:Number) : void
		{
			this._curPlayManager.seek(param1);
			if(this._newPlayManager)
			{
				this._newPlayManager.seek(param1);
			}
		}
		
		public function set availableDelayTime(param1:uint) : void
		{
			this._curPlayManager.availableDelayTime = param1;
			if(this._newPlayManager)
			{
				this._newPlayManager.availableDelayTime = param1;
			}
		}
		
		public function set isVip(param1:Boolean) : void
		{
			this._isVip = param1;
			this._curPlayManager.isVip = this._isVip;
			if(this._newPlayManager)
			{
				this._newPlayManager.isVip = this._isVip;
			}
		}
		
		public function pause() : void
		{
			if(this._newPlayManager)
			{
			}
			this._curPlayManager.pause();
		}
		
		public function resume() : void
		{
			this._curPlayManager.resume();
		}
		
		public function get volume() : Number
		{
			return this._curPlayManager.volume;
		}
		
		public function set volume(param1:Number) : void
		{
			this._curPlayManager.volume = param1;
		}
		
		public function get bufferTime() : Number
		{
			return this._curPlayManager.bufferTime;
		}
		
		public function get bufferLength() : Number
		{
			return this._curPlayManager.bufferLength;
		}
		
		public function get droppedFrame() : Number
		{
			return this._curPlayManager.droppedFrame;
		}
		
		public function get time() : Number
		{
			return this._curPlayManager.time;
		}
		
		public function get stream() : NetStream
		{
			return this._curPlayManager.stream;
		}
		
		public function get currentSegment() : int
		{
			return this._curPlayManager.currentSegment;
		}
		
		public function appendBytes(param1:ByteArray) : void
		{
			this._curPlayManager.appendBytes(param1);
		}
		
		private function doSwitch(param1:PlayInfo, param2:Number) : void
		{
			logger.info("switch ft: from[" + this._curPlayManager.playInfo.ft + "] to[" + param1.ft + "]");
			this.removeListeners(this._curPlayManager);
			this._curPlayManager.destroy();
			this._curPlayManager = new P2PPlayManager(param1,this._netStream);
			this.addListeners(this._curPlayManager);
			this._curPlayManager.isVip = this._isVip;
			this._curPlayManager.attachVideo(this._video);
			this._curPlayManager.play(param2);
			dispatchEvent(new PlayStatusEvent(PlayStatusEvent.SWITCH_FT,this._curPlayManager.playInfo.ft));
		}
		
		private function getPlayInfoByFT(param1:String) : PlayInfo
		{
			var _loc2:PlayInfo = null;
			for each(_loc2 in this._playInfos)
			{
				if(_loc2.ft == param1)
				{
					return _loc2;
				}
			}
			if(this._playInfos.length > 0)
			{
				return this._playInfos[0];
			}
			return null;
		}
		
		private function onTimer(param1:TimerEvent) : void
		{
		}
		
		private function netStatusHandler(param1:NetStatusEvent) : void
		{
			var _loc2:PlayInfo = null;
			switch(param1.info.code)
			{
				case "NetConnection.Connect.Success":
					this._netConnection.removeEventListener(NetStatusEvent.NET_STATUS,this.netStatusHandler);
					this.createNetStream();
					_loc2 = this.getPlayInfoByFT(this._initFT);
					this._curPlayManager = new P2PPlayManager(_loc2,this._netStream);
					this.addListeners(this._curPlayManager);
					break;
			}
		}
		
		private function createNetStream() : void
		{
			this._netStream = new NetStream(this._netConnection);
			this._netStream.inBufferSeek = false;
			this._netStream.checkPolicyFile = true;
			this._netStream.bufferTime = PlayManager.STREAM_BUFFER_TIME;
			this._netStream.addEventListener(IOErrorEvent.IO_ERROR,this.onError,false,0,true);
			this._netStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.onError,false,0,true);
			this._netStream.play(null);
		}
		
		private function onError(param1:Event) : void
		{
			logger.error("onError: " + param1.toString());
		}
		
		private function addListeners(param1:P2PPlayManager) : void
		{
			param1.addEventListener(PlayStatusEvent.BUFFER_EMPTY,this.onPlayEvent,false,0,true);
			param1.addEventListener(PlayStatusEvent.PLAY_START,this.onPlayEvent,false,0,true);
			param1.addEventListener(PlayProgressEvent.PLAY_PROGRESS,this.onPlayEvent,false,0,true);
			param1.addEventListener(PlayStatusEvent.PLAY_SEEK_NOTIFY,this.onPlayEvent,false,0,true);
			param1.addEventListener(PlayStatusEvent.BUFFER_FULL,this.onPlayEvent,false,0,true);
			param1.addEventListener(PlayStatusEvent.PLAY_COMPLETE,this.onPlayEvent,false,0,true);
			param1.addEventListener(PlayStatusEvent.PLAY_PAUSED,this.onPlayEvent,false,0,true);
			param1.addEventListener(PlayStatusEvent.PLAY_FAILED,this.onPlayEvent,false,0,true);
			param1.addEventListener(PlayResultEvent.PLAY_RESULT,this.onPlayEvent,false,0,true);
			param1.addEventListener(DacLogEvent.P2P_DAC_LOG,this.onPlayEvent,false,0,true);
			param1.addEventListener(DacLogEvent.DETECT_KERNEL_LOG,this.onPlayEvent,false,0,true);
		}
		
		private function removeListeners(param1:P2PPlayManager) : void
		{
			param1.removeEventListener(PlayStatusEvent.BUFFER_EMPTY,this.onPlayEvent);
			param1.removeEventListener(PlayStatusEvent.PLAY_START,this.onPlayEvent);
			param1.removeEventListener(PlayProgressEvent.PLAY_PROGRESS,this.onPlayEvent);
			param1.removeEventListener(PlayStatusEvent.PLAY_SEEK_NOTIFY,this.onPlayEvent);
			param1.removeEventListener(PlayStatusEvent.BUFFER_FULL,this.onPlayEvent);
			param1.removeEventListener(PlayStatusEvent.PLAY_COMPLETE,this.onPlayEvent);
			param1.removeEventListener(PlayStatusEvent.PLAY_PAUSED,this.onPlayEvent);
			param1.removeEventListener(PlayStatusEvent.PLAY_FAILED,this.onPlayEvent);
			param1.removeEventListener(PlayResultEvent.PLAY_RESULT,this.onPlayEvent);
			param1.removeEventListener(DacLogEvent.P2P_DAC_LOG,this.onPlayEvent);
			param1.removeEventListener(DacLogEvent.DETECT_KERNEL_LOG,this.onPlayEvent);
		}
		
		private function onPlayEvent(param1:Event) : void
		{
			if(param1.type != PlayStatusEvent.PLAY_START)
			{
				dispatchEvent(param1);
			}
			else if(!this._haveDispatchPlayStartEvent)
			{
				dispatchEvent(param1);
				this._haveDispatchPlayStartEvent = true;
			}
			
		}
	}
}
