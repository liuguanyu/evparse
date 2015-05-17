package com.pplive.play
{
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import com.pplive.p2p.download.CDNChecker;
	import com.pplive.p2p.ResourceCache;
	import com.pplive.p2p.FlvStreamGenerator;
	import com.pplive.p2p.download.ResourceDownloader;
	import com.pplive.p2p.kernel.KernelPreDownload;
	import flash.utils.Timer;
	import com.pplive.monitor.Monitor;
	import flash.events.TimerEvent;
	import com.pplive.vod.events.*;
	import flash.utils.getTimer;
	import com.pplive.p2p.events.CDNCheckEvent;
	import com.pplive.p2p.BootStrapConfig;
	import com.pplive.p2p.events.FlvDataEvent;
	import com.pplive.p2p.events.GetSeekTimeEvent;
	import com.pplive.p2p.events.SegmentCompleteEvent;
	import com.pplive.p2p.events.DownloadRequestEvent;
	import com.pplive.p2p.events.DownloadHeaderRequestEvent;
	import com.pplive.p2p.download.HttpFailEvent;
	import flash.events.Event;
	import com.pplive.p2p.P2PServices;
	import com.pplive.p2p.struct.Constants;
	import com.pplive.net.LoadFailedEvent;
	import com.pplive.p2p.struct.RID;
	import de.polygonal.ds.ArrayUtil;
	import flash.utils.Dictionary;
	import com.pplive.p2p.upload.UploadStat;
	import com.pplive.util.StringConvert;
	import flash.net.NetStream;
	import com.pplive.p2p.Util;
	
	public class P2PPlayManager extends PlayManager
	{
		
		protected static var NETSTREAM_BUFFER_LENGTH_BOUND_IN_SECONDS:uint = 60;
		
		protected static var UPLOAD_REPORT_INTERVAL_IN_SECONDS:uint = 10 * 60;
		
		private static var logger:ILogger = getLogger(P2PPlayManager);
		
		private var _mode:int = -1;
		
		private var _playInfo:PlayInfo;
		
		private var _segmentTimeOffsetArray:Array;
		
		private var _dragLoader:DragLoader;
		
		private var _dragHosts:Vector.<String>;
		
		private var _cdnChecker:CDNChecker;
		
		private var _resources:Vector.<ResourceCache>;
		
		private var _flvStream:FlvStreamGenerator;
		
		private var _downloader:ResourceDownloader;
		
		private var _kernelPreDownload:KernelPreDownload;
		
		private var _haveDispatchDetectKernelLogEvent:Boolean = false;
		
		private var _playStartTime:uint;
		
		private var _uploadReportTimer:Timer;
		
		private var _rtmfpStatusReported:Boolean = false;
		
		private var _createLogReported:Boolean = false;
		
		private var _firstBufFullReported:Boolean = false;
		
		public function P2PPlayManager(param1:PlayInfo, param2:NetStream = null)
		{
			var _loc4:uint = 0;
			this._segmentTimeOffsetArray = new Array();
			this._dragHosts = new Vector.<String>();
			this._resources = new Vector.<ResourceCache>();
			this._playStartTime = getTimer();
			this._uploadReportTimer = new Timer(UPLOAD_REPORT_INTERVAL_IN_SECONDS * 1000);
			logger.info("construct,play info:" + "\n" + param1.toString());
			if(!P2PServices.instance)
			{
				logger.info("start p2p services in PlayManager");
				P2PServices.start();
			}
			super(param2);
			Constants.IS_VIP = param1.isVip;
			this._playInfo = param1;
			if(this._playInfo.host.indexOf(":") >= 0)
			{
				this._mode = Constants.PLAY_MODE_DIRECT;
			}
			this._resources.length = this._playInfo.segments.length;
			var _loc3:Number = 0;
			_loc4 = 0;
			while(_loc4 < this._playInfo.segments.length)
			{
				this._segmentTimeOffsetArray.push(_loc3);
				_loc3 = _loc3 + this._playInfo.segments[_loc4].duration;
				_loc4++;
			}
			if(this._playInfo.segments[0].rid == null && (Util.useP2P(this._playInfo.bwType)))
			{
				if(this._playInfo.draghost)
				{
					this._dragHosts.push(this._playInfo.draghost);
					this._dragHosts.push(this._playInfo.draghost);
				}
				else
				{
					this._dragHosts.push("drag.synacast.com");
					this._dragHosts.push("drag.synacast.com");
					this._dragHosts.push("drag.g1d.net");
					this._dragHosts.push("d.150hi.com");
					this._dragHosts.push("drag.synacast.com");
					this._dragHosts.push("drag.g1d.net");
					this._dragHosts.push("d.150hi.com");
				}
				this.createDragLoader(this._dragHosts[0]);
			}
			this._uploadReportTimer.addEventListener(TimerEvent.TIMER,this.onReportUploadDacLog,false,0,true);
			addEventListener(PlayStatusEvent.PLAY_SEEK_NOTIFY,this.seekNotifyListener);
			Monitor.root.addChild(this.monitor);
		}
		
		override public function destroy() : void
		{
			logger.info("destroy");
			Monitor.root.removeChild(this.monitor);
			this._uploadReportTimer.removeEventListener(TimerEvent.TIMER,this.onReportUploadDacLog);
			this._uploadReportTimer.stop();
			this._uploadReportTimer = null;
			removeEventListener(PlayStatusEvent.PLAY_SEEK_NOTIFY,this.seekNotifyListener);
			this.destroyDragLoader();
			this.destroyFlvStreamGenerator();
			this.destroyDownloader();
			this._segmentTimeOffsetArray.length = 0;
			this._segmentTimeOffsetArray = null;
			var _loc1:uint = 0;
			while(_loc1 < this._resources.length)
			{
				if(this._resources[_loc1])
				{
					this._resources[_loc1].stat.droppable = true;
				}
				_loc1++;
			}
			this._resources.length = 0;
			this._resources = null;
			if(this._kernelPreDownload)
			{
				this._kernelPreDownload.destroy();
				this._kernelPreDownload = null;
			}
			super.destroy();
		}
		
		override public function get playInfo() : PlayInfo
		{
			return this._playInfo;
		}
		
		override public function play(param1:Number = 0) : void
		{
			logger.info("play from " + param1 + " seconds.");
			if(param1 > this._playInfo.duration)
			{
				logger.error("invalid starttime: " + param1 + ", change to 0");
				var param1:Number = 0;
			}
			if(param1 < 0.1)
			{
				param1 = 0;
			}
			if(this._flvStream)
			{
				this.seek(param1);
				return;
			}
			this._uploadReportTimer.start();
			this._playStartTime = getTimer();
			super.playResultStartTime = getTimer();
			super.reportPlayResultStauts = PLAY_RESULT_START_BFULL_REPORT;
			this.currentTime = param1;
			this.seekTime = param1;
			_stream.bufferTime = 0;
			_stream.seek(0);
			timer.start();
			this.reportProgressLog("start");
		}
		
		override public function seek(param1:Number) : void
		{
			if(param1 > this._playInfo.duration - 3)
			{
				var param1:Number = this._playInfo.duration - 3;
			}
			else if(param1 < 0.1)
			{
				param1 = 0;
			}
			
			logger.info("seek to " + param1 + "seconds.");
			this.currentTime = time;
			this.seekTime = param1;
			_stream.seek(0);
			_preStreamTime = -1;
			dispatchEvent(new PlayStatusEvent(PlayStatusEvent.BUFFER_EMPTY,false));
			playResultStartTime = getTimer();
			reportPlayResultStauts = PLAY_RESULT_SEEK_BFULL_REPORT;
			_availableDelayTime = 0;
		}
		
		public function getNextSyncTime(param1:Number) : Number
		{
			var _loc2:uint = 0;
			var _loc3:* = NaN;
			if(this._flvStream)
			{
				_loc2 = this._flvStream.segmentIndex;
				if(param1 >= this._segmentTimeOffsetArray[_loc2] && param1 < this._segmentTimeOffsetArray[_loc2] + this._playInfo.segments[_loc2].duration)
				{
					var param1:Number = param1 - this._segmentTimeOffsetArray[_loc2];
					_loc3 = this._flvStream.getRealSeekTime(param1,param1 + 0.2);
					if(_loc3 >= 0)
					{
						return this._segmentTimeOffsetArray[_loc2] + _loc3;
					}
				}
			}
			return -1;
		}
		
		override public function get currentSegment() : int
		{
			return this._flvStream?this._flvStream.segmentIndex:-1;
		}
		
		override protected function getPlayMode() : int
		{
			return this._mode;
		}
		
		override protected function getPlayURL() : String
		{
			return this._playInfo.constructCdnURL(this._flvStream?this._flvStream.segmentIndex:0,this._playInfo.host);
		}
		
		override protected function get downloadSpeed() : uint
		{
			return 0;
		}
		
		override protected function get vipAcceleratedSpeed() : uint
		{
			return 0;
		}
		
		override protected function get hasPendingBytes() : Boolean
		{
			return !(this._flvStream == null);
		}
		
		override public function set isVip(param1:Boolean) : void
		{
			this._playInfo.isVip = param1;
		}
		
		private function startCDNChecker() : void
		{
			if(this._cdnChecker == null)
			{
				this._cdnChecker = new CDNChecker(this._playInfo);
				this._cdnChecker.addEventListener(CDNCheckEvent.FAIL,this.onCDNCheckFail,false,0,true);
				this._cdnChecker.addEventListener(CDNCheckEvent.OK,this.onCDNCheckOK,false,0,true);
				this._cdnChecker.start(BootStrapConfig.CDN_CHECK_TIMEOUT);
			}
		}
		
		private function createFlvStreamGenerator(param1:int) : void
		{
			var _loc2:ResourceCache = null;
			if(this._flvStream == null || !(this._flvStream.segmentIndex == param1))
			{
				this.destroyFlvStreamGenerator();
				_loc2 = this.getResource(param1);
				this._flvStream = new FlvStreamGenerator(_loc2,param1);
				this._flvStream.addEventListener(FlvDataEvent.FLV_DATA,this.onFlvData,false,0,true);
				this._flvStream.addEventListener(GetSeekTimeEvent.GET_SEEK_TIME,this.onGetSeekTime,false,0,true);
				this._flvStream.addEventListener(SegmentCompleteEvent.SEGMENT_COMPLETE,this.onSegmentComplete,false,0,true);
				this._flvStream.addEventListener(DownloadRequestEvent.DOWNLOAD_REQUEST,this.onDownloadRequest,false,0,true);
				this._flvStream.addEventListener(DownloadHeaderRequestEvent.DOWNLOAD_HEADER_REQUEST,this.onDownloadHeaderRequest,false,0,true);
			}
		}
		
		private function destroyFlvStreamGenerator() : void
		{
			if(this._flvStream)
			{
				this._flvStream.removeEventListener(FlvDataEvent.FLV_DATA,this.onFlvData);
				this._flvStream.removeEventListener(GetSeekTimeEvent.GET_SEEK_TIME,this.onGetSeekTime);
				this._flvStream.removeEventListener(SegmentCompleteEvent.SEGMENT_COMPLETE,this.onSegmentComplete);
				this._flvStream.removeEventListener(DownloadRequestEvent.DOWNLOAD_REQUEST,this.onDownloadRequest);
				this._flvStream.removeEventListener(DownloadHeaderRequestEvent.DOWNLOAD_HEADER_REQUEST,this.onDownloadHeaderRequest);
				this._flvStream.destroy();
				this._flvStream = null;
			}
		}
		
		private function createDownloader(param1:uint) : void
		{
			var _loc2:ResourceCache = null;
			if(this._downloader == null || !(this._downloader.segmentIndex == param1))
			{
				this.destroyDownloader();
				_loc2 = this.getResource(param1);
				this._downloader = new ResourceDownloader(_loc2,this._playInfo,param1,this.sessionId,this._mode);
				this._downloader.restPlayTime = this.getRestPlayTime() + _availableDelayTime;
				this._downloader.addEventListener(DacLogEvent.P2P_DAC_LOG,this.onDacLog,false,0,true);
				this._downloader.addEventListener(DacLogEvent.DETECT_KERNEL_LOG,this.onDetectKernelLog,false,0,true);
				this._downloader.addEventListener(HttpFailEvent.HTTP_FAIL_EVENT,this.onHttpError,false,0,true);
				this._downloader.addEventListener(Event.COMPLETE,this.onDownloadComplete,false,0,true);
				this.monitor.addChild(this._downloader.monitor);
			}
		}
		
		private function destroyDownloader() : void
		{
			if(this._downloader)
			{
				this.monitor.removeChild(this._downloader.monitor);
				this._mode = this._downloader.mode;
				this._downloader.destroy();
				this._downloader.removeEventListener(DacLogEvent.P2P_DAC_LOG,this.onDacLog);
				this._downloader.removeEventListener(DacLogEvent.DETECT_KERNEL_LOG,this.onDetectKernelLog);
				this._downloader.removeEventListener(HttpFailEvent.HTTP_FAIL_EVENT,this.onHttpError);
				this._downloader.removeEventListener(Event.COMPLETE,this.onDownloadComplete);
				this._downloader = null;
			}
		}
		
		private function onDownloadHeaderRequest(param1:DownloadHeaderRequestEvent) : void
		{
			if(!this._flvStream.resource.isHeadComplete)
			{
				this.createDownloader(this._flvStream.segmentIndex);
				this._downloader.requestHeader();
			}
		}
		
		private function onDownloadRequest(param1:DownloadRequestEvent) : void
		{
			if(!this._flvStream.resource.isComplete(param1.offset))
			{
				this.createDownloader(this._flvStream.segmentIndex);
				this._downloader.request(param1.offset);
			}
			else
			{
				this.downloadNext();
			}
		}
		
		private function onDownloadComplete(param1:Event) : void
		{
			if(!this._downloader.isRequestHeader)
			{
				this.downloadNext();
			}
		}
		
		private function downloadNext() : void
		{
			var _loc1:uint = 0;
			if(this._flvStream)
			{
				_loc1 = this._flvStream.segmentIndex + 1;
				if(_loc1 < this._playInfo.segments.length && (this._resources[_loc1] == null || !this._resources[_loc1].isComplete(0)))
				{
					this.createDownloader(_loc1);
					this.resetReservedResources();
					this._downloader.request(0);
					return;
				}
			}
			this.destroyDownloader();
		}
		
		private function resetReservedResources() : void
		{
			var _loc2:* = 0;
			var _loc1:int = this._flvStream?this._flvStream.segmentIndex:0;
			var _loc3:uint = 0;
			_loc2 = 0;
			while(_loc2 < this._resources.length)
			{
				if(this._resources[_loc2])
				{
					if((this._resources[_loc2].stat.isPlaying) || (this._resources[_loc2].stat.isDownloading))
					{
						this._resources[_loc2].stat.droppable = false;
						_loc3 = _loc3 + this._resources[_loc2].length;
					}
					else
					{
						this._resources[_loc2].stat.droppable = true;
					}
				}
				_loc2++;
			}
			_loc2 = _loc1;
			while(_loc2 < this._resources.length && _loc3 < BootStrapConfig.CACHE_MEMORY_BOUND_IN_M << 20)
			{
				if((this._resources[_loc2]) && (this._resources[_loc2].stat.droppable) && this._resources[_loc2].fullPercent > 0.5)
				{
					this._resources[_loc2].stat.droppable = false;
					_loc3 = _loc3 + this._resources[_loc2].length;
				}
				_loc2++;
			}
			_loc2 = 0;
			while(_loc2 < this._resources.length)
			{
				if((this._resources[_loc2]) && (this._resources[_loc2].stat.droppable))
				{
					this._resources[_loc2] = null;
				}
				_loc2++;
			}
		}
		
		private function getResource(param1:uint) : ResourceCache
		{
			var _loc3:SegmentInfo = null;
			var _loc2:ResourceCache = this._resources[param1];
			if(_loc2 == null)
			{
				_loc3 = this._playInfo.segments[param1];
				if(_loc3.rid)
				{
					_loc2 = P2PServices.instance.resourceManager.getResource(this._playInfo.segments[param1].rid);
					if(_loc2 == null)
					{
						_loc2 = P2PServices.instance.resourceManager.createResource(_loc3.rid,_loc3.fileLength,_loc3.headLength);
					}
				}
				else
				{
					_loc2 = new ResourceCache(_loc3.fileLength,_loc3.headLength);
				}
				this._resources[param1] = _loc2;
			}
			return _loc2;
		}
		
		private function startKernelPreDownload(param1:uint) : void
		{
			if(!this._kernelPreDownload)
			{
				this._kernelPreDownload = new KernelPreDownload(Constants.LOCAL_KERNEL_TCP_PORT);
			}
			var _loc2:String = this._playInfo.constructKernelUrl(param1,sessionId);
			this._kernelPreDownload.start(_loc2,this.getRestPlayTime());
		}
		
		protected function seekNotifyListener(param1:PlayStatusEvent) : void
		{
			logger.info("do-seek, current-time: " + this.currentTime + ", seek-time: " + this.seekTime);
			var _loc2:uint = this.findSegmentIndexFromTime(currentTime);
			var _loc3:uint = this.findSegmentIndexFromTime(seekTime);
			this.createFlvStreamGenerator(_loc3);
			if(_loc2 != _loc3)
			{
				this._flvStream.seek(this.seekTime - this._segmentTimeOffsetArray[_loc3],this.seekTime - this._segmentTimeOffsetArray[_loc3]);
			}
			else
			{
				this._flvStream.seek(this.currentTime - this._segmentTimeOffsetArray[_loc3],this.seekTime - this._segmentTimeOffsetArray[_loc3]);
			}
			this._flvStream.start();
		}
		
		private function onFlvData(param1:FlvDataEvent) : void
		{
			super.appendBytes(param1.data);
		}
		
		private function onGetSeekTime(param1:GetSeekTimeEvent) : void
		{
			this.seekTime = this._segmentTimeOffsetArray[this._flvStream.segmentIndex] + param1.seekTime;
			logger.info("adjusted seektime: " + seekTime);
		}
		
		private function onSegmentComplete(param1:SegmentCompleteEvent) : void
		{
			if(this._flvStream.segmentIndex + 1 < this._playInfo.segments.length)
			{
				this.createFlvStreamGenerator(this._flvStream.segmentIndex + 1);
				this._flvStream.setBaseTimeStamp(param1.videoTimeStamp,param1.audioTimeStamp);
				this._flvStream.start();
			}
			else
			{
				this.destroyFlvStreamGenerator();
			}
		}
		
		override protected function onTimer(param1:TimerEvent) : void
		{
			var _loc2:uint = 0;
			if((BootStrapConfig.IS_UPDATED) && (BootStrapConfig.ENABLE_CDN_CHECKER) && this._cdnChecker == null)
			{
				this.startCDNChecker();
			}
			if(this._downloader)
			{
				_loc2 = this.getRestPlayTime();
				this._downloader.restPlayTime = _stream.bufferLength >= _stream.bufferTime + 2?_loc2 + _availableDelayTime:_loc2;
			}
			if((video) && (this._flvStream))
			{
				if(_stream.bufferLength < NETSTREAM_BUFFER_LENGTH_BOUND_IN_SECONDS)
				{
					this._flvStream.start();
				}
				else if(_stream.bufferLength > 2 * NETSTREAM_BUFFER_LENGTH_BOUND_IN_SECONDS)
				{
					this._flvStream.stop();
				}
				
			}
			if(!this._createLogReported)
			{
				this.reportProgressLog("create");
				this._createLogReported = true;
			}
			if(!this._firstBufFullReported && _stream.bufferLength >= _stream.bufferTime)
			{
				this._firstBufFullReported = true;
				this.reportProgressLog("first-buf-full");
			}
			super.onTimer(param1);
		}
		
		override protected function getRestPlayTime() : Number
		{
			var _loc2:uint = 0;
			if(this._flvStream == null)
			{
				return _stream.bufferLength;
			}
			var _loc1:Number = _stream.bufferLength + this.estimateSegmentRestPlayTime(this._flvStream.resource,this._playInfo.segments[this._flvStream.segmentIndex].duration,this._flvStream.currentSendPosition);
			if(this._flvStream.resource.isComplete(this._flvStream.currentSendPosition))
			{
				_loc2 = this._flvStream.segmentIndex + 1;
				while((_loc2 < this._resources.length) && (this._resources[_loc2]) && (this._resources[_loc2].isComplete()))
				{
					_loc1 = _loc1 + this._playInfo.segments[_loc2].duration;
					_loc2++;
				}
				if(_loc2 < this._resources.length && (this._resources[_loc2]))
				{
					_loc1 = _loc1 + this.estimateSegmentRestPlayTime(this._resources[_loc2],this._playInfo.segments[_loc2].duration,0);
				}
			}
			return _loc1;
		}
		
		private function estimateSegmentRestPlayTime(param1:ResourceCache, param2:Number, param3:uint) : Number
		{
			return (param1.getFirstSubPieceMissed(param3).offset - param3) / param1.length * param2;
		}
		
		private function createDragLoader(param1:String) : void
		{
			this._dragLoader = new DragLoader(this._playInfo.fileName,param1);
			this._dragLoader.addEventListener(Event.COMPLETE,this.onDragLoaded,false,0,true);
			this._dragLoader.addEventListener(LoadFailedEvent.LOAD_FAILED,this.onDragLoadFailed,false,0,true);
			this._dragLoader.load();
		}
		
		private function destroyDragLoader() : void
		{
			if(this._dragLoader)
			{
				this._dragLoader.removeEventListener(Event.COMPLETE,this.onDragLoaded);
				this._dragLoader.removeEventListener(LoadFailedEvent.LOAD_FAILED,this.onDragLoadFailed);
				this._dragLoader.destroy();
				this._dragLoader = null;
			}
		}
		
		protected function onDragLoaded(param1:Event) : void
		{
			var _loc2:uint = 0;
			var _loc3:uint = 0;
			if(this._dragLoader.segments.length == this._playInfo.segments.length)
			{
				_loc2 = 0;
				_loc3 = this._playInfo.segments.length;
				while(_loc2 < _loc3)
				{
					if(this._dragLoader.segments[_loc2].rid)
					{
						this._playInfo.segments[_loc2].rid = this._dragLoader.segments[_loc2].rid;
						if(this._resources[_loc2] != null)
						{
							P2PServices.instance.resourceManager.addResource(this._playInfo.segments[_loc2].rid,this._resources[_loc2]);
						}
					}
					else
					{
						logger.error("invalid drag: " + _loc2 + ": " + this._dragLoader.segments[_loc2]);
					}
					_loc2++;
				}
				if(this._downloader)
				{
					this._downloader.rid = new RID(this._playInfo.segments[this._downloader.segmentIndex].rid);
				}
				P2PServices.instance.p2p.doReport();
			}
			else
			{
				logger.error("invalid drag: " + this._dragLoader.segments);
			}
			this.reportDragLoadResult(true,this._dragLoader.requestDuration);
			this.destroyDragLoader();
		}
		
		private function onCDNCheckFail(param1:CDNCheckEvent) : void
		{
			logger.error("CDN check fail");
			this.reportProgressLog("cdncheck",{"error":this._cdnChecker.error});
			var _loc2:* = 5;
			dispatchEvent(new PlayResultEvent(_loc2,this._playInfo.constructCdnURL(0),5 * 1000,0,param1.error));
		}
		
		private function onCDNCheckOK(param1:CDNCheckEvent) : void
		{
			this.reportProgressLog("cdncheck",{"error":0});
		}
		
		private function onDragLoadFailed(param1:Event) : void
		{
			this.destroyDragLoader();
			this._dragHosts.shift();
			if(this._dragHosts.length > 0)
			{
				this.createDragLoader(this._dragHosts[0]);
			}
			else
			{
				this.reportDragLoadResult(false,0);
			}
		}
		
		private function constructKernelUrl(param1:uint) : String
		{
			return this._playInfo.constructKernelUrl(param1,sessionId);
		}
		
		protected function findSegmentIndexFromTime(param1:uint) : uint
		{
			var _loc2:int = ArrayUtil.bsearchFloat(this._segmentTimeOffsetArray,param1,0,this._segmentTimeOffsetArray.length - 1);
			if(_loc2 < 0)
			{
				return ~_loc2 - 1;
			}
			return _loc2;
		}
		
		override public function updateMonitedAttributes(param1:Dictionary) : void
		{
			param1["segCnt"] = this._playInfo.segments.length;
			param1["playIdx"] = this._flvStream?this._flvStream.segmentIndex:-1;
			param1["downloadIdx"] = this._downloader?this._downloader.segmentIndex:-1;
			param1["restPlayTime"] = uint(this.getRestPlayTime());
			param1["playurl"] = this._flvStream?this._playInfo.constructCdnURL(this._flvStream.segmentIndex):"";
			param1["dropped-frames"] = droppedFrame;
		}
		
		private function onReportUploadDacLog(param1:Event) : void
		{
			var _loc2:UploadStat = P2PServices.instance.uploader.stat;
			var _loc3:Object = new Object();
			_loc3.dt = "upload";
			_loc3.av = _loc2.averageSpeedUponActiveInKBPS;
			_loc3.mv = _loc2.maxAvgSpeedInK;
			_loc3.ut = _loc2.uploadTimeInMS;
			_loc3.uz = _loc2.uploadAmountInK;
			_loc3.cv = Version.version;
			P2PServices.instance.uploader.resetStat();
			dispatchEvent(new DacLogEvent(_loc3,DacLogEvent.P2P_DAC_LOG));
		}
		
		private function reportRtmfpStatus() : void
		{
			var _loc1:Object = null;
			if(P2PServices.instance.stat.rtmfpStartComplete)
			{
				_loc1 = new Object();
				_loc1.dt = "rtmfp";
				_loc1.cv = Version.version;
				_loc1.ct = P2PServices.instance.stat.rtmfpConnectTime;
				_loc1.ok = P2PServices.instance.rtmfp.isStarted;
				dispatchEvent(new DacLogEvent(_loc1,DacLogEvent.P2P_DAC_LOG));
			}
		}
		
		private function onDacLog(param1:DacLogEvent) : void
		{
			param1.logObject.cv = Version.version;
			dispatchEvent(new DacLogEvent(param1.logObject));
		}
		
		private function onDetectKernelLog(param1:DacLogEvent) : void
		{
			this._mode = Constants.PLAY_MODE_KERNEL;
			if(!this._haveDispatchDetectKernelLogEvent)
			{
				this._haveDispatchDetectKernelLogEvent = true;
				param1.logObject.n = StringConvert.urldecodeGB2312(this._playInfo.fileName);
				dispatchEvent(new DacLogEvent(param1.logObject,DacLogEvent.DETECT_KERNEL_LOG));
			}
		}
		
		private function onHttpError(param1:HttpFailEvent) : void
		{
			var _loc2:* = 0;
			logger.error("onHttpError: " + param1.error + ", interval: " + param1.interval + ", http-status: " + param1.httpStatus + ", received-data: " + param1.hasReceivedData + ", url: " + param1.url);
			if(param1.hasReceivedData)
			{
				dispatchEvent(new PlayStatusEvent(PlayStatusEvent.PLAY_FAILED,{
					"error:":param1.error + 10000,
					"interval":param1.interval,
					"httpStatus":param1.httpStatus
				}));
			}
			else
			{
				_loc2 = 5;
				dispatchEvent(new PlayResultEvent(_loc2,param1.url,param1.interval,param1.error,param1.httpStatus));
			}
		}
		
		override protected function getPlayResult() : uint
		{
			var _loc1:uint = 0;
			if(Constants.PLAY_MODE_KERNEL == this._mode)
			{
				if(reportPlayResultStauts == PLAY_RESULT_SEEK_BFULL_REPORT)
				{
					_loc1 = 8;
				}
				else
				{
					_loc1 = 6;
				}
			}
			else if(reportPlayResultStauts == PLAY_RESULT_SEEK_BFULL_REPORT)
			{
				_loc1 = 9;
			}
			else
			{
				_loc1 = 7;
			}
			
			if((this._downloader) && this._downloader.httpFailTimes > 0)
			{
				_loc1 = _loc1 + 4;
			}
			return _loc1;
		}
		
		private function reportDragLoadResult(param1:Boolean, param2:uint) : void
		{
			var _loc3:Dictionary = new Dictionary();
			_loc3["ok"] = param1?1:0;
			_loc3["timeused"] = param1?param2:0;
			this.reportProgressLog("dragload",_loc3);
		}
		
		private function reportProgressLog(param1:String, param2:Object = null) : void
		{
			var _loc4:* = undefined;
			var _loc3:Object = new Object();
			_loc3.dt = "stop";
			_loc3.progress = param1;
			_loc3.file = this._playInfo.fileName;
			_loc3.variables = this._playInfo.variables;
			_loc3.cv = Version.version;
			if(param2)
			{
				for(_loc4 in param2)
				{
					_loc3[_loc4 as String] = param2[_loc4];
				}
			}
			dispatchEvent(new DacLogEvent(_loc3));
		}
	}
}
