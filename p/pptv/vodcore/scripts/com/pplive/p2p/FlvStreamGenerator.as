package com.pplive.p2p
{
	import flash.events.EventDispatcher;
	import org.as3commons.concurrency.thread.IRunnable;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import org.as3commons.concurrency.thread.FramePseudoThread;
	import com.pplive.p2p.mp4.Mp4Stream;
	import com.pplive.p2p.struct.SubPiece;
	import com.pplive.p2p.events.DownloadRequestEvent;
	import flash.events.ProgressEvent;
	import com.pplive.p2p.events.SegmentCompleteEvent;
	import com.pplive.p2p.events.FlvDataEvent;
	import com.pplive.p2p.events.GetSeekTimeEvent;
	import com.pplive.p2p.events.DownloadHeaderRequestEvent;
	import flash.utils.ByteArray;
	
	public class FlvStreamGenerator extends EventDispatcher implements IRunnable
	{
		
		private static var logger:ILogger = getLogger(FlvStreamGenerator);
		
		private static var MAX_SEND_COUNT_PER_FRAME:uint = 50;
		
		private var _resource:ResourceCache;
		
		private var _segmentIndex:uint;
		
		private var _frameThread:FramePseudoThread;
		
		private var _mp4Stream:Mp4Stream;
		
		private var _sendPosition:SubPiece;
		
		private var _isFirstSubpieceAfterSeek:Boolean;
		
		private var _needSeek:Boolean = false;
		
		private var _currentTime:Number = 0;
		
		private var _seekTime:Number = 0;
		
		private var _seekOffset:uint = 0;
		
		private var _downloadHeaderRequestDispatched:Boolean = false;
		
		public function FlvStreamGenerator(param1:ResourceCache, param2:uint)
		{
			this._mp4Stream = new Mp4Stream();
			this._sendPosition = new SubPiece(0,0);
			super();
			this._resource = param1;
			this._segmentIndex = param2;
			this._resource.stat.isPlaying = true;
			this._mp4Stream.addEventListener(ProgressEvent.PROGRESS,this.onRecvFlvData,false,0,true);
			this._mp4Stream.addEventListener(SegmentCompleteEvent.SEGMENT_COMPLETE,this.onComplete,false,0,true);
		}
		
		public function setBaseTimeStamp(param1:uint, param2:uint) : void
		{
			this._mp4Stream.setBaseTimeStamp(param1,param2);
		}
		
		public function get resource() : ResourceCache
		{
			return this._resource;
		}
		
		public function get isRunning() : Boolean
		{
			return !(this._frameThread == null);
		}
		
		public function get currentSendPosition() : uint
		{
			return this._sendPosition.offset;
		}
		
		public function get segmentIndex() : uint
		{
			return this._segmentIndex;
		}
		
		public function start() : void
		{
			if(this._frameThread == null)
			{
				this._frameThread = new FramePseudoThread(this);
				this._frameThread.start();
				if(this._needSeek)
				{
					this.handleSeek();
				}
				else
				{
					dispatchEvent(new DownloadRequestEvent(this._sendPosition.offset));
				}
			}
		}
		
		public function stop() : void
		{
			this._resource.stat.isPlaying = false;
			if(this._frameThread)
			{
				this._frameThread.stop();
				this._frameThread = null;
			}
		}
		
		public function destroy() : void
		{
			this.stop();
			this._mp4Stream.destroy();
			this._mp4Stream.removeEventListener(ProgressEvent.PROGRESS,this.onRecvFlvData);
			this._mp4Stream.removeEventListener(SegmentCompleteEvent.SEGMENT_COMPLETE,this.onComplete);
		}
		
		public function seek(param1:Number, param2:Number) : void
		{
			this._needSeek = true;
			this._currentTime = param1;
			this._seekTime = param2;
			this._downloadHeaderRequestDispatched = false;
			if(this.isRunning)
			{
				this.handleSeek();
			}
		}
		
		public function getRealSeekTime(param1:Number, param2:Number) : Number
		{
			return this._mp4Stream.hasMp4Header()?this._mp4Stream.getRealSeekTime(param1,param2):-1;
		}
		
		public function process() : void
		{
			if(this._needSeek)
			{
				this.handleSeek();
			}
			this.sendBytesToMp4Stream();
		}
		
		public function cleanup() : void
		{
		}
		
		private function onRecvFlvData(param1:ProgressEvent) : void
		{
			if(!this._needSeek)
			{
				dispatchEvent(new FlvDataEvent(this._mp4Stream.readBytes()));
			}
		}
		
		private function onComplete(param1:SegmentCompleteEvent) : void
		{
			this.stop();
			dispatchEvent(param1);
		}
		
		private function handleSeek() : void
		{
			var _loc1:* = NaN;
			if(this._mp4Stream.hasMp4Header())
			{
				if(this._seekTime < 0.1)
				{
					this._seekTime = 0;
				}
				logger.info("handleSeek: " + this._seekTime);
				this._needSeek = false;
				_loc1 = this._mp4Stream.getRealSeekTime(this._currentTime,this._seekTime);
				dispatchEvent(new GetSeekTimeEvent(_loc1));
				this._seekOffset = this._mp4Stream.seek(this._currentTime,this._seekTime);
				this._sendPosition = SubPiece.createSubPieceFromOffset(this._seekOffset);
				this._isFirstSubpieceAfterSeek = true;
				dispatchEvent(new DownloadRequestEvent(this._seekOffset));
				return;
			}
			if(!this._downloadHeaderRequestDispatched)
			{
				logger.info("seek without header, dispatch download header request");
				this._downloadHeaderRequestDispatched = true;
				dispatchEvent(new DownloadHeaderRequestEvent());
			}
		}
		
		private function sendBytesToMp4Stream() : void
		{
			var _loc1:uint = 0;
			var _loc2:ByteArray = null;
			if(!this._resource.isDrmSetup)
			{
				return;
			}
			while(_loc1++ < MAX_SEND_COUNT_PER_FRAME && (this._resource.hasSubPiece(this._sendPosition)))
			{
				_loc2 = this._resource.getSubPiece(this._sendPosition);
				if(this._isFirstSubpieceAfterSeek)
				{
					_loc2.position = this._seekOffset - this._sendPosition.offset;
					this._isFirstSubpieceAfterSeek = false;
				}
				this._sendPosition.moveToNextSubPiece();
				this._mp4Stream.appendBytes(_loc2);
			}
		}
	}
}
