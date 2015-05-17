package com.pplive.util
{
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	
	public class SpeedMeter extends Object
	{
		
		public static const DEFAULT_STAT_TIME_SCALE_IN_SECONDS:uint = 5;
		
		public static const MINUTE_TIME_SCALE_IN_SECONDS:uint = 60;
		
		private var maxRecordSeconds:uint;
		
		private var statTimeScaleInSeconds:uint;
		
		private var historySpeed:Vector.<uint>;
		
		private var currentSecondBytes:uint;
		
		private var archiveTimer:Timer;
		
		private var _isRunning:Boolean = false;
		
		private var _totalBytes:uint;
		
		private var _totalTimeInMS:uint;
		
		private var _maxSpeedInKPS:uint;
		
		private var startTime:int;
		
		public function SpeedMeter(param1:uint = 60, param2:uint = 5)
		{
			super();
			this.maxRecordSeconds = param1;
			this.statTimeScaleInSeconds = param2;
			this.historySpeed = new Vector.<uint>();
			this.currentSecondBytes = 0;
			this.archiveTimer = new Timer(1000);
			this.archiveTimer.addEventListener(TimerEvent.TIMER,this.onArchiveTimer,false,0,true);
			this.archiveTimer.start();
		}
		
		public function get isRunning() : Boolean
		{
			return this._isRunning;
		}
		
		public function get totalBytes() : uint
		{
			return this._totalBytes;
		}
		
		public function get totalTimeInMS() : uint
		{
			var _loc1:uint = this._totalTimeInMS;
			if(this._isRunning)
			{
				_loc1 = _loc1 + (getTimer() - this.startTime);
			}
			return _loc1;
		}
		
		public function resume() : void
		{
			if(!this._isRunning)
			{
				this._isRunning = true;
				this.startTime = getTimer();
				this.historySpeed = new Vector.<uint>();
			}
		}
		
		public function pause() : void
		{
			if(this._isRunning)
			{
				this._isRunning = false;
				this._totalTimeInMS = this._totalTimeInMS + (getTimer() - this.startTime);
			}
		}
		
		public function destory() : void
		{
			this.historySpeed.length = 0;
			this.historySpeed = null;
			this.archiveTimer.stop();
			this.archiveTimer.removeEventListener(TimerEvent.TIMER,this.onArchiveTimer);
			this.archiveTimer = null;
		}
		
		public function submitBytes(param1:uint) : void
		{
			if(this._isRunning)
			{
				this.currentSecondBytes = this.currentSecondBytes + param1;
				this._totalBytes = this._totalBytes + param1;
			}
		}
		
		public function getSecondSpeedInKBPS() : uint
		{
			if(this.historySpeed.length > 0)
			{
				return this.historySpeed[this.historySpeed.length - 1] / 1024;
			}
			return 0;
		}
		
		public function getRecentSpeedInKBPS(param1:uint = 5) : uint
		{
			return this.getMultiSecondsSpeedInKBPS(param1);
		}
		
		public function getMinuteSpeedInKBPS() : uint
		{
			return this.getMultiSecondsSpeedInKBPS(MINUTE_TIME_SCALE_IN_SECONDS);
		}
		
		public function getMaxSpeedInKPS() : uint
		{
			return this._maxSpeedInKPS;
		}
		
		public function getTotalAvarageSpeedInKBPS() : uint
		{
			return this._totalBytes / (this.totalTimeInMS + 1);
		}
		
		private function getMultiSecondsSpeedInKBPS(param1:uint) : uint
		{
			var _loc4:uint = 0;
			var _loc2:uint = 0;
			var _loc3:uint = this.historySpeed.length;
			if(_loc3 >= param1)
			{
				_loc4 = _loc3 - param1;
				while(_loc4 < _loc3)
				{
					_loc2 = _loc2 + this.historySpeed[_loc4];
					_loc4++;
				}
				return _loc2 / param1 / 1024;
			}
			if(_loc3 > 0)
			{
				_loc4 = 0;
				while(_loc4 < _loc3)
				{
					_loc2 = _loc2 + this.historySpeed[_loc4];
					_loc4++;
				}
				return _loc2 / _loc3 / 1024;
			}
			return 0;
		}
		
		private function onArchiveTimer(param1:Event) : void
		{
			var _loc2:uint = 0;
			if(this.historySpeed.length == this.maxRecordSeconds)
			{
				this.historySpeed.shift();
			}
			this.historySpeed.push(this.currentSecondBytes);
			this.currentSecondBytes = 0;
			if(this.historySpeed.length >= this.statTimeScaleInSeconds)
			{
				_loc2 = this.getMultiSecondsSpeedInKBPS(this.statTimeScaleInSeconds);
				if(this._maxSpeedInKPS < _loc2)
				{
					this._maxSpeedInKPS = _loc2;
				}
			}
		}
	}
}
