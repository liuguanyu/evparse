package com.letv.player.components.controlBar
{
   import com.letv.player.components.BaseConfigComponent;
   import com.greensock.TweenLite;
   import com.letv.player.components.controlBar.classes.*;
   import com.letv.player.components.controlBar.events.*;
   import com.letv.player.components.types.UIState;
   import com.letv.player.notify.LogicNotify;
   import flash.geom.Rectangle;
   import flash.events.MouseEvent;
   import com.letv.player.components.types.SleepState;
   import com.alex.utils.TimeUtil;
   import flash.text.TextFieldAutoSize;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import com.alex.controls.Image;
   import com.alex.states.BitmapFillMode;
   import flash.events.IOErrorEvent;
   import flash.events.Event;
   import com.alex.utils.BrowserUtil;
   
   public class ControlBarUI extends BaseConfigComponent
   {
      
      private var speedTimeout:int;
      
      private var START_X:uint = 0;
      
      private var trackUI:TrackUI;
      
      private var previewUI:PreviewUI;
      
      private var nextBtnUI:NextBtnUI;
      
      private var definitionUI:DefinitionUI;
      
      private var seeDataUI:SeeDataUI;
      
      private var volumeUI:VolumeUI;
      
      private var scaleUI:ScaleUI;
      
      private var filterUI:HotFilterUI;
      
      private var infoData:Object;
      
      private var locked:Boolean;
      
      private var currentTime:Number = 0;
      
      private var loopPlayTime:Boolean = true;
      
      private var speedInter:int;
      
      private var logo:Image;
      
      private var url:String;
      
      private var _maxAlpha:Number = 0.5;
      
      public const MAX_WIDTH:uint = 1280;
      
      public const V_GAP:uint = 20;
      
      public const H_GAP:uint = 20;
      
      public function ControlBarUI(param1:Object)
      {
         super(param1);
      }
      
      public function set maxAlpha(param1:Number) : void
      {
         this._maxAlpha = param1;
         TweenLite.to(this.trackUI,0.3,{"alpha":this._maxAlpha});
         TweenLite.to(skin.back,0.3,{"alpha":this._maxAlpha});
         TweenLite.to(skin.currentTime,0.3,{"alpha":this._maxAlpha});
         TweenLite.to(skin.durationTime,0.3,{"alpha":this._maxAlpha});
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
      }
      
      public function show() : void
      {
         if(stage != null)
         {
            if(uistate == UIState.PLAY || uistate == UIState.PAUSE || uistate == UIState.REC)
            {
               TweenLite.to(parent,0.4,{
                  "y":0,
                  "onStart":this.onShowStart
               });
               sendNotification(LogicNotify.CONTROLBAR_SHOW_COMPLETE);
            }
         }
      }
      
      public function hide() : void
      {
         if(stage != null)
         {
            if(uistate == UIState.PLAY || uistate == UIState.PAUSE)
            {
               TweenLite.to(parent,0.4,{
                  "y":this.trackUI.height,
                  "onComplete":this.onHideComplete
               });
            }
            else
            {
               this.onHideComplete();
            }
         }
      }
      
      private function onShowStart() : void
      {
         var _loc1_:ControlBarEvent = new ControlBarEvent(ControlBarEvent.SHOWSKIN);
         dispatchEvent(_loc1_);
         if(!visible)
         {
            this.visible = true;
         }
      }
      
      private function onHideComplete() : void
      {
         var _loc1_:ControlBarEvent = new ControlBarEvent(ControlBarEvent.HIDESKIN);
         dispatchEvent(_loc1_);
         if(visible)
         {
            this.visible = false;
         }
         sendNotification(LogicNotify.CONTROLBAR_HIDE_COMPLETE);
      }
      
      public function resize(param1:Boolean = false) : void
      {
         var GAP_AD:uint = 0;
         var GAP:uint = 0;
         var MIN_DRAG_WIDTH:uint = 0;
         var leaveWidth:Number = NaN;
         var leaveVisualWidth:Number = NaN;
         var QUEUE_PRIORITY:Array = null;
         var QUEUE_POSITION:Array = null;
         var CONFIG_PRIORITY:Array = null;
         var nextBtnConf:Boolean = false;
         var queueVisible:Boolean = false;
         var i:uint = 0;
         var hPosition:uint = 0;
         var sqcount:uint = 0;
         var changeScale:Number = NaN;
         var isGlobal:Boolean = param1;
         if(!(stage == null) && !(skin.back == null))
         {
            TweenLite.killTweensOf(this);
            GAP_AD = 5;
            GAP = 15;
            skin.back.width = applicationWidth;
            if(applicationWidth < 120 || applicationHeight < 120)
            {
               return;
            }
            this.setSpeed(false);
            if(isGlobal)
            {
               this.maxAlpha = this._maxAlpha;
            }
            switch(uistate)
            {
               case UIState.INIT:
               case UIState.WAIT:
                  if(visible)
                  {
                     this.onHideComplete();
                  }
                  break;
               case UIState.AD:
                  if(!visible)
                  {
                     this.onShowStart();
                  }
                  this.alpha = 1;
                  this.maxAlpha = 1;
                  changeScale = 37 / 50;
                  this.scaleX = this.scaleY = changeScale;
                  this.volumeUI.x = GAP_AD;
                  this.scaleUI.x = this.volumeUI.x + this.volumeUI.width + GAP_AD;
                  skin.back.width = this.scaleUI.x + this.scaleUI.width + GAP_AD;
                  this.x = applicationWidth - this.H_GAP - skin.back.width * changeScale;
                  this.y = applicationHeight - skin.back.height * changeScale - this.V_GAP;
                  try
                  {
                     this.y = this.y - this.parent.y;
                  }
                  catch(e:Error)
                  {
                  }
                  return;
               default:
                  if(!visible)
                  {
                     this.onShowStart();
                  }
                  if(alpha != 1)
                  {
                     this.alpha = 1;
                  }
                  if(scaleX != 1)
                  {
                     this.scaleX = 1;
                  }
                  if(scaleY != 1)
                  {
                     this.scaleY = 1;
                  }
            }
            this.onControlBarUpdate();
            MIN_DRAG_WIDTH = 200;
            leaveWidth = skin.back.width - this.START_X;
            leaveVisualWidth = leaveWidth;
            if(R.controlbar.nextBtnStatus == "on")
            {
               nextBtnConf = true;
            }
            else if(R.controlbar.nextBtnStatus == "off")
            {
               nextBtnConf = false;
            }
            else
            {
               nextBtnConf = (R.controlbar.nextBtnVisible) && (uistate == UIState.PLAY || uistate == UIState.PAUSE || uistate == UIState.STOP) && this.nextBtnUI.total > 1;
            }
            
            if(R.controlbar.definitionVisible)
            {
               QUEUE_PRIORITY = [this.scaleUI,this.volumeUI,this.nextBtnUI,this.definitionUI,skin.logo];
               QUEUE_POSITION = [skin.logo,this.scaleUI,this.definitionUI,this.volumeUI,this.nextBtnUI];
               CONFIG_PRIORITY = [null,null,nextBtnConf,!(uistate == UIState.INIT) && !(uistate == UIState.SLEEP) && !(uistate == UIState.STOP) && !(uistate == UIState.REC),R.controlbar.logoVisible];
            }
            else
            {
               QUEUE_PRIORITY = [this.scaleUI,this.volumeUI,this.nextBtnUI,skin.logo];
               QUEUE_POSITION = [skin.logo,this.scaleUI,this.volumeUI,this.nextBtnUI];
               CONFIG_PRIORITY = [null,null,nextBtnConf,R.controlbar.logoVisible];
            }
            i = 0;
            while(i < QUEUE_PRIORITY.length)
            {
               if(QUEUE_PRIORITY[i] != null)
               {
                  queueVisible = CONFIG_PRIORITY[i] == null || !(CONFIG_PRIORITY[i] == null) && CONFIG_PRIORITY[i] == true;
                  QUEUE_PRIORITY[i].visible = queueVisible;
               }
               i++;
            }
            hPosition = skin.back.width;
            sqcount = 0;
            i = 0;
            while(i < QUEUE_POSITION.length)
            {
               if(!(QUEUE_POSITION[i] == null || !QUEUE_POSITION[i].visible))
               {
                  leaveVisualWidth = leaveWidth - (QUEUE_POSITION[i].width + GAP);
                  if(leaveVisualWidth >= MIN_DRAG_WIDTH)
                  {
                     hPosition = hPosition - (QUEUE_POSITION[i].width + GAP);
                     QUEUE_POSITION[i].x = hPosition;
                     sqcount++;
                     leaveWidth = leaveVisualWidth;
                  }
                  else
                  {
                     QUEUE_POSITION[i].visible = false;
                  }
               }
               i++;
            }
            leaveWidth = leaveWidth - GAP;
            try
            {
               this.trackUI.x = this.START_X;
               this.trackUI.resize(leaveWidth);
               this.filterUI.resize(new Rectangle(0,0,this.trackUI.width,this.trackUI.height));
               skin.durationTime.x = this.START_X + this.trackUI.width - skin.durationTime.width - 10;
               this.seeDataUI.resize(this.trackUI.width,this.trackUI.height);
            }
            catch(e:Error)
            {
            }
            this.x = 0;
            this.y = applicationHeight - R.controlbar.cHeight;
         }
      }
      
      public function inSleepState(param1:int) : void
      {
         switch(param1)
         {
            case SleepState.PLAY_BEFORE:
               this.initState();
               uistate = UIState.SLEEP;
               this.resize(false);
               skin.playBtn.mouseEnabled = true;
               skin.playBtn.addEventListener(MouseEvent.CLICK,this.onSetup);
               break;
            case SleepState.PLAY_AFTER:
               this.inStopState();
               skin.playBtn.visible = false;
               skin.pauseBtn.visible = false;
               skin.replayBtn.visible = true;
               skin.replayBtn.mouseEnabled = true;
               skin.replayBtn.addEventListener(MouseEvent.CLICK,this.onReplay);
               break;
            case SleepState.PLAY_ING:
               this.lock();
               skin.playBtn.visible = true;
               skin.pauseBtn.visible = false;
               skin.replayBtn.visible = false;
               break;
            default:
               this.initState();
         }
      }
      
      public function initState() : void
      {
         uistate = UIState.INIT;
         this.currentTime = 0;
         if(skin.playBtn != null)
         {
            skin.playBtn.visible = true;
         }
         if(skin.pauseBtn != null)
         {
            skin.pauseBtn.visible = false;
         }
         if(skin.replayBtn != null)
         {
            skin.replayBtn.visible = false;
         }
         if(skin.currentTime != null)
         {
            skin.currentTime.visible = false;
         }
         if(skin.durationTime != null)
         {
            skin.durationTime.visible = false;
         }
         if(this.seeDataUI != null)
         {
            this.seeDataUI.hide();
         }
         if(this.definitionUI != null)
         {
            this.definitionUI.hide();
         }
         if(this.scaleUI != null)
         {
            this.scaleUI.enabled = false;
         }
         if(this.filterUI != null)
         {
            this.filterUI.visible = false;
         }
         if(this.nextBtnUI != null)
         {
            this.nextBtnUI.enabled = false;
         }
         if(this.previewUI != null)
         {
            this.previewUI.visible = false;
         }
         if(this.trackUI != null)
         {
            this.trackUI.showSlider = false;
         }
         this.refreshLoadPercent(0);
         this.refreshPlayPercent(0);
         this.lock();
         this.resize(false);
      }
      
      public function inAdState() : void
      {
         uistate = UIState.AD;
         if(skin.speed != null)
         {
            skin.speed.visible = false;
         }
         if(skin.playBtn != null)
         {
            skin.playBtn.visible = false;
         }
         if(skin.pauseBtn != null)
         {
            skin.pauseBtn.visible = false;
         }
         if(skin.replayBtn != null)
         {
            skin.replayBtn.visible = false;
         }
         if(skin.currentTime != null)
         {
            skin.currentTime.visible = false;
         }
         if(skin.durationTime != null)
         {
            skin.durationTime.visible = false;
         }
         if(this.scaleUI != null)
         {
            this.scaleUI.enabled = false;
         }
         if(this.trackUI != null)
         {
            this.trackUI.visible = false;
         }
         if(this.volumeUI != null)
         {
            this.volumeUI.enabled = false;
         }
         if(this.previewUI != null)
         {
            this.previewUI.visible = false;
         }
         if(this.nextBtnUI != null)
         {
            this.nextBtnUI.enabled = false;
         }
         if(this.seeDataUI != null)
         {
            this.seeDataUI.hide();
         }
         this.lock();
         this.resize(true);
      }
      
      public function inEnabledState(param1:Object) : void
      {
         uistate = UIState.WAIT;
         if(param1 != null)
         {
            this.infoData = param1;
            if((param1.hasOwnProperty("url")) && !(param1["url"] == ""))
            {
               this.url = param1["url"];
            }
            if(skin.speed != null)
            {
               skin.speed.visible = true;
            }
            if(this.volumeUI != null)
            {
               this.volumeUI.initvolume = param1;
            }
            if(this.seeDataUI != null)
            {
               this.seeDataUI.setData(param1,this.duration);
            }
            if(this.nextBtnUI != null)
            {
               this.nextBtnUI.setData(param1);
               this.nextBtnUI.addEventListener(ControlBarEvent.PLAY_NEXT,this.onPlayNext);
            }
            this.definitionUI.setData(sdk.getDefinition(),sdk.getDefaultDefinition(),sdk.getDefinitionList(),sdk.getDefinitionMatchList());
         }
         this.resize(false);
      }
      
      public function inStartState(param1:Object = null) : void
      {
         var info:Object = param1;
         try
         {
            this.infoData.duration = info.duration;
            if(skin.speed != null)
            {
               skin.speed.visible = true;
            }
            if(this.nextBtnUI != null)
            {
               this.nextBtnUI.addEventListener(ControlBarEvent.PLAY_NEXT,this.onPlayNext);
            }
            if(this.volumeUI != null)
            {
               this.volumeUI.initvolume = info;
            }
            if(this.seeDataUI != null)
            {
               this.seeDataUI.resetDuration(this.duration);
            }
            this.unlock();
            try
            {
               skin.currentTime.visible = true;
               skin.durationTime.visible = true;
               skin.durationTime.text = TimeUtil.swap(this.duration);
               skin.durationTime.autoSize = TextFieldAutoSize.LEFT;
            }
            catch(e:Error)
            {
            }
            this.inPlayState();
         }
         catch(e:Error)
         {
            trace("Error ControlBarUI.inStartState",e.message);
         }
      }
      
      public function inToggleState() : void
      {
         if(uistate == UIState.PLAY)
         {
            this.onPause();
         }
         else if(uistate == UIState.PAUSE)
         {
            this.onPlay();
         }
         
      }
      
      public function inPlayState() : void
      {
         uistate = UIState.PLAY;
         this.setSpeed(false);
         if(skin.playBtn != null)
         {
            skin.playBtn.visible = false;
         }
         if(skin.pauseBtn != null)
         {
            skin.pauseBtn.visible = true;
         }
         if(skin.replayBtn != null)
         {
            skin.replayBtn.visible = false;
         }
         if(skin.currentTime != null)
         {
            skin.currentTime.visible = true;
         }
         if(skin.durationTime != null)
         {
            skin.durationTime.visible = true;
         }
         if(this.scaleUI != null)
         {
            this.scaleUI.enabled = true;
         }
         if(this.trackUI != null)
         {
            this.trackUI.visible = true;
         }
         if(this.volumeUI != null)
         {
            this.volumeUI.enabled = true;
         }
         if(this.nextBtnUI != null)
         {
            this.nextBtnUI.enabled = true;
         }
         if(this.trackUI != null)
         {
            this.trackUI.showSlider = true;
         }
         if(this.seeDataUI != null)
         {
            this.seeDataUI.unlock();
         }
         this.unlock();
         this.resize(false);
      }
      
      public function inPauseState() : void
      {
         if(uistate == UIState.PLAY)
         {
            uistate = UIState.PAUSE;
            if(skin.playBtn != null)
            {
               skin.playBtn.visible = true;
            }
            if(skin.pauseBtn != null)
            {
               skin.pauseBtn.visible = false;
            }
            if(skin.replayBtn != null)
            {
               skin.replayBtn.visible = false;
            }
         }
      }
      
      public function inStopState() : void
      {
         uistate = UIState.STOP;
         this.addListener();
         if(skin.playBtn != null)
         {
            skin.playBtn.visible = false;
         }
         if(skin.pauseBtn != null)
         {
            skin.pauseBtn.visible = false;
         }
         if(skin.replayBtn != null)
         {
            skin.replayBtn.visible = true;
         }
         if(skin.replayBtn != null)
         {
            skin.replayBtn.mouseEnabled = true;
         }
         if(this.scaleUI != null)
         {
            this.scaleUI.enabled = false;
         }
         if(this.previewUI != null)
         {
            this.previewUI.visible = false;
         }
         if(this.seeDataUI != null)
         {
            this.seeDataUI.hide();
         }
         if(this.volumeUI != null)
         {
            this.volumeUI.enabled = true;
         }
         if(this.trackUI != null)
         {
            this.trackUI.visible = true;
         }
         if(this.filterUI != null)
         {
            this.filterUI.visible = false;
         }
         if(this.trackUI != null)
         {
            this.trackUI.unlock();
            this.trackUI.showSlider = false;
         }
         this.refreshPlayPercent(0);
         this.refreshLoadPercent(0);
         this.resize(true);
      }
      
      public function inRecState() : void
      {
         uistate = UIState.REC;
         this.addListener();
         if(skin.playBtn != null)
         {
            skin.playBtn.visible = false;
         }
         if(skin.pauseBtn != null)
         {
            skin.pauseBtn.visible = false;
         }
         if(skin.replayBtn != null)
         {
            skin.replayBtn.visible = true;
         }
         if(skin.replayBtn != null)
         {
            skin.replayBtn.mouseEnabled = true;
         }
         if(this.scaleUI != null)
         {
            this.scaleUI.enabled = false;
         }
         if(this.previewUI != null)
         {
            this.previewUI.visible = false;
         }
         if(this.seeDataUI != null)
         {
            this.seeDataUI.hide();
         }
         if(this.volumeUI != null)
         {
            this.volumeUI.enabled = true;
         }
         if(this.trackUI != null)
         {
            this.trackUI.visible = true;
         }
         if(this.filterUI != null)
         {
            this.filterUI.visible = false;
         }
         if(this.trackUI != null)
         {
            this.trackUI.unlock();
            this.trackUI.showSlider = false;
         }
         this.refreshPlayPercent(0);
         this.refreshLoadPercent(0);
         this.resize(true);
      }
      
      public function unlock() : void
      {
         this.locked = false;
         if(skin.playBtn != null)
         {
            skin.playBtn.mouseEnabled = true;
         }
         if(skin.pauseBtn != null)
         {
            skin.pauseBtn.mouseEnabled = true;
         }
         if(skin.replayBtn != null)
         {
            skin.replayBtn.mouseEnabled = true;
         }
         if(this.trackUI != null)
         {
            this.trackUI.unlock();
         }
         if(this.seeDataUI != null)
         {
            this.seeDataUI.unlock();
         }
         this.addListener();
      }
      
      public function lock() : void
      {
         this.locked = true;
         if(skin.playBtn != null)
         {
            skin.playBtn.mouseEnabled = false;
         }
         if(skin.pauseBtn != null)
         {
            skin.pauseBtn.mouseEnabled = false;
         }
         if(skin.replayBtn != null)
         {
            skin.replayBtn.mouseEnabled = false;
         }
         if(this.previewUI != null)
         {
            this.previewUI.visible = false;
         }
         if(this.trackUI != null)
         {
            this.trackUI.lock();
         }
         if(this.seeDataUI != null)
         {
            this.seeDataUI.lock();
         }
         this.removeListener();
         this.resize(false);
      }
      
      public function get duration() : Number
      {
         if((this.infoData) && (this.infoData.duration) && !isNaN(this.infoData.duration))
         {
            return this.infoData.duration;
         }
         return 0;
      }
      
      public function get controlHeight() : Number
      {
         try
         {
            return skin.back.height;
         }
         catch(e:Error)
         {
         }
         return 0;
      }
      
      public function lockTrack() : void
      {
         try
         {
            this.trackUI.lock();
         }
         catch(e:Error)
         {
         }
         try
         {
            this.seeDataUI.hide();
         }
         catch(e:Error)
         {
         }
         try
         {
            this.previewUI.visible = false;
         }
         catch(e:Error)
         {
         }
      }
      
      public function displayHotFilter(param1:Boolean) : void
      {
         if(this.filterUI != null)
         {
            this.filterUI.display(param1);
         }
      }
      
      public function setHotFilterData(param1:Object) : void
      {
         if(this.filterUI != null)
         {
            this.filterUI.setData(param1);
         }
      }
      
      public function setSpeed(param1:Boolean, param2:int = 0) : void
      {
         var flag:Boolean = param1;
         var type:int = param2;
         clearInterval(this.speedInter);
         if(flag)
         {
            this.loopPlayTime = false;
            if(type == 0)
            {
               this.onBackSpeed();
               this.speedInter = setInterval(this.onBackSpeed,50);
            }
            else
            {
               this.onForwardSpeed();
               this.speedInter = setInterval(this.onForwardSpeed,100);
            }
            skin.stage.addEventListener(MouseEvent.MOUSE_UP,this.onSeekTo);
         }
         else
         {
            this.loopPlayTime = true;
            try
            {
               skin["rewindBtn"].visible = false;
               skin["forwardBtn"].visible = false;
               if((skin.rewindBtn.visible) || (skin.forwarBtn.visible))
               {
                  skin["playBtn"].visible = false;
                  skin["pauseBtn"].visible = true;
               }
            }
            catch(e:Error)
            {
            }
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.onSeekTo);
         }
         if(flag)
         {
            return;
         }
      }
      
      public function onBackSpeed() : void
      {
         try
         {
            skin["rewindBtn"].visible = true;
            skin["forwardBtn"].visible = false;
            skin["playBtn"].visible = false;
            skin["pauseBtn"].visible = false;
         }
         catch(e:Error)
         {
         }
         this.loopPlayTime = false;
         this.refreshPlayPercent(this.currentTime - 15);
      }
      
      public function onForwardSpeed() : void
      {
         try
         {
            skin["rewindBtn"].visible = false;
            skin["forwardBtn"].visible = true;
            skin["playBtn"].visible = false;
            skin["pauseBtn"].visible = false;
         }
         catch(e:Error)
         {
         }
         this.loopPlayTime = false;
         this.refreshPlayPercent(this.currentTime + 15);
      }
      
      public function set initDuration(param1:Number) : void
      {
         if(!(skin.durationTime == null) && param1 > 0)
         {
            this.infoData = {"duration":param1};
            skin.durationTime.text = TimeUtil.swap(param1);
         }
      }
      
      public function set toggleVolume(param1:int) : void
      {
         this.volumeUI.toggleVolume = param1;
      }
      
      public function set scriptVolume(param1:Object) : void
      {
         this.volumeUI.scriptVolume = param1;
      }
      
      public function set speed(param1:Object) : void
      {
         var result:Number = NaN;
         var value:Object = param1;
         try
         {
            var onHideSpeed:Function = function():void
            {
               skin.speed.text = "";
            };
            result = int(value);
            if(!isNaN(result) && result > 0 && (skin.speed.visible))
            {
               skin.speed.text = result + "KB/S";
               clearTimeout(this.speedTimeout);
               this.speedTimeout = setTimeout(onHideSpeed,3000);
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public function set percent(param1:Object) : void
      {
         if(this.duration <= 0)
         {
            return;
         }
         if(param1.hasOwnProperty("loadPercent"))
         {
            this.refreshLoadPercent(param1.loadPercent);
         }
         if(!this.loopPlayTime)
         {
            return;
         }
         if(param1.hasOwnProperty("videoTime"))
         {
            this.refreshPlayPercent(param1.videoTime);
         }
      }
      
      private function refreshLoadPercent(param1:Number) : void
      {
         if(this.trackUI != null)
         {
            if((isNaN(param1)) && param1 < 0)
            {
               var param1:Number = 0;
            }
            if(param1 > 1)
            {
               param1 = 1;
            }
            this.trackUI.loadPercent = param1;
         }
      }
      
      private function refreshPlayPercent(param1:Number) : void
      {
         var value:Number = param1;
         if((isNaN(value)) || value < 0)
         {
            value = 0;
         }
         this.currentTime = value > this.duration?this.duration:value;
         if(skin.currentTime != null)
         {
            skin.currentTime.text = TimeUtil.swap(this.currentTime);
            skin.currentTime.autoSize = TextFieldAutoSize.LEFT;
         }
         if(this.trackUI != null)
         {
            this.trackUI.playPercent = this.currentTime / this.duration;
         }
         try
         {
            if(this.trackUI.sliderX > skin.currentTime.width + 10)
            {
               skin.currentTime.x = this.trackUI.x + (this.trackUI.sliderX - skin.currentTime.width) - 10;
            }
            else
            {
               skin.currentTime.x = this.trackUI.x;
            }
            if(skin.currentTime.x + skin.currentTime.width >= skin.durationTime.x)
            {
               if(skin.durationTime.visible)
               {
                  skin.durationTime.visible = false;
               }
            }
            else if(!skin.durationTime.visible)
            {
               skin.durationTime.visible = true;
            }
            
         }
         catch(e:Error)
         {
         }
      }
      
      private function onControlBarUpdate() : void
      {
         var _loc1_:ControlBarEvent = new ControlBarEvent(ControlBarEvent.CONTROLBAR_MOVE);
         _loc1_.controlbarX = this.x;
         _loc1_.controlbarY = this.y;
         dispatchEvent(_loc1_);
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         if(skin.playBtn != null)
         {
            this.START_X = skin.playBtn.x + skin.playBtn.width;
         }
         try
         {
            skin.speed.text = "";
            skin.speed.visible = false;
            skin.speed.mouseEnabled = false;
            skin.speed.autoSize = TextFieldAutoSize.LEFT;
         }
         catch(e:Error)
         {
         }
         try
         {
            skin["rewindBtn"].visible = false;
            skin["forwardBtn"].visible = false;
         }
         catch(e:Error)
         {
         }
         this.trackUI = new TrackUI(skin["dragBar"]);
         try
         {
            skin.currentTime.x = this.trackUI.x;
            skin.currentTime.mouseEnabled = false;
            skin.currentTime.autoSize = TextFieldAutoSize.LEFT;
            skin.durationTime.text = "00:00";
            skin.durationTime.mouseEnabled = false;
            skin.durationTime.autoSize = TextFieldAutoSize.LEFT;
         }
         catch(e:Error)
         {
         }
         this.volumeUI = new VolumeUI(skin["volume"]);
         this.volumeUI.addEventListener(ControlBarEvent.SET_VOLUME,this.onSetVolume);
         this.seeDataUI = new SeeDataUI(this.trackUI);
         this.seeDataUI.addEventListener(SeePointEvent.HIDE_SEE_POINT,this.onHideSeePoint);
         this.seeDataUI.addEventListener(SeePointEvent.SHOW_SEE_POINT,this.onShowSeePoint);
         this.seeDataUI.addEventListener(SeePointEvent.SELECT_SEE_POINT,this.onSelectSeePoint);
         this.seeDataUI.addEventListener(SeePointEvent.SET_JUMP,this.onPreviewSetJump);
         addElement(this.seeDataUI);
         this.filterUI = new HotFilterUI(this.trackUI.skin);
         this.previewUI = new PreviewUI(skin["preview"]);
         this.trackUI.addElement(this.previewUI);
         this.definitionUI = new DefinitionUI(skin["definition"]);
         this.definitionUI.visible = R.controlbar.definitionVisible;
         this.scaleUI = new ScaleUI(skin["scale"]);
         if(!R.controlbar.nextBtnVisible && !(skin.nextBtn == null))
         {
            skin.removeChild(skin.nextBtn);
            skin.nextBtn = null;
            delete skin.nextBtn;
            true;
         }
         else
         {
            this.nextBtnUI = new NextBtnUI(skin["nextBtn"]);
         }
         if(!R.controlbar.logoVisible)
         {
            if(skin.logo != null)
            {
               skin.removeChild(skin.logo);
               skin.logo = null;
               delete skin.logo;
               true;
            }
         }
         else if(R.controlbar.logoURL != null)
         {
            if(skin.logo != null)
            {
               skin.removeChild(skin.logo);
               delete skin.logo;
               true;
            }
            this.logo = new Image();
            this.logo.fillMode = BitmapFillMode.ORIGINAL;
            this.logo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadLogoError);
            this.logo.addEventListener(Event.COMPLETE,this.onLoadLogoComplete);
            this.logo.source = R.controlbar.logoURL;
         }
         
         if(skin.logo != null)
         {
            skin.logo.addEventListener(MouseEvent.CLICK,this.onMain);
         }
         this.initState();
      }
      
      private function onLoadLogoError(param1:Event) : void
      {
         this.logo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadLogoError);
         this.logo.removeEventListener(Event.COMPLETE,this.onLoadLogoComplete);
         this.logo.destroy();
         this.logo = null;
      }
      
      private function onLoadLogoComplete(param1:Event) : void
      {
         this.logo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadLogoError);
         this.logo.removeEventListener(Event.COMPLETE,this.onLoadLogoComplete);
         this.addElement(this.logo);
         skin.logo = this.logo;
         skin.logo.y = skin.playBtn.y + (skin.playBtn.height - skin.logo.height) * 0.5;
         if(R.controlbar.logoClkURL != null)
         {
            this.logo.buttonMode = true;
            this.logo.addEventListener(MouseEvent.CLICK,this.onMain);
         }
         this.resize();
      }
      
      private function addListener() : void
      {
         addEventListener(MouseEvent.ROLL_OVER,this.onControlBarFocusOver);
         addEventListener(MouseEvent.ROLL_OUT,this.onControlBarFocusOut);
         if(skin.pauseBtn != null)
         {
            skin.pauseBtn.addEventListener(MouseEvent.CLICK,this.onPause);
         }
         if(skin.playBtn != null)
         {
            skin.playBtn.addEventListener(MouseEvent.CLICK,this.onPlay);
         }
         if(skin.replayBtn != null)
         {
            skin.replayBtn.addEventListener(MouseEvent.CLICK,this.onReplay);
         }
         if(this.trackUI != null)
         {
            this.trackUI.addEventListener(TrackEvent.CHANGE_PREVIEW,this.onPreviewChange);
            this.trackUI.addEventListener(TrackEvent.CHANGE_TRACK,this.onTrackChange);
            this.trackUI.addEventListener(TrackEvent.SEEK,this.onSeekTo);
         }
         if(this.volumeUI != null)
         {
            this.volumeUI.addEventListener(ControlBarEvent.SET_VOLUME,this.onSetVolume);
         }
         if(this.nextBtnUI != null)
         {
            this.nextBtnUI.addEventListener(ControlBarEvent.PLAY_NEXT,this.onPlayNext);
         }
         if(this.definitionUI != null)
         {
            this.definitionUI.addEventListener(ControlBarEvent.DEFINITION_VIP,this.onDefinitionVip);
            this.definitionUI.addEventListener(ControlBarEvent.DEFINITION_REGULATE,this.onDefinitionRegulate);
         }
      }
      
      private function removeListener() : void
      {
         removeEventListener(MouseEvent.ROLL_OVER,this.onControlBarFocusOver);
         removeEventListener(MouseEvent.ROLL_OUT,this.onControlBarFocusOut);
         if(skin.pauseBtn != null)
         {
            skin.pauseBtn.removeEventListener(MouseEvent.CLICK,this.onPause);
         }
         if(skin.playBtn != null)
         {
            skin.playBtn.removeEventListener(MouseEvent.CLICK,this.onPlay);
            skin.playBtn.removeEventListener(MouseEvent.CLICK,this.onSetup);
         }
         if(skin.replayBtn != null)
         {
            skin.replayBtn.removeEventListener(MouseEvent.CLICK,this.onReplay);
         }
         if(this.trackUI != null)
         {
            this.trackUI.removeEventListener(TrackEvent.CHANGE_PREVIEW,this.onPreviewChange);
            this.trackUI.removeEventListener(TrackEvent.CHANGE_TRACK,this.onTrackChange);
            this.trackUI.removeEventListener(TrackEvent.SEEK,this.onSeekTo);
         }
         if(this.definitionUI != null)
         {
            this.definitionUI.removeEventListener(ControlBarEvent.DEFINITION_VIP,this.onDefinitionVip);
            this.definitionUI.removeEventListener(ControlBarEvent.DEFINITION_REGULATE,this.onDefinitionRegulate);
         }
      }
      
      private function onControlBarFocusOver(param1:MouseEvent) : void
      {
         this.maxAlpha = 1;
      }
      
      private function onControlBarFocusOut(param1:MouseEvent) : void
      {
         if(this.previewUI != null)
         {
            this.previewUI.visible = false;
         }
         this.maxAlpha = 0.5;
      }
      
      private function onPause(param1:MouseEvent = null) : void
      {
         dispatchEvent(new ControlBarEvent(ControlBarEvent.VIDEO_PAUSE));
      }
      
      private function onPlay(param1:MouseEvent = null) : void
      {
         dispatchEvent(new ControlBarEvent(ControlBarEvent.VIDEO_RESUME));
      }
      
      private function onReplay(param1:MouseEvent) : void
      {
         this.unlock();
         dispatchEvent(new ControlBarEvent(ControlBarEvent.VIDEO_REPLAY));
      }
      
      private function onZoom(param1:MouseEvent) : void
      {
         if(skin.wideScreen.currentFrame == 1)
         {
            dispatchEvent(new ControlBarEvent(ControlBarEvent.DOCK_ZOOM_IN));
         }
         else
         {
            dispatchEvent(new ControlBarEvent(ControlBarEvent.DOCK_ZOOM_OUT));
         }
      }
      
      private function onLeftSpeedDown(param1:MouseEvent) : void
      {
         this.setSpeed(true,0);
      }
      
      private function onRightSpeedDown(param1:MouseEvent) : void
      {
         this.setSpeed(true,1);
      }
      
      private function onPreviewMove(param1:MouseEvent) : void
      {
         this.previewPosition(skin.mouseX);
      }
      
      private function previewPosition(param1:Number) : void
      {
         var _loc2_:* = NaN;
         if(this.previewUI != null)
         {
            this.previewUI.x = param1;
            if(this.duration <= 0)
            {
               return;
            }
            _loc2_ = this.duration * this.trackUI.mousePercent;
            this.previewUI.setPreviewTime(_loc2_);
         }
      }
      
      private function onPreviewChange(param1:TrackEvent) : void
      {
         if(param1.dataProvider == true)
         {
            this.previewUI.visible = true;
            this.previewPosition(this.trackUI.track.mouseX);
         }
         else
         {
            this.previewUI.visible = false;
         }
      }
      
      private function onTrackChange(param1:TrackEvent) : void
      {
         this.loopPlayTime = false;
         var _loc2_:Number = this.duration * this.trackUI.playPercent;
         this.refreshPlayPercent(_loc2_);
      }
      
      public function onSeekTo(param1:TrackEvent = null) : void
      {
         var _loc2_:ControlBarEvent = null;
         this.setSpeed(false);
         if(this.duration > 0)
         {
            _loc2_ = new ControlBarEvent(ControlBarEvent.SEEK_TO);
            _loc2_.dataProvider = this.duration * this.trackUI.playPercent;
            dispatchEvent(_loc2_);
         }
         this.loopPlayTime = true;
      }
      
      private function onInfotipChange(param1:InfoTipEvent) : void
      {
         var _loc2_:InfoTipEvent = new InfoTipEvent(InfoTipEvent.CHANGE);
         _loc2_.dataProvider = param1.dataProvider;
         dispatchEvent(_loc2_);
      }
      
      private function onSetVolume(param1:ControlBarEvent) : void
      {
         var _loc2_:ControlBarEvent = new ControlBarEvent(ControlBarEvent.SET_VOLUME);
         _loc2_.dataProvider = param1.dataProvider;
         dispatchEvent(_loc2_);
      }
      
      private function onHideSeePoint(param1:SeePointEvent) : void
      {
      }
      
      private function onShowSeePoint(param1:SeePointEvent) : void
      {
         this.previewUI.visible = false;
      }
      
      private function onSelectSeePoint(param1:SeePointEvent) : void
      {
         var _loc2_:ControlBarEvent = null;
         if(this.duration > 0)
         {
            this.refreshPlayPercent(param1.time);
            _loc2_ = new ControlBarEvent(param1.dataProvider == true?ControlBarEvent.JUMP_TAIL:ControlBarEvent.SEEK_TO);
            _loc2_.dataProvider = param1.time;
            dispatchEvent(_loc2_);
         }
      }
      
      private function onPreviewSetJump(param1:SeePointEvent) : void
      {
         if(sdk != null)
         {
            sdk.setJump(param1.dataProvider as Boolean);
         }
      }
      
      private function onPlayNext(param1:ControlBarEvent) : void
      {
         dispatchEvent(new ControlBarEvent(ControlBarEvent.PLAY_NEXT));
      }
      
      private function onSetup(param1:MouseEvent) : void
      {
         if(skin.playBtn != null)
         {
            skin.playBtn.mouseEnabled = false;
            skin.playBtn.removeEventListener(MouseEvent.CLICK,this.onSetup);
         }
         dispatchEvent(new ControlBarEvent(ControlBarEvent.VIDEO_START_FROM_SLEEP));
      }
      
      private function onMain(param1:MouseEvent) : void
      {
         if(uistate == UIState.PLAY)
         {
            this.onPause();
         }
         if(this.url != null)
         {
            BrowserUtil.openBlankWindow(this.url,stage);
         }
         else if(R.controlbar.logoClkURL != null)
         {
            BrowserUtil.openBlankWindow(R.controlbar.logoClkURL,stage);
         }
         else
         {
            BrowserUtil.openBlankWindow("http://www.letv.com",stage);
         }
         
      }
      
      private function onDefinitionVip(param1:ControlBarEvent) : void
      {
         var _loc2_:ControlBarEvent = new ControlBarEvent(ControlBarEvent.DEFINITION_VIP);
         _loc2_.dataProvider = param1.dataProvider;
         dispatchEvent(_loc2_);
      }
      
      private function onDefinitionRegulate(param1:ControlBarEvent) : void
      {
         var _loc2_:ControlBarEvent = new ControlBarEvent(ControlBarEvent.DEFINITION_REGULATE);
         _loc2_.dataProvider = param1.dataProvider;
         dispatchEvent(_loc2_);
      }
      
      public function setDefinitionBtn(param1:String) : void
      {
         if(this.definitionUI != null)
         {
            this.definitionUI.setData(param1,sdk.getDefaultDefinition(),sdk.getDefinitionList(),sdk.getDefinitionMatchList(),true);
         }
      }
   }
}
