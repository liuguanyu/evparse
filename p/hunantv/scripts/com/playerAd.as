package com
{
   import com.utl.helpMethods;
   import flash.display.*;
   import flash.ui.*;
   import flash.events.*;
   import flash.media.*;
   import flash.text.*;
   import flash.net.*;
   import flash.utils.*;
   import com.utl.timeInfo;
   import com.utl.msgTipData;
   import flash.external.ExternalInterface;
   import com.utl.consolelog;
   import flash.system.LoaderContext;
   
   public class playerAd extends Sprite
   {
      
      var adpanel:MovieClip = null;
      
      var loader:Loader;
      
      var loaderinfo:LoaderInfo;
      
      public var AdPlugin:MovieClip = null;
      
      var bloader:Loader;
      
      var bloaderinfo:LoaderInfo;
      
      var bAdPlugin:MovieClip;
      
      var adCpId:String = "none";
      
      var adCpType:String = "vid";
      
      var adSwfUrl:String = "";
      
      var Billboard:Array;
      
      var aid:String = "";
      
      var linkUrl:String = "";
      
      var tagStr:String = "";
      
      var configPars:String = "";
      
      var isStart:Boolean = true;
      
      var showFlag:int = 1;
      
      var playAction:String = "1";
      
      var adLoadTimerTick:Number;
      
      var AdTimerTick:Number;
      
      var adLoadTime:Number = 0;
      
      var PauseAdWidth:Number = 588;
      
      var PauseAdHeight:Number = 425;
      
      var isHaveLoadMcData:Boolean = false;
      
      var videoStreamLoadFlag:Boolean = false;
      
      var videoplayFlag:Boolean = false;
      
      var adPluginLoaded:Boolean = false;
      
      var adretObj:Object;
      
      var pflg = true;
      
      var mADTime:int = 60;
      
      public var parmObj:parmParse = null;
      
      public var skinswf:String = null;
      
      private var ad_player_already:Boolean = false;
      
      var mFirst:Boolean = true;
      
      public function playerAd(param1:MovieClip, param2:parmParse)
      {
         this.Billboard = new Array();
         this.adretObj = new Object();
         super();
         this.adpanel = param1;
         this.adretObj.type = "1";
         this.parmObj = param2;
         if(stage)
         {
            this.initF(null);
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,this.initF);
         }
      }
      
      public function initF(param1:Event) : *
      {
         helpMethods.addMutiEventListener(stage,this.dealmsg,playerEvents.AD_BACK_COMPLETE,playerEvents.PLAYCORE_COMPLETE,playerEvents.CONTORL_START,playerEvents.CONTORL_PAUSE,playerEvents.STREAM_TIME,playerEvents.PLAYCORE_SEEKEND,playerEvents.BITSET_CHANGE_OK);
         helpMethods.addMutiEventListener(stage,this.rsz,Event.RESIZE);
         stage.addEventListener(FullScreenEvent.FULL_SCREEN,this.OnFullScreenEvent);
      }
      
      function rsz(param1:Event) : *
      {
         try
         {
            this.AdPlugin.setAreaSize(stage.stageWidth,stage.stageHeight);
         }
         catch(ex:*)
         {
         }
      }
      
      private function OnFullScreenEvent(param1:FullScreenEvent) : *
      {
         if(param1.fullScreen == false)
         {
            this.AdPlay("7");
         }
         else if(param1.fullScreen == true)
         {
            this.AdPlay("6");
         }
         
      }
      
      function dealmsg(param1:playerEvents) : *
      {
         var _loc2_:timeInfo = null;
         switch(param1.type)
         {
            case playerEvents.AD_BACK_COMPLETE:
               this.AdPlay("3");
               break;
            case playerEvents.CONTORL_PAUSE:
               if(!this.AdPlay("2"))
               {
                  this.sendMsg(playerEvents.PAUSE_ANIM_SHOW,null);
               }
               break;
            case playerEvents.CONTORL_START:
               this.AdPlay("1");
               break;
            case playerEvents.PLAYCORE_SEEKEND:
               this.AdPlay("1");
               break;
            case playerEvents.BITSET_CHANGE_OK:
               this.AdPlay("1");
               break;
            case playerEvents.STREAM_TIME:
               _loc2_ = new timeInfo();
               _loc2_ = param1.data as timeInfo;
               this.AdPlayingTimeTick(_loc2_.streamtime);
               break;
         }
      }
      
      private function sendMsg(param1:String, param2:Object) : *
      {
         dispatchEvent(new playerEvents(param1,param2,true,false));
      }
      
      private function noAdOrOver(param1:int = 0) : *
      {
         clearInterval(this.adLoadTimerTick);
         this.sendMsg(playerEvents.AD_OVER,param1);
         this.sendMsg(playerEvents.MSG_SHOW,new msgTipData("",false,false));
      }
      
      public function init() : *
      {
         var _loc1_:XML = null;
         this.sendMsg(playerEvents.AD_START,0);
         this.sendMsg(playerEvents.MSG_SHOW,new msgTipData("加载广告....",true,false));
         try
         {
            if(ExternalInterface.available)
            {
               this.configPars = helpMethods.callPageJs("getAdConfig");
            }
            if(this.configPars == "" || this.configPars == null)
            {
               this.configPars = "<config cpid=\"2\" surl=\"http://res.hunantv.com/FrameWork/AFP/ASP_vastWH0325.swf\" skin=\"http://res.hunantv.com/FrameWork/AFP/skin_jinying.swf\" linkurl=\"\" aid=\"4388\" billboard=\"1,1,1,1,1,1\" atag=\"\" type=\"swf\" />";
            }
            if(parmParse.DEBUG)
            {
               this.configPars = "";
            }
            trace("configPars:" + this.configPars);
            consolelog.log("configPars:" + this.configPars);
            try
            {
               if(this.parmObj.mMovieInfo != null)
               {
                  if(this.parmObj.mMovieInfo.data.user.isvip == "1")
                  {
                     this.configPars = "";
                  }
               }
            }
            catch(e:*)
            {
            }
            if(this.parmObj.mBaiduVIPUser)
            {
               this.configPars = "";
            }
            if(this.configPars != "")
            {
               _loc1_ = new XML(this.configPars);
               this.adCpId = _loc1_.attribute("cpid").toString();
               this.adCpType = _loc1_.attribute("type").toString();
               this.tagStr = _loc1_.attribute("atag").toString();
               this.skinswf = _loc1_.attribute("skin").toString();
               this.adSwfUrl = _loc1_.attribute("surl").toString();
               this.Billboard = _loc1_.attribute("billboard").toString().split(",");
               this.aid = _loc1_.attribute("aid").toString();
            }
         }
         catch(e:*)
         {
         }
         if(this.adSwfUrl != "")
         {
            this.mcAdLoadInit();
         }
         else
         {
            trace("noAdOrOver(1)");
            consolelog.log("noAdOrOver(1)");
            this.noAdOrOver(1);
         }
      }
      
      function mcAdLoadInit() : *
      {
         this.sendMsg(playerEvents.MSG_SHOW,new msgTipData("广告加载中，请稍候....",true,false));
         var _loc1_:* = new URLRequest(this.adSwfUrl);
         trace("mcRequest url:" + this.adSwfUrl);
         consolelog.log("mcRequest url:" + this.adSwfUrl);
         var _loc2_:LoaderContext = new LoaderContext(false);
         this.loader = new Loader();
         this.loaderinfo = this.loader.loaderInfo;
         this.loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.admcLoading);
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.admcLoaded);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.admcLoadedError);
         this.loader.load(_loc1_,_loc2_);
         this.adLoadTimerTick = setInterval(this.check_initad_load,1000);
      }
      
      function check_initad_load() : *
      {
         this.adLoadTime++;
      }
      
      function AdPlayingTimeTick(param1:Number) : void
      {
         if(this.adPluginLoaded)
         {
            try
            {
               this.AdPlugin.playLine(param1);
            }
            catch(e:*)
            {
            }
         }
      }
      
      function admcLoading(param1:ProgressEvent) : *
      {
         consolelog.log("admcLoading");
      }
      
      function admcLoadedError(param1:IOErrorEvent) : *
      {
         consolelog.log("admcLoadedError");
         this.noAdOrOver(1);
      }
      
      function admcLoaded(param1:Event) : *
      {
         this.adPluginLoaded = true;
         this.AdPlugin = this.loader.content as MovieClip;
         if(!this.isHaveLoadMcData && !(this.AdPlugin == null))
         {
            this.adpanel.addChild(this.AdPlugin);
            this.isHaveLoadMcData = true;
         }
         try
         {
            if(this.adCpId == "2")
            {
               this.init_ad_events();
            }
            else if(this.adCpId == "1" && (ExternalInterface.available))
            {
               helpMethods.callPageJs("adLoadComplete");
            }
            
         }
         catch(e:*)
         {
         }
      }
      
      function bnadmcLoading(param1:ProgressEvent) : *
      {
      }
      
      function bnadmcLoadedError(param1:IOErrorEvent) : *
      {
      }
      
      function bnadmcLoaded(param1:Event) : *
      {
         this.bAdPlugin = this.bloader.content as MovieClip;
      }
      
      private function ad_returnFun(param1:Object) : void
      {
         this.adretObj = param1;
      }
      
      private function ad_load_complete(param1:*) : *
      {
      }
      
      private function init_ad_events() : *
      {
         var whstr:String = null;
         try
         {
            this.AdPlugin.addEventListener("load_complete",this.ad_load_complete);
            this.AdPlugin.addEventListener("pause",this.ad_play_begin2);
            this.AdPlugin.addEventListener("play",this.ad_play_completed2);
            this.AdPlugin.addEventListener("AD_CLICK",this.OnADClickEvent);
            this.AdPlugin.returnData(this.ad_returnFun);
            whstr = this.adpanel.stage.stageWidth + "," + this.adpanel.stage.stageHeight;
            this.AdPlugin.initPlayerData({
               "allowAd":this.Billboard,
               "mutePos":2,
               "skin":this.skinswf,
               "serverURL":"http://bs.da.hunantv.com/"
            });
            this.AdPlugin.initAdData({
               "playerId":this.aid,
               "ctid":this.parmObj.video_id,
               "keyWords":this.tagStr,
               "wh":whstr,
               "playerFrameRate":28,
               "adAllowShowTime":this.mADTime,
               "videoTotalTime":this.parmObj.mVideoDuration,
               "backPreLoadTime":10
            });
            if(this.Billboard.length > 0 && this.Billboard[0] == "0")
            {
               this.noAdOrOver();
            }
         }
         catch(e:*)
         {
            noAdOrOver();
         }
      }
      
      public function AdPlay(param1:String) : Boolean
      {
         var typeid:String = param1;
         var ret:Boolean = false;
         try
         {
            this.playAction = typeid;
            this.AdPlugin.playAction(parseInt(this.playAction),{
               "adAreaWidth":this.adpanel.stage.stageWidth,
               "adAreaHeight":this.adpanel.stage.stageHeight
            });
            ret = true;
         }
         catch(e:*)
         {
            ret = false;
         }
         return ret;
      }
      
      private function ad_play_begin2(param1:*) : *
      {
         var _loc2_:Object = null;
         trace("ad_play_begin2 adretObj.type:" + this.adretObj.type.toString());
         consolelog.log("ad_play_begin2 adretObj.type:" + this.adretObj.type.toString());
         if(!this.ad_player_already)
         {
            _loc2_ = new Object();
            _loc2_.adid = this.aid;
            _loc2_.adtms = "";
            dispatchEvent(new playerEvents(playerEvents.STATISTICS_BIGDATA_ADBEGIN,_loc2_));
            this.ad_player_already = true;
         }
         if(this.mFirst)
         {
            helpMethods.ITweening(this.AdPlugin,"alpha",0,1,0.5);
            setTimeout(this.mAlphaOver,500);
            this.mFirst = false;
         }
         this.adpanel.visible = true;
         switch(this.adretObj.type.toString())
         {
            case "1":
               this.sendMsg(playerEvents.AD_START,int(this.adretObj.type));
               this.sendMsg(playerEvents.MSG_SHOW,new msgTipData("温馨提示：广告时间，请稍候...",true,false));
               break;
            case "2":
               this.sendMsg(playerEvents.AD_START,int(this.adretObj.type));
               this.sendMsg(playerEvents.MSG_SHOW,new msgTipData("温馨提示：广告时间，请稍候...",true,false));
               break;
            case "3":
               this.sendMsg(playerEvents.AD_START,int(this.adretObj.type));
               this.sendMsg(playerEvents.MSG_SHOW,new msgTipData("温馨提示：广告时间，请稍候...",true,false));
               break;
         }
      }
      
      private function mAlphaOver() : *
      {
         this.AdPlugin.alpha = 1;
      }
      
      private function ad_play_completed2(param1:*) : *
      {
         var _loc2_:Object = null;
         trace("ad_play_completed2 adretObj.type:" + this.adretObj.type.toString());
         consolelog.log("ad_play_completed2 adretObj.type:" + this.adretObj.type.toString());
         trace("adLoadTime:" + this.adLoadTime);
         if(this.ad_player_already)
         {
            this.ad_player_already = false;
            _loc2_ = new Object();
            _loc2_.adid = this.aid;
            _loc2_.adtms = this.adLoadTime * 1000;
            dispatchEvent(new playerEvents(playerEvents.STATISTICS_BIGDATA_ADEND,_loc2_));
         }
         this.mFirst = true;
         switch(this.adretObj.type.toString())
         {
            case "1":
               this.noAdOrOver(this.adretObj.type);
               this.sendMsg(playerEvents.MSG_SHOW,new msgTipData("广告结束",false,false));
               break;
            case "2":
               this.noAdOrOver(this.adretObj.type);
               this.sendMsg(playerEvents.MSG_SHOW,new msgTipData("广告结束",false,false));
               break;
            case "3":
               this.noAdOrOver(this.adretObj.type);
               this.sendMsg(playerEvents.MSG_SHOW,new msgTipData("广告结束",false,false));
               dispatchEvent(new playerEvents(playerEvents.PLAYCORE_COMPLETE));
               break;
         }
      }
      
      private function OnADClickEvent(param1:*) : *
      {
         if(stage.displayState != StageDisplayState.NORMAL)
         {
            stage.displayState = StageDisplayState.NORMAL;
         }
      }
   }
}
