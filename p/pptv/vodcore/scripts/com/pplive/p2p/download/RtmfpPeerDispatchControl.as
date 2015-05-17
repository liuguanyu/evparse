package com.pplive.p2p.download
{
	import flash.utils.getTimer;
	import com.pplive.p2p.Util;
	import com.pplive.p2p.BootStrapConfig;
	import com.pplive.p2p.connection.PeerConnection;
	
	class RtmfpPeerDispatchControl extends PeerDispatchControl
	{
		
		private var _subpieceReceived:uint;
		
		private var _nextAdjustWindowSizeTime:uint;
		
		private var _minRTT:uint = 3000;
		
		private var _preUpdateRTTTime:uint;
		
		function RtmfpPeerDispatchControl(param1:PeerConnection, param2:P2PState, param3:uint)
		{
			this._nextAdjustWindowSizeTime = getTimer() + 2000;
			super(param1,param2,param3);
		}
		
		override public function onTimer() : void
		{
			this.updateWindowSize();
		}
		
		override public function onReceiveSubpiece(param1:uint) : void
		{
			super.onReceiveSubpiece(param1);
			this._subpieceReceived++;
		}
		
		override protected function updateRTT(param1:uint) : void
		{
			var _loc2:uint = getTimer();
			if(this._preUpdateRTTTime == 0 || this._preUpdateRTTTime + 3000 < _loc2)
			{
				_rtt = param1;
			}
			else if(this._preUpdateRTTTime + 1000 < _loc2)
			{
				_rtt = (_rtt + param1) / 2;
			}
			else
			{
				_rtt = (_rtt * 9 + param1) / 10;
			}
			
			this._preUpdateRTTTime = _loc2;
			if(this._minRTT > _rtt)
			{
				this._minRTT = Util.max(_rtt,300);
			}
			if(this._nextAdjustWindowSizeTime > _loc2 + this._minRTT)
			{
				this._nextAdjustWindowSizeTime = _loc2 + this._minRTT;
			}
		}
		
		private function updateWindowSize() : void
		{
			var _loc1:uint = getTimer();
			if(_loc1 < this._nextAdjustWindowSizeTime)
			{
				return;
			}
			var _loc2:uint = this._subpieceReceived * (BootStrapConfig.RTMFP_P2P_CONGESTION_RATE + 1);
			if(_rtt <= this._minRTT * BootStrapConfig.RTMFP_P2P_MAX_DELAY_RATIO)
			{
				if(_windowSize < _loc2)
				{
					_windowSize = _loc2;
				}
				else
				{
					_windowSize = (_windowSize * 9 + _loc2) / 10;
				}
			}
			else if(_rtt > BootStrapConfig.RTMFP_P2P_MAX_DELAY_TIME || _windowSize > BootStrapConfig.RTMFP_P2P_MAX_WINDOW_SIZE_ALLOWED_FOR_AVOID_CONGESTION)
			{
				_windowSize = _loc2;
			}
			else
			{
				_windowSize++;
			}
			
			_windowSize = Util.fixToRange(_windowSize,BootStrapConfig.RTMFP_MIN_WINDOW_SIZE,BootStrapConfig.RTMFP_MAX_WINDOW_SIZE);
			this._nextAdjustWindowSizeTime = _loc1 + this._minRTT;
			this._subpieceReceived = 0;
		}
	}
}
