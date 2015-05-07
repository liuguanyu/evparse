package com.letv.player.view.skin.controlBar
{
   import com.letv.player.facade.MyMediator;
   import com.letv.player.components.controlBar.ControlBarUI;
   import com.letv.player.components.controlBar.classes.InfoTipUI;
   import com.letv.player.notify.AssistNotify;
   import com.letv.player.notify.GlobalNofity;
   import com.letv.player.notify.LogicNotify;
   import com.letv.player.notify.LoadNotify;
   import com.letv.player.notify.RecommendNotify;
   import com.letv.player.notify.ErrorNotify;
   import com.letv.player.notify.AdNotify;
   import org.puremvc.as3.interfaces.INotification;
   import com.letv.player.components.controlBar.events.ControlBarEvent;
   import com.letv.player.components.controlBar.events.InfoTipEvent;
   import com.letv.pluginsAPI.popup.PopupState;
   import com.letv.pluginsAPI.api.JsAPI;
   import com.letv.player.notify.ExtendNotify;
   import com.alex.utils.BrowserUtil;
   import com.letv.player.model.stat.LetvStatistics;
   
   public class ControlBarMediator extends MyMediator
   {
      
      public static const NAME:String = "controlBarMediator";
      
      private var controlBarUI:ControlBarUI;
      
      private var infotipUI:InfoTipUI;
      
      private var loopFlag:Boolean = true;
      
      public function ControlBarMediator(param1:Object)
      {
         super(NAME,param1);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [AssistNotify.DISPLAY_INFOTIP,AssistNotify.DISPLAY_TRYLOOK,AssistNotify.DISPLAY_HOT_FILTER,GlobalNofity.GLOBAL_RESIZE,GlobalNofity.GLOBAL_FULL_SCREEN,GlobalNofity.GLOBAL_HIDE_CURSOR,GlobalNofity.GLOBAL_SHOW_CURSOR,GlobalNofity.GLOBAL_SET_VOLUME,GlobalNofity.GLOBAL_CHANGE_VOLUME,LogicNotify.VIDEO_AUTH_VALID,LogicNotify.VIDEO_SLEEP,LogicNotify.VIDEO_NEXT,LogicNotify.VIDEO_START,LogicNotify.VIDEO_REPLAY,LogicNotify.SEEK_TO,LogicNotify.VIDEO_TOGGLE,LogicNotify.VIDEO_PAUSE,LogicNotify.VIDEO_RESUME,LogicNotify.VIDEO_STOP,LogicNotify.VIDEO_SPEED,LogicNotify.LOOP_ON_KERNEL,LogicNotify.KEYBOARD_SPEED_BACK,LogicNotify.KEYBOARD_SPEED_FORWARD,LogicNotify.KEYBOARD_SPEED_GO,LoadNotify.FILTER_DATA_OVER,RecommendNotify.SHOW_RECOMMEND,RecommendNotify.RECOMMEND_LOCK_TRACK,ErrorNotify.ERROR_IN_SDK,AdNotify.AD_START,LogicNotify.PLAYER_FIRSTLOOK,LogicNotify.PLAYER_LOGINLOOK,LogicNotify.SWAP_COMPLETE];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         switch(param1.getName())
         {
            case LogicNotify.LOOP_ON_KERNEL:
               if(this.loopFlag)
               {
                  this.controlBarUI.percent = param1.getBody();
               }
               break;
            case AssistNotify.DISPLAY_INFOTIP:
               if(R.controlbar.infotipVisible)
               {
                  this.infotipUI.show(param1.getBody(),sdk.getVideoSetting(),sdk.getUserinfo());
               }
               break;
            case AssistNotify.DISPLAY_HOT_FILTER:
               this.controlBarUI.displayHotFilter(param1.getBody());
               break;
            case LogicNotify.KEYBOARD_SPEED_BACK:
               this.controlBarUI.onBackSpeed();
               break;
            case LogicNotify.KEYBOARD_SPEED_FORWARD:
               this.controlBarUI.onForwardSpeed();
               break;
            case LogicNotify.KEYBOARD_SPEED_GO:
               this.controlBarUI.onSeekTo();
               break;
            case LogicNotify.VIDEO_AUTH_VALID:
               this.controlBarUI.inEnabledState(param1.getBody());
               break;
            case LogicNotify.VIDEO_SLEEP:
               this.controlBarUI.inSleepState(param1.getBody().state);
               break;
            case LogicNotify.VIDEO_NEXT:
            case ErrorNotify.ERROR_IN_SDK:
            case AssistNotify.DISPLAY_TRYLOOK:
            case LogicNotify.PLAYER_FIRSTLOOK:
            case LogicNotify.PLAYER_LOGINLOOK:
               if(this.infotipUI != null)
               {
                  this.infotipUI.hide(true);
               }
               this.controlBarUI.initState();
               break;
            case LogicNotify.VIDEO_START:
               this.controlBarUI.inStartState(param1.getBody());
               break;
            case LogicNotify.VIDEO_TOGGLE:
               this.controlBarUI.inToggleState();
               break;
            case LogicNotify.VIDEO_PAUSE:
               this.controlBarUI.inPauseState();
               sendNotification(AssistNotify.HIDE_LOADING);
               break;
            case LogicNotify.VIDEO_STOP:
            case RecommendNotify.SHOW_RECOMMEND:
               if(this.infotipUI != null)
               {
                  this.infotipUI.hide();
               }
               this.controlBarUI.inRecState();
               break;
            case LogicNotify.VIDEO_SPEED:
               this.controlBarUI.speed = param1.getBody();
               break;
            case LogicNotify.VIDEO_RESUME:
            case LogicNotify.SEEK_TO:
            case LogicNotify.VIDEO_REPLAY:
               this.controlBarUI.inPlayState();
               break;
            case LoadNotify.FILTER_DATA_OVER:
               this.controlBarUI.setHotFilterData(param1.getBody());
               break;
            case GlobalNofity.GLOBAL_RESIZE:
            case GlobalNofity.GLOBAL_FULL_SCREEN:
               this.infotipUI.resize();
               this.controlBarUI.resize(true);
               break;
            case GlobalNofity.GLOBAL_HIDE_CURSOR:
               this.controlBarUI.hide();
               break;
            case GlobalNofity.GLOBAL_SHOW_CURSOR:
               this.controlBarUI.show();
               this.infotipUI.setAnimation(true);
               break;
            case GlobalNofity.GLOBAL_SET_VOLUME:
               this.controlBarUI.scriptVolume = param1.getBody();
               break;
            case GlobalNofity.GLOBAL_CHANGE_VOLUME:
               this.controlBarUI.toggleVolume = int(param1.getBody());
               break;
            case RecommendNotify.RECOMMEND_LOCK_TRACK:
               this.controlBarUI.lockTrack();
               break;
            case AdNotify.AD_START:
               this.controlBarUI.inAdState();
               if(this.infotipUI != null)
               {
                  this.infotipUI.hide();
               }
               break;
            case LogicNotify.SWAP_COMPLETE:
               this.controlBarUI.setDefinitionBtn(String(param1.getBody().definition));
               break;
         }
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         this.controlBarUI = new ControlBarUI(R.skin.controlBar);
         this.controlBarUI.initDuration = R.flashvars.duration;
         R.controlbar.cHeight = this.controlBarUI.controlHeight;
         this.infotipUI = new InfoTipUI(R.skin.infotip);
         viewComponent.addElement(this.controlBarUI);
         viewComponent.addElement(this.infotipUI);
         this.infotipUI.x = this.controlBarUI.x;
         this.addListener();
      }
      
      private function addListener() : void
      {
         this.controlBarUI.addEventListener(ControlBarEvent.VIDEO_PAUSE,this.onVideoPause);
         this.controlBarUI.addEventListener(ControlBarEvent.VIDEO_RESUME,this.onVideoResume);
         this.controlBarUI.addEventListener(ControlBarEvent.VIDEO_REPLAY,this.onVideoReplay);
         this.controlBarUI.addEventListener(ControlBarEvent.VIDEO_START_FROM_SLEEP,this.onVideoStartFromSleep);
         this.controlBarUI.addEventListener(ControlBarEvent.SEEK_TO,this.onSeekTo);
         this.controlBarUI.addEventListener(ControlBarEvent.JUMP_TAIL,this.onJumpTail);
         this.controlBarUI.addEventListener(ControlBarEvent.PLAY_NEXT,this.onPlayNext);
         this.controlBarUI.addEventListener(ControlBarEvent.SET_VOLUME,this.onSetVolume);
         this.controlBarUI.addEventListener(ControlBarEvent.CONTROLBAR_MOVE,this.onControlbarMove);
         this.controlBarUI.addEventListener(ControlBarEvent.DEFINITION_VIP,this.onDefinitionVip);
         this.controlBarUI.addEventListener(ControlBarEvent.DEFINITION_REGULATE,this.onDefinitionRegulate);
         this.controlBarUI.addEventListener(ControlBarEvent.SHOWSKIN,this.onShowSkin);
         this.controlBarUI.addEventListener(ControlBarEvent.HIDESKIN,this.onHideSkin);
         this.infotipUI.addEventListener(InfoTipEvent.CHANGE,this.onInfoTipChange);
      }
      
      private function onVideoPause(param1:ControlBarEvent = null) : void
      {
         sendNotification(LogicNotify.VIDEO_PAUSE);
      }
      
      private function onVideoResume(param1:ControlBarEvent = null) : void
      {
         sendNotification(LogicNotify.VIDEO_RESUME);
      }
      
      private function onVideoReplay(param1:ControlBarEvent) : void
      {
         sendNotification(LogicNotify.VIDEO_REPLAY);
      }
      
      private function onVideoStartFromSleep(param1:ControlBarEvent) : void
      {
         sendNotification(LogicNotify.START_UP);
      }
      
      private function onSeekTo(param1:ControlBarEvent) : void
      {
         this.loopFlag = false;
         sendNotification(LogicNotify.SEEK_TO,param1.dataProvider);
         this.loopFlag = true;
      }
      
      private function onPlayNext(param1:ControlBarEvent) : void
      {
         if(sdk != null)
         {
            sdk.playNext(false,true);
         }
      }
      
      private function onJumpTail(param1:ControlBarEvent) : void
      {
         var _loc2_:Object = null;
         this.loopFlag = false;
         if(sdk != null)
         {
            _loc2_ = sdk.getPlayset();
            if(_loc2_.jump)
            {
               sendNotification(LogicNotify.SEEK_TO,-1);
               sdk.jumpVideo(1);
            }
            else
            {
               sendNotification(LogicNotify.SEEK_TO,param1.dataProvider);
            }
         }
         this.loopFlag = true;
      }
      
      private function onSetVolume(param1:ControlBarEvent) : void
      {
         sendNotification(LogicNotify.SET_VOLUME,param1.dataProvider);
      }
      
      private function onControlbarMove(param1:ControlBarEvent) : void
      {
         sendNotification(AssistNotify.CONTROLBAR_MOVE,[param1.controlbarX,param1.controlbarY]);
      }
      
      private function onDefinitionVip(param1:ControlBarEvent) : void
      {
         sendNotification(AssistNotify.DISPLAY_POPUP,[PopupState.VIP_VIDEO,param1.dataProvider]);
      }
      
      private function onDefinitionRegulate(param1:ControlBarEvent) : void
      {
         if(sdk != null)
         {
            sdk.setDefinition(String(param1.dataProvider),null,true);
         }
      }
      
      private function onShowSkin(param1:ControlBarEvent) : void
      {
         if(this.infotipUI)
         {
            this.infotipUI.setAnimation(true);
         }
      }
      
      private function onHideSkin(param1:ControlBarEvent) : void
      {
         if(this.infotipUI)
         {
            this.infotipUI.setAnimation(false);
         }
      }
      
      private function onInfoTipChange(param1:InfoTipEvent) : void
      {
         var _loc3_:Object = null;
         var _loc4_:* = false;
         var _loc5_:Object = null;
         var _loc6_:* = false;
         var _loc7_:Array = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc2_:String = String(param1.dataProvider);
         if(_loc2_ == "pause")
         {
            sendNotification(LogicNotify.VIDEO_PAUSE);
         }
         else if(_loc2_ == "setting")
         {
            sendNotification(AssistNotify.DISPLAY_POPUP,PopupState.PLAYSET);
         }
         else if(_loc2_ == "watchFromStart")
         {
            sdk.seekTo(0);
         }
         else if(_loc2_ == "firstlook")
         {
            _loc3_ = main.browserManager.callScript(R.flashvars.callbackJs,JsAPI.CLICK_FIRSTLOOK,{
               "vid":R.flashvars.vid,
               "htime":sdk.getVideoTime()
            });
            if(_loc3_ == "1")
            {
               main.systemManager.setFullScreen(false);
            }
            _loc4_ = _loc3_ == "1"?false:true;
            sendNotification(AssistNotify.FIRSTLOOK,{
               "istip":_loc4_,
               "ref":"sktipqrcode"
            });
         }
         else if(_loc2_ == "cutoff")
         {
            _loc5_ = main.browserManager.callScript(R.flashvars.callbackJs,JsAPI.CLICK_STREAMCUT,{
               "vid":R.flashvars.vid,
               "htime":sdk.getVideoTime()
            });
            if(_loc5_ == "1")
            {
               main.systemManager.setFullScreen(false);
            }
            _loc6_ = _loc5_ == "1"?false:true;
            sendNotification(AssistNotify.FIRSTLOOK,{
               "istip":_loc6_,
               "ref":"cuttipqrcode"
            });
         }
         else if(_loc2_ == "login")
         {
            main.systemManager.setFullScreen(false);
            main.browserManager.callScript(JsAPI.DISPLAY_LOGIN);
         }
         else if(_loc2_.indexOf("extend") != -1)
         {
            sendNotification(ExtendNotify.DISPLAY_EXTEND_PLUGIN,_loc2_);
         }
         else if(_loc2_.indexOf("trylook") != -1)
         {
            sendNotification(AssistNotify.BUY_VIDEO);
         }
         else if(_loc2_.indexOf("debug_statistics") != -1)
         {
            _loc7_ = _loc2_.split("@");
            _loc8_ = String(_loc7_[1]);
            _loc9_ = String(_loc7_[2]);
            BrowserUtil.openBlankWindow(_loc9_,stage);
         }
         else if(_loc2_ == "loginLimitLogin")
         {
            _loc10_ = this.loginRefresh();
            R.stat.sendDocDebug(LetvStatistics.LOGINLIMIT_LOGIN_TIP);
            main.systemManager.setFullScreen(false);
            main.browserManager.callScript(JsAPI.DISPLAY_LOGIN,_loc10_);
         }
         else if(_loc2_ == "loginLimitRegist")
         {
            R.stat.sendDocDebug(LetvStatistics.LOGINLIMIT_REGIST_TIP);
            BrowserUtil.openBlankWindow("http://sso.letv.com/user/emailreg",stage);
         }
         else if(_loc2_ == "super_phone")
         {
            R.stat.sendDocDebug(LetvStatistics.SUPER_PHONE_CLICK);
            main.systemManager.setFullScreen(false);
            BrowserUtil.openBlankWindow("http://www.lemall.com/phone.html?cps_id=ledh_pc_rx_sssdsxk_bfy_all_p",stage);
         }
         
         
         
         
         
         
         
         
         
         
         
      }
      
      private function loginRefresh() : String
      {
         var _loc5_:RegExp = null;
         var _loc6_:RegExp = null;
         var _loc1_:String = BrowserUtil.url || "";
         var _loc2_:Array = _loc1_.split("#");
         var _loc3_:String = _loc2_[0];
         if(_loc3_.indexOf("htime=") != -1)
         {
            _loc5_ = new RegExp("htime=\\d+");
            _loc3_ = _loc3_.replace(_loc5_,"htime=" + Math.floor(sdk.getVideoTime()));
         }
         else
         {
            _loc3_ = _loc3_ + (_loc3_.indexOf("?") != -1?"&htime=":"?htime=") + Math.floor(sdk.getVideoTime());
         }
         if(_loc3_.indexOf("ref=") != -1)
         {
            _loc6_ = new RegExp("ref=\\w+");
            _loc3_ = _loc3_.replace(_loc6_,"ref=" + "loginLimit");
         }
         else
         {
            _loc3_ = _loc3_ + (_loc3_.indexOf("?") != -1?"&ref=":"?ref=") + "loginLimit";
         }
         _loc1_ = _loc3_;
         var _loc4_:* = 1;
         while(_loc4_ < _loc2_.length)
         {
            _loc1_ = _loc1_ + "#" + _loc2_[_loc4_];
            _loc4_++;
         }
         return _loc1_;
      }
   }
}
