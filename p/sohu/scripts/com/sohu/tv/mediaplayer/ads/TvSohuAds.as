package com.sohu.tv.mediaplayer.ads {
	import ebing.XXTEA;
	import ebing.Utils;
	import com.sohu.tv.mediaplayer.p2p.P2PExplorer;
	import com.sohu.tv.mediaplayer.PlayerConfig;
	import ebing.external.Eif;
	import flash.external.ExternalInterface;
	import flash.system.Capabilities;
	import flash.display.*;
	import flash.net.*;
	import flash.utils.*;
	import com.sohu.tv.mediaplayer.net.*;
	import com.sohu.tv.mediaplayer.stat.*;
	import ebing.net.*;
	import flash.events.*;
	
	public class TvSohuAds extends EventDispatcher {
		
		public function TvSohuAds(param1:Stage = null) {
			this._xxtea = new XXTEA();
			super();
			if(param1 != null) {
				this._stage = param1;
			}
			this.hardInit();
		}
		
		private static var singleton:TvSohuAds;
		
		public static function getInstance(param1:Stage = null) : TvSohuAds {
			if(singleton == null) {
				singleton = new TvSohuAds(param1);
			}
			return singleton;
		}
		
		private var _adsInfo_arr:Array;
		
		private var _hasAds:Boolean;
		
		private var _selectorStartAd:SelectorStartAd;
		
		private var _startAd:StartAd;
		
		private var _topLogoAd:TopLogoAd;
		
		private var _logoAd:LogoAd;
		
		private var _pauseAd;
		
		private var _endAd:EndAd;
		
		private var _middleAd:MiddleAd;
		
		private var _sogouAd:SogouAd;
		
		private var _topAd:TopAd;
		
		private var _bottomAd:BottomAd;
		
		private var _ctrlBarAd:CtrlBarAd;
		
		private var _func:Function;
		
		private var _stage:Stage;
		
		private var _adSo:SharedObject;
		
		private var _fetchAdsUrl:String = "";
		
		private var _vipUser:String = "";
		
		private var _illegal:Boolean = false;
		
		private var encNum:int = 0;
		
		private var _playAdTimeout:Number = 0;
		
		private var _startLoadAds:Number = 0;
		
		private var _spendTime:Number = 0;
		
		protected var _urlloader:TvSohuURLLoaderUtil;
		
		private var _xxtea:XXTEA;
		
		private function hardInit() : void {
			this.sysInit("start");
		}
		
		private function sysInit(param1:String = null) : void {
			if(param1 == "start") {
				this.newFunc();
				this.drawUi();
				this.addEvent();
			}
			this._vipUser = "";
		}
		
		private function addEvent() : void {
		}
		
		private function newFunc() : void {
			this._selectorStartAd = new SelectorStartAd({
				"width":this._stage.stageWidth,
				"height":this._stage.stageHeight
			});
			this._selectorStartAd.addEventListener(TvSohuAdsEvent.SELECTORFINISH,this.selectorAdFinish);
			this._startAd = new StartAd({
				"width":this._stage.stageWidth,
				"height":this._stage.stageHeight
			});
			this._topLogoAd = new TopLogoAd();
			this._logoAd = new LogoAd();
			this._pauseAd = new PauseAd2();
			this._endAd = new EndAd({
				"width":this._stage.stageWidth,
				"height":this._stage.stageHeight
			});
			this._middleAd = new MiddleAd({
				"width":this._stage.stageWidth,
				"height":this._stage.stageHeight
			});
			this._topAd = new TopAd();
			this._bottomAd = new BottomAd();
			this._ctrlBarAd = new CtrlBarAd();
			this._sogouAd = new SogouAd();
			try {
				this._adSo = SharedObject.getLocal("AD","/");
			}
			catch(e:*) {
			}
		}
		
		public function loadAdInfo(param1:Function) : void {
			var func:Function = param1;
			this._func = func;
			var vipUser:String = Utils.getBrowserCookie("fee_status");
			var ifoxVipUser:String = Utils.getBrowserCookie("fee_ifox");
			var vu:String = !(vipUser == "") || !(ifoxVipUser == "") && (P2PExplorer.getInstance().hasP2P)?"&vu=" + (vipUser != ""?vipUser:ifoxVipUser):"";
			this._vipUser = vu;
			var type:String = PlayerConfig.isTransition?"vms1":!PlayerConfig.isLongVideo?"vms2":PlayerConfig.isMyTvVideo?PlayerConfig.wm_user == "20"?"pgc":"my":"vrs";
			var pub_catecode:String = PlayerConfig.pub_catecode != ""?"&pub_catecode=" + PlayerConfig.pub_catecode:"";
			var qd:String = PlayerConfig.ch_key != ""?"&qd=" + PlayerConfig.ch_key:"";
			var _isIf:String = "";
			var refer:String = "";
			if((Eif.available) && (ExternalInterface.available)) {
				if(ExternalInterface.call("eval","window.top.location != window.self.location")) {
					_isIf = "1";
				} else {
					_isIf = "0";
				}
				refer = ExternalInterface.call("eval","document.referrer");
			}
			var newInfoStr:String = (PlayerConfig.lqd != ""?"&oth=" + PlayerConfig.lqd:"") + (PlayerConfig.lcode != ""?"&cd=" + PlayerConfig.lcode:"") + "&sz=" + (PlayerConfig.clientWidth + "_" + PlayerConfig.clientHeight) + "&md=" + PlayerConfig.adMd + (PlayerConfig.ugu != ""?"&ugu=" + PlayerConfig.ugu:"") + (PlayerConfig.ugcode != ""?"&ugcode=" + PlayerConfig.ugcode:"");
			this.encNum = this.randRange(0,127);
			var otherInfoStr:String = "&vid=" + PlayerConfig.vid + "&uid=" + PlayerConfig.userId + "&fee=" + (PlayerConfig.isFee?"1":"0") + vu + "&pageUrl=" + escape(PlayerConfig.currentPageUrl == ""?escape(PlayerConfig.outReferer):escape(PlayerConfig.currentPageUrl));
			var enc:String = "&ran=" + encodeURIComponent(this._xxtea.NetEncrypt(otherInfoStr,this.encNum)) + "_" + this.encNum;
			this._fetchAdsUrl = PlayerConfig.FETCH_ADS_PATCH + "?cat=" + PlayerConfig.cmscat + "&pver=" + Capabilities.version + "&type=" + type + "&al=" + ((PlayerConfig.isMyTvVideo) && PlayerConfig.wm_user == "20"?Number(PlayerConfig.plid):Number(PlayerConfig.vrsPlayListId)) + "&vid=" + PlayerConfig.vid + "&tvid=" + PlayerConfig.tvid + "&c=" + PlayerConfig.channel + "&vc=" + PlayerConfig.catcode + "&act=" + PlayerConfig.act + "&st=" + PlayerConfig.mainActorId + "&ar=" + PlayerConfig.areaId + "&ye=" + PlayerConfig.year + "&fee=" + (PlayerConfig.isFee?"1":"0") + "&isIf=" + _isIf + "&du=" + PlayerConfig.totalDuration + (PlayerConfig.xuid != ""?"&pgy=" + PlayerConfig.xuid:"") + "&out=" + PlayerConfig.domainProperty + "&uid=" + PlayerConfig.userId + pub_catecode + qd + (PlayerConfig.adReview != ""?"&review=" + PlayerConfig.adReview:"") + (PlayerConfig.apiKey != ""?"&ak=" + PlayerConfig.apiKey:"") + (PlayerConfig.liveType != ""?"&lid=" + PlayerConfig.vid:"") + "&autoPlay=" + (PlayerConfig.autoPlay?"1":"0") + (PlayerConfig.txid != ""?"&txid=" + PlayerConfig.txid:"") + "&crid=" + PlayerConfig.crid + vu + enc + newInfoStr + (PlayerConfig.myTvUserId != ""?"&myTvUid=" + PlayerConfig.myTvUserId:"") + (PlayerConfig.tag != ""?"&tag=" + encodeURIComponent(PlayerConfig.tag):"") + "&pageUrl=" + escape(PlayerConfig.currentPageUrl == ""?escape(PlayerConfig.outReferer):escape(PlayerConfig.currentPageUrl)) + "&lrd=" + escape(PlayerConfig.landingrefer) + "&pagerefer=" + escape(escape(refer)) + "&ag=" + escape(PlayerConfig.age) + "&ti=" + encodeURIComponent(PlayerConfig.videoTitle);
			this.selectorAdIni();
			if(!this._selectorStartAd.hasAd) {
				this._urlloader = new TvSohuURLLoaderUtil();
				AdLog.msg("请求广告接口：" + this._fetchAdsUrl);
				this._urlloader.load(15,this.adsInfoHandler,this._fetchAdsUrl + "&m=" + new Date().getTime());
				this._startLoadAds = new Date().getTime();
				this._playAdTimeout = setTimeout(function():void {
					clearTimeout(_playAdTimeout);
					adsInfoHandler({
						"info":"timeout2",
						"target":this
					});
				},1000 * 5);
			}
		}
		
		private function adsInfoHandler(param1:Object) : void {
			var errInfo:Object = null;
			var json:Object = null;
			var startAdPar:String = null;
			var endAdPar:String = null;
			var logoAdPar:String = null;
			var logoAdDelayPar:String = null;
			var logoAdIntervalPar:String = null;
			var logoAdClickPar:String = null;
			var clicklayerflogo:String = null;
			var logoAdFirsttimePar:String = null;
			var topLogoAdPar:String = null;
			var topLogoAdDelayPar:String = null;
			var topLogoAdClickPar:String = null;
			var pauseAdPar:String = null;
			var topAdPar:String = null;
			var topAdDelayPar:String = null;
			var topAdClickPar:String = null;
			var bottomAdPar:String = null;
			var bottomAdDelayPar:String = null;
			var bottomAdClickPar:String = null;
			var ctrlBarAdPar:String = null;
			var sogouAdPar:String = null;
			var logoAdPingback:String = null;
			var topLogoAdPingback:String = null;
			var pauseAdPingback:String = null;
			var topAdPingback:String = null;
			var bottomAdPingback:String = null;
			var ctrlBarAdPingback:String = null;
			var ctrlBarAdClickPar:String = null;
			var clicklayerfbar:String = null;
			var _oadvol:String = null;
			var dataStr:String = null;
			var j:Object = null;
			var i:uint = 0;
			var obj:Object = param1;
			this._spendTime = (new Date().getTime() - this._startLoadAds) / 1000;
			AdLog.msg("广告接口返回：" + obj.info + "：： : " + (obj.info == "ioError"?"status : " + obj.status:" ") + ": : : spend：" + this._spendTime.toFixed(2));
			clearTimeout(this._playAdTimeout);
			if(obj.info == "timeout2") {
				errInfo = {
					"num":"1",
					"errType":"timeout",
					"outTime":5
				};
				InforSender.getInstance().sendMesg(InforSender.FF,0,"","","http://pb.hd.sohu.com.cn/hdpb.gif",0,errInfo);
			} else {
				if(this._spendTime > 5 && this._spendTime < 15) {
					this._urlloader.close();
					errInfo = {
						"num":"1",
						"errType":obj.info,
						"spendTime":this._spendTime.toFixed(2)
					};
					InforSender.getInstance().sendMesg(InforSender.FF,0,"","","http://pb.hd.sohu.com.cn/hdpb.gif",0,errInfo);
					return;
				}
				if(this._spendTime >= 15) {
					this._urlloader.close();
					errInfo = {
						"num":"1",
						"errType":obj.info,
						"outTime":15
					};
					InforSender.getInstance().sendMesg(InforSender.FF,0,"","","http://pb.hd.sohu.com.cn/hdpb.gif",0,errInfo);
					return;
				}
			}
			if(obj.info == "success") {
				PlayerConfig.adinfoSpend = obj.target.spend;
				try {
					dataStr = this._xxtea.NetDecrypt(obj.data,this.encNum);
					AdLog.msg("==========广告信息(json)开始==========");
					AdLog.msg(dataStr);
					AdLog.msg("==========广告信息(json)结束==========");
					json = new ebing.net.JSON().parse(dataStr);
					this.encNum = 0;
				}
				catch(evt:*) {
					InforSender.getInstance().sendMesg(InforSender.FF,0,"","","http://pb.hd.sohu.com.cn/hdpb.gif",0,{
						"num":"1",
						"errType":"decoderror"
					});
					if(_vipUser == "") {
						_illegal = true;
					}
				}
				startAdPar = "";
				endAdPar = "";
				logoAdPar = "";
				logoAdDelayPar = "";
				logoAdIntervalPar = "";
				logoAdClickPar = "";
				clicklayerflogo = "";
				logoAdFirsttimePar = "";
				topLogoAdPar = "";
				topLogoAdDelayPar = "";
				topLogoAdClickPar = "";
				pauseAdPar = "";
				topAdPar = "";
				topAdDelayPar = "";
				topAdClickPar = "";
				bottomAdPar = "";
				bottomAdDelayPar = "";
				bottomAdClickPar = "";
				ctrlBarAdPar = "";
				sogouAdPar = "";
				logoAdPingback = "";
				topLogoAdPingback = "";
				pauseAdPingback = "";
				topAdPingback = "";
				bottomAdPingback = "";
				ctrlBarAdPingback = "";
				ctrlBarAdClickPar = "";
				clicklayerfbar = "";
				_oadvol = "";
				if(!(json == null) && json.status == 1) {
					AdLog.msg("==========广告status正常==========");
					startAdPar = this.getPar(json.data.oad);
					if(this.getPar(json.data.oadvol) != "") {
						if(this.getPar(json.data.oadvol) == "0") {
							this.startAd.isMute = true;
						} else if(this.getPar(json.data.oadvol) == "1") {
							this.startAd.isMute = false;
						}
						
					}
					if(this.getPar(json.data.oadplaymode) != "") {
						if(this.getPar(json.data.oadplaymode) == "0") {
							this.startAd.isAutoPlayAd = false;
						} else if(this.getPar(json.data.oadplaymode) == "1") {
							this.startAd.isAutoPlayAd = true;
						}
						
					}
					if(!(this.getPar(json.data.ebt) == null) && !(this.getPar(json.data.ebt) == "")) {
						this.startAd.ebt = this.getPar(json.data.ebt);
					}
					endAdPar = this.getPar(json.data.ead);
					logoAdPar = this.getPar(json.data.flogoad);
					logoAdDelayPar = this.getPar(json.data.flogodelay);
					logoAdIntervalPar = this.getPar(json.data.flogointerval);
					logoAdPingback = this.getPar(json.data.flogopingback);
					logoAdClickPar = this.getPar(json.data.flogoclickurl);
					clicklayerflogo = this.getPar(json.data.clicklayerflogo);
					logoAdFirsttimePar = this.getPar(json.data.flogofirsttime);
					topLogoAdPar = this.getPar(json.data.tlogoad);
					topLogoAdDelayPar = this.getPar(json.data.tlogodelay);
					topLogoAdPingback = this.getPar(json.data.tlogopingback);
					topLogoAdClickPar = this.getPar(json.data.tlogoclickurl);
					pauseAdPar = "1";
					pauseAdPingback = this.getPar(json.data.padpingback);
					topAdPar = this.getPar(json.data.ftitlead);
					topAdDelayPar = this.getPar(json.data.ftitledelay);
					topAdPingback = this.getPar(json.data.ftitlepingback);
					topAdClickPar = this.getPar(json.data.ftitleclickurl);
					bottomAdPar = this.getPar(json.data.fbottomad);
					bottomAdDelayPar = this.getPar(json.data.fbottomdelay);
					bottomAdPingback = this.getPar(json.data.fbottompingback);
					bottomAdClickPar = this.getPar(json.data.fbottomclickurl);
					if(this.getPar(json.data.fbottomtype) != "") {
						if(this.getPar(json.data.fbottomtype) == "1") {
							this._bottomAd.isFButtomAd = true;
						} else if(this.getPar(json.data.fbottomtype) == "0") {
							this._bottomAd.isFButtomAd = false;
						}
						
					}
					ctrlBarAdPar = this.getPar(json.data.fbarad);
					ctrlBarAdPingback = this.getPar(json.data.fbarpingback);
					ctrlBarAdClickPar = this.getPar(json.data.fbarclickurl);
					clicklayerfbar = this.getPar(json.data.clicklayerfbar);
				} else {
					startAdPar = this.getParams("oad");
					endAdPar = this.getParams("ead");
					logoAdPar = this.getParams("flogoad");
					logoAdDelayPar = this.getParams("flogodelay");
					logoAdIntervalPar = this.getParams("flogointerval");
					logoAdFirsttimePar = this.getParams("flogofirsttime");
					topLogoAdPar = this.getParams("tlogoad");
					topLogoAdDelayPar = this.getParams("tlogodelay");
					pauseAdPar = this.getParams("pad");
					topAdPar = this.getParams("ftitlead");
					topAdDelayPar = this.getParams("ftitledelay");
					bottomAdPar = this.getParams("fbottomad");
					bottomAdDelayPar = this.getParams("fbottomdelay");
					ctrlBarAdPar = this.getParams("fbarad");
					if(!(startAdPar == "") || !(endAdPar == "") || !(logoAdPar == "") || !(logoAdFirsttimePar == "") || !(logoAdDelayPar == "") || !(logoAdIntervalPar == "") || !(topLogoAdPar == "") || !(topLogoAdDelayPar == "") || !(pauseAdPar == "") || !(topAdPar == "") || !(topAdDelayPar == "") || !(bottomAdPar == "") || !(bottomAdDelayPar == "") || !(ctrlBarAdPar == "")) {
						SendRef.getInstance().sendPQVPC("pl_oldad_show");
					}
					if(!(json == null) && json.status == 3 && !(json.data == null) && !(json.data.oad == null) && !(json.data.oad == "")) {
						j = new ebing.net.JSON().parse(json.data.oad.replace(new RegExp("\'","g"),"\""));
						i = 0;
						while(i < j.length) {
							if(j[i][3] != null) {
								new URLLoaderUtil().multiSend(j[i][3]);
							}
							i++;
						}
						if(!(json.data.flogopingback == null) && !(json.data.flogopingback == "")) {
							new URLLoaderUtil().send(json.data.flogopingback);
						}
						if(!(json.data.fbaradpingback == null) && !(json.data.fbaradpingback == "")) {
							new URLLoaderUtil().send(json.data.fbaradpingback);
						}
						if(!(json.data.padpingback == null) && !(json.data.padpingback == "")) {
							new URLLoaderUtil().send(json.data.padpingback);
						}
					}
					ErrorSenderPQ.getInstance().sendPQStat({
						"error":PlayerConfig.ADINFO_ERROR_OTHER,
						"code":PlayerConfig.REALVV_CODE
					});
					if(!(json == null) && !(json.status == null) && (json.status == -101 || json.status == -102)) {
						InforSender.getInstance().sendMesg(InforSender.FF,0,"","","http://pb.hd.sohu.com.cn/hdpb.gif",0,{
							"num":"1",
							"errType":(json.status == -101?"tampercipher":"tamperparams")
						});
						if(this._vipUser == "") {
							startAdPar = "[[\'http://images.sohu.com/ytv/SH/Unilever/8/44/" + Utils.createUID() + ".mp4\',60,\'\',\'\',\'\',\'\',\'\',\'0\']]";
						}
					}
				}
				if(this._vipUser != "") {
					this._startAd.isAdTip = true;
				} else {
					this._startAd.isAdTip = false;
				}
				if((obj.selectedVideo) && !(obj.selectedVideo == null)) {
					AdLog.msg("==========前贴广告部分开始==========");
					this._startAd.softInit({
						"adPar":startAdPar,
						"selectedVideo":obj.selectedVideo
					});
					AdLog.msg("==========前贴广告部分结束==========");
				} else if(this._vipUser == "" && (json == null || json.status == null)) {
					SendRef.getInstance().sendPQVPC("3");
					this._illegal = true;
				} else {
					AdLog.msg("==========前贴广告部分开始==========");
					this._startAd.softInit({"adPar":startAdPar});
					AdLog.msg("==========前贴广告部分结束==========");
				}
				
				this._logoAd.softInit({
					"adPar":logoAdPar,
					"adClick":logoAdClickPar,
					"adDelayPar":logoAdDelayPar,
					"adIntervalPar":logoAdIntervalPar,
					"adPingback":logoAdPingback,
					"adClicklayerflogo":clicklayerflogo,
					"adFirsttimePar":logoAdFirsttimePar
				});
				this._topLogoAd.softInit({
					"adPar":topLogoAdPar,
					"adClick":topLogoAdClickPar,
					"adDelayPar":topLogoAdDelayPar,
					"adPingback":topLogoAdPingback
				});
				this._pauseAd.softInit({
					"adPar":pauseAdPar,
					"adPingback":pauseAdPingback
				});
				AdLog.msg("==========后贴广告部分开始==========");
				this._endAd.softInit({"adPar":endAdPar});
				AdLog.msg("==========后贴广告部分结束==========");
				this._topAd.softInit({
					"adPar":topAdPar,
					"adClick":topAdClickPar,
					"adDelayPar":topAdDelayPar,
					"adPingback":topAdPingback
				});
				this._bottomAd.softInit({
					"adPar":bottomAdPar,
					"adClick":bottomAdClickPar,
					"adDelayPar":bottomAdDelayPar,
					"adPingback":bottomAdPingback
				});
				this._sogouAd.softInit({"adPar":sogouAdPar});
				this._ctrlBarAd.softInit({
					"adPar":ctrlBarAdPar,
					"adClick":ctrlBarAdClickPar,
					"adPingback":ctrlBarAdPingback,
					"adClicklayerfbar":clicklayerfbar
				});
				this.hasAds = true;
			} else {
				startAdPar = this.getParams("oad");
				endAdPar = this.getParams("ead");
				logoAdPar = this.getParams("flogoad");
				logoAdFirsttimePar = this.getParams("flogofirsttime");
				logoAdDelayPar = this.getParams("flogodelay");
				logoAdIntervalPar = this.getParams("flogointerval");
				topLogoAdPar = this.getParams("tlogoad");
				topLogoAdDelayPar = this.getParams("tlogodelay");
				pauseAdPar = this.getParams("pad");
				topAdPar = this.getParams("ftitlead");
				topAdDelayPar = this.getParams("ftitledelay");
				bottomAdPar = this.getParams("fbottomad");
				bottomAdDelayPar = this.getParams("fbottomdelay");
				ctrlBarAdPar = this.getParams("fbarad");
				if(!(startAdPar == "") || !(endAdPar == "") || !(logoAdPar == "") || !(logoAdFirsttimePar == "") || !(logoAdDelayPar == "") || !(logoAdIntervalPar == "") || !(topLogoAdPar == "") || !(topLogoAdDelayPar == "") || !(pauseAdPar == "") || !(topAdPar == "") || !(topAdDelayPar == "") || !(bottomAdPar == "") || !(bottomAdDelayPar == "") || !(ctrlBarAdPar == "")) {
					SendRef.getInstance().sendPQVPC("pl_oldad_show");
				}
				if(obj.info == "timeout") {
					ErrorSenderPQ.getInstance().sendPQStat({
						"error":PlayerConfig.ADINFO_ERROR_TIMEOUT,
						"code":PlayerConfig.REALVV_CODE,
						"utime":obj.target.spend
					});
				} else if(obj.info == "securityError" || obj.info == "ioError") {
					InforSender.getInstance().sendMesg(InforSender.FF,0,"","","http://pb.hd.sohu.com.cn/hdpb.gif",0,{
						"num":"1",
						"errType":obj.info
					});
					if(this._vipUser == "") {
						startAdPar = "[[\'http://images.sohu.com/ytv/SH/Unilever/8/44/" + Utils.createUID() + ".mp4\',60,\'\',\'\',\'\',\'\',\'\',\'0\']]";
					}
				} else {
					ErrorSenderPQ.getInstance().sendPQStat({
						"error":PlayerConfig.ADINFO_ERROR_FAILED,
						"code":PlayerConfig.REALVV_CODE
					});
				}
				
				if((obj.selectedVideo) && !(obj.selectedVideo == null)) {
					AdLog.msg("==========前贴广告部分开始==========");
					this._startAd.softInit({
						"adPar":startAdPar,
						"selectedVideo":obj.selectedVideo
					});
					AdLog.msg("==========前贴广告部分结束==========");
				} else {
					AdLog.msg("==========前贴广告部分开始==========");
					this._startAd.softInit({"adPar":startAdPar});
					AdLog.msg("==========前贴广告部分结束==========");
				}
				this._logoAd.softInit({
					"adPar":logoAdPar,
					"adDelayPar":logoAdDelayPar,
					"adIntervalPar":logoAdIntervalPar,
					"adFirsttimePar":logoAdFirsttimePar
				});
				this._topLogoAd.softInit({
					"adPar":topLogoAdPar,
					"adDelayPar":topLogoAdDelayPar
				});
				this._pauseAd.softInit({"adPar":pauseAdPar});
				AdLog.msg("==========后贴广告部分开始==========");
				this._endAd.softInit({"adPar":endAdPar});
				AdLog.msg("==========后贴广告部分结束==========");
				this._topAd.softInit({
					"adPar":topAdPar,
					"adDelayPar":topAdDelayPar
				});
				this._bottomAd.softInit({
					"adPar":bottomAdPar,
					"adDelayPar":bottomAdDelayPar
				});
				this._sogouAd.softInit({"adPar":sogouAdPar});
				this._ctrlBarAd.softInit({"adPar":ctrlBarAdPar});
				this.hasAds = true;
			}
			this._func();
		}
		
		private function getPar(param1:*) : String {
			var _loc2_:* = "";
			if(!(param1 == undefined) && !(param1 == null)) {
				_loc2_ = String(param1);
			}
			return _loc2_;
		}
		
		private function getTestData(param1:Number) : String {
			var _loc2_:* = "";
			var _loc3_:* = PlayerConfig.swfHost + "panel/ErrorAds.swf";
			var _loc4_:Number = 0;
			if(Math.round(param1) > 300) {
				_loc4_ = 60;
				_loc2_ = "[[\'" + _loc3_ + "\'," + _loc4_ + ",\'\',\'\',\'\',\'\',\'\',\'1\',\'0\',{},\'0\']]";
			} else if(Math.round(param1) > 60 && Math.round(param1) <= 300) {
				_loc4_ = 40;
				_loc2_ = "[[\'" + _loc3_ + "\'," + _loc4_ + ",\'\',\'\',\'\',\'\',\'\',\'1\',\'0\',{},\'0\']]";
			} else {
				return _loc2_;
			}
			
			return _loc2_;
		}
		
		private function selectorAdIni() : void {
			var _loc1_:String = this.getParams("soad");
			this._selectorStartAd.softInit({"adPar":_loc1_});
			if(this._selectorStartAd.hasAd) {
				this._selectorStartAd.play();
				SendRef.getInstance().sendPQVPC("pl_oldad_show");
			}
		}
		
		private function selectorAdFinish(param1:TvSohuAdsEvent) : void {
			if(this._selectorStartAd.hasAd) {
				this.adsInfoHandler({
					"info":"success",
					"selectedVideo":this._selectorStartAd.video
				});
			}
		}
		
		private function drawUi() : void {
		}
		
		private function dispatch(param1:String, param2:Object = null) : void {
			var _loc3_:TvSohuAdsEvent = new TvSohuAdsEvent(param1);
			_loc3_.obj = param2;
			dispatchEvent(_loc3_);
		}
		
		public function destroy() : void {
			if(!(this.startAd == null) && (this.startAd.hasAd) && (this.startAd.state == "playing" || this.startAd.state == "end")) {
				this.startAd.destroy();
			}
			if(!(this.endAd == null) && (this.endAd.hasAd)) {
				this.endAd.destroy();
			}
			if(!(this.ctrlBarAd == null) && (this.ctrlBarAd.hasAd)) {
				this.ctrlBarAd.destroy();
			}
		}
		
		public function get illegal() : Boolean {
			return this._illegal;
		}
		
		public function get hasAds() : Boolean {
			return this._hasAds;
		}
		
		public function set hasAds(param1:Boolean) : void {
			this._hasAds = param1;
		}
		
		public function screen() : * {
			return "";
		}
		
		public function get selectorStartAd() : SelectorStartAd {
			return this._selectorStartAd;
		}
		
		public function get startAd() : StartAd {
			return this._startAd;
		}
		
		public function get pauseAd() : * {
			return this._pauseAd;
		}
		
		public function get ctrlBarAd() : CtrlBarAd {
			return this._ctrlBarAd;
		}
		
		public function get logoAd() : LogoAd {
			return this._logoAd;
		}
		
		public function get topLogoAd() : TopLogoAd {
			return this._topLogoAd;
		}
		
		public function get sogouAd() : SogouAd {
			return this._sogouAd;
		}
		
		public function get topAd() : TopAd {
			return this._topAd;
		}
		
		public function get bottomAd() : BottomAd {
			return this._bottomAd;
		}
		
		public function get endAd() : EndAd {
			return this._endAd;
		}
		
		public function get middleAd() : MiddleAd {
			return this._middleAd;
		}
		
		public function set stage(param1:Stage) : void {
			this._stage = param1;
		}
		
		public function isFrequencyLimit(param1:String) : Boolean {
			var _loc5_:uint = 0;
			var _loc2_:Array = param1.split("|");
			if(_loc2_.length < 2 || this._adSo == null) {
				return false;
			}
			var _loc3_:Date = new Date();
			var _loc4_:String = this.doubleDigitFormat(_loc3_.month + 1) + this.doubleDigitFormat(_loc3_.date);
			if(!(this._adSo.data.adLimit == undefined) && !(this._adSo.data.adLimit == null)) {
				_loc5_ = 0;
				while(_loc5_ < this._adSo.data.adLimit.length) {
					if(this._adSo.data.adLimit[_loc5_].id == _loc2_[0]) {
						if(uint(this._adSo.data.adLimit[_loc5_].frequency) == 0 && this._adSo.data.adLimit[_loc5_].date == _loc4_) {
							return true;
						}
					}
					_loc5_++;
				}
			}
			return false;
		}
		
		public function doubleDigitFormat(param1:uint) : String {
			if(param1 < 10) {
				return "0" + param1.toString();
			}
			return param1.toString();
		}
		
		public function get fetchAdsUrl() : String {
			return this._fetchAdsUrl;
		}
		
		private function getParams(param1:String) : String {
			var _loc2_:* = "";
			if(this._stage.loaderInfo.parameters[param1] != null) {
				_loc2_ = String(this._stage.loaderInfo.parameters[param1]);
				_loc2_ = _loc2_.replace(new RegExp("\\^","g"),"&");
				_loc2_ = _loc2_.replace(new RegExp("#{3}","g"),"^");
			}
			return _loc2_;
		}
		
		private function randRange(param1:Number, param2:Number) : Number {
			var _loc3_:Number = Math.floor(Math.random() * (param2 - param1 + 1)) + param1;
			return _loc3_;
		}
	}
}
