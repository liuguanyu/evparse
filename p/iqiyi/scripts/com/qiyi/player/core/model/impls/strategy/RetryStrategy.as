package com.qiyi.player.core.model.impls.strategy {
	import com.qiyi.player.core.model.IStrategy;
	import com.qiyi.player.core.player.coreplayer.ICorePlayer;
	import com.qiyi.player.base.logging.ILogger;
	import com.qiyi.player.core.model.impls.pub.Settings;
	import com.qiyi.player.base.logging.Log;
	
	public class RetryStrategy extends Object implements IStrategy {
		
		public function RetryStrategy(param1:ICorePlayer) {
			this._log = Log.getLogger("com.qiyi.player.core.model.strategy.RetryStrategy");
			super();
			this._holder = param1;
			this._log.info("RetryStrategy is created.");
		}
		
		private var _holder:ICorePlayer;
		
		private var _log:ILogger;
		
		public function getStartTime() : Number {
			var _loc1_:* = 0;
			var _loc2_:* = 0;
			this._holder.runtimeData.startFromHistory = false;
			if(this._holder.runtimeData.isTryWatch) {
				_loc1_ = this._holder.runtimeData.originalStartTime;
				if(_loc1_ > 0) {
					return _loc1_;
				}
			} else {
				_loc2_ = this._holder.history.getMovieHistoryTime();
				if(_loc2_ > 0 && _loc2_ < this._holder.movie.duration) {
					return _loc2_;
				}
			}
			if((Settings.instance.skipTitle) && this._holder.movie.titlesTime > 0) {
				return this._holder.movie.titlesTime;
			}
			return 0;
		}
	}
}