package com.letv.player.view.plugin
{
   import com.letv.player.facade.MyMediator;
   import com.letv.player.notify.ExtendNotify;
   import com.letv.player.notify.LogicNotify;
   import com.letv.player.notify.GlobalNofity;
   import org.puremvc.as3.interfaces.INotification;
   import com.letv.store.ExtendUI_2;
   import com.letv.store.events.ExtendEvent;
   import flash.external.ExternalInterface;
   import com.letv.pluginsAPI.api.CallBackAPI;
   import com.letv.player.components.types.SleepState;
   import flash.events.Event;
   import com.letv.player.notify.AssistNotify;
   import com.letv.pluginsAPI.infoTip.InfoTipStyle;
   import com.alex.core.Application;
   
   public class ExtendMediator extends MyMediator
   {
      
      public static const NAME:String = "extendMediator";
      
      private var callbackinited:Boolean;
      
      private var extend:ExtendUI_2;
      
      public function ExtendMediator(param1:Object)
      {
         super(NAME,param1);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ExtendNotify.DISPLAY_EXTEND_LIST,ExtendNotify.DISPLAY_EXTEND_PLUGIN,ExtendNotify.REMOVE_EXTEND_PLUGIN,LogicNotify.PLAYER_INIT,LogicNotify.VIDEO_NEXT,LogicNotify.VIDEO_STOP,GlobalNofity.GLOBAL_RESIZE];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var notification:INotification = param1;
         switch(notification.getName())
         {
            case LogicNotify.PLAYER_INIT:
               this.addCallback();
               break;
            case LogicNotify.VIDEO_NEXT:
            case LogicNotify.VIDEO_STOP:
               if(this.extend != null)
               {
                  this.extend.removePlugin();
                  this.extend.displayList(false);
               }
               break;
            case ExtendNotify.DISPLAY_EXTEND_LIST:
               if(this.extend != null)
               {
                  this.extend.displayList();
               }
               break;
            case ExtendNotify.DISPLAY_EXTEND_PLUGIN:
               try
               {
                  this.extend.displayPlugin(String(notification.getBody()),sdk.getDefinitionList().testurl);
               }
               catch(e:Error)
               {
               }
               break;
            case ExtendNotify.REMOVE_EXTEND_PLUGIN:
               if(this.extend != null)
               {
                  this.extend.removePlugin();
               }
               break;
            case GlobalNofity.GLOBAL_RESIZE:
               if(this.extend != null)
               {
                  this.extend.resize();
               }
               break;
         }
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         this.extend = new ExtendUI_2(viewComponent.skin,R.extension.plugins,sdk);
         this.extend.addEventListener(ExtendEvent.EXTEND_COMMAND,this.onExtendCommand);
         this.extend.addEventListener(ExtendEvent.EXTEND_INFOTIP,this.onExtendInfotip);
      }
      
      private function addCallback() : void
      {
         if(this.callbackinited)
         {
            return;
         }
         this.callbackinited = true;
         try
         {
            if(ExternalInterface.available)
            {
               ExternalInterface.addCallback(CallBackAPI.PLAY_NEW_ID,this.playNewId);
               ExternalInterface.addCallback(CallBackAPI.PAUSE_VIDEO,this.pauseVideo);
               ExternalInterface.addCallback(CallBackAPI.RESUME_VIDEO,this.resumeVideo);
               ExternalInterface.addCallback(CallBackAPI.SHUT_DOWN,this.shutDown);
               ExternalInterface.addCallback(CallBackAPI.SEEK_TO,this.seekTo);
               ExternalInterface.addCallback(CallBackAPI.SET_VOLUME,this.setVolume);
               ExternalInterface.addCallback(CallBackAPI.START_UP,this.startUp);
               ExternalInterface.addCallback(CallBackAPI.SET_NEXT_BTN_VISIBLE_STATUS,this.setNextBtnVisibleStatus);
               ExternalInterface.addCallback(CallBackAPI.SET_SCREEN_NORMAL_DOCK_VISIBLE,this.setScreenNormalDockVisible);
               ExternalInterface.addCallback(CallBackAPI.SET_SCREEN_NORMAL_VIDEO_LIST_BTN_VISIBLE,this.setScreenNormalVideoListBtnVisible);
               ExternalInterface.addCallback(CallBackAPI.SET_VIDEO_RECT,null);
               ExternalInterface.addCallback(CallBackAPI.SET_AUTO_REPLAY,null);
               ExternalInterface.addCallback(CallBackAPI.SET_VIDEO_PERCENT,null);
               ExternalInterface.addCallback(CallBackAPI.SET_DEFINITION,sdk.setDefinition);
               ExternalInterface.addCallback(CallBackAPI.OUT_FULLSCREEN,this.outFullScreen);
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function onExtendCommand(param1:ExtendEvent) : void
      {
         var event:ExtendEvent = param1;
         try
         {
            switch(event.command)
            {
               case CallBackAPI.SHUT_DOWN:
                  sendNotification(LogicNotify.VIDEO_SLEEP,{
                     "state":SleepState.PLAY_TESTSPEED,
                     "clear":false
                  });
                  break;
               case CallBackAPI.SET_NODE:
                  this.extend.removePlugin();
                  sendNotification(LogicNotify.SET_NODE,event);
                  break;
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function playNewId(param1:* = null) : void
      {
         if(sdk != null)
         {
            if(param1 is Event)
            {
               facade.sendNotification(LogicNotify.PLAY_NEW_ID,param1["dataProvider"]);
            }
            else
            {
               facade.sendNotification(LogicNotify.PLAY_NEW_ID,param1);
            }
         }
      }
      
      private function pauseVideo() : void
      {
         if(sdk != null)
         {
            facade.sendNotification(LogicNotify.VIDEO_PAUSE);
         }
      }
      
      private function resumeVideo() : void
      {
         if(sdk != null)
         {
            facade.sendNotification(LogicNotify.VIDEO_RESUME);
         }
      }
      
      private function replayVideo() : void
      {
         if(sdk != null)
         {
            facade.sendNotification(LogicNotify.VIDEO_REPLAY);
         }
      }
      
      private function closeVideo(param1:Boolean = true) : void
      {
         if(sdk != null)
         {
            sdk.closeVideo(param1);
         }
      }
      
      private function shutDown(param1:* = null) : void
      {
         if(sdk != null)
         {
            sdk.shutDown(param1);
            sendNotification(LogicNotify.VIDEO_NEXT);
            sendNotification(LogicNotify.VIDEO_SLEEP,{"state":SleepState.PLAY_BEFORE});
         }
      }
      
      private function seekTo(param1:Number) : void
      {
         if(sdk != null)
         {
            sendNotification(LogicNotify.SEEK_TO,param1);
         }
      }
      
      private function setVolume(param1:Number) : void
      {
         if(sdk != null)
         {
            sendNotification(LogicNotify.SET_VOLUME,param1);
            sendNotification(GlobalNofity.GLOBAL_SET_VOLUME,param1);
         }
      }
      
      private function startUp() : void
      {
         if(sdk != null)
         {
            sendNotification(LogicNotify.START_UP);
         }
      }
      
      private function onExtendInfotip(param1:ExtendEvent) : void
      {
         sendNotification(AssistNotify.DISPLAY_INFOTIP,{
            "type":param1.dataProvider,
            "style":InfoTipStyle.TIP_EXTEND_PLUGIN
         });
      }
      
      private function setNextBtnVisibleStatus(param1:String) : void
      {
         R.controlbar.nextBtnStatus = param1;
         sendNotification(GlobalNofity.GLOBAL_RESIZE);
      }
      
      private function setScreenNormalDockVisible(param1:Boolean) : void
      {
         R.skin.screenNormalDockVisible = param1;
         sendNotification(GlobalNofity.GLOBAL_RESIZE);
      }
      
      private function setScreenNormalVideoListBtnVisible(param1:Boolean) : void
      {
         R.skin.screenNormalVideoListBtnVisible = param1;
         sendNotification(GlobalNofity.GLOBAL_RESIZE);
      }
      
      private function outFullScreen() : void
      {
         Application.application.systemManager.setFullScreen(false);
      }
   }
}
