package com.letv.plugins.kernel.view
{
   import com.letv.plugins.kernel.interfaces.IDestroy;
   import com.letv.plugins.kernel.components.VideoUI;
   import com.letv.plugins.kernel.components.WaterMarkUI;
   import com.letv.pluginsAPI.kernel.PlayerStateEvent;
   import com.letv.pluginsAPI.kernel.PlayerErrorEvent;
   import com.letv.plugins.kernel.media.MediaEvent;
   import flash.events.Event;
   import com.letv.pluginsAPI.stat.Stat;
   import com.letv.pluginsAPI.api.JsAPI;
   import flash.external.ExternalInterface;
   import com.letv.plugins.kernel.Kernel;
   import com.letv.plugins.kernel.utils.VideoShapeUtil;
   import com.letv.plugins.kernel.model.special.LimitData;
   import flash.events.FullScreenEvent;
   import com.letv.plugins.kernel.utils.KeyFrameUtil;
   import flash.media.Video;
   import com.alex.utils.ColorMatrix;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Rectangle;
   import com.letv.plugins.kernel.model.Model;
   import com.letv.plugins.kernel.controller.Controller;
   
   public class View extends Object implements IDestroy
   {
      
      private var main:Kernel;
      
      private var model:Model;
      
      private var controller:Controller;
      
      private var videoUI:VideoUI;
      
      private var _markUI:WaterMarkUI;
      
      public function View(param1:Kernel, param2:Model, param3:Controller)
      {
         super();
         this.main = param1;
         this.model = param2;
         this.controller = param3;
         this.init();
         this.addListener();
      }
      
      public function destroy() : void
      {
      }
      
      private function init() : void
      {
         this.main.mouseChildren = false;
         this.main.mouseEnabled = false;
         this.videoUI = new VideoUI(this.model);
         this.main.addChild(this.videoUI);
         this._markUI = new WaterMarkUI(this.controller);
         this.main.addChild(this._markUI);
      }
      
      private function addListener() : void
      {
         this.model.addEventListener(PlayerStateEvent.USER_AUTH_VALID,this.onUserAuthValid);
         this.model.addEventListener(PlayerStateEvent.GSLB_SUCCESS,this.onPlayerState);
         this.model.addEventListener(PlayerStateEvent.PLAYER_MEDIA_MODE,this.onPlayerState);
         this.model.addEventListener(PlayerStateEvent.EXCUTE_P2P,this.onPlayerState);
         this.model.addEventListener(PlayerStateEvent.PLAYER_START_READY,this.onPlayerState);
         this.model.addEventListener(PlayerStateEvent.PLAYER_FULL,this.onPlayerState);
         this.model.addEventListener(PlayerStateEvent.PLAYER_EMPTY,this.onPlayerState);
         this.model.addEventListener(PlayerStateEvent.PLAYER_LOADING,this.onPlayerState);
         this.model.addEventListener(PlayerStateEvent.PLAYER_START,this.onPlayerStart);
         this.model.addEventListener(PlayerStateEvent.PLAYER_STOP,this.onPlayerStop);
         this.model.addEventListener(PlayerStateEvent.PLAYER_STOPPING,this.onPlayerState);
         this.model.addEventListener(PlayerStateEvent.FIRSTLOOK_STOPPING,this.onPlayerState);
         this.model.addEventListener(PlayerStateEvent.LOGINLOOK_STOPPING,this.onPlayerState);
         this.model.addEventListener(PlayerStateEvent.PLAYER_REPLAY,this.onPlayerState);
         this.model.addEventListener(PlayerStateEvent.PLAYER_NEXT,this.onPlayerState);
         this.model.addEventListener(PlayerStateEvent.PLAYER_DEFINITION,this.onPlayerState);
         this.model.addEventListener(PlayerStateEvent.PLAYER_SPEED,this.onPlayerState);
         this.model.addEventListener(PlayerStateEvent.SWAP_COMPLETE,this.onPlayerState);
         this.model.addEventListener(PlayerStateEvent.SWAP_DEFINITION_FAIL,this.onSwapDefinitionFail);
         this.model.addEventListener(PlayerErrorEvent.PLAYER_ERROR,this.onPlayerError);
         this.model.addEventListener(MediaEvent.MODE_CHANGE,this.onModeChange);
         this.model.addEventListener(MediaEvent.META_DATA,this.onMetaData);
         this.model.addEventListener(Event.RESIZE,this.onVideoResize);
         this.model.addEventListener(PlayerStateEvent.VIDEO_RECT,this.onVideoRect);
         this.model.addEventListener(PlayerStateEvent.CUT_PLAY_COMPLETE,this.onPlayerCutoff);
         this.model.addEventListener(PlayerErrorEvent.P2P_ERROR,this.onPlayerError);
         this.model.addEventListener(PlayerStateEvent.START_PRELOAD,this.onPreload);
         this.model.addEventListener(PlayerStateEvent.START_PRELOAD_AD,this.onPlayerState);
         this.model.addEventListener(PlayerStateEvent.PLAY_PRELOAD,this.onPlayPreload);
         this.model.addEventListener(PlayerStateEvent.STOP_PRELOAD,this.onPlayerState);
         this.main.addEventListener(Event.ADDED_TO_STAGE,this.onAdded);
         this.main.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
         this.videoUI.addEventListener(Event.RESIZE,this.onVideoResize);
      }
      
      private function onUserAuthValid(param1:PlayerStateEvent) : void
      {
         this.model.statistics.sendStat(Stat.LOG_IRS,Stat.IRS_START);
         var _loc2_:PlayerStateEvent = new PlayerStateEvent(PlayerStateEvent.USER_AUTH_VALID);
         var _loc3_:Object = this.model.getVideoSetting();
         _loc3_["adEnabled"] = this.model.adEnabled;
         _loc3_["seeData"] = this.model.vrs.seeData;
         _loc3_["vip"] = this.model.getUserInfo();
         _loc2_.dataProvider = _loc3_;
         this.main.dispatchEvent(_loc2_);
      }
      
      private function onPlayerState(param1:PlayerStateEvent) : void
      {
         var _loc2_:PlayerStateEvent = new PlayerStateEvent(param1.type);
         switch(param1.type)
         {
            case PlayerStateEvent.PLAYER_FULL:
               break;
            case PlayerStateEvent.PLAYER_REPLAY:
               this.model.sendInterface(JsAPI.VIDEO_AUTO_REPLAY,param1.dataProvider);
               _loc2_.dataProvider = param1.dataProvider;
               break;
            case PlayerStateEvent.PLAYER_NEXT:
               _loc2_.dataProvider = param1.dataProvider;
               break;
            default:
               _loc2_.dataProvider = param1.dataProvider;
         }
         this.main.dispatchEvent(_loc2_);
      }
      
      private function onPlayerStart(param1:PlayerStateEvent) : void
      {
         if(!this.model.play.swapDefinition)
         {
            this.model.sendInterface(JsAPI.PLAYER_VIDEO_PLAY,{"id":this.model.setting.vid});
            this.model.statistics.sendStat(Stat.LOG_PLAY,Stat.LOG_PLAY_PLAY,{
               "utime":param1.dataProvider.utime,
               "retry":param1.dataProvider.retry
            });
            this.model.statistics.sendStat(Stat.LOG_COMSCORE);
         }
         this.controller.playStart();
         this._markUI.start(this.controller.getVideoTime(),this.model.waterMarkData.data,this.main);
         var _loc2_:PlayerStateEvent = new PlayerStateEvent(PlayerStateEvent.PLAYER_START);
         var _loc3_:Object = this.model.getVideoSetting();
         _loc3_["playMode"] = this.model.playMode;
         _loc3_["metadata"] = param1.dataProvider.metadata;
         _loc3_["vip"] = this.model.getUserInfo();
         _loc3_["time"] = this.controller.getVideoTime();
         _loc3_["recordTime"] = this.model.flashCookie.recordTime;
         _loc2_.dataProvider = _loc3_;
         this.main.dispatchEvent(_loc2_);
      }
      
      private function onPlayerStop(param1:PlayerStateEvent) : void
      {
         var callback:Object = null;
         var event:PlayerStateEvent = param1;
         this.controller.playStop();
         this._markUI.stop();
         try
         {
            ExternalInterface.call("notifyPlayingVideoCloseDown");
         }
         catch(e:Error)
         {
         }
         var data:Object = this.model.getVideoSetting();
         if(this.model.isTrylook)
         {
            callback = {"status":"recommend"};
         }
         else if(!this.model.config.continuration)
         {
            callback = this.model.sendInterface(JsAPI.PLAYER_VIDEO_COMPLETE);
            callback = {"status":"recommend"};
         }
         else
         {
            callback = this.model.sendInterface(JsAPI.PLAYER_VIDEO_COMPLETE);
            data["callback"] = callback;
         }
         
         Kernel.sendLog("Kernel.Complete CallScript status : " + callback["status"]);
         var ev:PlayerStateEvent = new PlayerStateEvent(PlayerStateEvent.PLAYER_STOP);
         switch(callback["status"])
         {
            case "recommend":
               data.playNext = 0;
               break;
            case "error":
            case "playerContinue":
               if(this.model.setting.continuePlay)
               {
                  data.playNext = this.model.hadNextData?1:0;
               }
               else
               {
                  data.playNext = 0;
               }
               break;
            case "simple":
               data.playNext = 0;
               break;
            case "pageContinue":
               return;
         }
         ev.dataProvider = data;
         this.main.dispatchEvent(ev);
      }
      
      private function onSwapDefinitionFail(param1:PlayerStateEvent) : void
      {
         this.main.setDefinition(this.main.getDefinition(),null,false,true);
      }
      
      private function onPlayerError(param1:PlayerErrorEvent) : void
      {
         if(param1.type == PlayerErrorEvent.PLAYER_ERROR)
         {
            this.controller.closeVideo(false);
            this.model.statistics.sendStat(Stat.OP_REFRESH_VV);
         }
         var _loc2_:PlayerErrorEvent = new PlayerErrorEvent(param1.type);
         _loc2_.dataProvider = this.model.setting.clone();
         _loc2_.errorCode = param1.errorCode;
         this.main.dispatchEvent(_loc2_);
      }
      
      private function onModeChange(param1:MediaEvent) : void
      {
         this.controller.changeMode(param1.dataProvider);
      }
      
      private function onMetaData(param1:MediaEvent) : void
      {
         this.videoUI.render();
         VideoShapeUtil.change(this.main,this.videoUI,this.model,this._markUI);
      }
      
      private function onVideoResize(param1:Event = null) : void
      {
         if(this.main.stage)
         {
            VideoShapeUtil.change(this.main,this.videoUI,this.model,this._markUI);
         }
      }
      
      public function onVideoRect(param1:PlayerStateEvent) : void
      {
         var param1:PlayerStateEvent = new PlayerStateEvent(param1.type);
         this.main.dispatchEvent(param1);
      }
      
      private function onPlayerCutoff(param1:PlayerStateEvent) : void
      {
         var _loc2_:String = param1.dataProvider.toString();
         switch(_loc2_)
         {
            case LimitData.FIRSTLOOKNAME:
               this.model.sendInterface(JsAPI.PLAYER_FIRSTLOOK,{
                  "vid":this.model.setting.vid,
                  "htime":int(this.controller.getVideoTime())
               });
               this.main.dispatchEvent(new PlayerStateEvent(PlayerStateEvent.PLAYER_FIRSTLOOK,"skqrcode"));
               break;
            case LimitData.LOGINLOOKNAME:
               this.main.dispatchEvent(new PlayerStateEvent(PlayerStateEvent.PLAYER_LOGINLOOK));
               break;
            case LimitData.CUTOFFPCNAME:
               this.model.sendInterface(JsAPI.PLAYER_STREAMCUT,{
                  "vid":this.model.setting.vid,
                  "htime":int(this.controller.getVideoTime())
               });
               this.main.dispatchEvent(new PlayerStateEvent(PlayerStateEvent.PLAYER_FIRSTLOOK,"cutqrcode"));
               break;
         }
      }
      
      private function onFullScren(param1:FullScreenEvent) : void
      {
         this.model.setting.fullscreen = param1.fullScreen;
         this.model.sendInterface(JsAPI.CHANGE_FULLSCREEN,{"flag":param1.fullScreen});
      }
      
      private function onAdded(param1:Event) : void
      {
         this.main.stage.addEventListener(Event.RESIZE,this.onVideoResize);
         this.main.stage.addEventListener(FullScreenEvent.FULL_SCREEN,this.onFullScren);
         this.onVideoResize();
      }
      
      private function onRemoved(param1:Event) : void
      {
         if(this.main.stage != null)
         {
            this.main.stage.removeEventListener(Event.RESIZE,this.onVideoResize);
            this.main.stage.removeEventListener(FullScreenEvent.FULL_SCREEN,this.onFullScren);
         }
      }
      
      private function onPreload(param1:PlayerStateEvent) : void
      {
         this.controller.onPreload();
      }
      
      private function onPlayPreload(param1:Event) : void
      {
         this.controller.onPlayPreload();
      }
      
      public function getScreenShot() : Object
      {
         return KeyFrameUtil.getScreenshots(this.controller.getVideoTime(),this.model,this.model.setting.duration);
      }
      
      public function setVisible(param1:Boolean) : void
      {
         this.videoUI.visible = param1;
      }
      
      public function setVideoColor(param1:* = 0, param2:* = 0, param3:* = 0, param4:* = 0) : Boolean
      {
         if(VideoUI.video == null)
         {
            return false;
         }
         if(!(VideoUI.video is Video))
         {
            return false;
         }
         var _loc5_:ColorMatrix = new ColorMatrix();
         _loc5_.adjustBrightness(param1);
         _loc5_.adjustContrast(param2);
         _loc5_.adjustSaturation(param3);
         _loc5_.adjustHue(param4);
         var _loc6_:Boolean = VideoUI.filters([new ColorMatrixFilter(_loc5_)],this.model);
         if(_loc6_)
         {
            this.model.setting.color = [param1,param2,param3,param4];
         }
         else
         {
            Kernel.sendLog("Kernel.setVideoColor NotSupport","warn");
         }
         return true;
      }
      
      public function setVideoPercent(param1:Number, param2:Boolean = false) : Boolean
      {
         if(this.model.metadata.duration > 0)
         {
            if(VideoUI.video != null)
            {
               if(param1 < 0)
               {
                  var param1:Number = 0;
               }
               this.model.setting.percent = param1;
               VideoShapeUtil.change(this.main,this.videoUI,this.model,this._markUI,param2);
               return true;
            }
         }
         return false;
      }
      
      public function setVideoRect(param1:Object) : void
      {
         if(VideoUI.video == null)
         {
            return;
         }
         if(param1 != null)
         {
            this.model.setting.rect = new Rectangle(param1.x,param1.y,param1.width,param1.height);
         }
         else
         {
            this.model.setting.rect = null;
         }
         VideoShapeUtil.change(this.main,this.videoUI,this.model,this._markUI);
      }
      
      public function setVideoRotation(param1:int) : Boolean
      {
         var value:int = param1;
         try
         {
            if(this.model.metadata.duration > 0)
            {
               this.model.setting.rotation = value;
               VideoShapeUtil.change(this.main,this.videoUI,this.model,this._markUI);
               return true;
            }
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function setVideoScale(param1:*) : Boolean
      {
         var value:* = param1;
         value = Number(value);
         if(isNaN(value))
         {
            value = 0;
         }
         try
         {
            if(this.model.metadata.duration <= 0)
            {
               return false;
            }
            if(VideoUI.video == null)
            {
               return false;
            }
            if(value < 0)
            {
               this.fullVideoScale();
               return true;
            }
            if(value == 0)
            {
               this.resetVideoScale();
               return true;
            }
            this.model.setting.fullScale = false;
            this.model.setting.currentScale = value;
            VideoShapeUtil.change(this.main,this.videoUI,this.model,this._markUI);
            return true;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function resetVideoScale() : void
      {
         if(this.model.metadata.duration > 0)
         {
            if(VideoUI.video)
            {
               this.model.setting.fullScale = false;
               this.model.setting.currentScale = this.model.setting.originalScale;
               VideoShapeUtil.change(this.main,this.videoUI,this.model,this._markUI);
            }
         }
      }
      
      public function fullVideoScale() : void
      {
         if(this.model.metadata.duration > 0)
         {
            if(VideoUI.video)
            {
               this.model.setting.fullScale = true;
               this.model.setting.currentScale = this.main.stage.stageWidth / this.main.stage.stageHeight;
               VideoShapeUtil.change(this.main,this.videoUI,this.model,this._markUI);
            }
         }
      }
   }
}
