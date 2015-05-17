package com.pplive.play
{
	import com.pplive.monitor.Monitable;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	import com.pplive.vod.events.*;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.AsyncErrorEvent;
	import flash.events.TimerEvent;
	import flash.media.SoundTransform;
	import flash.utils.getTimer;
	import flash.utils.ByteArray;
	import com.pplive.p2p.struct.Constants;
	import flash.net.NetStreamAppendBytesAction;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class PlayManager extends Monitable implements IPlayManager
	{
		
		private static var logger:ILogger = getLogger(PlayManager);
		
		public static var STREAM_BUFFER_TIME:Number = 2;
		
		protected var connection:NetConnection;
		
		protected var video;
		
		protected var _stream:NetStream;
		
		protected var _preStreamTime:Number = 0;
		
		protected var _isPaused:Boolean = false;
		
		private var _closeNetStreamUponDestroy:Boolean;
		
		protected var _availableDelayTime:uint;
		
		protected var currentTime:Number = 0;
		
		protected var seekTime:Number = 0;
		
		protected var sessionId:String;
		
		protected var haveDispatchPlayStartEvent:Boolean = false;
		
		protected var timer:Timer;
		
		protected const PLAY_RESULT_NOT_REPORT:uint = 0;
		
		protected const PLAY_RESULT_START_BFULL_REPORT:uint = 1;
		
		protected const PLAY_RESULT_SEEK_BFULL_REPORT:uint = 2;
		
		protected var reportPlayResultStauts:uint = 1;
		
		protected var playResultStartTime:uint = 0;
		
		public function PlayManager(param1:NetStream = null)
		{
			super("PlayManager");
			if(param1)
			{
				this._closeNetStreamUponDestroy = false;
				this._stream = param1;
				this._stream.addEventListener(NetStatusEvent.NET_STATUS,this.netStatusHandler,false,0,true);
				this._stream.addEventListener(IOErrorEvent.IO_ERROR,this.errorHandler,false,0,true);
				this._stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.errorHandler,false,0,true);
			}
			else
			{
				this._closeNetStreamUponDestroy = true;
				this.connection = new NetConnection();
				this.connection.addEventListener(NetStatusEvent.NET_STATUS,this.netStatusHandler,false,0,true);
				this.connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler,false,0,true);
				this.connection.connect(null);
			}
			this.timer = new Timer(1000);
			this.timer.addEventListener(TimerEvent.TIMER,this.onTimer,false,0,true);
			this.sessionId = new Date().valueOf().toString() + Math.random();
		}
		
		public function destroy() : void
		{
			logger.info("PlayManager destory");
			if(this.video)
			{
				this.video.attachNetStream(null);
				this.video = null;
			}
			if(this.connection)
			{
				this.connection.close();
				this.connection.removeEventListener(NetStatusEvent.NET_STATUS,this.netStatusHandler);
				this.connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
				this.connection = null;
			}
			this._stream.removeEventListener(NetStatusEvent.NET_STATUS,this.netStatusHandler);
			this._stream.removeEventListener(IOErrorEvent.IO_ERROR,this.errorHandler);
			this._stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,this.errorHandler);
			if(this._closeNetStreamUponDestroy)
			{
				this._stream.close();
			}
			this._stream = null;
			this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
			this.timer.stop();
			this.timer = null;
			this.sessionId = null;
		}
		
		public function get playInfo() : PlayInfo
		{
			return null;
		}
		
		public function attachVideo(param1:*) : void
		{
			this.video = param1;
			param1.attachNetStream(this._stream);
		}
		
		public function get volume() : Number
		{
			return this._stream.soundTransform.volume;
		}
		
		public function get bufferTime() : Number
		{
			return this._stream.bufferTime;
		}
		
		public function get bufferLength() : Number
		{
			return this.getRestPlayTime();
		}
		
		public function set volume(param1:Number) : void
		{
			if(param1 < 0)
			{
				var param1:Number = 0;
			}
			logger.info("set volume:" + param1);
			this._stream.soundTransform = new SoundTransform(param1);
		}
		
		public function play(param1:Number = 0) : void
		{
			logger.info("play from " + param1 + "seconds.");
			this.reportPlayResultStauts = this.PLAY_RESULT_START_BFULL_REPORT;
			this.playResultStartTime = getTimer();
			this.timer.start();
		}
		
		public function set availableDelayTime(param1:uint) : void
		{
			logger.info("availableDelayTime: " + param1);
			this._availableDelayTime = param1;
		}
		
		public function set isVip(param1:Boolean) : void
		{
		}
		
		public function switchFT(param1:String) : void
		{
		}
		
		public function seek(param1:Number) : void
		{
			logger.info("seek to " + param1 + "seconds.");
			this.reportPlayResultStauts = this.PLAY_RESULT_SEEK_BFULL_REPORT;
			this.playResultStartTime = getTimer();
			dispatchEvent(new PlayStatusEvent(PlayStatusEvent.BUFFER_EMPTY,false));
			this._stream.seek(0);
			this._preStreamTime = -1;
			this._availableDelayTime = 0;
		}
		
		public function pause() : void
		{
			logger.info("pause");
			this._stream.pause();
			this._isPaused = true;
		}
		
		public function resume() : void
		{
			logger.info("resume");
			this._stream.resume();
			this._isPaused = false;
			this._availableDelayTime = 0;
		}
		
		public function get droppedFrame() : Number
		{
			return this._stream.info.droppedFrames;
		}
		
		public function get time() : Number
		{
			return this.seekTime + this._stream.time;
		}
		
		public function get stream() : NetStream
		{
			return this._stream;
		}
		
		public function appendBytes(param1:ByteArray) : void
		{
			if(!this.haveDispatchPlayStartEvent)
			{
				this.haveDispatchPlayStartEvent = true;
				logger.info("NetStream.Play.Start: send play start event.playmode:" + this.getPlayMode());
				dispatchEvent(new PlayStatusEvent(PlayStatusEvent.PLAY_START,this.getPlayMode()));
				dispatchEvent(new PlayStatusEvent(PlayStatusEvent.BUFFER_EMPTY,false));
			}
			this._stream.appendBytes(param1);
		}
		
		protected function getPlayMode() : int
		{
			return Constants.PLAY_MODE_DIRECT;
		}
		
		protected function getPlayResult() : uint
		{
			return 0;
		}
		
		protected function get hasPendingBytes() : Boolean
		{
			return true;
		}
		
		protected function getRestPlayTime() : Number
		{
			return this._stream.bufferLength;
		}
		
		protected function get downloadSpeed() : uint
		{
			return 0;
		}
		
		protected function get vipAcceleratedSpeed() : uint
		{
			return 0;
		}
		
		protected function onTimer(param1:TimerEvent) : void
		{
			dispatchEvent(new PlayProgressEvent(this.time,this.getRestPlayTime(),this.downloadSpeed,this.vipAcceleratedSpeed));
			if(!this._isPaused)
			{
				if(!this.hasPendingBytes && this._stream.time < this._preStreamTime + 0.1)
				{
					logger.info("NetStream.Buffer.Empty movie complete.");
					dispatchEvent(new PlayStatusEvent(PlayStatusEvent.PLAY_COMPLETE));
					return;
				}
			}
			this._preStreamTime = this._stream.time;
			if(this.timer.delay * this.timer.currentCount >= 15 * 1000 && this._stream.bufferTime + 0.1 < STREAM_BUFFER_TIME)
			{
				this._stream.bufferTime = STREAM_BUFFER_TIME;
			}
			if(this._stream.bufferLength >= this._stream.bufferTime)
			{
				if(this.reportPlayResultStauts == this.PLAY_RESULT_START_BFULL_REPORT || this.reportPlayResultStauts == this.PLAY_RESULT_SEEK_BFULL_REPORT)
				{
					dispatchEvent(new PlayStatusEvent(PlayStatusEvent.BUFFER_FULL));
					logger.info("send buffer full event");
					this.DispatchPlayResultEvent();
				}
			}
			if(this._availableDelayTime > 0)
			{
				this._availableDelayTime--;
			}
		}
		
		protected function onSeekNotify() : void
		{
			logger.info("onSeekNotify");
			this._stream.appendBytesAction(NetStreamAppendBytesAction.RESET_BEGIN);
			dispatchEvent(new PlayStatusEvent(PlayStatusEvent.PLAY_SEEK_NOTIFY));
		}
		
		private function createNetStream() : void
		{
			this._stream = new NetStream(this.connection);
			this._stream.inBufferSeek = false;
			this._stream.checkPolicyFile = true;
			this._stream.bufferTime = STREAM_BUFFER_TIME;
			this._stream.addEventListener(NetStatusEvent.NET_STATUS,this.netStatusHandler,false,0,true);
			this._stream.addEventListener(IOErrorEvent.IO_ERROR,this.errorHandler,false,0,true);
			this._stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.errorHandler,false,0,true);
			this._stream.play(null);
		}
		
		protected function netStatusHandler(param1:NetStatusEvent) : void
		{
			switch(param1.info.code)
			{
				case "NetConnection.Connect.Success":
					this.createNetStream();
					break;
				case "NetStream.Buffer.Full":
					logger.info("NetStream.Buffer.Full " + new Date().toLocaleTimeString());
					dispatchEvent(new PlayStatusEvent(PlayStatusEvent.BUFFER_FULL));
					if(this.reportPlayResultStauts == this.PLAY_RESULT_START_BFULL_REPORT || this.reportPlayResultStauts == this.PLAY_RESULT_SEEK_BFULL_REPORT)
					{
						this.DispatchPlayResultEvent();
					}
					break;
				case "NetStream.Buffer.Empty":
					if(this.hasPendingBytes)
					{
						logger.info("NetStream.Buffer.Empty movie buffering.");
						dispatchEvent(new PlayStatusEvent(PlayStatusEvent.BUFFER_EMPTY,true));
					}
					else
					{
						logger.info("NetStream.Buffer.Empty movie complete.");
						dispatchEvent(new PlayStatusEvent(PlayStatusEvent.PLAY_COMPLETE));
					}
					break;
				case "NetStream.Seek.Notify":
					this.onSeekNotify();
					break;
				case "NetStream.Pause.Notify":
					dispatchEvent(new PlayStatusEvent(PlayStatusEvent.PLAY_PAUSED));
					break;
			}
		}
		
		protected function getPlayURL() : String
		{
			return "";
		}
		
		protected function DispatchPlayResultEvent() : void
		{
			logger.info("reportPlayResultStauts:" + this.reportPlayResultStauts);
			var _loc1:int = this.getPlayResult();
			var _loc2:String = this.getPlayURL();
			var _loc3:uint = getTimer() - this.playResultStartTime;
			logger.info("dispatch play result event,m:" + _loc1 + " url:" + _loc2 + " interval:" + _loc3);
			dispatchEvent(new PlayResultEvent(_loc1,_loc2,_loc3));
			this.reportPlayResultStauts = this.PLAY_RESULT_NOT_REPORT;
		}
		
		private function securityErrorHandler(param1:SecurityErrorEvent) : void
		{
			logger.info("securityErrorHandler: " + param1);
		}
		
		private function errorHandler(param1:Event) : void
		{
			logger.info("errorHandler: " + param1);
		}
		
		override public function updateMonitedAttributes(param1:Dictionary) : void
		{
		}
		
		public function get currentSegment() : int
		{
			return 0;
		}
	}
}
