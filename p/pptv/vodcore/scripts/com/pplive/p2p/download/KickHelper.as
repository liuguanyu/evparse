package com.pplive.p2p.download
{
	import com.pplive.p2p.connection.PeerConnection;
	import com.pplive.util.Assert;
	import flash.utils.getTimer;
	
	class KickHelper extends Object
	{
		
		public static const FRESH_TIME_LIMIT:uint = 30;
		
		public static const USABLE_SPEED_LIMIT_KPS:uint = 10;
		
		public var connection:PeerConnection;
		
		public var isFresh:Boolean;
		
		public var isEmpty:Boolean;
		
		public var currentSpeed:int;
		
		public var recentSpeed:int;
		
		function KickHelper(param1:PeerConnection)
		{
			super();
			this.connection = param1;
			var _loc2:PeerDispatchControl = param1.client;
			Assert.isTrue(!(_loc2 == null));
			var _loc3:uint = (getTimer() - _loc2.createTime) / 1000 + 1;
			this.isFresh = _loc3 <= FRESH_TIME_LIMIT;
			this.isEmpty = _loc3 > FRESH_TIME_LIMIT && (param1.isEmpty);
			this.currentSpeed = param1.stat.downloadSpeedMeter.getRecentSpeedInKBPS(2);
			this.recentSpeed = param1.stat.downloadSpeedMeter.getRecentSpeedInKBPS(10);
		}
		
		public static function cmp(param1:KickHelper, param2:KickHelper) : int
		{
			if(param1.isFresh != param2.isFresh)
			{
				return param1.isFresh?-1:1;
			}
			if(param1.isEmpty != param2.isEmpty)
			{
				return param1.isEmpty?1:-1;
			}
			if(param1.currentSpeed >= USABLE_SPEED_LIMIT_KPS || param2.currentSpeed >= USABLE_SPEED_LIMIT_KPS)
			{
				return param2.currentSpeed - param1.currentSpeed;
			}
			return param2.recentSpeed - param1.recentSpeed;
		}
	}
}
