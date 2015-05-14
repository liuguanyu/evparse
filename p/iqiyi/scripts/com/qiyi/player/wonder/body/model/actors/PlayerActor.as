package com.qiyi.player.wonder.body.model.actors
{
	import org.puremvc.as3.interfaces.IFacade;
	import com.qiyi.player.wonder.common.status.Status;
	import com.qiyi.player.core.player.IPlayer;
	import com.qiyi.player.core.player.LoadMovieParams;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import gs.TweenLite;
	import com.qiyi.player.base.logging.ILogger;
	import flash.display.Sprite;
	import com.qiyi.player.core.player.events.PlayerEvent;
	import flash.events.TimerEvent;
	import com.qiyi.player.core.model.IStrategy;
	import com.qiyi.player.core.view.ILayer;
	import com.qiyi.player.base.pub.EnumItem;
	import com.qiyi.player.core.model.IMovieModel;
	import com.qiyi.player.core.model.IMovieInfo;
	import com.qiyi.player.wonder.body.BodyDef;
	import com.qiyi.player.core.video.def.StopReasonEnum;
	import flash.geom.Rectangle;
	import com.qiyi.player.wonder.common.config.SystemConfig;
	import com.qiyi.player.core.model.impls.ScreenInfo;
	import com.qiyi.player.core.model.def.ScreenEnum;
	import com.qiyi.player.core.player.def.StatusEnum;
	import com.qiyi.player.core.model.def.TryWatchEnum;
	import com.qiyi.player.core.model.impls.pub.Settings;
	import com.qiyi.player.core.model.impls.FocusTip;
	import com.qiyi.player.base.logging.Log;
	import com.qiyi.player.wonder.common.config.FlashVarConfig;
	import com.qiyi.player.core.CoreManager;
	import com.qiyi.player.core.player.def.PlayerUseTypeEnum;
	import com.qiyi.player.wonder.common.pingback.PingBackDef;
	
	public class PlayerActor extends Object
	{
		
		private var _facade:IFacade;
		
		private var _status:Status;
		
		private var _isInit:Boolean = false;
		
		private var _isPreload:Boolean = false;
		
		private var _isPlayRefreshed:Boolean = false;
		
		private var _smallWindowMode:Boolean = false;
		
		private var _player:IPlayer;
		
		private var _loadMovieParams:LoadMovieParams;
		
		private var _loadMovieType:String = "";
		
		private var _playStartTime:int = 0;
		
		private var _playingDuration:int = 0;
		
		private var _waitingDuration:int = 0;
		
		private var _focusTipsMap:Dictionary;
		
		private var _needTryWatchArrCheck:Boolean = true;
		
		private var _timer:Timer;
		
		private var _playerStatusDelay:TweenLite;
		
		private var _log:ILogger;
		
		public function PlayerActor(param1:IFacade)
		{
			this._log = Log.getLogger("com.qiyi.player.wonder.body.model.actors.PlayerActor");
			super();
			this._facade = param1;
			this._status = new Status(BodyDef.PLAYER_STATUS_BEGIN,BodyDef.PLAYER_STATUS_END);
			if(FlashVarConfig.owner == FlashVarConfig.OWNER_PAGE)
			{
				this._player = CoreManager.getInstance().createPlayer(PlayerUseTypeEnum.MAIN);
			}
			this._player.needFilterQualityDefinition = FlashVarConfig.outsite;
			this._player.isPreload = this._isPreload;
			this._player.pbPlayListID = FlashVarConfig.playListID;
			this._player.pbVVFrom = FlashVarConfig.videoFrom;
			this._player.pbVVFromtp = PingBackDef.VVPING_USER_CLICK;
			this._player.pbVFrm = FlashVarConfig.vfrm;
			this._player.pbOpenBarrage = FlashVarConfig.openBarrage;
			this._timer = new Timer(BodyDef.PLAYER_TIMER_TIME);
		}
		
		public function init(param1:Sprite, param2:Boolean = true) : void
		{
			if(!this._isInit)
			{
				this._player.initialize(param1,param2);
				this._player.addEventListener(PlayerEvent.Evt_Error,this.onPlayerError);
				this._player.addEventListener(PlayerEvent.Evt_DefinitionSwitched,this.onPlayerDefinitionSwitched);
				this._player.addEventListener(PlayerEvent.Evt_AudioTrackSwitched,this.onPlayerAudioTrackSwitched);
				this._player.addEventListener(PlayerEvent.Evt_MovieInfoReady,this.onPlayerMovieInfoReady);
				this._player.addEventListener(PlayerEvent.Evt_GPUChanged,this.onPlayerGPUChanged);
				this._player.addEventListener(PlayerEvent.Evt_PreparePlayEnd,this.onPlayerPreparePlayEnd);
				this._player.addEventListener(PlayerEvent.Evt_SkipTrailer,this.onPlayerSkipTrailer);
				this._player.addEventListener(PlayerEvent.Evt_StartFromHistory,this.onPlayerStartFromHistory);
				this._player.addEventListener(PlayerEvent.Evt_SkipTitle,this.onPlayerSkipTitle);
				this._player.addEventListener(PlayerEvent.Evt_StatusChanged,this.onPlayerStatusChanged);
				this._player.addEventListener(PlayerEvent.Evt_Stuck,this.onPlayerStuck);
				this._player.addEventListener(PlayerEvent.Evt_EnterPrepareSkipPoint,this.onPlayerEnterPrepareSkipPoint);
				this._player.addEventListener(PlayerEvent.Evt_OutPrepareSkipPoint,this.onPlayerOutPrepareSkipPoint);
				this._player.addEventListener(PlayerEvent.Evt_OutPrepareSkipPoint,this.onPreparePlayEndSkipPoint);
				this._player.addEventListener(PlayerEvent.Evt_EnterSkipPoint,this.onPlayerEnterSkipPoint);
				this._player.addEventListener(PlayerEvent.Evt_OutSkipPoint,this.onPlayerOutSkipPoint);
				this._player.addEventListener(PlayerEvent.Evt_FreshedSkipPoints,this.onFreshedSkipPoints);
				this._player.addEventListener(PlayerEvent.Evt_EnterPrepareLeaveSkipPoint,this.onEnterPrepareLeaveSkipPoint);
				this._player.addEventListener(PlayerEvent.Evt_OutPrepareLeaveSkipPoint,this.onOutPrepareLeaveSkipPoint);
				this._player.addEventListener(PlayerEvent.Evt_EnjoyableSubTypeInited,this.onEnjoyableSubTypeInited);
				this._timer.addEventListener(TimerEvent.TIMER,this.onTimer);
				this._timer.start();
				this._isInit = true;
			}
		}
		
		public function get corePlayer() : IPlayer
		{
			return this._player;
		}
		
		public function set openSelectPlay(param1:Boolean) : void
		{
			this._player.openSelectPlay = param1;
		}
		
		public function set pbVVFromtp(param1:String) : void
		{
			this._player.pbVVFromtp = param1;
		}
		
		public function set vfrm(param1:String) : void
		{
			this._player.pbVFrm = param1;
		}
		
		public function set openBarrage(param1:Boolean) : void
		{
			this._player.pbOpenBarrage = param1;
		}
		
		public function set isStarBarrage(param1:Boolean) : void
		{
			this._player.pbIsStarBarrage = param1;
		}
		
		public function get openSelectPlay() : Boolean
		{
			return this._player.openSelectPlay;
		}
		
		public function set isPreload(param1:Boolean) : void
		{
			this._isPreload = param1;
			this._player.isPreload = this._isPreload;
		}
		
		public function get isPreload() : Boolean
		{
			return this._isPreload;
		}
		
		public function get isPlayRefreshed() : Boolean
		{
			return this._isPlayRefreshed;
		}
		
		public function get loadMovieParams() : LoadMovieParams
		{
			return this._loadMovieParams;
		}
		
		public function get loadMovieType() : String
		{
			return this._loadMovieType;
		}
		
		public function get strategy() : IStrategy
		{
			return this._player.strategy;
		}
		
		public function get floatLayer() : ILayer
		{
			return this._player.layer;
		}
		
		public function get uuid() : String
		{
			return this._player.uuid;
		}
		
		public function get videoEventID() : String
		{
			return this._player.videoEventID;
		}
		
		public function get serverTime() : uint
		{
			return this._player.serverTime;
		}
		
		public function set visits(param1:String) : void
		{
			this._player.visits = param1;
		}
		
		public function setEnjoyableSubType(param1:EnumItem, param2:int) : void
		{
			this._player.setEnjoyableSubType(param1,param2);
		}
		
		public function get movieModel() : IMovieModel
		{
			return this._player.movieModel;
		}
		
		public function get movieInfo() : IMovieInfo
		{
			return this._player.movieInfo;
		}
		
		public function get errorCode() : int
		{
			return this._player.errorCode;
		}
		
		public function get errorCodeValue() : Object
		{
			return this._player.errorCodeValue;
		}
		
		public function get authenticationResult() : Object
		{
			return this._player.authenticationResult;
		}
		
		public function get authenticationError() : Boolean
		{
			return this._player.authenticationError;
		}
		
		public function get accStatus() : EnumItem
		{
			return this._player.accStatus;
		}
		
		public function get currentTime() : int
		{
			return this._player.currentTime;
		}
		
		public function get bufferTime() : int
		{
			return this._player.bufferTime;
		}
		
		public function get loadComplete() : Boolean
		{
			return this._player.loadComplete;
		}
		
		public function get speed() : int
		{
			return this._player.currentSpeed;
		}
		
		public function get playingDuration() : int
		{
			if(this._status.hasStatus(BodyDef.PLAYER_STATUS_STOPPING))
			{
				return this._playingDuration;
			}
			return this._player.playingDuration;
		}
		
		public function get waitingDuration() : int
		{
			if(this._status.hasStatus(BodyDef.PLAYER_STATUS_STOPPING))
			{
				return this._waitingDuration;
			}
			return this._player.waitingDuration;
		}
		
		public function get stopReason() : EnumItem
		{
			return this._player.stopReason;
		}
		
		public function get isNaturalStopReason() : Boolean
		{
			return this._player.stopReason == StopReasonEnum.SKIP_TRAILER || this._player.stopReason == StopReasonEnum.REACH_ASSIGN || this._player.stopReason == StopReasonEnum.STOP;
		}
		
		public function get isTryWatch() : Boolean
		{
			return this._player.isTryWatch;
		}
		
		public function get tryWatchType() : EnumItem
		{
			return this._player.tryWatchType;
		}
		
		public function get tryWatchTime() : int
		{
			return this._player.tryWatchTime;
		}
		
		public function get frameRate() : int
		{
			return this._player.frameRate;
		}
		
		public function get settingArea() : Rectangle
		{
			return this._player.settingArea;
		}
		
		public function get realArea() : Rectangle
		{
			return this._player.realArea;
		}
		
		public function get authenticationTipType() : int
		{
			return this._player.authenticationTipType;
		}
		
		public function get smallWindowMode() : Boolean
		{
			return this._smallWindowMode;
		}
		
		public function set smallWindowMode(param1:Boolean) : void
		{
			this._smallWindowMode = param1;
			this._player.smallWindowMode = param1;
		}
		
		public function set ugcAuthKey(param1:String) : void
		{
			this._player.ugcAuthKey = param1;
		}
		
		public function get VInfoDisIP() : String
		{
			return this._player.VInfoDisIP;
		}
		
		public function getCaptureURL(param1:Number = -1, param2:int = 1) : String
		{
			return this._player.getCaptureURL(param1,param2);
		}
		
		public function getSwfUrl() : String
		{
			if((this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) && (this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY)))
			{
				if(this._player.movieInfo.infoJSON.vu.split("/")[2] == "yule.iqiyi.com" || this._player.movieInfo.infoJSON.vu.split("/")[2] == "yule.qiyi.com")
				{
					return SystemConfig.PLAYER_URI + this._player.movieModel.vid + "/0/" + Math.floor(this._player.movieModel.duration / 1000) + "/" + this._player.movieInfo.infoJSON.vu.split("/")[2].split(".")[0] + "/" + this._player.movieInfo.infoJSON.vu.split("qiyi.com/")[1].split(".html")[0] + ".swf" + "-albumId=" + this._player.movieModel.albumId + "-tvId=" + this._player.movieModel.tvid + "-isPurchase=" + (this._player.movieModel.member?"1":"0") + "-cnId=" + this._player.movieModel.channelID;
				}
				return SystemConfig.PLAYER_URI + this._player.movieModel.vid + "/0/" + Math.floor(this._player.movieModel.duration / 1000) + "/" + this._player.movieInfo.infoJSON.vu.split("qiyi.com/")[1].split(".html")[0] + ".swf" + "-albumId=" + this._player.movieModel.albumId + "-tvId=" + this._player.movieModel.tvid + "-isPurchase=" + (this._player.movieModel.member?"1":"0") + "-cnId=" + this._player.movieModel.channelID;
			}
			return "";
		}
		
		public function getHtmlUrl() : String
		{
			if((this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) && (this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY)))
			{
				return "<embed src=\"" + this.getSwfUrl() + "\" quality=\"high\" width=\"480\" height=\"400\" align=\"middle\" " + "allowScriptAccess=\"always\" type=\"application/x-shockwave-flash\"></embed>";
			}
			return "";
		}
		
		public function get3DScreenInfo() : ScreenInfo
		{
			var _loc1:* = 0;
			var _loc2:* = 0;
			if(this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY))
			{
				_loc1 = this._player.movieModel.screenInfoCount;
				_loc2 = 0;
				while(_loc2 < _loc1)
				{
					if(this._player.movieModel.getScreenInfoAt(_loc2).screenType == ScreenEnum.THREE_D)
					{
						return this._player.movieModel.getScreenInfoAt(_loc2);
					}
					_loc2++;
				}
			}
			return null;
		}
		
		public function get2DScreenInfo() : ScreenInfo
		{
			var _loc1:* = 0;
			var _loc2:* = 0;
			if(this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY))
			{
				_loc1 = this._player.movieModel.screenInfoCount;
				_loc2 = 0;
				while(_loc2 < _loc1)
				{
					if(this._player.movieModel.getScreenInfoAt(_loc2).screenType == ScreenEnum.TWO_D)
					{
						return this._player.movieModel.getScreenInfoAt(_loc2);
					}
					_loc2++;
				}
			}
			return null;
		}
		
		public function loadMovie(param1:LoadMovieParams, param2:String) : void
		{
			if(this._playerStatusDelay)
			{
				TweenLite.killTweensOf(this.onAsyncPlayerStatusComplete,true);
				this._playerStatusDelay = null;
			}
			this._playStartTime = 0;
			this._needTryWatchArrCheck = true;
			switch(param2)
			{
				case BodyDef.LOAD_MOVIE_TYPE_ORIGINAL:
					this._loadMovieType = param2;
					this._loadMovieParams = param1;
					break;
				case BodyDef.LOAD_MOVIE_TYPE_SWITCH_TO_2D:
				case BodyDef.LOAD_MOVIE_TYPE_SWITCH_TO_3D:
					this._loadMovieType = param2;
					if((this.hasStatus(BodyDef.PLAYER_STATUS_PLAYING)) || (this.hasStatus(BodyDef.PLAYER_STATUS_SEEKING)) || (this.hasStatus(BodyDef.PLAYER_STATUS_WAITING)) || (this.hasStatus(BodyDef.PLAYER_STATUS_PAUSED)))
					{
						this._playStartTime = this.currentTime;
					}
					break;
			}
			this.clearLoadMovieStatus();
			this._isPlayRefreshed = false;
			this._player.loadMovie(param1);
			this.addStatus(BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE);
		}
		
		public function startLoad() : void
		{
			if((this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE)) && (this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) && !this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_START_LOAD) && !this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY))
			{
				this._player.startLoad();
				this.addStatus(BodyDef.PLAYER_STATUS_ALREADY_START_LOAD);
			}
		}
		
		public function stopLoad() : void
		{
			if((this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_START_LOAD)) || (this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY)))
			{
				this._player.stopLoad();
				this.removeStatus(BodyDef.PLAYER_STATUS_ALREADY_START_LOAD);
			}
		}
		
		public function play() : void
		{
			if((this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE)) && (this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) && !this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY) && !this.hasStatus(BodyDef.PLAYER_STATUS_FAILED))
			{
				this._log.debug("PlayerActor call play!");
				this._player.play();
				this.addStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY);
				if(this._player.hasStatus(StatusEnum.WAITING))
				{
					this._log.info("PlayerActor enter play,core cur status:waiting");
					this.addStatus(BodyDef.PLAYER_STATUS_WAITING);
				}
				else if(this._player.hasStatus(StatusEnum.SEEKING))
				{
					this._log.info("PlayerActor enter play,core cur status:seeking");
					this.addStatus(BodyDef.PLAYER_STATUS_SEEKING);
				}
				
				if(this._loadMovieType == BodyDef.LOAD_MOVIE_TYPE_SWITCH_TO_2D || this._loadMovieType == BodyDef.LOAD_MOVIE_TYPE_SWITCH_TO_3D)
				{
					if(this._playStartTime > 0)
					{
						this._log.info("PlayerActor play start execute playStartTime:" + this._playStartTime);
						this.resetFocusTipsMap();
						this._player.seek(this._playStartTime);
					}
				}
			}
		}
		
		public function pause(param1:int = 0) : void
		{
			if((this.hasStatus(BodyDef.PLAYER_STATUS_PLAYING)) || (this.hasStatus(BodyDef.PLAYER_STATUS_SEEKING)) || (this.hasStatus(BodyDef.PLAYER_STATUS_WAITING)))
			{
				this._player.pause(param1);
				this.addStatus(BodyDef.PLAYER_STATUS_PAUSED);
			}
		}
		
		public function resume() : void
		{
			if(this.hasStatus(BodyDef.PLAYER_STATUS_PAUSED))
			{
				this._player.resume();
				this.removeStatus(BodyDef.PLAYER_STATUS_PAUSED);
			}
		}
		
		public function seek(param1:uint, param2:int = 0) : void
		{
			if((this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE)) && (this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) && (this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY)))
			{
				if((this.hasStatus(BodyDef.PLAYER_STATUS_PLAYING)) || (this.hasStatus(BodyDef.PLAYER_STATUS_PAUSED)) || (this.hasStatus(BodyDef.PLAYER_STATUS_WAITING)) || (this.hasStatus(BodyDef.PLAYER_STATUS_SEEKING)))
				{
					if(!this._needTryWatchArrCheck && (this._player.isTryWatch) && this._player.tryWatchType == TryWatchEnum.PART)
					{
						if(this._player.tryWatchTime > 0 && this._player.currentTime < this._player.tryWatchTime)
						{
							this._needTryWatchArrCheck = true;
						}
					}
					this.resetFocusTipsMap();
					this._player.seek(param1,param2);
				}
			}
		}
		
		public function replay() : void
		{
			var _loc1:* = 0;
			if((this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE)) && (this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) && (this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY)) && !this.hasStatus(BodyDef.PLAYER_STATUS_STOPPING) && !this.hasStatus(BodyDef.PLAYER_STATUS_FAILED))
			{
				this._needTryWatchArrCheck = true;
				if(this.hasStatus(BodyDef.PLAYER_STATUS_STOPED))
				{
					this.resetFocusTipsMap();
					this._player.replay();
					if(this._isPreload)
					{
						this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_REPLAYED,null,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
					}
					else
					{
						this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_REPLAYED,null,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
					}
				}
				else if(this.movieModel)
				{
					_loc1 = 0;
					if((Settings.instance.skipTitle) && this.movieModel.titlesTime > 0)
					{
						_loc1 = this.movieModel.titlesTime;
					}
					this.resetFocusTipsMap();
					this._player.seek(_loc1);
				}
				
			}
		}
		
		public function refresh() : void
		{
			if(this._status.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY))
			{
				this._isPlayRefreshed = true;
			}
			if(this._playerStatusDelay)
			{
				TweenLite.killTweensOf(this.onAsyncPlayerStatusComplete,true);
				this._playerStatusDelay = null;
			}
			this._status.removeStatus(BodyDef.PLAYER_STATUS_ALREADY_READY);
			this._status.removeStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY);
			this._status.removeStatus(BodyDef.PLAYER_STATUS_ALREADY_START_LOAD);
			this._status.removeStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY);
			this._status.removeStatus(BodyDef.PLAYER_STATUS_LOAD_COMPLETE);
			this._status.removeStatus(BodyDef.PLAYER_STATUS_PLAYING);
			this._status.removeStatus(BodyDef.PLAYER_STATUS_PAUSED);
			this._status.removeStatus(BodyDef.PLAYER_STATUS_SEEKING);
			this._status.removeStatus(BodyDef.PLAYER_STATUS_WAITING);
			this._status.removeStatus(BodyDef.PLAYER_STATUS_STOPPING);
			this._status.removeStatus(BodyDef.PLAYER_STATUS_STOPED);
			this._status.removeStatus(BodyDef.PLAYER_STATUS_FAILED);
			this._needTryWatchArrCheck = true;
			if(this._isPreload)
			{
				this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_START_REFRESH,null,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
			}
			else
			{
				this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_START_REFRESH,null,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
			}
			this._player.refresh();
		}
		
		public function clearSurface() : void
		{
			this._player.clearSurface();
		}
		
		public function stop() : void
		{
			if(this._playerStatusDelay)
			{
				TweenLite.killTweensOf(this.onAsyncPlayerStatusComplete,true);
				this._playerStatusDelay = null;
			}
			this._needTryWatchArrCheck = true;
			this._player.stop();
			this.clearLoadMovieStatus();
		}
		
		public function setArea(param1:int, param2:int, param3:int, param4:int) : void
		{
			this._player.setArea(param1,param2,param3,param4);
		}
		
		public function setPuman(param1:Boolean) : void
		{
			this._player.setPuman(param1);
		}
		
		public function setZoom(param1:int) : void
		{
			this._player.setZoom(param1);
		}
		
		public function hasStatus(param1:int) : Boolean
		{
			return this._status.hasStatus(param1);
		}
		
		public function setADRemainTime(param1:int) : void
		{
			this._player.setADRemainTime(param1);
		}
		
		public function startLoadMeta() : void
		{
			this._player.startLoadMeta();
		}
		
		public function startLoadHistory() : void
		{
			this._player.startLoadHistory();
		}
		
		public function startLoadP2P() : void
		{
			this._player.startLoadP2PCore();
		}
		
		private function addStatus(param1:int, param2:Boolean = true) : void
		{
			if(param1 >= BodyDef.PLAYER_STATUS_BEGIN && param1 < BodyDef.PLAYER_STATUS_END && !this._status.hasStatus(param1))
			{
				switch(param1)
				{
					case BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE:
						this._status.removeStatus(BodyDef.PLAYER_STATUS_ALREADY_READY);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_ALREADY_START_LOAD);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_LOAD_COMPLETE);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_PLAYING);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_PAUSED);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_SEEKING);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_WAITING);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_STOPPING);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_STOPED);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_FAILED);
						break;
					case BodyDef.PLAYER_STATUS_ALREADY_READY:
						break;
					case BodyDef.PLAYER_STATUS_ALREADY_INFO_READY:
						break;
					case BodyDef.PLAYER_STATUS_ALREADY_START_LOAD:
						break;
					case BodyDef.PLAYER_STATUS_ALREADY_PLAY:
						break;
					case BodyDef.PLAYER_STATUS_LOAD_COMPLETE:
						break;
					case BodyDef.PLAYER_STATUS_PLAYING:
						this._status.removeStatus(BodyDef.PLAYER_STATUS_PAUSED);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_SEEKING);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_WAITING);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_STOPPING);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_STOPED);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_FAILED);
						break;
					case BodyDef.PLAYER_STATUS_PAUSED:
						this._status.removeStatus(BodyDef.PLAYER_STATUS_PLAYING);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_STOPPING);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_STOPED);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_FAILED);
						break;
					case BodyDef.PLAYER_STATUS_SEEKING:
						this._status.removeStatus(BodyDef.PLAYER_STATUS_PLAYING);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_WAITING);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_STOPPING);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_STOPED);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_FAILED);
						break;
					case BodyDef.PLAYER_STATUS_WAITING:
						this._status.removeStatus(BodyDef.PLAYER_STATUS_PLAYING);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_SEEKING);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_STOPPING);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_STOPED);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_FAILED);
						break;
					case BodyDef.PLAYER_STATUS_STOPPING:
						this._status.removeStatus(BodyDef.PLAYER_STATUS_PLAYING);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_PAUSED);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_SEEKING);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_WAITING);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_STOPED);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_FAILED);
						break;
					case BodyDef.PLAYER_STATUS_STOPED:
						this._status.removeStatus(BodyDef.PLAYER_STATUS_PLAYING);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_PAUSED);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_SEEKING);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_WAITING);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_STOPPING);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_FAILED);
						break;
					case BodyDef.PLAYER_STATUS_FAILED:
						this._status.removeStatus(BodyDef.PLAYER_STATUS_PLAYING);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_PAUSED);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_SEEKING);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_WAITING);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_STOPPING);
						this._status.removeStatus(BodyDef.PLAYER_STATUS_STOPED);
						break;
				}
				this._status.addStatus(param1);
				this._log.debug("Player Actor add status,status:" + param1 + ",isPreload:" + this._isPreload);
				if(param2)
				{
					if(this._isPreload)
					{
						this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_ADD_STATUS,param1,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
					}
					else
					{
						this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_ADD_STATUS,param1,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
					}
				}
			}
		}
		
		private function removeStatus(param1:int, param2:Boolean = true) : void
		{
			if(param1 >= BodyDef.PLAYER_STATUS_BEGIN && param1 < BodyDef.PLAYER_STATUS_END && (this._status.hasStatus(param1)))
			{
				switch(param1)
				{
					case BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE:
						break;
					case BodyDef.PLAYER_STATUS_ALREADY_READY:
						break;
					case BodyDef.PLAYER_STATUS_ALREADY_INFO_READY:
						break;
					case BodyDef.PLAYER_STATUS_ALREADY_START_LOAD:
						break;
					case BodyDef.PLAYER_STATUS_ALREADY_PLAY:
						break;
					case BodyDef.PLAYER_STATUS_LOAD_COMPLETE:
						break;
					case BodyDef.PLAYER_STATUS_PLAYING:
						break;
					case BodyDef.PLAYER_STATUS_PAUSED:
						break;
					case BodyDef.PLAYER_STATUS_SEEKING:
						break;
					case BodyDef.PLAYER_STATUS_WAITING:
						break;
					case BodyDef.PLAYER_STATUS_STOPPING:
						break;
					case BodyDef.PLAYER_STATUS_STOPED:
						break;
					case BodyDef.PLAYER_STATUS_FAILED:
						break;
				}
				this._status.removeStatus(param1);
				if(param2)
				{
					if(this._isPreload)
					{
						this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_REMOVE_STATUS,param1,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
					}
					else
					{
						this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_REMOVE_STATUS,param1,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
					}
				}
			}
		}
		
		private function resetFocusTipsMap() : void
		{
			var _loc1:Vector.<FocusTip> = null;
			var _loc2:* = 0;
			var _loc3:FocusTip = null;
			var _loc4:* = 0;
			this._focusTipsMap = new Dictionary();
			if(this._player.movieInfo)
			{
				_loc1 = this._player.movieInfo.focusTips;
				if(_loc1)
				{
					_loc2 = _loc1.length;
					_loc3 = null;
					_loc4 = 0;
					while(_loc4 < _loc2)
					{
						_loc3 = _loc1[_loc4] as FocusTip;
						if(_loc3)
						{
							this._focusTipsMap[_loc3] = false;
						}
						_loc4++;
					}
				}
			}
		}
		
		private function clearLoadMovieStatus() : void
		{
			this._status.removeStatus(BodyDef.PLAYER_STATUS_ALREADY_READY);
			this._status.removeStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY);
			this._status.removeStatus(BodyDef.PLAYER_STATUS_ALREADY_START_LOAD);
			this._status.removeStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY);
			this._status.removeStatus(BodyDef.PLAYER_STATUS_LOAD_COMPLETE);
			this._status.removeStatus(BodyDef.PLAYER_STATUS_PLAYING);
			this._status.removeStatus(BodyDef.PLAYER_STATUS_PAUSED);
			this._status.removeStatus(BodyDef.PLAYER_STATUS_SEEKING);
			this._status.removeStatus(BodyDef.PLAYER_STATUS_WAITING);
			this._status.removeStatus(BodyDef.PLAYER_STATUS_STOPPING);
			this._status.removeStatus(BodyDef.PLAYER_STATUS_STOPED);
			this._status.removeStatus(BodyDef.PLAYER_STATUS_FAILED);
			this.removeStatus(BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE);
		}
		
		private function asyncPlayerStatus(param1:int) : void
		{
			if(this._playerStatusDelay)
			{
				TweenLite.killTweensOf(this.onAsyncPlayerStatusComplete,true);
			}
			this._playerStatusDelay = TweenLite.delayedCall(0.03,this.onAsyncPlayerStatusComplete,[param1]);
		}
		
		private function onAsyncPlayerStatusComplete(param1:int) : void
		{
			this._playerStatusDelay = null;
			switch(param1)
			{
				case StatusEnum.ALREADY_READY:
					if(this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE))
					{
						if(this._player.movieInfo.ready)
						{
							this.resetFocusTipsMap();
							this.addStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY);
						}
						this.addStatus(BodyDef.PLAYER_STATUS_ALREADY_READY);
					}
					break;
				case StatusEnum.PLAYING:
					if(this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY))
					{
						this.addStatus(BodyDef.PLAYER_STATUS_PLAYING);
					}
					break;
				case StatusEnum.PAUSED:
					if(this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY))
					{
						this.addStatus(BodyDef.PLAYER_STATUS_PAUSED);
					}
					break;
				case StatusEnum.SEEKING:
					if(this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY))
					{
						this.addStatus(BodyDef.PLAYER_STATUS_SEEKING);
					}
					break;
				case StatusEnum.WAITING:
					if(this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY))
					{
						this.addStatus(BodyDef.PLAYER_STATUS_WAITING);
					}
					break;
				case StatusEnum.STOPPING:
					if(this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY))
					{
						if(this._player.stopReason == StopReasonEnum.SKIP_TRAILER || this._player.stopReason == StopReasonEnum.REACH_ASSIGN || this._player.stopReason == StopReasonEnum.STOP)
						{
							this.addStatus(BodyDef.PLAYER_STATUS_STOPPING);
						}
						else
						{
							this.addStatus(BodyDef.PLAYER_STATUS_STOPPING,false);
						}
					}
					break;
				case StatusEnum.STOPED:
					if(this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY))
					{
						if(this._player.stopReason == StopReasonEnum.SKIP_TRAILER || this._player.stopReason == StopReasonEnum.REACH_ASSIGN || this._player.stopReason == StopReasonEnum.STOP)
						{
							this.addStatus(BodyDef.PLAYER_STATUS_STOPED);
						}
						else
						{
							this.addStatus(BodyDef.PLAYER_STATUS_STOPED,false);
						}
					}
					break;
			}
		}
		
		private function onPlayerStatusChanged(param1:PlayerEvent) : void
		{
			if(!(param1.data.isAdd as Boolean))
			{
				return;
			}
			var _loc2:int = param1.data.status;
			if(_loc2 == StatusEnum.STOPPING)
			{
				this._playingDuration = this._player.playingDuration;
				this._waitingDuration = this._player.waitingDuration;
				if(this._player.movieModel)
				{
					if(this._player.stopReason == StopReasonEnum.SKIP_TRAILER || this._player.stopReason == StopReasonEnum.REACH_ASSIGN || this._player.stopReason == StopReasonEnum.STOP)
					{
						if(this._isPreload)
						{
							this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_UPDATE_OVER_BONUS,this._player.movieModel.duration,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
						}
						else
						{
							this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_UPDATE_OVER_BONUS,this._player.movieModel.duration,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
						}
					}
				}
			}
			this.asyncPlayerStatus(_loc2);
		}
		
		private function onPlayerError(param1:PlayerEvent) : void
		{
			if(this._playerStatusDelay)
			{
				TweenLite.killTweensOf(this.onAsyncPlayerStatusComplete,true);
				this._playerStatusDelay = null;
			}
			this._log.info("playe error,error code:" + this.errorCode + ", authenticationError:" + this.authenticationError + ", isPreload:" + this._isPreload);
			this.addStatus(BodyDef.PLAYER_STATUS_FAILED);
			if(this._isPreload)
			{
				this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_ERROR,null,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
			}
			else
			{
				this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_ERROR,null,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
			}
		}
		
		private function onPlayerDefinitionSwitched(param1:PlayerEvent) : void
		{
			if(this._isPreload)
			{
				this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_DEFINITION_SWITCHED,param1.data,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
			}
			else
			{
				this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_DEFINITION_SWITCHED,param1.data,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
			}
		}
		
		private function onPlayerAudioTrackSwitched(param1:PlayerEvent) : void
		{
			if(this._isPreload)
			{
				this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_AUDIOTRACK_SWITCHED,param1.data,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
			}
			else
			{
				this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_AUDIOTRACK_SWITCHED,param1.data,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
			}
		}
		
		private function onPlayerMovieInfoReady(param1:PlayerEvent) : void
		{
			if(this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE))
			{
				this.resetFocusTipsMap();
				this.addStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY);
			}
		}
		
		private function onPlayerGPUChanged(param1:PlayerEvent) : void
		{
			if(this._isPreload)
			{
				this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_GPU_CHANGED,param1.data,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
			}
			else
			{
				this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_GPU_CHANGED,param1.data,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
			}
		}
		
		private function onPlayerPreparePlayEnd(param1:PlayerEvent) : void
		{
			if(this._isPreload)
			{
				this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_PREPARE_PLAY_END,null,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
			}
			else
			{
				this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_PREPARE_PLAY_END,null,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
			}
		}
		
		private function onPlayerSkipTrailer(param1:PlayerEvent) : void
		{
			if(this._isPreload)
			{
				this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_SKIP_TRAILER,null,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
			}
			else
			{
				this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_SKIP_TRAILER,null,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
			}
		}
		
		private function onPlayerStartFromHistory(param1:PlayerEvent) : void
		{
			if(this._isPreload)
			{
				this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_START_FROM_HISTORY,param1.data,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
			}
			else
			{
				this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_START_FROM_HISTORY,param1.data,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
			}
		}
		
		private function onPlayerSkipTitle(param1:PlayerEvent) : void
		{
			if(this._isPreload)
			{
				this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_SKIP_TITLE,null,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
			}
			else
			{
				this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_SKIP_TITLE,null,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
			}
		}
		
		private function onPlayerStuck(param1:PlayerEvent) : void
		{
			if(this._isPreload)
			{
				this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_STUCK,null,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
			}
			else
			{
				this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_STUCK,null,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
			}
		}
		
		private function onPlayerEnterPrepareSkipPoint(param1:PlayerEvent) : void
		{
			if(this._isPreload)
			{
				this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_PREPARE_SKIP_POINT,param1.data,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
			}
			else
			{
				this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_PREPARE_SKIP_POINT,param1.data,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
			}
		}
		
		private function onPlayerOutPrepareSkipPoint(param1:PlayerEvent) : void
		{
		}
		
		private function onPlayerEnterSkipPoint(param1:PlayerEvent) : void
		{
			if(this._isPreload)
			{
				this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_ENTER_SKIP_POINT,param1.data,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
			}
			else
			{
				this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_ENTER_SKIP_POINT,param1.data,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
			}
		}
		
		private function onPreparePlayEndSkipPoint(param1:PlayerEvent) : void
		{
			if(this._isPreload)
			{
				this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_PRE_OUT_SKIP_POINT,param1.data,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
			}
			else
			{
				this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_PRE_OUT_SKIP_POINT,param1.data,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
			}
		}
		
		private function onPlayerOutSkipPoint(param1:PlayerEvent) : void
		{
			if(this._isPreload)
			{
				this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_OUT_SKIP_POINT,param1.data,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
			}
			else
			{
				this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_OUT_SKIP_POINT,param1.data,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
			}
		}
		
		private function onFreshedSkipPoints(param1:PlayerEvent) : void
		{
			if(this._isPreload)
			{
				this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_FRESHED_SKIP_POINT,param1.data,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
			}
			else
			{
				this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_FRESHED_SKIP_POINT,param1.data,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
			}
		}
		
		private function onEnterPrepareLeaveSkipPoint(param1:PlayerEvent) : void
		{
			if(this._isPreload)
			{
				this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_ENTER_LEAVE_SKIP_POINT,param1.data,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
			}
			else
			{
				this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_ENTER_LEAVE_SKIP_POINT,param1.data,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
			}
		}
		
		private function onOutPrepareLeaveSkipPoint(param1:PlayerEvent) : void
		{
			if(this._isPreload)
			{
				this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_OUT_LEAVE_SKIP_POINT,param1.data,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
			}
			else
			{
				this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_OUT_LEAVE_SKIP_POINT,param1.data,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
			}
		}
		
		private function onEnjoyableSubTypeInited(param1:PlayerEvent) : void
		{
			if(this._isPreload)
			{
				this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_ENJOY_TYPE_INITED,param1.data,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
			}
			else
			{
				this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_ENJOY_TYPE_INITED,param1.data,BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
			}
		}
		
		private function onTimer(param1:TimerEvent) : void
		{
			var _loc2:* = 0;
			var _loc3:* = 0;
			var _loc4:* = 0;
			var _loc5:* = 0;
			var _loc6:Object = null;
			var _loc7:Vector.<FocusTip> = null;
			var _loc8:* = 0;
			var _loc9:FocusTip = null;
			var _loc10:* = 0;
			if(!this._isPreload)
			{
				if((this._status.hasStatus(BodyDef.PLAYER_STATUS_PLAYING)) || (this._status.hasStatus(BodyDef.PLAYER_STATUS_SEEKING)) || (this._status.hasStatus(BodyDef.PLAYER_STATUS_WAITING)) || (this._status.hasStatus(BodyDef.PLAYER_STATUS_PAUSED)))
				{
					_loc2 = this.currentTime;
					_loc3 = this.bufferTime;
					_loc4 = this._player.movieModel.duration;
					_loc5 = this._player.playingDuration;
					_loc6 = new Object();
					_loc6.currentTime = _loc2;
					_loc6.bufferTime = _loc3;
					_loc6.duration = _loc4;
					_loc6.playingDuration = _loc5;
					this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_RUNNING,_loc6);
					if(this._player.loadComplete)
					{
						this.addStatus(BodyDef.PLAYER_STATUS_LOAD_COMPLETE);
					}
					else
					{
						this.removeStatus(BodyDef.PLAYER_STATUS_LOAD_COMPLETE);
					}
					if((this._status.hasStatus(BodyDef.PLAYER_STATUS_PLAYING)) && (this._focusTipsMap) && (this._player.movieInfo))
					{
						_loc7 = this._player.movieInfo.focusTips;
						if(_loc7)
						{
							_loc8 = _loc7.length;
							_loc9 = null;
							_loc10 = 0;
							while(_loc10 < _loc8)
							{
								_loc9 = _loc7[_loc10] as FocusTip;
								if((_loc9) && (int(_loc9.timestamp / 1000) == int(_loc2 / 1000)) && this._focusTipsMap[_loc9] == false)
								{
									this._focusTipsMap[_loc9] = true;
									this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_TO_FOCUS_TIP,_loc9);
								}
								_loc10++;
							}
						}
					}
					if((this._player.isTryWatch) && this._player.tryWatchType == TryWatchEnum.PART)
					{
						if((this._needTryWatchArrCheck) && this._player.tryWatchTime > 0 && _loc2 >= this._player.tryWatchTime)
						{
							this._log.info("PlayerActor check timer, arrive try watch time!");
							this._needTryWatchArrCheck = false;
							this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_ARRIVE_TRYWATCH_TIME);
						}
					}
				}
			}
		}
	}
}
