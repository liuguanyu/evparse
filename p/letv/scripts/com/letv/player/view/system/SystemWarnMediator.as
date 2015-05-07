package com.letv.player.view.system
{
   import com.letv.player.facade.MyMediator;
   import com.letv.player.components.outter.warn.OutterWarnUI;
   import com.letv.player.notify.ErrorNotify;
   import com.letv.player.notify.OutterNotify;
   import com.letv.player.notify.LogicNotify;
   import com.letv.player.notify.GlobalNofity;
   import com.letv.player.notify.AssistNotify;
   import com.letv.player.notify.AdNotify;
   import org.puremvc.as3.interfaces.INotification;
   import com.alex.utils.BrowserUtil;
   import com.letv.player.components.types.SleepState;
   import com.letv.player.components.outter.warn.OutterWarnEvent;
   import com.letv.player.notify.InitNotify;
   import com.letv.player.notify.ExtendNotify;
   
   public class SystemWarnMediator extends MyMediator
   {
      
      public static const NAME:String = "systemWarnMediator";
      
      private var warn:OutterWarnUI;
      
      private var errorType:String;
      
      private var errorCode:String = "0";
      
      public function SystemWarnMediator(param1:Object)
      {
         super(NAME,param1);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ErrorNotify.ERROR_IN_CREATION,ErrorNotify.ERROR_IN_LOAD_SDK,ErrorNotify.ERROR_IN_SDK,OutterNotify.DISPLAY_DEBUG_FEEDBACK,OutterNotify.REMOVE_ALL_OUTTER,LogicNotify.VIDEO_START,LogicNotify.VIDEO_SLEEP,LogicNotify.VIDEO_NEXT,GlobalNofity.GLOBAL_RESIZE,AssistNotify.DISPLAY_POPUP,AdNotify.AD_PAUSE_IMPRESSION,LogicNotify.PLAYER_FIRSTLOOK,LogicNotify.PLAYER_LOGINLOOK];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         switch(param1.getName())
         {
            case ErrorNotify.ERROR_IN_CREATION:
            case ErrorNotify.ERROR_IN_LOAD_SDK:
            case ErrorNotify.ERROR_IN_SDK:
               R.log.append(this + " Fault " + param1.getName(),"fault");
               this.errorType = param1.getName();
               this.displayWarn("播放错误",param1.getBody());
               break;
            case OutterNotify.DISPLAY_DEBUG_FEEDBACK:
               this.displayFeedback();
               break;
            case OutterNotify.REMOVE_ALL_OUTTER:
            case AssistNotify.DISPLAY_POPUP:
            case AdNotify.AD_PAUSE_IMPRESSION:
            case LogicNotify.VIDEO_START:
            case LogicNotify.VIDEO_AUTH_VALID:
            case LogicNotify.VIDEO_SLEEP:
            case LogicNotify.VIDEO_NEXT:
            case LogicNotify.PLAYER_FIRSTLOOK:
            case LogicNotify.PLAYER_LOGINLOOK:
               this.closeWarn(param1.getName(),param1.getBody());
               break;
            case GlobalNofity.GLOBAL_RESIZE:
               if(this.warn != null)
               {
                  this.warn.resize();
               }
               break;
         }
      }
      
      private function uploadErrorLog() : void
      {
         var value:Object = null;
         try
         {
            value = {};
            value.mid = R.flashvars.mmsid;
            value.vid = R.flashvars.vid;
            value.ch = R.coops.typeFrom;
            value.ver = R.plugins.VERSION;
            value.url = encodeURIComponent(BrowserUtil.url);
            value.errno = this.errorCode;
            R.stat.uploadErrorLog(value);
         }
         catch(e:Error)
         {
         }
      }
      
      private function uploadUserFeedback(param1:Object) : void
      {
         var videodata:String = null;
         var value:Object = param1;
         try
         {
            if(value == null)
            {
               value = {};
            }
            if(sdk != null)
            {
               value.errno = this.errorCode;
               sdk.sendFeedback(value);
            }
            else
            {
               value.data = videodata;
               videodata = "";
               videodata = videodata + ("mmsid=" + R.flashvars.mmsid);
               videodata = videodata + ("vid=" + R.flashvars.vid);
               videodata = videodata + ("typeFrom=" + R.coops.typeFrom);
               videodata = videodata + ("version=" + R.plugins.VERSION);
               videodata = videodata + ("ref=" + encodeURIComponent(BrowserUtil.referer));
               videodata = videodata + ("errno=" + this.errorCode);
               R.stat.uploadUserFeedback(value);
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function displayWarn(param1:String, param2:Object) : void
      {
         sendNotification(LogicNotify.VIDEO_SLEEP,{"state":SleepState.PLAY_ERROR});
         this.errorCode = param2.errorCode;
         if(this.warn == null)
         {
            this.warn = new OutterWarnUI();
         }
         viewComponent.addElement(this.warn);
         this.warn.addEventListener(OutterWarnEvent.REFRESH,this.onRefresh);
         this.warn.addEventListener(OutterWarnEvent.FEEDBACK,this.onFeedback);
         this.warn.addEventListener(OutterWarnEvent.FAQ_PAGE,this.onFaqPage);
         this.warn.addEventListener(OutterWarnEvent.MAIN_PAGE,this.onMainPage);
         this.warn.addEventListener(OutterWarnEvent.CHANGE_NODE,this.onChangeNode);
         this.warn.displayError("error",this.errorCode);
         if(this.errorType != ErrorNotify.ERROR_IN_SDK)
         {
            this.uploadErrorLog();
         }
      }
      
      private function displayFeedback() : void
      {
         sendNotification(AssistNotify.HIDE_POPUP);
         if(this.warn == null)
         {
            this.warn = new OutterWarnUI();
         }
         viewComponent.addElement(this.warn);
         this.warn.addEventListener(OutterWarnEvent.FAQ_PAGE,this.onFaqPage);
         this.warn.addEventListener(OutterWarnEvent.FEEDBACK,this.onFeedback);
         this.warn.displayFeedback();
      }
      
      private function closeWarn(param1:String = null, param2:Object = null) : void
      {
         if(!(param1 == LogicNotify.VIDEO_SLEEP && param2.state == SleepState.PLAY_ERROR))
         {
            this.errorCode = "0";
            this.errorType = null;
         }
         this.hideWarn();
      }
      
      private function onRefresh(param1:OutterWarnEvent = null) : void
      {
         this.hideWarn();
         switch(this.errorType)
         {
            case ErrorNotify.ERROR_IN_CREATION:
               sendNotification(InitNotify.INIT_CREATION);
               break;
            case ErrorNotify.ERROR_IN_LOAD_SDK:
               sendNotification(InitNotify.INIT_PLUGIN);
               break;
            case ErrorNotify.ERROR_IN_SDK:
               sendNotification(LogicNotify.START_UP);
               break;
            default:
               sendNotification(LogicNotify.START_UP);
         }
      }
      
      private function hideWarn() : void
      {
         if(!(this.warn == null) && !(this.warn.parent == null))
         {
            try
            {
               viewComponent.removeElement(this.warn);
            }
            catch(e:Error)
            {
            }
            this.warn.removeEventListener(OutterWarnEvent.REFRESH,this.onRefresh);
            this.warn.removeEventListener(OutterWarnEvent.FEEDBACK,this.onFeedback);
            this.warn.removeEventListener(OutterWarnEvent.FAQ_PAGE,this.onFaqPage);
            this.warn.removeEventListener(OutterWarnEvent.MAIN_PAGE,this.onMainPage);
            this.warn.removeEventListener(OutterWarnEvent.CHANGE_NODE,this.onChangeNode);
         }
      }
      
      private function onFeedback(param1:OutterWarnEvent) : void
      {
         this.uploadUserFeedback(param1.dataProvider);
      }
      
      private function onFaqPage(param1:OutterWarnEvent) : void
      {
         BrowserUtil.openBlankWindow("http://www.letv.com/help/index.html",stage);
      }
      
      private function onMainPage(param1:OutterWarnEvent) : void
      {
         BrowserUtil.openSelfWindow("http://www.letv.com");
      }
      
      private function onChangeNode(param1:OutterWarnEvent) : void
      {
         sendNotification(ExtendNotify.DISPLAY_EXTEND_PLUGIN,"extend_plugin_testspeed");
      }
   }
}
