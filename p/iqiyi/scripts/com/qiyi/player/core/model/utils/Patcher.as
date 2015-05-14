package com.qiyi.player.core.model.utils
{
	import com.qiyi.player.core.IDestroy;
	import com.qiyi.player.core.player.coreplayer.ICorePlayer;
	import flash.utils.Timer;
	import com.qiyi.player.base.logging.ILogger;
	import flash.events.TimerEvent;
	import com.qiyi.player.core.player.def.StatusEnum;
	import com.qiyi.player.base.logging.Log;
	
	public class Patcher extends Object implements IDestroy
	{
		
		private const BLACK_SCREEN_TIME:int = 3000;
		
		private var _corePlayer:ICorePlayer;
		
		private var _timer:Timer;
		
		private var _blackScreenTime:int = 0;
		
		private var _blackScreenCurTime:int = 0;
		
		private var _log:ILogger;
		
		public function Patcher()
		{
			this._log = Log.getLogger("com.qiyi.player.core.model.utils.Patcher");
			super();
			this._timer = new Timer(500);
			this._timer.addEventListener(TimerEvent.TIMER,this.onTimer);
			this._timer.start();
		}
		
		public function initCorePlayer(param1:ICorePlayer) : void
		{
			this._corePlayer = param1;
		}
		
		public function monitorBlackScreen(param1:Boolean) : void
		{
			if(param1)
			{
				this._timer.start();
			}
			else
			{
				this._timer.stop();
			}
		}
		
		public function destroy() : void
		{
			this._timer.stop();
			this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
			this._timer = null;
			this._corePlayer = null;
		}
		
		private function onTimer(param1:TimerEvent) : void
		{
			var _loc2:* = 0;
			if(this._corePlayer)
			{
				if(this._corePlayer.hasStatus(StatusEnum.PLAYING))
				{
					_loc2 = this._corePlayer.currentTime;
					if(_loc2 != this._blackScreenCurTime)
					{
						this._blackScreenCurTime = _loc2;
						this._blackScreenTime = 0;
					}
					else
					{
						this._blackScreenTime = this._blackScreenTime + this._timer.delay;
					}
					if(this._blackScreenTime >= this.BLACK_SCREEN_TIME)
					{
						this._log.warn("CorePlayer arrive black limit time,execute seek,seek time:" + _loc2);
						this._corePlayer.seek(_loc2);
						this._blackScreenTime = 0;
						this._blackScreenCurTime = 0;
					}
				}
				else
				{
					this._blackScreenTime = 0;
					this._blackScreenCurTime = 0;
				}
			}
		}
	}
}
