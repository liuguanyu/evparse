package com.pplive.p2p.kernel
{
	import flash.events.EventDispatcher;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import flash.net.URLLoader;
	import flash.utils.Timer;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.Event;
	import com.pplive.p2p.struct.Constants;
	import flash.net.URLRequest;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	
	public class KernelDectecter extends EventDispatcher
	{
		
		private static var logger:ILogger = getLogger(KernelDectecter);
		
		private var _listener:KernelDetectorListener;
		
		private var _loader0:URLLoader;
		
		private var _loader1:URLLoader;
		
		private var _startTime:int;
		
		private var _timeoutTimer:Timer;
		
		public function KernelDectecter(param1:KernelDetectorListener)
		{
			super();
			this._listener = param1;
			this._loader0 = new URLLoader();
			this._loader1 = new URLLoader();
			this.DetectPort(this._loader0,Constants.KERNEL_MAGIC_PORT0);
			this.DetectPort(this._loader1,Constants.KERNEL_MAGIC_PORT1);
			this._startTime = getTimer();
			logger.info("start time:" + this._startTime);
			this._timeoutTimer = new Timer(1000);
			this._timeoutTimer.addEventListener(TimerEvent.TIMER,this.onTimeOut,false,0,true);
			this._timeoutTimer.start();
		}
		
		private function DetectPort(param1:URLLoader, param2:uint) : void
		{
			var loader:URLLoader = param1;
			var port:uint = param2;
			loader.addEventListener(IOErrorEvent.IO_ERROR,function(param1:IOErrorEvent):void
			{
				onIOError(param1,port);
			});
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,function(param1:SecurityErrorEvent):void
			{
				onSecurityError(param1,port);
			});
			loader.addEventListener(Event.COMPLETE,function(param1:Event):void
			{
				onComplete(param1,port,loader);
			});
			var url:String = "http://" + Constants.KERNEL_HOST + ":" + port + "/synacast.xml?rnd=" + Math.random().toString();
			loader.load(new URLRequest(url));
		}
		
		private function RemoveLoaderEvent(param1:URLLoader) : void
		{
			param1.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
			param1.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
			param1.removeEventListener(Event.COMPLETE,this.onComplete);
		}
		
		public function destory() : void
		{
			this.stopTimer();
			this.RemoveLoaderEvent(this._loader0);
			this._loader0.close();
			this._loader0 = null;
			this.RemoveLoaderEvent(this._loader1);
			this._loader1.close();
			this._loader1 = null;
		}
		
		private function stopTimer() : void
		{
			if(this._timeoutTimer != null)
			{
				this._timeoutTimer.stop();
				this._timeoutTimer.removeEventListener(TimerEvent.TIMER,this.onTimeOut);
				this._timeoutTimer = null;
			}
		}
		
		private function onTimeOut(param1:TimerEvent) : void
		{
			logger.error("timeout error");
			this.onError();
		}
		
		private function onComplete(param1:Event, param2:uint, param3:URLLoader) : void
		{
			var kernelVersionXml:XML = null;
			var kernelVersion:String = null;
			var versionVector:Array = null;
			var majorVersion:uint = 0;
			var minorVersion:uint = 0;
			var macroVersion:uint = 0;
			var extraVersion:uint = 0;
			var tcpPort:uint = 0;
			var kernelDescription:KernelDescription = null;
			var event:Event = param1;
			var port:uint = param2;
			var loader:URLLoader = param3;
			logger.debug("complete enent:" + event + " port:" + port);
			try
			{
				kernelVersionXml = new XML(loader.data);
				logger.info(kernelVersionXml);
				if(kernelVersionXml.PPVA != null)
				{
					Constants.KERNEL_MAGIC_PORT = port;
					kernelVersion = kernelVersionXml.PPVA.attribute("v");
					versionVector = kernelVersion.split(", ");
					majorVersion = uint(versionVector[0]);
					minorVersion = uint(versionVector[1]);
					macroVersion = uint(versionVector[2]);
					extraVersion = uint(versionVector[3]);
					tcpPort = uint(kernelVersionXml.PPVA.attribute("p"));
					kernelDescription = new KernelDescription(majorVersion,minorVersion,macroVersion,extraVersion,tcpPort);
					this._listener.reportKernelStatus(true,getTimer() - this._startTime,kernelDescription);
					this.stopTimer();
				}
				else
				{
					logger.info("too old kernel version");
					this.onError();
				}
			}
			catch(e:TypeError)
			{
				logger.error("kernelVersionXml parse error:" + e);
				onError();
			}
		}
		
		private function onIOError(param1:IOErrorEvent, param2:uint) : void
		{
			logger.error("onIOError " + param1);
		}
		
		private function onSecurityError(param1:SecurityErrorEvent, param2:uint) : void
		{
			logger.error("onSecurityError");
		}
		
		private function onError() : void
		{
			this.stopTimer();
			this._listener.reportKernelStatus(false,getTimer() - this._startTime);
		}
	}
}
