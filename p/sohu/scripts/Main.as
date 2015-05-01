package {
	import flash.display.Sprite;
	import com.sohu.tv.mediaplayer.Model;
	import com.sohu.tv.mediaplayer.stat.ErrorSenderPQ;
	import com.sohu.tv.mediaplayer.ads.TvSohuAds;
	import flash.net.SharedObject;
	import flash.ui.ContextMenu;
	import com.sohu.tv.mediaplayer.ui.TvSohuErrorMsg;
	import com.sohu.tv.mediaplayer.ui.LogsPanel;
	import com.sohu.tv.mediaplayer.ui.VerInfoPanel;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import com.adobe.images.ButtonUi;
	import com.sohu.tv.mediaplayer.ads.AdPlayIllegal;
	import flash.events.Event;
	import com.sohu.tv.mediaplayer.PlayerConfig;
	import ebing.Utils;
	import ebing.external.Eif;
	import flash.external.ExternalInterface;
	import flash.system.Capabilities;
	import ebing.utils.LogManager;
	import com.sohu.tv.mediaplayer.p2p.P2PExplorer;
	import ebing.net.JSON;
	import flash.ui.ContextMenuItem;
	import flash.events.ContextMenuEvent;
	import com.sohu.tv.mediaplayer.ui.VerLog;
	import flash.net.SharedObjectFlushStatus;
	import flash.events.NetStatusEvent;
	import com.sohu.tv.mediaplayer.stat.SendRef;
	import flash.system.System;
	import com.sohu.tv.mediaplayer.video.RadioMpb;
	import com.sohu.tv.mediaplayer.video.TSZMpb;
	import com.sohu.tv.mediaplayer.video.TvSohuMediaPlayback;
	import com.sohu.tv.mediaplayer.stat.InforSender;
	import com.sohu.tv.mediaplayer.ads.TvSohuAdsEvent;
	import flash.events.KeyboardEvent;
	import flash.events.StageVideoAvailabilityEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.events.MouseEvent;
	import ebing.net.LoaderUtil;
	import ebing.events.MediaEvent;
	import flash.text.TextFormatAlign;
	import flash.utils.setTimeout;
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import com.sohu.tv.mediaplayer.ads.AdLog;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.events.TextEvent;
	import p2pstream.XNetStreamVODFactory;
	import com.sohu.tv.mediaplayer.netstream.PlayVODStream;
	import flash.media.StageVideoAvailability;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.system.Security;
	
	public class Main extends Sprite {
		
		public function Main() {
			super();
			this._owner = this;
			if(stage) {
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
			}
			Security.allowDomain("*");
			this._cacheFixed_num = setInterval(function():void {
				if(!(stage.stageWidth == 0) && !(stage.stageHeight == 0)) {
					clearInterval(_cacheFixed_num);
					sysInit("start");
				}
			},10);
		}
		
		private var _tvSohuMpb;
		
		private var _model:Model;
		
		private var _qfStat:ErrorSenderPQ;
		
		private var _cacheFixed_num:Number;
		
		private var _ads:TvSohuAds;
		
		private var _pauseAd:Number;
		
		private var _so:SharedObject;
		
		private var _isDrag:Boolean = false;
		
		private var _isAutoPlay:Boolean = true;
		
		private var _breakPoint:Number = 0;
		
		private var _tvSohuLoading;
		
		private var _tvSohuLoading_c:Sprite;
		
		private var _version:String = "";
		
		private var _autoFix:String = "";
		
		private var _bandwidth:Number = 0;
		
		private var _owner:Main;
		
		private var _isPlayStartAd:Boolean = true;
		
		private var _isShowPlayedAd:Boolean = false;
		
		private var _mpbSoftInitSuc:Boolean = false;
		
		private var _selectorStartAdContainer:Sprite;
		
		private var _startAdContainer:Sprite;
		
		private var _endAdContainer:Sprite;
		
		private var _middleAdContainer:Sprite;
		
		private var _mpbSoftInitObj:Object;
		
		private var _tvSohuMpbOk:Number;
		
		private var _width:Number;
		
		private var _height:Number;
		
		private var _tvSohuMpb_c:Sprite;
		
		private var _cm:ContextMenu;
		
		private var _bg:Sprite;
		
		private var _isPwd:Boolean = false;
		
		private var _errStatusSp:Sprite;
		
		private var _tvSohuErrorMsg:TvSohuErrorMsg;
		
		private var _logsPanel:LogsPanel;
		
		private var _verInfoPanel:VerInfoPanel;
		
		private var _isLoop:Boolean = false;
		
		private var _isNewsLogo:Boolean;
		
		private var _testVerTip:TextField;
		
		private var _fatText:TextFormat;
		
		private var _isFirstSend:Boolean = true;
		
		private var _isDownPreviewPic:Boolean = true;
		
		private var _isAutoLoop:Boolean = false;
		
		private var _isJsCallLoadAndPlay:Boolean = false;
		
		private var _btnUi:ButtonUi;
		
		private var _adPlayIllegal:AdPlayIllegal;
		
		private var _payPanel;
		
		private var _svdUserSo:SharedObject;
		
		public function sysInit(param1:String) : void {
			var flv:String = null;
			var sn:String = null;
			var str:String = null;
			var ran:int = 0;
			var obj:Object = null;
			var myTvVid:String = null;
			var re:RegExp = null;
			var re1:RegExp = null;
			var flag:String = param1;
			if(flag == "start") {
				stage.addEventListener(Event.RESIZE,this.resizeHandler);
				PlayerConfig.vid = this.getParams("vid");
				if(!(this.getParams("sid") == null) && !(this.getParams("sid") == "") && !(this.getParams("sid") == "null")) {
					PlayerConfig.sid = this.getParams("sid");
				} else if(!(Utils.getBrowserCookie("SUV") == null) && !(Utils.getBrowserCookie("SUV") == "") && !(Utils.getBrowserCookie("SUV") == "null")) {
					PlayerConfig.sid = Utils.getBrowserCookie("SUV");
				}
				
				if(Utils.getBrowserCookie("pagelianbo") != "") {
					PlayerConfig.lb = Utils.getBrowserCookie("pagelianbo");
					if(Eif.available) {
						ExternalInterface.call("function(){document.cookie=\"pagelianbo=;path=/;\"}");
					}
				}
				if(Utils.getBrowserCookie("YYID") != "") {
					PlayerConfig.yyid = Utils.getBrowserCookie("YYID");
				}
				PlayerConfig.pid = this.getParams("pid");
				PlayerConfig.nid = this.getParams("nid");
				PlayerConfig.playListId = this.getParams("playListId");
				flv = unescape(this.getParams("flv"));
				PlayerConfig.isPreview = this.getParams("preview") == "true"?true:false;
				PlayerConfig.isListPlay = this.getParams("isListPlay") == "0"?false:true;
				PlayerConfig.showPgcModule = this.getParams("showPgcModule") == "0" || this.getParams("hasPgcMode") == "0"?false:true;
				sn = this.getParams("skinNum");
				PlayerConfig.skinNum = !(sn == "") && !(sn == "2") && !(sn == "5") && !(sn == "6") && !(sn == "7")?sn:"1";
				PlayerConfig.autoPlay = this.getParams("autoplay") == "true" || this.getParams("autoPlay") == "true"?true:false;
				PlayerConfig.showRecommend = this.getParams("showRecommend") == "0"?false:true;
				PlayerConfig.recommendPath = this.getParams("recommend");
				PlayerConfig.coverImg = this.getParams("playercover");
				PlayerConfig.showAds = this.getParams("adss") == "0"?false:true;
				PlayerConfig.hasApi = this.getParams("api") == "1"?true:false;
				PlayerConfig.outReferer = this.getParams("pageurl");
				PlayerConfig.isHide = this.getParams("showCtrlBar") == "0"?true:false;
				PlayerConfig.isHideTip = this.getParams("showTipHistory") == "0"?true:false;
				PlayerConfig.isJump = this.getParams("jump") == "0"?false:true;
				PlayerConfig.showCommentBtn = this.getParams("highlightBtn") == "1"?true:false;
				PlayerConfig.apiKey = this.getParams("api_key");
				PlayerConfig.liveType = this.getParams("ltype");
				if(PlayerConfig.liveType != "") {
					PlayerConfig.isLive = true;
				}
				PlayerConfig.userAgent = this.getParams("ua");
				PlayerConfig.plid = this.getParams("plid");
				PlayerConfig.pub_catecode = this.getParams("pub_catecode");
				PlayerConfig.ch_key = this.getParams("ch_key");
				PlayerConfig.atype = this.getParams("atype");
				PlayerConfig.showShareBtn = this.getParams("shareBtn") == "1"?true:false;
				PlayerConfig.showSogouBtn = this.getParams("sogouBtn") == "0"?false:true;
				PlayerConfig.showWiderBtn = this.getParams("widerBtn") == "1"?true:false;
				PlayerConfig.showIFoxBar = this.getParams("iFoxBar") == "0"?false:true;
				PlayerConfig.showMiniWinBtn = this.getParams("miniWinBtn") == "1"?true:false;
				PlayerConfig.showLangSetBtn = this.getParams("langSetBtn") == "1"?true:false;
				PlayerConfig.showTopBar = this.getParams("topBar") == "1"?true:false;
				PlayerConfig.topBarNor = this.getParams("topBarNor") == "1"?true:false;
				PlayerConfig.topBarFull = this.getParams("topBarFull") == "1"?true:false;
				PlayerConfig.showDownloadBtn = this.getParams("downloadBtn") == "1"?true:false;
				PlayerConfig.startTime = this.getParams("startTime");
				PlayerConfig.endTime = this.getParams("endTime");
				PlayerConfig.adReview = this.getAdReview();
				PlayerConfig.cooperator = this.getParams("cooperator");
				PlayerConfig.isMute = this.getParams("mute") == "1"?true:false;
				PlayerConfig.passportUID = this.getPassportUID();
				PlayerConfig.passportMail = this.getPassportMail();
				PlayerConfig.xuid = this.getParams("xuid");
				PlayerConfig.onPlay = this.getParams("onPlay");
				PlayerConfig.onPause = this.getParams("onPause");
				PlayerConfig.onPlayed = this.getParams("onPlayed");
				PlayerConfig.onPlayerReady = this.getParams("onPlayerReady");
				PlayerConfig.onEndAdStop = this.getParams("onEndAdStop");
				PlayerConfig.onBufferEmpty = this.getParams("onBufferEmpty");
				PlayerConfig.onStop = this.getParams("onStop");
				PlayerConfig.onMAdShown = this.getParams("onMAdShown");
				PlayerConfig.onMAdFinish = this.getParams("onMAdFinish");
				PlayerConfig.isSendPID = this.getParams("isSendPID") == "1"?true:false;
				PlayerConfig.currentPageUrl = this.getPageURL();
				PlayerConfig.flashVersion = Capabilities.version;
				PlayerConfig.playerReffer = stage.loaderInfo.url;
				PlayerConfig.isSohuDomain = this.isSohuDomain();
				PlayerConfig.isPartner = this.isPartner();
				PlayerConfig.seekTo = this.getSeekTo();
				PlayerConfig.timestamp = new Date().getTime();
				PlayerConfig.swfHost = this.getSwfHost();
				PlayerConfig.uuid = this.getParams("uuid") != ""?this.getParams("uuid"):Utils.createUID();
				PlayerConfig.mergeid = this.getMergeid();
				PlayerConfig.txid = Utils.getBrowserCookie("_TXID") != ""?Utils.getBrowserCookie("_TXID"):"";
				PlayerConfig.lqd = Utils.getBrowserCookie("_LQD") != ""?Utils.getBrowserCookie("_LQD"):"";
				PlayerConfig.lcode = Utils.getBrowserCookie("_LCODE") != ""?Utils.getBrowserCookie("_LCODE"):"";
				PlayerConfig.clientWidth = this.getClientWidth();
				PlayerConfig.clientHeight = this.getClientHeight();
				str = PlayerConfig.clientWidth + "_" + PlayerConfig.clientHeight + "/" + PlayerConfig.VERSION;
				ran = int(int(Number(PlayerConfig.clientWidth) % 127) * int(Number(PlayerConfig.clientHeight) % 127) % 127) + 100;
				this._btnUi = new ButtonUi();
				PlayerConfig.adMd = this._btnUi.drawBtnAD(str,PlayerConfig.clientWidth,PlayerConfig.clientHeight) + ran;
				PlayerConfig.cdnMd = this._btnUi.drawBtnCDN(str,PlayerConfig.clientWidth,PlayerConfig.clientHeight) + ran;
				PlayerConfig.dmMd = this._btnUi.drawBtnDM(str,PlayerConfig.clientWidth,PlayerConfig.clientHeight) + ran;
				PlayerConfig.qsMd = this._btnUi.drawBtnQS(str,PlayerConfig.clientWidth,PlayerConfig.clientHeight) + ran;
				this._width = stage.stageWidth;
				this._height = stage.stageHeight;
				if(PlayerConfig.isSohuDomain) {
					if(stage.stageWidth < 290 || stage.stageHeight < 245) {
						PlayerConfig.showRecommend = false;
					}
				} else if(stage.stageWidth < 300 || stage.stageHeight < 230) {
					PlayerConfig.showRecommend = false;
				}
				
				if(!PlayerConfig.DEBUG) {
					myTvVid = this.getParams("id");
					if((Eif.available) && (ExternalInterface.available)) {
						PlayerConfig.authorId = Utils.getJSVar("_uid");
					}
					PlayerConfig.isTransition = false;
					PlayerConfig.isMyTvVideo = false;
					re = new RegExp("data\\.vod");
					if(PlayerConfig.vid == "" && !(flv == "") && (re.test(flv))) {
						re1 = new RegExp("http:\\/\\/","g");
						PlayerConfig.vmsFlv = PlayerConfig.vid = flv.replace(re1,"");
						PlayerConfig.isTransition = true;
					} else if(PlayerConfig.vid == "" && !(myTvVid == "")) {
						PlayerConfig.vid = myTvVid;
						PlayerConfig.isMyTvVideo = true;
					}
					
				}
				PlayerConfig.isJump = PlayerConfig.isSohuDomain?false:true;
				PlayerConfig.hasApi = true;
				LogManager.msg("vid:" + PlayerConfig.vid + "&sid:" + PlayerConfig.sid + "&pid:" + PlayerConfig.pid + "&nid:" + PlayerConfig.nid + "&prev:" + PlayerConfig.isPreview + "&st:" + String(PlayerConfig.seekTo) + "&sk:" + String(PlayerConfig.skinNum) + "&ap:" + PlayerConfig.autoPlay + "&sr:" + PlayerConfig.showRecommend + "&rp:" + PlayerConfig.recommendPath + "&cover:" + PlayerConfig.coverImg + "&ad:" + PlayerConfig.showAds + "&api:" + PlayerConfig.hasApi + "&pu:" + PlayerConfig.outReferer + "&scb:" + !PlayerConfig.isHide + "&jump:" + PlayerConfig.isJump + "&cb:" + PlayerConfig.showCommentBtn + "&sb:" + PlayerConfig.showShareBtn + "&mwb:" + PlayerConfig.showMiniWinBtn + "&cf:" + PlayerConfig.currentPageUrl + "&fv:" + PlayerConfig.flashVersion + "&pr:" + PlayerConfig.playerReffer + "&issd:" + PlayerConfig.isSohuDomain + "&ts:" + String(PlayerConfig.timestamp) + "&sh:" + PlayerConfig.swfHost + "&uuid:" + PlayerConfig.uuid + "&ver:" + PlayerConfig.VERSION + "&&" + Capabilities.serverString);
				this.wirteCookie();
				this.get56Cookie();
				obj = Utils.RegExpVersion();
				if(!(obj.majorVersion == 10 && obj.minorVersion == 0)) {
					this.setMenu();
				}
				this.newFunc();
				this.drawUi();
				this.addEvent();
				this._ads.selectorStartAd.container = this._selectorStartAdContainer;
				this._ads.startAd.container = this._startAdContainer;
				this._ads.endAd.container = this._endAdContainer;
				this._ads.middleAd.container = this._middleAdContainer;
				P2PExplorer.getInstance().callP2P(function(param1:Object):void {
					if(param1.info == "success") {
						P2PExplorer.getInstance().hasP2P = true;
						if(!(param1.data == null) && !(param1.data == "")) {
							PlayerConfig.ifoxInfoObj = {
								"ifoxVer":"",
								"ifoxUid":"",
								"ifoxCh":""
							};
							PlayerConfig.ifoxInfoObj.ifoxVer = param1.data.split("|")[0];
							PlayerConfig.ifoxInfoObj.ifoxUid = param1.data.split("|")[1];
							PlayerConfig.ifoxInfoObj.ifoxCh = param1.data.split("|")[2];
						}
					} else {
						P2PExplorer.getInstance().hasP2P = false;
					}
					PlayerConfig.passportUID = getPassportUID();
					PlayerConfig.passportMail = getPassportMail();
					start();
				});
			}
		}
		
		private function getAdReview() : String {
			var _loc1_:* = "";
			if(Eif.available) {
				_loc1_ = ExternalInterface.call("eval","location.hash");
			}
			var _loc2_:Array = _loc1_.split("#");
			var _loc3_:String = _loc2_[_loc2_.length - 1];
			if(!(_loc3_ == null) && !(_loc3_ == "")) {
				return _loc3_;
			}
			return "";
		}
		
		private function getPassportUID() : String {
			var passportUID:String = "";
			if(Eif.available) {
				try {
					passportUID = ExternalInterface.call("eval","(typeof sohuHD !== \'undefined\' && sohuHD.passport && sohuHD.passport.getUid && sohuHD.passport.getUid()) || (typeof PassportSC !== \'undefined\' && (PassportSC.parsePassportCookie() || PassportSC.cookie.uid || \'\'))");
				}
				catch(evt:Error) {
				}
			}
			return !(passportUID == null) && !(passportUID == "") && !(passportUID == "false")?passportUID:"";
		}
		
		private function getPassportMail() : String {
			var passportFor56:String = null;
			var passportMail:String = "";
			if(Eif.available) {
				try {
					if(PlayerConfig.domainProperty == "3") {
						passportFor56 = Utils.getBrowserCookie("member_id");
						if(passportFor56 != null) {
							passportMail = passportFor56;
						}
					} else {
						passportMail = ExternalInterface.call("eval","(typeof sohuHD !== \'undefined\' && sohuHD.passport && sohuHD.passport.getPassport && sohuHD.passport.getPassport()) || (typeof PassportSC !== \'undefined\' && (PassportSC.parsePassportCookie() || PassportSC.cookieHandle()))");
					}
				}
				catch(evt:Error) {
				}
			}
			if(Eif.available) {
				PlayerConfig.landingrefer = Utils.getBrowserCookie("landingrefer");
				return !(passportMail == null) && !(passportMail == "") && !(passportMail == "false")?passportMail:"";
			}
			PlayerConfig.landingrefer = Utils.getBrowserCookie("landingrefer");
			return !(passportMail == null) && !(passportMail == "") && !(passportMail == "false")?passportMail:"";
		}
		
		private function getClientWidth() : Number {
			var _width:Number = 0;
			if(Eif.available) {
				try {
					_width = ExternalInterface.call("eval","document.documentElement.clientWidth");
				}
				catch(evt:Error) {
				}
			}
			return _width;
		}
		
		private function getClientHeight() : Number {
			var _height:Number = 0;
			if(Eif.available) {
				try {
					_height = ExternalInterface.call("eval","document.documentElement.clientHeight");
				}
				catch(evt:Error) {
				}
			}
			return _height;
		}
		
		private function getSeekTo() : uint {
			var _loc2_:uint = 0;
			var _loc3_:Array = null;
			var _loc4_:String = null;
			var _loc1_:* = "";
			if((Eif.available) && (PlayerConfig.isSohuDomain)) {
				_loc1_ = ExternalInterface.call("eval","location.hash");
			}
			if(!(_loc1_ == "") && !(_loc1_ == null)) {
				_loc3_ = _loc1_.split("#");
				_loc4_ = _loc3_[_loc3_.length - 1];
				if(!(_loc4_ == null) && !(_loc4_ == "") && Number(_loc4_) > 0) {
					_loc2_ = uint(_loc4_);
				} else {
					_loc2_ = uint(this.getParams("seekTo"));
				}
			} else {
				_loc2_ = uint(this.getParams("seekTo"));
			}
			PlayerConfig.tempParam = _loc2_ > 0?true:false;
			return _loc2_;
		}
		
		private function getMergeid() : String {
			var json:Object = null;
			var mergeid:String = "";
			if(Eif.available) {
				try {
					json = new ebing.net.JSON().parse(ExternalInterface.call("returnUserIdsList"));
					if(!(json == null) && !(json == "") && !(json.ifox == null) && !(json.ifox == "")) {
						mergeid = json.ifox;
					}
				}
				catch(evt:Error) {
				}
			}
			if(Eif.available) {
				return mergeid;
			}
			return mergeid;
		}
		
		private function setMenu() : void {
			this._cm = new ContextMenu();
			var _loc1_:Array = PlayerConfig.swfHost.split("/");
			var _loc2_:String = _loc1_[_loc1_.length - 2];
			var _loc3_:ContextMenuItem = new ContextMenuItem("画面调节...");
			var _loc4_:ContextMenuItem = new ContextMenuItem("色彩调节...");
			var _loc5_:ContextMenuItem = new ContextMenuItem("视频信息");
			var _loc6_:ContextMenuItem = new ContextMenuItem("复制视频地址");
			var _loc7_:ContextMenuItem = new ContextMenuItem("复制当前时间视频地址");
			var _loc8_:ContextMenuItem = new ContextMenuItem("意见反馈");
			var _loc9_:ContextMenuItem = new ContextMenuItem("查看Log");
			var _loc10_:ContextMenuItem = new ContextMenuItem("查看面板信息");
			var _loc11_:ContextMenuItem = new ContextMenuItem("SohuTVPlayer:" + PlayerConfig.VERSION);
			var _loc12_:ContextMenuItem = new ContextMenuItem("FlashPlayer:" + PlayerConfig.flashVersion);
			var _loc13_:ContextMenuItem = new ContextMenuItem("用户ID:" + PlayerConfig.userId);
			_loc3_.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,this.showDSPanel);
			_loc4_.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,this.showCSPanel);
			_loc5_.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,this.showVideoInfoPanel);
			_loc6_.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,this.copyVideoPath);
			_loc7_.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,this.copyVideoHotPath);
			_loc8_.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,this.gotoTvSohuBlog);
			_loc9_.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,this.gotoCopyLog);
			_loc10_.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,this.showPanelVer);
			_loc11_.enabled = _loc12_.enabled = _loc13_.enabled = false;
			_loc6_.separatorBefore = _loc8_.separatorBefore = _loc11_.separatorBefore = true;
			this._cm.hideBuiltInItems();
			this._cm.customItems.push(_loc3_);
			this._cm.customItems.push(_loc4_);
			this._cm.customItems.push(_loc5_);
			this._cm.customItems.push(_loc6_);
			this._cm.customItems.push(_loc7_);
			this._cm.customItems.push(_loc8_);
			this._cm.customItems.push(_loc9_);
			this._cm.customItems.push(_loc10_);
			this._cm.customItems.push(_loc11_);
			this._cm.customItems.push(_loc12_);
			this._cm.customItems.push(_loc13_);
			this.contextMenu = this._cm;
			this._cm.addEventListener(ContextMenuEvent.MENU_SELECT,this.menuSelectHandler);
			this.shieldRightMenuItem();
		}
		
		private function menuSelectHandler(param1:ContextMenuEvent) : void {
		}
		
		private function showVideoInfoPanel(param1:ContextMenuEvent) : void {
			if(this._tvSohuMpb != null) {
				this._tvSohuMpb.showVideoInfoPanel();
			}
		}
		
		private function showDSPanel(param1:ContextMenuEvent) : void {
			if(this._tvSohuMpb != null) {
				this._tvSohuMpb.showSettingPanel("CLICK");
			}
		}
		
		private function showCSPanel(param1:ContextMenuEvent) : void {
			if(this._tvSohuMpb != null) {
				this._tvSohuMpb.showSettingPanel("CLICK");
			}
		}
		
		private function gotoTvSohuBlog(param1:ContextMenuEvent) : void {
			this._qfStat.sendFeedback();
		}
		
		private function gotoCopyLog(param1:ContextMenuEvent = null) : void {
			this._logsPanel.resize(stage.stageWidth,stage.stageHeight - 42);
			if((PlayerConfig.isLive) && !(this._tvSohuMpb == null) && !(this._tvSohuMpb.core == null) && !(this._tvSohuMpb.core.peerId == null)) {
				LogManager.msg("peerId:" + this._tvSohuMpb.core.peerId);
			}
			if(!this._logsPanel.isOpen) {
				this._logsPanel.open();
			} else {
				this._logsPanel.close();
			}
			this.setChildIndex(this._logsPanel,this.numChildren - 1);
		}
		
		private function showPanelVer(param1:ContextMenuEvent) : void {
			this._verInfoPanel.resize(stage.stageWidth,stage.stageHeight - 42);
			if(!this._verInfoPanel.isOpen && !(VerLog.getMsg() == "")) {
				this._verInfoPanel.open();
			} else {
				this._verInfoPanel.close();
			}
			this.setChildIndex(this._verInfoPanel,this.numChildren - 1);
		}
		
		private function closeStageVideo(param1:ContextMenuEvent) : void {
			var _loc2_:String = null;
			this._svdUserSo = SharedObject.getLocal("svdUserTip","/");
			this._svdUserSo.clear();
			this._svdUserSo.data.svdTag = "0";
			try {
				_loc2_ = this._svdUserSo.flush();
				if(_loc2_ == SharedObjectFlushStatus.PENDING) {
					this._svdUserSo.addEventListener(NetStatusEvent.NET_STATUS,this.onStatusShare);
				} else if(_loc2_ == SharedObjectFlushStatus.FLUSHED) {
				}
				
			}
			catch(e:Error) {
			}
			SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_S_CloseSpeedUp&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
			if((Eif.available) && (ExternalInterface.available)) {
				ExternalInterface.call("swfClose3D");
			}
		}
		
		private function gotoStageVideo(param1:Event = null) : void {
			this._bg.visible = false;
			if(!(this._tvSohuMpb == null) && !(this._tvSohuMpb.core == null)) {
				this._tvSohuMpb.core.toggleVideoMode();
			}
		}
		
		private function gotoVideo(param1:Event = null) : void {
			this._bg.visible = true;
			if(!(this._tvSohuMpb == null) && !(this._tvSohuMpb.core == null)) {
				this._tvSohuMpb.core.toggleVideoMode();
			}
		}
		
		private function copyVideoPath(param1:ContextMenuEvent) : void {
			System.setClipboard(PlayerConfig.filePrimaryReferer);
		}
		
		private function copyVideoHotPath(param1:ContextMenuEvent) : void {
			System.setClipboard(PlayerConfig.filePrimaryReferer + "#" + PlayerConfig.playedTime);
		}
		
		private function getSwfHost() : String {
			var _loc1_:String = stage.loaderInfo.url;
			_loc1_ = _loc1_.split("?")[0];
			var _loc2_:Number = _loc1_.lastIndexOf("/");
			var _loc3_:String = _loc1_.substr(0,_loc2_ + 1);
			return _loc3_;
		}
		
		private function getPageURL() : String {
			var _loc1_:* = "";
			if(Eif.available) {
				_loc1_ = ExternalInterface.call("eval","document.URL");
			}
			return _loc1_;
		}
		
		private function isSohuDomain() : Boolean {
			var _loc1_:String = PlayerConfig.currentPageUrl == ""?PlayerConfig.outReferer:PlayerConfig.currentPageUrl;
			if(_loc1_ == null || _loc1_ == "") {
				return false;
			}
			if(_loc1_.split(stage.loaderInfo.url).length >= 2) {
				return false;
			}
			var _loc2_:RegExp = new RegExp("\\/([^\\/]+)");
			var _loc3_:Array = PlayerConfig.SOHU_MATRIX;
			var _loc4_:Array = _loc1_.match(_loc2_);
			if(_loc4_ == null) {
				return false;
			}
			var _loc5_:String = String(_loc4_[1]);
			var _loc6_:* = 0;
			while(_loc6_ < _loc3_.length) {
				if(new RegExp(_loc3_[_loc6_],"i").test(_loc5_)) {
					PlayerConfig.domainProperty = "2";
					if(new RegExp(PlayerConfig.TV_SOHU,"i").test(_loc5_)) {
						PlayerConfig.domainProperty = "0";
						return true;
					}
					if(new RegExp("56\\.com$","i").test(_loc5_)) {
						PlayerConfig.domainProperty = "3";
						return true;
					}
					return true;
				}
				_loc6_++;
			}
			PlayerConfig.domainProperty = "1";
			return false;
		}
		
		private function isPartner() : Boolean {
			var _loc1_:String = PlayerConfig.currentPageUrl == ""?escape(PlayerConfig.outReferer):escape(PlayerConfig.currentPageUrl);
			if(_loc1_ == null || _loc1_ == "") {
				return false;
			}
			if(_loc1_.split(stage.loaderInfo.url).length >= 2) {
				return false;
			}
			var _loc2_:RegExp = new RegExp("\\/([^\\/]+)");
			var _loc3_:Array = ["taohua\\.com$","taohua\\.net$","yunhd\\.unikaixin\\.com$"];
			var _loc4_:Array = _loc1_.match(_loc2_);
			if(_loc4_ == null) {
				return false;
			}
			var _loc5_:String = String(_loc4_[1]);
			var _loc6_:* = 0;
			while(_loc6_ < _loc3_.length) {
				if(new RegExp(_loc3_[_loc6_],"i").test(_loc5_)) {
					return true;
				}
				_loc6_++;
			}
			return false;
		}
		
		private function specialDomain(param1:String, param2:Array) : Boolean {
			var _loc3_:String = param1;
			if(_loc3_ == null || _loc3_ == "") {
				return false;
			}
			if(_loc3_.split(stage.loaderInfo.url).length >= 2) {
				return false;
			}
			var _loc4_:RegExp = new RegExp("\\/([^\\/]+)");
			var _loc5_:Array = param2;
			var _loc6_:Array = _loc3_.match(_loc4_);
			if(_loc6_ == null) {
				return false;
			}
			var _loc7_:String = String(_loc6_[1]);
			var _loc8_:* = 0;
			while(_loc8_ < _loc5_.length) {
				if(new RegExp(_loc5_[_loc8_],"i").test(_loc7_)) {
					return true;
				}
				_loc8_++;
			}
			return false;
		}
		
		private function createMpb() : void {
			if(this._tvSohuMpb == null) {
				if(stage.loaderInfo.parameters["showMode"] == "radio") {
					this._tvSohuMpb = RadioMpb.getInstance();
				} else if(stage.loaderInfo.parameters["showMode"] == "360") {
					this._tvSohuMpb = TSZMpb.getInstance();
				} else {
					this._tvSohuMpb = TvSohuMediaPlayback.getInstance();
				}
				
				addChild(this._tvSohuMpb);
				this.swapChildren(this._tvSohuMpb,this._startAdContainer);
				this._tvSohuMpb.hardInit({
					"buffer":3,
					"width":this._width,
					"height":this._height,
					"core":"",
					"isHide":PlayerConfig.isHide,
					"hardInitHandler":this.onMpbHardInit,
					"skinPath":PlayerConfig.swfHost + "skins/s" + PlayerConfig.skinNum + ".swf",
					"selectorStartAdContainer":this._selectorStartAdContainer,
					"startAdContainer":this._startAdContainer,
					"endAdContainer":this._endAdContainer,
					"middleAdContainer":this._middleAdContainer,
					"stage":this.stage
				});
				this._tvSohuMpb.addEventListener("liveCoreVer",function(param1:Event):void {
					var _loc2_:ContextMenuItem = new ContextMenuItem("PLCore:" + _tvSohuMpb.liveCoreVer);
					_loc2_.enabled = false;
					_cm.customItems.push(_loc2_);
				});
			} else if(!this._mpbSoftInitSuc) {
				if((PlayerConfig.isFms) && !(PlayerConfig.currentCore == "TvSohuFMSCore") || !PlayerConfig.isFms && !(PlayerConfig.currentCore == "TvSohuVideoCore")) {
					this._tvSohuMpb.setLoadCore(this.softInitAndContinue);
				} else if((PlayerConfig.isLive) && !(this._tvSohuMpb.core == null) && !(this._tvSohuMpb.core.initP2P == null)) {
					this._tvSohuMpb.core.initP2P(this.softInitAndContinue);
				} else {
					this.softInitAndContinue();
				}
				
			}
			
		}
		
		private function onMpbHardInit(param1:Object) : void {
			if(param1.info == "success") {
				this.addMpbEvent();
				if(!this._mpbSoftInitSuc) {
					this.softInitAndContinue();
				}
			}
		}
		
		private function softInitAndContinue() : void {
			this.softInitMpb();
			if(this._isAutoPlay) {
				if((TvSohuAds.getInstance().startAd.hasAd) && TvSohuAds.getInstance().startAd.state == "playing") {
					if(!PlayerConfig.isFms) {
						this._tvSohuMpb.core.play();
						this._tvSohuMpb.core.pause();
					}
				} else {
					this._tvSohuMpb.core.play();
				}
			} else {
				this._tvSohuMpb.showCover();
			}
		}
		
		private function softInitMpb() : void {
			/*
			 * Decompilation error
			 * Code may be obfuscated
			 * Deobfuscation is activated but decompilation still failed. If the file is NOT obfuscated, disable "Automatic deobfuscation" for better results.
			 * Error type: TranslateException
			 */
			throw new flash.errors.IllegalOperationError("Not decompiled due to error");
		}
		
		private function start() : void {
			var _loc2_:SharedObject = null;
			var _loc3_:String = null;
			var _loc1_:* = "";
			this._so = SharedObject.getLocal("vmsPlayer","/");
			if(!(this._so.data.ver == undefined) && !(this._so.data.ver == "") && !(String(this._so.data.ver) == "0")) {
				PlayerConfig.definition = this._version = this._so.data.ver;
			}
			if(!(this._so.data.bw == undefined) && !(this._so.data.bw == "") && !(String(this._so.data.bw) == "0")) {
				this._bandwidth = this._so.data.bw;
			}
			if(!(this._so.data.af == undefined) && !(this._so.data.af == "") && !(String(this._so.data.af) == "0")) {
				PlayerConfig.autoFix = this._autoFix = this._so.data.af;
			} else {
				if(this._so.data.ver == undefined || this._so.data.ver == "" || String(this._so.data.ver) == "0") {
					PlayerConfig.autoFix = this._autoFix = "1";
					try {
						_loc2_.data.af = this._autoFix;
						_loc3_ = _loc2_.flush();
						if(_loc3_ == SharedObjectFlushStatus.PENDING) {
							_loc2_.addEventListener(NetStatusEvent.NET_STATUS,this.onStatusShare);
						} else if(_loc3_ == SharedObjectFlushStatus.FLUSHED) {
						}
						
					}
					catch(e:Error) {
					}
				}
				if(this._so.data.ver == undefined || this._so.data.ver == "" || String(this._so.data.ver) == "0") {
				}
			}
			if(PlayerConfig.DEBUG) {
				_loc1_ = PlayerConfig.DEBUG_VID;
				PlayerConfig.pid = PlayerConfig.DEBUG_PID;
			} else {
				_loc1_ = PlayerConfig.vid;
			}
			if(PlayerConfig.autoPlay) {
				this.loadAndPlay(_loc1_);
			} else {
				this.loadAndPause(_loc1_);
			}
		}
		
		public function resizeHandler(param1:* = null) : void {
			this._width = stage.stageWidth;
			this._height = stage.stageHeight;
			if(!(this._tvSohuMpb == null) && !(this._tvSohuMpb.core == null)) {
				this._tvSohuMpb.resize(this._width,this._height);
			} else if(this._ads.startAd.hasAd) {
				this._ads.startAd.resize(this._width,this._height);
			}
			
			this.resize();
		}
		
		private function getParams(param1:String) : String {
			var _loc2_:* = "";
			if(stage.loaderInfo.parameters[param1] != null) {
				_loc2_ = String(stage.loaderInfo.parameters[param1]);
				_loc2_ = _loc2_.replace(new RegExp("\\^","g"),"&");
			}
			return _loc2_;
		}
		
		private function newFunc() : void {
			this._ads = TvSohuAds.getInstance(this.stage);
			this._qfStat = ErrorSenderPQ.getInstance();
			InforSender.getInstance().ifltype = this._qfStat.qfltype = this.getParams("ltype");
			this._model = Model.getInstance();
		}
		
		private function drawUi() : void {
			this._tvSohuLoading_c = new Sprite();
			this._selectorStartAdContainer = new Sprite();
			this._startAdContainer = new Sprite();
			this._endAdContainer = new Sprite();
			this._middleAdContainer = new Sprite();
			this._errStatusSp = new Sprite();
			this._logsPanel = new LogsPanel(stage.stageWidth,stage.stageHeight - 42);
			this._logsPanel.close(0);
			this._verInfoPanel = new VerInfoPanel(stage.stageWidth,stage.stageHeight - 42);
			this._verInfoPanel.close(0);
			this._bg = new Sprite();
			Utils.drawRect(this._bg,0,0,stage.stageWidth,stage.stageHeight,0,1);
			addChild(this._bg);
			addChild(this._selectorStartAdContainer);
			addChild(this._startAdContainer);
			addChild(this._tvSohuLoading_c);
			addChild(this._errStatusSp);
			addChild(this._logsPanel);
			addChild(this._verInfoPanel);
			this.resize();
		}
		
		private function addEvent() : void {
			this._model.addEventListener(Model.VINFO_LOAD_SUCCESS,this.vinfoLoadSuccess);
			this._model.addEventListener(Model.VINFO_LOAD_TIMEOUT,this.vinfoLoadTimeout);
			this._model.addEventListener(Model.VINFO_LOAD_IOERROR,this.vinfoLoadIoError);
			this._model.addEventListener(Model.VINFO_DATA_EMPTY,this.vinfoDataEmpty);
			this._model.addEventListener(Model.QUICK_MODE,this.showQuickPanel);
			this._ads.startAd.addEventListener(TvSohuAdsEvent.SCREENSHOWN,this.startAdShown);
			this._ads.startAd.addEventListener(TvSohuAdsEvent.START_AD_LOADED,this.startAdLoaded);
			this._ads.startAd.addEventListener(TvSohuAdsEvent.SCREEN_LOAD_FAILED,this.startAdLoadFailed);
			this._ads.startAd.addEventListener(TvSohuAdsEvent.SCREENFINISH,this.screenAdFinish);
			this._ads.startAd.addEventListener(TvSohuAdsEvent.START_AD_ILLEGAL,this.adPlayIllegal);
			this._ads.startAd.addEventListener("to_has_sound_icon",this.adsVolume);
			this._ads.startAd.addEventListener("to_no_sound_icon",this.adsMute);
			this._ads.endAd.addEventListener(TvSohuAdsEvent.SCREENSHOWN,this.endAdShown);
			this._ads.endAd.addEventListener(TvSohuAdsEvent.ENDFINISH,this.endAdFinish);
			stage.addEventListener(KeyboardEvent.KEY_UP,this.keyboardUpHandler);
			stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY,this.stageVideoAvailabilityHandler);
			stage.addEventListener("throttle",this.onThrottle);
			loaderInfo.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,this.uncaughtErrorHandler);
		}
		
		private function sendLogs(param1:MouseEvent) : void {
			this._qfStat.sendDebugInfo({
				"url":"http://um.hd.sohu.com/u.gif",
				"type":"player",
				"code":PlayerConfig.BUFFER_CODE,
				"error":"",
				"debuginfo":LogManager.getMsg(),
				"sid":PlayerConfig.sid,
				"uid":PlayerConfig.userId,
				"time":new Date().getTime()
			});
		}
		
		private function showQuickPanel(param1:Event) : void {
			var evt:Event = param1;
			new LoaderUtil().load(20,function(param1:Object):void {
				var content:* = undefined;
				var obj:Object = param1;
				if(obj.info == "success") {
					content = obj.data.content;
					addChild(content);
					content.close(0);
					content.init(stage.stageWidth,stage.stageHeight);
					content.open();
					content.addEventListener("startPlay",function(param1:Event):void {
						if((PlayerConfig.isLive) && (PlayerConfig.hasP2PLive)) {
							toP2PLive();
						}
						removeChild(content);
					});
				}
			},null,PlayerConfig.swfHost + "panel/QuickLivePanel.swf");
		}
		
		private function loadLoading(param1:String) : void {
			var url:String = param1;
			new LoaderUtil().load(3,function(param1:Object):void {
				if(param1.info == "success") {
					_tvSohuLoading = param1.data.content;
					_tvSohuLoading.hardInit({
						"width":stage.stageWidth,
						"height":stage.stageHeight
					});
					_tvSohuLoading_c.addChild(_tvSohuLoading);
					dispatchEvent(new Event("hideShellLoading"));
				}
			},null,url);
		}
		
		private function addMpbEvent() : void {
			this._tvSohuMpb.core.addEventListener(MediaEvent.PAUSE,this.onPause);
			this._tvSohuMpb.core.addEventListener(MediaEvent.PLAY,this.onPlay);
			this._tvSohuMpb.core.addEventListener(MediaEvent.PLAYED,this.onPlayed);
			this._tvSohuMpb.core.addEventListener(MediaEvent.STOP,this.onStop);
			this._tvSohuMpb.core.addEventListener(MediaEvent.CONNECTING,this.onMediaConnecting);
			this._tvSohuMpb.core.addEventListener("live_overload",this.toP2PLive);
			this._tvSohuMpb.addEventListener(TvSohuMediaPlayback.SUPER_BUTTON_MOUSEUP,this.changeSuperVideo);
			this._tvSohuMpb.addEventListener(TvSohuMediaPlayback.COMMON_BUTTON_MOUSEUP,this.changeCommonVideo);
			this._tvSohuMpb.addEventListener(TvSohuMediaPlayback.HD_BUTTON_MOUSEUP,this.changeHdVideo);
			this._tvSohuMpb.addEventListener(TvSohuMediaPlayback.ORI_BUTTON_MOUSEUP,this.changeYYYVideo);
			this._tvSohuMpb.addEventListener(TvSohuMediaPlayback.EXTREME_BUTTON_MOUSEUP,this.changeExtremeVideo);
			this._tvSohuMpb.addEventListener("retryPanel_shown",this.retryPanelShown);
			this._tvSohuMpb.addEventListener("playListVideo",this.playListVideo);
			this._tvSohuMpb.addEventListener("ChangeAutoPlay",function(param1:Event):void {
				_isAutoPlay = true;
			});
			this._tvSohuMpb.addEventListener("skinLoadSuccess",function(param1:Event):void {
				dispatchEvent(new Event("hideShellLoading"));
			});
			this._tvSohuMpb.addEventListener("gotoStageVideo",this.gotoStageVideo);
			this._tvSohuMpb.addEventListener("gotoVideo",this.gotoVideo);
			if((PlayerConfig.hasApi) && (Eif.available)) {
				try {
					ExternalInterface.addCallback("activity",this._tvSohuMpb.activity);
					ExternalInterface.addCallback("playVideo",this.playVideo);
					ExternalInterface.addCallback("pauseVideo",this.pauseVideo);
					ExternalInterface.addCallback("stopVideo",this._tvSohuMpb.core.stop);
					ExternalInterface.addCallback("webUnload",this.webUnload);
					ExternalInterface.addCallback("getUUID",function():String {
						return PlayerConfig.uuid;
					});
					ExternalInterface.addCallback("destroyVideo",function():void {
						_tvSohuMpb.core.destroy();
					});
					ExternalInterface.addCallback("playerState",function():String {
						return _tvSohuMpb.core.streamState;
					});
					ExternalInterface.addCallback("seekTo",this._tvSohuMpb.seekTo);
					ExternalInterface.addCallback("playedTime",function():Number {
						return _tvSohuMpb.core.filePlayedTime;
					});
					ExternalInterface.addCallback("videoTotTime",function():Number {
						if(_tvSohuMpb.core != null) {
							return Math.floor(_tvSohuMpb.core.fileTotTime);
						}
						return 0;
					});
					ExternalInterface.addCallback("videoWidth",function():Number {
						if(_tvSohuMpb.core != null) {
							return Math.floor(_tvSohuMpb.core.metaWidth);
						}
						return 0;
					});
					ExternalInterface.addCallback("videoHeight",function():Number {
						if(_tvSohuMpb.core != null) {
							return Math.floor(_tvSohuMpb.core.metaHeight);
						}
						return 0;
					});
					ExternalInterface.addCallback("setVolume",function(param1:Number):void {
						if(_tvSohuMpb.core != null) {
							_tvSohuMpb.core.volume = param1;
						}
					});
					ExternalInterface.addCallback("getCount",function():String {
						return ErrorSenderPQ.getInstance().getPlayCount();
					});
					ExternalInterface.addCallback("commonMode",this._tvSohuMpb.toCommonMode);
					ExternalInterface.addCallback("getDebugInfo",function():Object {
						var _loc1_:Object = {
							"debugInfo":"-1",
							"volume":-1,
							"averageSpeed":"-1",
							"rate":"-1",
							"os":"-1",
							"currentNewFile":""
						};
						_loc1_.debugInfo = LogManager.getMsg();
						if(_tvSohuMpb != null) {
							_loc1_.volume = _tvSohuMpb.core.volume;
							_loc1_.rate = _tvSohuMpb.core.vrate;
							_loc1_.os = Capabilities.os;
							if(!(PlayerConfig.synUrl == null) && !(PlayerConfig.synUrl[_tvSohuMpb.core.downloadIndex] == null)) {
								_loc1_.currentNewFile = PlayerConfig.synUrl[_tvSohuMpb.core.downloadIndex];
							}
							if(_tvSohuMpb.videoInfoPanel != null) {
								_loc1_.averageSpeed = _tvSohuMpb.videoInfoPanel.averageSpeed;
							}
						}
						return _loc1_;
					});
					if(PlayerConfig.isTransition) {
						ExternalInterface.addCallback("externalPlay",this._tvSohuMpb.core.play);
						ExternalInterface.addCallback("externalPause",this._tvSohuMpb.core.pause);
						ExternalInterface.addCallback("externalStop",this._tvSohuMpb.core.stop);
						ExternalInterface.addCallback("getCurrentTime",function():Number {
							return Math.floor(_tvSohuMpb.core.filePlayedTime);
						});
						ExternalInterface.call("playerLoaded");
					}
					if(PlayerConfig.onPlayerReady != "") {
						ExternalInterface.call(PlayerConfig.onPlayerReady);
					}
					if(PlayerConfig.showWiderBtn) {
						ExternalInterface.addCallback("externalCinema",this._tvSohuMpb.toCinemaMode);
					}
					ExternalInterface.addCallback("ctrlBarVisible",this.setCtrlBarVisible);
					ExternalInterface.addCallback("startCutImgToBoundPage",this._tvSohuMpb.startCutImgToBoundPage);
					ExternalInterface.addCallback("updateUserLoginInfo",this.updateUserLoginInfo);
					if(stage.loaderInfo.parameters["showMode"] == "radio") {
						ExternalInterface.addCallback("setNextVideo",this._tvSohuMpb.setNextVideo);
						ExternalInterface.addCallback("loadAndPlay",this.loadAndPlay);
						ExternalInterface.addCallback("setBtnState",this._tvSohuMpb.setBtnState);
					}
					if(!(PlayerConfig.voteRegion == "") && PlayerConfig.voteRegion == "1" && !(PlayerConfig.voteId == "")) {
						if((Eif.available) && (ExternalInterface.available)) {
							ExternalInterface.call("initPageVote",PlayerConfig.voteId);
						}
					}
				}
				catch(evt:SecurityError) {
				}
			}
			if((PlayerConfig.hasApi) && (Eif.available)) {
				return;
			}
		}
		
		private function toP2PLive(param1:Event = null) : void {
			PlayerConfig.needP2PLive = true;
			this.loadAndPlay(PlayerConfig.vid);
		}
		
		private function startAdLoadFailed(param1:* = null) : void {
			this.startAdLoaded();
			this.screenAdFinish();
		}
		
		private function adPlayIllegal(param1:* = null) : void {
			if(!(this._tvSohuMpb == null) && !(this._tvSohuMpb.core == null)) {
				this._tvSohuMpb.core.pause();
			}
			var _loc2_:RegExp = new RegExp("CODE");
			this._adPlayIllegal = new AdPlayIllegal(stage.stageWidth,stage.stageHeight,PlayerConfig.ADS_PLAY_ILLEGAL.replace(_loc2_," 500" + PlayerConfig.ILLEGALMSG + " "));
			addChild(this._adPlayIllegal);
			var _loc3_:String = "500" + PlayerConfig.ILLEGALMSG;
			if((Eif.available) && (ExternalInterface.available)) {
				ExternalInterface.call("function(){document.cookie=\'pbb1=" + _loc3_ + ";path=/\';}");
			}
		}
		
		private function illegalAdsTip() : void {
			this.hideTvSohuLoading();
			var _loc1_:TextFormat = new TextFormat();
			_loc1_.size = 18;
			_loc1_.leading = 10;
			_loc1_.font = "微软雅黑";
			_loc1_.align = TextFormatAlign.CENTER;
			var _loc2_:TextField = new TextField();
			_loc2_.wordWrap = true;
			_loc2_.multiline = true;
			_loc2_.textColor = 11776947;
			_loc2_.width = stage.stageWidth;
			_loc2_.htmlText = PlayerConfig.ADS_DATA_ERROR;
			_loc2_.setTextFormat(_loc1_);
			Utils.setCenterByNumber(_loc2_,stage.stageWidth,stage.stageHeight);
			this._errStatusSp.addChild(_loc2_);
		}
		
		private function showmore(param1:Event = null) : void {
			if(PlayerConfig.showRecommend) {
				this._tvSohuMpb.loadMore();
			} else {
				this._tvSohuMpb.showCover();
			}
		}
		
		private function onMediaConnecting(param1:MediaEvent) : void {
			this.hideTvSohuLoading();
		}
		
		private function onPlayed(param1:MediaEvent) : void {
			var _loc3_:SharedObject = null;
			var _loc4_:uint = 0;
			var _loc5_:String = null;
			var _loc6_:Object = null;
			var _loc7_:String = null;
			var _loc2_:Number = new Date().getTime();
			try {
				if(this._tvSohuMpb.core.coreTempTime) {
					PlayerConfig.cdngetSpend = _loc2_ - this._tvSohuMpb.core.coreTempTime - PlayerConfig.allotSpend;
				}
			}
			catch(evt:*) {
			}
			if((Eif.available) && !(this._ads.endAd.state == "playing") && !(this._ads.startAd.state == "playing")) {
				if(PlayerConfig.onPlayed != "") {
					_loc3_ = SharedObject.getLocal("ac","/");
					_loc4_ = 0;
					if(_loc3_.data.nov != undefined) {
						_loc4_ = _loc3_.data.nov;
					}
					ExternalInterface.call(PlayerConfig.onPlayed,PlayerConfig.userId,Model.getInstance().videoInfo.vt,PlayerConfig.currentVideoReplayNum,_loc4_);
					PlayerConfig.onPlayed = "";
				} else if(PlayerConfig.isTransition) {
					_loc5_ = this.getParams("clipPlayCallback");
					if(_loc5_ != "") {
						ExternalInterface.call(_loc5_);
					}
				}
				
			}
			if(PlayerConfig.otherInforSender == "") {
				try {
					_loc6_ = {
						"mode":((PlayerConfig.availableStvd) && (PlayerConfig.stvdInUse)?1:0),
						"curColor":this._tvSohuMpb.core.videoArr[this._tvSohuMpb.core.curIndex].video.info.getCurColor(),
						"colorSpace":this._tvSohuMpb.core.videoArr[this._tvSohuMpb.core.curIndex].video.info.getColorSpace(),
						"svdLen":this._tvSohuMpb.core.videoArr[this._tvSohuMpb.core.curIndex].video.info.getSvdLen()
					};
				}
				catch(err:Error) {
				}
				InforSender.getInstance().sendMesg(InforSender.START2,0,"","","http://pb.hd.sohu.com.cn/hdpb.gif",0,_loc6_);
			} else if(PlayerConfig.otherInforSender != "") {
				InforSender.getInstance().sendMesg(PlayerConfig.otherInforSender,0,"","","http://pb.hd.sohu.com.cn/hdpb.gif");
			}
			
			if(PlayerConfig.otherInforSender == "") {
				this.startPlayListLoop();
				if(this._isFirstSend) {
					if(Eif.available) {
						_loc7_ = Utils.getJSVar("__playerTest");
						if(!(_loc7_ == null) && !(_loc7_ == "") && !(_loc7_ == "undefined")) {
							PlayerConfig.jsgetSpend = _loc7_.split(",")[0];
							PlayerConfig.playerSpend = _loc7_.split(",")[1];
						}
					}
					SendRef.getInstance().sendPlayerTest("loadtime");
					this._isFirstSend = false;
				}
				if(!(PlayerConfig.pvpic == null) && !(this._tvSohuMpb == null) && (this._isDownPreviewPic)) {
					if(!(PlayerConfig.pvpic.big == null) && !(PlayerConfig.pvpic.big == "") && !(PlayerConfig.pvpic.small == null) && !(PlayerConfig.pvpic.small == "")) {
						PlayerConfig.isPreviewPic = true;
					} else {
						PlayerConfig.isPreviewPic = false;
					}
					this._tvSohuMpb.isTsp = true;
					this._isDownPreviewPic = false;
				}
				return;
			}
			this.startPlayListLoop();
			if(this._isFirstSend) {
				if(Eif.available) {
					_loc7_ = Utils.getJSVar("__playerTest");
					if(!(_loc7_ == null) && !(_loc7_ == "") && !(_loc7_ == "undefined")) {
						PlayerConfig.jsgetSpend = _loc7_.split(",")[0];
						PlayerConfig.playerSpend = _loc7_.split(",")[1];
					}
				}
				SendRef.getInstance().sendPlayerTest("loadtime");
				this._isFirstSend = false;
			}
			if(!(PlayerConfig.pvpic == null) && !(this._tvSohuMpb == null) && (this._isDownPreviewPic)) {
				if(!(PlayerConfig.pvpic.big == null) && !(PlayerConfig.pvpic.big == "") && !(PlayerConfig.pvpic.small == null) && !(PlayerConfig.pvpic.small == "")) {
					PlayerConfig.isPreviewPic = true;
				} else {
					PlayerConfig.isPreviewPic = false;
				}
				this._tvSohuMpb.isTsp = true;
				this._isDownPreviewPic = false;
			}
		}
		
		private function startPlayListLoop() : void {
			if(!(PlayerConfig.skinNum == "-1" && stage.loaderInfo.parameters["os"] == "android" && stage.loaderInfo.parameters["showMode"] == "radio")) {
				if(PlayerConfig.vrsPlayListId) {
					if((PlayerConfig.isSohuDomain) && !PlayerConfig.isMyTvVideo && (PlayerConfig.isListPlay) || !PlayerConfig.isSohuDomain && !((PlayerConfig.isAlbumVideo) || (PlayerConfig.isKTVVideo)) && (PlayerConfig.isListPlay)) {
						if(this._tvSohuMpb.panel == null) {
							setTimeout(function():void {
								_tvSohuMpb.showPlayListPanel();
								_isLoop = true;
								_isNewsLogo = PlayerConfig.isNewsLogo;
							},1000);
						}
					}
				}
			}
		}
		
		private function startAdShown(param1:TvSohuAdsEvent) : void {
			if(this._tvSohuLoading_c.numChildren >= 0) {
				this.hideTvSohuLoading();
			}
			this.resizeHandler();
		}
		
		private function hideTvSohuLoading() : void {
			TweenLite.to(this._tvSohuLoading_c,0.2,{
				"alpha":0,
				"ease":Quad.easeOut,
				"onComplete":function():void {
					var _loc1_:* = undefined;
					_tvSohuLoading_c.visible = false;
					if(_tvSohuLoading != null) {
						_loc1_ = 0;
						while(_loc1_ < _tvSohuLoading_c.numChildren) {
							_tvSohuLoading_c.removeChildAt(_loc1_);
							_loc1_++;
						}
						_tvSohuLoading = null;
					}
				}
			});
			dispatchEvent(new Event("hideShellLoading"));
		}
		
		private function changeSuperVideo(param1:Event) : void {
			this._isPlayStartAd = false;
			this._breakPoint = this._tvSohuMpb.core.filePlayedTime;
			PlayerConfig.otherInforSender = "change";
			this.loadAndPlay(PlayerConfig.superVid);
			PlayerConfig.definition = "21";
		}
		
		private function changeCommonVideo(param1:Event) : void {
			this._isPlayStartAd = false;
			this._breakPoint = this._tvSohuMpb.core.filePlayedTime;
			PlayerConfig.otherInforSender = "change";
			this.loadAndPlay(PlayerConfig.norVid);
			PlayerConfig.definition = "2";
		}
		
		private function changeHdVideo(param1:Event) : void {
			this._isPlayStartAd = false;
			this._breakPoint = this._tvSohuMpb.core.filePlayedTime;
			PlayerConfig.otherInforSender = "change";
			this.loadAndPlay(PlayerConfig.hdVid);
			PlayerConfig.definition = "1";
		}
		
		private function changeYYYVideo(param1:Event) : void {
			this._isPlayStartAd = false;
			this._breakPoint = this._tvSohuMpb.core.filePlayedTime;
			PlayerConfig.otherInforSender = "change";
			this.loadAndPlay(PlayerConfig.oriVid);
			PlayerConfig.definition = "31";
		}
		
		private function changeExtremeVideo(param1:Event) : void {
			this._isPlayStartAd = false;
			this._breakPoint = this._tvSohuMpb.core.filePlayedTime;
			PlayerConfig.otherInforSender = "change";
			this.loadAndPlay(PlayerConfig.h2644kVid);
			PlayerConfig.definition = "51";
		}
		
		public function loadAndPlay(param1:String, param2:* = null, param3:String = "") : void {
			if(param2 != null) {
				PlayerConfig.isMyTvVideo = param2;
				this._isJsCallLoadAndPlay = true;
				this.loopSoft();
			}
			if(param3 != "") {
				PlayerConfig.plid = param3;
			}
			this._isJsCallLoadAndPlay = false;
			PlayerConfig.vid = param1;
			this._isAutoPlay = true;
			this.fetchVideoInfo(PlayerConfig.vid);
			while(this._errStatusSp.numChildren) {
				this._errStatusSp.removeChildAt(0);
			}
		}
		
		private function loopSoft() : void {
			if(this._ads.hasAds) {
				this._ads.destroy();
			}
			if(!this._isAutoLoop) {
				this._isAutoLoop = true;
				this._tvSohuMpb.core.stop();
			}
			this._isAutoLoop = false;
			try {
				this._tvSohuMpb.setFlatWall3D();
			}
			catch(evt:SecurityError) {
			}
			this.setVideoVer();
			PlayerConfig.uuid = Utils.createUID();
			this._qfStat.isSentDefPause = false;
			InforSender.getInstance().ifltype = this._qfStat.qfltype = this.getParams("ltype");
			this._isDownPreviewPic = this._isFirstSend = true;
			if(!PlayerConfig.autoPlay) {
				PlayerConfig.autoPlay = true;
			}
			PlayerConfig.xuid = "";
			PlayerConfig.seekTo = 0;
			this._breakPoint = 0;
			PlayerConfig.isVipUser = false;
			PlayerConfig.isShowTanmu = false;
		}
		
		public function loadAndPause(param1:String) : void {
			PlayerConfig.vid = param1;
			this._isAutoPlay = false;
			this.fetchVideoInfo(PlayerConfig.vid);
		}
		
		private function onPause(param1:MediaEvent) : void {
			var evt:MediaEvent = param1;
			if(evt.obj.isHard) {
				if((this._tvSohuMpb.preLoadPanel == null || !this._tvSohuMpb.preLoadPanel.visible || this._tvSohuMpb.preLoadPanel.isBackgroundRun) && (this._tvSohuMpb.sharePanel2 == null || !this._tvSohuMpb.sharePanel2.isOpen) && (this._tvSohuMpb.isShownPauseAd)) {
					this._pauseAd = setTimeout(function():void {
						if((_ads.pauseAd.hasAd) && _tvSohuMpb.core.streamState == "pause") {
							AdLog.msg("==========请求暂停广告数据==========");
							_ads.pauseAd.play();
						} else if(!_ads.pauseAd.hasAd) {
							_ads.pauseAd.pingback();
						}
						
					},500);
				}
			}
			if((Eif.available) && !(PlayerConfig.onPause == "")) {
				ExternalInterface.call(PlayerConfig.onPause);
			}
		}
		
		private function onPlay(param1:MediaEvent) : void {
			var _loc2_:uint = 0;
			if((this._ads.pauseAd.hasAd) && (this._ads.pauseAd.state == "playing" || this._ads.pauseAd.state == "loading" || this._ads.pauseAd.state == "end")) {
				clearTimeout(this._pauseAd);
				this._ads.pauseAd.close();
			}
			while(this._errStatusSp.numChildren) {
				this._errStatusSp.removeChildAt(0);
			}
			if(this._tvSohuMpb.more != null) {
				this._tvSohuMpb.more.visible = false;
			}
			if(!(this._tvSohuMpb == null) && !(this._tvSohuMpb.likePanel == null)) {
				this._tvSohuMpb.likePanel.visible = false;
			}
			if(!(this._tvSohuMpb == null) && !(this._tvSohuMpb.flatWall3D == null) && (this._tvSohuMpb.flatWall3D.isOpen)) {
				this._tvSohuMpb.flatWall3D.close();
			}
			if(this._payPanel != null) {
				this._payPanel.visible = false;
			}
			if(!(this._ads.endAd.state == "playing") && !(this._ads.startAd.state == "playing")) {
				this.activateRightMenuItem();
			}
			if(!PlayerConfig.sendRealVV && !(TvSohuAds.getInstance().startAd.state == "playing")) {
				_loc2_ = 0;
				if(PlayerConfig.startAdTime == 0) {
					_loc2_ = 0;
				} else if(PlayerConfig.startAdPlayTime >= PlayerConfig.startAdTime * 1000 - 3000 && PlayerConfig.startAdPlayTime < PlayerConfig.startAdTime * 1000 + 3000) {
					_loc2_ = 1;
				} else if(PlayerConfig.startAdPlayTime >= PlayerConfig.startAdTime * 1000 + 3000 && PlayerConfig.startAdPlayTime <= PlayerConfig.startAdTime * 1000 + PlayerConfig.startAdTimeOut * 1000 - 1000) {
					_loc2_ = 2;
				} else if(PlayerConfig.startAdPlayTime > PlayerConfig.startAdTime * 1000 + PlayerConfig.startAdTimeOut * 1000 - 1000 && PlayerConfig.startAdPlayTime <= PlayerConfig.startAdTime * 1000 + PlayerConfig.startAdTimeOut * 1000 + 1000) {
					_loc2_ = 3;
				} else if(PlayerConfig.startAdPlayTime <= PlayerConfig.startAdTime * 1000 - 3000) {
					_loc2_ = 4;
				}
				
				
				
				
				this._qfStat.sendPQStat({
					"code":PlayerConfig.REALVV_CODE,
					"adt":PlayerConfig.startAdTime,
					"alt":PlayerConfig.startAdLoadTime,
					"apt":PlayerConfig.startAdPlayTime,
					"slt":(PlayerConfig.skinLoadTime > 150000?0:PlayerConfig.skinLoadTime),
					"rpt":(PlayerConfig.videoDownloadTime > 0?getTimer() - PlayerConfig.videoDownloadTime:0),
					"aps":_loc2_
				});
				PlayerConfig.sendRealVV = true;
			}
			if((Eif.available) && !(PlayerConfig.onPlay == "")) {
				ExternalInterface.call(PlayerConfig.onPlay);
			}
		}
		
		private function onStop(param1:MediaEvent = null) : void {
			if(param1 != null) {
				if((this._ads.endAd.hasAd) && this._ads.endAd.state == "no") {
					this._ads.endAd.play();
				} else {
					this.endAdFinish();
				}
				if(this._ads.bottomAd.hasAd) {
					this._ads.bottomAd.close();
				}
				if(this._ads.topAd.hasAd) {
					this._ads.topAd.close();
				}
				if(this._ads.logoAd.hasAd) {
					this._ads.logoAd.close();
				}
				if(this._ads.topLogoAd.hasAd) {
					this._ads.topLogoAd.close();
				}
			}
			if(!(PlayerConfig.startTime == "") && !(PlayerConfig.endTime == "")) {
				this._tvSohuMpb.core.seek(uint(PlayerConfig.startTime));
			}
			if((Eif.available) && !(PlayerConfig.onStop == "") && !this._isJsCallLoadAndPlay) {
				ExternalInterface.call(PlayerConfig.onStop);
			}
		}
		
		private function playListVideo(param1:Event) : void {
			this.loopSoft();
			PlayerConfig.lb = "1";
			PlayerConfig.lastReferer = PlayerConfig.filePrimaryReferer;
			var _loc2_:Object = this._tvSohuMpb.panel.getVideoInfo();
			if(_loc2_.isMyorVrs) {
				PlayerConfig.isMyTvVideo = true;
			} else {
				PlayerConfig.isMyTvVideo = false;
			}
			this.loadAndPlay(_loc2_.vid);
			this._tvSohuMpb.isSwitchVideos = false;
		}
		
		private function setVideoVer() : void {
			this._so = SharedObject.getLocal("vmsPlayer","/");
			if(!(this._so.data.ver == undefined) && !(this._so.data.ver == "") && !(String(this._so.data.ver) == "0")) {
				PlayerConfig.definition = this._version = this._so.data.ver;
			}
		}
		
		private function startAdLoaded(param1:TvSohuAdsEvent = null) : void {
			this.createMpb();
		}
		
		private function endAdShown(param1:TvSohuAdsEvent) : void {
			this.shieldRightMenuItem();
		}
		
		private function adsVolume(param1:Event) : void {
			param1.target.volume = 0.5;
		}
		
		private function adsMute(param1:Event) : void {
			param1.target.volume = 0;
		}
		
		private function screenAdFinish(param1:* = null) : void {
			var item12:ContextMenuItem = null;
			var evt:* = param1;
			Utils.debug("1111");
			clearInterval(this._tvSohuMpbOk);
			this._tvSohuMpbOk = setInterval(function():void {
				var _loc1_:* = undefined;
				var _loc2_:* = undefined;
				if(!(_tvSohuMpb == null) && (_tvSohuMpb.ncConnectError)) {
					clearInterval(_tvSohuMpbOk);
					statusError(PlayerConfig.NC_RETRY_FAILED_TEXT);
					writeErrorMark();
				} else if(!(_tvSohuMpb == null) && (_mpbSoftInitSuc)) {
					clearInterval(_tvSohuMpbOk);
					if(_isAutoPlay) {
						_tvSohuMpb.core.play();
						playPlayedAds();
					}
					if(PlayerConfig.onPlayed != "") {
						_loc1_ = SharedObject.getLocal("ac","/");
						_loc2_ = 0;
						if(_loc1_.data.nov != undefined) {
							_loc2_ = _loc1_.data.nov;
						}
						ExternalInterface.call(PlayerConfig.onPlayed,PlayerConfig.userId,Model.getInstance().videoInfo.vt,PlayerConfig.currentVideoReplayNum,_loc2_);
						PlayerConfig.onPlayed = "";
					}
					activateRightMenuItem();
				}
				
			},10);
			if((PlayerConfig.availableStvd) && (PlayerConfig.stvdInUse)) {
				item12 = new ContextMenuItem("关闭硬件加速");
				item12.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,this.closeStageVideo);
				item12.enabled = true;
				item12.separatorBefore = true;
				this._cm.customItems.push(item12);
			}
		}
		
		private function shieldRightMenuItem() : void {
			var _loc1_:uint = 0;
			while(_loc1_ < 3) {
				this._cm.customItems[_loc1_].enabled = false;
				_loc1_++;
			}
		}
		
		private function activateRightMenuItem() : void {
			var _loc1_:uint = 0;
			while(_loc1_ < 3) {
				this._cm.customItems[_loc1_].enabled = true;
				_loc1_++;
			}
		}
		
		private function playPlayedAds() : void {
			if(!this._isShowPlayedAd) {
				this._isShowPlayedAd = true;
				if(this._ads.logoAd.hasAd) {
					this._ads.logoAd.play();
				} else {
					this._ads.logoAd.pingback();
				}
				if(this._ads.topLogoAd.hasAd) {
					this._ads.topLogoAd.play();
				} else {
					this._ads.topLogoAd.pingback();
				}
				if(this._ads.topAd.hasAd) {
					this._ads.topAd.play();
				} else {
					this._ads.topAd.pingback();
				}
				if(this._ads.bottomAd.hasAd) {
					this._ads.bottomAd.play();
				} else {
					this._ads.bottomAd.pingback();
				}
			}
		}
		
		private function endAdFinish(param1:* = null) : void {
			var so:SharedObject = null;
			var item:Object = null;
			var flushResult:String = null;
			var evt:* = param1;
			PlayerConfig.advolume = null;
			if(this._isAutoLoop) {
				return;
			}
			var sgnp:Object = null;
			if((!(this._tvSohuMpb.panel == null)) && (this._tvSohuMpb.panel.hasNext()) && !PlayerConfig.isSohuDomain) {
				this._isAutoLoop = true;
				this._tvSohuMpb.panel.nextPlay();
				SendRef.getInstance().sendPQVPCU("PL_S _LIST");
			} else if((!(this._tvSohuMpb.panel == null) && this._tvSohuMpb.panel.hasNext()) && (PlayerConfig.isSohuDomain) && this._tvSohuMpb.stage.displayState == "fullScreen") {
				this._isAutoLoop = true;
				this._tvSohuMpb.panel.nextPlay();
				SendRef.getInstance().sendPQVPCU("PL_S _LIST");
			} else {
				if(!(this._tvSohuMpb.hisRecommObj == null) && !(this._tvSohuMpb.hisRecommObj.videoUrl == null) && !(this._tvSohuMpb.hisRecommObj.videoUrl == "")) {
					so = SharedObject.getLocal("hisRecommMark","/");
					item = {
						"vid":this._tvSohuMpb.hisRecommObj.vid,
						"time":new Date().getTime()
					};
					so.data.item = item;
					try {
						flushResult = so.flush();
						if(flushResult == SharedObjectFlushStatus.PENDING) {
							so.addEventListener(NetStatusEvent.NET_STATUS,this.onStatusShare);
						} else if(flushResult == SharedObjectFlushStatus.FLUSHED) {
						}
						
					}
					catch(e:Error) {
					}
					SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_haoli202921_bfqznlbvv&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
					SendRef.getInstance().sendPQDrog("http://ctr.hd.sohu.com/ctr.gif?fuid=" + PlayerConfig.userId + "&yyid=" + PlayerConfig.yyid + "&passport=" + PlayerConfig.passportMail + "&sid=" + PlayerConfig.sid + "&vid=" + this._tvSohuMpb.hisRecommObj.vid + "&pid=" + this._tvSohuMpb.hisRecommObj.pid + "&cid=" + this._tvSohuMpb.hisRecommObj.cid + "&refvid=" + PlayerConfig.vid + "&refpid=" + PlayerConfig.vrsPlayListId + "&refcid=" + PlayerConfig.caid + "&msg=click" + "&alg=" + this._tvSohuMpb.hisRecommObj.r + "&ab=0&formwork=33&type=100" + "&uuid=" + PlayerConfig.uuid + "&url=" + escape(this._tvSohuMpb.hisRecommObj.videoUrl) + "&refer=" + (PlayerConfig.currentPageUrl == ""?escape(PlayerConfig.outReferer):escape(PlayerConfig.currentPageUrl)));
					Utils.openWindow(this._tvSohuMpb.hisRecommObj.videoUrl,"_self");
				} else {
					PlayerConfig.otherInforSender = "restart";
					this._tvSohuMpb.readyReplay();
					if((Eif.available) && (PlayerConfig.hasApi)) {
						try {
							if(PlayerConfig.onEndAdStop != "") {
								ExternalInterface.call(PlayerConfig.onEndAdStop);
							} else {
								ExternalInterface.call("vrsPlayerCallEndAd");
								sgnp = ExternalInterface.call("swfGotoNewPage","",PlayerConfig.isTransition?"vms1":!PlayerConfig.isLongVideo?"vms2":PlayerConfig.isMyTvVideo?"my":"vrs");
							}
						}
						catch(evt:SecurityError) {
						}
					}
					if((Eif.available) && (PlayerConfig.hasApi)) {
						if(sgnp == null) {
							if(PlayerConfig.previewTime > 0 && PlayerConfig.cooperator == "imovie") {
								this._tvSohuMpb.toCommonMode();
							}
							if(PlayerConfig.previewTime > 0) {
								if((PlayerConfig.isPartner) || PlayerConfig.cooperator == "imovie") {
									if((Eif.available) && (ExternalInterface.available)) {
										ExternalInterface.call("playerIsBuy");
									}
								} else {
									this.loadPayPanel();
								}
							} else if(PlayerConfig.showRecommend) {
								this._tvSohuMpb.loadMore();
							} else {
								this._tvSohuMpb.showCover();
							}
							
						} else {
							this._tvSohuMpb.toCommonMode();
						}
					} else if(sgnp == null) {
						if(PlayerConfig.previewTime > 0 && PlayerConfig.cooperator == "imovie") {
							this._tvSohuMpb.toCommonMode();
						}
						if(PlayerConfig.previewTime > 0) {
							if((PlayerConfig.isPartner) || PlayerConfig.cooperator == "imovie") {
								if((Eif.available) && (ExternalInterface.available)) {
									ExternalInterface.call("playerIsBuy");
								}
							} else {
								this.loadPayPanel();
							}
						} else if(PlayerConfig.showRecommend) {
							this._tvSohuMpb.loadMore();
						} else {
							this._tvSohuMpb.showCover();
						}
						
					} else {
						this._tvSohuMpb.toCommonMode();
					}
					
				}
				if(!(this._tvSohuMpb.hisRecommObj == null) && !(this._tvSohuMpb.hisRecommObj.videoUrl == null) && !(this._tvSohuMpb.hisRecommObj.videoUrl == "")) {
				}
			}
			
		}
		
		private function adsHandler() : void {
			if(this._ads.hasAds) {
				this.getErrorMarkCookie();
				if((this._ads.startAd.hasAd) && (this._isPlayStartAd) && (this._isAutoPlay)) {
					this._ads.startAd.play();
				} else if((this._ads.startAd.hasAd && this._ads.startAd.isAutoPlayAd) && (!this._isAutoPlay) && (this._isPlayStartAd)) {
					this._ads.startAd.play();
				} else if(this._ads.illegal) {
					this.illegalAdsTip();
				} else {
					this.startAdLoadFailed();
				}
				
				
			} else {
				this.startAdLoadFailed();
			}
		}
		
		private function retryPanelShown(param1:Event) : void {
			if(PlayerConfig.isFirst) {
				PlayerConfig.isFirst = false;
				this.writeErrorMark();
			}
		}
		
		private function fetchVideoInfo(param1:String) : void {
			var _loc20_:Array = null;
			var _loc21_:String = null;
			var _loc22_:uint = 0;
			var _loc23_:Array = null;
			var _loc24_:String = null;
			var _loc2_:String = PlayerConfig.isPreview?PlayerConfig.FETCH_VINFO_PATH_PREVIEW:PlayerConfig.isTransition?PlayerConfig.FETCH_VINFO_PATH_TRANSITION:PlayerConfig.isMyTvVideo?PlayerConfig.FETCH_VINFO_PATH_MYTV:PlayerConfig.liveType != ""?PlayerConfig.FETCH_LIVE_PATH:PlayerConfig.FETCH_VINFO_PATH;
			var _loc3_:String = param1;
			if(PlayerConfig.isTransition) {
				_loc20_ = param1.split("|");
				_loc21_ = "";
				_loc22_ = 0;
				while(_loc22_ < _loc20_.length) {
					_loc23_ = _loc20_[_loc22_].split("/");
					_loc24_ = _loc23_[_loc23_.length - 1];
					_loc21_ = _loc21_ + (_loc24_ + (_loc22_ == _loc20_.length - 1?"":"|"));
					_loc22_++;
				}
				if(!(_loc21_ == "") && !(_loc21_ == null)) {
					_loc3_ = _loc21_;
				}
			}
			if(this._tvSohuMpb != null) {
				this._tvSohuMpb.core.stop("noevent");
			}
			if(!(this._ads == null) && (this._isPlayStartAd)) {
				this._ads.destroy();
				this._isShowPlayedAd = false;
			}
			PlayerConfig.vid = param1;
			this._mpbSoftInitSuc = false;
			var _loc4_:* = "";
			if(this._isPlayStartAd) {
				_loc4_ = this.getParams("co") != ""?"&co=" + this.getParams("co"):"";
			}
			var _loc5_:String = this._version != ""?"&ver=" + this._version:"";
			var _loc6_:String = this._autoFix == "1"?"&af=1":"";
			var _loc7_:String = this.getParams("fkey");
			var _loc8_:String = _loc7_ != ""?"&fkey=" + _loc7_:"";
			var _loc9_:String = PlayerConfig.apiKey != ""?"&api_key=" + PlayerConfig.apiKey:"";
			var _loc10_:String = PlayerConfig.liveType != ""?"&type=" + PlayerConfig.liveType:"";
			var _loc11_:String = PlayerConfig.needP2PLive?"&quick=1":"";
			var _loc12_:String = "&referer=" + (PlayerConfig.currentPageUrl == ""?escape(PlayerConfig.outReferer):escape(PlayerConfig.currentPageUrl));
			var _loc13_:String = PlayerConfig.plid != ""?"&plid=" + PlayerConfig.plid:"";
			PlayerConfig.needP2PLive = false;
			var _loc14_:String = this._bandwidth != 0?"&bw=" + this._bandwidth:"";
			var _loc15_:String = this._isPwd?"&passwd=" + (this._tvSohuErrorMsg != null?this._tvSohuErrorMsg.pwdStr:""):"";
			var _loc16_:String = P2PExplorer.getInstance().hasP2P?"&hasIfox=1":"";
			var _loc17_:String = PlayerConfig.userId != ""?"&uid=" + PlayerConfig.userId:"";
			var _loc18_:String = PlayerConfig.cooperator != ""?"&cooperator=" + PlayerConfig.cooperator:"";
			var _loc19_:String = !(PlayerConfig.authorId == "") && !(PlayerConfig.authorId == null)?"&authorId=" + PlayerConfig.authorId:"";
			this._model.fetchVideoInfo(_loc2_ + _loc3_ + _loc5_ + _loc6_ + _loc14_ + _loc4_ + _loc8_ + _loc9_ + _loc16_ + _loc10_ + _loc11_ + _loc13_ + _loc17_ + _loc19_ + _loc18_ + "&out=" + PlayerConfig.domainProperty + _loc15_ + "&g=" + Math.abs(new Date().getTimezoneOffset() / 60) + _loc12_);
			this._autoFix = this._version = "";
		}
		
		private function vinfoLoadTimeout(param1:Event = null) : void {
			var _loc2_:TextFormat = new TextFormat();
			_loc2_.size = 14;
			_loc2_.leading = 10;
			_loc2_.bold = true;
			_loc2_.align = TextFormatAlign.LEFT;
			var _loc3_:TextField = new TextField();
			_loc3_.wordWrap = true;
			_loc3_.textColor = 14277081;
			_loc3_.width = 326;
			_loc3_.htmlText = PlayerConfig.VINFO_ERROR_TEXT;
			_loc3_.setTextFormat(_loc2_);
			_loc3_.addEventListener(TextEvent.LINK,this.linkHandler);
			Utils.setCenterByNumber(_loc3_,stage.stageWidth,stage.stageHeight);
			this._errStatusSp.addChild(_loc3_);
			this.writeErrorMark();
		}
		
		private function linkHandler(param1:TextEvent) : void {
			this._qfStat.sendFeedback();
		}
		
		private function writeErrorMark() : void {
			var _loc3_:String = null;
			var _loc1_:SharedObject = SharedObject.getLocal("errorMark","/");
			var _loc2_:Object = {
				"vid":PlayerConfig.vid,
				"time":new Date().getTime()
			};
			_loc1_.data.item = _loc2_;
			try {
				_loc3_ = _loc1_.flush();
				if(_loc3_ == SharedObjectFlushStatus.PENDING) {
					_loc1_.addEventListener(NetStatusEvent.NET_STATUS,this.onStatusShare);
				} else if(_loc3_ == SharedObjectFlushStatus.FLUSHED) {
				}
				
			}
			catch(e:Error) {
			}
		}
		
		private function getErrorMarkCookie() : void {
			var _loc1_:SharedObject = SharedObject.getLocal("errorMark","/");
			if(!(_loc1_.data.item == undefined) && !(_loc1_.data.item.vid == undefined) && !(_loc1_.data.item.vid == "")) {
				if(_loc1_.data.item.vid == PlayerConfig.vid && new Date().getTime() - _loc1_.data.item.time <= 300000) {
					this._isPlayStartAd = false;
				}
				_loc1_.clear();
			}
		}
		
		private function vinfoLoadIoError(param1:Event) : void {
			this.vinfoLoadTimeout();
		}
		
		private function vinfoDataEmpty(param1:Event) : void {
			if(!(stage.stageWidth == 0) && !(stage.stageHeight == 0)) {
				this.statusError(PlayerConfig.VINFO_DATA_ERROR);
			}
		}
		
		private function wirteCookie() : void {
			var _loc3_:String = null;
			var _loc1_:Number = new Date().getTime();
			var _loc2_:String = this.makeRandom(_loc1_);
			this._so = SharedObject.getLocal("vmsuser","/");
			if(this._so.data.id == undefined || this._so.data.id == "" || !(this._so.data.id.length == 20)) {
				_loc3_ = "";
				if(Utils.getBrowserCookie("fuid") != "") {
					this._so.clear();
					this._so.data.id = Utils.getBrowserCookie("fuid");
					this._so.data.ts = _loc1_;
					PlayerConfig.userId = Utils.getBrowserCookie("fuid");
					try {
						_loc3_ = this._so.flush();
						if(_loc3_ == SharedObjectFlushStatus.PENDING) {
							this._so.addEventListener(NetStatusEvent.NET_STATUS,this.onStatusShare);
						} else if(_loc3_ == SharedObjectFlushStatus.FLUSHED) {
						}
						
					}
					catch(e:Error) {
					}
				} else {
					this._so.clear();
					this._so.data.id = _loc2_;
					this._so.data.ts = _loc1_;
					PlayerConfig.userId = _loc2_;
					if((Eif.available) && (ExternalInterface.available)) {
						ExternalInterface.call("function(){var d = new Date();d.setTime(d.getTime()+(100*24*60*60*1000));var expires=\'expires=\'+d.toGMTString();document.cookie=\'fuid=" + _loc2_ + ";path=/;domain=tv.sohu.com;\'+expires;}");
					}
					try {
						_loc3_ = this._so.flush();
						if(_loc3_ == SharedObjectFlushStatus.PENDING) {
							this._so.addEventListener(NetStatusEvent.NET_STATUS,this.onStatusShare);
						} else if(_loc3_ == SharedObjectFlushStatus.FLUSHED) {
						}
						
					}
					catch(e:Error) {
					}
				}
			} else {
				PlayerConfig.userId = this._so.data.id;
			}
			if(this._so.data.id == undefined || this._so.data.id == "" || !(this._so.data.id.length == 20)) {
				return;
			}
		}
		
		private function get56Cookie() : void {
			var _loc1_:* = undefined;
			if(PlayerConfig.domainProperty == "3" && (Eif.available)) {
				_loc1_ = ExternalInterface.call("s2j_getCookie","fuid");
				LogManager.msg("通过56提供的js方法s2j_getCookie读取fuid=" + _loc1_);
				if(_loc1_ == "" || _loc1_ == null || _loc1_ == "undefined" || _loc1_ == undefined) {
					ExternalInterface.call("s2j_setCookie","fuid",PlayerConfig.userId,{
						"path":"/",
						"domain":".56.com",
						"expires":100 * 24 * 60 * 60 * 1000
					});
				} else {
					PlayerConfig.userId = _loc1_;
				}
			}
		}
		
		private function onStatusShare(param1:NetStatusEvent) : void {
			if(param1.info.code != "SharedObject.Flush.Success") {
				if(param1.info.code == "SharedObject.Flush.Failed") {
				}
			}
			param1.target.removeEventListener(NetStatusEvent.NET_STATUS,this.onStatusShare);
		}
		
		private function makeRandom(param1:Number) : String {
			var _loc2_:Number = 1000;
			var _loc3_:Number = _loc2_;
			var _loc4_:Number = _loc2_ + Math.pow(10,7);
			var _loc5_:Number = Math.random();
			_loc5_ = _loc5_ < 0.1?_loc5_ + 0.1:_loc5_;
			var _loc6_:Number = Math.floor(_loc3_ + _loc5_ * _loc4_);
			var _loc7_:String = String(param1) + "" + String(_loc6_);
			return _loc7_;
		}
		
		private function parseVInfo(param1:Object) : void {
			var coverImg:String = null;
			var uvrObj:Object = null;
			var arr:Array = null;
			var pageUrl:String = null;
			var flvPath:String = null;
			var j:int = 0;
			var et2:uint = 0;
			var st2:Number = NaN;
			var k:uint = 0;
			var l:uint = 0;
			var len:Number = NaN;
			var minute_str:String = null;
			var adpoArr:Array = null;
			var n:uint = 0;
			var info:Object = param1;
			if(PlayerConfig.coverImg != "") {
				arr = ["taobao\\.com$"];
				pageUrl = PlayerConfig.currentPageUrl == ""?escape(PlayerConfig.outReferer):escape(PlayerConfig.currentPageUrl);
				if((this.specialDomain(pageUrl,arr)) && (this.specialDomain(PlayerConfig.coverImg,PlayerConfig.SOHU_MATRIX)) || !this.specialDomain(pageUrl,arr)) {
					coverImg = PlayerConfig.coverImg;
				}
			} else {
				PlayerConfig.coverImg = coverImg = info.data.coverImg;
			}
			var filePath:String = "";
			var fileSize:String = "";
			var fileTime:String = "";
			var streamarr:Array = info.data.clipsURL;
			var sizearr:Array = info.data.clipsBytes;
			var timearr:Array = info.data.clipsDuration;
			var is200:Boolean = false;
			if(!(info.prot == null) && info.prot == "2") {
				is200 = true;
			}
			var st:uint = PlayerConfig.stTime = info.data.sT != null?uint(info.data.sT):0;
			var et:uint = PlayerConfig.etTime = info.data.eT != null?uint(info.data.eT):0;
			var ep:Array = info.data.eP != null?info.data.eP:new Array();
			var uvr:Array = info.uvr != null?info.uvr:new Array();
			var midAdAdPo:Array = new Array();
			var totTime:Number = 0;
			var epInfo:Array = new Array();
			var cupTipArr:Array = new Array();
			PlayerConfig.fileSize = sizearr;
			if(info.p2pflag != null) {
				PlayerConfig.p2pflag = info.p2pflag;
			}
			if(info.bs != null) {
				PlayerConfig.availableTime = Number(info.bs);
			}
			if(!(info.ibn == null) && info.ibn == 1) {
				PlayerConfig.isPlayDownSameClip = true;
			} else {
				PlayerConfig.isPlayDownSameClip = false;
			}
			if(!(info.data.su == null) && info.data.su is Array) {
				PlayerConfig.synUrl = info.data.su;
			}
			if(info.ct != null) {
				PlayerConfig.area = info.ct;
			}
			if(info.nt != null) {
				PlayerConfig.isp = info.nt;
			}
			if(info.hcap != null) {
				PlayerConfig.hcap = String(info.hcap);
			}
			if(!(info.data.logoUrl == null) && !(info.data.logoUrl == "")) {
				PlayerConfig.watermarkPath = info.data.logoUrl;
			}
			if(!(info.scap == null) && !(PlayerConfig.hcap == "-1")) {
				PlayerConfig.cap = info.scap;
			}
			if(info.fee != null) {
				PlayerConfig.isFee = info.fee == 1?true:false;
			}
			if(!(info.cmscat == null) && !(info.cmscat == "")) {
				PlayerConfig.cmscat = info.cmscat;
			}
			if(this.getParams("cmscat") != "") {
				PlayerConfig.cmscat = this.getParams("cmscat");
			}
			if(this.getParams("playListId") != "") {
				PlayerConfig.playListId = this.getParams("playListId");
			}
			if(!(info.data.hc == null) && !(info.data.hc == "")) {
				PlayerConfig.hashId = info.data.hc;
			}
			if(!(info.data.ck == null) && !(info.data.ck == "")) {
				PlayerConfig.key = info.data.ck;
			}
			if(!(info.data.bfd == null) && !(info.data.bfd == "")) {
				PlayerConfig.bfd = info.data.bfd;
			}
			if(!(info.sp == null) && !(info.sp == "")) {
				PlayerConfig.p2pSP = info.sp;
			}
			if(info.url != null) {
				PlayerConfig.filePrimaryReferer = info.url;
			}
			if(info.data.version != null) {
				PlayerConfig.isHd = String(info.data.version) == "1" || String(info.data.version) == "21" || String(info.data.version) == "2" || String(info.data.version) == "31"?true:false;
			}
			if(!(info.data.photoUrls == null) && !(info.data.photoUrls == "")) {
				PlayerConfig.photoUrlsArr = info.data.photoUrls;
			}
			try {
				if(info.data.tvName != null) {
					PlayerConfig.videoTitle = unescape(info.data.tvName);
				}
			}
			catch(evt:*) {
				LogManager.msg("Main::解析tvName:" + evt);
			}
			if(info.allot != null) {
				PlayerConfig.gslbIp = info.allot;
			}
			if(info.reserveIp != null) {
				PlayerConfig.backupGSLBIP = info.reserveIp.split(";");
			}
			if(!(info.tn == null) && !(info.data.tn == "")) {
				PlayerConfig.p2pTNum = uint(info.tn);
			}
			if(!(info.id == null) && !(String(info.id) == "0")) {
				PlayerConfig.currentVid = String(info.id);
			}
			var isSendTa:Boolean = PlayerConfig.ch_key.split("aureole").length > 1;
			PlayerConfig.ta_jm = !(PlayerConfig.ch_key == "") && (isSendTa)?this._btnUi.drawBtn(PlayerConfig.ch_key,PlayerConfig.currentVid,PlayerConfig.userId.substr(0,8)):"";
			if(!(info.data.relativeId == null) && !(String(info.data.relativeId) == "0")) {
				PlayerConfig.relativeId = info.data.relativeId;
			}
			if(!(info.data.superVid == null) && !(String(info.data.superVid) == "0")) {
				PlayerConfig.superVid = String(info.data.superVid);
			} else {
				PlayerConfig.superVid = "";
			}
			if(!(info.data.highVid == null) && !(String(info.data.highVid) == "0")) {
				PlayerConfig.hdVid = info.data.highVid;
			} else {
				PlayerConfig.hdVid = "";
			}
			if(!(info.data.norVid == null) && !(String(info.data.norVid) == "0")) {
				PlayerConfig.norVid = info.data.norVid;
			} else {
				PlayerConfig.norVid = "";
			}
			if(!(info.data.oriVid == null) && !(String(info.data.oriVid) == "0")) {
				PlayerConfig.oriVid = info.data.oriVid;
			} else {
				PlayerConfig.oriVid = "";
			}
			if(!(info.data.h2644kVid == null) && !(String(info.data.h2644kVid) == "0")) {
				PlayerConfig.h2644kVid = info.data.h2644kVid;
			} else {
				PlayerConfig.h2644kVid = "";
			}
			if(!(info.data.h2654kVid == null) && !(String(info.data.h2654kVid) == "0")) {
				PlayerConfig.h2654kVid = info.data.h2654kVid;
			} else {
				PlayerConfig.h2654kVid = "";
			}
			if(!(info.data.logoPos == null) && !(info.data.logoPos == "")) {
				PlayerConfig.watermarkPos = info.data.logoPos;
			}
			if((Eif.available) && (ExternalInterface.available)) {
				PlayerConfig.danmuDefaultStatus = Utils.getJSVar("sohuHD.baseInfo.dm");
				LogManager.msg("从页面获取的参数，参数值是：" + PlayerConfig.danmuDefaultStatus);
			} else if(info.dm != null) {
				PlayerConfig.danmuDefaultStatus = String(info.dm);
				LogManager.msg("从热点获取的参数，参数值是：" + PlayerConfig.danmuDefaultStatus);
			}
			
			if(PlayerConfig.danmuDefaultStatus == "1" || PlayerConfig.danmuDefaultStatus == "2") {
				PlayerConfig.isShowTanmu = true;
			} else {
				PlayerConfig.isShowTanmu = false;
			}
			if(!(info.isdl == null) && !(info.isdl == "")) {
				PlayerConfig.idDownload = info.isdl == 1?true:false;
			}
			if(this._isLoop) {
				PlayerConfig.isNewsLogo = this._isNewsLogo;
			}
			var i:uint = 0;
			while(i < timearr.length) {
				flvPath = (PlayerConfig.isFms) && !PlayerConfig.isLive?Utils.getType(streamarr[i],".") + ":" + streamarr[i].substring(streamarr[i].lastIndexOf("stream/") + 7,streamarr[i].length):streamarr[i];
				if(i == 0) {
					fileTime = String(timearr[i]);
					fileSize = sizearr[i];
					filePath = flvPath;
				} else {
					fileTime = fileTime + ("," + String(timearr[i]));
					fileSize = fileSize + ("," + sizearr[i]);
					filePath = filePath + ("," + flvPath);
				}
				totTime = totTime + timearr[i];
				i++;
			}
			if(!(info.ispv == null) && info.ispv == 1 && ((PlayerConfig.isFee) || PlayerConfig.cooperator == "imovie")) {
				j = 0;
				if(streamarr.length < timearr.length) {
					if(PlayerConfig.cooperator == "imovie") {
						j = 0;
						while(j < 2) {
							PlayerConfig.previewTime = PlayerConfig.previewTime + timearr[j];
							j++;
						}
					} else {
						j = 0;
						while(j < streamarr.length) {
							PlayerConfig.previewTime = PlayerConfig.previewTime + timearr[j];
							j++;
						}
					}
				} else if(totTime > 3600 || PlayerConfig.cooperator == "imovie") {
					PlayerConfig.previewTime = 600;
				} else {
					PlayerConfig.previewTime = 300;
				}
				
			}
			var re1:RegExp = new RegExp("http:\\/\\/tv\\.sohu\\.com");
			var re2:RegExp = new RegExp("http:\\/\\/store\\.tv\\.sohu\\.com");
			PlayerConfig.isTvAndOutSite = !PlayerConfig.isSohuDomain && ((re1.test(PlayerConfig.filePrimaryReferer)) || (re2.test(PlayerConfig.filePrimaryReferer)));
			if(!(PlayerConfig.startTime == "") && PlayerConfig.endTime == "") {
				et2 = uint(PlayerConfig.startTime) + PlayerConfig.SHARE_TIME_LIMIT;
				if(et2 < totTime) {
					PlayerConfig.endTime = String(et2);
				} else {
					PlayerConfig.endTime = String(totTime);
				}
			} else if(PlayerConfig.startTime == "" && !(PlayerConfig.endTime == "")) {
				st2 = uint(PlayerConfig.endTime) - PlayerConfig.SHARE_TIME_LIMIT;
				if(st2 < 0) {
					PlayerConfig.startTime = "0";
				} else {
					PlayerConfig.startTime = String(st2);
				}
			} else if(!(PlayerConfig.startTime == "") && !(PlayerConfig.endTime == "")) {
				if(uint(PlayerConfig.endTime) < uint(PlayerConfig.startTime)) {
					PlayerConfig.startTime = PlayerConfig.endTime = "";
				} else if(uint(PlayerConfig.endTime) - uint(PlayerConfig.startTime) > PlayerConfig.SHARE_TIME_LIMIT) {
					PlayerConfig.endTime = String(uint(PlayerConfig.startTime) + PlayerConfig.SHARE_TIME_LIMIT);
				}
				
			}
			
			
			if(!(PlayerConfig.startTime == "") && !(PlayerConfig.endTime == "")) {
				if(this._breakPoint <= 0) {
					this._breakPoint = PlayerConfig.startTime == "0"?1:uint(PlayerConfig.startTime);
				}
			}
			if(st > 0 && st / totTime >= 0 && st / totTime <= 1) {
				epInfo[0] = {
					"rate":st / totTime,
					"time":st,
					"type":"",
					"title":"正片开始位置",
					"isai":"0"
				};
			}
			if(ep != null) {
				k = 0;
				while(k < ep.length) {
					if(!(ep[k].pt == null) && ep[k].pt == 3) {
						cupTipArr.push({
							"k":ep[k].k,
							"v":ep[k].v,
							"url":ep[k].url
						});
					} else if(ep[k].k / totTime >= 0 && ep[k].k / totTime <= 1) {
						epInfo.push({
							"rate":ep[k].k / totTime,
							"time":ep[k].k,
							"type":"",
							"title":ep[k].v,
							"isai":"0"
						});
					}
					
					k++;
				}
			}
			if(et > 0) {
				if(et / totTime >= 0 && et / totTime <= 1) {
					epInfo.push({
						"rate":et / totTime,
						"time":et,
						"type":"",
						"title":"正片结束位置",
						"isai":"0"
					});
				}
			}
			if(uvr != null) {
				l = 0;
				while(l < uvr.length) {
					if(!(uvr[l].t == null) && uvr[l].t == 1) {
						len = PlayerConfig.totalDuration - uvr[l].length;
						minute_str = String(Math.floor(len / 60));
						if(minute_str.length == 1) {
							minute_str = "0" + minute_str;
						}
						uvrObj = {
							"l":uvr[l].l,
							"len":minute_str,
							"url":uvr[l].ugcurl
						};
					}
					l++;
				}
			}
			PlayerConfig.epInfo = PlayerConfig.startTime == "" && PlayerConfig.endTime == ""?epInfo:null;
			PlayerConfig.cueTipEpInfo = cupTipArr != null?cupTipArr:null;
			PlayerConfig.uvrInfo = uvrObj != null?uvrObj:null;
			if(info.data.adpo != null) {
				adpoArr = info.data.adpo;
				n = 0;
				while(n < adpoArr.length) {
					midAdAdPo.push(adpoArr[n].s);
					n++;
				}
			} else {
				midAdAdPo.push(PlayerConfig.MIDDLEAD_SHOWTIME);
			}
			PlayerConfig.midAdTimeArr = midAdAdPo;
			PlayerConfig.stype = PlayerConfig.isMyTvVideo?PlayerConfig.wm_user == "20"?"211":"210":PlayerConfig.catcode;
			this._mpbSoftInitObj = {
				"filePath":filePath,
				"fileTime":fileTime,
				"fileSize":fileSize,
				"isDrag":this._isDrag,
				"cover":coverImg,
				"is200":is200
			};
			if(PlayerConfig.DEBUG) {
				info.holiday = 0;
			}
			if(!(info.holiday == null) && (PlayerConfig.autoPlay) && !(stage.loaderInfo.parameters["showMode"] == "360")) {
				if(info.holiday != 0) {
					this.loadLoading("http://tv.sohu.com/upload/swf/holiday/" + String(info.holiday) + ".swf");
				} else {
					this.loadLoading(PlayerConfig.swfHost + "TvSohuLoading.swf");
				}
			}
			if(totTime > 60 && (XNetStreamVODFactory.checkCompatibility()) && !((P2PExplorer.getInstance().hasP2P) || (PlayerConfig.isLive) || (PlayerConfig.isFms))) {
				if(!PlayerConfig.isWebP2p) {
					LogManager.msg("p2p初始化开始");
					PlayVODStream.init(function():void {
						LogManager.msg("p2p初始化完成，结果：" + PlayVODStream.factory.isSuccess);
						if(PlayVODStream.factory.isSuccess) {
							PlayerConfig.isWebP2p = true;
						} else {
							PlayerConfig.isWebP2p = false;
						}
						if(PlayerConfig.autoPlay) {
							Model.getInstance().sendVV();
						}
						loadAdsInfo();
					});
				} else {
					if(PlayerConfig.autoPlay) {
						Model.getInstance().sendVV();
					}
					this.loadAdsInfo();
				}
			} else {
				if(PlayerConfig.autoPlay) {
					Model.getInstance().sendVV();
				}
				PlayerConfig.isWebP2p = false;
				if(PlayerConfig.autoPlay) {
					Model.getInstance().sendVV();
				}
				this.loadAdsInfo();
			}
		}
		
		private function loadAdsInfo() : void {
			var _loc2_:* = NaN;
			var _loc3_:String = null;
			var _loc1_:* = false;
			try {
				if((Eif.available) && (ExternalInterface.available)) {
					_loc2_ = PlayerConfig.totalDuration > 180?30:10;
					_loc3_ = InforSender.getInstance().heartBeat(_loc2_,"http://pb.hd.sohu.com.cn/hdpb.gif?msg=realPlayTime") + "&time=" + PlayerConfig.viewTime;
					ExternalInterface.call("messagebus.publish","player.update_time",{
						"time":PlayerConfig.viewTime,
						"pingback":_loc3_
					});
				}
				this._svdUserSo = SharedObject.getLocal("svdUserTip","/");
				if(!(this._svdUserSo.data.svdTag == undefined) && !(this._svdUserSo.data.svdTag == "") && (this._svdUserSo.data.svdTag == "0" || this._svdUserSo.data.svdTag == "1")) {
					_loc1_ = true;
					if(this._svdUserSo.data.svdTag == "0" && !(this._tvSohuMpb == null)) {
						this._tvSohuMpb.isSvdUserTip = true;
					}
					this._svdUserSo.clear();
				}
			}
			catch(e:Error) {
			}
			if(PlayerConfig.DEBUG_MAIL.indexOf(PlayerConfig.passportMail) == -1 && (this._isPlayStartAd) && !_loc1_) {
				this._ads.loadAdInfo(this.adsHandler);
			} else {
				this.startAdLoadFailed();
				this._isPlayStartAd = true;
			}
		}
		
		public function vinfoLoadSuccess(param1:* = null) : void {
			var _loc3_:RegExp = null;
			var _loc4_:RegExp = null;
			var _loc5_:RegExp = null;
			var _loc6_:RegExp = null;
			var _loc7_:RegExp = null;
			var _loc8_:RegExp = null;
			var _loc9_:RegExp = null;
			Utils.debug("fetch video info success");
			var _loc2_:Object = param1 == null && !(PlayerConfig.videoInfo == null)?PlayerConfig.videoInfo:param1.target.videoInfo;
			PlayerConfig.videoInfo = null;
			if(_loc2_.play == 1) {
				if(_loc2_.status == 1) {
					if((PlayerConfig.isTransition) || (PlayerConfig.isLive)) {
						this._isDrag = false;
					} else {
						this._isDrag = true;
					}
					this.parseVInfo(_loc2_);
				} else if(_loc2_.status == 2) {
					this._isDrag = false;
					this.parseVInfo(_loc2_);
				} else if(_loc2_.status == 3) {
					_loc3_ = new RegExp("CODE");
					this.statusError(PlayerConfig.COPYRIGHT_FALLIN.replace(_loc3_,PlayerConfig.VINFO_ERROR_3));
				} else if(_loc2_.status == 5) {
					this.statusError(_loc2_.mytvmsg);
				} else if(_loc2_.status == 6) {
					_loc4_ = new RegExp("CODE");
					this.statusError(PlayerConfig.COPYRIGHT_FALLIN.replace(_loc4_,PlayerConfig.VINFO_ERROR_6));
				} else if(_loc2_.status == 7) {
					_loc5_ = new RegExp("CODE");
					this.statusError(PlayerConfig.COPYRIGHT_FALLIN.replace(_loc5_,PlayerConfig.VINFO_ERROR_7));
				} else if(_loc2_.status == 8) {
					_loc6_ = new RegExp("CODE");
					this.statusError(PlayerConfig.COPYRIGHT_FALLIN.replace(_loc6_,PlayerConfig.VINFO_ERROR_8));
				} else if(_loc2_.status == 9) {
					_loc7_ = new RegExp("CODE");
					this.statusError(PlayerConfig.COPYRIGHT_FALLIN.replace(_loc7_,PlayerConfig.VINFO_ERROR_9));
				} else if(_loc2_.status == 10) {
					_loc8_ = new RegExp("CODE");
					this.statusError(PlayerConfig.COPYRIGHT_STORE.replace(_loc8_,PlayerConfig.VINFO_ERROR_10));
				} else if(_loc2_.status == 11) {
					_loc9_ = new RegExp("CODE");
					this._isPwd = true;
					this.statusError(_loc2_.mytvmsg);
				}
				
				
				
				
				
				
				
				
				
			} else if(!(_loc2_.status == null) && _loc2_.status == 12) {
				this.statusError(PlayerConfig.VINFO_DATA_ERROR);
			} else {
				this.statusError(PlayerConfig.LIMIT_TEXT);
			}
			
		}
		
		private function statusError(param1:String) : void {
			var _time:Number = NaN;
			var strTxt:String = param1;
			this.hideTvSohuLoading();
			if(this._tvSohuMpb != null) {
				this.tvSohuMpb.clearTipText();
			}
			var hasSkin:Boolean = false;
			if(!(this._tvSohuMpb == null) && !(this._tvSohuMpb.skin == null)) {
				hasSkin = true;
			} else {
				hasSkin = false;
			}
			this._tvSohuErrorMsg = new TvSohuErrorMsg(stage.stageWidth,stage.stageHeight,strTxt,hasSkin,this._isPwd);
			this._tvSohuErrorMsg.addEventListener("loadAndPlay",function(param1:Event):void {
				loadAndPlay(PlayerConfig.vid);
			});
			this._errStatusSp.addChild(this._tvSohuErrorMsg);
			_time = setInterval(function():void {
				onStop();
				clearInterval(_time);
			},5000);
		}
		
		private function resize() : void {
			if(this._tvSohuLoading != null) {
				this._tvSohuLoading.resize(stage.stageWidth,stage.stageHeight);
			}
			if(this._logsPanel != null) {
				if(!(this._tvSohuMpb == null) && (this._tvSohuMpb.core)) {
					this._logsPanel.resize(this._tvSohuMpb.core.width,this._tvSohuMpb.core.height - 5);
				} else {
					this._logsPanel.resize(stage.stageWidth,stage.stageHeight - 42);
				}
			}
			if(this._verInfoPanel != null) {
				if(!(this._tvSohuMpb == null) && (this._tvSohuMpb.core)) {
					this._verInfoPanel.resize(this._tvSohuMpb.core.width,this._tvSohuMpb.core.height - 5);
				} else {
					this._verInfoPanel.resize(stage.stageWidth,stage.stageHeight - 42);
				}
			}
			if(this._bg != null) {
				this._bg.width = stage.stageWidth;
				this._bg.height = stage.stageHeight;
			}
			if(this._tvSohuErrorMsg != null) {
				this._tvSohuErrorMsg.resize(stage.stageWidth,stage.stageHeight);
			}
			if(this._adPlayIllegal != null) {
				this._adPlayIllegal.resize(stage.stageWidth,stage.stageHeight);
			}
			if(this._payPanel != null) {
				this._payPanel.resize(stage.stageWidth,stage.stageHeight);
			}
		}
		
		private function keyboardUpHandler(param1:KeyboardEvent) : void {
			switch(param1.keyCode) {
				case 68:
					if((param1.ctrlKey) && ((param1.shiftKey) && !PlayerConfig.isCounterfeitFms || (param1.altKey))) {
						this.gotoCopyLog();
					}
					break;
			}
		}
		
		private function stageVideoAvailabilityHandler(param1:StageVideoAvailabilityEvent) : void {
			if(param1.availability == StageVideoAvailability.AVAILABLE && stage.loaderInfo.parameters["stageVideo"] == "1") {
				PlayerConfig.availableStvd = true;
				this._bg.visible = false;
				if((PlayerConfig.availableStvd) && !(PlayerConfig.recordSvdMode == 0)) {
					PlayerConfig.stvdInUse = true;
				}
				LogManager.msg("已开启硬件加速功能");
			} else {
				LogManager.msg("未开启硬件加速功能");
				PlayerConfig.availableStvd = false;
				this._bg.visible = true;
				PlayerConfig.stvdInUse = false;
			}
		}
		
		public function webUnload() : void {
		}
		
		public function playVideo() : void {
			if((TvSohuAds.getInstance().startAd.hasAd) && TvSohuAds.getInstance().startAd.state == "playing") {
				TvSohuAds.getInstance().startAd.resume();
			} else {
				this._tvSohuMpb.core.play();
			}
		}
		
		public function pauseVideo() : void {
			if((TvSohuAds.getInstance().startAd.hasAd) && TvSohuAds.getInstance().startAd.state == "playing") {
				TvSohuAds.getInstance().startAd.pause();
			} else {
				this._tvSohuMpb.core.pause();
			}
		}
		
		public function updateUserLoginInfo(param1:String) : void {
			switch(param1) {
				case "login":
					break;
				case "login.userinfo":
					PlayerConfig.passportMail = this.getPassportMail();
					if(PlayerConfig.domainProperty == "3") {
						PlayerConfig.visitorId = PlayerConfig.passportMail.split("@")[0];
					} else if(Eif.available) {
						PlayerConfig.visitorId = ExternalInterface.call("sohuHD.user.uid");
					}
					
					if(this._tvSohuMpb != null) {
						this._tvSohuMpb.updateUserLoginInfo();
					}
					break;
				case "logout":
					if(Eif.available) {
						PlayerConfig.visitorId = ExternalInterface.call("sohuHD.user.uid");
					}
					PlayerConfig.passportMail = this.getPassportMail();
					if(this._tvSohuMpb != null) {
						this._tvSohuMpb.updateUserLoginInfo();
					}
					break;
			}
		}
		
		public function setCtrlBarVisible(param1:* = null) : void {
			this._tvSohuMpb.ctrlBarVisible(this.getParams("showCtrlBar") == "0"?true:false,param1);
		}
		
		private function loadPayPanel() : void {
			if(this._payPanel == null) {
				new LoaderUtil().load(10,function(param1:Object):void {
					var obj:Object = param1;
					if(obj.info == "success") {
						_payPanel = obj.data.content;
						_payPanel.init(PlayerConfig.vrsPlayListId,PlayerConfig.vid);
						_payPanel.addEventListener("replay_preview_video",function(param1:Event):void {
							_tvSohuMpb.replay();
						});
						addChild(_payPanel);
						_payPanel.resize(stage.stageWidth,stage.stageHeight);
					}
				},null,PlayerConfig.swfHost + "panel/PayPanel.swf");
			} else {
				this._payPanel.visible = true;
			}
		}
		
		private function onThrottle(param1:Event) : void {
			if(param1["state"] == "throttle") {
				PlayerConfig.isThrottle = true;
			} else if(param1["state"] == "resume") {
				PlayerConfig.isThrottle = false;
			}
			
		}
		
		private function uncaughtErrorHandler(param1:UncaughtErrorEvent) : void {
			LogManager.msg("uncaughtErrorHandler : event.error : " + param1.error);
			if(this._tvSohuMpb != null) {
				this._tvSohuMpb.isUncaught = true;
				this._tvSohuMpb.uncaughtError = param1.error;
			}
			param1.preventDefault();
		}
		
		public function get tvSohuMpb() : * {
			return this._tvSohuMpb;
		}
	}
}
