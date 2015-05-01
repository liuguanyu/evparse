package com.sohu.tv.mediaplayer.netstream {
	import flash.net.URLVariables;
	import ebing.net.*;
	import com.sohu.tv.mediaplayer.stat.*;
	import ebing.utils.*;
	import flash.events.*;
	import flash.utils.*;
	import com.sohu.tv.mediaplayer.PlayerConfig;
	import com.sohu.tv.mediaplayer.p2p.P2PExplorer;
	import ebing.Utils;
	import flash.system.Capabilities;
	import flash.net.NetConnection;
	import ebing.external.Eif;
	import flash.external.ExternalInterface;
	
	public class TvSohuNetStream extends NetStreamUtil {
		
		public function TvSohuNetStream(param1:NetConnection, param2:Boolean = false, param3:Boolean = false) {
			var connection:NetConnection = param1;
			var is200:Boolean = param2;
			var isWriteLog:Boolean = param3;
			this._errCdnIds = new Array();
			this._urlloader = new URLLoaderUtil();
			this._isWriteLog = isWriteLog;
			if(Eif.available) {
				ExternalInterface.addCallback("playUrlForXL",function(param1:String):void {
					doPlay(param1);
				});
			}
			super(connection,is200);
		}
		
		protected var _cdn301TimeLimit:int = 15;
		
		protected var _cdn200TimeLimit:int = 10;
		
		protected var _p2pTimeLimit:int = 20;
		
		protected var _cdnTimeoutId:Number = 0;
		
		protected var _cdnIP:String = "";
		
		protected var _cdnID:String = "";
		
		protected var _errCdnIds:Array;
		
		protected var _hasP2P:Boolean = false;
		
		protected var _urlloader:URLLoaderUtil;
		
		protected var _isnp:Boolean = false;
		
		protected var _isWriteLog:Boolean = false;
		
		protected var _smallSuppliers:Boolean = false;
		
		protected var _changeGSLBIP:Boolean = false;
		
		protected var _ipTime:int = 0;
		
		protected var _cdnNt:String = "";
		
		protected var _cdnArea:String = "";
		
		override public function play(... rest) : void {
			var p:URLVariables = null;
			var arguments:Array = rest;
			_isPlay = true;
			_gslbUrl = arguments[0];
			try {
				p = new URLVariables(_gslbUrl.split("?")[1]);
				_dragTime = p.start != undefined?Number(p.start):_dragTime;
			}
			catch(evt:Error) {
				_dragTime = 0;
			}
			this.checkP2P();
		}
		
		private function ttt() : void {
			var _loc3_:String = null;
			var _loc4_:String = null;
			var _loc5_:String = null;
			var _loc6_:String = null;
			var _loc7_:String = null;
			var _loc8_:String = null;
			var _loc9_:String = null;
			var _loc10_:uint = 0;
			var _loc11_:String = null;
			var _loc12_:String = null;
			var _loc13_:uint = 0;
			var _loc14_:Array = null;
			var _loc15_:Array = null;
			var _loc16_:* = false;
			var _loc1_:* = _gslbUrl.split("?").length > 1;
			var _loc2_:String = (PlayerConfig.lqd != ""?"&oth=" + PlayerConfig.lqd:"") + (PlayerConfig.lcode != ""?"&cd=" + PlayerConfig.lcode:"") + "&sz=" + (PlayerConfig.clientWidth + "_" + PlayerConfig.clientHeight) + "&md=" + PlayerConfig.cdnMd + (PlayerConfig.ugu != ""?"&ugu=" + PlayerConfig.ugu:"") + (PlayerConfig.ugcode != ""?"&ugcode=" + PlayerConfig.ugcode:"");
			if(this._hasP2P) {
				_loc3_ = !(PlayerConfig.synUrl == null) && !(PlayerConfig.synUrl[_clipNo] == null) && !(PlayerConfig.synUrl[_clipNo] == "")?"&new=" + PlayerConfig.synUrl[_clipNo]:"";
				_loc4_ = PlayerConfig.p2pTNum > 0?"&cdn=" + String(PlayerConfig.p2pTNum):"";
				_loc5_ = PlayerConfig.p2pSP > 0?"&sp=" + PlayerConfig.p2pSP:"";
				_loc6_ = PlayerConfig.area != ""?"&area=" + PlayerConfig.area:"";
				_loc7_ = PlayerConfig.isp != ""?"&isp=" + PlayerConfig.isp:"";
				_loc8_ = PlayerConfig.userId != ""?"&uid=" + PlayerConfig.userId:"";
				_loc9_ = PlayerConfig.ta_jm != ""?"&ta=" + escape(PlayerConfig.ta_jm):"";
				if(!(PlayerConfig.videoArr == null) && PlayerConfig.videoArr.length > _clipNo) {
					_loc13_ = 0;
					while(_loc13_ < _clipNo) {
						_loc10_ = _loc10_ + PlayerConfig.videoArr[_loc13_].time;
						_loc13_++;
					}
				}
				_loc11_ = "";
				if(PlayerConfig.isMyTvVideo) {
					_loc14_ = _gslbUrl.split("/");
					if(_loc14_.length > 1) {
						_loc11_ = PlayerConfig.gslbIp + _gslbUrl.substr(_gslbUrl.indexOf("/"),_gslbUrl.length);
					} else {
						_loc11_ = PlayerConfig.gslbIp + _gslbUrl;
					}
				} else {
					_loc11_ = _gslbUrl.replace("http://data.vod.itc.cn",PlayerConfig.gslbIp);
				}
				_loc12_ = PlayerConfig.CHECKP2PPATH + _loc11_ + (_loc1_?"&":"?") + "vid=" + PlayerConfig.currentVid + "&tvid=" + PlayerConfig.tvid + "&uuid=" + PlayerConfig.uuid + "&hashid=" + PlayerConfig.hashId[_clipNo] + "&key=" + PlayerConfig.key[_clipNo] + "&num=" + (_clipNo + 1) + "&pnum=" + String(PlayerConfig.playingSplit) + "&dnum=" + String(_clipNo) + "&ptime=" + (_dragTime == 0?PlayerConfig.playedTime:_loc10_) + "&dtime=" + _loc10_ + "&p2pflag=" + String(PlayerConfig.p2pflag) + "&size=" + PlayerConfig.fileSize[_clipNo] + _loc4_ + _loc3_ + _loc5_ + _loc6_ + _loc7_ + _loc8_ + _loc9_ + _loc2_ + (!(PlayerConfig.bfd == null) && !(PlayerConfig.bfd[_clipNo] == "")?"&bfd=" + PlayerConfig.bfd[_clipNo]:"") + ((PlayerConfig.isLive) && (PlayerConfig.isP2PLive)?"&liveid=" + PlayerConfig.vid:"") + "&fname=" + PlayerConfig.videoTitle + "&r=" + (new Date().getTime() + Math.random());
				PlayerConfig.allotip = PlayerConfig.gslbIp;
				_gslbUrl = _loc12_;
				this.doPlay(_gslbUrl);
			} else if(_is200) {
				this.loadLocationAndPlay();
			} else {
				_loc15_ = _gslbUrl.split("data.vod.itc.cn");
				if(!(PlayerConfig.synUrl == null) && PlayerConfig.synUrl.length > _clipNo && !(PlayerConfig.synUrl[_clipNo] == "")) {
					_gslbUrl = _gslbUrl + (_loc1_?"&":"?");
					_gslbUrl = _gslbUrl + ("new=" + PlayerConfig.synUrl[_clipNo]);
				}
				if(_loc15_.length <= 1) {
					_gslbUrl = "http://" + (PlayerConfig.gslbIp != ""?PlayerConfig.gslbIp + "/":"") + _gslbUrl;
				} else if(PlayerConfig.gslbIp != "") {
					_gslbUrl = _gslbUrl.replace("data.vod.itc.cn",PlayerConfig.gslbIp);
				}
				
				_loc16_ = _gslbUrl.split("?").length > 1;
				_gslbUrl = _gslbUrl + ((_loc16_?"&":"?") + (PlayerConfig.currentVid != ""?"vid=" + PlayerConfig.currentVid:"") + "&tvid=" + PlayerConfig.tvid + (PlayerConfig.userId != ""?"&uid=" + PlayerConfig.userId:"") + (PlayerConfig.ta_jm != ""?"&ta=" + escape(PlayerConfig.ta_jm):"") + _loc2_ + (!(PlayerConfig.bfd == null) && !(PlayerConfig.bfd[_clipNo] == "")?"&bfd=" + PlayerConfig.bfd[_clipNo]:""));
				PlayerConfig.allotip = PlayerConfig.gslbIp;
				if(this._isWriteLog) {
					LogManager.msg("段号：" + _clipNo + " 调度地址：" + _gslbUrl + " 方式：301");
				}
				this.doPlay(_gslbUrl);
			}
			
		}
		
		private function checkP2P() : void {
			if(PlayerConfig.gslbErrorIp == "") {
				if(PlayerConfig.isForbidP2P != "1") {
					if(P2PExplorer.getInstance().hasP2P) {
						if(!(PlayerConfig.hashId == null) && !(PlayerConfig.hashId[_clipNo] == "") && !(PlayerConfig.synUrl == null) && !(PlayerConfig.synUrl[_clipNo] == "")) {
							try {
								new URLLoaderUtil().load(1,this.handshakeReport,PlayerConfig.CHECKP2PPATH + "shakehand" + "?uuid=" + PlayerConfig.uuid + "&vid=" + PlayerConfig.vid + "&r=" + (new Date().getTime() + Math.random()));
							}
							catch(evt:ErrorEvent) {
								_hasP2P = false;
							}
						} else {
							this.handshakeReport({"info":"hashIdOrNewPathError"});
						}
					} else {
						this.handshakeReport({"info":"nop2p"});
					}
				} else {
					this.handshakeReport({"info":"forbidP2P"});
				}
			} else {
				this.handshakeReport({"info":"gslbIpError"});
			}
		}
		
		private function handshakeReport(param1:Object) : void {
			if(param1.info == "success") {
				this._hasP2P = true;
				if(this._isWriteLog) {
					LogManager.msg("段号：" + _clipNo + " P2P握手成功！握手地址：" + param1.target.url);
				}
			} else {
				this._hasP2P = false;
				if(this._isWriteLog) {
					LogManager.msg("段号：" + _clipNo + " P2P握手失败！失败原因：" + param1.info + (!(param1.info == "hashIdOrNewPathError") && !(param1.info == "forbidP2P") && !(param1.info == "gslbIpError") && !(param1.info == "nop2p") && !(param1.info == "liveMode")?" 握手地址：" + param1.target.url:""));
				}
			}
			this.ttt();
		}
		
		override protected function doPlay(param1:String) : void {
			var url:String = param1;
			super.checkPolicyFile = true;
			this._isnp = true;
			var boo:Boolean = url.split("?").length > 1;
			var vid:String = PlayerConfig.currentVid != ""?"&vid=" + PlayerConfig.currentVid:"";
			var uid:String = PlayerConfig.userId != ""?"&uid=" + PlayerConfig.userId:"";
			var ta:String = PlayerConfig.ta_jm != ""?"&ta=" + escape(PlayerConfig.ta_jm):"";
			var plat:String = "";
			var otherParameters:String = "";
			var newInfoStr:String = (PlayerConfig.lqd != ""?"&oth=" + PlayerConfig.lqd:"") + (PlayerConfig.lcode != ""?"&cd=" + PlayerConfig.lcode:"") + "&sz=" + (PlayerConfig.clientWidth + "_" + PlayerConfig.clientHeight) + "&md=" + PlayerConfig.cdnMd + (PlayerConfig.ugu != ""?"&ugu=" + PlayerConfig.ugu:"") + (PlayerConfig.ugcode != ""?"&ugcode=" + PlayerConfig.ugcode:"");
			if((this._hasP2P) || !_is200) {
				plat = "&plat=" + escape(Utils.cleanTrim("flash_" + Capabilities.os + "_ifox"));
			} else {
				plat = "&plat=" + escape(Utils.cleanTrim("flash_" + Capabilities.os));
				otherParameters = vid + "&tvid=" + PlayerConfig.tvid + uid + ta + newInfoStr;
			}
			var tempid:String = "";
			var cc:String = String(PlayerConfig.catcode).substr(0,3);
			if(cc == "115") {
				tempid = "&tempid=115";
			}
			if(boo) {
				url = url + "&ua=" + PlayerConfig.userAgent + (PlayerConfig.channel != ""?"&ch=" + PlayerConfig.channel:"") + (PlayerConfig.catcode != ""?"&catcode=" + PlayerConfig.catcode:"") + (!(PlayerConfig.vrsPlayListId == "") && (PlayerConfig.isSendPID)?"&pid=" + PlayerConfig.vrsPlayListId:"") + tempid + "&prod=flash&pt=1" + plat + (this._cdnNt != ""?"&n=" + this._cdnNt:"") + (this._cdnArea != ""?"&a=" + this._cdnArea:"") + (PlayerConfig.clientIp != ""?"&cip=" + PlayerConfig.clientIp:"") + otherParameters + "&uuid=" + PlayerConfig.uuid + "&url=" + (PlayerConfig.currentPageUrl == ""?escape(PlayerConfig.outReferer):escape(PlayerConfig.currentPageUrl));
			} else {
				url = url + "?ua=" + PlayerConfig.userAgent + (PlayerConfig.channel != ""?"&ch=" + PlayerConfig.channel:"") + (PlayerConfig.catcode != ""?"&catcode=" + PlayerConfig.catcode:"") + (!(PlayerConfig.vrsPlayListId == "") && (PlayerConfig.isSendPID)?"&pid=" + PlayerConfig.vrsPlayListId:"") + tempid + "&prod=flash&pt=1" + plat + (this._cdnNt != ""?"&n=" + this._cdnNt:"") + (this._cdnArea != ""?"&a=" + this._cdnArea:"") + (PlayerConfig.clientIp != ""?"&cip=" + PlayerConfig.clientIp:"") + otherParameters + "&uuid=" + PlayerConfig.uuid + "&url=" + (PlayerConfig.currentPageUrl == ""?escape(PlayerConfig.outReferer):escape(PlayerConfig.currentPageUrl));
			}
			super.doPlay(url);
			if(this._isWriteLog) {
				LogManager.msg("段号：" + _clipNo + " 最终播放地址：" + url);
			}
			this.clearCdnTimeout(false);
			var limit:int = 0;
			if(this._hasP2P) {
				limit = this._p2pTimeLimit;
			} else if(_is200) {
				limit = this._cdn200TimeLimit;
			} else {
				limit = this._cdn301TimeLimit;
			}
			
			this._cdnTimeoutId = setTimeout(function():void {
				close();
				dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS,false,false,{"code":"CDNTimeout"}));
			},limit * 1000);
		}
		
		public function clearCdnTimeout(param1:Boolean = true) : void {
			clearTimeout(this._cdnTimeoutId);
			if(param1) {
				this._p2pTimeLimit = 20;
			}
		}
		
		public function setP2PTimeLimit() : void {
			if((this._hasP2P) && this._p2pTimeLimit < 60) {
				this._p2pTimeLimit = this._p2pTimeLimit + 20;
			} else if(!this._hasP2P) {
				this._p2pTimeLimit = 20;
			}
			
		}
		
		public function initP2PTimeLimit() : void {
			if((this._hasP2P) && this._p2pTimeLimit < 60) {
				this._p2pTimeLimit = this._p2pTimeLimit + 20;
			} else if(!this._hasP2P) {
				this._p2pTimeLimit = 20;
			}
			
		}
		
		private function getUrlFilename(param1:String) : String {
			if(!param1 || param1 == null || param1 == "") {
				return "";
			}
			var _loc2_:Array = param1.split("/");
			return _loc2_[_loc2_.length - 1].split("?")[0];
		}
		
		protected function getUrlPath(param1:String) : String {
			if(!param1 || param1 == null || param1 == "") {
				return "";
			}
			var param1:String = param1.replace("http://data.vod.itc.cn","");
			return param1.split("?")[0];
		}
		
		override protected function loadLocationAndPlay() : void {
			var re:RegExp = new RegExp("\\?start=");
			var reData:RegExp = new RegExp("http\\:\\/\\/(.+?)\\/\\|([0-9]{1,4})\\|(.+?)\\|([^|]*)\\|?([01]?)\\|?([01]?)\\|([0-9]{1,6})\\|([0-9]{1,6})\\|([0-9]{1,6})");
			var boo:Boolean = re.test(_gslbUrl);
			var ips:String = "";
			var synUrl:String = "";
			if(this._errCdnIds.length > 0) {
				ips = "&idc=" + this._errCdnIds.join(",");
			}
			if(!(PlayerConfig.synUrl == null) && PlayerConfig.synUrl.length > _clipNo) {
				synUrl = "&new=" + PlayerConfig.synUrl[_clipNo];
			}
			var backupIP:String = "";
			if((this._changeGSLBIP) && !(PlayerConfig.backupGSLBIP == null) && this._ipTime < PlayerConfig.backupGSLBIP.length) {
				backupIP = PlayerConfig.backupGSLBIP[this._ipTime];
				this._ipTime++;
				if(this._ipTime == PlayerConfig.backupGSLBIP.length) {
					this._ipTime = 0;
				}
				this.changeGSLBIP = false;
			}
			var url:String = "";
			var key:String = !(PlayerConfig.key == null) && !(PlayerConfig.key[_clipNo] == null) && !(PlayerConfig.key[_clipNo] == "")?"&key=" + PlayerConfig.key[_clipNo]:"";
			var vid:String = PlayerConfig.currentVid != ""?"&vid=" + PlayerConfig.currentVid:"";
			var uid:String = PlayerConfig.userId != ""?"&uid=" + PlayerConfig.userId:"";
			var ta:String = PlayerConfig.ta_jm != ""?"&ta=" + escape(PlayerConfig.ta_jm):"";
			var newInfoStr:String = (PlayerConfig.lqd != ""?"&oth=" + PlayerConfig.lqd:"") + (PlayerConfig.lcode != ""?"&cd=" + PlayerConfig.lcode:"") + "&sz=" + (PlayerConfig.clientWidth + "_" + PlayerConfig.clientHeight) + "&md=" + PlayerConfig.cdnMd + (PlayerConfig.ugu != ""?"&ugu=" + PlayerConfig.ugu:"") + (PlayerConfig.ugcode != ""?"&ugcode=" + PlayerConfig.ugcode:"");
			url = "http://" + (backupIP != ""?backupIP:PlayerConfig.gslbIp) + "/yp2p?prot=9&prod=flash&pt=1&file=" + this.getUrlPath(_gslbUrl) + synUrl + ips + key + vid + "&tvid=" + PlayerConfig.tvid + uid + ta + newInfoStr + (!(PlayerConfig.bfd == null) && !(PlayerConfig.bfd[_clipNo] == "")?"&bfd=" + PlayerConfig.bfd[_clipNo]:"") + (!PlayerConfig.isWebP2p && (boo)?"&" + _gslbUrl.split("?")[1]:"") + "&t=" + Math.random();
			PlayerConfig.allotip = backupIP != ""?backupIP:PlayerConfig.gslbIp;
			if((PlayerConfig.isLive) && !PlayerConfig.isP2PLive) {
				url = "http://" + _gslbUrl + "&prot=9&prod=flash&pt=1&hasquick=" + (PlayerConfig.hasP2PLive?"1":"0") + key;
			}
			if(this._isWriteLog) {
				LogManager.msg("段号：" + _clipNo + " 调度地址：" + url + " 方式：200");
			}
			_gslbLoader = new URLLoaderUtil();
			_gslbLoader.load(10,function(param1:Object):void {
				var _loc2_:Object = null;
				var _loc3_:Object = null;
				var _loc4_:Array = null;
				var _loc5_:Array = null;
				_spend_num = PlayerConfig.allotSpend = param1.target.spend;
				if(param1.info == "success") {
					if(_isWriteLog) {
						LogManager.msg("段号：" + _clipNo + " CDN信息：" + param1.data);
					}
					if(param1.data == "quick") {
						dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS,false,false,{
							"code":"GSLB.Failed",
							"reason":"overload"
						}));
						return;
					}
					_loc2_ = new JSON().parse(param1.data);
					_url = _loc2_.url;
					if(_loc2_ != null) {
						PlayerConfig.cdnIp = _cdnIP = _loc2_.ip;
						PlayerConfig.cdnId = _cdnID = _loc2_.nid;
						PlayerConfig.clientIp = _loc2_.cip;
					} else {
						PlayerConfig.cdnIp = _url = "";
						PlayerConfig.cdnId = "";
						PlayerConfig.clientIp = "";
						_cdnNt = _cdnArea = "";
					}
					if(!(_loc2_.isSmallSup == null) && _loc2_.isSmallSup == "1" && (PlayerConfig.isWebP2p)) {
						LogManager.msg("smallSuppliers");
						_smallSuppliers = true;
					}
					if(_loc2_.n != null) {
						_cdnNt = _loc2_.n;
					}
					if(_loc2_.a != null) {
						_cdnArea = _loc2_.a;
					}
					if(_loc2_.qs != null) {
						PlayerConfig.gslbWay = _loc2_.qs;
					}
					if(!(_loc2_.allotType && _loc2_.allotType == "1")) {
						if(PlayerConfig.isMyTvVideo) {
							_url = "http://" + _gslbUrl;
							_loc3_ = {
								"allotType":_loc2_.allotType,
								"errType":"ugc"
							};
							InforSender.getInstance().sendMesg(InforSender.HISTORYPROBLEMS,0,"","","http://pb.hd.sohu.com.cn/hdpb.gif",0,_loc3_);
						} else if((PlayerConfig.isLive) && !PlayerConfig.isP2PLive) {
							_loc3_ = {
								"allotType":_loc2_.allotType,
								"errType":"livenop2plive"
							};
							InforSender.getInstance().sendMesg(InforSender.HISTORYPROBLEMS,0,"","","http://pb.hd.sohu.com.cn/hdpb.gif",0,_loc3_);
						} else {
							_loc4_ = _gslbUrl.split("data.vod.itc.cn");
							if(_loc4_.length > 1 && !(_url == "")) {
								_url = _gslbUrl.replace("http://data.vod.itc.cn",_url);
								_loc3_ = {
									"allotType":_loc2_.allotType,
									"errType":"data.vod.itc.cn"
								};
								InforSender.getInstance().sendMesg(InforSender.HISTORYPROBLEMS,0,"","","http://pb.hd.sohu.com.cn/hdpb.gif",0,_loc3_);
							}
						}
						
					}
					if(_gslbUrl.split("?").length > 1) {
						_loc5_ = _url.split("?");
						_url = _loc5_.length > 1?_loc5_[0] + "?" + _gslbUrl.split("?")[1] + "&" + _loc5_[1]:_loc5_[0] + "?" + _gslbUrl.split("?")[1];
					}
					doPlay(_url);
					dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS,false,false,{"code":"GSLB.Success"}));
				} else if(param1.info == "timeout") {
					dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS,false,false,{
						"code":"GSLB.Failed",
						"reason":"timeout"
					}));
				} else {
					dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS,false,false,{
						"code":"GSLB.Failed",
						"reason":"ioerror"
					}));
				}
				
			},url,null);
		}
		
		override public function close() : void {
			super.close();
		}
		
		public function sendCloseEvent() : void {
			var _loc1_:String = null;
			if(this._hasP2P) {
				_loc1_ = "http://127.0.0.1:8810/close" + "?uuid=" + PlayerConfig.uuid + "&vid=" + PlayerConfig.vid + "&num=" + (_clipNo + 1) + "&r=" + (new Date().getTime() + Math.random());
				this._urlloader.send(_loc1_);
			}
		}
		
		public function get cdnIP() : String {
			return this._cdnIP;
		}
		
		public function get cdnID() : String {
			return this._cdnID;
		}
		
		public function get hasP2P() : Boolean {
			return this._hasP2P;
		}
		
		public function addErrIp() : void {
			if(this._errCdnIds.indexOf(this._cdnID) == -1) {
				this._errCdnIds.unshift(this._cdnID);
			}
			if(this._errCdnIds.length > 3) {
				this._errCdnIds = this._errCdnIds.slice(0,2);
			}
		}
		
		public function set changeGSLBIP(param1:Boolean) : void {
			this._changeGSLBIP = param1;
		}
		
		public function get isnp() : Boolean {
			return this._isnp;
		}
		
		public function set isnp(param1:Boolean) : void {
			this._isnp = param1;
		}
	}
}
