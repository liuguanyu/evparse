package com.sohu.tv.mediaplayer.stat {
	import flash.events.EventDispatcher;
	import com.sohu.tv.mediaplayer.PlayerConfig;
	import flash.net.SharedObject;
	import com.adobe.crypto.*;
	import com.sohu.tv.mediaplayer.ads.*;
	import ebing.Utils;
	import flash.net.URLVariables;
	import com.sohu.tv.mediaplayer.Model;
	import ebing.utils.LogManager;
	import com.sohu.tv.mediaplayer.p2p.P2PExplorer;
	import ebing.external.Eif;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.sendToURL;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class InforSender extends EventDispatcher {
		
		public function InforSender() {
			this.FCK = new FlashCookie();
			super();
		}
		
		public static const START:String = "playCount";
		
		public static const START2:String = "videoStart";
		
		public static const START3:String = "out";
		
		public static const END:String = "videoEnds";
		
		public static const BUFFER_FULL:String = "bufferFull";
		
		public static const BUFFER_EMPTY:String = "bufferEmpty";
		
		public static const STOP:String = "stopTrigger";
		
		public static const PAUSE:String = "pauseTrigger";
		
		public static const CLIP_OVER:String = "clipOver";
		
		public static const ADCLIP_OVER:String = "adclipOver";
		
		public static const FULLSCREEN:String = "fullScreen";
		
		public static const SCALESCREEN:String = "scaleScreen";
		
		public static const DOWNLOAD_TIME:String = "downloadtime";
		
		public static const OPENING_AD:String = "openingad";
		
		public static const ENDING_AD:String = "endingad";
		
		public static const NEW_USER:String = "newuser";
		
		public static const DROPFRAMES:String = "dropFrames";
		
		public static const DFFORSO:String = "dfForSo";
		
		public static const FF:String = "ff";
		
		public static const HISTORYPROBLEMS:String = "historyproblems";
		
		public static var singleton:InforSender;
		
		public static function getInstance() : InforSender {
			if(InforSender.singleton == null) {
				InforSender.singleton = new InforSender();
			}
			return InforSender.singleton;
		}
		
		private var _timeoutID:uint = 0;
		
		private var _ifltype:String = "";
		
		private var FCK:FlashCookie;
		
		public function sendMesg(param1:String, param2:Number, param3:String = "", param4:String = "", param5:String = "http://data.vrs.sohu.com/player.gif", param6:uint = 0, param7:Object = null) : void {
			var _loc20_:String = null;
			var _loc21_:String = null;
			var _loc22_:Array = null;
			var _loc23_:* = NaN;
			if(PlayerConfig.isPreview) {
				return;
			}
			var _loc8_:SharedObject = SharedObject.getLocal("hisRecommMark","/");
			if(!(_loc8_.data.item == undefined) && !(_loc8_.data.item.vid == undefined) && !(_loc8_.data.item.vid == "")) {
				if(_loc8_.data.item.vid == PlayerConfig.vid || _loc8_.data.item.vid == PlayerConfig.hdVid || _loc8_.data.item.vid == PlayerConfig.superVid || _loc8_.data.item.vid == PlayerConfig.norVid || _loc8_.data.item.vid == PlayerConfig.oriVid) {
					PlayerConfig.lb = "3";
					_loc8_.clear();
				}
			}
			var _loc9_:String = PlayerConfig.userId;
			var _loc10_:Boolean = !(this._ifltype == "") && !PlayerConfig.isLive && !(PlayerConfig.hdVid == "")?true:false;
			_loc10_;
			var _loc11_:Number = Number(Utils.cleanUnderline(PlayerConfig.vid));
			var _loc12_:Number = PlayerConfig.isFms?-1:Number(PlayerConfig.nid);
			var _loc13_:Number = Number(PlayerConfig.pid);
			var _loc14_:Number = Number(PlayerConfig.sid);
			var _loc15_:Number = PlayerConfig.timestamp;
			var _loc16_:URLVariables = new URLVariables();
			if(!(param3 == "") && !(param4 == "")) {
				_loc16_[param3] = param4;
			}
			if(!(Model.getInstance().videoInfo == null) && !(Model.getInstance().videoInfo.status == null) && !(Model.getInstance().videoInfo.status == "") && Model.getInstance().videoInfo.status == 3) {
				_loc16_.msg = START3;
			} else {
				_loc16_.msg = param1;
			}
			if(param1 == START2) {
				_loc16_.hasStartAd = TvSohuAds.getInstance().startAd.hasAd?"1":"0";
				if(param7 != null) {
					if(param7.mode != null) {
						_loc16_.stvMode = param7.mode;
					}
					if(param7.curColor != null) {
						_loc16_.curColor = param7.curColor;
					}
					if(param7.colorSpace != null) {
						_loc16_.colorSpace = param7.colorSpace;
					}
					if(param7.svdLen != null) {
						_loc16_.svdLen = param7.svdLen;
					}
				}
			}
			if(param1 == DROPFRAMES) {
				if(param7 != null) {
					if(param7.mode != null) {
						_loc16_.stvMode = param7.mode;
					}
					if(param7.curColor != null) {
						_loc16_.curColor = param7.curColor;
					}
					if(param7.colorSpace != null) {
						_loc16_.colorSpace = param7.colorSpace;
					}
					if(param7.svdLen != null) {
						_loc16_.svdLen = param7.svdLen;
					}
					if(param7.videoFps != null) {
						_loc16_.videoFps = param7.videoFps;
					}
					if(param7.totalMemory != null) {
						_loc16_.totalMemory = param7.totalMemory;
					}
					if(param7.freeMemory != null) {
						_loc16_.freeMemory = param7.freeMemory;
					}
				}
			}
			if(param1 == FF) {
				if(param7 != null) {
					if(param7.num != null) {
						_loc16_.num = param7.num;
					}
					if(param7.errType != null) {
						_loc16_.errType = param7.errType;
					}
					if(param7.outTime != null) {
						_loc16_.outTime = param7.outTime;
					}
					if(param7.spendTime != null) {
						_loc16_.spendTime = param7.spendTime;
					}
					if(param7.serTimeNum1 != null) {
						_loc16_.serTimeNum1 = param7.serTimeNum1;
					}
					if(param7.serTimeNum2 != null) {
						_loc16_.serTimeNum2 = param7.serTimeNum2;
					}
					if(param7.clientTime != null) {
						_loc16_.clientTime = param7.clientTime;
					}
					if(param7.adUrl != null) {
						_loc16_.adUrl = param7.adUrl;
					}
					if(param7.adSerTime != null) {
						_loc16_.adSerTime = param7.adSerTime;
					}
					if(param7.adPlayedTime1 != null) {
						_loc16_.adPlayedTime1 = param7.adPlayedTime1;
					}
					if(param7.adPlayedTime2 != null) {
						_loc16_.adPlayedTime2 = param7.adPlayedTime2;
					}
					if(param7.flag != null) {
						_loc16_.flag = param7.flag;
					}
					if(param7.loadType != null) {
						_loc16_.loadType = param7.loadType;
					}
					if(param7.hasAd != null) {
						_loc16_.hasAd = param7.hasAd;
					}
				}
			}
			if(param1 == END) {
				if(param7 != null) {
					if(param7.totalRAM != null) {
						_loc16_.totalRAM = param7.totalRAM;
					}
					if(param7.idleRAMPer != null) {
						_loc16_.idleRAMPer = param7.idleRAMPer;
					}
					if(param7.playerRAMPer != null) {
						_loc16_.playerRAMPer = param7.playerRAMPer;
					}
				}
			}
			if(param1 == DFFORSO) {
				if(param7 != null) {
					if(param7.totalViewTime != null) {
						_loc16_.totalViewTime = param7.totalViewTime;
					}
					if(param7.totalDropFrames != null) {
						_loc16_.totalDropFrames = param7.totalDropFrames;
					}
					if(param7.stvdInUse != null) {
						_loc16_.stvdInUse = param7.stvdInUse;
					}
				}
			}
			if(param1 == HISTORYPROBLEMS) {
				if(param7 != null) {
					if(param7.allotType != null) {
						_loc16_.allotType = param7.allotType;
					}
					if(param7.errType != null) {
						_loc16_.errType = param7.errType;
					}
				}
			}
			if(param1 == START && !(param6 == 0)) {
				_loc16_.err = 1;
			}
			_loc16_.time = Math.floor(param2);
			_loc16_.uid = _loc9_;
			_loc16_.vid = _loc11_;
			_loc16_.tvid = PlayerConfig.tvid;
			_loc16_.nid = _loc12_;
			_loc16_.pid = _loc13_;
			_loc16_.sid = _loc14_;
			if(PlayerConfig.isLive) {
				_loc16_.ltype = PlayerConfig.liveType;
			}
			if((PlayerConfig.isFee) && param1 == START) {
				_loc16_.isfee = 1;
				ErrorSenderPQ.getInstance().sendDebugInfo({
					"url":"http://um.hd.sohu.com/u.gif",
					"type":"player",
					"code":PlayerConfig.VINFO_CODE,
					"error":PlayerConfig.VINFO_ERROR_13,
					"debuginfo":LogManager.getMsg(),
					"sid":PlayerConfig.sid,
					"uid":PlayerConfig.userId,
					"time":new Date().getTime()
				});
			}
			_loc16_.playListId = PlayerConfig.isMyTvVideo?(PlayerConfig.isSohuDomain) && !(PlayerConfig.plid == "")?PlayerConfig.plid:"0":PlayerConfig.vrsPlayListId;
			_loc16_.isHD = PlayerConfig.videoVersion;
			_loc16_.td = Math.round(PlayerConfig.totalDuration);
			_loc16_.type = PlayerConfig.isMyTvVideo?PlayerConfig.isKTVVideo?"ktv":"my":(PlayerConfig.isTransition) || !PlayerConfig.isLongVideo?"vms":"vrs";
			if(PlayerConfig.caid != "") {
				_loc16_.cateid = PlayerConfig.caid;
			}
			if(PlayerConfig.apiKey != "") {
				_loc16_.apikey = PlayerConfig.apiKey;
			}
			if(PlayerConfig.yyid != "") {
				_loc16_.yyid = PlayerConfig.yyid;
			}
			if(PlayerConfig.atype != "") {
				_loc16_.atype = PlayerConfig.atype;
			}
			if(PlayerConfig.mergeid != "") {
				_loc16_.mergeid = PlayerConfig.mergeid;
			}
			if(PlayerConfig.isWebP2p) {
				_loc16_.ua = "pp";
			} else {
				_loc16_.ua = "sh";
			}
			_loc16_.isp2p = P2PExplorer.getInstance().hasP2P?PlayerConfig.gslbErrorIp != ""?0:1:0;
			if(PlayerConfig.isMyTvVideo) {
				_loc16_.cateid = PlayerConfig.cid;
				_loc16_.userid = PlayerConfig.myTvUserId;
			}
			if(!(Model.getInstance().videoInfo == null) && !(Model.getInstance().videoInfo.company == null) && !(Model.getInstance().videoInfo.company == "")) {
				_loc16_.company = Model.getInstance().videoInfo.company;
			}
			_loc16_.timestamp = _loc15_;
			if((Eif.available) && (ExternalInterface.available)) {
				try {
					_loc20_ = ExternalInterface.call("eval","window.top.location.href");
					_loc21_ = ExternalInterface.call("eval","window.self.location.href");
					if(_loc20_ != _loc21_) {
						_loc16_.isIframe = "1";
					} else {
						_loc16_.isIframe = "0";
					}
				}
				catch(e:Error) {
				}
			}
			if((Eif.available) && (ExternalInterface.available)) {
				_loc16_.areaid = PlayerConfig.area;
				_loc16_.vrschannelid = PlayerConfig.channel;
				var _loc17_:String = PlayerConfig.catcode;
				if(PlayerConfig.isHotOrMy) {
					_loc16_.systype = "0";
				} else {
					_loc16_.systype = "1";
					if(PlayerConfig.isAlbumVideo) {
						_loc16_.album = "1";
					} else {
						_loc16_.album = "0";
					}
				}
				_loc16_.uuid = PlayerConfig.uuid;
				_loc16_.catcode = _loc17_;
				_loc16_.act = PlayerConfig.act;
				_loc16_.st = PlayerConfig.mainActorId;
				_loc16_.ar = PlayerConfig.areaId;
				_loc16_.ye = PlayerConfig.year;
				_loc16_.ag = PlayerConfig.age;
				_loc16_.lf = escape(PlayerConfig.landingrefer);
				_loc16_.autoplay = PlayerConfig.autoPlay?1:0;
				if(!(PlayerConfig.lb == null) && !(PlayerConfig.lb == "") && PlayerConfig.lb == "1") {
					_loc16_.refer = escape(PlayerConfig.lastReferer);
					_loc16_.url = escape(PlayerConfig.filePrimaryReferer);
				} else {
					if((Eif.available) && (ExternalInterface.available)) {
						try {
							_loc16_.refer = escape(ExternalInterface.call("eval","document.referrer"));
						}
						catch(e:Error) {
						}
					}
					_loc16_.url = PlayerConfig.currentPageUrl == ""?escape(PlayerConfig.outReferer):escape(PlayerConfig.currentPageUrl);
				}
				if(PlayerConfig.totalDuration > 180) {
					_loc16_.heart = 30;
				} else {
					_loc16_.heart = 10;
				}
				_loc16_.xuid = PlayerConfig.xuid;
				_loc16_.out = PlayerConfig.domainProperty;
				if(!(PlayerConfig.lb == null) && !(PlayerConfig.lb == "")) {
					_loc16_.lb = PlayerConfig.lb;
				}
				if(!(PlayerConfig.pub_catecode == null) && !(PlayerConfig.pub_catecode == "")) {
					_loc16_.pub_catecode = PlayerConfig.pub_catecode;
				}
				if(!(PlayerConfig.ch_key == null) && !(PlayerConfig.ch_key == "")) {
					_loc16_.ch_key = PlayerConfig.ch_key;
				}
				if(!(PlayerConfig.ifoxInfoObj == null) && !(PlayerConfig.ifoxInfoObj == "")) {
					if(PlayerConfig.ifoxInfoObj.ifoxVer != "") {
						_loc16_.v = PlayerConfig.ifoxInfoObj.ifoxVer;
					}
					if(PlayerConfig.ifoxInfoObj.ifoxUid != "") {
						_loc16_.iuid = PlayerConfig.ifoxInfoObj.ifoxUid;
					}
					if(PlayerConfig.ifoxInfoObj.ifoxCh != "") {
						_loc16_.ChannelID = PlayerConfig.ifoxInfoObj.ifoxCh;
					}
				}
				_loc16_.passport = PlayerConfig.passportMail;
				try {
					if((Eif.available) && !(ExternalInterface.call("sohuHD.cookie","promote_position") == null) && !(ExternalInterface.call("sohuHD.cookie","promote_position") == "") && !(ExternalInterface.call("sohuHD.cookie","promote_position") == "undefined")) {
						_loc16_.pepn = ExternalInterface.call("sohuHD.cookie","promote_position");
						ExternalInterface.call("sohuHD.cookie","promote_position",null,{
							"path":"/",
							"domain":"tv.sohu.com"
						});
					}
				}
				catch(e:Error) {
				}
				_loc16_.fver = PlayerConfig.VERSION;
				if(PlayerConfig.lqd != "") {
					_loc16_.oth = PlayerConfig.lqd;
				}
				if(PlayerConfig.lcode != "") {
					_loc16_.cd = PlayerConfig.lcode;
				}
				_loc16_.sz = PlayerConfig.clientWidth + "_" + PlayerConfig.clientHeight;
				_loc16_.md = PlayerConfig.dmMd;
				var _loc18_:Array = PlayerConfig.swfHost.split("/");
				_loc16_.pdir = _loc18_[_loc18_.length - 2];
				if(PlayerConfig.ugu != "") {
					_loc16_.ugu = PlayerConfig.ugu;
				}
				if(PlayerConfig.ugcode != "") {
					_loc16_.ugcode = PlayerConfig.ugcode;
				}
				if(PlayerConfig.wm_user != "") {
					_loc16_.wm_user = PlayerConfig.wm_user;
				}
				if(PlayerConfig.fc_user != "") {
					_loc16_.fc_user = PlayerConfig.fc_user;
				}
				if(!(Model.getInstance().videoInfo == null) && !(Model.getInstance().videoInfo.status == null) && !(Model.getInstance().videoInfo.status == "") && Model.getInstance().videoInfo.status == 12) {
					_loc16_.status = Model.getInstance().videoInfo.status;
				}
				if(!(PlayerConfig.hotVrSyst == "") && (param1 == START || param1 == START2)) {
					_loc22_ = PlayerConfig.hotVrSyst.split("&m=");
					_loc23_ = new Date().getTime();
					_loc22_[0] = Number(_loc22_[0]) + Math.abs(_loc23_ - Number(_loc22_[1]));
					_loc16_.t = Number(_loc22_[0]);
					_loc16_.syst = new Date().getTime();
					_loc16_.ts = MD5.hash(String(Number(PlayerConfig.vid) % 127) + PlayerConfig.userId + String(Number(_loc22_[0]) % 127));
				}
				var _loc19_:URLRequest = new URLRequest(param5);
				_loc19_.method = URLRequestMethod.GET;
				_loc19_.data = _loc16_;
				sendToURL(_loc19_);
				return;
			}
			_loc16_.areaid = PlayerConfig.area;
			_loc16_.vrschannelid = PlayerConfig.channel;
			_loc17_ = PlayerConfig.catcode;
			if(PlayerConfig.isHotOrMy) {
				_loc16_.systype = "0";
			} else {
				_loc16_.systype = "1";
				if(PlayerConfig.isAlbumVideo) {
					_loc16_.album = "1";
				} else {
					_loc16_.album = "0";
				}
			}
			_loc16_.uuid = PlayerConfig.uuid;
			_loc16_.catcode = _loc17_;
			_loc16_.act = PlayerConfig.act;
			_loc16_.st = PlayerConfig.mainActorId;
			_loc16_.ar = PlayerConfig.areaId;
			_loc16_.ye = PlayerConfig.year;
			_loc16_.ag = PlayerConfig.age;
			_loc16_.lf = escape(PlayerConfig.landingrefer);
			_loc16_.autoplay = PlayerConfig.autoPlay?1:0;
			if(!(PlayerConfig.lb == null) && !(PlayerConfig.lb == "") && PlayerConfig.lb == "1") {
				_loc16_.refer = escape(PlayerConfig.lastReferer);
				_loc16_.url = escape(PlayerConfig.filePrimaryReferer);
			} else {
				if((Eif.available) && (ExternalInterface.available)) {
					_loc16_.refer = escape(ExternalInterface.call("eval","document.referrer"));
				}
				_loc16_.url = PlayerConfig.currentPageUrl == ""?escape(PlayerConfig.outReferer):escape(PlayerConfig.currentPageUrl);
			}
			if(PlayerConfig.totalDuration > 180) {
				_loc16_.heart = 30;
			} else {
				_loc16_.heart = 10;
			}
			_loc16_.xuid = PlayerConfig.xuid;
			_loc16_.out = PlayerConfig.domainProperty;
			if(!(PlayerConfig.lb == null) && !(PlayerConfig.lb == "")) {
				_loc16_.lb = PlayerConfig.lb;
			}
			if(!(PlayerConfig.pub_catecode == null) && !(PlayerConfig.pub_catecode == "")) {
				_loc16_.pub_catecode = PlayerConfig.pub_catecode;
			}
			if(!(PlayerConfig.ch_key == null) && !(PlayerConfig.ch_key == "")) {
				_loc16_.ch_key = PlayerConfig.ch_key;
			}
			if(!(PlayerConfig.ifoxInfoObj == null) && !(PlayerConfig.ifoxInfoObj == "")) {
				if(PlayerConfig.ifoxInfoObj.ifoxVer != "") {
					_loc16_.v = PlayerConfig.ifoxInfoObj.ifoxVer;
				}
				if(PlayerConfig.ifoxInfoObj.ifoxUid != "") {
					_loc16_.iuid = PlayerConfig.ifoxInfoObj.ifoxUid;
				}
				if(PlayerConfig.ifoxInfoObj.ifoxCh != "") {
					_loc16_.ChannelID = PlayerConfig.ifoxInfoObj.ifoxCh;
				}
			}
			_loc16_.passport = PlayerConfig.passportMail;
			if((Eif.available) && !(ExternalInterface.call("sohuHD.cookie","promote_position") == null) && !(ExternalInterface.call("sohuHD.cookie","promote_position") == "") && !(ExternalInterface.call("sohuHD.cookie","promote_position") == "undefined")) {
				_loc16_.pepn = ExternalInterface.call("sohuHD.cookie","promote_position");
				ExternalInterface.call("sohuHD.cookie","promote_position",null,{
					"path":"/",
					"domain":"tv.sohu.com"
				});
			}
			_loc16_.fver = PlayerConfig.VERSION;
			if(PlayerConfig.lqd != "") {
				_loc16_.oth = PlayerConfig.lqd;
			}
			if(PlayerConfig.lcode != "") {
				_loc16_.cd = PlayerConfig.lcode;
			}
			_loc16_.sz = PlayerConfig.clientWidth + "_" + PlayerConfig.clientHeight;
			_loc16_.md = PlayerConfig.dmMd;
			_loc18_ = PlayerConfig.swfHost.split("/");
			_loc16_.pdir = _loc18_[_loc18_.length - 2];
			if(PlayerConfig.ugu != "") {
				_loc16_.ugu = PlayerConfig.ugu;
			}
			if(PlayerConfig.ugcode != "") {
				_loc16_.ugcode = PlayerConfig.ugcode;
			}
			if(PlayerConfig.wm_user != "") {
				_loc16_.wm_user = PlayerConfig.wm_user;
			}
			if(PlayerConfig.fc_user != "") {
				_loc16_.fc_user = PlayerConfig.fc_user;
			}
			if(!(Model.getInstance().videoInfo == null) && !(Model.getInstance().videoInfo.status == null) && !(Model.getInstance().videoInfo.status == "") && Model.getInstance().videoInfo.status == 12) {
				_loc16_.status = Model.getInstance().videoInfo.status;
			}
			if(!(PlayerConfig.hotVrSyst == "") && (param1 == START || param1 == START2)) {
				_loc22_ = PlayerConfig.hotVrSyst.split("&m=");
				_loc23_ = new Date().getTime();
				_loc22_[0] = Number(_loc22_[0]) + Math.abs(_loc23_ - Number(_loc22_[1]));
				_loc16_.t = Number(_loc22_[0]);
				_loc16_.syst = new Date().getTime();
				_loc16_.ts = MD5.hash(String(Number(PlayerConfig.vid) % 127) + PlayerConfig.userId + String(Number(_loc22_[0]) % 127));
			}
			_loc19_ = new URLRequest(param5);
			_loc19_.method = URLRequestMethod.GET;
			_loc19_.data = _loc16_;
			sendToURL(_loc19_);
		}
		
		public function heartBeat(param1:Number, param2:String) : String {
			var _loc13_:String = null;
			var _loc14_:String = null;
			var _loc15_:String = null;
			var _loc3_:* = "";
			var _loc4_:* = "";
			var _loc5_:* = "";
			if(!(PlayerConfig.lb == null) && !(PlayerConfig.lb == "") && PlayerConfig.lb == "1") {
				_loc5_ = escape(PlayerConfig.lastReferer);
				_loc4_ = escape(PlayerConfig.filePrimaryReferer);
			} else {
				if((Eif.available) && (ExternalInterface.available)) {
					try {
						_loc5_ = escape(ExternalInterface.call("eval","document.referrer"));
					}
					catch(e:Error) {
					}
				}
				_loc4_ = PlayerConfig.currentPageUrl == ""?escape(PlayerConfig.outReferer):escape(PlayerConfig.currentPageUrl);
			}
			var _loc6_:* = "";
			if(!(PlayerConfig.ifoxInfoObj == null) && !(PlayerConfig.ifoxInfoObj == "")) {
				_loc13_ = PlayerConfig.ifoxInfoObj.ifoxVer != ""?"&v=" + PlayerConfig.ifoxInfoObj.ifoxVer:"";
				_loc14_ = PlayerConfig.ifoxInfoObj.ifoxUid != ""?"&iuid=" + PlayerConfig.ifoxInfoObj.ifoxUid:"";
				_loc15_ = PlayerConfig.ifoxInfoObj.ifoxCh != ""?"&ChannelID=" + PlayerConfig.ifoxInfoObj.ifoxCh:"";
				_loc6_ = _loc13_ + _loc14_ + _loc15_;
			}
			var _loc7_:Number = 0;
			var _loc8_:SharedObject = SharedObject.getLocal("vmsPlayer","/");
			if(!(_loc8_.data.bw == undefined) && !(_loc8_.data.bw == "") && !(String(_loc8_.data.bw) == "0")) {
				_loc7_ = _loc8_.data.bw;
			}
			var _loc9_:Boolean = !(InforSender.getInstance().ifltype == "") && !PlayerConfig.isLive && !(PlayerConfig.hdVid == "")?true:false;
			var _loc10_:* = "";
			var _loc11_:Array = PlayerConfig.swfHost.split("/");
			_loc10_ = "&pdir=" + _loc11_[_loc11_.length - 2];
			var _loc12_:String = (PlayerConfig.lqd != ""?"&oth=" + PlayerConfig.lqd:"") + (PlayerConfig.lcode != ""?"&cd=" + PlayerConfig.lcode:"") + "&sz=" + (PlayerConfig.clientWidth + "_" + PlayerConfig.clientHeight) + "&md=" + PlayerConfig.dmMd + (PlayerConfig.ugu != ""?"&ugu=" + PlayerConfig.ugu:"") + (PlayerConfig.ugcode != ""?"&ugcode=" + PlayerConfig.ugcode:"") + (PlayerConfig.wm_user != ""?"&wm_user=" + PlayerConfig.wm_user:"") + (PlayerConfig.fc_user != ""?"&fc_user=" + PlayerConfig.fc_user:"");
			_loc3_ = param2 + "&vid=" + (_loc9_?Utils.cleanUnderline(PlayerConfig.hdVid):Utils.cleanUnderline(PlayerConfig.vid)) + "&tvid=" + PlayerConfig.tvid + "&ua=" + (PlayerConfig.isWebP2p?"pp":"sh") + "&isHD=" + PlayerConfig.videoVersion + "&pid=" + PlayerConfig.pid + "&uid=" + PlayerConfig.userId + "&out=" + PlayerConfig.domainProperty + "&playListId=" + (PlayerConfig.isMyTvVideo?(PlayerConfig.isSohuDomain) && !(PlayerConfig.plid == "")?PlayerConfig.plid:"0":PlayerConfig.vrsPlayListId) + "&nid=" + (PlayerConfig.isFms?-1:Number(PlayerConfig.nid)) + "&tc=" + PlayerConfig.viewTime + "&type=" + (PlayerConfig.isMyTvVideo?PlayerConfig.isKTVVideo?"ktv":"my":(PlayerConfig.isTransition) || !PlayerConfig.isLongVideo?"vms":"vrs") + "&cateid=" + PlayerConfig.cid + "&userid=" + PlayerConfig.myTvUserId + "&uuid=" + encodeURIComponent(PlayerConfig.uuid) + (PlayerConfig.isLive?"&ltype=" + PlayerConfig.liveType:"") + (PlayerConfig.isFee?"&isfee=1":"") + (PlayerConfig.pub_catecode != ""?"&pub_catecode=" + PlayerConfig.pub_catecode:"") + (PlayerConfig.atype != ""?"&atype=" + PlayerConfig.atype:"") + (PlayerConfig.ch_key != ""?"&ch_key=" + PlayerConfig.ch_key:"") + (PlayerConfig.mergeid != ""?"&mergeid=" + PlayerConfig.mergeid:"") + "&isp2p=" + (P2PExplorer.getInstance().hasP2P?PlayerConfig.gslbErrorIp != ""?0:1:0) + (PlayerConfig.userAgent != ""?"&ua=" + PlayerConfig.userAgent:"") + "&catcode=" + encodeURIComponent(PlayerConfig.catcode) + "&systype=" + (PlayerConfig.isHotOrMy?"0":"1") + "&act=" + PlayerConfig.act + "&st=" + encodeURIComponent(PlayerConfig.mainActorId) + "&ar=" + PlayerConfig.areaId + "&ye=" + PlayerConfig.year + "&ag=" + escape(PlayerConfig.age) + "&lb=" + PlayerConfig.lb + (PlayerConfig.yyid != ""?"&yyid=" + PlayerConfig.yyid:"") + _loc6_ + "&xuid=" + PlayerConfig.xuid + "&passport=" + encodeURIComponent(PlayerConfig.passportMail) + "&showqd=" + Math.round(PlayerConfig.playedTime) + "&heart=" + param1 + "&td=" + Math.round(PlayerConfig.totalDuration) + "&fver=" + PlayerConfig.VERSION + _loc10_ + _loc12_ + "&url=" + _loc4_ + "&lf=" + escape(PlayerConfig.landingrefer) + "&autoplay=" + (PlayerConfig.autoPlay?1:0) + "&cdnIp=" + PlayerConfig.cdnIp + "&cdnSpeed=" + _loc7_ + "&refer=" + _loc5_ + "&t=" + Math.random();
			return _loc3_;
		}
		
		public function sendIRS(param1:String = "") : void {
			var _loc2_:String = PlayerConfig.currentVid.split("_")[0];
			this.FCK._IWT_Debug = false;
			this.FCK._IWT_UAID = PlayerConfig.isLive?"UA-sohu-100007":PlayerConfig.isSohuDomain?"UA-sohu-100009":"UA-sohu-100008";
			var _loc3_:String = PlayerConfig.isLive?_loc2_:PlayerConfig.tvid;
			var _loc4_:int = int(PlayerConfig.totalDuration);
			var _loc5_:* = true;
			var _loc6_:String = PlayerConfig.isLive?_loc2_:PlayerConfig.vid;
			var _loc7_:String = escape(PlayerConfig.currentPageUrl);
			var _loc8_:String = !PlayerConfig.isMyTvVideo?escape(PlayerConfig.sid + "|" + PlayerConfig.userId):"";
			switch(param1) {
				case "":
					this.FCK.IRS_NewPlay(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_);
					break;
				case "play":
					this.FCK.IRS_UserACT("play");
					break;
				case "pause":
					this.FCK.IRS_UserACT("pause");
					break;
				case "end":
					this.FCK.IRS_UserACT("end");
					this.FCK.IRS_FlashClear();
					break;
			}
		}
		
		public function sendBufferMesg(param1:String, param2:Number) : void {
			if(PlayerConfig.isPreview) {
				return;
			}
			if(this._timeoutID != 0) {
				clearTimeout(this._timeoutID);
			}
			this._timeoutID = setTimeout(this.sendMesg,2000,param1,param2);
		}
		
		public function sendCustomMesg(param1:String) : void {
			var _loc2_:URLRequest = null;
			if(PlayerConfig.isPreview) {
				return;
			}
			if(!(param1 == null) && !(param1 == "")) {
				_loc2_ = new URLRequest(param1);
				_loc2_.method = URLRequestMethod.GET;
				sendToURL(_loc2_);
			}
		}
		
		public function set ifltype(param1:String) : void {
			this._ifltype = param1;
		}
		
		public function get ifltype() : String {
			return this._ifltype;
		}
	}
}
