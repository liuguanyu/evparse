package com.letv.player.view.plugin
{
   import com.letv.player.facade.MyMediator;
   import flash.display.Shape;
   import com.letv.player.components.sleep.SleepUI;
   import com.letv.player.notify.GlobalNofity;
   import com.letv.player.notify.LogicNotify;
   import com.letv.player.notify.AdNotify;
   import com.letv.player.notify.AssistNotify;
   import com.letv.player.notify.OutterNotify;
   import com.letv.player.notify.ErrorNotify;
   import org.puremvc.as3.interfaces.INotification;
   import com.letv.player.components.types.SleepState;
   import com.letv.pluginsAPI.ad.ADV;
   import com.letv.pluginsAPI.PlayerEvent;
   import flash.events.MouseEvent;
   import flash.events.Event;
   import com.letv.pluginsAPI.stat.PageDebugLog;
   import com.alex.utils.BrowserUtil;
   import com.letv.player.notify.LoadNotify;
   import com.letv.player.notify.RecommendNotify;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import com.letv.pluginsAPI.kernel.Config;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class SdkMediator extends MyMediator
   {
      
      public static const NAME:String = "sdkMediator";
      
      private var shape:Shape;
      
      private var sleep:SleepUI;
      
      private var loopInter:int;
      
      private var clkTimeout:int;
      
      private var videoVolume:Number = -1;
      
      public function SdkMediator(param1:Object)
      {
         this.shape = new Shape();
         super(NAME,param1);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [GlobalNofity.GLOBAL_STAISTICS,GlobalNofity.GLOBAL_RESIZE,GlobalNofity.GLOBAL_CHANGE_ROTATION,LogicNotify.PLAYER_INIT,LogicNotify.SET_NODE,LogicNotify.SET_VOLUME,LogicNotify.VIDEO_NEXT,LogicNotify.START_UP,LogicNotify.VIDEO_SLEEP,LogicNotify.VIDEO_START,LogicNotify.SEEK_TO,LogicNotify.VIDEO_REPLAY,LogicNotify.VIDEO_PAUSE,LogicNotify.VIDEO_RESUME,LogicNotify.PLAY_NEW_ID,AdNotify.AD_START,AssistNotify.DISPLAY_POPUP,OutterNotify.DISPLAY_DEBUG_FEEDBACK,ErrorNotify.ERROR_IN_SDK];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = NaN;
         switch(param1.getName())
         {
            case GlobalNofity.GLOBAL_STAISTICS:
               sdk.sendStatistics(param1.getBody());
               break;
            case GlobalNofity.GLOBAL_RESIZE:
               this.drawClkArea();
               if(this.sleep != null)
               {
                  this.sleep.resize();
               }
               break;
            case GlobalNofity.GLOBAL_CHANGE_ROTATION:
               sdk.setVideoRotation(int(param1.getBody()));
               break;
            case LogicNotify.PLAYER_INIT:
               if(!R.flashvars.autoplay)
               {
                  sendNotification(LogicNotify.VIDEO_SLEEP,{"state":SleepState.PLAY_BEFORE});
               }
               break;
            case LogicNotify.VIDEO_NEXT:
               this.setLoop(false);
               break;
            case LogicNotify.SET_NODE:
               this.setEnabled(false);
               sdk.setDefinition(null,param1.getBody()["dataProvider"],false,false,true);
               break;
            case LogicNotify.SET_VOLUME:
               sdk.setVolume(Number(param1.getBody()));
               break;
            case LogicNotify.START_UP:
               this.displaySleep(false);
               this.addListener();
               sdk.startUp();
               break;
            case LogicNotify.VIDEO_SLEEP:
               this.onPlayerSleep(param1.getBody());
               break;
            case LogicNotify.VIDEO_START:
               this.setEnabled(true);
               break;
            case LogicNotify.SEEK_TO:
               this.displaySleep(false);
               this.setDelay(false);
               this.setLoop(true);
               this.addListener();
               _loc2_ = Number(param1.getBody());
               if(_loc2_ >= 0)
               {
                  sdk.seekTo(_loc2_);
               }
               break;
            case LogicNotify.VIDEO_REPLAY:
               this.displaySleep(false);
               this.addListener();
               sdk.replayVideo();
               this.setLoop(true);
               break;
            case LogicNotify.VIDEO_PAUSE:
               if(param1.getBody() == "noad")
               {
                  sdk.pauseVideoNoAd();
               }
               else
               {
                  sdk.pauseVideo();
               }
               break;
            case LogicNotify.VIDEO_RESUME:
               sdk.resumeVideo();
               this.setEnabled(true);
               break;
            case LogicNotify.PLAY_NEW_ID:
               this.playNewId(param1.getBody());
               break;
            case AdNotify.AD_START:
               this.setEnabled(false);
               break;
            case ErrorNotify.ERROR_IN_SDK:
               break;
            case AssistNotify.DISPLAY_POPUP:
            case OutterNotify.DISPLAY_DEBUG_FEEDBACK:
               sdk.hidePauseAd();
               break;
         }
      }
      
      override public function onRegister() : void
      {
         var visualFlashvars:Object = null;
         super.onRegister();
         try
         {
            this.addListener();
            visualFlashvars = R.flashvars.flashvars;
            visualFlashvars["pccsData"] = R.plugins.pccs;
            visualFlashvars["skinnable"] = 0;
            visualFlashvars["adv"] = ADV.V_V2;
            visualFlashvars["showJumpAd"] = "1";
            sdk.setFlashvars(visualFlashvars);
            viewComponent.addChild(sdk.instance);
            viewComponent.addChild(this.shape);
         }
         catch(e:Error)
         {
            R.log.append("[UI V2]KernelMediator.onRegister Error " + e.message,"error");
         }
      }
      
      private function drawClkArea() : void
      {
         if(viewComponent.stage != null)
         {
            this.shape.graphics.clear();
            this.shape.graphics.beginFill(0,0);
            this.shape.graphics.drawRect(0,0,viewComponent.stage.stageWidth,viewComponent.stage.stageHeight);
            this.shape.graphics.endFill();
            viewComponent.graphics.clear();
            viewComponent.graphics.beginFill(0,0);
            viewComponent.graphics.drawRect(0,0,viewComponent.stage.stageWidth,viewComponent.stage.stageHeight);
            viewComponent.graphics.endFill();
         }
      }
      
      private function addListener() : void
      {
         this.setEnabled(true);
         if(sdk != null)
         {
            sdk.addEventListener(PlayerEvent.PLAY_STATE,this.onSdkState);
         }
      }
      
      private function removeListener() : void
      {
         this.setLoop(false);
         this.setDelay(false);
         this.setEnabled(false);
         if(sdk != null)
         {
            sdk.removeEventListener(PlayerEvent.PLAY_STATE,this.onSdkState);
         }
      }
      
      private function setEnabled(param1:Boolean) : void
      {
         if(param1)
         {
            viewComponent.doubleClickEnabled = true;
            viewComponent.addEventListener(MouseEvent.CLICK,this.onClk);
            viewComponent.addEventListener(MouseEvent.DOUBLE_CLICK,this.onDoubleClk);
         }
         else
         {
            viewComponent.doubleClickEnabled = false;
            viewComponent.removeEventListener(MouseEvent.CLICK,this.onClk);
            viewComponent.removeEventListener(MouseEvent.DOUBLE_CLICK,this.onDoubleClk);
         }
      }
      
      private function onSdkState(param1:Event) : void
      {
         var _loc2_:Object = null;
         switch(param1["state"])
         {
            case "loopOnKernel":
               return;
            case "playerInit":
               this.onPlayerInit();
               break;
            case "videoAuthValid":
               this.onUserAuthValid(param1["dataProvider"]);
               break;
            case "adHeadLoadComplete":
               break;
            case "videoStartReady":
               break;
            case "adHeadPlayStart":
            case "adTailPlayStart":
               layer.adNormalLayer();
               sendNotification(AdNotify.AD_START);
               break;
            case "adInsertPlayStart":
               layer.adNormalLayer();
               sendNotification(LogicNotify.VIDEO_PAUSE);
               sendNotification(AdNotify.AD_START);
               break;
            case "adHeadPlayNone":
            case "adHeadPlayComplete":
               if(!sdk.getPlayState().canPlay && !param1["dataProvider"])
               {
                  sendNotification(AssistNotify.DISPLAY_LOADING,0);
               }
               if(this.videoVolume > 0)
               {
                  sendNotification(LogicNotify.SET_VOLUME,this.videoVolume);
                  sendNotification(GlobalNofity.GLOBAL_SET_VOLUME,this.videoVolume);
               }
               break;
            case "adInsertPlayComplete":
               break;
            case "adTailPlayComplete":
               break;
            case "adPauseImpression":
               sendNotification(AdNotify.AD_PAUSE_IMPRESSION);
               break;
            case "videoNext":
               this.onPlayerNext(param1["dataProvider"]);
               break;
            case "swapDefinition":
               sendNotification(LogicNotify.SWAP_DEFINITION);
               break;
            case "videoStart":
               if(R.flashvars.debugJs)
               {
                  PageDebugLog.getInstance().callJsLog(PageDebugLog.VIDEO_START);
               }
               this.onPlayerStart(param1["dataProvider"]);
               break;
            case "videoPause":
               sendNotification(LogicNotify.VIDEO_PAUSE);
               break;
            case "videoResume":
               sendNotification(LogicNotify.VIDEO_RESUME);
               break;
            case "videoEmpty":
               _loc2_ = param1["dataProvider"];
               this.onPlayerEmpty();
               break;
            case "videoFull":
               this.onPlayerFull();
               break;
            case "videoStop":
               this.onPlayerStop(param1["dataProvider"]);
               break;
            case "videoSpeed":
               sendNotification(LogicNotify.VIDEO_SPEED,sdk.getDownloadSpeed());
               break;
            case "showRecommend":
               this.onPlayerShowRecommend();
               break;
            case "displayTrylook":
               this.onPlayerDisplayTrylook();
               break;
            case "displayPopup":
               sendNotification(AssistNotify.DISPLAY_POPUP,param1["dataProvider"]);
               break;
            case "displayInfotip":
               sendNotification(AssistNotify.DISPLAY_INFOTIP,param1["dataProvider"]);
               break;
            case "displayLoading":
               sendNotification(AssistNotify.DISPLAY_LOADING,1);
               break;
            case "errorInConfig":
            case "errorInLoadPlugins":
            case "errorInKernel":
               if(R.flashvars.debugJs)
               {
                  PageDebugLog.getInstance().callJsLog(PageDebugLog.VIDEO_ERROR);
               }
               this.onPlayerError(param1["dataProvider"]);
               break;
            case "playerFirstlook":
               main.systemManager.setFullScreen(false);
               sendNotification(LogicNotify.PLAYER_FIRSTLOOK,param1["dataProvider"]);
               break;
            case "playerLoginlook":
               sendNotification(LogicNotify.PLAYER_LOGINLOOK);
               break;
            case "teletexeTip":
               sendNotification(LogicNotify.TELETEXT_TIP,param1["dataProvider"]);
               break;
            case "swapcomplete":
               sendNotification(LogicNotify.SWAP_COMPLETE,param1["dataProvider"]);
               break;
         }
      }
      
      private function onClk(param1:MouseEvent) : void
      {
         this.setDelay(true);
         main.browserManager.callScript("avdTCPage");
         main.browserManager.callScript("clickPlayerSwapStatus");
         if(!(R.flashvars.playClkUrl == null) && !(R.flashvars.playClkUrl == ""))
         {
            BrowserUtil.openBlankWindow(R.flashvars.playClkUrl,stage);
         }
      }
      
      private function onDoubleClk(param1:MouseEvent) : void
      {
         this.setDelay(false);
         main.systemManager.setFullScreen(main.fullscreen?false:true,sdk.getFullscreenInput());
      }
      
      private function onPlayerInit() : void
      {
         sdk.setContinuePlay(true);
         sendNotification(LogicNotify.PLAYER_INIT);
      }
      
      private function onUserAuthValid(param1:Object) : void
      {
         R.flashvars.cid = param1["cid"];
         R.flashvars.pid = param1["pid"];
         this.videoVolume = param1.volume;
         sendNotification(LogicNotify.VIDEO_AUTH_VALID,param1);
      }
      
      private function onPlayerStart(param1:Object) : void
      {
         R.flashvars.cid = param1["cid"];
         R.flashvars.pid = param1["pid"];
         sendNotification(LogicNotify.VIDEO_START,param1);
         this.setLoop(true);
         this.addListener();
         if(R.flashvars.filter)
         {
            sendNotification(LoadNotify.FILTER_DATA_GET,param1["vid"]);
         }
         sendNotification(LoadNotify.PUSH_START);
      }
      
      private function onPlayerFull() : void
      {
         sendNotification(LogicNotify.VIDEO_FULL);
      }
      
      private function onPlayerEmpty() : void
      {
         sendNotification(LogicNotify.VIDEO_EMPTY);
      }
      
      private function onPlayerStop(param1:Object) : void
      {
         var _loc2_:* = 0;
         this.setLoop(false);
         this.setDelay(false);
         this.setEnabled(false);
         if(!param1.isTrylook)
         {
            _loc2_ = param1["playNext"];
            if(_loc2_ == 1)
            {
               sdk.playNext(true);
               return;
            }
            sendNotification(LogicNotify.VIDEO_STOP,param1);
         }
      }
      
      private function onPlayerShowRecommend() : void
      {
         if(R.flashvars.picEndUrl != null)
         {
            sendNotification(LogicNotify.VIDEO_SLEEP,{
               "state":SleepState.PLAY_AFTER,
               "alive":true
            });
         }
         else
         {
            sendNotification(RecommendNotify.SHOW_RECOMMEND);
         }
      }
      
      private function onPlayerDisplayTrylook() : void
      {
         sendNotification(AssistNotify.DISPLAY_TRYLOOK);
      }
      
      private function onPlayerNext(param1:Boolean = false) : void
      {
         sendNotification(LoadNotify.FILTER_DATA_OVER);
         sendNotification(LogicNotify.VIDEO_NEXT,param1);
      }
      
      private function onPlayerError(param1:Object) : void
      {
         this.setLoop(false);
         sendNotification(ErrorNotify.ERROR_IN_SDK,param1);
      }
      
      private function onPlayerSleep(param1:Object) : void
      {
         this.setLoop(false);
         this.setEnabled(false);
         if(param1.state == SleepState.PLAY_ING)
         {
            sendNotification(LogicNotify.VIDEO_PAUSE);
         }
         else if(!param1.hasOwnProperty("alive") || param1.alive == false)
         {
            sdk.closeVideo(!param1.hasOwnProperty("clear") || param1.clear == true);
         }
         
         this.displaySleep(true,param1.state);
      }
      
      private function playNewId(param1:Object) : void
      {
         var show:Boolean = false;
         var vid:Object = param1;
         try
         {
            if(vid != null)
            {
               show = sdk.getVideoSetting().nextvid == vid && (sdk.getPlayset().preload);
               sendNotification(LogicNotify.VIDEO_NEXT,show);
               sdk.playNewId(vid);
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function setLoop(param1:Boolean) : void
      {
         clearInterval(this.loopInter);
         if(param1)
         {
            this.onLoop();
            this.loopInter = setInterval(this.onLoop,Config.LOOP_ON_KERNEL);
         }
      }
      
      private function onLoop() : void
      {
         var _loc1_:Object = {
            "loadPercent":sdk.getLoadPercent(),
            "videoTime":sdk.getVideoTime()
         };
         sendNotification(LogicNotify.LOOP_ON_KERNEL,_loc1_);
      }
      
      private function setDelay(param1:Boolean) : void
      {
         clearTimeout(this.clkTimeout);
         if(param1)
         {
            this.clkTimeout = setTimeout(this.onDelay,Config.CLK_DELAY_TIME);
         }
      }
      
      private function onDelay() : void
      {
         sendNotification(LogicNotify.VIDEO_TOGGLE);
      }
      
      private function displaySleep(param1:Boolean = true, param2:int = 0) : void
      {
         if(param1)
         {
            layer.adNormalLayer();
            if(this.sleep == null)
            {
               this.sleep = new SleepUI(R.flashvars);
            }
            if(param2 == SleepState.PLAY_AFTER)
            {
               layer.sdkLayer.visible = false;
               layer.sleepLayer.addElement(this.sleep);
               this.sleep.showTail();
               return;
            }
            if(param2 == SleepState.PLAY_BEFORE)
            {
               layer.sdkLayer.visible = false;
               layer.sleepLayer.addElement(this.sleep);
               this.sleep.showHead();
               return;
            }
         }
         layer.sdkLayer.visible = true;
         if(!(this.sleep == null) && !(this.sleep.parent == null))
         {
            layer.sleepLayer.removeElement(this.sleep);
         }
      }
   }
}
