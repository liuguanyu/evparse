package com.pplive.p2p
{
	import flash.events.EventDispatcher;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import com.pplive.net.UrlLoaderWithRetry;
	import flash.events.Event;
	import com.pplive.net.LoadFailedEvent;
	import flash.events.SecurityErrorEvent;
	import com.pplive.p2p.events.SimpleEvent;
	import com.pplive.p2p.struct.TrackerInfo;
	
	class BootStrapModule extends EventDispatcher
	{
		
		private static var logger:ILogger = getLogger(BootStrapModule);
		
		public static const BootStrapDomain:String = "player.aplus.pptv.com";
		
		public static const MAX_TRY_COUNT:uint = 3;
		
		private var _domain:String;
		
		private var _loader:UrlLoaderWithRetry;
		
		function BootStrapModule(param1:String = "player.aplus.pptv.com")
		{
			super();
			this._domain = param1;
		}
		
		public function start() : void
		{
			var _loc1:uint = 0;
			var _loc2:String = null;
			if(!this._loader)
			{
				this._loader = new UrlLoaderWithRetry(MAX_TRY_COUNT);
				this._loader.addEventListener(Event.COMPLETE,this.onComplete,false,0,true);
				this._loader.addEventListener(LoadFailedEvent.LOAD_FAILED,this.onError,false,0,true);
				this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError,false,0,true);
				_loc1 = Math.random() * uint.MAX_VALUE;
				_loc2 = "http://" + this._domain + "/config/vodp2pconfig" + "?rand=" + _loc1;
				logger.info("URL: " + _loc2);
				this._loader.load(_loc2);
			}
		}
		
		private function onComplete(param1:Event) : void
		{
			var bsconfigXML:XML = null;
			var event:Event = param1;
			BootStrapConfig.IS_UPDATED = true;
			try
			{
				logger.debug("bs data: " + this._loader.data);
				bsconfigXML = new XML(this._loader.data);
				this.setRtmfpValues(bsconfigXML);
				this.setTrackerValues(bsconfigXML);
				this.setCacheValues(bsconfigXML);
				this.setDownloadValues(bsconfigXML);
				this.setP2PDownloadValues(bsconfigXML);
				this.logConfigs();
				if(!BootStrapConfig.RTMFP_ENABLED)
				{
					BootStrapConfig.RTMFP_DOWNLOAD_ENABLED = false;
				}
				BootStrapConfig.DOWNLOAD_P2P_ENABLED = (BootStrapConfig.TCP_DOWNLOAD_ENABLED) || (BootStrapConfig.RTMFP_DOWNLOAD_ENABLED);
				dispatchEvent(new SimpleEvent(SimpleEvent.BS_CONFIG_SUCCESS));
			}
			catch(e:*)
			{
				logger.error("parse error: " + e);
				dispatchEvent(new SimpleEvent(SimpleEvent.BS_CONFIG_FAIL));
			}
		}
		
		private function logConfigs() : void
		{
			logger.info("Config.IS_UPDATED: " + BootStrapConfig.IS_UPDATED);
			logger.info("Config.ENABLE_CDN_CHECKER: " + BootStrapConfig.ENABLE_CDN_CHECKER);
			logger.info("Config.CDN_CHECK_TIMEOUT: " + BootStrapConfig.CDN_CHECK_TIMEOUT);
			logger.info("Config.DOWNLOAD_RESUME_HTTP_REST_PLAY_TIME: " + BootStrapConfig.DOWNLOAD_RESUME_HTTP_REST_PLAY_TIME);
			logger.info("Config.DOWNLOAD_START_P2P_REST_PLAY_TIME: " + BootStrapConfig.DOWNLOAD_START_P2P_REST_PLAY_TIME);
			logger.info("Config.MAX_HTTP_MODE_DURATION: " + BootStrapConfig.MAX_HTTP_MODE_DURATION);
			logger.info("Config.MIN_P2P_MODE_DURATION: " + BootStrapConfig.MIN_P2P_MODE_DURATION);
			logger.info("Config.CACHE_MEMORY_BOUND_IN_M: " + BootStrapConfig.CACHE_MEMORY_BOUND_IN_M);
			logger.info("Config.TRACKERS: " + BootStrapConfig.TRACKERS.toString());
			logger.info("Config.MAX_LIST_INTERVAL: " + BootStrapConfig.MAX_LIST_INTERVAL);
			logger.info("Config.RTMFP_ENABLED: " + BootStrapConfig.RTMFP_ENABLED);
			logger.info("Config.RTMFP_P2P_SERVER: " + BootStrapConfig.RTMFP_P2P_SERVER);
			logger.info("Config.RTMFP_P2P_SERVER_KEY: " + BootStrapConfig.RTMFP_P2P_SERVER_KEY);
			logger.info("Config.RTMFP_MEDIA: " + BootStrapConfig.RTMFP_MEDIA);
			logger.info("Config.RTMFP_STARTUP_TIMEOUT: " + BootStrapConfig.RTMFP_STARTUP_TIMEOUT);
			logger.info("Config.RTMFP_DATA_RELIABLE: " + BootStrapConfig.RTMFP_DATA_RELIABLE);
			logger.info("Config.PEER_PRIORITY: " + BootStrapConfig.PEER_PRIORITY);
			logger.info("Config.ANNOUNCE_UPDATE_INTERVAL: " + BootStrapConfig.ANNOUNCE_UPDATE_INTERVAL);
			logger.info("Config.RTMFP_DOWNLOAD_ENABLED: " + BootStrapConfig.RTMFP_DOWNLOAD_ENABLED);
			logger.info("Config.RTMFP_MIN_WINDOW_SIZE: " + BootStrapConfig.RTMFP_MIN_WINDOW_SIZE);
			logger.info("Config.RTMFP_MAX_WINDOW_SIZE: " + BootStrapConfig.RTMFP_MAX_WINDOW_SIZE);
			logger.info("Config.RTMFP_MAX_CONNECTION_COUNT: " + BootStrapConfig.RTMFP_MAX_CONNECTION_COUNT);
			logger.info("Config.RTMFP_P2P_CONNECT_TIMEOUT: " + BootStrapConfig.RTMFP_P2P_CONNECT_TIMEOUT);
			logger.info("Config.RTMFP_CONNECT_COUNT_BOUND: " + BootStrapConfig.RTMFP_CONNECT_COUNT_BOUND);
			logger.info("Config.RTMFP_CONNECTION_SETUP_COUNT_BOUND: " + BootStrapConfig.RTMFP_CONNECTION_SETUP_COUNT_BOUND);
			logger.info("Config.RTMFP_P2P_CONNECT_MAX_PENDING_COUNT: " + BootStrapConfig.RTMFP_P2P_CONNECT_MAX_PENDING_COUNT);
			logger.info("Config.RTMFP_P2P_CONNECT_RATE: " + BootStrapConfig.RTMFP_P2P_CONNECT_RATE);
			logger.info("Config.TCP_DOWNLOAD_ENABLED: " + BootStrapConfig.TCP_DOWNLOAD_ENABLED);
			logger.info("Config.TCP_MIN_WINDOW_SIZE: " + BootStrapConfig.TCP_MIN_WINDOW_SIZE);
			logger.info("Config.TCP_MAX_WINDOW_SIZE: " + BootStrapConfig.TCP_MAX_WINDOW_SIZE);
			logger.info("Config.TCP_MAX_CONNECTION_COUNT: " + BootStrapConfig.TCP_MAX_CONNECTION_COUNT);
			logger.info("Config.TCP_CONNECT_MAX_PENDING_COUNT: " + BootStrapConfig.TCP_CONNECT_MAX_PENDING_COUNT);
			logger.info("Config.TCP_CONNECT_TIMEOUT: " + BootStrapConfig.TCP_CONNECT_TIMEOUT);
			logger.info("Config.TCP_CONNECT_RATE: " + BootStrapConfig.TCP_CONNECT_RATE);
		}
		
		private function onError(param1:Event) : void
		{
			logger.error("onError: " + param1);
			BootStrapConfig.IS_UPDATED = true;
			dispatchEvent(new SimpleEvent(SimpleEvent.BS_CONFIG_FAIL));
		}
		
		private function parseTrackerList(param1:*) : Vector.<TrackerInfo>
		{
			var _loc3:uint = 0;
			var _loc4:uint = 0;
			var _loc2:Vector.<TrackerInfo> = new Vector.<TrackerInfo>();
			if(param1)
			{
				_loc3 = 0;
				_loc4 = param1.length();
				while(_loc3 < _loc4)
				{
					_loc2.push(new TrackerInfo(param1[_loc3].@i,param1[_loc3].@p));
					_loc3++;
				}
			}
			return _loc2;
		}
		
		private function setTrackerValues(param1:XML) : void
		{
			BootStrapConfig.TRACKERS = this.parseTrackerList(param1.tracker.t);
			this.setBSConfig("MAX_LIST_INTERVAL",param1.tracker,"max_list_interval",uint);
			if(BootStrapConfig.TRACKERS.length == 0)
			{
				BootStrapConfig.TRACKERS = this.parseTrackerList(param1.reportgroup.t);
			}
		}
		
		private function setRtmfpValues(param1:XML) : void
		{
			var _loc2:* = param1.rtmfp;
			this.setBSConfig("RTMFP_ENABLED",_loc2,"enable",this.booleanConverter);
			this.setBSConfig("RTMFP_P2P_SERVER",_loc2,"server",String);
			this.setBSConfig("RTMFP_P2P_SERVER_KEY",_loc2,"key",String);
			this.setBSConfig("RTMFP_MEDIA",_loc2,"media",String);
			this.setBSConfig("RTMFP_STARTUP_TIMEOUT",_loc2,"startup_timeout",uint);
			this.setBSConfig("RTMFP_DATA_RELIABLE",_loc2,"data_reliable",this.booleanConverter);
		}
		
		private function setDownloadValues(param1:XML) : void
		{
			var _loc2:* = param1.download;
			this.setBSConfig("DOWNLOAD_RESUME_HTTP_REST_PLAY_TIME",_loc2,"rhrpt",uint);
			this.setBSConfig("DOWNLOAD_START_P2P_REST_PLAY_TIME",_loc2,"sprpt",uint);
			this.setBSConfig("ENABLE_CDN_CHECKER",_loc2,"check_cdn",this.booleanConverter);
			this.setBSConfig("CDN_CHECK_TIMEOUT",_loc2,"check_cdn_timeout",uint);
			_loc2 = param1.dispatch;
			this.setBSConfig("MAX_HTTP_MODE_DURATION",_loc2,"max_http_duration",uint);
			this.setBSConfig("MIN_P2P_MODE_DURATION",_loc2,"min_p2p_duration",uint);
		}
		
		private function setP2PDownloadValues(param1:XML) : void
		{
			var _loc2:* = param1.p2pdownload;
			this.setBSConfig("PEER_PRIORITY",_loc2,"peer_priority",String);
			this.setBSConfig("ANNOUNCE_UPDATE_INTERVAL",_loc2,"announce_interval",uint);
			_loc2 = param1.p2pdownload.tcp;
			this.setBSConfig("TCP_DOWNLOAD_ENABLED",_loc2,"enable",this.booleanConverter);
			this.setBSConfig("TCP_MIN_WINDOW_SIZE",_loc2,"min_window",uint);
			this.setBSConfig("TCP_MAX_WINDOW_SIZE",_loc2,"max_window",uint);
			this.setBSConfig("TCP_MAX_CONNECTION_COUNT",_loc2,"max_connections",uint);
			this.setBSConfig("TCP_CONNECT_MAX_PENDING_COUNT",_loc2,"max_peer_waiting_connection_setup",uint);
			this.setBSConfig("TCP_CONNECT_TIMEOUT",_loc2,"connect_timeout",uint);
			this.setBSConfig("TCP_CONNECT_RATE",_loc2,"connect_rate",Number);
			_loc2 = param1.p2pdownload.rtmfp;
			this.setBSConfig("RTMFP_DOWNLOAD_ENABLED",_loc2,"enable",this.booleanConverter);
			this.setBSConfig("RTMFP_MIN_WINDOW_SIZE",_loc2,"min_window",uint);
			this.setBSConfig("RTMFP_MAX_WINDOW_SIZE",_loc2,"max_window",uint);
			this.setBSConfig("RTMFP_MAX_CONNECTION_COUNT",_loc2,"max_connections",uint);
			this.setBSConfig("RTMFP_P2P_CONNECT_MAX_PENDING_COUNT",_loc2,"max_peer_waiting_connection_setup",uint);
			this.setBSConfig("RTMFP_P2P_CONNECT_TIMEOUT",_loc2,"connect_timeout",uint);
			this.setBSConfig("RTMFP_CONNECT_COUNT_BOUND",_loc2,"connect_count_bound",uint);
			this.setBSConfig("RTMFP_CONNECTION_SETUP_COUNT_BOUND",_loc2,"connection_setup_count_bound",uint);
			this.setBSConfig("RTMFP_P2P_CONNECT_RATE",_loc2,"connect_rate",Number);
		}
		
		private function setCacheValues(param1:XML) : void
		{
			var _loc2:* = param1.cache;
			this.setBSConfig("CACHE_MEMORY_BOUND_IN_M",_loc2,"mem_bound",uint);
		}
		
		private function booleanConverter(param1:String) : Boolean
		{
			return param1.toLowerCase() == "true";
		}
		
		private function randomEnableByPercent(param1:String) : Boolean
		{
			var _loc2:uint = uint(param1);
			var _loc3:uint = Math.random() * 100;
			return _loc3 < _loc2;
		}
		
		private function setBSConfig(param1:String, param2:*, param3:String, param4:Object) : Boolean
		{
			var val:String = null;
			var item:String = param1;
			var xmlNode:* = param2;
			var attr:String = param3;
			var convertor:Object = param4;
			if((xmlNode) && !(xmlNode.attribute(attr) == undefined))
			{
				val = xmlNode.attribute(attr);
				logger.debug("attr: " + attr + ", value: " + val);
				try
				{
					BootStrapConfig[item] = convertor(val);
					return true;
				}
				catch(e:*)
				{
					logger.error("setBSConfig: " + attr + ", " + val);
				}
				return false;
			}
			logger.info("empty attr: " + attr);
			return false;
		}
	}
}
