package com.pplive.p2p.download
{
	import com.pplive.p2p.BootStrapConfig;
	import com.pplive.p2p.connection.PeerConnection;
	
	class TcpPeerDispatchControl extends PeerDispatchControl
	{
		
		function TcpPeerDispatchControl(param1:PeerConnection, param2:P2PState, param3:uint)
		{
			super(param1,param2,param3);
		}
		
		override public function onTimer() : void
		{
			this.updateWindowSize();
		}
		
		override protected function updateRTT(param1:uint) : void
		{
			_rtt = (_rtt * 9 + param1) / 10;
		}
		
		private function updateWindowSize() : void
		{
			_windowSize = _connection.stat.downloadSpeedMeter.getRecentSpeedInKBPS(3);
			if(_windowSize < BootStrapConfig.TCP_MIN_WINDOW_SIZE)
			{
				_windowSize = BootStrapConfig.TCP_MIN_WINDOW_SIZE;
			}
			else if(_windowSize > BootStrapConfig.TCP_MAX_WINDOW_SIZE)
			{
				_windowSize = BootStrapConfig.TCP_MAX_WINDOW_SIZE;
			}
			
		}
	}
}
