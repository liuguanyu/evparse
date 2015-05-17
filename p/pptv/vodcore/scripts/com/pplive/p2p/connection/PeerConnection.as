package com.pplive.p2p.connection
{
	import com.pplive.monitor.Monitable;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import com.pplive.p2p.struct.RID;
	import com.pplive.p2p.struct.PeerInfo;
	import com.pplive.p2p.struct.BlockMap;
	import com.pplive.p2p.events.ConnectionStatusEvent;
	import flash.utils.getTimer;
	import com.pplive.p2p.struct.SubPiece;
	import com.pplive.p2p.network.protocol.*;
	import com.pplive.p2p.struct.Constants;
	import com.pplive.p2p.P2PServices;
	import com.pplive.p2p.ResourceCache;
	import com.pplive.p2p.struct.PeerDownloadInfo;
	import com.pplive.p2p.events.ReceiveSubpieceEvent;
	import flash.utils.Dictionary;
	
	public class PeerConnection extends Monitable
	{
		
		protected static var logger:ILogger = getLogger(PeerConnection);
		
		protected var _isOpen:Boolean = true;
		
		protected var _createTime:uint;
		
		protected var _preFreeTime:uint;
		
		protected var _announceUpdateTime:uint;
		
		protected var _rid:RID;
		
		protected var _peer:PeerInfo;
		
		protected var _blockMap:BlockMap;
		
		protected var _stat:PCStat;
		
		public var client;
		
		public function PeerConnection(param1:PeerInfo)
		{
			this._createTime = getTimer();
			this._preFreeTime = getTimer();
			this._stat = new PCStat();
			super("PeerConnection");
			this._peer = param1;
		}
		
		public function close() : void
		{
			if(this._isOpen)
			{
				this._isOpen = false;
				this.doClose();
				this._blockMap = null;
				dispatchEvent(new ConnectionStatusEvent(ConnectionStatusEvent.CLOSED));
			}
		}
		
		public function get isOpen() : Boolean
		{
			return this._isOpen;
		}
		
		public function get peer() : PeerInfo
		{
			return this._peer;
		}
		
		public function get isRTMFP() : Boolean
		{
			return false;
		}
		
		public function get isAcceptedConnection() : Boolean
		{
			return false;
		}
		
		public function set rid(param1:RID) : void
		{
			this._blockMap = null;
			this._rid = param1;
			if(this._rid == null)
			{
				this._preFreeTime = getTimer();
			}
		}
		
		public function get isFree() : Boolean
		{
			return this._rid == null;
		}
		
		public function get lifetime() : uint
		{
			return (getTimer() - this._createTime) / 1000;
		}
		
		public function get freetime() : uint
		{
			return this.isFree?(getTimer() - this._preFreeTime) / 1000:0;
		}
		
		public function get announceUpdateTime() : uint
		{
			return this._announceUpdateTime;
		}
		
		public function get stat() : PCStat
		{
			return this._stat;
		}
		
		public function sendSubpiece(param1:SubPiecePacket) : void
		{
			if(this._isOpen)
			{
				this._stat.uploadSpeedMeter.submitBytes(param1.data.length);
				this.sendPacketImpl(param1);
			}
		}
		
		public function get blockMap() : BlockMap
		{
			return this._blockMap;
		}
		
		public function get isEmpty() : Boolean
		{
			return this._blockMap == null || (this._blockMap.isEmpty);
		}
		
		public function get isFull() : Boolean
		{
			return (this._blockMap) && (this._blockMap.isFull);
		}
		
		public function requestAnnounce() : void
		{
			if((this._isOpen) && (this._rid))
			{
				this.sendPacketImpl(new AnnounceRequestPacket(Packet.NewTransactionID(),this._rid));
			}
		}
		
		public function requestSubpiece(param1:uint) : void
		{
			var _loc2:Vector.<SubPiece> = null;
			if((this._isOpen) && (this._rid))
			{
				_loc2 = new Vector.<SubPiece>();
				_loc2.push(SubPiece.createSubPieceFromOffset(param1 * Constants.SUBPIECE_SIZE));
				this.sendPacketImpl(new SubPieceRequestPacket(Packet.NewTransactionID(),this._rid,_loc2,0));
			}
		}
		
		public function hasSubpiece(param1:uint) : Boolean
		{
			return !(this._blockMap == null) && (this._blockMap.hasBlock(param1 / Constants.SUBPIECE_NUM_PER_BLOCK));
		}
		
		public function onTimer() : void
		{
			this._stat.onTimer();
		}
		
		protected function doClose() : void
		{
			this._stat.destroy();
		}
		
		protected function onPacket(param1:Packet) : void
		{
			if(!this._isOpen)
			{
				return;
			}
			switch(param1.action)
			{
				case AnnounceResponsePacket.ACTION:
					this.handleAnnounceResponse(param1 as AnnounceResponsePacket);
					break;
				case AnnounceRequestPacket.ACTION:
					this.handleAnnounceRequest(param1 as AnnounceRequestPacket);
					break;
				case SubPiecePacket.ACTION:
					this.handleSubpieceResponse(param1 as SubPiecePacket);
					break;
				case SubPieceRequestPacket.ACTION:
					this.handleSubpieceRequest(param1 as SubPieceRequestPacket);
					break;
			}
		}
		
		protected function handleAnnounceResponse(param1:AnnounceResponsePacket) : void
		{
			if((this._rid) && (this._rid.isEqual(param1.rid)))
			{
				this._blockMap = param1.blockMap;
				this._announceUpdateTime = getTimer();
				dispatchEvent(new ConnectionStatusEvent(ConnectionStatusEvent.ANNOUNCE_UPDATED));
			}
		}
		
		protected function handleAnnounceRequest(param1:AnnounceRequestPacket) : void
		{
			var _loc4:BlockMap = null;
			var _loc2:ResourceCache = P2PServices.instance.resourceManager.getResource(param1.rid.toString());
			var _loc3:PeerDownloadInfo = new PeerDownloadInfo();
			if(_loc2)
			{
				_loc3.isDownloading = _loc2.stat.isDownloading;
				_loc4 = _loc2.blockBitmap;
			}
			else
			{
				_loc3.isDownloading = false;
				_loc4 = new BlockMap(0);
			}
			this.sendPacketImpl(new AnnounceResponsePacket(param1.transactionId,param1.rid,_loc3,_loc4));
		}
		
		protected function handleSubpieceResponse(param1:SubPiecePacket) : void
		{
			if((this._rid) && (this._rid.isEqual(param1.rid)))
			{
				dispatchEvent(new ReceiveSubpieceEvent(param1.subpiece,param1.data));
			}
		}
		
		protected function handleSubpieceRequest(param1:SubPieceRequestPacket) : void
		{
			P2PServices.instance.uploader.onSubpieceRequest(this,param1);
		}
		
		protected function sendPacketImpl(param1:Packet) : void
		{
		}
		
		override public function updateMonitedAttributes(param1:Dictionary) : void
		{
			param1["type"] = this.isRTMFP?"RTMFP":"TCP";
			param1["accepted"] = this.isAcceptedConnection;
			param1["id"] = this.peer.id;
			param1["upload-speed"] = this._stat.uploadSpeedMeter.getRecentSpeedInKBPS(2);
			param1["upload-amount"] = this._stat.uploadSpeedMeter.totalBytes >> 10;
			param1["rid"] = this._rid?this._rid.toString():"--";
		}
	}
}
