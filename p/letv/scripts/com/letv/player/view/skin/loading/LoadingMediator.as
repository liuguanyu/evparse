package com.letv.player.view.skin.loading
{
   import com.letv.player.facade.MyMediator;
   import com.letv.player.components.loading.LoadingUI;
   import com.letv.player.notify.AssistNotify;
   import com.letv.player.notify.AdNotify;
   import com.letv.player.notify.GlobalNofity;
   import com.letv.player.notify.LogicNotify;
   import com.letv.player.notify.InitNotify;
   import com.letv.player.notify.ErrorNotify;
   import org.puremvc.as3.interfaces.INotification;
   import com.letv.player.components.types.SleepState;
   
   public class LoadingMediator extends MyMediator
   {
      
      public static const NAME:String = "loadingMediator";
      
      private var loadingUI:LoadingUI;
      
      public function LoadingMediator(param1:Object)
      {
         super(NAME,param1);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [AssistNotify.HIDE_LOADING,AssistNotify.DISPLAY_LOADING,AdNotify.AD_START,GlobalNofity.GLOBAL_RESIZE,LogicNotify.START_UP,LogicNotify.VIDEO_REPLAY,LogicNotify.VIDEO_START,LogicNotify.VIDEO_EMPTY,LogicNotify.VIDEO_FULL,LogicNotify.VIDEO_STOP,LogicNotify.VIDEO_NEXT,LogicNotify.VIDEO_SLEEP,LogicNotify.VIDEO_REPLAY,LogicNotify.VIDEO_RESUME,LogicNotify.SEEK_TO,InitNotify.INIT_PLUGIN,ErrorNotify.ERROR_IN_CREATION,ErrorNotify.ERROR_IN_LOAD_SDK,ErrorNotify.ERROR_IN_SDK,LogicNotify.PLAYER_FIRSTLOOK,AssistNotify.FIRSTLOOK,LogicNotify.PLAYER_LOGINLOOK];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var body:Object = null;
         var notification:INotification = param1;
         try
         {
            switch(notification.getName())
            {
               case GlobalNofity.GLOBAL_RESIZE:
                  this.loadingUI.resize();
                  break;
               case LogicNotify.VIDEO_EMPTY:
                  this.loadingUI.show(1);
                  break;
               case AdNotify.AD_START:
                  this.loadingUI.hide();
                  this.loadingUI.visible = false;
                  break;
               case LogicNotify.VIDEO_START:
                  this.loadingUI.hide();
                  this.loadingUI.visible = true;
                  break;
               case LogicNotify.SEEK_TO:
               case LogicNotify.VIDEO_REPLAY:
               case LogicNotify.VIDEO_RESUME:
                  if(!this.loadingUI.visible)
                  {
                     this.loadingUI.visible = true;
                  }
                  break;
               case AssistNotify.HIDE_LOADING:
               case LogicNotify.VIDEO_FULL:
               case LogicNotify.VIDEO_STOP:
               case ErrorNotify.ERROR_IN_CREATION:
               case ErrorNotify.ERROR_IN_LOAD_SDK:
               case ErrorNotify.ERROR_IN_SDK:
               case LogicNotify.PLAYER_FIRSTLOOK:
               case AssistNotify.FIRSTLOOK:
               case LogicNotify.PLAYER_LOGINLOOK:
                  this.loadingUI.hide();
                  break;
               case LogicNotify.START_UP:
               case InitNotify.INIT_PLUGIN:
               case LogicNotify.VIDEO_NEXT:
                  if(!notification.getBody())
                  {
                     this.loadingUI.visible = true;
                     this.loadingUI.show(0);
                  }
                  break;
               case LogicNotify.VIDEO_SLEEP:
                  body = notification.getBody();
                  if(body.state == SleepState.PLAY_BEFORE && R.flashvars.picStartUrl == null)
                  {
                     this.loadingUI.show(0);
                  }
                  else
                  {
                     this.loadingUI.hide();
                  }
                  if(!this.loadingUI.visible)
                  {
                     this.loadingUI.visible = true;
                  }
                  break;
               case LogicNotify.VIDEO_REPLAY:
                  this.loadingUI.show(1);
                  break;
               case AssistNotify.DISPLAY_LOADING:
                  this.loadingUI.show(Number(notification.getBody()));
                  break;
            }
         }
         catch(e:Error)
         {
         }
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         this.loadingUI = new LoadingUI();
         viewComponent.addElement(this.loadingUI);
      }
      
      public function setMainLoading(param1:Object) : void
      {
         this.loadingUI.setMainLoading(param1);
      }
      
      public function setData(param1:Object) : void
      {
         this.loadingUI.setData(param1);
      }
   }
}
