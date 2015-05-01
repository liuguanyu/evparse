package com.qiyi.player.core.model.impls {
	import flash.events.EventDispatcher;
	import com.qiyi.player.base.logging.ILogger;
	import com.qiyi.player.core.player.coreplayer.ICorePlayer;
	import com.qiyi.player.core.model.IMovie;
	import com.qiyi.player.core.model.remote.MixerRemote;
	import com.qiyi.player.core.model.remote.AuthenticationRemote;
	import com.qiyi.player.core.model.IMovieInfo;
	import com.qiyi.player.core.model.events.MovieEvent;
	import com.qiyi.player.core.model.def.TryWatchEnum;
	import com.qiyi.player.base.rpc.RemoteObjectEvent;
	import com.qiyi.player.base.rpc.RemoteObjectStatusEnum;
	import com.qiyi.player.core.player.def.PlayerUseTypeEnum;
	import com.adobe.serialization.json.JSON;
	import flash.utils.getTimer;
	import com.qiyi.player.core.model.impls.pub.Settings;
	import com.qiyi.player.core.player.RuntimeData;
	import com.qiyi.player.base.pub.EnumItem;
	import com.qiyi.player.core.model.utils.DefinitionUtils;
	import com.qiyi.player.core.model.def.DefinitionEnum;
	import com.qiyi.player.core.player.events.PlayerEvent;
	import com.qiyi.player.base.logging.Log;
	
	public class MovieChecker extends EventDispatcher {
		
		public function MovieChecker(param1:ICorePlayer) {
			this._log = Log.getLogger("com.qiyi.player.core.model.impls.MovieChecker");
			super();
			this._holder = param1;
			this._currentTvid = "";
			this._currentVid = "";
			this._isSuccess = false;
			this._failHappened = false;
		}
		
		private var _log:ILogger;
		
		private var _holder:ICorePlayer;
		
		private var _movie:IMovie;
		
		private var _movieInfo:MovieInfo;
		
		private var _currentTvid:String;
		
		private var _currentVid:String;
		
		private var _isSuccess:Boolean;
		
		private var _mixerRemote:MixerRemote;
		
		private var _authRemote:AuthenticationRemote;
		
		private var _failHappened:Boolean;
		
		public function getIsSuccess() : Boolean {
			return this._isSuccess;
		}
		
		public function getMovie() : IMovie {
			return this._movie;
		}
		
		public function getMovieInfo() : IMovieInfo {
			return this._movieInfo;
		}
		
		public function getCurrentTvid() : String {
			return this._currentTvid;
		}
		
		public function getCurrentVid() : String {
			return this._currentVid;
		}
		
		public function clearMovie() : void {
			this.stopAuthRemote();
			this.stopMixerRemote();
			if(this._movie) {
				this._movie.destroy();
				this._movie = null;
			}
			if(this._movieInfo) {
				this._movieInfo.removeEventListener(MovieEvent.Evt_Ready,this.onMovieInfoReady);
				this._movieInfo.destroy();
				this._movieInfo = null;
			}
			this._currentTvid = "";
			this._currentVid = "";
			this._isSuccess = false;
			this._failHappened = false;
		}
		
		public function checkout(param1:String, param2:String) : void {
			this.clearMovie();
			this._currentTvid = param1;
			this._currentVid = param2;
			this._holder.runtimeData.isTryWatch = false;
			this._holder.runtimeData.tryWatchType = TryWatchEnum.NONE;
			this._holder.runtimeData.tryWatchTime = 0;
			this._holder.runtimeData.authenticationTipType = -1;
			if(this._holder.runtimeData.movieIsMember) {
				this.startAuthRemote();
			} else {
				this.startMixerRemote();
			}
		}
		
		private function startAuthRemote() : void {
			this._authRemote = new AuthenticationRemote(0,this._holder);
			this._authRemote.addEventListener(RemoteObjectEvent.Evt_StatusChanged,this.onAuthRemoteStatusChanged);
			this._authRemote.initialize();
		}
		
		private function stopAuthRemote() : void {
			if(this._authRemote) {
				this._authRemote.removeEventListener(RemoteObjectEvent.Evt_StatusChanged,this.onAuthRemoteStatusChanged);
				this._authRemote.destroy();
				this._authRemote = null;
			}
		}
		
		private function onAuthRemoteStatusChanged(param1:RemoteObjectEvent) : void {
			var _loc2_:Object = null;
			if(this._authRemote.status == RemoteObjectStatusEnum.Success) {
				_loc2_ = this._authRemote.getData();
				if(_loc2_.code == "A00000") {
					this.stopMixerRemote();
					this.startMixerRemote();
					if((_loc2_.data) && !(_loc2_.data.tip_type == undefined)) {
						this._holder.runtimeData.authenticationTipType = int(_loc2_.data.tip_type);
					}
				} else {
					this._log.info("failed to Authentication, code = " + _loc2_.code);
					this._holder.runtimeData.errorCode = 504;
					this.onFailed();
				}
			} else {
				this.onFailed();
			}
		}
		
		private function startMixerRemote() : void {
			this._mixerRemote = new MixerRemote(this._holder);
			this._mixerRemote.addEventListener(RemoteObjectEvent.Evt_StatusChanged,this.onMixerRemoteStatusChanged);
			this._mixerRemote.initialize();
		}
		
		private function stopMixerRemote() : void {
			if(this._mixerRemote) {
				this._mixerRemote.removeEventListener(RemoteObjectEvent.Evt_StatusChanged,this.onMixerRemoteStatusChanged);
				this._mixerRemote.destroy();
				this._mixerRemote = null;
			}
		}
		
		private function onMixerRemoteStatusChanged(param1:RemoteObjectEvent) : void {
			var _loc2_:String = null;
			if(this._mixerRemote.status == RemoteObjectStatusEnum.Success) {
				_loc2_ = this._mixerRemote.getData().code;
				if(_loc2_ == "A000000") {
					if(this._holder.runtimeData.CDNStatus == -1 && this._holder.runtimeData.playerUseType == PlayerUseTypeEnum.MAIN) {
						this.parseF4v();
					}
					if(!this._failHappened) {
						this.parseVi();
					}
					if(!this._failHappened) {
						this.createMovieInfo();
					}
					if(!this._failHappened) {
						this.parseVp();
					}
					if(!this._failHappened) {
						this.createMovie();
					}
				} else {
					this._holder.runtimeData.errorCode = MixerRemote.VMSErrorMap[_loc2_];
					this._log.error("vms checked error, code: " + _loc2_);
					this.onFailed();
				}
			} else {
				this.onFailed();
			}
		}
		
		private function parseF4v() : void {
			var f4v:Object = null;
			var area:String = null;
			var l:String = null;
			var lArr:Array = null;
			var lSubArr:Array = null;
			f4v = this._mixerRemote.getData().f4v;
			if(f4v == null) {
				this._log.warn("Vf4v catched error, Vf4v is null");
				return;
			}
			try {
				this._log.info("Vf4v Result: " + com.adobe.serialization.json.JSON.encode(f4v));
				this._holder.runtimeData.CDNStatus = f4v.hasOwnProperty("s")?int(f4v.s):0;
				if(f4v.hasOwnProperty("r")) {
					this._holder.runtimeData.openFlashP2P = true;
					this._holder.runtimeData.stratusIP = (f4v.r as String).split("//")[1];
				} else {
					this._holder.runtimeData.openFlashP2P = false;
				}
				this._holder.runtimeData.smallOperators = f4v.hasOwnProperty("m")?f4v.m == "1":false;
				this._holder.runtimeData.dispatcherServerTime = uint(f4v.time);
				this._holder.runtimeData.dispatchFlashRunTime = int(getTimer() / 1000);
				area = (f4v.t as String).split("|")[0];
				this._log.info("the user node is in " + area);
				this._holder.runtimeData.oversea = Settings.instance.boss?0:area == "OVERSEA"?1:0;
				this._holder.runtimeData.userArea = f4v.t as String;
				if(f4v.l) {
					l = f4v.l;
					lArr = l.split("://");
					if((lArr) && lArr.length >= 2) {
						lSubArr = String(lArr[1]).split("/");
						if((lSubArr) && (lSubArr.length > 0) && (lSubArr[0])) {
							RuntimeData.VInfoDisIP = String(lSubArr[0]);
						}
					}
				}
			}
			catch(e:Error) {
				_log.info("parse Vf4v field error:" + e.message);
				pingbackError(403);
			}
		}
		
		private function parseVi() : void {
			var _loc1_:Object = this._mixerRemote.getData().vi;
			if(_loc1_ == null || !_loc1_.hasOwnProperty("st")) {
				this.pingbackError(603);
				this.onFailed();
				return;
			}
			var _loc2_:* = int(_loc1_.st) == 200;
			if(!_loc2_) {
				this.pingbackError(604);
				this.onFailed();
			}
		}
		
		private function parseVp() : void {
			var _loc1_:Object = this._mixerRemote.getData().vp;
			if(_loc1_ == null || !_loc1_.hasOwnProperty("st")) {
				this._log.info("parse vms vp or np data error:st is null");
				this.pingbackError(103);
				this.onFailed();
				return;
			}
			var _loc2_:int = int(_loc1_.st);
			var _loc3_:Boolean = 100 < _loc2_ && _loc2_ < 200;
			if(!_loc3_) {
				this._holder.runtimeData.errorCodeValue = _loc1_;
				this._log.info("vrs status:" + _loc2_);
				this.pingbackError(104);
				this.onFailed();
			}
		}
		
		private function pingbackError(param1:int) : void {
			if(this._holder.pingBack) {
				this._holder.pingBack.sendError(param1);
			}
			this._holder.runtimeData.errorCode = param1;
		}
		
		private function createMovieInfo() : void {
			try {
				this._movieInfo = new MovieInfo(this._holder);
				this._movieInfo.addEventListener(MovieEvent.Evt_Ready,this.onMovieInfoReady);
				this._movieInfo.startInitByInfo(this._mixerRemote.getData().vi);
			}
			catch(e:Error) {
				_log.info("create movieInfo error:" + e.message);
				pingbackError(603);
				onFailed();
			}
		}
		
		private function createMovie() : void {
			var definitionType:EnumItem = null;
			try {
				this._movie = new Movie(this._mixerRemote.getData().vp,this._holder.runtimeData.movieIsMember,this._holder);
				if((this._movie.ipLimited) && this._holder.runtimeData.oversea == 1 && !Settings.instance.boss) {
					this.pingbackError(5000);
					this.onFailed();
					return;
				}
				definitionType = this._holder.runtimeData.playerUseType == PlayerUseTypeEnum.MAIN?DefinitionUtils.getCurrentDefinition(this._holder):DefinitionEnum.LIMIT;
				this._movie.setCurAudioTrack(Settings.instance.audioTrack,definitionType);
				if(this._holder.runtimeData.originalEndTime > this._movie.duration) {
					this._holder.runtimeData.originalEndTime = this._movie.duration;
				}
				if(this._holder.runtimeData.playerUseType == PlayerUseTypeEnum.MAIN) {
					this._movie.startLoadAddedSkipPoints();
				}
				this._currentTvid = "";
				this._currentVid = "";
				this._isSuccess = true;
				dispatchEvent(new MovieEvent(MovieEvent.Evt_Success));
			}
			catch(e:Error) {
				_log.info("create movie error:" + e.message);
				pingbackError(103);
				onFailed();
			}
		}
		
		private function onFailed() : void {
			this._currentTvid = "";
			this._currentVid = "";
			this._failHappened = true;
			this.stopAuthRemote();
			this.stopMixerRemote();
			dispatchEvent(new MovieEvent(MovieEvent.Evt_Failed));
		}
		
		private function onMovieInfoReady(param1:MovieEvent) : void {
			this._movieInfo.removeEventListener(MovieEvent.Evt_Ready,this.onMovieInfoReady);
			this._holder.dispatchEvent(new PlayerEvent(PlayerEvent.Evt_MovieInfoReady));
		}
	}
}
