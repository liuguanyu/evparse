package
{
   import com.control.controlBar;
   import com.gridsum.VideoTracker.VodPlay;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.external.ExternalInterface;
   import flash.system.Capabilities;
   import com.gridsum.VideoTracker.VideoTracker;
   import com.gridsum.VideoTracker.VideoInfo;
   import com.gs.NetStreamVodInfoProvider;
   import com.cgi.vodPost;
   import com.statistics.comscore.comScore;
   import com.statistics.bigdata.BigData;
   import com.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   import com.utl.*;
   import flash.net.*;
   import flash.text.*;
   import flash.system.Security;
   
   public dynamic class imgotv extends MovieClip
   {
      
      public var bg:MovieClip;
      
      public var tip_label:TextField;
      
      public var tip_label_feedback:TextField;
      
      var logoObj:MovieClip;
      
      public var infoObj:TextField = null;
      
      public var parmObj:parmParse;
      
      public var playerCoreObj:playerCoreGs = null;
      
      var skinObj:Skinloader = null;
      
      public var contorlBarObj:controlBar = null;
      
      public var playAd:playerAd = null;
      
      var adpanel:MovieClip = null;
      
      private var movie_bg:MovieClip = null;
      
      public var mVodPlay:VodPlay = null;
      
      var voddataPost:vodPost = null;
      
      var mComScore:comScore = null;
      
      var mBigData:BigData = null;
      
      public function imgotv()
      {
         super();
         Security.allowDomain("*");
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.align = StageAlign.TOP_LEFT;
         stage.addEventListener(Event.RESIZE,this.resz);
         this.tip_label.visible = false;
         this.tip_label_feedback.visible = false;
         this.SetFontByOS();
         parmParse.TFormat.font = parmParse.FONT_FACE;
         this.SetPlayerVersion();
         this.setLogo();
         setTimeout(this.startup,2000);
      }
      
      private function SetPlayerVersion() : *
      {
         var _loc1_:ContextMenu = new ContextMenu();
         _loc1_.hideBuiltInItems();
         _loc1_.customItems.push(new ContextMenuItem(parmParse.VERSION + " with p2p gridsum",true));
         this.contextMenu = _loc1_;
      }
      
      private function SetFontByOS() : *
      {
         var uaInfo:String = null;
         try
         {
            if(ExternalInterface.available)
            {
               uaInfo = ExternalInterface.call("function BrowserAgent(){return navigator.userAgent;}");
               if(uaInfo.indexOf("Macintosh") != -1)
               {
                  parmParse.FONT_FACE = "";
               }
               else
               {
                  this.IsWinChrome();
               }
            }
         }
         catch(e:*)
         {
            IsWinChrome();
         }
      }
      
      private function IsWinChrome() : *
      {
         if(Capabilities.manufacturer == "Google Pepper")
         {
            parmParse.FONT_FACE = "微软雅黑";
         }
         else
         {
            parmParse.FONT_FACE = "Microsoft YaHei";
         }
      }
      
      function startup() : *
      {
         this.parmObj = new parmParse();
         addChild(this.parmObj);
         helpMethods.addMutiEventListener(this.parmObj,this.PostMsg,playerEvents.PARMS_READY,playerEvents.PARMS_ERROR,playerEvents.BITSET_CHANGE_OK,playerEvents.IP_LEGAL,playerEvents.IP_LEAGL_ERROR,playerEvents.PAID_MOVIE_BG,playerEvents.TV_ERROR,playerEvents.STATION_OUTSIDE_VIP);
         stage.addEventListener(playerEvents.P2P_READY,this.PostMsg);
         stage.addEventListener(playerEvents.P2P_ERROR,this.PostMsg);
         this.parmObj.Init();
         this.Statistics();
      }
      
      private function VideoTrackerInit() : *
      {
         var _loc1_:VideoTracker = VideoTracker.getInstance("GVD-200050","GSD-200050");
         var _loc2_:VideoInfo = new VideoInfo(this.parmObj.video_id);
         VideoTracker.setSamplingRate(parmParse.VTSAMPLINGRATE);
         var _loc3_:NetStreamVodInfoProvider = new NetStreamVodInfoProvider(null);
         this.mVodPlay = _loc1_.newVodPlay(_loc2_,_loc3_);
      }
      
      private function Statistics() : *
      {
         this.mComScore = new comScore();
         addChild(this.mComScore);
         this.mComScore.Init();
         this.mBigData = new BigData(this.parmObj);
         addChild(this.mBigData);
         this.mBigData.Init();
      }
      
      function loadSkin() : *
      {
         this.skinObj = new Skinloader(this.parmObj,this);
         helpMethods.addMutiEventListener(this.skinObj,this.PostMsg,playerEvents.SKIN_LOADED,playerEvents.SKIN_ERROR,playerEvents.SKIN_PROGRESS);
      }
      
      function loadContrlUI() : *
      {
         if(this.contorlBarObj == null)
         {
            this.contorlBarObj = new controlBar(this.skinObj,this.parmObj);
            addChild(this.contorlBarObj);
            this.contorlBarObj.addcontrolBarBgMc();
            helpMethods.addMutiEventListener(this.contorlBarObj,this.PostMsg,playerEvents.BITSET_CHANGE,playerEvents.CONTORL_SIZE);
         }
      }
      
      function loadPalyerCore() : *
      {
         if(this.playerCoreObj == null)
         {
            this.playerCoreObj = new playerCoreGs(this.parmObj,this.contorlBarObj.dispanPanel,this);
            addChild(this.playerCoreObj);
            helpMethods.addMutiEventListener(this.playerCoreObj,this.PostMsg,playerEvents.META_READY,playerEvents.PLAYCORE_COMPLETE);
         }
         try
         {
            if(ExternalInterface.available)
            {
               helpMethods.addPageJsCall("PageClose",this.PageClose);
            }
         }
         catch(e:*)
         {
         }
      }
      
      public function PageClose() : *
      {
         this.playerCoreObj.CDNOffline();
      }
      
      function loadAd() : *
      {
         if(this.playAd == null)
         {
            if(this.parmObj.isPlayAd == "1")
            {
               this.playAd = new playerAd(this.contorlBarObj.adpanel,this.parmObj);
               addChild(this.playAd);
               helpMethods.addMutiEventListener(this.playAd,this.PostMsg,playerEvents.AD_START,playerEvents.AD_OVER,playerEvents.PLAYCORE_COMPLETE);
               this.playAd.init();
            }
         }
      }
      
      private function adStop(param1:Event) : *
      {
         dispatchEvent(new playerEvents(playerEvents.CONTORL_PAUSE));
      }
      
      private function adPlay(param1:Event) : *
      {
         dispatchEvent(new playerEvents(playerEvents.CONTORL_START));
      }
      
      function PostMsg(param1:playerEvents) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:Object = null;
         var _loc5_:* = 0;
         trace("e.type:" + param1.type);
         consolelog.log("PostMsg e.type:" + param1.type);
         switch(param1.type)
         {
            case playerEvents.TV_ERROR:
               _loc2_ = param1.data as String;
               if(this.mVodPlay == null)
               {
                  this.VideoTrackerInit();
               }
               this.mVodPlay.onError(_loc2_);
               break;
            case playerEvents.PAID_MOVIE_BG:
               this.LoadMovieBG();
               break;
            case playerEvents.STATION_OUTSIDE_VIP:
               this.removeLogo();
               _loc3_ = param1.data as String;
               this.tip_label.visible = false;
               this.tip_label_feedback.htmlText = "<font color=\'#ffffff\' face=\'" + parmParse.FONT_FACE + "\' size=\'16\'>该影片仅限于芒果TV站内播放，请前往 </font><font color=\'#f05f00\' face=\'" + parmParse.FONT_FACE + "\' size=\'16\'><a href=\'" + _loc3_ + "\' target=\'_blank\'><u>芒果TV</u></a></font><font color=\'#ffffff\' face=\'" + parmParse.FONT_FACE + "\' size=\'16\'> 观看</font>";
               this.tip_label_feedback.x = stage.stageWidth / 2 - this.tip_label_feedback.width / 2;
               this.tip_label_feedback.y = stage.stageHeight / 2 - 21;
               this.tip_label_feedback.visible = true;
               break;
            case playerEvents.IP_LEAGL_ERROR:
               this.removeLogo();
               this.tip_label.visible = false;
               this.tip_label_feedback.htmlText = "<font color=\'#ffffff\' face=\'" + parmParse.FONT_FACE + "\' size=\'16\'>网络异常，请刷新页面重试或 </font><font color=\'#f05f00\' face=\'" + parmParse.FONT_FACE + "\' size=\'16\'><a href=\'http://i.hunantv.com/feedback.html\' target=\'_blank\'><u>反馈</u></a></font><font color=\'#ffffff\' face=\'" + parmParse.FONT_FACE + "\' size=\'16\'> 客服</font>";
               this.tip_label_feedback.x = stage.stageWidth / 2 - this.tip_label_feedback.width / 2;
               this.tip_label_feedback.y = stage.stageHeight / 2 - 21;
               this.tip_label_feedback.visible = true;
               break;
            case playerEvents.IP_LEGAL:
               this.removeLogo();
               _loc4_ = param1.data as Object;
               helpMethods.SetLabelTextFormat(this.tip_label,_loc4_.mongoMsg);
               this.tip_label.x = stage.stageWidth / 2 - this.tip_label.width / 2;
               this.tip_label.y = stage.stageHeight / 2 - 50;
               this.tip_label.visible = true;
               this.tip_label_feedback.htmlText = "<font color=\'#ffffff\' face=\'" + parmParse.FONT_FACE + "\' size=\'16\'>如您在中国大陆地区观看视频出现受限提示，请向我们 </font><font color=\'#f05f00\' face=\'" + parmParse.FONT_FACE + "\' size=\'16\'><a href=\'http://i.hunantv.com/feedback.html\' target=\'_blank\'><u>反馈</u></a></font>";
               this.tip_label_feedback.x = stage.stageWidth / 2 - this.tip_label_feedback.width / 2;
               this.tip_label_feedback.y = stage.stageHeight / 2 - 21;
               this.tip_label_feedback.visible = true;
               break;
            case playerEvents.PARMS_READY:
               this.loadSkin();
               break;
            case playerEvents.PARMS_ERROR:
               helpMethods.SetLabelTextFormat(this.infoObj,"加载失败");
               break;
            case playerEvents.SKIN_PROGRESS:
               break;
            case playerEvents.SKIN_LOADED:
               this.loadContrlUI();
               this.loadPalyerCore();
               this.parmObj.MovieInfo();
               break;
            case playerEvents.BITSET_CHANGE_OK:
               this.parmObj.BroadcastPlayInfo();
               this.playerCoreObj.videoMeta.offsetType = this.parmObj.offsetType;
               this.playerCoreObj.connectHttpserverP2P(this.parmObj.HttpServerUrl);
               this.playerCoreObj.canSkipHead = true;
               break;
            case playerEvents.P2P_READY:
               this.playerCoreObj.connectHttpserverP2P(this.parmObj.HttpServerUrl);
               this.loadAd();
               break;
            case playerEvents.P2P_ERROR:
               this.playerCoreObj.connectHttpserverNoP2p(this.parmObj.HttpServerUrl);
               this.loadAd();
               break;
            case playerEvents.SKIN_ERROR:
               helpMethods.SetLabelTextFormat(this.infoObj,"皮肤装载错误");
               break;
            case playerEvents.META_READY:
               this.contorlBarObj.isCanDragSeek = true;
               this.contorlBarObj.reSizeDisPanel(this.playerCoreObj.videoMeta.videoRatio);
               break;
            case playerEvents.AD_START:
               _loc5_ = param1.data as int;
               trace("adStates:" + _loc5_);
               if(_loc5_ != 0)
               {
                  this.removeLogo();
               }
               break;
            case playerEvents.AD_OVER:
               this.removeLogo();
               break;
            case playerEvents.STREAM_TIME:
               break;
            case playerEvents.PLAYCORE_COMPLETE:
               if(!(this.parmObj.s_title == "") && !(this.parmObj.s_url == ""))
               {
                  stage.displayState = StageDisplayState.NORMAL;
                  navigateToURL(new URLRequest(this.parmObj.s_url),"_self");
               }
               else
               {
                  this.removeLogo();
               }
               break;
            case playerEvents.BITSET_CHANGE:
               this.parmObj.VideoSources(true);
               break;
            case playerEvents.CONTORL_SIZE:
               this.contorlBarObj.AspectRatio = param1.data as String;
               this.contorlBarObj.reSizeDisPanel(this.playerCoreObj.videoMeta.videoRatio,true);
               break;
         }
      }
      
      function sendMsg(param1:String, param2:Object) : *
      {
         dispatchEvent(new playerEvents(param1,param2,true,false));
      }
      
      function resz(param1:Event) : *
      {
         try
         {
            this.logoObj.x = stage.stageWidth / 2;
            this.logoObj.y = stage.stageHeight / 2;
            this.logoObj.height = stage.stageHeight;
            this.logoObj.width = stage.stageHeight * 1.777;
            this.bg.width = stage.stageWidth;
            this.bg.height = stage.stageHeight;
            if(this.contorlBarObj != null)
            {
               this.contorlBarObj.reSizeDisPanel(this.playerCoreObj.videoMeta.videoRatio);
            }
            this.tip_label.x = stage.stageWidth / 2 - this.tip_label.width / 2;
            this.tip_label.y = stage.stageHeight / 2 - 50;
            this.tip_label_feedback.x = stage.stageWidth / 2 - this.tip_label_feedback.width / 2;
            this.tip_label_feedback.y = stage.stageHeight / 2 - 21;
         }
         catch(ex:*)
         {
         }
      }
      
      function setLogo() : void
      {
         this.logoObj = new mlogo();
         this.logoObj.x = stage.stageWidth / 2;
         this.logoObj.y = stage.stageHeight / 2;
         this.logoObj.height = stage.stageHeight;
         this.logoObj.width = stage.stageHeight * 1.777;
         addChild(this.logoObj);
         this.bg.width = stage.stageWidth;
         this.bg.height = stage.stageHeight;
      }
      
      function removeLogo() : void
      {
         this.logoObj.visible = false;
         stage.frameRate = 36;
      }
      
      private function LoadMovieBG() : *
      {
         this.movie_bg = new mcMovieBG();
         this.movie_bg.x = stage.stageWidth / 2;
         this.movie_bg.y = stage.stageHeight / 2;
         this.movie_bg.width = stage.stageWidth;
         this.movie_bg.height = stage.stageHeight;
         addChild(this.movie_bg);
      }
   }
}
