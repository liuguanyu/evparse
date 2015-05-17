package com.pplive.p2p.download
{
	import com.pplive.monitor.Monitable;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import com.pplive.p2p.struct.RID;
	import com.pplive.p2p.ResourceCache;
	import com.pplive.play.PlayInfo;
	import com.pplive.p2p.struct.Constants;
	import com.pplive.p2p.Util;
	import flash.utils.getTimer;
	import flash.events.Event;
	import com.pplive.p2p.events.ReceiveSubpieceEvent;
	import com.pplive.vod.events.DacLogEvent;
	import com.pplive.p2p.P2PServices;
	import com.pplive.p2p.kernel.*;
	import com.pplive.p2p.BootStrapConfig;
	import com.pplive.mx.ObjectUtil;
	import flash.utils.Dictionary;
	
	public class ResourceDownloader extends Monitable implements KernelDetectorListener
	{
		
		private static var logger:ILogger = getLogger(ResourceDownloader);
		
		public static const MAX_KERNEL_FAIL_TIME:uint = 3;
		
		private var _rid:RID;
		
		private var _resource:ResourceCache;
		
		private var _playInfo:PlayInfo;
		
		private var _segmentIndex:uint;
		
		private var _sessionId:String;
		
		private var _drmInfoLoader:DRMInfoLoader;
		
		private var _mode:int = -1;
		
		private var _kernelDetecter:KernelDectecter;
		
		private var _kernelDownloader:KernelDownloader;
		
		private var _cdnDownloader:CDNHttpDownloader;
		
		private var _p2pDownloader:P2PDownloader;
		
		private var _kernelStatusReporter:KernelStatusReporter;
		
		private var _dispatcher:Dispatcher;
		
		private var _state:uint = 0;
		
		private var _startTime:uint;
		
		private var _requestHeader:Boolean;
		
		private var _offset:int = -1;
		
		private var _restPlayTime:Number = 0;
		
		private var _httpErrorCode:uint = 0;
		
		private var _stat:Stat;
		
		public function ResourceDownloader(param1:ResourceCache, param2:PlayInfo, param3:uint, param4:String, param5:int)
		{
			this._stat = new Stat();
			super("ResourceDownloader");
			this._resource = param1;
			this._playInfo = param2;
			this._segmentIndex = param3;
			this._sessionId = param4;
			this._mode = param5;
			this._kernelDownloader = new KernelDownloader(Constants.KERNEL_HOST,Constants.KERNEL_MAGIC_PORT,param2,param3,param4);
			this._kernelDownloader.maxFailTimesPerHost = MAX_KERNEL_FAIL_TIME;
			this._kernelDownloader.addEventListener(ReceiveSubpieceEvent.RECEIVE_SUBPIECE,this.onReceiveSubpiece,false,0,true);
			this._kernelDownloader.addEventListener(HttpFailEvent.HTTP_FAIL_EVENT,this.onHttpError,false,0,true);
			this._cdnDownloader = new CDNHttpDownloader(param2,param3);
			this._cdnDownloader.addEventListener(ReceiveSubpieceEvent.RECEIVE_SUBPIECE,this.onReceiveSubpiece,false,0,true);
			this._cdnDownloader.addEventListener(HttpFailEvent.HTTP_FAIL_EVENT,this.onHttpError,false,0,true);
			var _loc6:String = this._playInfo.segments[this._segmentIndex].rid;
			if(_loc6)
			{
				this._rid = new RID(_loc6);
				this._kernelDownloader.rid = this._rid;
				if(Util.useP2P(this._playInfo.bwType))
				{
					this.createP2PDownloader();
				}
			}
			this._resource.stat.isDownloading = true;
		}
		
		public function get mode() : int
		{
			return this._mode;
		}
		
		public function get httpFailTimes() : uint
		{
			return this._mode == Constants.PLAY_MODE_KERNEL?this._kernelDownloader.failTimes:this._cdnDownloader.failTimes;
		}
		
		public function set restPlayTime(param1:Number) : void
		{
			this._restPlayTime = param1;
			if(this._dispatcher)
			{
				this._dispatcher.restPlayTime = param1;
			}
			if(this._kernelStatusReporter)
			{
				this._kernelStatusReporter.restPlayTime = param1;
			}
		}
		
		public function get isRequestHeader() : Boolean
		{
			return this._requestHeader;
		}
		
		public function get segmentIndex() : uint
		{
			return this._segmentIndex;
		}
		
		public function get resource() : ResourceCache
		{
			return this._resource;
		}
		
		public function get stat() : Stat
		{
			return this._stat;
		}
		
		public function requestHeader() : void
		{
			this._requestHeader = true;
			this._offset = -1;
			if(this._state == State.LATENT)
			{
				this.start();
			}
			else if(this._state == State.STARTED && (this._dispatcher))
			{
				this._dispatcher.requestHeader();
			}
			
		}
		
		public function request(param1:uint) : void
		{
			this._requestHeader = false;
			this._offset = param1;
			if(this._state == State.LATENT)
			{
				this.start();
			}
			else if(this._state == State.STARTED && (this._dispatcher))
			{
				this._dispatcher.request(param1);
			}
			
		}
		
		public function set rid(param1:RID) : void
		{
			if(!(this._state == State.STOPPED) && this._rid == null)
			{
				this._rid = param1;
				if(this._dispatcher is KernelHttpDispatcher)
				{
					this.createKernelStatusReporter();
				}
				if(Util.useP2P(this._playInfo.bwType))
				{
					this.createP2PDownloader();
					if(this._dispatcher is HttpP2PDispatcher)
					{
						this._p2pDownloader.start();
						(this._dispatcher as HttpP2PDispatcher).p2pDownloader = this._p2pDownloader;
					}
				}
			}
		}
		
		public function start() : void
		{
			if(this._state != State.LATENT)
			{
				return;
			}
			this._state = State.STARTED;
			this._startTime = getTimer();
			if(!this._resource.isDrmSetup)
			{
				this._drmInfoLoader = new DRMInfoLoader(this._playInfo,this._segmentIndex);
				this._drmInfoLoader.addEventListener(Event.COMPLETE,this.onDrmLoaded,false,0,true);
				this._drmInfoLoader.start();
			}
			if(this._mode == Constants.PLAY_MODE_UNKNOWN)
			{
				this._kernelDetecter = new KernelDectecter(this);
			}
			else
			{
				this.createDispatcher();
			}
		}
		
		public function destroy() : void
		{
			this._resource.stat.isDownloading = false;
			if(this._state == State.STOPPED)
			{
				return;
			}
			this.sendStopLog();
			this._state = State.STOPPED;
			if(this._drmInfoLoader)
			{
				this._drmInfoLoader.removeEventListener(Event.COMPLETE,this.onDrmLoaded);
				this._drmInfoLoader.close();
			}
			this._kernelDownloader.removeEventListener(ReceiveSubpieceEvent.RECEIVE_SUBPIECE,this.onReceiveSubpiece);
			this._kernelDownloader.removeEventListener(HttpFailEvent.HTTP_FAIL_EVENT,this.onHttpError);
			this._kernelDownloader.destroy();
			this._cdnDownloader.removeEventListener(ReceiveSubpieceEvent.RECEIVE_SUBPIECE,this.onReceiveSubpiece);
			this._cdnDownloader.removeEventListener(HttpFailEvent.HTTP_FAIL_EVENT,this.onHttpError);
			this._cdnDownloader.destroy();
			if(this._p2pDownloader != null)
			{
				monitor.removeChild(this._p2pDownloader.monitor);
				this._p2pDownloader.removeEventListener(ReceiveSubpieceEvent.RECEIVE_SUBPIECE,this.onReceiveSubpiece);
				this._p2pDownloader.destroy();
			}
			if(this._kernelStatusReporter)
			{
				this._kernelStatusReporter.close();
				this._kernelStatusReporter = null;
			}
			if(this._dispatcher)
			{
				this._dispatcher.removeEventListener(Event.COMPLETE,this.onComplete);
				this._dispatcher.stop();
			}
			if(this._kernelDetecter)
			{
				this._kernelDetecter.destory();
				this._kernelDetecter = null;
			}
		}
		
		public function reportKernelStatus(param1:Boolean, param2:int, param3:KernelDescription = null) : void
		{
			this._kernelDetecter.destory();
			this._kernelDetecter = null;
			logger.info("reportKernelStatus exist: " + param1 + ", detectTime: " + param2);
			if(param1)
			{
				logger.info("kernel info: " + param3);
			}
			if(this._state == State.STOPPED)
			{
				return;
			}
			if((param1) && param3.extraVersion >= 1812)
			{
				this._mode = Constants.PLAY_MODE_KERNEL;
				Constants.LOCAL_KERNEL_TCP_PORT = param3.tcpPort;
				dispatchEvent(new DacLogEvent({
					"dt":"vst",
					"ctx":null,
					"vst":param2
				},DacLogEvent.DETECT_KERNEL_LOG));
			}
			else
			{
				this._mode = Constants.PLAY_MODE_DIRECT;
			}
			this.createDispatcher();
		}
		
		private function createDispatcher() : void
		{
			if(this._mode == Constants.PLAY_MODE_KERNEL)
			{
				this._kernelDownloader.start();
				this._dispatcher = new KernelHttpDispatcher(this._resource,this._kernelDownloader);
				this.createKernelStatusReporter();
			}
			else
			{
				this._cdnDownloader.start();
				if(Util.useP2P(this._playInfo.bwType))
				{
					this._dispatcher = new HttpP2PDispatcher(this._resource,this._cdnDownloader,this._playInfo.bwType);
					if(this._p2pDownloader)
					{
						this._p2pDownloader.start();
						(this._dispatcher as HttpP2PDispatcher).p2pDownloader = this._p2pDownloader;
					}
				}
				else
				{
					this._dispatcher = new HttpDispatcher(this._resource,this._cdnDownloader);
				}
			}
			this._dispatcher.addEventListener(Event.COMPLETE,this.onComplete,false,0,true);
			this._dispatcher.restPlayTime = this._restPlayTime;
			if(this._requestHeader)
			{
				this._dispatcher.requestHeader();
			}
			else if(this._offset >= 0)
			{
				this._dispatcher.request(this._offset);
			}
			
		}
		
		private function createKernelStatusReporter() : void
		{
			if((this._rid) && this._kernelStatusReporter == null)
			{
				this._kernelStatusReporter = new KernelStatusReporter(Constants.LOCAL_KERNEL_TCP_PORT,this._rid,this._playInfo.isVip);
				this._kernelStatusReporter.restPlayTime = this._restPlayTime;
				try
				{
					this._kernelStatusReporter.start();
				}
				catch(e:*)
				{
					_kernelStatusReporter.close();
					_kernelStatusReporter = null;
				}
			}
		}
		
		private function createP2PDownloader() : void
		{
			this._p2pDownloader = new P2PDownloader(this._rid,this._resource.length,this._resource.headLength);
			this._p2pDownloader.addEventListener(ReceiveSubpieceEvent.RECEIVE_SUBPIECE,this.onReceiveSubpiece,false,0,true);
			monitor.addChild(this._p2pDownloader.monitor);
		}
		
		private function onDrmLoaded(param1:Event) : void
		{
			this._resource.drmDecoder = this._drmInfoLoader.drmDecoder;
		}
		
		private function onReceiveSubpiece(param1:ReceiveSubpieceEvent) : void
		{
			this._stat.speedMeter.submitBytes(param1.data.length);
			if(param1.target == this._p2pDownloader)
			{
				this._stat.p2pSpeedMeter.submitBytes(param1.data.length);
			}
			else
			{
				this._stat.httpSpeedMeter.submitBytes(param1.data.length);
			}
			if(!this._resource.hasSubPiece(param1.subpiece))
			{
				this._resource.addSubPiece(param1.subpiece,param1.data);
			}
			else
			{
				this._stat.redundantDownloadBytes = this._stat.redundantDownloadBytes + param1.data.length;
				if(param1.target == this._p2pDownloader)
				{
					this._stat.p2pRedundantDownloadBytes = this._stat.p2pRedundantDownloadBytes + param1.data.length;
				}
			}
		}
		
		private function onComplete(param1:Event) : void
		{
			if(!this.isRequestHeader)
			{
				P2PServices.instance.p2p.doReport();
			}
			dispatchEvent(param1);
		}
		
		private function onHttpError(param1:HttpFailEvent) : void
		{
			if(this._state != State.STARTED)
			{
				return;
			}
			if(param1.target == this._kernelDownloader)
			{
				logger.error("kernel error: " + param1);
				this._dispatcher.removeEventListener(Event.COMPLETE,this.onComplete);
				this._dispatcher.stop();
				this._kernelDownloader.removeEventListener(ReceiveSubpieceEvent.RECEIVE_SUBPIECE,this.onReceiveSubpiece);
				this._kernelDownloader.removeEventListener(HttpFailEvent.HTTP_FAIL_EVENT,this.onHttpError);
				this._kernelDownloader.destroy();
				this._mode = Constants.PLAY_MODE_DIRECT;
				this.createDispatcher();
			}
			else
			{
				this._httpErrorCode = param1.error;
				this.destroy();
				dispatchEvent(param1);
			}
		}
		
		public function sendStopLog() : void
		{
			var _loc2:P2PDownloader = null;
			var _loc1:Object = new Object();
			_loc1.dt = "stop";
			_loc1.rid = this._rid?this._rid.toString():"";
			_loc1.url = this._playInfo.constructCdnURL(this._segmentIndex,this._playInfo.host);
			_loc1.sz = this._resource.length;
			_loc1.du = this._playInfo.segments[this._segmentIndex].duration;
			_loc1.bwt = this._playInfo.bwType;
			_loc1.usep2p = BootStrapConfig.DOWNLOAD_P2P_ENABLED?1:0;
			_loc1.rtmfpS = P2PServices.instance.rtmfp.isStarted?1:0;
			_loc1.rtmfpP = P2PServices.instance.rtmfpListener.isStarted?1:0;
			_loc1.pz = this._stat.p2pSpeedMeter.totalBytes;
			_loc1.hz = this._stat.httpSpeedMeter.totalBytes;
			_loc1.av = this._stat.speedMeter.getTotalAvarageSpeedInKBPS();
			_loc1.hv = this._stat.httpSpeedMeter.getTotalAvarageSpeedInKBPS();
			_loc1.dwt = getTimer() - this._startTime;
			_loc1.red = this._stat.redundantDownloadBytes;
			_loc1.p2pred = this._stat.p2pRedundantDownloadBytes;
			_loc1.km = this._dispatcher is KernelHttpDispatcher?1:0;
			if(this._p2pDownloader)
			{
				_loc2 = this._p2pDownloader;
				_loc1.pv = _loc2.stat.avgSpeedInK;
				_loc1.pc = _loc2.connectionCount;
				_loc1.qc = _loc2.connectStat.queriedPeersCount;
				_loc1.ct = _loc2.connectionFullTime;
				_loc1.tca = _loc2.connectStat.tcpConnectCount;
				_loc1.tcs = _loc2.connectStat.tcpSuccessCount;
				_loc1.tz = _loc2.stat.tcpDownloadedBytes;
				_loc1.rca = _loc2.connectStat.rtmfpConnectCount;
				_loc1.rcs = _loc2.connectStat.rtmfpSuccessCount;
				_loc1.rz = _loc2.stat.rtmfpDownloadedBytes;
				_loc1.tks = _loc2.connectStat.listCount;
			}
			else
			{
				_loc1.pv = 0;
				_loc1.pc = 0;
				_loc1.qc = 0;
				_loc1.ct = 0;
				_loc1.p2pdwt = 0;
				_loc1.tca = 0;
				_loc1.tcs = 0;
				_loc1.tct = 0;
				_loc1.tz = 0;
				_loc1.rca = 0;
				_loc1.rcs = 0;
				_loc1.rct = 0;
				_loc1.rz = 0;
				_loc1.tks = 0;
				_loc1.tkf = 0;
			}
			_loc1.ec = this._httpErrorCode;
			this._httpErrorCode = 0;
			logger.info("sendStopLog:" + ObjectUtil.toString(_loc1));
			dispatchEvent(new DacLogEvent(_loc1));
		}
		
		override public function updateMonitedAttributes(param1:Dictionary) : void
		{
			param1["mode"] = this._dispatcher is KernelHttpDispatcher?"kernel":"normal";
			param1["bwtype"] = this._playInfo.bwType;
			param1["http-bytes"] = this._stat.httpSpeedMeter.totalBytes;
			param1["p2p-bytes"] = this._stat.p2pSpeedMeter.totalBytes;
			var _loc2:Number = this._stat.redundantDownloadBytes / (this._stat.httpSpeedMeter.totalBytes + this._stat.p2pSpeedMeter.totalBytes - this._stat.redundantDownloadBytes);
			param1["redundant-ratio"] = uint(_loc2 * 100000) / 100000;
			param1["speed"] = this._stat.speedMeter.getRecentSpeedInKBPS();
			param1["http-speed"] = this._stat.httpSpeedMeter.getRecentSpeedInKBPS();
			param1["p2p-connection-count"] = this._p2pDownloader?this._p2pDownloader.tcpCount + "|" + this._p2pDownloader.rtmfpCount:"";
			param1["p2p-speed"] = this._stat.p2pSpeedMeter.getRecentSpeedInKBPS();
			param1["p2p-connect-time"] = this._p2pDownloader?this._p2pDownloader.connectionFullTime:"";
			param1["current-method"] = this._dispatcher?this._dispatcher.currentMethod:"IDLE";
		}
	}
}

class State extends Object
{
	
	public static const LATENT:uint = 0;
	
	public static const STARTED:uint = 1;
	
	public static const STOPPED:uint = 2;
	
	function State()
	{
		super();
	}
}

import com.pplive.p2p.SpeedMeter;

class Stat extends Object
{
	
	public var speedMeter:SpeedMeter;
	
	public var httpSpeedMeter:SpeedMeter;
	
	public var p2pSpeedMeter:SpeedMeter;
	
	public var redundantDownloadBytes:uint;
	
	public var p2pRedundantDownloadBytes:uint;
	
	function Stat()
	{
		this.speedMeter = new SpeedMeter();
		this.httpSpeedMeter = new SpeedMeter();
		this.p2pSpeedMeter = new SpeedMeter();
		super();
		this.speedMeter.resume();
		this.httpSpeedMeter.resume();
		this.p2pSpeedMeter.resume();
	}
	
	public function destroy() : void
	{
		this.speedMeter.destory();
		this.httpSpeedMeter.destory();
		this.p2pSpeedMeter.destory();
	}
}
