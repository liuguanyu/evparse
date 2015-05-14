package com.qiyi.player.wonder.common.pingback
{
	import org.puremvc.as3.patterns.facade.Facade;
	import flash.net.URLRequest;
	import flash.net.sendToURL;
	import com.qiyi.player.base.uuid.UUIDManager;
	import com.qiyi.player.wonder.body.model.PlayerProxy;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.core.model.IMovieModel;
	import com.qiyi.player.core.model.IMovieInfo;
	import com.qiyi.player.user.impls.UserManager;
	import com.qiyi.player.wonder.common.config.FlashVarConfig;
	import com.qiyi.player.wonder.plugins.continueplay.model.ContinuePlayProxy;
	import com.qiyi.player.core.Version;
	import flash.system.Capabilities;
	import com.qiyi.player.wonder.common.config.SystemConfig;
	import flash.external.ExternalInterface;
	
	public class PingBack extends Object
	{
		
		private static const PING_BACK_URL:String = "http://msg.71.am/vpb.gif";
		
		private static const PING_BACK_TMPSTATS:String = "http://msg.71.am/tmpstats.gif";
		
		private static const PING_BACK_BARRAGE:String = "http://msg.71.am/b";
		
		private static const PlATFORM_TYPE:String = "11";
		
		private static var _instance:PingBack;
		
		private var _facade:Facade;
		
		private var _visits:String = "";
		
		private var _send140707ADInitFlag:Boolean = false;
		
		private var _send140708FStartFlag:Boolean = false;
		
		public function PingBack(param1:SingletonClass)
		{
			super();
		}
		
		public static function getInstance() : PingBack
		{
			if(_instance == null)
			{
				_instance = new PingBack(new SingletonClass());
			}
			return _instance;
		}
		
		public function set visits(param1:String) : void
		{
			this._visits = param1;
		}
		
		public function init(param1:Facade) : void
		{
			this._facade = param1;
		}
		
		private function pingRequestServer(param1:String, param2:Boolean = true) : void
		{
			var _loc3:URLRequest = new URLRequest();
			if(param2)
			{
				_loc3.url = param1 + "&tn=" + Math.random();
			}
			else
			{
				_loc3.url = param1;
			}
			sendToURL(_loc3);
		}
		
		private function publicURL() : String
		{
			var _loc1:String = UUIDManager.instance.isNewUser?"1":"0";
			var _loc2:* = "";
			var _loc3:* = "";
			var _loc4:* = "";
			var _loc5:* = "";
			var _loc6:* = "";
			var _loc7:* = "";
			var _loc8:* = "";
			var _loc9:* = "";
			var _loc10:* = "";
			var _loc11:PlayerProxy = this._facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc12:UserProxy = this._facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			var _loc13:IMovieModel = _loc11.curActor.movieModel;
			var _loc14:IMovieInfo = _loc11.curActor.movieInfo;
			if((_loc13) && (_loc14))
			{
				_loc2 = _loc13.vid;
				_loc3 = _loc13.tvid;
				_loc4 = _loc13.albumId;
				_loc5 = _loc13.channelID.toString();
				_loc6 = _loc14.pageUrl;
				_loc7 = _loc13.curDefinitionInfo.type.id.toString();
				_loc8 = _loc13.ctgId.toString();
				_loc10 = _loc11.curActor.movieModel.uploaderID;
			}
			else
			{
				_loc2 = "";
			}
			if(_loc2 != "")
			{
				_loc9 = _loc11.curActor.videoEventID;
			}
			var _loc15:String = UserManager.getInstance().user?UserManager.getInstance().user.passportID:"";
			var _loc16:String = UserManager.getInstance().user?UserManager.getInstance().user.profileID:"";
			var _loc17:String = _loc11.curActor.uuid;
			var _loc18:String = UUIDManager.instance.getWebEventID();
			var _loc19:* = "";
			_loc19 = "&newusr=" + _loc1 + "&vid=" + _loc2 + "&aid=" + _loc4 + "&tvid=" + _loc3 + "&cid=" + _loc5 + "&purl=" + encodeURIComponent(_loc6) + "&lev=" + _loc7 + "&puid=" + _loc15 + "&pru=" + _loc16 + "&suid=" + _loc17 + "&visits=" + this._visits + "&pla=" + PlATFORM_TYPE + "&weid=" + _loc18 + "&veid=" + _loc9 + "&coop=" + FlashVarConfig.coop + "&ctgid=" + _loc8 + "&plid=" + FlashVarConfig.playListID + "&vvfrom=" + FlashVarConfig.videoFrom + "&tn=" + String(Math.random());
			_loc19 = _loc19 + ((_loc10) && !(_loc10 == "0")?"&upderid=" + _loc10:"");
			return _loc19;
		}
		
		public function playStartPing() : void
		{
			this.environmentInfoPing();
		}
		
		public function recommendationPanelPing() : void
		{
			var _loc1:* = "";
			_loc1 = PING_BACK_URL + "?flag=" + PingBackDef.PLAYER_ACTION + "&plyract=" + PingBackDef.SHOW_RECOMMEND + this.publicURL();
			this.pingRequestServer(_loc1,false);
		}
		
		public function continuityPlayPing() : void
		{
			var _loc1:* = "";
			_loc1 = PING_BACK_URL + "?flag=" + PingBackDef.USER_ACTION + "&plyract=" + PingBackDef.CONTINUITY_PLAY + this.publicURL();
			this.pingRequestServer(_loc1,false);
		}
		
		public function cyclePlayPing(param1:String, param2:String) : void
		{
			var _loc3:* = "";
			_loc3 = PING_BACK_URL + "?flag=" + param1 + "&" + param2 + "=" + PingBackDef.CYCLE_PLAY + this.publicURL();
			this.pingRequestServer(_loc3,false);
		}
		
		public function userActionPing(param1:String, param2:int = -1) : void
		{
			var _loc3:* = "";
			if(param2 >= 0)
			{
				_loc3 = PING_BACK_URL + "?flag=" + PingBackDef.USER_ACTION + "&usract=" + param1 + "&prgr=" + int(param2 / 1000).toString() + this.publicURL();
			}
			else
			{
				_loc3 = PING_BACK_URL + "?flag=" + PingBackDef.USER_ACTION + "&usract=" + param1 + this.publicURL();
			}
			this.pingRequestServer(_loc3,false);
		}
		
		public function playerActionPing(param1:String, param2:String = "") : void
		{
			var _loc3:* = "";
			_loc3 = PING_BACK_URL + "?flag=" + PingBackDef.PLAYER_ACTION + "&plyract=" + param1 + this.publicURL();
			this.pingRequestServer(_loc3,false);
		}
		
		public function switchDefinition(param1:int, param2:int) : void
		{
			var _loc3:String = PING_BACK_URL + "?flag=" + PingBackDef.USER_ACTION + "&usract=" + PingBackDef.SWITCH_DEFINATION + "&from=" + param1 + "&to=" + param2 + this.publicURL();
			this.pingRequestServer(_loc3,false);
		}
		
		public function previewActionPing(param1:int) : void
		{
			var _loc2:int = param1 / 1000;
			var _loc3:* = "";
			_loc3 = PING_BACK_URL + "?flag=" + PingBackDef.USER_ACTION + "&usract=" + PingBackDef.PREVIEW_VIDEO + "&prvwt=" + _loc2 + this.publicURL();
			this.pingRequestServer(_loc3,false);
		}
		
		public function dragActionPing(param1:int, param2:int, param3:uint) : void
		{
			var _loc4:int = param1 / 1000;
			var _loc5:int = param2 / 1000;
			var _loc6:* = "";
			_loc6 = PING_BACK_URL + "?flag=" + PingBackDef.USER_ACTION + "&usract=" + PingBackDef.DRAG + "&from=" + _loc4 + "&isgrn=" + param3 + "&to=" + _loc5 + this.publicURL();
			this.pingRequestServer(_loc6,false);
		}
		
		public function scaleActionPing(param1:int) : void
		{
			var _loc2:* = "";
			_loc2 = PING_BACK_URL + "?flag=" + PingBackDef.USER_ACTION + "&usract=" + PingBackDef.SCALE + "&scale=" + (param1 == 0?"coverd":param1) + this.publicURL();
			this.pingRequestServer(_loc2,false);
		}
		
		public function recommendSelectionPing(param1:String, param2:String) : void
		{
			var _loc3:* = "";
			_loc3 = PING_BACK_URL + "?flag=" + PingBackDef.USER_ACTION + "&usract=" + PingBackDef.RECOMMENDATION_SELECTED + "&recselurl=" + param1 + "&recslctpos=" + param2 + this.publicURL();
			this.pingRequestServer(_loc3,false);
		}
		
		public function recommendClick4QiyuPing(param1:String, param2:String, param3:String, param4:String, param5:String, param6:String, param7:String) : void
		{
			var _loc8:PlayerProxy = this._facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc9:ContinuePlayProxy = this._facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
			var _loc10:UserProxy = this._facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			var _loc11:* = "";
			if(_loc9.taid != "")
			{
				_loc11 = _loc9.taid;
			}
			else
			{
				_loc11 = _loc8.curActor.movieModel != null?_loc8.curActor.movieModel.albumId:"";
			}
			var _loc12:* = "";
			if(_loc9.taid != "")
			{
				_loc12 = _loc9.tcid;
			}
			else
			{
				_loc12 = _loc8.curActor.movieModel != null?_loc8.curActor.movieModel.channelID.toString():"";
			}
			var _loc13:String = UserManager.getInstance().user?UserManager.getInstance().user.passportID:"";
			var _loc14:String = UserManager.getInstance().user?UserManager.getInstance().user.profileID:"";
			var _loc15:* = "";
			_loc15 = PING_BACK_TMPSTATS + "?type=recctplay20121226" + "&usract=userclick" + "&ppuid=" + _loc13 + "&pru=" + _loc14 + "&uid=" + _loc8.curActor.uuid + "&aid=" + _loc11 + "&event_id=" + param2 + "&cid=" + _loc12 + "&bkt=" + param3 + "&area=" + param4 + "&rank=" + param5 + "&url=" + param6 + "&taid=" + param1 + "&tcid=" + param7 + "&platform=" + PlATFORM_TYPE + "&plid=" + FlashVarConfig.playListID + "&vvfrom=" + FlashVarConfig.videoFrom + "&t=" + String(Math.random());
			var _loc16:String = _loc8.curActor.movieModel != null?_loc8.curActor.movieModel.uploaderID:"";
			_loc15 = _loc15 + ((_loc16) && !(_loc16 == "0")?"&upderid=" + _loc16:"");
			this.pingRequestServer(_loc15,false);
		}
		
		public function recommendLoadDoneSend(param1:String, param2:String, param3:String, param4:String) : void
		{
			var _loc5:PlayerProxy = this._facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc6:ContinuePlayProxy = this._facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
			var _loc7:UserProxy = this._facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			var _loc8:* = "";
			if(_loc6.taid != "")
			{
				_loc8 = _loc6.taid;
			}
			else
			{
				_loc8 = _loc5.curActor.movieModel != null?_loc5.curActor.movieModel.albumId:"";
			}
			var _loc9:* = "";
			if(_loc6.taid != "")
			{
				_loc9 = _loc6.tcid;
			}
			else
			{
				_loc9 = _loc5.curActor.movieModel != null?_loc5.curActor.movieModel.channelID.toString():"";
			}
			var _loc10:String = UserManager.getInstance().user?UserManager.getInstance().user.passportID:"";
			var _loc11:String = UserManager.getInstance().user?UserManager.getInstance().user.profileID:"";
			var _loc12:* = "";
			_loc12 = PING_BACK_TMPSTATS + "?type=recctplay20121226" + "&usract=show&ppuid=" + _loc10 + "&uid=" + _loc5.curActor.uuid + "&pru=" + _loc11 + "&aid=" + _loc8 + "&event_id=" + param2 + "&cid=" + _loc9 + "&bkt=" + param3 + "&area=" + param4 + "&platform=" + PlATFORM_TYPE + "&albumlist=" + param1 + "&t=" + String(Math.random());
			this.pingRequestServer(_loc12,false);
		}
		
		public function skipAD(param1:String, param2:String, param3:String, param4:String) : void
		{
			var _loc5:String = PING_BACK_TMPSTATS + "?type=skipad131210&pf=1&p=10&ppuid=" + param1 + "&flshuid=" + param2 + "&tvid=" + param3 + "&aid=" + param4 + "&tn=" + Math.random();
			this.pingRequestServer(_loc5,false);
		}
		
		public function floatPlayerPing() : void
		{
			var _loc1:* = "";
			_loc1 = PING_BACK_TMPSTATS + "?type=bodanvvtest" + "&isfloatplayer=" + FlashVarConfig.isFloatPlayer + this.publicURL();
			this.pingRequestServer(_loc1,false);
		}
		
		public function headmapPing() : void
		{
			var _loc1:* = "";
			_loc1 = PING_BACK_TMPSTATS + "?type=bodanvvtest" + "&isheadmap=" + FlashVarConfig.isheadmap + this.publicURL();
			this.pingRequestServer(_loc1,false);
		}
		
		public function videoSharePing(param1:String, param2:Number, param3:Number) : void
		{
			var _loc4:* = "";
			_loc4 = PING_BACK_URL + "?flag=" + PingBackDef.USER_ACTION + "&usract=" + PingBackDef.VIDEO_SHARE + "&shrtg=" + param1 + "&shrst=" + param2 + "&shret=" + param3 + this.publicURL();
			this.pingRequestServer(_loc4,false);
		}
		
		public function filterPing(param1:String) : void
		{
			var _loc2:* = "";
			_loc2 = PING_BACK_URL + "?flag=" + PingBackDef.USER_ACTION + "&usract=" + param1 + this.publicURL();
			this.pingRequestServer(_loc2,false);
		}
		
		public function nextPing() : void
		{
			var _loc1:* = "";
			_loc1 = PING_BACK_URL + "?flag=" + PingBackDef.USER_ACTION + "&usract=" + PingBackDef.NEXT + this.publicURL();
			this.pingRequestServer(_loc1,false);
		}
		
		public function videoLinkShowPing() : void
		{
			var _loc1:* = "";
			_loc1 = PING_BACK_URL + "?flag=" + PingBackDef.USER_ACTION + "&usract=" + PingBackDef.VIDEO_LINK_SHOW + this.publicURL();
			this.pingRequestServer(_loc1,false);
		}
		
		public function videoLinkUserClickPing() : void
		{
			var _loc1:* = "";
			_loc1 = PING_BACK_URL + "?flag=" + PingBackDef.USER_ACTION + "&usract=" + PingBackDef.VIDEO_LINK_CLICK + this.publicURL();
			this.pingRequestServer(_loc1,false);
		}
		
		public function environmentInfoPing() : void
		{
			var _loc1:* = "";
			var _loc2:Object = this.getBrowserMatch();
			if(_loc2)
			{
				_loc1 = _loc2.browser;
			}
			var _loc3:* = "";
			_loc3 = PING_BACK_URL + "?flag=" + PingBackDef.STU_ENV + "&plyrver=" + Version.VERSION + "&pla=" + PlATFORM_TYPE + "&os=" + Capabilities.os + "&browser=" + _loc1 + "&dpi=" + Capabilities.screenResolutionX + "X" + Capabilities.screenResolutionY + "&flashver=" + Capabilities.version + this.publicURL();
			this.pingRequestServer(_loc3,false);
		}
		
		public function startVisitsPing() : void
		{
			var _loc1:* = "";
			_loc1 = PING_BACK_URL + "?flag=" + PingBackDef.START_VISITS + this.publicURL();
			this.pingRequestServer(_loc1,false);
		}
		
		public function sendPlayerLoadSuccess(param1:String) : void
		{
			var _loc2:String = PING_BACK_TMPSTATS + "?type=yhls20130924&usract=jingyitest1" + "&url=" + this.getPageLocationHref() + "&ver=" + encodeURIComponent(Capabilities.version) + "&yhls=" + param1 + "&pla=" + PlATFORM_TYPE + "&tn=" + Math.random();
			this.pingRequestServer(_loc2,false);
		}
		
		public function sendBeforeADInit() : void
		{
			var _loc1:String = null;
			if(!this._send140707ADInitFlag)
			{
				this._send140707ADInitFlag = true;
				_loc1 = PING_BACK_TMPSTATS + "?type=yhls20130924&usract=140707adinit" + "&pla=" + PlATFORM_TYPE + "&tn=" + Math.random();
				this.pingRequestServer(_loc1,false);
			}
		}
		
		public function sendVideoStart() : void
		{
			var _loc1:String = null;
			if(!this._send140708FStartFlag)
			{
				this._send140708FStartFlag = true;
				_loc1 = PING_BACK_TMPSTATS + "?type=yhls20130924&usract=140708fstart" + "&pla=" + PlATFORM_TYPE + "&tn=" + Math.random();
				this.pingRequestServer(_loc1,false);
			}
		}
		
		public function sendFilmScore(param1:uint) : void
		{
			var _loc2:PlayerProxy = this._facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc3:ContinuePlayProxy = this._facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
			var _loc4:UserProxy = this._facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			var _loc5:* = "";
			if(_loc3.taid != "")
			{
				_loc5 = _loc3.tcid;
			}
			else
			{
				_loc5 = _loc2.curActor.movieModel != null?_loc2.curActor.movieModel.channelID.toString():"";
			}
			var _loc6:String = UserManager.getInstance().user?UserManager.getInstance().user.passportID:"";
			var _loc7:String = UserManager.getInstance().user?UserManager.getInstance().user.profileID:"";
			var _loc8:String = PING_BACK_TMPSTATS + "?usract=3" + "&type=user_rating_20141014" + "&ppuid=" + _loc6 + "&pru=" + _loc7 + "&uid=" + _loc2.curActor.uuid + "&platform=11" + "&taid=" + (_loc2.curActor.movieModel?_loc2.curActor.movieModel.tvid:"") + "&rate=" + param1 + "&src_code=1" + "&channel_id=" + _loc5 + "&rn=" + Math.random();
			this.pingRequestServer(_loc8,false);
		}
		
		public function sendFilmScoreRecommend(param1:uint) : void
		{
			var _loc2:PlayerProxy = this._facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc3:UserProxy = this._facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			var _loc4:String = UserManager.getInstance().user?UserManager.getInstance().user.passportID:"";
			var _loc5:String = UserManager.getInstance().user?UserManager.getInstance().user.profileID:"";
			var _loc6:String = SystemConfig.MOVIE_SCORE_URL + "set_score?ppuid=" + _loc4 + "&uid=" + _loc2.curActor.uuid + "&pru=" + _loc5 + "&entity_id=" + (_loc2.curActor.movieModel?_loc2.curActor.movieModel.tvid:"") + "&score=" + param1 + "&rn=" + Math.random();
			this.pingRequestServer(_loc6,false);
		}
		
		public function barrageDeleteInfo(param1:uint, param2:int) : void
		{
			var _loc3:String = PING_BACK_BARRAGE + "?block=tucao" + "&t=21" + "&vtime=" + param2 + "&rseat=140903_clr" + "&clrcnt=" + param1 + this.publicUrl_4_0() + "&rn=" + Math.random();
			this.pingRequestServer(_loc3,false);
		}
		
		public function userActionPing_4_0(param1:String) : void
		{
			var _loc2:String = PING_BACK_BARRAGE + "?rseat=" + param1 + "&t=20" + this.publicUrl_4_0() + "&rn=" + Math.random();
			this.pingRequestServer(_loc2,false);
		}
		
		public function showActionPing_4_0(param1:String) : void
		{
			var _loc2:String = PING_BACK_BARRAGE + "?block=" + param1 + "&t=21" + this.publicUrl_4_0() + "&rn=" + Math.random();
			this.pingRequestServer(_loc2,false);
		}
		
		public function noticeUserActionPing_4_0(param1:String, param2:String) : void
		{
			var _loc3:String = PING_BACK_BARRAGE + "?rseat=" + param1 + "&noticeid=" + param2 + "&t=20" + this.publicUrl_4_0() + "&rn=" + Math.random();
			this.pingRequestServer(_loc3,false);
		}
		
		public function noticeShowActionPing_4_0(param1:String, param2:String) : void
		{
			var _loc3:String = PING_BACK_BARRAGE + "?block=" + param1 + "&noticeid=" + param2 + "&t=21" + this.publicUrl_4_0() + "&rn=" + Math.random();
			this.pingRequestServer(_loc3,false);
		}
		
		private function publicUrl_4_0() : String
		{
			var _loc1:PlayerProxy = this._facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2:UserProxy = this._facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			var _loc3:IMovieModel = _loc1.curActor.movieModel;
			var _loc4:IMovieInfo = _loc1.curActor.movieInfo;
			var _loc5:* = "";
			var _loc6:Number = 0;
			var _loc7:* = "";
			var _loc8:String = UserManager.getInstance().user?UserManager.getInstance().user.passportID:"";
			var _loc9:String = UserManager.getInstance().user?UserManager.getInstance().user.profileID:"";
			if((_loc3) && (_loc4))
			{
				_loc5 = _loc3.tvid;
				_loc6 = _loc3.duration;
				_loc7 = _loc3.channelID.toString();
			}
			var _loc10:String = "&pf=1" + "&bstp=0" + "&p=10" + "&p1=101" + "&u=" + _loc1.curActor.uuid + "&pu=" + _loc8 + "&pru=" + _loc9 + "&qpid=" + _loc5 + "&c1=" + _loc7 + "&tm=" + _loc6;
			return _loc10;
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
		
		private function getBrowserMatch() : Object
		{
			var browserAgent:String = null;
			var ua:String = null;
			var ropera:RegExp = null;
			var rmsie:RegExp = null;
			var rmozilla:RegExp = null;
			var match:Object = null;
			try
			{
				browserAgent = ExternalInterface.call("function BrowserAgent(){return navigator.userAgent;}");
				ua = browserAgent?browserAgent:"";
				ropera = new RegExp("(opera)(?:.*version)?[ \\/]([\\w.]+)","i");
				rmsie = new RegExp("(msie) ([\\w.]+)","i");
				rmozilla = new RegExp("(mozilla)(?:.*? rv:([\\w.]+))?","i");
				match = new RegExp("(webkit)[ \\/]([\\w.]+)","i").exec(ua) || ropera.exec(ua) || rmsie.exec(ua) || ua.indexOf("compatible") < 0 && rmozilla.exec(ua) || [];
				return {
					"browser":match[1] || "",
					"version":match[2] || "0"
				};
			}
			catch(error:Error)
			{
			}
			return null;
		}
	}
}

class SingletonClass extends Object
{
	
	function SingletonClass()
	{
		super();
	}
}
