package com.letv.player.components.displayBar
{
   import com.letv.player.components.BaseConfigComponent;
   import com.letv.player.components.displayBar.classes.DockUI;
   import com.letv.player.components.displayBar.classes.ColorUI;
   import com.letv.player.components.displayBar.classes.ShareUI;
   import com.letv.player.components.displayBar.classes.FullScreenInputUI;
   import com.letv.player.components.displayBar.classes.LoopUI;
   import com.letv.player.components.displayBar.classes.VipAdUI;
   import com.letv.player.components.displayBar.classes.VipVideoUI;
   import com.letv.player.components.displayBar.classes.ScreenShotUI;
   import com.letv.player.components.displayBar.classes.ZanUI;
   import com.letv.player.components.displayBar.classes.VideoListUI;
   import com.letv.player.components.displayBar.classes.MoreSettingUI;
   import com.letv.player.components.displayBar.classes.ScanPopupUI;
   import com.letv.player.components.displayBar.classes.HotPopupUI;
   import com.letv.player.components.BaseAutoScalePopup;
   import com.letv.pluginsAPI.popup.PopupState;
   import com.letv.player.components.BaseRightDisplayPopup;
   import flash.events.Event;
   
   public class DisplayBarUI extends BaseConfigComponent
   {
      
      private var dockUI:DockUI;
      
      private var colorUI:ColorUI;
      
      private var shareUI:ShareUI;
      
      private var inputUI:FullScreenInputUI;
      
      private var loopUI:LoopUI;
      
      private var adUI:VipAdUI;
      
      private var videoadUI:VipVideoUI;
      
      private var screenshotUI:ScreenShotUI;
      
      private var zanUI:ZanUI;
      
      private var videolistUI:VideoListUI;
      
      private var moreUI:MoreSettingUI;
      
      private var uiStack:Object;
      
      private var scanPopupUI:ScanPopupUI;
      
      private var hotPopupUI:HotPopupUI;
      
      public function DisplayBarUI(param1:Object)
      {
         super(param1);
      }
      
      public function resize() : void
      {
         var _loc1_:BaseAutoScalePopup = null;
         if(stage != null)
         {
            this.dockUI.resize();
            for each(_loc1_ in this.uiStack)
            {
               if(_loc1_ != null)
               {
                  _loc1_.resize();
               }
            }
         }
      }
      
      public function removeAll() : void
      {
         if(this.dockUI != null)
         {
            this.dockUI.hide();
         }
         this.removePopup();
      }
      
      public function removePopup() : void
      {
         var _loc1_:BaseAutoScalePopup = null;
         for each(_loc1_ in this.uiStack)
         {
            if(_loc1_ != null)
            {
               _loc1_.hide();
            }
         }
      }
      
      public function setPlayNewID() : void
      {
         if(this.videolistUI != null)
         {
            this.videolistUI.setPlayNewID();
         }
      }
      
      public function showDock() : void
      {
         this.dockUI.show();
      }
      
      public function hideDock() : void
      {
         this.dockUI.hide();
      }
      
      public function setListData(param1:Object) : void
      {
         if(this.videolistUI != null)
         {
            this.videolistUI.setListData(param1);
         }
      }
      
      public function setCommentOver(param1:Object) : void
      {
         if(this.screenshotUI != null)
         {
            this.screenshotUI.setCommentBack(param1);
         }
      }
      
      public function setFilterDataOver(param1:Object) : void
      {
         if(this.moreUI != null)
         {
            this.moreUI.setGreenData(param1);
         }
      }
      
      public function displayPopup(param1:Object, param2:Object = null) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(param1 != null)
         {
            if(param1 is Array && param1.length > 0)
            {
               _loc3_ = param1[0];
               var param2:Object = param1[1];
            }
            else
            {
               _loc3_ = String(param1);
            }
         }
         for(_loc4_ in this.uiStack)
         {
            if(_loc4_ == _loc3_)
            {
               if(_loc3_ == PopupState.COLOR)
               {
                  this.uiStack[_loc4_].display(sdk.getVideoColor());
               }
               else if(_loc3_ == PopupState.ACC)
               {
                  this.uiStack[_loc4_].display(sdk.getPlayset());
               }
               else if(_loc3_ == PopupState.FULLSCREEN_INPUT)
               {
                  this.uiStack[_loc4_].display(sdk.getVideoSetting());
               }
               else if(_loc3_ == PopupState.SCREENSHOT_BOX)
               {
                  this.uiStack[_loc4_].display({
                     "info":sdk.getScreenShot(),
                     "playing":sdk.getPlayState()["playing"]
                  });
               }
               else if(_loc3_ == PopupState.VIP_VIDEO)
               {
                  this.uiStack[_loc4_].display({
                     "userinfo":sdk.getUserinfo(),
                     "definition":param2
                  });
               }
               else
               {
                  this.uiStack[_loc4_].display(param2);
               }
               
               
               
               
            }
            else
            {
               this.uiStack[_loc4_].hide();
            }
         }
      }
      
      public function setData(param1:Object) : void
      {
         if(this.shareUI != null)
         {
            this.shareUI.setData(param1);
         }
         if(this.dockUI != null)
         {
            this.dockUI.setData(param1);
         }
         if(this.videolistUI != null)
         {
            this.videolistUI.setData(param1);
         }
      }
      
      public function set dockAlpha(param1:Number) : void
      {
         this.dockUI.maxAlpha = param1;
      }
      
      public function get popupOpening() : Boolean
      {
         var _loc1_:BaseAutoScalePopup = null;
         for each(_loc1_ in this.uiStack)
         {
            if(!(_loc1_ == null) && (_loc1_.opening))
            {
               return true;
            }
         }
         return false;
      }
      
      public function refreshScreenShot() : void
      {
         this.screenshotUI.refresh(sdk.getScreenShot());
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this.x = this.y = 0;
         this.dockUI = new DockUI(skin["dock"]);
         this.colorUI = new ColorUI(skin["colorPopup"],PopupState.MORE_SETTING);
         this.shareUI = new ShareUI(skin["sharePopup"]);
         this.adUI = new VipAdUI(skin["adPopup"]);
         this.videoadUI = new VipVideoUI(skin["videoAdPopup"]);
         this.inputUI = new FullScreenInputUI(skin["fullscreenInputPopup"],PopupState.MORE_SETTING);
         if(skin.hasOwnProperty("loopPlayPopup"))
         {
            this.loopUI = new LoopUI(skin["loopPlayPopup"],PopupState.MORE_SETTING);
         }
         this.screenshotUI = new ScreenShotUI(skin["screenshotPopup"]);
         this.zanUI = new ZanUI(skin["zanPopup"]);
         this.videolistUI = new VideoListUI(skin["videolistPopup"]);
         this.moreUI = new MoreSettingUI(skin["morePopup"]);
         this.scanPopupUI = new ScanPopupUI(skin["scanPopup"]);
         this.hotPopupUI = new HotPopupUI(skin["hotPopup"],PopupState.MORE_SETTING);
         this.uiStack = {};
         this.uiStack[PopupState.COLOR] = this.colorUI;
         this.uiStack[PopupState.SHARE] = this.shareUI;
         this.uiStack[PopupState.SCREENSHOT_BOX] = this.screenshotUI;
         this.uiStack[PopupState.ZAN] = this.zanUI;
         this.uiStack[PopupState.VIP_AD] = this.adUI;
         this.uiStack[PopupState.VIP_VIDEO] = this.videoadUI;
         this.uiStack[PopupState.VIDEOLIST] = this.videolistUI;
         this.uiStack[PopupState.MORE_SETTING] = this.moreUI;
         this.uiStack[PopupState.FULLSCREEN_INPUT] = this.inputUI;
         this.uiStack[PopupState.TWOCODE] = this.scanPopupUI;
         this.uiStack[PopupState.HOT] = this.hotPopupUI;
         if(this.loopUI != null)
         {
            this.uiStack[PopupState.LOOP_PLAY_VIDEO] = this.loopUI;
         }
         this.addListener();
      }
      
      private function addListener() : void
      {
         var _loc1_:BaseAutoScalePopup = null;
         this.adUI.addEventListener(DisplayBarEvent.VIP_AD_CLOSE,this.onDisplayBarEvent);
         this.colorUI.addEventListener(DisplayBarEvent.CHANGE_FUNCTION,this.onDisplayBarEvent);
         this.zanUI.addEventListener(DisplayBarEvent.SCREENSHOT_RESUME_VIDEO,this.onDisplayBarEvent);
         this.screenshotUI.addEventListener(DisplayBarEvent.OVER_COMMENT,this.onCommentOver);
         this.screenshotUI.addEventListener(DisplayBarEvent.ADD_COMMENT,this.onDisplayBarEvent);
         this.screenshotUI.addEventListener(DisplayBarEvent.SCREENSHOT_PAUSE_VIDEO,this.onDisplayBarEvent);
         this.screenshotUI.addEventListener(DisplayBarEvent.SCREENSHOT_RESUME_VIDEO,this.onDisplayBarEvent);
         this.videolistUI.addEventListener(DisplayBarEvent.CHANGE_PLAY,this.onDisplayBarEvent);
         this.videolistUI.addEventListener(DisplayBarEvent.GET_VIDEO_LIST,this.onDisplayBarEvent);
         this.moreUI.addEventListener(DisplayBarEvent.CHANGE_FUNCTION,this.onDisplayBarEvent);
         this.dockUI.addEventListener(DisplayBarEvent.DOCK_SHARE,this.onDisplayBarEvent);
         this.dockUI.addEventListener(DisplayBarEvent.DOCK_CAMERA_SHARE,this.onDisplayBarEvent);
         this.dockUI.addEventListener(DisplayBarEvent.DOCK_VIDEO_LIST,this.onDisplayBarEvent);
         this.dockUI.addEventListener(DisplayBarEvent.DOCK_MORE,this.onDisplayBarEvent);
         this.dockUI.addEventListener(DisplayBarEvent.DOCK_GREEN,this.onDisplayBarEvent);
         for each(_loc1_ in this.uiStack)
         {
            if(_loc1_ is BaseRightDisplayPopup)
            {
               _loc1_.addEventListener(Event.CHANGE,this.onBaseRightClose);
            }
         }
      }
      
      private function removeListener() : void
      {
         var _loc1_:BaseAutoScalePopup = null;
         this.adUI.removeEventListener(DisplayBarEvent.VIP_AD_CLOSE,this.onDisplayBarEvent);
         this.colorUI.removeEventListener(DisplayBarEvent.CHANGE_FUNCTION,this.onDisplayBarEvent);
         this.zanUI.removeEventListener(DisplayBarEvent.SCREENSHOT_RESUME_VIDEO,this.onDisplayBarEvent);
         this.screenshotUI.removeEventListener(DisplayBarEvent.OVER_COMMENT,this.onCommentOver);
         this.screenshotUI.removeEventListener(DisplayBarEvent.ADD_COMMENT,this.onDisplayBarEvent);
         this.screenshotUI.removeEventListener(DisplayBarEvent.SCREENSHOT_PAUSE_VIDEO,this.onDisplayBarEvent);
         this.screenshotUI.removeEventListener(DisplayBarEvent.SCREENSHOT_RESUME_VIDEO,this.onDisplayBarEvent);
         this.videolistUI.removeEventListener(DisplayBarEvent.CHANGE_PLAY,this.onDisplayBarEvent);
         this.videolistUI.removeEventListener(DisplayBarEvent.GET_VIDEO_LIST,this.onDisplayBarEvent);
         this.moreUI.removeEventListener(DisplayBarEvent.CHANGE_FUNCTION,this.onDisplayBarEvent);
         this.dockUI.removeEventListener(DisplayBarEvent.DOCK_SHARE,this.onDisplayBarEvent);
         this.dockUI.removeEventListener(DisplayBarEvent.DOCK_CAMERA_SHARE,this.onDisplayBarEvent);
         this.dockUI.removeEventListener(DisplayBarEvent.DOCK_VIDEO_LIST,this.onDisplayBarEvent);
         this.dockUI.removeEventListener(DisplayBarEvent.DOCK_MORE,this.onDisplayBarEvent);
         this.dockUI.removeEventListener(DisplayBarEvent.DOCK_GREEN,this.onDisplayBarEvent);
         for each(_loc1_ in this.uiStack)
         {
            if(_loc1_ is BaseRightDisplayPopup)
            {
               _loc1_.removeEventListener(Event.CHANGE,this.onBaseRightClose);
            }
         }
      }
      
      private function onBaseRightClose(param1:Event) : void
      {
         dispatchEvent(new Event("globalMove"));
      }
      
      private function onCommentOver(param1:DisplayBarEvent) : void
      {
         this.displayPopup(PopupState.ZAN,param1.dataProvider);
      }
      
      private function onDisplayBarEvent(param1:DisplayBarEvent) : void
      {
         dispatchEvent(new DisplayBarEvent(param1.type,param1.dataProvider));
      }
   }
}
