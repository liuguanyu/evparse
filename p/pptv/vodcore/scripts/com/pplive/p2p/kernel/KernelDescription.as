package com.pplive.p2p.kernel
{
	public class KernelDescription extends Object
	{
		
		private var _majorVersion:uint;
		
		private var _minorVersion:uint;
		
		private var _macroVersion:uint;
		
		private var _extraVersion:uint;
		
		private var _tcpPort:uint;
		
		public function KernelDescription(param1:uint, param2:uint, param3:uint, param4:uint, param5:uint)
		{
			super();
			this._majorVersion = param1;
			this._minorVersion = param2;
			this._macroVersion = param3;
			this._extraVersion = param4;
			this._tcpPort = param5;
		}
		
		public function get majorVersion() : uint
		{
			return this._majorVersion;
		}
		
		public function get minorVersion() : uint
		{
			return this._minorVersion;
		}
		
		public function get macroVersion() : uint
		{
			return this._macroVersion;
		}
		
		public function get extraVersion() : uint
		{
			return this._extraVersion;
		}
		
		public function get tcpPort() : uint
		{
			return this._tcpPort;
		}
	}
}
