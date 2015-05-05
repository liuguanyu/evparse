package com.control
{
   import com.Skinloader;
   import com.parmParse;
   import com.datasvc.setupSharedObject;
   import com.utl.helpMethods;
   import com.playerEvents;
   import com.utl.timeInfo;
   import flash.display.*;
   import flash.events.*;
   import fl.transitions.easing.*;
   import flash.media.*;
   import flash.utils.*;
   import com.gridsum.Debug.*;
   import com.utl.consolelog;
   
   public class controlBar extends MovieClip
   {
      
      public var playStatus:int = 1;
      
      var skinObj:Skinloader;
      
      var ctrlComponents:Array;
      
      public var dispanPanel:MovieClip;
      
      private var MainPanelWidget:MovieClip;
      
      var TotalBarMC:MovieClip;
      
      var TimeMC:MovieClip;
      
      var TimeTipMC:MovieClip;
      
      var PlayDragerMC:MovieClip;
      
      var SkipMarkMC:MovieClip;
      
      var SpliterMc:MovieClip;
      
      var photosharePan:MovieClip;
      
      var QualityBTN:MovieClip;
      
      var EnterFullscreenBTN:SimpleButton;
      
      var ExitFullscreenBTN:SimpleButton;
      
      var BigPlayBTN:SimpleButton;
      
      var PhotoShareBTN:SimpleButton;
      
      var PlaySetBTN:SimpleButton;
      
      var QualityPan:MovieClip;
      
      var SetPan:MovieClip;
      
      var hotclipPan:MovieClip;
      
      var VolumeBarMC:MovieClip = null;
      
      var VolumeIconMC:MovieClip;
      
      var VolumeIconNoneMC:MovieClip;
      
      var isVolumeSet:Boolean = false;
      
      public var volumeNumber:Number = 0.5;
      
      public var isHandSeek:Boolean = false;
      
      public var isCanDragSeek:Boolean = false;
      
      public var totalTime:Number = 1;
      
      var seekToTime:Number = 0;
      
      public var streamtime:Number = 0;
      
      public var AspectRatio:String = "默认";
      
      var parmObj:parmParse = null;
      
      public var adpanel:MovieClip = null;
      
      public var AVDadParent:MovieClip = null;
      
      public var msgtipBar:MovieClip = null;
      
      private var isDoubleClick:Boolean = true;
      
      private var mSearchEvent:Boolean = false;
      
      private var zoomRatio:Number = 1;
      
      private var dispanelOrginHeight:Number;
      
      private var dispanelOrginWidth:Number;
      
      private var isFullScreen:Boolean = false;
      
      private var SHAREOBJ_ZOOM_KEY:String = "SHAREOBJ_ZOOM_KEY";
      
      private var currentLevel:String = "1";
      
      private var shareObj:setupSharedObject;
      
      private var mOver:Boolean = false;
      
      public function controlBar(param1:Skinloader, param2:parmParse)
      {
         this.ctrlComponents = new Array();
         this.dispanPanel = new MovieClip();
         this.MainPanelWidget = new MovieClip();
         this.TotalBarMC = new MovieClip();
         this.TimeMC = new MovieClip();
         this.TimeTipMC = new MovieClip();
         this.PlayDragerMC = new MovieClip();
         this.SkipMarkMC = new MovieClip();
         this.SpliterMc = new MovieClip();
         this.photosharePan = new MovieClip();
         this.QualityBTN = new MovieClip();
         this.EnterFullscreenBTN = new SimpleButton();
         this.ExitFullscreenBTN = new SimpleButton();
         this.BigPlayBTN = new SimpleButton();
         this.PhotoShareBTN = new SimpleButton();
         this.PlaySetBTN = new SimpleButton();
         this.QualityPan = new MovieClip();
         this.SetPan = new MovieClip();
         this.hotclipPan = new MovieClip();
         this.VolumeIconMC = new MovieClip();
         this.VolumeIconNoneMC = new MovieClip();
         this.shareObj = new setupSharedObject();
         super();
         this.skinObj = param1;
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
      
      function initF(param1:Event) : *
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.initF);
         helpMethods.addMutiEventListener(stage,this.dealmsg,playerEvents.PLAYCORE_COMPLETE,playerEvents.VIDEO_REPLAY,playerEvents.AD_START,playerEvents.AD_OVER,playerEvents.CONTORL_PAUSE,playerEvents.CONTORL_START,playerEvents.CONTORL_RESTART,playerEvents.CONTORL_SEEKSTART,playerEvents.PLAYCORE_SEEKEND,playerEvents.CONTORL_SIZE,playerEvents.CONTORL_SKIP_HEADEND,playerEvents.SEARCH_EVENT,playerEvents.CONTORL_ZOOM,playerEvents.CONTORL_SET_ZOOM_BY_FULL_AND_WINDOWS_BTN);
         helpMethods.addMutiEventListener(stage,this.dealkeymsg,KeyboardEvent.KEY_DOWN,KeyboardEvent.KEY_UP);
         helpMethods.addMutiEventListener(stage,this.rollmsg,MouseEvent.MOUSE_OVER,MouseEvent.MOUSE_OUT);
         stage.addEventListener(Event.RESIZE,this.resz);
         stage.addEventListener(FullScreenEvent.FULL_SCREEN,this.fullScreenEvent);
         this.currentLevel = this.shareObj.getValue(this.SHAREOBJ_ZOOM_KEY);
         if(null != this.currentLevel)
         {
            this.zoomRatio = Number(this.currentLevel);
         }
      }
      
      function fullScreenEvent(param1:FullScreenEvent) : void
      {
         this.resz(null);
         if(param1.fullScreen == true)
         {
            return;
         }
         if(param1.fullScreen == false)
         {
            return;
         }
      }
      
      function resz(param1:Event) : *
      {
         if(parmParse.INSTATION)
         {
            if(stage.stageWidth <= 400 && stage.stageHeight <= 240)
            {
               this.MainPanelWidget.visible = false;
               parmParse.SMALL_WINDOW = true;
            }
            else
            {
               this.MainPanelWidget.visible = true;
               parmParse.SMALL_WINDOW = false;
            }
         }
      }
      
      function rollmsg(param1:MouseEvent) : *
      {
         if(param1.type == MouseEvent.MOUSE_OVER)
         {
            stage.dispatchEvent(new playerEvents(playerEvents.CONTORL_TOOLPAN_SHOW));
         }
         else if(param1.type == MouseEvent.MOUSE_OUT)
         {
            stage.dispatchEvent(new playerEvents(playerEvents.CONTORL_TOOLPAN_HIDE));
         }
         
      }
      
      function dealmsg(param1:playerEvents) : *
      {
         var _loc2_:timeInfo = null;
         switch(param1.type)
         {
            case playerEvents.STREAM_TIME:
               _loc2_ = new timeInfo();
               _loc2_ = param1.data as timeInfo;
               this.totalTime = _loc2_.totaltime;
               this.streamtime = _loc2_.streamtime;
               break;
            case playerEvents.VIDEO_REPLAY:
               this.playStatus = 1;
               this.mOver = false;
               helpMethods.callPageJs("clipStart","1");
               break;
            case playerEvents.PLAYCORE_COMPLETE:
               this.playStatus = 3;
               this.mOver = true;
               helpMethods.callPageJs("clipStart","0");
               break;
            case playerEvents.AD_START:
               this.dispanPanel.visible = false;
               this.playStatus = 4;
               break;
            case playerEvents.AD_OVER:
               this.dispanPanel.visible = true;
               this.playStatus = 5;
               if(!this.mOver)
               {
                  helpMethods.callPageJs("clipStart","1");
               }
               break;
            case playerEvents.CONTORL_PAUSE:
               this.playStatus = 2;
               if(!this.mOver)
               {
                  helpMethods.callPageJs("clipStart","0");
               }
               break;
            case playerEvents.CONTORL_START:
               this.playStatus = 1;
               if(!this.mOver)
               {
                  helpMethods.callPageJs("clipStart","1");
               }
               break;
            case playerEvents.CONTORL_RESTART:
               this.playStatus = 1;
               break;
            case playerEvents.CONTORL_SEEKSTART:
               this.isHandSeek = true;
               break;
            case playerEvents.PLAYCORE_SEEKEND:
               this.BigPlayBTN.visible = false;
               this.playStatus = 1;
               this.isHandSeek = false;
               break;
            case playerEvents.CONTORL_SIZE:
               break;
            case playerEvents.CONTORL_SKIP_HEADEND:
               break;
            case playerEvents.CONTORL_ZOOM:
               this.zoomRatio = param1.data as Number;
               this.setDisplayZoom(this.zoomRatio);
               break;
            case playerEvents.CONTORL_SET_ZOOM_BY_FULL_AND_WINDOWS_BTN:
               this.isFullScreen = param1.data as Boolean;
               this.fullScreenAndWindowsBtnEvent(this.isFullScreen);
               break;
            case playerEvents.SEARCH_EVENT:
               this.mSearchEvent = param1.data as Boolean;
               break;
         }
      }
      
      function msd(param1:MouseEvent) : *
      {
         if(param1.type == MouseEvent.DOUBLE_CLICK)
         {
            if(stage.displayState == StageDisplayState.FULL_SCREEN)
            {
               stage.displayState = StageDisplayState.NORMAL;
               this.isFullScreen = false;
               this.fullScreenAndWindowsBtnEvent(this.isFullScreen);
            }
            else
            {
               stage.displayState = StageDisplayState.FULL_SCREEN;
               this.isFullScreen = true;
               this.fullScreenAndWindowsBtnEvent(this.isFullScreen);
            }
            dispatchEvent(new playerEvents(playerEvents.CONTORL_START));
         }
         else if(param1.type == MouseEvent.CLICK)
         {
            if(this.playStatus == 1 || this.playStatus == 5)
            {
               dispatchEvent(new playerEvents(playerEvents.CONTORL_PAUSE));
            }
            else
            {
               dispatchEvent(new playerEvents(playerEvents.CONTORL_START));
            }
         }
         
      }
      
      function dealkeymsg(param1:KeyboardEvent) : *
      {
         if(parmParse.SMALL_WINDOW)
         {
            return;
         }
         if(this.playStatus == 3 || this.playStatus == 4)
         {
            return;
         }
         switch(param1.type)
         {
            case KeyboardEvent.KEY_DOWN:
               break;
            case KeyboardEvent.KEY_UP:
               if(param1.keyCode == 32)
               {
                  if(!this.mSearchEvent)
                  {
                     if(this.playStatus == 1)
                     {
                        dispatchEvent(new playerEvents(playerEvents.CONTORL_PAUSE));
                     }
                     else
                     {
                        dispatchEvent(new playerEvents(playerEvents.CONTORL_START));
                     }
                  }
               }
         }
      }
      
      function keyHandler(param1:uint) : void
      {
         trace("down:" + param1);
      }
      
      public function addcontrolBarBgMc() : void
      {
         this.dispanPanel = this.skinObj.getSkinMovieClipByClassName("displayPanel");
         this.dispanPanel.x = 0;
         this.dispanPanel.y = 0;
         addChild(this.dispanPanel);
         this.AVDadParent = new MovieClip();
         this.AVDadParent.y = 0;
         this.AVDadParent.x = 0;
         addChild(this.AVDadParent);
         this.dispanPanel.VideoDisplayCtr.width = stage.stageWidth;
         this.dispanPanel.VideoDisplayCtr.height = stage.stageHeight;
         this.dispanPanel.buttonMode = true;
         this.dispanPanel.doubleClickEnabled = true;
         this.dispanPanel.addEventListener(MouseEvent.CLICK,this.msd);
         this.dispanPanel.addEventListener(MouseEvent.DOUBLE_CLICK,this.msd);
         this.MainPanelWidget = this.skinObj.getSkinMovieClipByClassName("com.hulu.MainPanelWidget");
         addChild(this.MainPanelWidget);
         this.adpanel = new MovieClip();
         this.adpanel.y = 0;
         this.adpanel.x = 0;
         addChild(this.adpanel);
      }
      
      public function reSizeDisPanel(param1:Number, param2:Boolean = false) : void
      {
         var _loc3_:Number = 0;
         var _loc4_:Number = stage.stageWidth / stage.stageHeight;
         switch(this.AspectRatio)
         {
            case "默认":
               _loc3_ = param1;
               break;
            case "16:9":
               _loc3_ = 16 / 9;
               break;
            case "4:3":
               _loc3_ = 4 / 3;
               break;
            default:
               _loc3_ = 16 / 9;
         }
         this.setDispalySize(_loc3_,_loc4_,param2);
      }
      
      private function setDispalySize(param1:Number, param2:Number, param3:Boolean = false) : void
      {
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         var _loc6_:Number = 0;
         var _loc7_:Number = 0;
         if(param1 > param2)
         {
            _loc4_ = stage.stageWidth;
            _loc5_ = _loc4_ / param1;
            _loc6_ = 0;
            _loc7_ = (stage.stageHeight - _loc5_) / 2;
         }
         else
         {
            _loc5_ = stage.stageHeight;
            _loc4_ = _loc5_ * param1;
            _loc7_ = 0;
            _loc6_ = (stage.stageWidth - _loc4_) / 2;
         }
         trace("x:" + _loc6_);
         trace("y:" + _loc7_);
         if(_loc6_ == 0 && _loc7_ < 10)
         {
            _loc7_ = 0;
         }
         if(_loc6_ < 10 && _loc7_ == 0)
         {
            _loc6_ = 0;
         }
         if(_loc6_ == 0 && _loc7_ == 0)
         {
            _loc4_ = stage.stageWidth;
            _loc5_ = stage.stageHeight;
         }
         if(stage.stageWidth <= 400 && stage.stageHeight <= 240)
         {
            _loc4_ = stage.stageWidth;
            _loc5_ = stage.stageHeight;
            _loc6_ = 0;
            _loc7_ = 0;
         }
         if(param3)
         {
            helpMethods.ITweening(this.dispanPanel.VideoDisplayCtr,"width",this.dispanPanel.width,_loc4_,0.3);
            helpMethods.ITweening(this.dispanPanel.VideoDisplayCtr,"height",this.dispanPanel.height,_loc5_,0.3);
            helpMethods.ITweening(this.dispanPanel,"x",this.dispanPanel.x,_loc6_,0.3);
            helpMethods.ITweening(this.dispanPanel,"y",this.dispanPanel.y,_loc7_,0.3);
         }
         else
         {
            this.dispanPanel.VideoDisplayCtr.width = _loc4_;
            this.dispanPanel.VideoDisplayCtr.height = _loc5_;
            this.dispanPanel.x = _loc6_;
            this.dispanPanel.y = _loc7_;
         }
         this.dispanelOrginWidth = _loc4_;
         this.dispanelOrginHeight = _loc5_;
         this.setDisplayZoom(this.zoomRatio);
      }
      
      private function setDisplayZoom(param1:Number) : void
      {
         var _loc3_:* = NaN;
         var _loc4_:* = NaN;
         consolelog.log("isFullSreen-------------------------" + this.isFullScreen);
         var _loc2_:Number = 0.3;
         if((this.isFullScreen) && !(stage.displayState == StageDisplayState.NORMAL))
         {
            if(param1 == 0)
            {
               helpMethods.ITweening(this.dispanPanel.VideoDisplayCtr,"height",this.dispanPanel.VideoDisplayCtr.height,stage.stageHeight,_loc2_);
               helpMethods.ITweening(this.dispanPanel.VideoDisplayCtr,"width",this.dispanPanel.VideoDisplayCtr.width,stage.stageWidth,_loc2_);
               helpMethods.ITweening(this.dispanPanel,"x",this.dispanPanel.x,0,_loc2_);
               helpMethods.ITweening(this.dispanPanel,"y",this.dispanPanel.y,0,_loc2_);
               return;
            }
            helpMethods.ITweening(this.dispanPanel.VideoDisplayCtr,"height",this.dispanPanel.VideoDisplayCtr.height,this.dispanelOrginHeight * param1,_loc2_);
            helpMethods.ITweening(this.dispanPanel.VideoDisplayCtr,"width",this.dispanPanel.VideoDisplayCtr.width,this.dispanelOrginWidth * param1,_loc2_);
            _loc3_ = (stage.stageWidth - this.dispanelOrginWidth * param1) / 2;
            _loc4_ = (stage.stageHeight - this.dispanelOrginHeight * param1) / 2;
            trace(_loc3_,_loc4_,this.dispanPanel.width,this.dispanPanel.height);
            helpMethods.ITweening(this.dispanPanel,"x",this.dispanPanel.x,_loc3_,_loc2_);
            helpMethods.ITweening(this.dispanPanel,"y",this.dispanPanel.y,_loc4_,_loc2_);
            return;
         }
      }
      
      private function fullScreenAndWindowsBtnEvent(param1:Boolean) : *
      {
         this.currentLevel = this.shareObj.getValue(this.SHAREOBJ_ZOOM_KEY);
         this.zoomRatio = Number(this.currentLevel);
         consolelog.log("fullScreenAndWindowsBtnEvent------" + this.zoomRatio + param1);
         if(param1)
         {
            this.setDisplayZoom(this.zoomRatio);
         }
      }
   }
}
