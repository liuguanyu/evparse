package cn.pplive.player.common
{
   import cn.pplive.player.utils.AS3Cookie;
   
   public class VodCommon extends Object
   {
      
      public static var version:String = "3.4.0.12";
      
      public static var liveVS:String = "1.1.0.31";
      
      public static var pid:String;
      
      public static var clid:String = null;
      
      public static var title:String = null;
      
      public static var link:String = null;
      
      public static var swf:String = null;
      
      public static var barrageDisplay:Boolean = false;
      
      public static var isMetadata:Boolean = false;
      
      public static var isPatch:Boolean = false;
      
      public static var playstate:String = "paused";
      
      public static var allowInteractive:String = "always";
      
      public static var allowScreenClick:String = "all";
      
      public static var playType:String = "web.fpp";
      
      public static var playStr:String;
      
      public static var pl:String;
      
      public static var puid:String = null;
      
      public static var mkey:String = null;
      
      public static var currRid:String = null;
      
      public static var playerWidth:Number;
      
      public static var playerHeight:Number;
      
      public static var smart:String;
      
      public static var priplay:String;
      
      public static var isEmpty:Boolean = true;
      
      public static var isSkipPrelude:Boolean = true;
      
      public static var aheadCount:int = 0;
      
      public static var cookie:AS3Cookie = null;
      
      public static var isHttpRequest:Boolean = true;
      
      public static var row:Number = 10;
      
      public static var column:Number = 10;
      
      public static var snapshotHeight:Number = 720;
      
      public static var snapshotVersion:Number;
      
      public static var preSnapshot:Vector.<Object>;
      
      public static var volume:Number = 50;
      
      public static var isSVavailable:Boolean;
      
      public static var isSV:Boolean;
      
      public static var hardwareDecoding:Boolean;
      
      public static var hardwareEncoding:Boolean;
      
      public static var isTheatre:Boolean = false;
      
      public static var isPPAP:Boolean = false;
      
      public static var purl:String = "http://download.pplive.com/config/pplite/superplugin.exe";
      
      public static var cline_add:String = "http://download.pplive.com/pptv/self/PPTV(pplive)_guide_forqd1_pause.exe";
      
      public static var initErrorText:String = "播放器初始化数据错误，请刷新后重试";
      
      public static var playErrorText:String = "非常抱歉，我们暂无此视频资源<br>【%code%】";
      
      public static var playSkipStartText:String = "已经为您跳过片头";
      
      public static var playSkipEndText:String = "已经为您设置了跳过片尾，视频即将结束";
      
      public static var playVipTipTexT:String = "请 <a href=\"event:vip\">开通VIP会员</a> 播放此视频";
      
      public static var playPayText:String = "<a href=\"http://pay.ddp.vip.pptv.com/?id=[CID]&type=0&aid=vod_detail_play\" target=\"_self\">立即购买</a>观看完整版";
      
      public static var playSmoothText:String = "当前播放不流畅，可选择下载<a href=\"" + cline_add + "\"> 客户端 </a>观看";
      
      public static var playPayFreeText:String = "当前正在播放免费试看，" + playPayText;
      
      public static var playPayNoFreeText:String = "当前付费节目，请" + playPayText;
      
      public static var playPayFreeEndText:String = "当前免费试看已经结束，请" + playPayText;
      
      public static var installPPAPText:String = "请安装 <a href=\"" + purl + "\">PP插件</a> 观看更清晰节目";
      
      public static var VersionText:String = "您当前的Flash播放器版本过低，请下载Flash Player10.2及其以上版本。<br>下载完毕后请重新刷新页面播放。<br>下载地址：<a href=\"https://get.adobe.com/flashplayer/\" target=\"_blank\"><b>https://get.adobe.com/flashplayer/</b></a>";
      
      public static var callCode:Object = {
         "config":["1000","1001-error","1002-security","1003-timeout"],
         "play":["2000","2001-error","2002-security","2003-timeout","2004-nodt","2005","2006-nochannel","2007","2008-rb"],
         "video":["3000","3001-error","3002-security","3003-timeout","3004-mandatory ppap","3005-switch stream ppap","3006","3007","3008"]
      };
      
      public function VodCommon()
      {
         super();
      }
   }
}
