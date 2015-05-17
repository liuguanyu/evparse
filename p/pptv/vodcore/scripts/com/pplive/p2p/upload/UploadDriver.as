package com.pplive.p2p.upload
{
	import com.pplive.monitor.Monitable;
	import com.pplive.p2p.connection.PeerConnection;
	import com.pplive.p2p.network.protocol.SubPieceRequestPacket;
	import com.pplive.p2p.ResourceCache;
	import com.pplive.p2p.struct.SubPiece;
	import com.pplive.p2p.network.protocol.SubPiecePacket;
	import com.pplive.p2p.P2PServices;
	import com.pplive.p2p.struct.Constants;
	import flash.utils.Dictionary;
	
	public class UploadDriver extends Monitable
	{
		
		private var _stat:UploadStat;
		
		private var _isRunning:Boolean;
		
		public function UploadDriver()
		{
			this._stat = new UploadStat();
			super("UploadDriver");
		}
		
		public function get isRunning() : Boolean
		{
			return this._isRunning;
		}
		
		public function get stat() : UploadStat
		{
			return this._stat;
		}
		
		public function resetStat() : void
		{
			this._stat = new UploadStat();
		}
		
		public function start() : void
		{
			this._isRunning = true;
		}
		
		public function stop() : void
		{
			this._isRunning = false;
		}
		
		public function onSubpieceRequest(param1:PeerConnection, param2:SubPieceRequestPacket) : void
		{
			var _loc3:ResourceCache = null;
			var _loc4:uint = 0;
			var _loc5:SubPiece = null;
			var _loc6:SubPiecePacket = null;
			if(this._isRunning)
			{
				_loc3 = P2PServices.instance.resourceManager.getResource(param2.rid.toString());
				if(_loc3)
				{
					_loc4 = 0;
					for each(_loc5 in param2.subpieces)
					{
						if(_loc3.hasSubPiece(_loc5))
						{
							_loc6 = new SubPiecePacket(param2.transactionId,param2.rid,_loc5,_loc3.getSubPiece(_loc5));
							param1.sendSubpiece(_loc6);
							_loc4++;
						}
					}
					this._stat.onUpload(_loc4);
					_loc3.stat.uploadSpeed.submitBytes(_loc4 * Constants.SUBPIECE_SIZE);
				}
			}
		}
		
		override public function updateMonitedAttributes(param1:Dictionary) : void
		{
			param1["speed"] = this._stat.currentSpeedInK;
			param1["max-speed"] = this._stat.maxSpeedInK;
			param1["time"] = this._stat.uploadTimeInMS / 1000;
			param1["amount"] = this._stat.uploadAmountInK;
			param1["avg-speed"] = this._stat.currentAvgSpeedInK;
			param1["max-avg-speed"] = this._stat.maxAvgSpeedInK;
		}
	}
}
