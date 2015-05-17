package com.pplive.p2p.upload
{
	import com.pplive.p2p.SpeedMeter;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import com.pplive.p2p.struct.Constants;
	
	public class UploadStat extends Object
	{
		
		private static const STAT_SCALE_IN_SECONDS:uint = 15;
		
		private var _speedMeter:SpeedMeter;
		
		private var _maxAvgSpeedInK:uint = 0;
		
		private var _maxSpeedInK:uint;
		
		private var _timer:Timer;
		
		private var _startTime:uint = 0;
		
		private var _lastUploadTime:uint = 0;
		
		public function UploadStat()
		{
			this._speedMeter = new SpeedMeter(STAT_SCALE_IN_SECONDS);
			this._timer = new Timer(1000);
			super();
			this._timer.addEventListener(TimerEvent.TIMER,this.onTimer,false,0,true);
			this._timer.start();
		}
		
		public function destroy() : void
		{
			this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
			this._timer.stop();
			this._speedMeter.destory();
		}
		
		public function get startTime() : uint
		{
			return this._startTime;
		}
		
		public function get uploadTimeInMS() : uint
		{
			return this._speedMeter.totalTimeInMS;
		}
		
		public function get averageSpeedUponActiveInKBPS() : uint
		{
			return this._speedMeter.getTotalAvarageSpeedInKBPS();
		}
		
		public function get uploadAmountInK() : uint
		{
			return this._speedMeter.totalBytes >> 10;
		}
		
		public function get currentAvgSpeedInK() : uint
		{
			return this._speedMeter.getRecentSpeedInKBPS(STAT_SCALE_IN_SECONDS);
		}
		
		public function get maxAvgSpeedInK() : uint
		{
			return this._maxAvgSpeedInK;
		}
		
		public function get currentSpeedInK() : uint
		{
			return this._speedMeter.getRecentSpeedInKBPS(2);
		}
		
		public function get maxSpeedInK() : uint
		{
			return this._maxSpeedInK;
		}
		
		public function onUpload(param1:uint) : void
		{
			var _loc2:uint = getTimer();
			if(param1 > 0)
			{
				this._lastUploadTime = _loc2;
				if(!this._speedMeter.isRunning)
				{
					this._speedMeter.resume();
				}
				this._speedMeter.submitBytes(param1 * Constants.SUBPIECE_SIZE);
				if(this._startTime == 0)
				{
					this._startTime = _loc2;
				}
			}
		}
		
		private function onTimer(param1:TimerEvent) : void
		{
			var _loc3:uint = 0;
			var _loc2:uint = this._speedMeter.getRecentSpeedInKBPS(2);
			if(this._maxSpeedInK < _loc2)
			{
				this._maxSpeedInK = _loc2;
			}
			if(getTimer() - this._lastUploadTime >= STAT_SCALE_IN_SECONDS * 1000)
			{
				this._speedMeter.pause();
			}
			if((this._speedMeter.isRunning) && this._speedMeter.startTime + STAT_SCALE_IN_SECONDS * 1000 < getTimer())
			{
				_loc3 = this._speedMeter.getRecentSpeedInKBPS(STAT_SCALE_IN_SECONDS);
				if(this._maxAvgSpeedInK < _loc3)
				{
					this._maxAvgSpeedInK = _loc3;
				}
			}
		}
	}
}
