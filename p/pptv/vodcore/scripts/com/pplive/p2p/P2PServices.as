package com.pplive.p2p
{
	import flash.events.EventDispatcher;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import com.pplive.net.RtmfpModule;
	import com.pplive.net.RtmfpListener;
	import com.pplive.p2p.connection.ConnectionCache;
	import com.pplive.p2p.upload.UploadDriver;
	import com.pplive.monitor.MonitInfoReporter;
	import flash.utils.Timer;
	import com.pplive.p2p.connection.PeerConnection;
	import com.pplive.events.RtmfpEvent;
	import flash.utils.getTimer;
	import flash.net.NetStream;
	import com.pplive.p2p.events.SimpleEvent;
	import flash.events.TimerEvent;
	import com.pplive.monitor.Monitor;
	
	public class P2PServices extends EventDispatcher
	{
		
		private static var logger:ILogger = getLogger(P2PServices);
		
		private static var _instance:P2PServices;
		
		private var _bs:BootStrapModule;
		
		private var _p2pModule:P2PModule;
		
		private var _rtmfp:RtmfpModule;
		
		private var _rtmfpListener:RtmfpListener;
		
		private var _resetedRtmfpPeers:Vector.<String>;
		
		private var _connectionCache:ConnectionCache;
		
		private var _resourceManager:CacheManager;
		
		private var _uploader:UploadDriver;
		
		private var _monitInfoReporter:MonitInfoReporter;
		
		private var _timer:Timer;
		
		private var _stat:Stat;
		
		public function P2PServices(param1:SingleEnforcer)
		{
			this._bs = new BootStrapModule();
			this._p2pModule = new P2PModule();
			this._rtmfp = new RtmfpModule();
			this._rtmfpListener = this._rtmfp.createListener();
			this._resetedRtmfpPeers = new Vector.<String>();
			this._connectionCache = new ConnectionCache();
			this._resourceManager = new CacheManager(BootStrapConfig.CACHE_MEMORY_BOUND_IN_M << 20);
			this._uploader = new UploadDriver();
			this._monitInfoReporter = new MonitInfoReporter();
			this._timer = new Timer(250);
			this._stat = new Stat();
			super();
			if(param1 == null)
			{
				throw new Error("P2PServices is singleton");
			}
			else
			{
				Monitor.root.setAttr("app","vod2");
				Monitor.root.setAttr("guid",this._p2pModule.guid);
				Monitor.root.addChild(this._rtmfp.monitor);
				Monitor.root.addChild(this._resourceManager.monitor);
				Monitor.root.addChild(this._uploader.monitor);
				Monitor.root.addChild(this._connectionCache.monitor);
				this._bs.addEventListener(SimpleEvent.BS_CONFIG_SUCCESS,this.onBSLoadComplete,false,0,true);
				this._bs.addEventListener(SimpleEvent.BS_CONFIG_FAIL,this.onBSLoadComplete,false,0,true);
				return;
			}
		}
		
		public static function start() : void
		{
			if(_instance == null)
			{
				_instance = new P2PServices(new SingleEnforcer());
				_instance._connectionCache.start();
				_instance._monitInfoReporter.start();
				_instance._bs.start();
			}
		}
		
		public static function get instance() : P2PServices
		{
			return _instance;
		}
		
		public function get p2p() : P2PModule
		{
			return this._p2pModule;
		}
		
		public function get rtmfp() : RtmfpModule
		{
			return this._rtmfp;
		}
		
		public function get rtmfpListener() : RtmfpListener
		{
			return this._rtmfpListener;
		}
		
		public function get resetedRtmfpPeers() : Vector.<String>
		{
			return this._resetedRtmfpPeers;
		}
		
		public function get connectionCache() : ConnectionCache
		{
			return this._connectionCache;
		}
		
		public function get resourceManager() : CacheManager
		{
			return this._resourceManager;
		}
		
		public function get uploader() : UploadDriver
		{
			return this._uploader;
		}
		
		public function get stat() : Stat
		{
			return this._stat;
		}
		
		public function reStartRTMFP() : void
		{
			var _loc1:PeerConnection = null;
			for each(_loc1 in this._connectionCache.connections)
			{
				if(_loc1.isRTMFP)
				{
					this._resetedRtmfpPeers.push(_loc1.peer.id);
				}
			}
			this.stopRtmfpListener();
			this.stopRTMFP();
			this.startRTMFP();
		}
		
		private function startRTMFP() : void
		{
			this._rtmfp.addEventListener(RtmfpEvent.RTMFP_START_SUCCESS,this.onRtmfpStarted,false,0,true);
			this._rtmfp.addEventListener(RtmfpEvent.RTMFP_START_FAIL,this.onFailToStartRtmfp,false,0,true);
			this._rtmfp.addEventListener(RtmfpEvent.RTMFP_STOP,this.onRtmfpStop,false,0,true);
			this._stat.rtmfpConnectStartTime = getTimer();
			this._rtmfp.start(BootStrapConfig.RTMFP_P2P_SERVER + "/" + BootStrapConfig.RTMFP_P2P_SERVER_KEY,BootStrapConfig.RTMFP_STARTUP_TIMEOUT * 1000,15);
		}
		
		private function stopRTMFP() : void
		{
			this._rtmfp.removeEventListener(RtmfpEvent.RTMFP_START_SUCCESS,this.onRtmfpStarted);
			this._rtmfp.removeEventListener(RtmfpEvent.RTMFP_START_FAIL,this.onFailToStartRtmfp);
			this._rtmfp.removeEventListener(RtmfpEvent.RTMFP_STOP,this.onRtmfpStop);
			this._rtmfp.stop();
		}
		
		private function startRtmfpListener() : void
		{
			this._rtmfpListener.peerValidator = function(param1:NetStream):Boolean
			{
				return true;
			};
			this._rtmfpListener.addEventListener(RtmfpEvent.RTMFP_LISTENER_START_SUCCESS,this.onRtmfpListenerStarted,false,0,true);
			this._rtmfpListener.addEventListener(RtmfpEvent.RTMFP_LISTENER_START_FAIL,this.onFailToStartRtmfpListener,false,0,true);
			this._rtmfpListener.start(BootStrapConfig.RTMFP_MEDIA);
		}
		
		private function stopRtmfpListener() : void
		{
			this._rtmfpListener.removeEventListener(RtmfpEvent.RTMFP_LISTENER_START_SUCCESS,this.onRtmfpListenerStarted);
			this._rtmfpListener.removeEventListener(RtmfpEvent.RTMFP_LISTENER_START_FAIL,this.onFailToStartRtmfpListener);
			this._rtmfpListener.stop();
		}
		
		private function onRtmfpStarted(param1:RtmfpEvent) : void
		{
			logger.info("rtmfp started");
			this._stat.rtmfpConnectTime = getTimer() - this._stat.rtmfpConnectStartTime;
			this._stat.rtmfpStartComplete = true;
			this._rtmfp.maxPeerConnections = BootStrapConfig.RTMFP_MAX_CONNECTION_COUNT;
			if(!this._uploader.isRunning)
			{
				this._uploader.start();
			}
			dispatchEvent(param1);
			this.startRtmfpListener();
		}
		
		private function onFailToStartRtmfp(param1:RtmfpEvent) : void
		{
			logger.error("fail to start rtmfp");
			this._stat.rtmfpStartComplete = true;
			dispatchEvent(param1);
		}
		
		private function onRtmfpStop(param1:RtmfpEvent) : void
		{
			logger.warn("rtmfp stopped");
			this._stat.rtmfpStopCount++;
			dispatchEvent(param1);
			this.reStartRTMFP();
		}
		
		private function onRtmfpListenerStarted(param1:RtmfpEvent) : void
		{
			logger.info("rtmfp listener started");
			this._p2pModule.enableReport(BootStrapConfig.TRACKERS);
		}
		
		private function onFailToStartRtmfpListener(param1:RtmfpEvent) : void
		{
			logger.error("fail to start rtmfp listener");
		}
		
		private function onBSLoadComplete(param1:SimpleEvent) : void
		{
			if(param1.type == SimpleEvent.BS_CONFIG_SUCCESS)
			{
				logger.info("BS loaded");
			}
			else
			{
				logger.error("can\'t load BS: " + param1.info);
			}
			this._resourceManager.memBound = BootStrapConfig.CACHE_MEMORY_BOUND_IN_M << 20;
			Util.shuffleArray(BootStrapConfig.TRACKERS);
			this._connectionCache.maxTcpCount = BootStrapConfig.TCP_MAX_CONNECTION_COUNT;
			this._connectionCache.maxRtmfpCount = BootStrapConfig.RTMFP_MAX_CONNECTION_COUNT;
			this._p2pModule.enableList(BootStrapConfig.TRACKERS);
			if(BootStrapConfig.RTMFP_ENABLED)
			{
				this.startRTMFP();
			}
			dispatchEvent(param1);
		}
		
		private function onTimer(param1:TimerEvent) : void
		{
			if(this._rtmfp.isStarted)
			{
				if(this._rtmfp.stat.connectCount > BootStrapConfig.RTMFP_CONNECT_COUNT_BOUND || this._rtmfp.stat.connectionSetupCount > BootStrapConfig.RTMFP_CONNECTION_SETUP_COUNT_BOUND)
				{
					this._rtmfp.stat.reset();
					this.reStartRTMFP();
				}
			}
		}
	}
}

class SingleEnforcer extends Object
{
	
	function SingleEnforcer()
	{
		super();
	}
}

class Stat extends Object
{
	
	public var rtmfpConnectStartTime:uint;
	
	public var rtmfpConnectTime:uint;
	
	public var rtmfpStartComplete:Boolean;
	
	public var rtmfpStopCount:uint;
	
	function Stat()
	{
		super();
	}
}
