package com.qiyi.player.wonder.common.pingback {
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
	
	public class PingBack extends Object {
		
		public function PingBack(param1:SingletonClass) {
			super();
		}
		
		private static const PING_BACK_URL:String = "http://msg.71.am/vpb.gif";
		
		private static const PING_BACK_TMPSTATS:String = "http://msg.71.am/tmpstats.gif";
		
		private static const PING_BACK_BARRAGE:String = "http://msg.71.am/b";
		
		private static const PlATFORM_TYPE:String = "11";
		
		private static var _instance:PingBack;
		
		public static function getInstance() : PingBack {
			if(_instance == null) {
				_instance = new PingBack(new SingletonClass());
			}
			return _instance;
		}
		
		private var _facade:Facade;
		
		private var _visits:String = "";
		
		private var _send140707ADInitFlag:Boolean = false;
		
		private var _send140708FStartFlag:Boolean = false;
		
		public function set visits(param1:String) : void {
			this._visits = param1;
		}
		
		public function init(param1:Facade) : void {
			this._facade = param1;
		}
		
		private function pingRequestServer(param1:String, param2:Boolean = true) : void {
			var _loc3_:URLRequest = new URLRequest();
			if(param2) {
				_loc3_.url = param1 + "&tn=" + Math.random();
			} else {
				_loc3_.url = param1;
			}
			sendToURL(_loc3_);
		}
		
		private function publicURL() : String {
			var _loc1_:String = UUIDManager.instance.isNewUser?"1":"0";
			var _loc2_:* = "";
			var _loc3_:* = "";
			var _loc4_:* = "";
			var _loc5_:* = "";
			var _loc6_:* = "";
			var _loc7_:* = "";
			var _loc8_:* = "";
			var _loc9_:* = "";
			var _loc10_:* = "";
			var _loc11_:PlayerProxy = this._facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc12_:UserProxy = this._facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			var _loc13_:IMovieModel = _loc11_.curActor.movieModel;
			var _loc14_:IMovieInfo = _loc11_.curActor.movieInfo;
			if((_loc13_) && (_loc14_)) {
				_loc2_ = _loc13_.vid;
				_loc3_ = _loc13_.tvid;
				_loc4_ = _loc13_.albumId;
				_loc5_ = _loc13_.channelID.toString();
				_loc6_ = _loc14_.pageUrl;
				_loc7_ = _loc13_.curDefinitionInfo.type.id.toString();
				_loc8_ = _loc13_.ctgId.toString();
				_loc10_ = _loc11_.curActor.movieModel.uploaderID;
			} else {
				_loc2_ = "";
			}
			if(_loc2_ != "") {
				_loc9_ = _loc11_.curActor.videoEventID;
			}
			var _loc15_:String = UserManager.getInstance().user?UserManager.getInstance().user.passportID:"";
			var _loc16_:String = UserManager.getInstance().user?UserManager.getInstance().user.profileID:"";
			var _loc17_:String = _loc11_.curActor.uuid;
			var _loc18_:String = UUIDManager.instance.getWebEventID();
			var _loc19_:* = "";
			_loc19_ = "&newusr=" + _loc1_ + "&vid=" + _loc2_ + "&aid=" + _loc4_ + "&tvid=" + _loc3_ + "&cid=" + _loc5_ + "&purl=" + encodeURIComponent(_loc6_) + "&lev=" + _loc7_ + "&puid=" + _loc15_ + "&pru=" + _loc16_ + "&suid=" + _loc17_ + "&visits=" + this._visits + "&pla=" + PlATFORM_TYPE + "&weid=" + _loc18_ + "&veid=" + _loc9_ + "&coop=" + FlashVarConfig.coop + "&ctgid=" + _loc8_ + "&plid=" + FlashVarConfig.playListID + "&vvfrom=" + FlashVarConfig.videoFrom + "&tn=" + String(Math.random());
			_loc19_ = _loc19_ + ((_loc10_) && !(_loc10_ == "0")?"&upderid=" + _loc10_:"");
			return _loc19_;
		}
		
		public function playStartPing() : void {
			this.environmentInfoPing();
		}
		
		public function recommendationPanelPing() : void {
			var _loc1_:* = "";
			_loc1_ = PING_BACK_URL + "?flag=" + PingBackDef.PLAYER_ACTION + "&plyract=" + PingBackDef.SHOW_RECOMMEND + this.publicURL();
			this.pingRequestServer(_loc1_,false);
		}
		
		public function continuityPlayPing() : void {
			var _loc1_:* = "";
			_loc1_ = PING_BACK_URL + "?flag=" + PingBackDef.USER_ACTION + "&plyract=" + PingBackDef.CONTINUITY_PLAY + this.publicURL();
			this.pingRequestServer(_loc1_,false);
		}
		
		public function cyclePlayPing(param1:String, param2:String) : void {
			var _loc3_:* = "";
			_loc3_ = PING_BACK_URL + "?flag=" + param1 + "&" + param2 + "=" + PingBackDef.CYCLE_PLAY + this.publicURL();
			this.pingRequestServer(_loc3_,false);
		}
		
		public function userActionPing(param1:String, param2:int = -1) : void {
			var _loc3_:* = "";
			if(param2 >= 0) {
				_loc3_ = PING_BACK_URL + "?flag=" + PingBackDef.USER_ACTION + "&usract=" + param1 + "&prgr=" + int(param2 / 1000).toString() + this.publicURL();
			} else {
				_loc3_ = PING_BACK_URL + "?flag=" + PingBackDef.USER_ACTION + "&usract=" + param1 + this.publicURL();
			}
			this.pingRequestServer(_loc3_,false);
		}
		
		public function playerActionPing(param1:String, param2:String = "") : void {
			var _loc3_:* = "";
			_loc3_ = PING_BACK_URL + "?flag=" + PingBackDef.PLAYER_ACTION + "&plyract=" + param1 + this.publicURL();
			this.pingRequestServer(_loc3_,false);
		}
		
		public function switchDefinition(param1:int, param2:int) : void {
			var _loc3_:String = PING_BACK_URL + "?flag=" + PingBackDef.USER_ACTION + "&usract=" + PingBackDef.SWITCH_DEFINATION + "&from=" + param1 + "&to=" + param2 + this.publicURL();
			this.pingRequestServer(_loc3_,false);
		}
		
		public function previewActionPing(param1:int) : void {
			var _loc2_:int = param1 / 1000;
			var _loc3_:* = "";
			_loc3_ = PING_BACK_URL + "?flag=" + PingBackDef.USER_ACTION + "&usract=" + PingBackDef.PREVIEW_VIDEO + "&prvwt=" + _loc2_ + this.publicURL();
			this.pingRequestServer(_loc3_,false);
		}
		
		public function dragActionPing(param1:int, param2:int, param3:uint) : void {
			var _loc4_:int = param1 / 1000;
			var _loc5_:int = param2 / 1000;
			var _loc6_:* = "";
			_loc6_ = PING_BACK_URL + "?flag=" + PingBackDef.USER_ACTION + "&usract=" + PingBackDef.DRAG + "&from=" + _loc4_ + "&isgrn=" + param3 + "&to=" + _loc5_ + this.publicURL();
			this.pingRequestServer(_loc6_,false);
		}
		
		public function scaleActionPing(param1:int) : void {
			var _loc2_:* = "";
			_loc2_ = PING_BACK_URL + "?flag=" + PingBackDef.USER_ACTION + "&usract=" + PingBackDef.SCALE + "&scale=" + (param1 == 0?"coverd":param1) + this.publicURL();
			this.pingRequestServer(_loc2_,false);
		}
		
		public function recommendSelectionPing(param1:String, param2:String) : void {
			var _loc3_:* = "";
			_loc3_ = PING_BACK_URL + "?flag=" + PingBackDef.USER_ACTION + "&usract=" + PingBackDef.RECOMMENDATION_SELECTED + "&recselurl=" + param1 + "&recslctpos=" + param2 + this.publicURL();
			this.pingRequestServer(_loc3_,false);
		}
		
		public function recommendClick4QiyuPing(param1:String, param2:String, param3:String, param4:String, param5:String, param6:String, param7:String) : void {
			var _loc8_:PlayerProxy = this._facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc9_:ContinuePlayProxy = this._facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
			var _loc10_:UserProxy = this._facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			var _loc11_:* = "";
			if(_loc9_.taid != "") {
				_loc11_ = _loc9_.taid;
			} else {
				_loc11_ = _loc8_.curActor.movieModel != null?_loc8_.curActor.movieModel.albumId:"";
			}
			var _loc12_:* = "";
			if(_loc9_.taid != "") {
				_loc12_ = _loc9_.tcid;
			} else {
				_loc12_ = _loc8_.curActor.movieModel != null?_loc8_.curActor.movieModel.channelID.toString():"";
			}
			var _loc13_:String = UserManager.getInstance().user?UserManager.getInstance().user.passportID:"";
			var _loc14_:String = UserManager.getInstance().user?UserManager.getInstance().user.profileID:"";
			var _loc15_:* = "";
			_loc15_ = PING_BACK_TMPSTATS + "?type=recctplay20121226" + "&usract=userclick" + "&ppuid=" + _loc13_ + "&pru=" + _loc14_ + "&uid=" + _loc8_.curActor.uuid + "&aid=" + _loc11_ + "&event_id=" + param2 + "&cid=" + _loc12_ + "&bkt=" + param3 + "&area=" + param4 + "&rank=" + param5 + "&url=" + param6 + "&taid=" + param1 + "&tcid=" + param7 + "&platform=" + PlATFORM_TYPE + "&plid=" + FlashVarConfig.playListID + "&vvfrom=" + FlashVarConfig.videoFrom + "&t=" + String(Math.random());
			var _loc16_:String = _loc8_.curActor.movieModel != null?_loc8_.curActor.movieModel.uploaderID:"";
			_loc15_ = _loc15_ + ((_loc16_) && !(_loc16_ == "0")?"&upderid=" + _loc16_:"");
			this.pingRequestServer(_loc15_,false);
		}
		
		public function recommendLoadDoneSend(param1:String, param2:String, param3:String, param4:String) : void {
			var _loc5_:PlayerProxy = this._facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc6_:ContinuePlayProxy = this._facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
			var _loc7_:UserProxy = this._facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			var _loc8_:* = "";
			if(_loc6_.taid != "") {
				_loc8_ = _loc6_.taid;
			} else {
				_loc8_ = _loc5_.curActor.movieModel != null?_loc5_.curActor.movieModel.albumId:"";
			}
			var _loc9_:* = "";
			if(_loc6_.taid != "") {
				_loc9_ = _loc6_.tcid;
			} else {
				_loc9_ = _loc5_.curActor.movieModel != null?_loc5_.curActor.movieModel.channelID.toString():"";
			}
			var _loc10_:String = UserManager.getInstance().user?UserManager.getInstance().user.passportID:"";
			var _loc11_:String = UserManager.getInstance().user?UserManager.getInstance().user.profileID:"";
			var _loc12_:* = "";
			_loc12_ = PING_BACK_TMPSTATS + "?type=recctplay20121226" + "&usract=show&ppuid=" + _loc10_ + "&uid=" + _loc5_.curActor.uuid + "&pru=" + _loc11_ + "&aid=" + _loc8_ + "&event_id=" + param2 + "&cid=" + _loc9_ + "&bkt=" + param3 + "&area=" + param4 + "&platform=" + PlATFORM_TYPE + "&albumlist=" + param1 + "&t=" + String(Math.random());
			this.pingRequestServer(_loc12_,false);
		}
		
		public function skipAD(param1:String, param2:String, param3:String, param4:String) : void {
			var _loc5_:String = PING_BACK_TMPSTATS + "?type=skipad131210&pf=1&p=10&ppuid=" + param1 + "&flshuid=" + param2 + "&tvid=" + param3 + "&aid=" + param4 + "&tn=" + Math.random();
			this.pingRequestServer(_loc5_,false);
		}
		
		public function floatPlayerPing() : void {
			var _loc1_:* = "";
			_loc1_ = PING_BACK_TMPSTATS + "?type=bodanvvtest" + "&isfloatplayer=" + FlashVarConfig.isFloatPlayer + this.publicURL();
			this.pingRequestServer(_loc1_,false);
		}
		
		public function headmapPing() : void {
			var _loc1_:* = "";
			_loc1_ = PING_BACK_TMPSTATS + "?type=bodanvvtest" + "&isheadmap=" + FlashVarConfig.isheadmap + this.publicURL();
			this.pingRequestServer(_loc1_,false);
		}
		
		public function videoSharePing(param1:String, param2:Number, param3:Number) : void {
			var _loc4_:* = "";
			_loc4_ = PING_BACK_URL + "?flag=" + PingBackDef.USER_ACTION + "&usract=" + PingBackDef.VIDEO_SHARE + "&shrtg=" + param1 + "&shrst=" + param2 + "&shret=" + param3 + this.publicURL();
			this.pingRequestServer(_loc4_,false);
		}
		
		public function filterPing(param1:String) : void {
			var _loc2_:* = "";
			_loc2_ = PING_BACK_URL + "?flag=" + PingBackDef.USER_ACTION + "&usract=" + param1 + this.publicURL();
			this.pingRequestServer(_loc2_,false);
		}
		
		public function nextPing() : void {
			var _loc1_:* = "";
			_loc1_ = PING_BACK_URL + "?flag=" + PingBackDef.USER_ACTION + "&usract=" + PingBackDef.NEXT + this.publicURL();
			this.pingRequestServer(_loc1_,false);
		}
		
		public function videoLinkShowPing() : void {
			var _loc1_:* = "";
			_loc1_ = PING_BACK_URL + "?flag=" + PingBackDef.USER_ACTION + "&usract=" + PingBackDef.VIDEO_LINK_SHOW + this.publicURL();
			this.pingRequestServer(_loc1_,false);
		}
		
		public function videoLinkUserClickPing() : void {
			var _loc1_:* = "";
			_loc1_ = PING_BACK_URL + "?flag=" + PingBackDef.USER_ACTION + "&usract=" + PingBackDef.VIDEO_LINK_CLICK + this.publicURL();
			this.pingRequestServer(_loc1_,false);
		}
		
		public function environmentInfoPing() : void {
			var _loc1_:* = "";
			var _loc2_:Object = this.getBrowserMatch();
			if(_loc2_) {
				_loc1_ = _loc2_.browser;
			}
			var _loc3_:* = "";
			_loc3_ = PING_BACK_URL + "?flag=" + PingBackDef.STU_ENV + "&plyrver=" + Version.VERSION + "&pla=" + PlATFORM_TYPE + "&os=" + Capabilities.os + "&browser=" + _loc1_ + "&dpi=" + Capabilities.screenResolutionX + "X" + Capabilities.screenResolutionY + "&flashver=" + Capabilities.version + this.publicURL();
			this.pingRequestServer(_loc3_,false);
		}
		
		public function startVisitsPing() : void {
			var _loc1_:* = "";
			_loc1_ = PING_BACK_URL + "?flag=" + PingBackDef.START_VISITS + this.publicURL();
			this.pingRequestServer(_loc1_,false);
		}
		
		public function sendPlayerLoadSuccess(param1:String) : void {
			var _loc2_:String = PING_BACK_TMPSTATS + "?type=yhls20130924&usract=jingyitest1" + "&url=" + this.getPageLocationHref() + "&ver=" + encodeURIComponent(Capabilities.version) + "&yhls=" + param1 + "&pla=" + PlATFORM_TYPE + "&tn=" + Math.random();
			this.pingRequestServer(_loc2_,false);
		}
		
		public function sendBeforeADInit() : void {
			var _loc1_:String = null;
			if(!this._send140707ADInitFlag) {
				this._send140707ADInitFlag = true;
				_loc1_ = PING_BACK_TMPSTATS + "?type=yhls20130924&usract=140707adinit" + "&pla=" + PlATFORM_TYPE + "&tn=" + Math.random();
				this.pingRequestServer(_loc1_,false);
			}
		}
		
		public function sendVideoStart() : void {
			var _loc1_:String = null;
			if(!this._send140708FStartFlag) {
				this._send140708FStartFlag = true;
				_loc1_ = PING_BACK_TMPSTATS + "?type=yhls20130924&usract=140708fstart" + "&pla=" + PlATFORM_TYPE + "&tn=" + Math.random();
				this.pingRequestServer(_loc1_,false);
			}
		}
		
		public function sendFilmScore(param1:uint) : void {
			var _loc2_:PlayerProxy = this._facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc3_:ContinuePlayProxy = this._facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
			var _loc4_:UserProxy = this._facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			var _loc5_:* = "";
			if(_loc3_.taid != "") {
				_loc5_ = _loc3_.tcid;
			} else {
				_loc5_ = _loc2_.curActor.movieModel != null?_loc2_.curActor.movieModel.channelID.toString():"";
			}
			var _loc6_:String = UserManager.getInstance().user?UserManager.getInstance().user.passportID:"";
			var _loc7_:String = UserManager.getInstance().user?UserManager.getInstance().user.profileID:"";
			var _loc8_:String = PING_BACK_TMPSTATS + "?usract=3" + "&type=user_rating_20141014" + "&ppuid=" + _loc6_ + "&pru=" + _loc7_ + "&uid=" + _loc2_.curActor.uuid + "&platform=11" + "&taid=" + (_loc2_.curActor.movieModel?_loc2_.curActor.movieModel.tvid:"") + "&rate=" + param1 + "&src_code=1" + "&channel_id=" + _loc5_ + "&rn=" + Math.random();
			this.pingRequestServer(_loc8_,false);
		}
		
		public function sendFilmScoreRecommend(param1:uint) : void {
			var _loc2_:PlayerProxy = this._facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc3_:UserProxy = this._facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			var _loc4_:String = UserManager.getInstance().user?UserManager.getInstance().user.passportID:"";
			var _loc5_:String = UserManager.getInstance().user?UserManager.getInstance().user.profileID:"";
			var _loc6_:String = SystemConfig.MOVIE_SCORE_URL + "set_score?ppuid=" + _loc4_ + "&uid=" + _loc2_.curActor.uuid + "&pru=" + _loc5_ + "&entity_id=" + (_loc2_.curActor.movieModel?_loc2_.curActor.movieModel.tvid:"") + "&score=" + param1 + "&rn=" + Math.random();
			this.pingRequestServer(_loc6_,false);
		}
		
		public function barrageDeleteInfo(param1:uint, param2:int) : void {
			var _loc3_:String = PING_BACK_BARRAGE + "?block=tucao" + "&t=21" + "&vtime=" + param2 + "&rseat=140903_clr" + "&clrcnt=" + param1 + this.publicUrl_4_0() + "&rn=" + Math.random();
			this.pingRequestServer(_loc3_,false);
		}
		
		public function userActionPing_4_0(param1:String) : void {
			var _loc2_:String = PING_BACK_BARRAGE + "?rseat=" + param1 + "&t=20" + this.publicUrl_4_0() + "&rn=" + Math.random();
			this.pingRequestServer(_loc2_,false);
		}
		
		public function showActionPing_4_0(param1:String) : void {
			var _loc2_:String = PING_BACK_BARRAGE + "?block=" + param1 + "&t=21" + this.publicUrl_4_0() + "&rn=" + Math.random();
			this.pingRequestServer(_loc2_,false);
		}
		
		public function noticeUserActionPing_4_0(param1:String, param2:String) : void {
			var _loc3_:String = PING_BACK_BARRAGE + "?rseat=" + param1 + "&noticeid=" + param2 + "&t=20" + this.publicUrl_4_0() + "&rn=" + Math.random();
			this.pingRequestServer(_loc3_,false);
		}
		
		public function noticeShowActionPing_4_0(param1:String, param2:String) : void {
			var _loc3_:String = PING_BACK_BARRAGE + "?block=" + param1 + "&noticeid=" + param2 + "&t=21" + this.publicUrl_4_0() + "&rn=" + Math.random();
			this.pingRequestServer(_loc3_,false);
		}
		
		private function publicUrl_4_0() : String {
			var _loc1_:PlayerProxy = this._facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2_:UserProxy = this._facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			var _loc3_:IMovieModel = _loc1_.curActor.movieModel;
			var _loc4_:IMovieInfo = _loc1_.curActor.movieInfo;
			var _loc5_:* = "";
			var _loc6_:Number = 0;
			var _loc7_:* = "";
			var _loc8_:String = UserManager.getInstance().user?UserManager.getInstance().user.passportID:"";
			var _loc9_:String = UserManager.getInstance().user?UserManager.getInstance().user.profileID:"";
			if((_loc3_) && (_loc4_)) {
				_loc5_ = _loc3_.tvid;
				_loc6_ = _loc3_.duration;
				_loc7_ = _loc3_.channelID.toString();
			}
			var _loc10_:String = "&pf=1" + "&bstp=0" + "&p=10" + "&p1=101" + "&u=" + _loc1_.curActor.uuid + "&pu=" + _loc8_ + "&pru=" + _loc9_ + "&qpid=" + _loc5_ + "&c1=" + _loc7_ + "&tm=" + _loc6_;
			return _loc10_;
		}
		
		private function getPageLocationHref() : String {
			var location:String = "";
			try {
				location = ExternalInterface.call("function(){return window.location.href;}");
				if(location) {
					location = encodeURIComponent(location);
				}
			}
			catch(e:Error) {
				location = "";
			}
			return location;
		}
		
		private function getBrowserMatch() : Object {
			var browserAgent:String = null;
			var ua:String = null;
			var ropera:RegExp = null;
			var rmsie:RegExp = null;
			var rmozilla:RegExp = null;
			var match:Object = null;
			try {
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
			catch(error:Error) {
			}
			return null;
		}
	}
}
class SingletonClass extends Object {
	
	function SingletonClass() {
		super();
	}
}
