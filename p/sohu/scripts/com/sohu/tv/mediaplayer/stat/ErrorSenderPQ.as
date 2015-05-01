package com.sohu.tv.mediaplayer.stat {
	import flash.events.EventDispatcher;
	import com.sohu.tv.mediaplayer.PlayerConfig;
	import flash.net.URLLoader;
	import flash.net.URLVariables;
	import flash.net.URLRequest;
	import flash.system.*;
	import flash.utils.*;
	import com.sohu.tv.mediaplayer.Model;
	import ebing.net.URLLoaderUtil;
	import ebing.Utils;
	import com.sohu.tv.mediaplayer.p2p.P2PExplorer;
	import ebing.utils.LogManager;
	import flash.net.URLRequestMethod;
	import flash.net.sendToURL;
	import com.sohu.tv.mediaplayer.ads.AdLog;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import ebing.net.JSON;
	import ebing.XXTEA;
	import ebing.external.Eif;
	import flash.external.ExternalInterface;
	
	public class ErrorSenderPQ extends EventDispatcher {
		
		public function ErrorSenderPQ() {
			super();
		}
		
		public static var singleton:ErrorSenderPQ;
		
		public static var STAT_IP_ID:int = Math.round(Math.random() * 10) % PlayerConfig.STAT_IP.length;
		
		public static var STAT_IP_QFCLIPS_ID:int = Math.round(Math.random() * 10) % PlayerConfig.STAT_IP_QFCLIPS.length;
		
		public static const FEEDBACK_PATH:String = "http://feedback.vrs.sohu.com/feedback.html?type=q4";
		
		public static function getInstance() : ErrorSenderPQ {
			if(ErrorSenderPQ.singleton == null) {
				ErrorSenderPQ.singleton = new ErrorSenderPQ();
			}
			return ErrorSenderPQ.singleton;
		}
		
		private var _isSentDefPause:Boolean = false;
		
		private var _playCount:String = "";
		
		private var _intervalBufferNum:uint = 0;
		
		private var _qfltype:String = "";
		
		private var _loader:URLLoader;
		
		public function sendPQStat(param1:Object = null) : void {
			var _loc2_:String = null;
			var _loc3_:String = null;
			var _loc4_:String = null;
			var _loc5_:String = null;
			var _loc6_:URLVariables = null;
			var _loc7_:Array = null;
			var _loc8_:URLRequest = null;
			var _loc9_:Array = null;
			var _loc10_:* = 0;
			var _loc11_:Array = null;
			var _loc12_:String = null;
			var _loc13_:uint = 0;
			var _loc14_:URLRequest = null;
			var _loc15_:String = null;
			var _loc16_:String = null;
			var _loc17_:String = null;
			var _loc18_:String = null;
			var _loc19_:String = null;
			var _loc20_:String = null;
			var _loc21_:String = null;
			var _loc22_:String = null;
			var _loc23_:URLRequest = null;
			if(PlayerConfig.isPreview) {
				return;
			}
			if(param1 != null) {
				_loc2_ = PlayerConfig.STAT_IP[STAT_IP_ID];
				_loc3_ = "http://" + _loc2_ + "/dov.do";
				_loc4_ = PlayerConfig.STAT_IP_QFCLIPS[STAT_IP_QFCLIPS_ID];
				_loc5_ = "http://" + _loc4_ + "/dov.do";
				_loc6_ = new URLVariables();
				_loc6_.method = "stat";
				_loc6_.t = new Date().getTime();
				_loc6_.uid = PlayerConfig.userId;
				_loc6_.vid = PlayerConfig.vid;
				_loc6_.tvid = PlayerConfig.tvid;
				_loc6_.nid = PlayerConfig.nid;
				_loc6_.pid = PlayerConfig.pid;
				_loc6_.sid = !(PlayerConfig.sid == null) && !(PlayerConfig.sid == "") && !(PlayerConfig.sid == "null")?PlayerConfig.sid:"0";
				_loc6_.uuid = PlayerConfig.uuid;
				_loc6_.cid = PlayerConfig.cid;
				_loc6_.type = PlayerConfig.isTransition?"vms1":!PlayerConfig.isLongVideo?"vms2":PlayerConfig.isMyTvVideo?PlayerConfig.isKTVVideo?"ktv":"my":"vrs";
				_loc6_.isHD = PlayerConfig.isHd?PlayerConfig.videoVersion:"0";
				_loc6_.vt = PlayerConfig.viewTime;
				_loc6_.totTime = PlayerConfig.totalDuration;
				_loc6_.out = PlayerConfig.domainProperty;
				_loc6_.stvMode = (PlayerConfig.availableStvd) && (PlayerConfig.stvdInUse)?"1":"0";
				if(PlayerConfig.gslbWay != "") {
					_loc9_ = PlayerConfig.gslbWay.split("&");
					_loc10_ = 0;
					while(_loc10_ < _loc9_.length) {
						if(_loc9_[_loc10_] != "") {
							_loc11_ = _loc9_[_loc10_].split("=");
							if(_loc11_.length > 1) {
								_loc6_[_loc11_[0]] = _loc11_[1];
							}
						}
						_loc10_++;
					}
				}
				if(!(param1.error == null) && param1.error == PlayerConfig.VINFO_ERROR_12) {
					_loc6_.vinfoErr = 2;
				}
				if(!(PlayerConfig.pub_catecode == null) && !(PlayerConfig.pub_catecode == "")) {
					_loc6_.pub_catecode = PlayerConfig.pub_catecode;
				}
				if(!(PlayerConfig.ch_key == null) && !(PlayerConfig.ch_key == "")) {
					_loc6_.ch_key = PlayerConfig.ch_key;
				}
				if(PlayerConfig.cdnId != "") {
					_loc6_.cdnid = PlayerConfig.cdnId;
				}
				if(PlayerConfig.cdnIp != "") {
					_loc6_.cdnip = PlayerConfig.cdnIp;
				}
				if(PlayerConfig.clientIp != "") {
					_loc6_.clientIp = PlayerConfig.clientIp;
				}
				if(PlayerConfig.vrsPlayListId != "") {
					_loc6_.playerListId = PlayerConfig.vrsPlayListId;
				}
				if(PlayerConfig.isForbidP2P != "") {
					_loc6_.FP2P = PlayerConfig.isForbidP2P;
				}
				if(PlayerConfig.gslbErrorIp != "") {
					_loc6_.gslbErrIp = PlayerConfig.gslbErrorIp;
				}
				if(PlayerConfig.caid != "") {
					_loc6_.caid = PlayerConfig.caid;
				}
				if(PlayerConfig.userAgent == "sh") {
					_loc6_.ua = "sh";
				}
				if(!(PlayerConfig.ifoxInfoObj == null) && !(PlayerConfig.ifoxInfoObj == "")) {
					if(PlayerConfig.ifoxInfoObj.ifoxVer != "") {
						_loc6_.v = PlayerConfig.ifoxInfoObj.ifoxVer;
					}
					if(PlayerConfig.ifoxInfoObj.ifoxUid != "") {
						_loc6_.iuid = PlayerConfig.ifoxInfoObj.ifoxUid;
					}
					if(PlayerConfig.ifoxInfoObj.ifoxCh != "") {
						_loc6_.ChannelID = PlayerConfig.ifoxInfoObj.ifoxCh;
					}
				}
				_loc6_.ref = PlayerConfig.currentPageUrl == ""?escape(PlayerConfig.outReferer):escape(PlayerConfig.currentPageUrl);
				_loc6_.pver = escape(PlayerConfig.flashVersion);
				_loc6_.fver = PlayerConfig.VERSION;
				_loc7_ = PlayerConfig.swfHost.split("/");
				_loc6_.pdir = _loc7_[_loc7_.length - 2];
				_loc6_.code = param1.code;
				if(PlayerConfig.lqd != "") {
					_loc6_.oth = PlayerConfig.lqd;
				}
				if(PlayerConfig.lcode != "") {
					_loc6_.cd = PlayerConfig.lcode;
				}
				_loc6_.sz = PlayerConfig.clientWidth + "_" + PlayerConfig.clientHeight;
				_loc6_.md = PlayerConfig.qsMd;
				if(PlayerConfig.ugu != "") {
					_loc6_.ugu = PlayerConfig.ugu;
				}
				if(PlayerConfig.ugcode != "") {
					_loc6_.ugcode = PlayerConfig.ugcode;
				}
				if(param1.all700no != null) {
					_loc6_.all700no = param1.all700no;
				}
				if(param1.allno != null) {
					_loc6_.allno = param1.allno;
				}
				if(param1.errno != null) {
					_loc6_.errno = param1.errno;
				}
				if(param1.bufno != null) {
					_loc6_.bufno = param1.bufno;
				}
				if(param1.allbufno != null) {
					_loc6_.allbufno = param1.allbufno;
				}
				if(param1.dom != null) {
					_loc6_.dom = escape(param1.dom);
				}
				if(param1.split != null) {
					_loc6_.split = param1.split;
				}
				if(!(param1.drag == null) && Number(param1.drag) > 0) {
					_loc6_.drag = param1.drag;
				} else {
					_loc6_.drag = "-1";
				}
				if(param1.error != null) {
					_loc6_.error = param1.error;
				}
				if(param1.adt != null) {
					_loc6_.adt = param1.adt;
				}
				if(param1.alt != null) {
					_loc6_.alt = param1.alt;
				}
				if(param1.apt != null) {
					_loc6_.apt = param1.apt;
				}
				if(param1.slt != null) {
					_loc6_.slt = param1.slt;
				}
				if(param1.rpt != null) {
					_loc6_.rpt = param1.rpt;
				}
				if(param1.aps != null) {
					_loc6_.aps = param1.aps;
				}
				if(param1.isp2p != null) {
					_loc6_.isp2p = param1.isp2p;
				}
				if(param1.bd != null) {
					_loc6_.bd = param1.bd;
				}
				if(param1.isped) {
					_loc6_.isped = param1.isped;
				}
				if(param1.fbt) {
					_loc6_.fbt = param1.fbt;
				}
				if(param1.utime != null) {
					_loc6_.utime = param1.utime;
				}
				if(param1.ontime != null) {
					_loc6_.ontime = param1.ontime;
				}
				if(PlayerConfig.isLive) {
					_loc6_.pt = "5";
				} else if(PlayerConfig.isFms) {
					_loc6_.pt = "2";
				} else if(PlayerConfig.isAlbumVideo) {
					_loc6_.pt = "22";
				} else {
					_loc6_.pt = "1";
				}
				
				
				if((PlayerConfig.isWebP2p) && !PlayerConfig.isLive) {
					_loc6_.pt = "10";
				}
				_loc6_.fms = PlayerConfig.isFms?"1":"0";
				if(param1.mycode != null) {
					_loc6_.mycode = param1.mycode;
				}
				if(param1.vvmark != null) {
					_loc6_.vvmark = param1.vvmark;
					if(!(!(param1.isClipsVV == null) && param1.isClipsVV == true)) {
						if(param1.code == PlayerConfig.VINFO_CODE && !(param1.error == 0)) {
							if(PlayerConfig.otherInforSender == "") {
								InforSender.getInstance().sendMesg(InforSender.START,0,"","","http://pb.hd.sohu.com.cn/hdpb.gif",param1.error);
								InforSender.getInstance().sendIRS();
							}
						} else if(PlayerConfig.otherInforSender == "") {
							InforSender.getInstance().sendMesg(InforSender.START,0,"","","http://pb.hd.sohu.com.cn/hdpb.gif");
							InforSender.getInstance().sendIRS();
						}
						
						if(PlayerConfig.isMyTvVideo) {
							_loc12_ = "";
							if(!(Model.getInstance().videoInfo == null) && !(Model.getInstance().videoInfo.status == null) && !(Model.getInstance().videoInfo.status == "") && Model.getInstance().videoInfo.status == 12) {
								_loc12_ = "&status=" + Model.getInstance().videoInfo.status;
							}
							new URLLoaderUtil().send("http://vstat.v.blog.sohu.com/dostat.do?method=setVideoPlayCount&v=" + PlayerConfig.vid + _loc12_ + "&playlistId=" + PlayerConfig.vrsPlayListId + "&c=" + PlayerConfig.cid + "&vc=" + encodeURIComponent(PlayerConfig.catcode) + "&uid=" + PlayerConfig.userId + "&plat=" + (PlayerConfig.domainProperty == "3"?"flash_56":"flash") + "&os=" + Utils.cleanTrim(Capabilities.os) + "&online=0" + "&type=" + _loc6_.type + (PlayerConfig.ktvId != ""?"&ktvId=" + PlayerConfig.ktvId:"") + "&o=" + PlayerConfig.myTvUserId + "&r=" + (PlayerConfig.currentPageUrl == ""?escape(PlayerConfig.outReferer):escape(PlayerConfig.currentPageUrl)) + "&time=" + new Date().getTime());
						}
					}
					if(PlayerConfig.playOrder != "") {
						new URLLoaderUtil().send("http://secure-cn.imrworldwide.com/cgi-bin/m?ci=cn-sohu&cg=0&cc=1&si=sohu2011/" + PlayerConfig.vrsPlayListId + "/" + PlayerConfig.playOrder + "/imp");
					}
				}
				if(param1.datarate != null) {
					_loc6_.datarate = param1.datarate;
				}
				if(param1.isdl != null) {
					_loc6_.isdl = param1.isdl;
				}
				if(param1.code == PlayerConfig.BUFFER_CODE) {
					this._intervalBufferNum++;
				}
				switch(param1.code) {
					case PlayerConfig.VINFO_CODE:
						_loc13_ = 0;
						if(PlayerConfig.tempParam) {
							_loc13_ = 0;
							PlayerConfig.tempParam = false;
						} else {
							_loc13_ = PlayerConfig.seekTo;
						}
						_loc6_.seekto = _loc13_;
						_loc6_.def = PlayerConfig.definition;
						_loc6_.isp2p = P2PExplorer.getInstance().hasP2P?PlayerConfig.gslbErrorIp != ""?0:1:0;
						_loc6_.os = escape(Capabilities.os);
						if(!this._isSentDefPause) {
							this._isSentDefPause = true;
							_loc6_.autoPlay = PlayerConfig.autoPlay?"1":"0";
							if(!(Model.getInstance().videoInfo == null) && !(Model.getInstance().videoInfo.status == null) && !(Model.getInstance().videoInfo.status == "") && !(Model.getInstance().videoInfo.status == 3)) {
								this.sendAndLoadPlayCount();
							}
						}
						break;
					case PlayerConfig.BUFFER_CODE:
						if(param1.allbufno == 15) {
							this.sendDebugInfo({
								"url":"http://um.hd.sohu.com/u.gif",
								"type":"player",
								"code":PlayerConfig.BUFFER_CODE,
								"error":param1.error,
								"debuginfo":LogManager.getMsg(),
								"sid":PlayerConfig.sid,
								"uid":PlayerConfig.userId,
								"time":new Date().getTime()
							});
						}
						break;
					case PlayerConfig.CDN_CODE:
						if(param1.error != 0) {
							this.sendDebugInfo({
								"url":"http://um.hd.sohu.com/u.gif",
								"type":"player",
								"code":PlayerConfig.CDN_CODE,
								"error":param1.error,
								"debuginfo":LogManager.getMsg(),
								"sid":PlayerConfig.sid,
								"uid":PlayerConfig.userId,
								"time":new Date().getTime()
							});
						}
						break;
					case PlayerConfig.GSLB_CODE:
						if(param1.error != 0) {
							this.sendDebugInfo({
								"url":"http://um.hd.sohu.com/u.gif",
								"type":"player",
								"code":PlayerConfig.GSLB_CODE,
								"error":param1.error,
								"debuginfo":LogManager.getMsg(),
								"sid":PlayerConfig.sid,
								"uid":PlayerConfig.userId,
								"time":new Date().getTime()
							});
						}
						break;
				}
				if(!(param1.isClipsVV == null) && param1.isClipsVV == true && !PlayerConfig.isLive) {
					_loc3_ = _loc5_;
				} else if(!PlayerConfig.isFms && !PlayerConfig.isLive && (param1.code == PlayerConfig.CDN_CODE || param1.code == PlayerConfig.GSLB_CODE || param1.code == PlayerConfig.BUFFER_CODE)) {
					_loc14_ = new URLRequest(_loc5_);
					_loc14_.method = URLRequestMethod.GET;
					_loc14_.data = _loc6_;
					if(!(param1.code == PlayerConfig.BUFFER_CODE && !(param1.bufno == null) && !(param1.bufno == 1) && !(param1.bufno == 4))) {
						sendToURL(_loc14_);
					}
				}
				
				_loc8_ = new URLRequest(_loc3_);
				if(param1.code == PlayerConfig.VINFO_CODE && param1.error == PlayerConfig.VINFO_ERROR_1) {
					_loc8_.method = URLRequestMethod.POST;
					if(param1.vrsdata != null) {
						_loc6_.vrsdata = param1.vrsdata;
					}
					if(param1.pagehtml != null) {
						_loc6_.pagehtml = param1.pagehtml;
					}
					if(param1.vid != null) {
						_loc6_.vid = param1.vid;
					}
				} else {
					_loc8_.method = URLRequestMethod.GET;
				}
				_loc8_.data = _loc6_;
				if(!(param1.code == PlayerConfig.BUFFER_CODE && !(param1.allbufno == null) && !(param1.allbufno == 1) && !(param1.allbufno == 4))) {
					sendToURL(_loc8_);
				}
				if(param1.code == PlayerConfig.VINFO_CODE) {
					_loc15_ = "1";
					_loc16_ = "7395122";
					_loc17_ = "";
					_loc18_ = "";
					_loc19_ = "";
					_loc20_ = PlayerConfig.isLive?"live_show":"";
					_loc21_ = PlayerConfig.userId;
					_loc22_ = new Array("c1=",_loc15_,"&c2=",_loc16_,"&c3=",_loc17_,"&c4=",_loc18_,"&c5=",_loc19_,"&c6=",_loc20_,"&c11=",_loc21_).join("");
					_loc23_ = new URLRequest("http://b.scorecardresearch.com/b?" + _loc22_);
					sendToURL(_loc23_);
				}
			}
		}
		
		public function sendDebugInfo(param1:Object) : void {
			var _loc2_:Object = {
				"type":param1.type,
				"code":param1.code,
				"error":param1.error,
				"debuginfo":param1.debuginfo,
				"uid":param1.uid,
				"sid":param1.sid,
				"time":param1.time
			};
			new URLLoaderUtil().send(param1.url,{
				"method":"POST",
				"dataType":"u",
				"data":_loc2_
			});
		}
		
		public function sendFeedback() : void {
			var _loc1_:* = "http://feedback.vrs.sohu.com/uploadLog.html";
			var _loc2_:URLRequest = new URLRequest(_loc1_);
			this._loader = new URLLoader();
			_loc2_.method = URLRequestMethod.POST;
			var _loc3_:URLVariables = new URLVariables();
			_loc3_.log = encodeURIComponent("主播放器日志：" + LogManager.getMsg() + "广告日志：" + AdLog.getMsg());
			_loc2_.data = _loc3_;
			this._loader.addEventListener(Event.COMPLETE,this.loaderComplete);
			this._loader.addEventListener(IOErrorEvent.IO_ERROR,this.loaderIoError);
			this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.loaderSecurityError);
			this._loader.load(_loc2_);
		}
		
		private function loaderComplete(param1:Event) : void {
			var _loc2_:Object = new ebing.net.JSON().parse(param1.target.data);
			if(_loc2_.status == 1 && !(_loc2_.logId == null) && !(_loc2_.logId == "")) {
				Utils.openWindow(FEEDBACK_PATH + "&logId=" + _loc2_.logId,"_blank");
			} else {
				Utils.openWindow(FEEDBACK_PATH,"_blank");
			}
		}
		
		private function loaderIoError(param1:Event) : void {
			Utils.openWindow(FEEDBACK_PATH,"_blank");
		}
		
		private function loaderSecurityError(param1:Event) : void {
			Utils.openWindow(FEEDBACK_PATH,"_blank");
		}
		
		private function sendAndLoadPlayCount() : void {
			var enc:String = null;
			var isHdVid:Boolean = false;
			var tArr:Array = null;
			var _xxtea:XXTEA = null;
			var currTime:Number = NaN;
			if(!PlayerConfig.isTransition && !PlayerConfig.isMyTvVideo && !PlayerConfig.isLive) {
				enc = "";
				if((PlayerConfig.isLpc) && !(PlayerConfig.hotVrSyst == "")) {
					tArr = PlayerConfig.hotVrSyst.split("&m=");
					if(!PlayerConfig.autoPlay) {
						currTime = new Date().getTime();
						tArr[0] = String(Number(tArr[0]) + Math.abs(currTime - Number(tArr[1])));
					}
					_xxtea = new XXTEA();
					enc = "&enc=" + encodeURIComponent(_xxtea.NetEncrypt("syst=" + tArr[0],int(Number(PlayerConfig.tvid) % 127)));
				}
				isHdVid = !(this._qfltype == "") && !PlayerConfig.isLive && !(PlayerConfig.hdVid == "")?true:false;
				new URLLoaderUtil().load(10,function(param1:Object):void {
					if(param1.info == "success") {
						_playCount = param1.data;
					}
				},"http://count.vrs.sohu.com/count/stat.do?videoId=" + (isHdVid?PlayerConfig.hdVid:PlayerConfig.vid) + "&tvid=" + PlayerConfig.tvid + (Model.getInstance().videoInfo.status == 12?"&status=12":"") + "&playlistId=" + PlayerConfig.vrsPlayListId + "&categoryId=" + PlayerConfig.caid + "&catecode=" + encodeURIComponent(PlayerConfig.catcode) + "&uid=" + PlayerConfig.userId + "&plat=flash" + "&os=" + Utils.cleanTrim(Capabilities.os) + "&online=0" + "&type=" + (PlayerConfig.isMyTvVideo?"my":(PlayerConfig.isTransition) || !PlayerConfig.isLongVideo?"vms":"vrs") + "&r=" + (PlayerConfig.currentPageUrl == ""?escape(PlayerConfig.outReferer):escape(PlayerConfig.currentPageUrl)) + "&t=" + (new Date().getTime() + Math.random()) + enc);
			}
		}
		
		public function liveHeart(param1:String, param2:uint, param3:uint) : void {
			var _loc8_:String = null;
			var _loc9_:String = null;
			var _loc4_:* = "";
			if(PlayerConfig.isP2PLive) {
				_loc8_ = (Eif.available) && !(ExternalInterface.call("sohuHD.ifox.getVersion") == undefined)?"&v=" + ExternalInterface.call("sohuHD.ifox.getVersion"):"";
				_loc9_ = (Eif.available) && !(ExternalInterface.call("sohuHD.ifox.getChannelNum") == undefined)?"&channel=" + ExternalInterface.call("sohuHD.ifox.getChannelNum"):"";
				_loc4_ = "&xx=" + param2 + "&tvFileId=" + param1 + "&qmbn=" + param3 + _loc8_ + _loc9_;
			}
			var _loc5_:String = PlayerConfig.STAT_IP[STAT_IP_ID];
			var _loc6_:* = "http://" + _loc5_ + "/heart.do";
			var _loc7_:* = "http://114.80.179.90:8080/heart.do";
			new URLLoaderUtil().send(_loc6_ + "?code=1&uid=" + PlayerConfig.userId + "&lid=" + PlayerConfig.vid + "&buf=" + this._intervalBufferNum + _loc4_ + "&t=" + (new Date().getTime() + Math.random()));
			new URLLoaderUtil().send(_loc7_ + "?code=1&uid=" + PlayerConfig.userId + "&lid=" + PlayerConfig.vid + "&buf=" + this._intervalBufferNum + _loc4_ + "&t=" + (new Date().getTime() + Math.random()));
			this._intervalBufferNum = 0;
		}
		
		public function getPlayCount() : String {
			return this._playCount;
		}
		
		public function set isSentDefPause(param1:Boolean) : void {
			this._isSentDefPause = param1;
		}
		
		public function set qfltype(param1:String) : void {
			this._qfltype = param1;
		}
		
		public function get qfltype() : String {
			return this._qfltype;
		}
	}
}
