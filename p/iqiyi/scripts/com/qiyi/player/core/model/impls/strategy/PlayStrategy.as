package com.qiyi.player.core.model.impls.strategy
{
	import com.qiyi.player.core.model.IStrategy;
	import com.qiyi.player.core.player.coreplayer.ICorePlayer;
	import com.qiyi.player.base.logging.ILogger;
	import com.qiyi.player.core.model.impls.pub.Settings;
	import com.qiyi.player.base.logging.Log;
	
	public class PlayStrategy extends Object implements IStrategy
	{
		
		private var _holder:ICorePlayer;
		
		private var _log:ILogger;
		
		public function PlayStrategy(param1:ICorePlayer)
		{
			this._log = Log.getLogger("com.qiyi.player.core.model.strategy.PlayStrategy");
			super();
			this._holder = param1;
			this._log.info("PlayStrategy is created.");
		}
		
		public function getStartTime() : Number
		{
			var _loc2:* = 0;
			this._holder.runtimeData.startFromHistory = false;
			var _loc1:int = this._holder.runtimeData.originalStartTime;
			if(_loc1 > 0)
			{
				return _loc1;
			}
			if((this._holder.runtimeData.useHistory) && (this._holder.history) && !this._holder.runtimeData.isTryWatch)
			{
				_loc2 = this._holder.history.getMovieHistoryTime();
				if(_loc2 > 0 && _loc2 < this._holder.movie.duration)
				{
					if((Settings.instance.skipTrailer) && this._holder.movie.trailerTime > 0)
					{
						if(this._holder.movie.trailerTime - _loc2 > 2000)
						{
							if(this._holder.runtimeData.originalEndTime > 0 && _loc2 >= this._holder.runtimeData.originalEndTime)
							{
								return 0;
							}
							this._holder.runtimeData.startFromHistory = true;
							return _loc2;
						}
						return (Settings.instance.skipTitle) && this._holder.movie.titlesTime > 0?this._holder.movie.titlesTime:0;
					}
					if(Math.abs(_loc2 - this._holder.movie.duration) > 9000)
					{
						if(this._holder.runtimeData.originalEndTime > 0 && _loc2 >= this._holder.runtimeData.originalEndTime)
						{
							return 0;
						}
						this._holder.runtimeData.startFromHistory = true;
						return _loc2;
					}
				}
			}
			if((Settings.instance.skipTitle) && this._holder.movie.titlesTime > 0)
			{
				return this._holder.movie.titlesTime;
			}
			return 0;
		}
	}
}
