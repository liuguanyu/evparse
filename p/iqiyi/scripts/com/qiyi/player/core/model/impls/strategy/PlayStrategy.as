package com.qiyi.player.core.model.impls.strategy {
	import com.qiyi.player.core.model.IStrategy;
	import com.qiyi.player.core.player.coreplayer.ICorePlayer;
	import com.qiyi.player.base.logging.ILogger;
	import com.qiyi.player.core.model.impls.pub.Settings;
	import com.qiyi.player.base.logging.Log;
	
	public class PlayStrategy extends Object implements IStrategy {
		
		public function PlayStrategy(param1:ICorePlayer) {
			this._log = Log.getLogger("com.qiyi.player.core.model.strategy.PlayStrategy");
			super();
			this._holder = param1;
			this._log.info("PlayStrategy is created.");
		}
		
		private var _holder:ICorePlayer;
		
		private var _log:ILogger;
		
		public function getStartTime() : Number {
			var _loc2_:* = 0;
			this._holder.runtimeData.startFromHistory = false;
			var _loc1_:int = this._holder.runtimeData.originalStartTime;
			if(_loc1_ > 0) {
				return _loc1_;
			}
			if((this._holder.runtimeData.useHistory) && (this._holder.history) && !this._holder.runtimeData.isTryWatch) {
				_loc2_ = this._holder.history.getMovieHistoryTime();
				if(_loc2_ > 0 && _loc2_ < this._holder.movie.duration) {
					if((Settings.instance.skipTrailer) && this._holder.movie.trailerTime > 0) {
						if(this._holder.movie.trailerTime - _loc2_ > 2000) {
							if(this._holder.runtimeData.originalEndTime > 0 && _loc2_ >= this._holder.runtimeData.originalEndTime) {
								return 0;
							}
							this._holder.runtimeData.startFromHistory = true;
							return _loc2_;
						}
						return (Settings.instance.skipTitle) && this._holder.movie.titlesTime > 0?this._holder.movie.titlesTime:0;
					}
					if(Math.abs(_loc2_ - this._holder.movie.duration) > 9000) {
						if(this._holder.runtimeData.originalEndTime > 0 && _loc2_ >= this._holder.runtimeData.originalEndTime) {
							return 0;
						}
						this._holder.runtimeData.startFromHistory = true;
						return _loc2_;
					}
				}
			}
			if((Settings.instance.skipTitle) && this._holder.movie.titlesTime > 0) {
				return this._holder.movie.titlesTime;
			}
			return 0;
		}
	}
}
