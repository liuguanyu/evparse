package com.pplive.p2p.tracker
{
	import flash.events.EventDispatcher;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import com.pplive.p2p.struct.TrackerInfo;
	import com.pplive.p2p.struct.RID;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.setTimeout;
	import flash.net.URLRequest;
	import com.pplive.p2p.events.SimpleEvent;
	import flash.utils.clearTimeout;
	import com.pplive.p2p.P2PServices;
	import com.pplive.p2p.struct.PeerInfo;
	import com.pplive.p2p.events.GetPeersEvent;
	import com.pplive.p2p.BootStrapConfig;
	import com.pplive.p2p.Util;
	import com.pplive.p2p.struct.RtmfpPeerInfo;
	import com.pplive.p2p.struct.TcpPeerInfo;
	
	public class TrackerListConnection extends EventDispatcher
	{
		
		private static var logger:ILogger = getLogger(TrackerListConnection);
		
		public static const TIMEOUT_IN_SECONDS:uint = 15;
		
		private var _trackerInfo:TrackerInfo;
		
		private var _rid:RID;
		
		private var _tcpCount:uint;
		
		private var _rtmfpCount:uint;
		
		private var _loader:URLLoader;
		
		private var _timeoutHandler:uint;
		
		public function TrackerListConnection(param1:TrackerInfo, param2:RID, param3:uint, param4:uint)
		{
			super();
			this._trackerInfo = param1;
			this._rid = param2;
			this._tcpCount = param3;
			this._rtmfpCount = param4;
		}
		
		public function get rid() : RID
		{
			return this._rid;
		}
		
		public function get trackerInfo() : TrackerInfo
		{
			return this._trackerInfo;
		}
		
		public function start() : void
		{
			if(this._loader)
			{
				return;
			}
			this._loader = new URLLoader();
			this._loader.addEventListener(Event.COMPLETE,this.onComplete,false,0,true);
			this._loader.addEventListener(IOErrorEvent.IO_ERROR,this.onError,false,0,true);
			this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError,false,0,true);
			var url:String = this.constructUrl();
			logger.info(url);
			this._timeoutHandler = setTimeout(this.onTimeout,TIMEOUT_IN_SECONDS * 1000);
			try
			{
				this._loader.load(new URLRequest(url));
			}
			catch(e:*)
			{
				logger.error("URLLoader.load: " + e);
				close();
				dispatchEvent(new SimpleEvent(SimpleEvent.TRACKER_LIST_FAIL));
			}
		}
		
		public function close() : void
		{
			if(this._loader)
			{
				this._loader.removeEventListener(Event.COMPLETE,this.onComplete);
				this._loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
				this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
				try
				{
					this._loader.close();
				}
				catch(e:*)
				{
					logger.error("URLLoader.close(): " + e);
				}
				this._loader = null;
				clearTimeout(this._timeoutHandler);
				this._timeoutHandler = 0;
			}
		}
		
		private function constructUrl() : String
		{
			var _loc1:uint = Math.random() * uint.MAX_VALUE;
			return "http://" + this._trackerInfo.ip + ":" + this._trackerInfo.port + "/flashcgi?" + "action=flashlist&rid=" + this._rid.toString() + "&pid=" + P2PServices.instance.p2p.guid + "&count=" + this._tcpCount + "&fcount=" + this._rtmfpCount + "&fid=" + P2PServices.instance.rtmfp.peerID + "&rand=" + _loc1.toString();
		}
		
		private function onComplete(param1:Event) : void
		{
			var peerListXml:XML = null;
			var peers:Vector.<PeerInfo> = null;
			var e:Event = param1;
			try
			{
				peerListXml = new XML(this._loader.data);
				logger.debug(peerListXml);
				this.close();
				peers = this.parsePeerList(peerListXml);
				dispatchEvent(new GetPeersEvent(this._rid,peers));
			}
			catch(e:*)
			{
				logger.error("peerListXml parse error: " + e + "\n:" + _loader.data);
				close();
				dispatchEvent(new SimpleEvent(SimpleEvent.TRACKER_LIST_FAIL));
			}
		}
		
		private function onError(param1:Event) : void
		{
			logger.error(param1);
			this.close();
			dispatchEvent(new SimpleEvent(SimpleEvent.TRACKER_LIST_FAIL));
		}
		
		private function onTimeout() : void
		{
			logger.error("Tracker-list: timeout");
			this.close();
			dispatchEvent(new SimpleEvent(SimpleEvent.TRACKER_LIST_FAIL));
		}
		
		private function parsePeerList(param1:XML) : Vector.<PeerInfo>
		{
			var _loc4:XMLList = null;
			var _loc5:uint = 0;
			var _loc6:uint = 0;
			var _loc7:XML = null;
			var _loc2:Vector.<PeerInfo> = new Vector.<PeerInfo>();
			var _loc3:XMLList = param1.result;
			if(_loc3.attribute("type") == 0)
			{
				if(BootStrapConfig.RTMFP_DOWNLOAD_ENABLED)
				{
					_loc4 = _loc3.data.flashpeer.p;
					_loc5 = _loc4.length();
					_loc6 = 0;
					while(_loc6 < _loc5)
					{
						_loc7 = _loc4[_loc6];
						if(Util.isFlashIDValid(_loc7.attribute("fid")))
						{
							_loc2.push(new RtmfpPeerInfo(_loc7.attribute("v"),_loc7.attribute("fid"),_loc7.attribute("up"),_loc7.attribute("tp")));
						}
						_loc6++;
					}
				}
				if(BootStrapConfig.TCP_DOWNLOAD_ENABLED)
				{
					_loc4 = _loc3.data.peer.p;
					_loc5 = _loc4.length();
					_loc6 = 0;
					while(_loc6 < _loc5)
					{
						_loc7 = _loc4[_loc6];
						_loc2.push(new TcpPeerInfo(_loc7.attribute("v"),_loc7.attribute("i1"),_loc7.attribute("p1"),_loc7.attribute("i2"),_loc7.attribute("p2"),_loc7.attribute("up"),_loc7.attribute("tp")));
						_loc6++;
					}
				}
			}
			return _loc2;
		}
	}
}
