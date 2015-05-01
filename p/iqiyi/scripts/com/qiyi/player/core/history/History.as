package com.qiyi.player.core.history {
	import flash.events.EventDispatcher;
	import com.qiyi.player.core.history.parts.LoginUserHistory;
	import com.qiyi.player.core.history.parts.UnLoginUserHistory;
	import com.qiyi.player.core.player.coreplayer.ICorePlayer;
	import com.qiyi.player.base.logging.ILogger;
	import com.qiyi.player.user.impls.UserManager;
	import com.qiyi.player.user.UserManagerEvent;
	import com.qiyi.player.core.history.events.HistoryEvent;
	import com.qiyi.player.user.IUser;
	import com.qiyi.player.base.logging.Log;
	
	public class History extends EventDispatcher {
		
		public function History(param1:ICorePlayer) {
			this._log = Log.getLogger("com.qiyi.player.core.history.History");
			super();
			this._holder = param1;
		}
		
		private var _loginUserHistory:LoginUserHistory;
		
		private var _unLoginUserHistory:UnLoginUserHistory;
		
		private var _holder:ICorePlayer;
		
		private var _log:ILogger;
		
		public function initialize() : void {
			UserManager.getInstance().addEventListener(UserManagerEvent.Evt_LoginSuccess,this.onLogin);
			UserManager.getInstance().addEventListener(UserManagerEvent.Evt_LogoutSuccess,this.onLogout);
			if(UserManager.getInstance().user) {
				this._log.info("History initialize! register user");
				this._loginUserHistory = new LoginUserHistory(this._holder);
				this._loginUserHistory.addEventListener(HistoryEvent.Evt_Ready,this.onHistoryReady);
				this.load(UserManager.getInstance().user);
			} else {
				this._log.info("History initialize! none user");
				this._unLoginUserHistory = new UnLoginUserHistory(this._holder);
				this._unLoginUserHistory.addEventListener(HistoryEvent.Evt_Ready,this.onHistoryReady);
				this.load(null);
			}
		}
		
		public function getReady() : Boolean {
			if(this._loginUserHistory) {
				return this._loginUserHistory.getReady();
			}
			if(this._unLoginUserHistory) {
				return this._unLoginUserHistory.getReady();
			}
			return false;
		}
		
		public function loadRecord(param1:String) : void {
			if(param1 == null || param1 == "") {
				return;
			}
			if(this._loginUserHistory) {
				this._loginUserHistory.loadRecord(param1);
			}
			if(this._unLoginUserHistory) {
				this._unLoginUserHistory.loadRecord(param1);
			}
		}
		
		public function update(param1:int) : void {
			if(this._loginUserHistory) {
				this._loginUserHistory.update(param1);
			}
			if(this._unLoginUserHistory) {
				this._unLoginUserHistory.update(param1);
			}
		}
		
		public function flush() : void {
			if(this._loginUserHistory) {
				this._loginUserHistory.upload();
			}
			if(this._unLoginUserHistory) {
				this._unLoginUserHistory.upload();
			}
		}
		
		public function getMovieHistoryTime() : int {
			if((this._loginUserHistory) && this._loginUserHistory.videoPlayTime > 0) {
				return this._loginUserHistory.videoPlayTime * 1000;
			}
			if((this._unLoginUserHistory) && this._unLoginUserHistory.videoPlayTime > 0) {
				return this._unLoginUserHistory.videoPlayTime * 1000;
			}
			return 0;
		}
		
		public function reset() : void {
			if(this._loginUserHistory) {
				this._loginUserHistory.reset();
			}
			if(this._unLoginUserHistory) {
				this._unLoginUserHistory.reset();
			}
		}
		
		public function load(param1:IUser) : void {
			if(this._loginUserHistory) {
				this._loginUserHistory.load(param1);
			}
			if(this._unLoginUserHistory) {
				this._unLoginUserHistory.load(param1);
			}
		}
		
		public function destroy() : void {
			this.destroyHistory();
			UserManager.getInstance().removeEventListener(UserManagerEvent.Evt_LoginSuccess,this.onLogin);
			UserManager.getInstance().removeEventListener(UserManagerEvent.Evt_LogoutSuccess,this.onLogout);
		}
		
		private function onHistoryReady(param1:HistoryEvent) : void {
			dispatchEvent(new HistoryEvent(HistoryEvent.Evt_Ready,param1.data));
		}
		
		private function onLogin(param1:UserManagerEvent) : void {
			this._log.info("History onLogin!");
			this.destroyHistory();
			this._loginUserHistory = new LoginUserHistory(this._holder);
			this._loginUserHistory.addEventListener(HistoryEvent.Evt_Ready,this.onHistoryReady);
			this.load(UserManager.getInstance().user);
			this.loadRecord(this._holder.runtimeData.tvid);
		}
		
		private function onLogout(param1:UserManagerEvent) : void {
			this._log.info("History onLogout!");
			this.destroyHistory();
			this._unLoginUserHistory = new UnLoginUserHistory(this._holder);
			this._unLoginUserHistory.addEventListener(HistoryEvent.Evt_Ready,this.onHistoryReady);
			this.load(null);
			this.loadRecord(this._holder.runtimeData.tvid);
		}
		
		private function destroyHistory() : void {
			if(this._loginUserHistory) {
				this._loginUserHistory.removeEventListener(HistoryEvent.Evt_Ready,this.onHistoryReady);
				this._loginUserHistory.destroy();
				this._loginUserHistory = null;
			}
			if(this._unLoginUserHistory) {
				this._unLoginUserHistory.removeEventListener(HistoryEvent.Evt_Ready,this.onHistoryReady);
				this._unLoginUserHistory.destroy();
				this._unLoginUserHistory = null;
			}
		}
	}
}
