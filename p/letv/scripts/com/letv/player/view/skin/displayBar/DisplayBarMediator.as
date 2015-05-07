package com.letv.player.view.skin.displayBar
{
   import com.letv.player.facade.MyMediator;
   import com.letv.player.components.displayBar.DisplayBarUI;
   import com.letv.player.notify.GlobalNofity;
   import com.letv.player.notify.LogicNotify;
   import com.letv.player.notify.AdNotify;
   import com.letv.player.notify.AssistNotify;
   import com.letv.player.notify.RecommendNotify;
   import com.letv.player.notify.LoadNotify;
   import org.puremvc.as3.interfaces.INotification;
   import com.letv.player.components.displayBar.DisplayBarEvent;
   import flash.events.Event;
   import com.letv.pluginsAPI.popup.PopupState;
   import com.letv.player.notify.ExtendNotify;
   import com.letv.player.notify.OutterNotify;
   
   public class DisplayBarMediator extends MyMediator
   {
      
      public static const NAME:String = "displayBarMediator";
      
      private var displayBarUI:DisplayBarUI;
      
      public function DisplayBarMediator(param1:Object)
      {
         super(NAME,param1);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [GlobalNofity.GLOBAL_RESIZE,GlobalNofity.GLOBAL_HIDE_CURSOR,GlobalNofity.GLOBAL_SHOW_CURSOR,LogicNotify.VIDEO_NEXT,LogicNotify.VIDEO_SLEEP,LogicNotify.VIDEO_AUTH_VALID,LogicNotify.VIDEO_STOP,LogicNotify.VIDEO_FULL,AdNotify.AD_PAUSE_IMPRESSION,AdNotify.AD_START,AssistNotify.DISPLAY_POPUP,AssistNotify.HIDE_POPUP,AssistNotify.DISPLAY_TRYLOOK,RecommendNotify.SHOW_RECOMMEND,LoadNotify.VIDEO_LIST_READY,LoadNotify.COMMENT_OVER,LoadNotify.FILTER_DATA_OVER,LogicNotify.PLAYER_FIRSTLOOK,LogicNotify.PLAYER_LOGINLOOK];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         switch(param1.getName())
         {
            case GlobalNofity.GLOBAL_RESIZE:
               this.displayBarUI.resize();
               break;
            case GlobalNofity.GLOBAL_HIDE_CURSOR:
               this.displayBarUI.hideDock();
               break;
            case GlobalNofity.GLOBAL_SHOW_CURSOR:
               this.displayBarUI.showDock();
               break;
            case LogicNotify.VIDEO_AUTH_VALID:
               this.displayBarUI.setData(param1.getBody());
               break;
            case LogicNotify.VIDEO_NEXT:
               this.displayBarUI.setPlayNewID();
            case LogicNotify.VIDEO_STOP:
            case LogicNotify.VIDEO_SLEEP:
            case AdNotify.AD_START:
            case AssistNotify.DISPLAY_TRYLOOK:
            case RecommendNotify.SHOW_RECOMMEND:
               this.displayBarUI.removeAll();
               break;
            case AdNotify.AD_PAUSE_IMPRESSION:
               this.displayBarUI.removePopup();
               break;
            case LogicNotify.VIDEO_FULL:
               this.displayBarUI.refreshScreenShot();
               break;
            case AssistNotify.DISPLAY_POPUP:
               this.displayBarUI.displayPopup(param1.getBody());
               break;
            case AssistNotify.HIDE_POPUP:
               this.displayBarUI.displayPopup(null);
               break;
            case LoadNotify.VIDEO_LIST_READY:
               this.displayBarUI.setListData(param1.getBody());
               break;
            case LoadNotify.COMMENT_OVER:
               this.displayBarUI.setCommentOver(param1.getBody());
               break;
            case LoadNotify.FILTER_DATA_OVER:
               this.displayBarUI.setFilterDataOver(param1.getBody());
               break;
            case LogicNotify.PLAYER_FIRSTLOOK:
            case LogicNotify.PLAYER_LOGINLOOK:
               this.displayBarUI.removeAll();
               break;
         }
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         this.displayBarUI = new DisplayBarUI(R.skin.displayBar);
         viewComponent.addElement(this.displayBarUI);
         this.addListener();
      }
      
      public function get popupOpening() : Boolean
      {
         return this.displayBarUI.popupOpening;
      }
      
      private function addListener() : void
      {
         this.displayBarUI.addEventListener(DisplayBarEvent.DOCK_MORE,this.onDisplayBarEvent);
         this.displayBarUI.addEventListener(DisplayBarEvent.DOCK_GREEN,this.onDisplayBarEvent);
         this.displayBarUI.addEventListener(DisplayBarEvent.DOCK_SHARE,this.onDisplayBarEvent);
         this.displayBarUI.addEventListener(DisplayBarEvent.DOCK_CAMERA_SHARE,this.onDisplayBarEvent);
         this.displayBarUI.addEventListener(DisplayBarEvent.DOCK_VIDEO_LIST,this.onDisplayBarEvent);
         this.displayBarUI.addEventListener(DisplayBarEvent.ADD_COMMENT,this.onDisplayBarEvent);
         this.displayBarUI.addEventListener(DisplayBarEvent.SCREENSHOT_PAUSE_VIDEO,this.onDisplayBarEvent);
         this.displayBarUI.addEventListener(DisplayBarEvent.SCREENSHOT_RESUME_VIDEO,this.onDisplayBarEvent);
         this.displayBarUI.addEventListener(DisplayBarEvent.VIP_AD_CLOSE,this.onDisplayBarEvent);
         this.displayBarUI.addEventListener(DisplayBarEvent.CHANGE_PLAY,this.onDisplayBarEvent);
         this.displayBarUI.addEventListener(DisplayBarEvent.GET_VIDEO_LIST,this.onDisplayBarEvent);
         this.displayBarUI.addEventListener(DisplayBarEvent.CHANGE_FUNCTION,this.onDisplayBarEvent);
         this.displayBarUI.addEventListener("globalMove",this.onGlobalMove);
      }
      
      private function onGlobalMove(param1:Event) : void
      {
         sendNotification(AssistNotify.MOUSE_MOVE);
      }
      
      private function onDisplayBarEvent(param1:DisplayBarEvent) : void
      {
         var _loc2_:Object = null;
         switch(param1.type)
         {
            case DisplayBarEvent.DOCK_MORE:
               sendNotification(AssistNotify.DISPLAY_POPUP,PopupState.MORE_SETTING);
               break;
            case DisplayBarEvent.DOCK_GREEN:
               sendNotification(AssistNotify.DISPLAY_HOT_FILTER,param1.dataProvider);
               break;
            case DisplayBarEvent.DOCK_SHARE:
               sendNotification(AssistNotify.DISPLAY_POPUP,PopupState.SHARE);
               break;
            case DisplayBarEvent.DOCK_CAMERA_SHARE:
               sendNotification(AssistNotify.DISPLAY_POPUP,PopupState.SCREENSHOT_BOX);
               break;
            case DisplayBarEvent.ADD_COMMENT:
               sendNotification(LoadNotify.COMMENT_ADD,{
                  "info":param1.dataProvider,
                  "setting":sdk.getVideoSetting(),
                  "time":int(sdk.getVideoTime())
               });
               break;
            case DisplayBarEvent.SCREENSHOT_PAUSE_VIDEO:
               sendNotification(LogicNotify.VIDEO_PAUSE,"noad");
               break;
            case DisplayBarEvent.SCREENSHOT_RESUME_VIDEO:
               sendNotification(LogicNotify.VIDEO_RESUME);
               break;
            case DisplayBarEvent.VIP_AD_CLOSE:
               if(sdk != null)
               {
                  sdk.resumeAd();
               }
               break;
            case DisplayBarEvent.DOCK_VIDEO_LIST:
               sendNotification(AssistNotify.DISPLAY_POPUP,PopupState.VIDEOLIST);
               break;
            case DisplayBarEvent.CHANGE_PLAY:
               _loc2_ = param1.dataProvider;
               if(_loc2_.hasOwnProperty("vid"))
               {
                  sendNotification(LogicNotify.PLAY_NEW_ID,_loc2_.vid);
               }
               break;
            case DisplayBarEvent.GET_VIDEO_LIST:
               if(sdk != null)
               {
                  sendNotification(LoadNotify.VIDEO_LIST_GET,{
                     "page":param1.dataProvider,
                     "settings":sdk.getVideoSetting()
                  });
               }
               break;
            case DisplayBarEvent.CHANGE_FUNCTION:
               switch(param1.dataProvider)
               {
                  case PopupState.NETWORK_TESTPSEED:
                     sendNotification(AssistNotify.DISPLAY_POPUP,null);
                     sendNotification(ExtendNotify.DISPLAY_EXTEND_PLUGIN,"extend_plugin_testspeed");
                     break;
                  case PopupState.FEEDBACK:
                     sendNotification(OutterNotify.DISPLAY_DEBUG_FEEDBACK);
                     break;
                  default:
                     sendNotification(AssistNotify.DISPLAY_POPUP,param1.dataProvider);
               }
               break;
         }
      }
   }
}
