package com.qiyi.player.core.model.impls.strategy {
	import com.qiyi.player.core.model.IStrategy;
	import com.qiyi.player.base.logging.ILogger;
	import com.qiyi.player.core.player.coreplayer.ICorePlayer;
	import com.qiyi.player.core.model.impls.pub.Settings;
	import com.qiyi.player.base.logging.Log;
	
	public class ReplayStrategy extends Object implements IStrategy {
		
		public function ReplayStrategy(param1:ICorePlayer) {
			this._log = Log.getLogger("com.qiyi.player.core.model.strategy.ReplayStrategy");
			super();
			this._holder = param1;
			this._log.info("ReplayStrategy is created.");
		}
		
		private var _log:ILogger;
		
		private var _holder:ICorePlayer;
		
		public function getStartTime() : Number {
			this._holder.runtimeData.startFromHistory = false;
			var _loc1_:int = this._holder.runtimeData.originalStartTime;
			if(_loc1_ > 0) {
				return _loc1_;
			}
			if((Settings.instance.skipTitle) && this._holder.movie.titlesTime > 0) {
				return this._holder.movie.titlesTime;
			}
			return 0;
		}
	}
}
