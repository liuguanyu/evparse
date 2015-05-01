package com.sohu.tv.mediaplayer {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.display.CapsStyle;
	
	public class PlayerConfig extends Object {
		
		public function PlayerConfig() {
			super();
		}
		
		public static const VERSION:String = "201504291040";
		
		public static const DEBUG:Boolean = false;
		
		public static const HIDESTARTAD:Boolean = false;
		
		public static const DEBUG_MAIL:Array = ["flaer@vip.qq.com","woaidbh@126.com","octoberyueyue@163.com","wangxiaohu111@sohu.com","dcw1123@sohu.com","18210115457@sohu.com"];
		
		public static const DEBUG_VID:String = "2254571";
		
		public static const DEBUG_PID:String = "261789173";
		
		public static var liveType:String = "";
		
		public static var tempParam:Boolean = false;
		
		public static var nextVid:String = "";
		
		public static var isWebP2p:Boolean = false;
		
		public static var ktvMode:String = "oa";
		
		public static var gslbErrorIp:String = "";
		
		public static var cmscat:String = "";
		
		public static var caid:String = "";
		
		public static var adReview:String = "";
		
		public static var previewTime:uint = 0;
		
		public static var isMute:Boolean = false;
		
		public static var availableTime:uint = 60;
		
		public static var isPlayDownSameClip:Boolean = false;
		
		public static var quickMaxBufferNum:uint = 0;
		
		public static var danmuDefaultStatus:String = "";
		
		public static var vmsFlv:String = "";
		
		public static var passportUID:String = "";
		
		public static var passportMail:String = "";
		
		public static var xuid:String = "";
		
		public static var isLongVideo:Boolean = true;
		
		public static var isFee:Boolean;
		
		public static var p2pflag:uint;
		
		public static var cooperator:String = "";
		
		public static var activityTimer:uint;
		
		public static const ACTIVITY_SWF_PATH:String = "http://tv.sohu.com/upload/swf/ac/ac.swf";
		
		public static const TANMU_SWF_URL:String = "http://www.56.com/flashApp/Tanmu.15.04.14.swf";
		
		public static var watermarkPath:String = "";
		
		public static var watermarkPos:String = "left-top";
		
		public static var isForbidP2P:String = "";
		
		public static var hcap:String;
		
		public static var cap:Array;
		
		public static var backupGSLBIP:Array;
		
		public static const TIMER_PATH:String = "http://tv.sohu.com/upload/swf/time.swf";
		
		public static const FETCH_VINFO_PATH:String = "http://hot.vrs.sohu.com/vrs_flash.action?vid=";
		
		public static const FETCH_VINFO_PATH_TRANSITION:String = "http://hot.vrs.sohu.com/vrs_vms.action?p=flash&old=";
		
		public static const FETCH_VINFO_PATH_MYTV:String = "http://my.tv.sohu.com/play/videonew.do?vid=";
		
		public static const FETCH_ADS_PATCH:String = "http://v.aty.sohu.com/v";
		
		public static const FETCH_LIVE_PATH:String = "http://live.tv.sohu.com/live/player_json.jhtml?encoding=utf-8&lid=";
		
		public static const MIDDLEAD_SHOWTIME:uint = 895;
		
		public static var midAdTimeArr:Array;
		
		public static const LOGOAD_DELAY:uint = 600;
		
		public static var startTime:String = "";
		
		public static var endTime:String = "";
		
		public static var totalDuration:Number = -1;
		
		public static var apiKey:String = "";
		
		public static var userAgent:String = "";
		
		public static var currentVideoReplayNum:uint;
		
		public static var idDownload:Boolean = false;
		
		public static var playingSplit:uint;
		
		public static var playedTime:uint;
		
		public static var videoArr:Array;
		
		public static var isTransition:Boolean = false;
		
		public static var isMyTvVideo:Boolean = false;
		
		public static const FETCH_VINFO_SUB_IP:Array = ["220.181.118.25","220.181.118.181","123.126.48.47","123.126.48.48"];
		
		public static const FETCH_VINFO_PATH_PREVIEW:String = "http://preview.vrs.sohu.com/vrs_flash.action?vid=";
		
		public static const RECOMMEND_PANEL_PATH:String = "recommend.swf";
		
		public static const OUTRECOMMEND_PANEL_PATH:String = "recommendOut.swf";
		
		public static const CHECKP2PPATH:String = "http://127.0.0.1:8828/";
		
		public static var hashId:Array;
		
		public static var key:Array;
		
		public static var p2pSP:uint;
		
		public static var fileSize:Array;
		
		public static var videoVersion:String = "";
		
		public static var p2pTNum:uint = 0;
		
		public static var isFirst:Boolean = true;
		
		public static const LIMIT_TEXT:String = "亲爱的用户，该视频仅授权中国大陆地区用户观看，向我们<u><a href=\"event:\"><font color=\"#ff0000\">留言反馈</font></a></u>。";
		
		public static const VINFO_ERROR_TEXT:String = "视频加载失败，请检查您的网络连接情况后重试，向我们<u><a href=\"event:\"><font color=\"#ff0000\">留言反馈</font></a></u>";
		
		public static const COPYRIGHT_FALLIN:String = "亲爱的用户，该视频版权已到期(CODE)，无法提供观看服务了，向我们<u><a href=\"event:\"><font color=\"#ff0000\">留言反馈</font></a></u>";
		
		public static const COPYRIGHT_STORE:String = "亲爱的用户，该视频已过付费有效期(CODE)，无法提供观看服务了，向我们<u><a href=\"event:\"><font color=\"#ff0000\">留言反馈</font></a></u>";
		
		public static const NC_RETRY_FAILED_TEXT:String = "视频加载失败，请检查您的网络连接情况后重试，向我们<u><a href=\"event:\"><font color=\"#ff0000\">留言反馈</font></a></u>";
		
		public static const VINFO_DATA_ERROR:String = "亲爱的用户，该视频内容存在异常，无法提供观看服务了，向我们<u><a href=\"event:\"><font color=\"#ff0000\">留言反馈</font></a></u>";
		
		public static const ADS_DATA_ERROR:String = "亲爱的用户，视频无法正常播放了，<br>请尝试关闭广告屏蔽功能或使用其他浏览器观看</br>";
		
		public static const ADS_PLAY_ILLEGAL:String = "<b>亲爱的用户，视频播放发生错误，</b><br><b>请您尝试使用其它浏览器观看！(CODE)</b></br><br></br><br><font  size=\"10\">也可安装 搜狐影音 观看视频，</font><u><a href=\"http://p2p.hd.sohu.com/dcs.do?f=1&s=1058\"><font color=\"#ff0000\" size=\"10\">安装试用</font></a></u></br><br><font  size=\"10\">如果依然无法观看视频，</font><u><a href=\"event:1\"><font color=\"#ff0000\" size=\"10\">请反馈给我们</font></a></u></br>";
		
		public static const ILLEGAL_INTERCEPT_DATA:String = "广告无法播放<br>观看广告的时候，我们会为你加载视频，观看更加流畅；</br><br>想要跳过广告，可以参与我们的活动：<u><a href=\"http://tv.sohu.com/vipapp/index.shtml\" target=\'_blank\'><font color=\"#ff0000\">免费去广告</font></a></u></br><br>请关闭广告屏蔽软件</br>";
		
		public static var showShareBtn:Boolean = false;
		
		public static var showWiderBtn:Boolean = false;
		
		public static var showMiniWinBtn:Boolean = false;
		
		public static var showTopBar:Boolean = false;
		
		public static var showDownloadBtn:Boolean = false;
		
		public static var showSogouBtn:Boolean = true;
		
		public static var showIFoxBar:Boolean = true;
		
		public static var isUseSpacebar:Boolean = true;
		
		public static var searchFocusIn:Boolean = false;
		
		public static var onPlay:String = "";
		
		public static var onPause:String = "";
		
		public static var onStop:String = "";
		
		public static var onPlayed:String = "";
		
		public static var onPlayerReady:String = "";
		
		public static var onEndAdStop:String = "";
		
		public static var onMAdShown:String = "";
		
		public static var onMAdFinish:String = "";
		
		public static var gslbIp:String = "";
		
		public static var gslbIpList:Array = ["115.25.217.132","219.238.10.34","220.181.61.229","221.130.27.2","61.135.183.46","data.vod.itc.cn","220.181.61.213","220.181.61.212","61.135.183.45","61.135.183.50","123.125.123.80","123.125.123.81","123.125.123.82","220.181.61.240","111.13.123.146","111.13.123.147","112.25.62.194"];
		
		public static var isBrowserFullScreen:Boolean = false;
		
		public static var clientIp:String = "";
		
		public static var cdnIp:String = "";
		
		public static var cdnId:String = "";
		
		public static var gslbWay:String = "";
		
		public static var stTime:uint = 0;
		
		public static var etTime:uint = 0;
		
		public static var filePrimaryReferer:String = "";
		
		public static var epInfo:Array;
		
		public static var isFms:Boolean = false;
		
		public static var isCounterfeitFms:Boolean = false;
		
		public static var mpbSoftInitObj:Object;
		
		public static var area:String = "";
		
		public static var isp:String = "";
		
		public static const SHARE_TIME_LIMIT:uint = 900;
		
		public static var videoInfo:Object;
		
		public static var autoFix:String = "";
		
		public static const GET_HIGHLIGHT_FOR9:String = "http://my.tv.sohu.com/lp/recommend_point.action?vid=";
		
		public static const GET_HIGHLIGHT_FORALL:String = "http://my.tv.sohu.com/lp/query_point.action?vid=";
		
		public static const SOHU_MATRIX:Array = ["localhost$","myfamily\\.sohu-inc\\.com$","sohu\\.com$","chinaren\\.com$","focus\\.cn$","17173\\.com$","sogou\\.com$","changyou\\.com$","56\\.com$"];
		
		public static const TV_SOHU:String = "tv\\.sohu\\.com$";
		
		public static var domainProperty:String = "-1";
		
		public static var playMode:String = "";
		
		public static var videoTitle:String = "";
		
		public static var flashVersion:String = "";
		
		public static var isSohuDomain:Boolean;
		
		public static var isTvAndOutSite:Boolean;
		
		public static var available:Boolean = false;
		
		public static var isClipDataError:Boolean = false;
		
		public static var swfHost:String = "";
		
		public static var isJump:Boolean = true;
		
		public static var vid:String = "";
		
		public static var superVid:String = "";
		
		public static var isLive:Boolean = false;
		
		public static var isP2PLive:Boolean = false;
		
		public static var hasP2PLive:Boolean = false;
		
		public static var needP2PLive:Boolean = false;
		
		public static var needInstallIFox:Boolean = false;
		
		public static var cid:String = "";
		
		public static var relativeId:String = "";
		
		public static var currentVid:String = "";
		
		public static var highlightInfo:Array;
		
		public static var hdVid:String = "";
		
		public static var oriVid:String = "";
		
		public static var norVid:String = "";
		
		public static var h2644kVid:String = "";
		
		public static var h2654kVid:String = "";
		
		public static var sid:String = "";
		
		public static var nid:String = "";
		
		public static var pid:String = "";
		
		public static var playListId:String = "";
		
		public static var vrsPlayListId:String = "";
		
		public static var playOrder:String = "";
		
		public static var seekTo:uint = 0;
		
		public static var isHd:Boolean;
		
		public static var definition:String = "";
		
		public static var otherInforSender:String = "";
		
		public static var viewTime:uint = 0;
		
		public static var autoPlay:Boolean;
		
		public static var showBorder:Boolean;
		
		public static var showRecommend:Boolean;
		
		public static var recommendPath:String;
		
		public static var showCommentBtn:Boolean;
		
		public static var showAds:Boolean;
		
		public static var hasApi:Boolean;
		
		public static var coverImg:String = "";
		
		public static var skinPath:String = "";
		
		public static var skinNum:String = "";
		
		public static var playerReffer:String = "";
		
		public static var isHide:Boolean;
		
		public static const STAT_IP:Array = ["qf1.hd.sohu.com.cn","qf2.hd.sohu.com.cn"];
		
		public static const STAT_IP_QFCLIPS:Array = ["qf3.hd.sohu.com.cn","qf4.hd.sohu.com.cn","qf5.hd.sohu.com.cn"];
		
		public static var userId:String;
		
		public static var myTvUid:String = "";
		
		public static var myTvUserId:String = "";
		
		public static var uuid:String;
		
		public static var timestamp:Number;
		
		public static var isPreview:Boolean = false;
		
		public static var currentPageUrl:String = "";
		
		public static var outReferer:String = "";
		
		public static var tempLastTime:Number = 0;
		
		public static var flashCookieLastTime:Number = 0;
		
		public static var preludeTime:uint = 0;
		
		public static var channel:String = "";
		
		public static var synUrl:Array;
		
		public static const VINFO_CODE:uint = 2;
		
		public static const CDN_CODE:uint = 4;
		
		public static const GSLB_CODE:uint = 3;
		
		public static const BUFFER_CODE:uint = 5;
		
		public static const BUFFER_FULL_CODE:uint = 12;
		
		public static const VINFO_ERROR_OTHER:uint = 500;
		
		public static const VINFO_ERROR_TIMEOUT:uint = 501;
		
		public static const PRELOAD_SHOWN_CODE:uint = 6;
		
		public static const START_PRELOAD_CODE:uint = 7;
		
		public static const AFFIRM_RETRY_CODE:uint = 8;
		
		public static const RETRY_SHOWN_CODE:uint = 9;
		
		public static const SKIN_CODE:uint = 10;
		
		public static const ON_VIDEO_PAUSE_CODE:uint = 12;
		
		public static const ON_VIDEO_FULLSCREEN_CODE:uint = 13;
		
		public static const HDCOM_BTN_CLICK_CODE:uint = 14;
		
		public static const SHARE_BTN_CLICK_CODE:uint = 16;
		
		public static const CAPTION_BTN_CLICK_CODE:uint = 18;
		
		public static const SOGOU_BTN_CLICK_CODE:uint = 19;
		
		public static const VINFO_ERROR_2:uint = 502;
		
		public static const VINFO_ERROR_3:uint = 503;
		
		public static const VINFO_ERROR_6:uint = 506;
		
		public static const VINFO_ERROR_7:uint = 507;
		
		public static const VINFO_ERROR_8:uint = 508;
		
		public static const VINFO_ERROR_9:uint = 509;
		
		public static const VINFO_ERROR_10:uint = 510;
		
		public static const VINFO_ERROR_12:uint = 512;
		
		public static const VINFO_ERROR_1:uint = 505;
		
		public static const VINFO_ERROR_FORBID:uint = 504;
		
		public static const CDN_ERROR_NETCONNECTION:uint = 600;
		
		public static const CDN_ERROR_NCFAILED:uint = 601;
		
		public static const CDN_ERROR_NOTFOUND:uint = 800;
		
		public static const VINFO_ERROR_13:uint = 901;
		
		public static const GSLB_ERROR_FAILED:uint = 700;
		
		public static const GSLB_ERROR_TIMEOUT:uint = 701;
		
		public static const CDN_ERROR_FAILED:uint = 802;
		
		public static const CDN_ERROR_TIMEOUT:uint = 801;
		
		public static const CDN_ERROR_FILESTRUCTUREINVALID:uint = 803;
		
		public static var allErrNo:uint = 0;
		
		public static var all700ErrNo:uint = 0;
		
		public static const REALVV_CODE:uint = 11;
		
		public static const ADINFO_ERROR_FAILED:uint = 1100;
		
		public static const ADINFO_ERROR_TIMEOUT:uint = 1101;
		
		public static const ADINFO_ERROR_OTHER:uint = 1102;
		
		public static const ADINFO_PARSE_ERROR:uint = 1103;
		
		public static const ADINFO_PB2_ERROR:uint = 1104;
		
		public static var sendRealVV:Boolean = false;
		
		public static var startAdTime:uint = 0;
		
		public static var startAdLoadTime:uint = 0;
		
		public static var startAdPlayTime:uint = 0;
		
		public static var skinLoadTime:uint = 0;
		
		public static var videoDownloadTime:uint = 0;
		
		public static var startAdPath:String = "";
		
		public static var startAdStat:String = "";
		
		public static var startAdUrl:String = "";
		
		public static var startAdTimeOut:uint = 20;
		
		public static var logoAdPath:String = "";
		
		public static var logoAdStat:String = "";
		
		public static var logoAdUrl:String = "";
		
		public static var pauseAdPath:String = "";
		
		public static var pauseAdStat:String = "";
		
		public static var pauseAdUrl:String = "";
		
		public static var endAdPath:String = "";
		
		public static var endAdStat:String = "";
		
		public static var endAdUrl:String = "";
		
		public static var topAdPath:String = "";
		
		public static var topAdStat:String = "";
		
		public static var topAdUrl:String = "";
		
		public static var bottomAdPath:String = "";
		
		public static var bottomAdStat:String = "";
		
		public static var bottomAdUrl:String = "";
		
		public static var ctrlBarAdPath:String = "";
		
		public static var ctrlBarAdStat:String = "";
		
		public static var ctrlBarAdUrl:String = "";
		
		public static var isNewsLogo:Boolean = false;
		
		public static var tag:String = "";
		
		public static var keyWord:String = "";
		
		public static var isVipUser:Boolean = false;
		
		public static var plcatid:String = "";
		
		public static var isHotOrMy:Boolean = true;
		
		public static var catcode:String = "";
		
		public static var onBufferEmpty:String = "";
		
		public static var topBarNor:Boolean = false;
		
		public static var topBarFull:Boolean = false;
		
		public static var myTvRotate:int = 0;
		
		public static var myTvDefinition:String = "";
		
		public static var isPartner:Boolean;
		
		public static var isListPlay:Boolean = true;
		
		public static var isShowTanmu:Boolean = false;
		
		public static var showLangSetBtn:Boolean = false;
		
		public static var mainActorId:String = "";
		
		public static var age:String = "";
		
		public static var act:String = "";
		
		public static var areaId:int = 0;
		
		public static var year:int = 0;
		
		public static var landingrefer:String = "";
		
		public static var isAlbumVideo:Boolean = false;
		
		public static var isKTVVideo:Boolean = false;
		
		public static var ktvId:String = "";
		
		public static var photoUrlsArr:Array;
		
		public static var pvpic:Object;
		
		public static var isPreviewPic:Boolean = false;
		
		public static var lb:String = "";
		
		public static var plid:String = "";
		
		public static var pub_catecode:String = "";
		
		public static var ch_key:String = "";
		
		public static var ta_jm:String = "";
		
		public static var advolume:Object = null;
		
		public static var ifoxInfoObj:Object;
		
		public static var atype:String = "";
		
		public static var yyid:String = "";
		
		public static var tvid:String = "-1";
		
		public static var hotVrSyst:String = "";
		
		public static var isLpc:Boolean = false;
		
		public static var mergeid:String = "";
		
		public static var tvFileIds:Array;
		
		public static var onlyusep2p:int = -1;
		
		public static var currentCore:String = "";
		
		public static var availableStvd:Boolean = false;
		
		public static var stvdInUse:Boolean = false;
		
		public static var isThrottle:Boolean = false;
		
		public static var recordSvdMode:int = -1;
		
		public static var isSendPID:Boolean = false;
		
		public static var cueTipEpInfo:Array;
		
		public static var lastReferer:String = "";
		
		public static var txid:String = "";
		
		public static var clientWidth:Number = 0;
		
		public static var clientHeight:Number = 0;
		
		public static var lqd:String = "";
		
		public static var lcode:String = "";
		
		public static var adMd:String = "";
		
		public static var cdnMd:String = "";
		
		public static var dmMd:String = "";
		
		public static var qsMd:String = "";
		
		public static var voteId:String = "";
		
		public static var voteRegion:String = "";
		
		public static var ILLEGALMSG:String = "0";
		
		public static var hotVrsSpend:Number = 0;
		
		public static var adinfoSpend:Number = -1;
		
		public static var adgetSpend:Number = -1;
		
		public static var allotSpend:Number = 0;
		
		public static var cdngetSpend:Number = 0;
		
		public static var allotip:String = "";
		
		public static var jsgetSpend:Number = 0;
		
		public static var playerSpend:Number = 0;
		
		public static var cdnInfoSendQs:String = "";
		
		public static var uvrInfo:Object;
		
		public static var crid:Number = 0;
		
		public static var authorId:String = "";
		
		public static var ugu:String = "";
		
		public static var ugcode:String = "";
		
		public static var isWmVideo:Boolean = false;
		
		public static var wmDataInfo:Object;
		
		public static var visitorId:String = "";
		
		public static var ifplu:String = "";
		
		public static var sohuCientVersion:String = "";
		
		public static var bfd:Array;
		
		public static var isai:String = "";
		
		public static var wm_user:String = "";
		
		public static var fc_user:String = "";
		
		public static var isHideTip:Boolean = false;
		
		public static var stype:String = "";
		
		public static var wm_filing:String = "";
		
		public static var showPgcModule:Boolean = true;
		
		public static function drawCloseBtn(param1:Number, param2:uint, param3:uint) : Sprite {
			var _loc4_:Number = int(param1 / 5);
			var _loc5_:Number = param1 / 2;
			var _loc6_:Number = _loc5_;
			var _loc7_:int = int(param1 / 5);
			var _loc8_:Sprite = new Sprite();
			var _loc9_:TextField = new TextField();
			var _loc10_:TextFormat = new TextFormat();
			_loc10_.color = param3;
			_loc10_.size = 12;
			_loc9_.autoSize = TextFieldAutoSize.LEFT;
			_loc9_.defaultTextFormat = _loc10_;
			_loc9_.selectable = false;
			_loc9_.text = "关闭";
			var _loc11_:Sprite = new Sprite();
			_loc11_.graphics.beginFill(param2,0.8);
			_loc11_.graphics.drawCircle(_loc6_,_loc6_,_loc5_);
			_loc11_.graphics.endFill();
			_loc11_.graphics.lineStyle(_loc4_,param3,1,false,"normal",CapsStyle.NONE);
			_loc11_.graphics.moveTo(_loc7_,_loc7_);
			_loc11_.graphics.lineTo(param1 - _loc7_,param1 - _loc7_);
			_loc11_.graphics.moveTo(_loc7_,param1 - _loc7_);
			_loc11_.graphics.lineTo(param1 - _loc7_,_loc7_);
			_loc8_.addChild(_loc9_);
			_loc8_.addChild(_loc11_);
			_loc11_.x = _loc9_.width + 1;
			_loc11_.y = (_loc8_.height - _loc11_.height) / 2;
			_loc8_.graphics.beginFill(4473924,0.5);
			_loc8_.graphics.drawRect(0,0,_loc8_.width,_loc8_.height);
			_loc8_.graphics.endFill();
			return _loc8_;
		}
	}
}
