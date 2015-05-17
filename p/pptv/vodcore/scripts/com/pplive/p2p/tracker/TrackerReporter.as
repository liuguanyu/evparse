package com.pplive.p2p.tracker
{
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import com.pplive.p2p.struct.TrackerInfo;
	import flash.net.URLLoader;
	import flash.utils.Timer;
	import flash.net.URLRequest;
	import com.pplive.p2p.P2PServices;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.TimerEvent;
	import com.pplive.p2p.Util;
	
	public class TrackerReporter extends Object
	{
		
		private static var logger:ILogger = getLogger(TrackerReporter);
		
		private static const DEFAULT_KEEP_ALIVE_INTERVEL_IN_SECONDS:uint = 120;
		
		private static const REPORT_TIMEOUT_IN_SECONDS:uint = 15;
		
		private var _trackers:Vector.<TrackerInfo>;
		
		private var _currentTrackerIdx:uint;
		
		private var _loader:URLLoader;
		
		private var _timeoutTimer:Timer;
		
		private var _doReportTimer:Timer;
		
		public function TrackerReporter()
		{
			super();
		}
		
		public function start(param1:Vector.<TrackerInfo>) : void
		{
			if((param1) && param1.length > 0)
			{
				this._trackers = param1;
				this.stop();
				this.doReport();
			}
		}
		
		public function get isRunning() : Boolean
		{
			return (this._trackers) && this._trackers.length > 0;
		}
		
		public function report() : void
		{
			this.stop();
			this.doReport();
		}
		
		public function stop() : void
		{
			this.dropTimers();
			this.dropLoader();
		}
		
		private function doReport() : void
		{
			var _loc1:URLRequest = null;
			if((this._trackers) && this._trackers.length > 0)
			{
				if(P2PServices.instance.rtmfp.isStarted)
				{
					this._loader = new URLLoader();
					this._loader.addEventListener(Event.COMPLETE,this.onComplete,false,0,true);
					this._loader.addEventListener(IOErrorEvent.IO_ERROR,this.onError,false,0,true);
					this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError,false,0,true);
					this._loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.onHttpStatus,false,0,true);
					_loc1 = this.constructRequest();
					this._loader.load(_loc1);
					this._timeoutTimer = new Timer(REPORT_TIMEOUT_IN_SECONDS * 1000,1);
					this._timeoutTimer.addEventListener(TimerEvent.TIMER,this.onError,false,0,true);
					this._timeoutTimer.start();
				}
				else
				{
					this.delayReport(1);
				}
			}
		}
		
		private function constructRequest() : URLRequest
		{
			var _loc1:Vector.<String> = P2PServices.instance.resourceManager.rids;
			var _loc2:TrackerInfo = this._trackers[this._currentTrackerIdx];
			var _loc3:uint = uint.MAX_VALUE * Math.random();
			var _loc4:String = "http://" + _loc2.ip + ":" + _loc2.port + "/flashcgi?action=flashreport&rand=" + _loc3.toString();
			var _loc5:* = "fid=" + P2PServices.instance.rtmfp.peerID + "&resource_count=" + _loc1.length + "&rids=" + _loc1.join("|") + "|";
			return new URLRequest(_loc4 + "&" + _loc5);
		}
		
		private function delayReport(param1:uint) : void
		{
			this.dropTimers();
			this.dropLoader();
			this._doReportTimer = new Timer(param1 * 1000,1);
			this._doReportTimer.addEventListener(TimerEvent.TIMER,this.onDoReport,false,0,true);
			this._doReportTimer.start();
		}
		
		private function onComplete(param1:Event) : void
		{
			var feedback:XML = null;
			var e:Event = param1;
			var keepalive_interval:uint = DEFAULT_KEEP_ALIVE_INTERVEL_IN_SECONDS;
			try
			{
				feedback = new XML(this._loader.data);
				logger.debug(this._loader.data);
				logger.info("tracker report result: " + feedback.result.@type);
				if(feedback.result.@type == "0")
				{
					keepalive_interval = feedback.result.data.p.@keepalive_interval;
				}
				else
				{
					logger.error("error code: " + feedback.result.@type);
					this.switchTracker();
				}
			}
			catch(e:*)
			{
				logger.error("result XML parse error: " + e + "\n" + _loader.data);
				switchTracker();
			}
			this.delayReport(keepalive_interval);
		}
		
		private function onHttpStatus(param1:HTTPStatusEvent) : void
		{
			if(uint(param1.status / 100) == 4 || uint(param1.status / 100) == 5)
			{
			}
		}
		
		private function onError(param1:Event) : void
		{
			logger.error("tracer report: " + param1);
			this.switchTracker();
			this.delayReport(DEFAULT_KEEP_ALIVE_INTERVEL_IN_SECONDS);
		}
		
		private function switchTracker() : void
		{
			if((this._trackers) && (this._trackers.length))
			{
				this._currentTrackerIdx = (this._currentTrackerIdx + 1) % this._trackers.length;
			}
		}
		
		private function onDoReport(param1:Event) : void
		{
			if(Util.isFlashIDValid(P2PServices.instance.rtmfp.peerID))
			{
				this.dropTimers();
				this.doReport();
			}
			else
			{
				this.delayReport(10);
			}
		}
		
		private function dropTimers() : void
		{
			if(this._timeoutTimer)
			{
				this._timeoutTimer.stop();
				this._timeoutTimer = null;
			}
			if(this._doReportTimer)
			{
				this._doReportTimer.stop();
				this._doReportTimer = null;
			}
		}
		
		private function dropLoader() : void
		{
			if(this._loader)
			{
				this._loader.removeEventListener(Event.COMPLETE,this.onComplete);
				this._loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
				this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
				this._loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS,this.onHttpStatus);
				try
				{
					this._loader.close();
				}
				catch(e:*)
				{
					logger.error("URLLoader.close(): " + e);
				}
				this._loader = null;
			}
		}
	}
}
