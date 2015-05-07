package com.letv.player.components.outter.warn
{
   import com.letv.player.components.BaseConfigComponent;
   import com.letv.player.components.outter.warn.classes.*;
   import flash.utils.clearTimeout;
   import com.letv.pluginsAPI.kernel.PlayerError;
   import com.greensock.TweenLite;
   import flash.utils.setTimeout;
   import com.letv.player.components.OutterWarn;
   
   public class OutterWarnUI extends BaseConfigComponent
   {
      
      private var otherErrorUI:OtherErrorUI;
      
      private var pluginErrorUI:PluginErrorUI;
      
      private var playErrorUI:PlayErrorUI;
      
      private var offlineErrorUI:OfflineErrorUI;
      
      private var nolineErrorUI:NolineErrorUI;
      
      private var blackErrorUI:BlackErrorUI;
      
      private var cnErrorUI:CNErrorUI;
      
      private var overSeaErrorUI:OverSeaErrorUI;
      
      private var hkErrorUI:HKErrorUI;
      
      private var adBlockErrorUI:AdBlockErrorUI;
      
      private var adBlockEnvErrorUI:AdBlockEnvErrorUI;
      
      private var feedbackUI:FeedbackUI;
      
      private var versionWarnUI:VersionWarningUI;
      
      private var latestError:BaseWarnPopup;
      
      private var authErrorUI:AuthErrorUI;
      
      private var uis:Array;
      
      private var sendDelayTime:int;
      
      public function OutterWarnUI()
      {
         super(new OutterWarn());
      }
      
      public function resize() : void
      {
         var i:uint = 0;
         if(stage != null)
         {
            if(skin.back != null)
            {
               skin.back.width = applicationWidth;
               skin.back.height = applicationHeight;
            }
            i = 0;
            while(i < this.uis.length)
            {
               try
               {
                  this.uis[i].autoResize();
               }
               catch(e:Error)
               {
               }
               i++;
            }
         }
      }
      
      public function displayFeedback() : void
      {
         this.latestError = null;
         this.displayError("feedback","N/A",false);
         this.latestError = null;
      }
      
      public function displayError(param1:String = "error", param2:String = "N/A", param3:Boolean = true) : void
      {
         var _loc4_:BaseWarnPopup = null;
         this.removeAll();
         clearTimeout(this.sendDelayTime);
         if(skin.back != null)
         {
            skin.back.visible = param3 && this.latestError;
         }
         switch(param1)
         {
            case "error":
               switch(param2)
               {
                  case PlayerError.FLASH_PLAYER_WARNING:
                     _loc4_ = this.versionWarnUI;
                     break;
                  case PlayerError.AD_BLOCK_PLUGIN:
                  case PlayerError.AD_BLOCK_SYSTEM:
                     _loc4_ = this.adBlockErrorUI;
                     break;
                  case PlayerError.AD_BLOCK_ENV:
                     _loc4_ = this.adBlockEnvErrorUI;
                     break;
                  case PlayerError.AUTH_CN_ERROR:
                     _loc4_ = this.cnErrorUI;
                     break;
                  case PlayerError.AUTH_OVERSEA_ERROR:
                     _loc4_ = this.overSeaErrorUI;
                     break;
                  case PlayerError.AUTH_HK_ERROR:
                     _loc4_ = this.hkErrorUI;
                     break;
                  case PlayerError.BLACK_LIST_ERROR:
                     _loc4_ = this.blackErrorUI;
                     break;
                  case 444:
                  case PlayerError.NEW_MMSID_AUTHTYPE_ERROR:
                     _loc4_ = this.authErrorUI;
                     break;
                  case PlayerError.VIDEO_EDIT_ERROR:
                     _loc4_ = this.nolineErrorUI;
                     break;
                  case PlayerError.VIDEO_RIGHT_ERROR:
                  case PlayerError.VIDEO_NONE_ERROR:
                     _loc4_ = this.offlineErrorUI;
                     break;
                  case PlayerError.PLUGINS_IO_ERROR:
                  case PlayerError.PLUGINS_OTHER_ERROR:
                  case PlayerError.PLUGINS_TIMEOUT_ERROR:
                  case PlayerError.PLUGINS_ANALY_ERROR:
                  case PlayerError.PLUGINS_SECURITY_ERROR:
                     _loc4_ = this.pluginErrorUI;
                     break;
                  case PlayerError.PLAY_HTTP_TS_IO_ERROR:
                  case PlayerError.PLAY_HTTP_TS_TIMEOUT_ERROR:
                  case PlayerError.PLAY_HTTP_TS_SECURITY_ERROR:
                  case PlayerError.PLAY_HTTP_TS_ANALY_ERROR:
                  case PlayerError.PLAY_HTTP_TS_OTHER_ERROR:
                  case PlayerError.PLAY_HTTP_TIMEOUT_ERROR:
                  case PlayerError.P2P_M3U8_ERROR:
                  case PlayerError.P2P_PLAY_ERROR:
                  case PlayerError.P2P_TIMEOUT_ERROR:
                  case PlayerError.P2P_PLAY_OTHER_ERROR:
                  case PlayerError.PLAY_HTTP_M3U8_IO_ERROR:
                  case PlayerError.PLAY_HTTP_M3U8_TIMEOUT_ERROR:
                  case PlayerError.PLAY_HTTP_M3U8_SECURITY_ERROR:
                  case PlayerError.PLAY_HTTP_M3U8_ANALY_ERROR:
                  case PlayerError.PLAY_HTTP_M3U8_OTHER_ERROR:
                     _loc4_ = this.playErrorUI;
                     break;
                  default:
                     _loc4_ = this.otherErrorUI;
               }
               _loc4_.errorCode = param2;
               this.latestError = _loc4_;
               break;
            case "latestError":
               _loc4_ = this.latestError;
               break;
            case "feedback":
               _loc4_ = this.feedbackUI;
               break;
         }
         if(_loc4_ != null)
         {
            addElement(_loc4_);
            _loc4_.alpha = 0;
            TweenLite.to(_loc4_,0.3,{"alpha":1});
            this.resize();
         }
      }
      
      private function removeAll() : void
      {
         var i:int = 0;
         while(i < this.uis.length)
         {
            try
            {
               removeElement(this.uis[i]);
            }
            catch(e:Error)
            {
            }
            i++;
         }
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this.otherErrorUI = new OtherErrorUI(skin.otherError);
         this.pluginErrorUI = new PluginErrorUI(skin.pluginError);
         this.playErrorUI = new PlayErrorUI(skin.playError);
         this.offlineErrorUI = new OfflineErrorUI(skin.offlineError);
         this.nolineErrorUI = new NolineErrorUI(skin.nolineError);
         this.authErrorUI = new AuthErrorUI(skin.authError);
         this.cnErrorUI = new CNErrorUI(skin.cnError);
         this.blackErrorUI = new BlackErrorUI(skin.blackError);
         this.overSeaErrorUI = new OverSeaErrorUI(skin.overSeaError);
         this.hkErrorUI = new HKErrorUI(skin.hkError);
         this.adBlockErrorUI = new AdBlockErrorUI(skin.adBlockError);
         this.adBlockEnvErrorUI = new AdBlockEnvErrorUI(skin.adBlockEnvError);
         this.feedbackUI = new FeedbackUI(skin.feedback);
         this.versionWarnUI = new VersionWarningUI(skin.versionWarningError);
         this.uis = [this.otherErrorUI,this.pluginErrorUI,this.playErrorUI,this.offlineErrorUI,this.nolineErrorUI,this.authErrorUI,this.cnErrorUI,this.blackErrorUI,this.overSeaErrorUI,this.hkErrorUI,this.adBlockErrorUI,this.adBlockEnvErrorUI,this.feedbackUI,this.versionWarnUI];
         this.otherErrorUI.addEventListener(OutterWarnEvent.REFRESH,this.onRefresh);
         this.otherErrorUI.addEventListener(OutterWarnEvent.FEEDBACK,this.onFeedback);
         this.authErrorUI.addEventListener(OutterWarnEvent.FEEDBACK,this.onFeedback);
         this.pluginErrorUI.addEventListener(OutterWarnEvent.REFRESH,this.onRefresh);
         this.pluginErrorUI.addEventListener(OutterWarnEvent.FEEDBACK,this.onFeedback);
         this.playErrorUI.addEventListener(OutterWarnEvent.REFRESH,this.onRefresh);
         this.playErrorUI.addEventListener(OutterWarnEvent.FEEDBACK,this.onFeedback);
         this.feedbackUI.addEventListener(OutterWarnEvent.FEEDBACK,this.onSendFeedback);
         this.feedbackUI.addEventListener(OutterWarnEvent.FAQ_PAGE,this.onFaqPage);
         this.feedbackUI.addEventListener(OutterWarnEvent.RETURN_BACK,this.onReturnError);
         this.versionWarnUI.addEventListener(OutterWarnEvent.REFRESH,this.onRefresh);
      }
      
      private function onRefresh(param1:OutterWarnEvent) : void
      {
         dispatchEvent(new OutterWarnEvent(OutterWarnEvent.REFRESH));
      }
      
      private function onFeedback(param1:OutterWarnEvent) : void
      {
         this.displayError("feedback");
      }
      
      private function onSendFeedback(param1:OutterWarnEvent) : void
      {
         this.sendDelayTime = setTimeout(this.displayError,1500,"latestError");
         var _loc2_:OutterWarnEvent = new OutterWarnEvent(OutterWarnEvent.FEEDBACK);
         _loc2_.dataProvider = param1.dataProvider;
         dispatchEvent(_loc2_);
      }
      
      private function onFaqPage(param1:OutterWarnEvent) : void
      {
         dispatchEvent(new OutterWarnEvent(OutterWarnEvent.FAQ_PAGE));
      }
      
      private function onMainPage(param1:OutterWarnEvent) : void
      {
         dispatchEvent(new OutterWarnEvent(OutterWarnEvent.MAIN_PAGE));
      }
      
      private function onReturnError(param1:OutterWarnEvent) : void
      {
         this.displayError("latestError");
      }
   }
}
