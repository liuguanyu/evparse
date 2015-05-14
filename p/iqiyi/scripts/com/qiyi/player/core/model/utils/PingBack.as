package com.qiyi.player.core.model.utils
{
	import com.qiyi.player.core.IDestroy;
	import com.qiyi.player.core.player.coreplayer.ICorePlayer;
	import com.qiyi.player.core.video.decoder.IDecoder;
	import flash.utils.Timer;
	import com.qiyi.player.base.logging.ILogger;
	import com.qiyi.player.core.player.def.PlayerUseTypeEnum;
	import com.qiyi.player.core.player.events.PlayerEvent;
	import flash.events.TimerEvent;
	import com.qiyi.player.core.model.def.PlayerTypeEnum;
	import com.qiyi.player.core.video.def.StopReasonEnum;
	import com.qiyi.player.base.pub.ProcessesTimeRecord;
	import flash.utils.getTimer;
	import com.qiyi.player.core.model.impls.pub.Statistics;
	import com.qiyi.player.core.player.def.StatusEnum;
	import loader.vod.P2PFileLoader;
	import com.qiyi.player.core.model.IMovie;
	import com.qiyi.player.core.model.impls.Segment;
	import com.qiyi.player.core.model.def.PingBackFlagEnum;
	import com.qiyi.player.core.Version;
	import com.qiyi.player.base.uuid.UUIDManager;
	import com.qiyi.player.user.impls.UserManager;
	import com.qiyi.player.core.model.def.PingBackPlayerActionEnum;
	import com.qiyi.player.core.model.def.ChannelEnum;
	import com.qiyi.player.core.model.def.StreamEnum;
	import flash.external.ExternalInterface;
	import com.qiyi.player.base.utils.MD5;
	import flash.net.URLRequest;
	import flash.net.sendToURL;
	import com.qiyi.player.base.logging.Log;
	
	public class PingBack extends Object implements IDestroy
	{
		
		private static const PING_BACK_ERR_URL:String = "http://msg.71.am/err.gif";
		
		private static const PING_BACK_URL:String = "http://msg.71.am/vpb.gif";
		
		private static const PING_SAVE_BANDWIDTH:String = "http://msg.71.am/vcache.gif";
		
		private static const PING_KA_URL:String = "http://uestat.video.qiyi.com/stat.html";
		
		private static const PING_TMP_STATS_URL:String = "http://msg.71.am/tmpstats.gif";
		
		private static var _visits:String = "";
		
		private static var _source:String = "";
		
		private static var _coop:String = "";
		
		private var _playListID:String = "";
		
		private var _VVFrom:String = "";
		
		private var _VFrm:String = "";
		
		private var _VVFromtp:String = "";
		
		private var _vfm:String = "";
		
		private var _src:String = "";
		
		private var _holder:ICorePlayer;
		
		private var _decoder:IDecoder;
		
		private var _playingMovieTVId:String;
		
		private var _activePlayMovieTVId:String;
		
		private var _startPlayLtm:int;
		
		private var _loadMovieTime:int;
		
		private var _bufferCount:int = 0;
		
		private var _timer1:Timer;
		
		private var _timer2:Timer;
		
		private var _timer3:Timer;
		
		private var _CDNStatistics:uint;
		
		private var _flashP2PErro:Boolean = false;
		
		private var _irs:IRS;
		
		private var _irsTvid:String = "";
		
		private var _irsPostponeUpdate:Boolean = false;
		
		private var _openBarrage:Boolean = false;
		
		private var _isStarBarrage:Boolean = false;
		
		private var _log:ILogger;
		
		private var _lastSecondDroppedFrames:int = 0;
		
		private var _droppedFramesSeconds:int = 0;
		
		private var _droppedFrames:int = 0;
		
		public function PingBack()
		{
			this._log = Log.getLogger("com.qiyi.player.core.model.utils.pingback.PingBack");
			super();
		}
		
		public function set loadMovieTime(param1:int) : void
		{
			this._loadMovieTime = param1;
		}
		
		public function set source(param1:String) : void
		{
			_source = param1;
		}
		
		public function set coop(param1:String) : void
		{
			_coop = param1;
		}
		
		public function set playListID(param1:String) : void
		{
			this._playListID = param1;
		}
		
		public function set VVFrom(param1:String) : void
		{
			this._VVFrom = param1;
		}
		
		public function set VFrm(param1:String) : void
		{
			this._VFrm = param1;
		}
		
		public function set VVFromtp(param1:String) : void
		{
			this._VVFromtp = param1;
		}
		
		public function set vfm(param1:String) : void
		{
			this._vfm = param1;
		}
		
		public function set src(param1:String) : void
		{
			this._src = param1;
		}
		
		public function set visits(param1:String) : void
		{
			_visits = param1;
		}
		
		public function set flashP2PErro(param1:Boolean) : void
		{
			this._flashP2PErro = param1;
		}
		
		public function set openBarrage(param1:Boolean) : void
		{
			this._openBarrage = param1;
		}
		
		public function set isStarBarrage(param1:Boolean) : void
		{
			this._isStarBarrage = param1;
		}
		
		public function initHolder(param1:ICorePlayer) : void
		{
			if(param1.runtimeData.playerUseType != PlayerUseTypeEnum.MAIN)
			{
				return;
			}
			if((param1) && this._holder == null)
			{
				this._holder = param1;
				this._holder.addEventListener(PlayerEvent.Evt_StatusChanged,this.onStatusChanged);
				this._timer1 = new Timer(1000);
				this._timer1.addEventListener(TimerEvent.TIMER,this.onTimer1);
			}
		}
		
		public function setReplay() : void
		{
			this._playingMovieTVId = "";
			this._activePlayMovieTVId = "";
			this.updateIRS();
		}
		
		public function setPreloadStatus(param1:Boolean) : void
		{
			if((this._irsPostponeUpdate) && !param1)
			{
				this.updateIRS();
				this._irsPostponeUpdate = false;
			}
		}
		
		public function startFlashP2PFailedCDN() : void
		{
			if(this._timer3 == null)
			{
				this._timer3 = new Timer(2 * 60 * 1000);
				this._timer3.addEventListener(TimerEvent.TIMER,this.onTimer3);
			}
			if(!this._timer3.running)
			{
				this._timer3.start();
			}
			this._CDNStatistics = 0;
		}
		
		public function stopFlashP2PFailedCDN() : void
		{
			if(this._timer3)
			{
				this._timer3.stop();
			}
			this._CDNStatistics = 0;
		}
		
		public function addCDNStatistics(param1:int) : void
		{
			if((this._holder && this._holder.movie) && (!this._holder.movie.member) && this._holder.runtimeData.playerType == PlayerTypeEnum.MAIN_STATION)
			{
				this._CDNStatistics = this._CDNStatistics + param1;
			}
		}
		
		private function onStatusChanged(param1:PlayerEvent) : void
		{
			if(param1.data.isAdd as Boolean)
			{
				switch(param1.data.status)
				{
					case StatusEnum.IDLE:
						break;
					case StatusEnum.ALREADY_READY:
						this._timer1.reset();
						this._bufferCount = 0;
						this.sendStartLoad();
						if(this._timer2 == null)
						{
							this._timer2 = new Timer(60000);
							this._timer2.addEventListener(TimerEvent.TIMER,this.onTimer2);
						}
						if((this._holder.movie) && !(this._irsTvid == this._holder.movie.tvid))
						{
							this._irsTvid = this._holder.movie.tvid;
							this.updateIRS();
						}
						break;
					case StatusEnum.STOPPING:
						this.setMovieStopTiming();
						if(this._holder.stopReason == StopReasonEnum.SKIP_TRAILER || this._holder.stopReason == StopReasonEnum.STOP || this._holder.stopReason == StopReasonEnum.REACH_ASSIGN)
						{
							this._playingMovieTVId = "";
							this._activePlayMovieTVId = "";
							this._irsTvid = "";
							this.sendStopPlay("t");
							if(this._timer2)
							{
								this._timer2.stop();
							}
							this.noticeIRSEnd();
							this.destroyIRS();
						}
						else if(this._holder.stopReason == StopReasonEnum.USER)
						{
							this._playingMovieTVId = "";
							this._activePlayMovieTVId = "";
							this._irsTvid = "";
							this.sendStopPlay("f");
							if(this._timer2)
							{
								this._timer2.stop();
							}
							this.noticeIRSEnd();
							this.destroyIRS();
						}
						else if(this._holder.stopReason == StopReasonEnum.REFRESH)
						{
							this.sendStopPlay("f");
						}
						
						
						break;
					case StatusEnum.FAILED:
						this.setMovieStopTiming();
						if((this._timer2) && (this._timer2.running))
						{
							this._timer2.stop();
						}
						ProcessesTimeRecord.needRecord = false;
						break;
					case StatusEnum.PLAYING:
						if(ProcessesTimeRecord.usedTime_showVideo == 0)
						{
						}
						if(ProcessesTimeRecord.needRecord)
						{
							this.sendProcessesTimeRecord();
						}
						if((this._holder.movie) && !(this._playingMovieTVId == this._holder.movie.tvid))
						{
							this._startPlayLtm = getTimer() - this._loadMovieTime;
							this._playingMovieTVId = this._holder.movie.tvid;
							this.sendStartPlay(String(int(this._startPlayLtm / 1000)));
							Statistics.instance.addVV();
						}
						this.noticeIRSPlay();
						if(!this._timer2.running)
						{
							this._timer2.start();
						}
						break;
					case StatusEnum.PAUSED:
						if(this._timer2.running)
						{
							this._timer2.stop();
						}
						this.noticeIRSPause();
						break;
					case StatusEnum.WAITING:
						this._bufferCount++;
						if(this._bufferCount == 3)
						{
							this.sendBuffer();
						}
						if(this._timer2.running)
						{
							this._timer2.stop();
						}
						this.noticeIRSPause();
						break;
					case StatusEnum.SEEKING:
						this.noticeIRSSeek();
						break;
				}
				if(this._holder.hasStatus(StatusEnum.PLAYING))
				{
					this._timer1.start();
				}
				else
				{
					this._timer1.stop();
				}
			}
		}
		
		private function onTimer2(param1:TimerEvent) : void
		{
			this.sendUEStatus();
			this._holder.runtimeData.bufferEmpty = 0;
		}
		
		private function onTimer1(param1:TimerEvent) : void
		{
			var _loc3:* = 0;
			if(this._holder.decoderInfo)
			{
				_loc3 = this._holder.decoderInfo.droppedFrames;
				if(!(_loc3 == this._lastSecondDroppedFrames) && _loc3 > this._lastSecondDroppedFrames)
				{
					if(_loc3 - this._lastSecondDroppedFrames >= 5)
					{
						this._droppedFramesSeconds++;
					}
					this._droppedFrames = this._droppedFrames + (_loc3 - this._lastSecondDroppedFrames);
					this._lastSecondDroppedFrames = _loc3;
				}
			}
			var _loc2:Number = 0;
			if(this._timer1.currentCount < 120)
			{
				if(this._timer1.currentCount == 15)
				{
					_loc2 = 15;
				}
				if(this._timer1.currentCount == 60)
				{
					_loc2 = 60;
				}
			}
			else if(this._timer1.currentCount % 120 == 0)
			{
				_loc2 = 120;
			}
			
			if(_loc2 != 0)
			{
				this.sendTiming(String(_loc2));
			}
			if(this._timer1.currentCount % 60 == 0)
			{
				this._droppedFramesSeconds = 0;
				this._droppedFrames = 0;
			}
		}
		
		private function setMovieStopTiming() : void
		{
			var _loc1:Number = 0;
			if(this._timer1.currentCount < 15)
			{
				_loc1 = this._timer1.currentCount;
			}
			else if(this._timer1.currentCount < 60 && this._timer1.currentCount > 15)
			{
				_loc1 = this._timer1.currentCount - 15;
			}
			else if(this._timer1.currentCount < 120 && this._timer1.currentCount > 60)
			{
				_loc1 = this._timer1.currentCount - 60;
			}
			else if(this._timer1.currentCount % 120 != 0)
			{
				_loc1 = this._timer1.currentCount % 120;
			}
			
			
			
			if(_loc1 != 0)
			{
				this.sendTiming(String(_loc1));
			}
			this._timer1.stop();
			this._timer1.reset();
		}
		
		private function onTimer3(param1:TimerEvent) : void
		{
			var _loc3:String = null;
			if(!P2PFileLoader.instance.isLoading && !P2PFileLoader.instance.loadDone && !P2PFileLoader.instance.loadErr)
			{
				return;
			}
			if(this._holder == null)
			{
				return;
			}
			var _loc2:IMovie = this._holder.movie;
			if(_loc2 == null)
			{
				return;
			}
			if(!_loc2.member && this._holder.runtimeData.playerType == PlayerTypeEnum.MAIN_STATION)
			{
				_loc3 = "http://msg.video.qiyi.com/vodpb.gif?tag=share&p2p=0" + "&cdn=" + this._CDNStatistics + "&md=cdn" + (this._flashP2PErro?"_err":"") + "&mi=" + _loc2.channelID + "_" + _loc2.albumId + "_" + _loc2.tvid + "_" + _loc2.vid + "&peerId=" + "&ran=" + Math.random();
				this._CDNStatistics = 0;
				this.fireData(_loc3);
			}
		}
		
		public function sendError(param1:int) : void
		{
			var _loc2:String = null;
			var _loc3:String = null;
			var _loc4:String = null;
			var _loc5:String = null;
			var _loc6:* = 0;
			var _loc7:String = null;
			var _loc8:String = null;
			var _loc9:IMovie = null;
			var _loc10:String = null;
			var _loc11:Segment = null;
			var _loc12:Object = null;
			if((this._holder) && param1 > 0)
			{
				_loc2 = "";
				_loc3 = "";
				_loc4 = "";
				_loc5 = "";
				_loc6 = 0;
				_loc7 = "";
				_loc8 = "";
				_loc9 = this._holder.movie;
				if(_loc9)
				{
					_loc2 = _loc9.channelID.toString();
					_loc3 = _loc9.tvid;
					if((_loc9.curDefinition) && (_loc9.curDefinition.type))
					{
						_loc8 = _loc9.curDefinition.type.id.toString();
					}
					if((this._holder.hasStatus(StatusEnum.PLAYING)) || (this._holder.hasStatus(StatusEnum.PAUSED)) || (this._holder.hasStatus(StatusEnum.SEEKING)) || (this._holder.hasStatus(StatusEnum.WAITING)))
					{
						_loc6 = int(this._holder.currentTime / 1000);
						_loc11 = _loc9.getSegmentByTime(this._holder.currentTime);
						if((_loc11) && (this._holder.runtimeData.userDisInfo))
						{
							_loc12 = this._holder.runtimeData.userDisInfo[_loc11.index];
							if(_loc12)
							{
								_loc4 = _loc12.t;
								_loc5 = _loc12.z;
							}
						}
					}
				}
				else
				{
					_loc3 = this._holder.runtimeData.tvid;
				}
				if((this._holder.runtimeData.errorCodeValue) && param1 == 104)
				{
					_loc7 = this._holder.runtimeData.errorCodeValue.st;
				}
				_loc10 = "?flag=" + PingBackFlagEnum.ERROR.name + "&plyrver=" + Version.VERSION + "&errcode=" + param1 + "&vrsrtcode=" + _loc7 + "&suid=" + this._holder.uuid + "&cid=" + _loc2 + "&tvid=" + _loc3 + "&pla=" + this._holder.runtimeData.platform.name + "&sttntp=" + this._holder.runtimeData.station.id.toString() + "&plyrtp=" + this._holder.runtimeData.playerType.id.toString() + "&z=" + _loc5 + "&diaoduuip=" + _loc4 + "&prgr=" + _loc6 + "&dwnldspd=" + this._holder.runtimeData.currentAverageSpeed + "&lev=" + _loc8 + "&as=" + this.getMD5Code(_loc3,this._holder.runtimeData.platform.name,this._holder.uuid,this._holder.videoEventID) + "&veid=" + this._holder.videoEventID + "&weid=" + UUIDManager.instance.getWebEventID() + "&puid=" + (UserManager.getInstance().user?UserManager.getInstance().user.passportID:"") + "&tn=" + String(Math.random());
				if(_coop != "")
				{
					_loc10 = _loc10 + ("&coop=" + _coop);
				}
				else if(_source != "")
				{
					_loc10 = _loc10 + ("&source=" + _source);
				}
				
				this.fireData(PING_BACK_ERR_URL + _loc10);
				this._log.info("Core PingBack,ErrorCode is " + param1);
			}
		}
		
		public function sendBuffer() : void
		{
			if(this._holder == null)
			{
				return;
			}
			var _loc1:String = "?flag=" + PingBackFlagEnum.PLAYER_ACT.name + "&plyract=" + PingBackPlayerActionEnum.BUFFER_EMPTY.name + this.commonParam();
			this.fireData(PING_BACK_URL + _loc1);
		}
		
		public function sendStartLoad() : void
		{
			if(this._holder == null)
			{
				return;
			}
			var _loc1:String = "?flag=" + PingBackFlagEnum.PLAYER_ACT.name + "&plyract=" + PingBackPlayerActionEnum.START_LOAD + "&prgr=" + int(this._holder.strategy.getStartTime());
			_loc1 = _loc1 + this.commonParam();
			this.fireData(PING_BACK_URL + _loc1);
		}
		
		public function sendStartPlay(param1:String) : void
		{
			if(this._holder == null)
			{
				return;
			}
			var _loc2:String = "?flag=" + PingBackFlagEnum.PLAYER_ACT.name + "&plyract=" + PingBackPlayerActionEnum.START_PLAY.name + "&prgr=" + int(this._holder.currentTime / 1000) + "&ltm=" + param1 + "&purl=" + this.getPageLocationHref() + "&vvfrmtp=" + this._VVFromtp + "&clltid=" + this._holder.runtimeData.collectionID + "&src=" + this._src + "&rfr=" + this.getPageReferrer() + this.commonParam();
			UUIDManager.instance.isNewUser = false;
			this.fireData(PING_BACK_URL + _loc2);
		}
		
		private function sendReady() : void
		{
			if(this._holder == null)
			{
				return;
			}
			var _loc1:String = "?flag=" + PingBackFlagEnum.PLAYER_ACT.name + "&plyract=" + PingBackPlayerActionEnum.READY.name + "&purl=" + this.getPageLocationHref() + "&vvfrmtp=" + this._VVFromtp + "&rfr=" + this.getPageReferrer() + this.commonParam();
			this.fireData(PING_BACK_URL + _loc1);
		}
		
		public function sendActivePlay() : void
		{
			var _loc1:String = null;
			if(this._holder == null)
			{
				return;
			}
			if((this._holder.movie) && !(this._activePlayMovieTVId == this._holder.movie.tvid))
			{
				this._activePlayMovieTVId = this._holder.movie.tvid;
				_loc1 = "?flag=" + PingBackFlagEnum.PLAYER_ACT.name + "&plyract=" + PingBackPlayerActionEnum.ACTIVE_PLAY.name + this.commonParam();
				this.fireData(PING_BACK_URL + _loc1);
			}
		}
		
		public function sendSaveBandWidth(param1:int, param2:int) : void
		{
			var url:String = null;
			var var_2:int = param1;
			var var_3:int = param2;
			if(this._holder == null || var_2 <= 0 || var_2 >= 360000)
			{
				return;
			}
			try
			{
				if(Math.abs(this._holder.currentTime - this._holder.runtimeData.startPlayTime) < 1000)
				{
					return;
				}
				url = PING_SAVE_BANDWIDTH;
				url = url + ("?pt=" + this._holder.runtimeData.playerType.id.toString());
				url = url + ("&cv=" + Version.VERSION);
				url = url + ("&cid=" + this._holder.movie.channelID.toString());
				url = url + ("&aid=" + this._holder.movie.albumId);
				url = url + ("&tvid=" + this._holder.movie.tvid);
				url = url + ("&lev=" + this._holder.movie.curDefinition.type.id);
				url = url + ("&dtl=" + int(var_2 / 1000).toString());
				url = url + ("&type=" + var_3.toString());
				this.fireData(url);
			}
			catch(e:Error)
			{
			}
		}
		
		public function sendStopPlay(param1:String = "") : void
		{
			if(this._holder == null)
			{
				return;
			}
			var _loc2:String = "?flag=" + PingBackFlagEnum.PLAYER_ACT.name + "&plyract=" + PingBackPlayerActionEnum.STOP_PLAY.name + "&prgr=" + int(this._holder.currentTime / 1000) + "&src=" + this._src + "&finish=" + param1 + this.commonParam();
			this.fireData(PING_BACK_URL + _loc2);
		}
		
		public function sendTiming(param1:String) : void
		{
			if(this._holder == null)
			{
				return;
			}
			var _loc2:String = "?flag=" + PingBackFlagEnum.PLAYER_ACT.name + "&plyract=" + PingBackPlayerActionEnum.TIMMING.name + "&prgr=" + int(this._holder.currentTime / 1000) + "&lostfrm=" + this._droppedFrames.toString() + "&lostfrmsec=" + this._droppedFramesSeconds.toString() + "&tl=" + param1 + "&src=" + this._src + "&purl=" + this.getPageLocationHref() + "&rfr=" + this.getPageReferrer() + this.commonParam();
			this.fireData(PING_BACK_URL + _loc2);
		}
		
		public function sendAutoDefinition(param1:int, param2:int) : void
		{
			if(this._holder == null)
			{
				return;
			}
			var _loc3:String = "?flag=" + PingBackFlagEnum.PLAYER_ACT.name + "&plyract=" + PingBackPlayerActionEnum.DOWN_DEFINITION.name + "&dwnfrom=" + param1 + "&dwnto=" + param2 + this.commonParam();
			this.fireData(PING_BACK_URL + _loc3);
		}
		
		private function sendComScorePing() : void
		{
			var c1:String = null;
			var c2:String = null;
			var c3:String = null;
			var c4:String = null;
			var c5:String = null;
			var c6:String = null;
			var c7:String = null;
			var c11:String = null;
			var cs_params:String = null;
			if(this._holder)
			{
				try
				{
					c1 = "1";
					c2 = "7290408";
					c3 = "";
					c4 = "11";
					c5 = "";
					c6 = "";
					c7 = "";
					c11 = this._holder.uuid;
					if(this._holder.movieInfo)
					{
						c7 = encodeURIComponent(this._holder.movieInfo.pageUrl);
					}
					if(this._holder.movieModel)
					{
						c3 = this._holder.movieModel.channelID.toString();
					}
					cs_params = "http://b.scorecardresearch.com/b?" + new Array("c1=",c1,"&c2=",c2,"&c3=",c3,"&c4=",c4,"&c5=",c5,"&c6=",c6,"&c7=",c7,"&c8=&c9=&c10=&c11=",c11).join("");
					this.fireData(cs_params);
				}
				catch(e:Error)
				{
				}
			}
			if(this._holder)
			{
				return;
			}
		}
		
		private function sendComScoreTWPing() : void
		{
			if((this._holder) && (this._holder.runtimeData.userArea))
			{
				if(this._holder.runtimeData.userArea.indexOf("OVERSEA|TW") != -1)
				{
					if(this._holder.movieModel)
					{
						if(this._holder.movieModel.channelID == ChannelEnum.PROGRAM.id)
						{
							this.fireData("http://b.scorecardresearch.com/p?c1=3&c2=17985150&c3=10102&c4=10102001&c5=10102001&c6=&c10=1&c11=10102&c13=100x100&c16=gen&cj=1&ax_fwd=1&rn=10102");
						}
						else if(this._holder.movieModel.channelID == ChannelEnum.VARIETY.id)
						{
							this.fireData("http://b.scorecardresearch.com/p?c1=3&c2=17985150&c3=10102&c4=10102001&c5=10102002&c6=&c10=1&c11=10102&c13=100x100&c16=gen&cj=1&ax_fwd=1&rn=10102");
						}
						else if(this._holder.movieModel.channelID == ChannelEnum.FILM.id)
						{
							this.fireData("http://b.scorecardresearch.com/p?c1=3&c2=17985150&c3=10102&c4=10102001&c5=10102003&c6=&c10=1&c11=10102&c13=100x100&c16=gen&cj=1&ax_fwd=1&rn=10102");
						}
						else if(this._holder.movieModel.channelID == ChannelEnum.CARTOON.id || this._holder.movieModel.channelID == ChannelEnum.CHILDREN.id || this._holder.movieModel.channelID == ChannelEnum.GAME.id)
						{
							this.fireData("http://b.scorecardresearch.com/p?c1=3&c2=17985150&c3=10102&c4=10102001&c5=10102004&c6=&c10=1&c11=10102&c13=100x100&c16=gen&cj=1&ax_fwd=1&rn=10102");
						}
						else
						{
							this.fireData("http://b.scorecardresearch.com/p?c1=3&c2=17985150&c3=10102&c4=10102001&c5=10102005&c6=&c10=1&c11=10102&c13=100x100&c16=gen&cj=1&ax_fwd=1&rn=10102");
						}
						
						
						
					}
				}
			}
		}
		
		public function sendVRSRequestTime(param1:int) : void
		{
			if(this._holder == null)
			{
				return;
			}
			var _loc2:String = "?flag=" + PingBackFlagEnum.PLAYER_ACT.name + "&plyract=" + PingBackPlayerActionEnum.VRS_REQUEST_TIME.name + "&vms=" + "1" + "&tl=" + param1 + this.commonParam();
			this.fireData(PING_BACK_URL + _loc2);
		}
		
		public function sendStartLoadVrs() : void
		{
			if(this._holder == null)
			{
				return;
			}
			var _loc1:String = "?flag=" + PingBackFlagEnum.PLAYER_ACT.name + "&plyract=" + PingBackPlayerActionEnum.VRS_START_LOAD.name;
			_loc1 = _loc1 + this.commonParam();
			this.fireData(PING_BACK_URL + _loc1);
		}
		
		private function sendProcessesTimeRecord() : void
		{
			var _loc1:String = null;
			if(this._holder == null)
			{
				return;
			}
			if(ProcessesTimeRecord.needRecord)
			{
				ProcessesTimeRecord.needRecord = false;
				_loc1 = "?type=plypfmc140109";
				if(ProcessesTimeRecord.usedTime_userInfo > 0)
				{
					_loc1 = _loc1 + ("&tm1=" + ProcessesTimeRecord.usedTime_userInfo + "," + ProcessesTimeRecord.STime_userInfo);
				}
				if(ProcessesTimeRecord.usedTime_P2PCore > 0)
				{
					_loc1 = _loc1 + ("&tm2=" + ProcessesTimeRecord.usedTime_P2PCore + "," + ProcessesTimeRecord.STime_P2PCore);
				}
				if(ProcessesTimeRecord.usedTime_VInfo > 0)
				{
					_loc1 = _loc1 + ("&tm3=" + ProcessesTimeRecord.usedTime_VInfo + "," + ProcessesTimeRecord.STime_VInfo);
				}
				if(ProcessesTimeRecord.usedTime_VP > 0)
				{
					_loc1 = _loc1 + ("&tm4=" + ProcessesTimeRecord.usedTime_VP + "," + ProcessesTimeRecord.STime_VP);
				}
				if(ProcessesTimeRecord.usedTime_VI > 0)
				{
					_loc1 = _loc1 + ("&tm5=" + ProcessesTimeRecord.usedTime_VI + "," + ProcessesTimeRecord.STime_VI);
				}
				if(ProcessesTimeRecord.usedTime_meta > 0)
				{
					_loc1 = _loc1 + ("&tm6=" + ProcessesTimeRecord.usedTime_meta + "," + ProcessesTimeRecord.STime_meta);
				}
				if(ProcessesTimeRecord.usedTime_history > 0)
				{
					_loc1 = _loc1 + ("&tm7=" + ProcessesTimeRecord.usedTime_history + "," + ProcessesTimeRecord.STime_history);
				}
				if(ProcessesTimeRecord.usedTime_pageShowVideo > 0 && ProcessesTimeRecord.usedTime_pageShowVideo < 120000 && ProcessesTimeRecord.usedTime_userInfo == 0)
				{
					_loc1 = _loc1 + ("&tm8=" + ProcessesTimeRecord.usedTime_pageShowVideo + ",0");
				}
				if(ProcessesTimeRecord.usedTime_showVideo > 0 && ProcessesTimeRecord.usedTime_showVideo < 60000 && ProcessesTimeRecord.usedTime_userInfo == 0)
				{
					_loc1 = _loc1 + ("&tm9=" + ProcessesTimeRecord.usedTime_showVideo + "," + ProcessesTimeRecord.STime_showVideo);
				}
				if(ProcessesTimeRecord.usedTime_vms > 0)
				{
					_loc1 = _loc1 + ("&tm10=" + ProcessesTimeRecord.usedTime_vms + "," + ProcessesTimeRecord.STime_vms);
				}
				if(ProcessesTimeRecord.usedTime_adInit > 0)
				{
					_loc1 = _loc1 + ("&tm11=" + ProcessesTimeRecord.usedTime_adInit + "," + ProcessesTimeRecord.STime_adInit);
				}
				if(ProcessesTimeRecord.usedTime_selfLoaded > 0 && ProcessesTimeRecord.usedTime_selfLoaded < 60000)
				{
					_loc1 = _loc1 + ("&tm12=" + ProcessesTimeRecord.usedTime_selfLoaded + ",0");
				}
				if(ProcessesTimeRecord.browserType)
				{
					_loc1 = _loc1 + ("&brs=" + ProcessesTimeRecord.browserType);
				}
				if(ProcessesTimeRecord.pageTmpltType)
				{
					_loc1 = _loc1 + ("&tmplt=" + ProcessesTimeRecord.pageTmpltType);
				}
				_loc1 = _loc1 + this.commonParam();
				this.fireData(PING_TMP_STATS_URL + _loc1);
			}
		}
		
		private function commonParam() : String
		{
			var _loc1:String = null;
			var _loc2:String = null;
			var _loc3:String = null;
			var _loc4:String = null;
			var _loc5:String = null;
			var _loc6:String = null;
			var _loc7:String = null;
			var _loc8:String = null;
			var _loc9:String = null;
			var _loc10:String = null;
			var _loc11:String = null;
			var _loc12:String = null;
			var _loc13:IMovie = null;
			var _loc14:String = null;
			var _loc15:String = null;
			var _loc16:String = null;
			var _loc17:String = null;
			var _loc18:String = null;
			var _loc19:Segment = null;
			var _loc20:Object = null;
			if(this._holder)
			{
				_loc1 = "";
				_loc2 = "";
				_loc3 = "";
				_loc4 = "";
				_loc5 = "";
				_loc6 = this._holder.uuid;
				_loc7 = UUIDManager.instance.isNewUser?"1":"0";
				_loc8 = "";
				_loc9 = "";
				_loc10 = "";
				_loc11 = "";
				_loc12 = "";
				_loc13 = this._holder.movie;
				if(_loc13)
				{
					_loc1 = _loc13.vid;
					_loc2 = _loc13.albumId;
					_loc5 = _loc13.tvid;
					_loc3 = _loc13.channelID.toString();
					_loc12 = _loc13.uploaderID;
					if((_loc13.curDefinition) && (_loc13.curDefinition.type))
					{
						_loc4 = _loc13.curDefinition.type.id.toString();
					}
					if((this._holder.hasStatus(StatusEnum.PLAYING)) || (this._holder.hasStatus(StatusEnum.PAUSED)) || (this._holder.hasStatus(StatusEnum.SEEKING)) || (this._holder.hasStatus(StatusEnum.WAITING)))
					{
						_loc19 = _loc13.getSegmentByTime(this._holder.currentTime);
						if((_loc19) && (this._holder.runtimeData.userDisInfo))
						{
							_loc20 = this._holder.runtimeData.userDisInfo[_loc19.index];
							if(_loc20)
							{
								_loc8 = _loc20.t;
								_loc9 = _loc20.z;
							}
						}
					}
					_loc10 = _loc13.member?"1":"0";
					_loc11 = _loc13.streamType == StreamEnum.RTMP?"1":"2";
				}
				else
				{
					_loc5 = this._holder.runtimeData.tvid;
					_loc1 = this._holder.runtimeData.vid;
				}
				_loc14 = this._holder.runtimeData.platform.name;
				_loc15 = this._holder.runtimeData.station.id.toString();
				_loc16 = this._holder.runtimeData.playerType.id.toString();
				_loc17 = Version.VERSION;
				_loc18 = "&aid=" + _loc2 + "&tvid=" + _loc5 + "&vid=" + _loc1 + "&cid=" + _loc3 + "&lev=" + _loc4 + "&puid=" + (UserManager.getInstance().user?UserManager.getInstance().user.passportID:"") + "&pru=" + (UserManager.getInstance().user?UserManager.getInstance().user.profileID:"") + "&veid=" + this._holder.videoEventID + "&weid=" + UUIDManager.instance.getWebEventID() + "&newusr=" + _loc7 + "&pla=" + _loc14 + "&visits=" + _visits + "&sttntp=" + _loc15 + "&plyrtp=" + _loc16 + "&plyrver=" + _loc17 + "&z=" + _loc9 + "&suid=" + _loc6 + "&diaoduuip=" + _loc8 + "&plid=" + this._playListID + "&vvfrom=" + this._VVFrom + "&vfrm=" + this._VFrm + "&vfm=" + this._vfm + "&restp=" + _loc11 + "&ispur=" + _loc10 + "&as=" + this.getMD5Code(_loc5,_loc14,_loc6,this._holder.videoEventID) + "&isdm=" + (this._openBarrage?"1":"0") + "&isstar=" + (this._isStarBarrage?"1":"0") + "&tn=" + String(Math.random());
				if(_coop != "")
				{
					_loc18 = _loc18 + ("&coop=" + _coop);
				}
				else if(_source != "")
				{
					_loc18 = _loc18 + ("&source=" + _source);
				}
				
				if((_loc12) && !(_loc12 == "0"))
				{
					_loc18 = _loc18 + ("&upderid=" + _loc12);
				}
				if(this._holder.runtimeData.playerType == PlayerTypeEnum.SHARE && !(this._holder.runtimeData.tg == ""))
				{
					_loc18 = _loc18 + ("&tg=" + this._holder.runtimeData.tg);
				}
				if((this._holder.runtimeData.movieIsMember) && (this._holder.authenticationResult) && (this._holder.authenticationResult.data) && (this._holder.authenticationResult.data.u))
				{
					_loc18 = _loc18 + ("&qy_uid=" + this._holder.authenticationResult.data.u);
					_loc18 = _loc18 + ("&qy_cid=" + this._holder.authenticationResult.data.cid);
					_loc18 = _loc18 + ("&qy_user_type=" + this._holder.authenticationResult.data.u_type);
					_loc18 = _loc18 + ("&qy_prv=" + this._holder.authenticationResult.data.prv);
					_loc18 = _loc18 + ("&qy_vip_level=" + this._holder.authenticationResult.data.v_level);
					_loc18 = _loc18 + ("&qy_chl_uid=" + this._holder.authenticationResult.data.chl_u);
				}
				return _loc18;
			}
			return "";
		}
		
		private function getPageReferrer() : String
		{
			var referrer:String = "";
			try
			{
				referrer = ExternalInterface.call("function(){return window.document.referrer;}");
				if(referrer)
				{
					referrer = encodeURIComponent(referrer);
				}
			}
			catch(e:Error)
			{
				referrer = "";
			}
			return referrer;
		}
		
		private function getPageLocationHref() : String
		{
			var location:String = "";
			try
			{
				location = ExternalInterface.call("function(){return window.location.href;}");
				if(location)
				{
					location = encodeURIComponent(location);
				}
			}
			catch(e:Error)
			{
				location = "";
			}
			return location;
		}
		
		public function sendUEStatus() : void
		{
			if(this._holder == null)
			{
				return;
			}
			if(this._holder.runtimeData.bufferEmpty == 0 && !this._holder.hasStatus(StatusEnum.PLAYING))
			{
				return;
			}
			var _loc1:String = PING_KA_URL;
			_loc1 = _loc1 + ("?pt=" + (this._holder.movie.streamType == StreamEnum.HTTP?"web":"fms"));
			_loc1 = _loc1 + ("&uid=" + this._holder.uuid);
			_loc1 = _loc1 + ("&vid=" + this._holder.movie.vid);
			_loc1 = _loc1 + ("&ds=" + this._holder.runtimeData.preDispatchArea);
			_loc1 = _loc1 + ("&ul=" + this._holder.runtimeData.currentUserArea);
			_loc1 = _loc1 + ("&bk=" + this._holder.runtimeData.bufferEmpty.toString());
			_loc1 = _loc1 + ("&tn=" + getTimer());
			this.fireData(_loc1);
		}
		
		private function getMD5Code(param1:String, param2:String, param3:String, param4:String) : String
		{
			return MD5.calculate(param1 + param2 + param3 + param4 + "gOzRI9CPVgObCIj0rpjuX1gOs");
		}
		
		private function fireData(param1:String) : void
		{
			var _loc2:URLRequest = null;
			if(this._holder)
			{
				_loc2 = new URLRequest();
				_loc2.url = param1;
				sendToURL(_loc2);
			}
		}
		
		private function updateIRS() : void
		{
			var t:uint = 0;
			if((this._holder) && (this._holder.movie))
			{
				if(this._holder.isPreload)
				{
					this._irsPostponeUpdate = true;
				}
				else
				{
					this.sendReady();
					try
					{
						t = getTimer();
						if(this._irs == null)
						{
							this._irs = new IRS();
							this._irs._IWT_Debug = false;
							if(this._holder.runtimeData.playerType == PlayerTypeEnum.MAIN_STATION)
							{
								this._irs._IWT_UAID = "UA-iqiyi-100009";
							}
							else
							{
								this._irs._IWT_UAID = "UA-iqiyi-100008";
							}
						}
						this._irs.IRS_NewPlay(this._holder.movie.tvid,int(this._holder.movie.duration / 1000),false,this._holder.runtimeData.originalVid,"",this._holder.uuid);
						this._log.info("IRS IRS_NewPlay Elapsed Time:" + (getTimer() - t) + "ms");
					}
					catch(e:Error)
					{
					}
					this._irsPostponeUpdate = false;
					this.sendComScoreTWPing();
					this.sendComScorePing();
				}
				if(this._holder.isPreload)
				{
				}
			}
			if((this._holder) && (this._holder.movie))
			{
				return;
			}
		}
		
		private function noticeIRSPlay() : void
		{
			if(this._irs)
			{
				try
				{
					this._irs.IRS_UserACT("play");
				}
				catch(e:Error)
				{
				}
			}
		}
		
		private function noticeIRSPause() : void
		{
			if(this._irs)
			{
				try
				{
					this._irs.IRS_UserACT("pause");
				}
				catch(e:Error)
				{
				}
			}
		}
		
		private function noticeIRSSeek() : void
		{
			if(this._irs)
			{
				try
				{
					this._irs.IRS_UserACT("drag");
				}
				catch(e:Error)
				{
				}
			}
		}
		
		private function noticeIRSEnd() : void
		{
			if(this._irs)
			{
				try
				{
					this._irs.IRS_UserACT("end");
				}
				catch(e:Error)
				{
				}
			}
		}
		
		private function destroyIRS() : void
		{
			if(this._irs)
			{
				try
				{
					this._irs.destroy();
				}
				catch(e:Error)
				{
				}
				this._irs = null;
			}
		}
		
		public function destroy() : void
		{
			this._playingMovieTVId = "";
			this._activePlayMovieTVId = "";
			this._bufferCount = 0;
			if(this._holder)
			{
				this._holder.removeEventListener(PlayerEvent.Evt_StatusChanged,this.onStatusChanged);
				this._holder = null;
			}
			if(this._timer1)
			{
				this._timer1.stop();
				this._timer1.removeEventListener(TimerEvent.TIMER,this.onTimer1);
				this._timer1 = null;
			}
			if(this._timer2)
			{
				this._timer2.removeEventListener(TimerEvent.TIMER,this.onTimer2);
				this._timer2.stop();
				this._timer2 = null;
			}
			if(this._timer3)
			{
				this._timer3.removeEventListener(TimerEvent.TIMER,this.onTimer3);
				this._timer3.stop();
				this._timer3 = null;
			}
			this.destroyIRS();
		}
	}
}
