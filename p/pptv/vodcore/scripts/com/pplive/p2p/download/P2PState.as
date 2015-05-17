package com.pplive.p2p.download
{
	class P2PState extends Object
	{
		
		public static const REST_PLAY_TIME_LOW_BOUND:uint = 90;
		
		public static const REST_PLAY_TIME_HIGH_BOUND:uint = 120;
		
		private var _isGood:Boolean = false;
		
		function P2PState()
		{
			super();
		}
		
		public function update(param1:Number) : void
		{
			if(param1 >= REST_PLAY_TIME_HIGH_BOUND)
			{
				this._isGood = true;
			}
			else if(param1 <= REST_PLAY_TIME_LOW_BOUND)
			{
				this._isGood = false;
			}
			
		}
		
		public function get isGood() : Boolean
		{
			return this._isGood;
		}
		
		public function get connectionNeeded() : uint
		{
			return this._isGood?10:20;
		}
	}
}
