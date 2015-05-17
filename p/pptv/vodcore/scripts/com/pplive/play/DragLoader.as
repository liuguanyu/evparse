package com.pplive.play
{
	import flash.events.EventDispatcher;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import com.pplive.net.UrlLoaderWithRetry;
	import flash.events.Event;
	import flash.events.SecurityErrorEvent;
	import com.pplive.net.LoadFailedEvent;
	import flash.utils.getTimer;
	import com.pplive.util.URI;
	
	public class DragLoader extends EventDispatcher
	{
		
		private static var logger:ILogger = getLogger(DragLoader);
		
		private var dragHost:String;
		
		private var fileName:String;
		
		private var dragLoader:UrlLoaderWithRetry;
		
		private var dragRequestStartTime:int;
		
		private var _requestDuration:uint;
		
		private var _segments:Vector.<SegmentInfo>;
		
		private var _loadFailEventDispatched:Boolean = false;
		
		public function DragLoader(param1:String, param2:String = "drag.synacast.com")
		{
			super();
			this.fileName = param1;
			this.dragHost = param2;
		}
		
		public function destroy() : void
		{
			this.fileName = null;
			if(this.dragLoader)
			{
				this.dragLoader.destory();
				this.dragLoader.removeEventListener(Event.COMPLETE,this.onDragComplete);
				this.dragLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
				this.dragLoader.removeEventListener(LoadFailedEvent.LOAD_FAILED,this.onError);
				this.dragLoader = null;
			}
			if(this._segments)
			{
				this._segments.length = 0;
				this._segments = null;
			}
		}
		
		public function load() : void
		{
			logger.info("PlayInfoLoader load");
			this.dragLoader = new UrlLoaderWithRetry(1);
			this.dragLoader.addEventListener(Event.COMPLETE,this.onDragComplete,false,0,true);
			this.dragLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError,false,0,true);
			this.dragLoader.addEventListener(LoadFailedEvent.LOAD_FAILED,this.onError,false,0,true);
			this._loadFailEventDispatched = false;
			this.dragRequestStartTime = getTimer();
			this.dragLoader.load("http://" + this.dragHost + "/" + URI.transferToPPFixFilename(this.fileName) + "0drag");
		}
		
		public function get requestDuration() : uint
		{
			return this._requestDuration;
		}
		
		public function get segments() : Vector.<SegmentInfo>
		{
			return this._segments;
		}
		
		private function onDragComplete(param1:Event) : void
		{
			var dragXml:XML = null;
			var segmentList:XMLList = null;
			var i:uint = 0;
			var duration:Number = NaN;
			var ridString:String = null;
			var ridElements:Array = null;
			var rid:String = null;
			var fileLength:uint = 0;
			var headLength:uint = 0;
			var event:Event = param1;
			this._requestDuration = getTimer() - this.dragRequestStartTime;
			try
			{
				dragXml = new XML(this.dragLoader.data);
				logger.debug(dragXml);
				this._segments = new Vector.<SegmentInfo>();
				segmentList = dragXml.segments.segment;
				i = 0;
				while(i < segmentList.length())
				{
					duration = Number(segmentList[i].attribute("duration"));
					ridString = segmentList[i].attribute("varid");
					ridElements = ridString.split("&");
					rid = (ridElements[0] as String).split("=")[1];
					fileLength = uint((ridElements[1] as String).split("=")[1]);
					headLength = uint(segmentList[i].attribute("headlength"));
					logger.info("segment " + i + " duration:" + duration + ", rid:" + rid + ", fileLength:" + fileLength + ", headLength:" + headLength);
					this.segments.push(new SegmentInfo(rid,duration,fileLength,headLength));
					i++;
				}
				dispatchEvent(new Event(Event.COMPLETE));
			}
			catch(e:TypeError)
			{
				logger.error("onDragComplete parse error:" + e);
				dispatchLoadFailEvent();
			}
		}
		
		private function onError(param1:Event) : void
		{
			logger.error("fail to load drag: " + param1);
			this.dispatchLoadFailEvent();
		}
		
		private function dispatchLoadFailEvent() : void
		{
			if(!this._loadFailEventDispatched)
			{
				this._loadFailEventDispatched = true;
				dispatchEvent(new LoadFailedEvent());
			}
		}
	}
}
