package com.letv.player.view.skin.barrage
{
   import com.letv.player.facade.MyMediator;
   import com.letv.player.notify.LogicNotify;
   import com.letv.player.notify.LoadNotify;
   import com.letv.player.notify.AdNotify;
   import com.letv.player.notify.AssistNotify;
   import com.letv.player.notify.BarrageNotify;
   import com.letv.player.notify.GlobalNofity;
   import com.letv.player.notify.ErrorNotify;
   import org.puremvc.as3.interfaces.INotification;
   import com.letv.player.components.displayBar.DisplayBarEvent;
   import com.letv.barrage.state.InputTipState;
   import com.letv.barrage.Barrage;
   import com.letv.player.facade.MyResource;
   import flash.events.Event;
   import com.letv.pluginsAPI.popup.PopupState;
   import com.letv.player.controller.command.BarrageCommand;
   import com.letv.pluginsAPI.api.JsAPI;
   import flash.geom.Rectangle;
   import com.alex.core.Application;
   import com.letv.barrage.BarrageEvent;
   import com.alex.utils.PlayerVersion;
   
   public class BarrageMediator extends MyMediator
   {
      
      public static const NAME:String = "barrageMediator";
      
      private var _loaded:Boolean = false;
      
      private var barrage:Barrage;
      
      public function BarrageMediator(param1:Object)
      {
         super(NAME,param1);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [LogicNotify.LOOP_ON_KERNEL,LogicNotify.VIDEO_AUTH_VALID,LogicNotify.VIDEO_SLEEP,LogicNotify.VIDEO_NEXT,LogicNotify.SEEK_TO,LogicNotify.VIDEO_REPLAY,LogicNotify.VIDEO_START,LogicNotify.VIDEO_RESUME,LogicNotify.VIDEO_PAUSE,LogicNotify.VIDEO_STOP,LoadNotify.BARRAGE_UPLOAD_FAILED,LoadNotify.BARRAGE_UPLOAD_COMPLETE,LoadNotify.BARRAGE_DOWNLOAD_FAILED,LoadNotify.BARRAGE_DOWNLOAD_COMPLETE,LoadNotify.BARRAGE_SEND_DONE,LoadNotify.BARRAGE_SEND_FAIL,AdNotify.AD_START,AssistNotify.DISPLAY_TRYLOOK,BarrageNotify.BARRAGE_PUSH,BarrageNotify.BARRAGE_UPDATE,BarrageNotify.BARRAGE_CLICK2DOWNLOAD,GlobalNofity.GLOBAL_RESIZE,GlobalNofity.GLOBAL_HIDE_CURSOR,GlobalNofity.GLOBAL_SHOW_CURSOR,ErrorNotify.ERROR_IN_SDK,LogicNotify.PLAYER_FIRSTLOOK,LogicNotify.PLAYER_LOGINLOOK];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         switch(param1.getName())
         {
            case LogicNotify.LOOP_ON_KERNEL:
               this.onBarrageTimeLoop(param1.getBody());
               break;
            case AdNotify.AD_START:
            case LogicNotify.VIDEO_SLEEP:
            case LogicNotify.VIDEO_NEXT:
            case LogicNotify.VIDEO_STOP:
               this.onBarrageRemoved();
               break;
            case LogicNotify.VIDEO_AUTH_VALID:
               this.onVideoAuthValid(param1.getBody());
               break;
            case AssistNotify.DISPLAY_TRYLOOK:
            case ErrorNotify.ERROR_IN_SDK:
            case LogicNotify.PLAYER_FIRSTLOOK:
            case LogicNotify.PLAYER_LOGINLOOK:
               this.onBarrageDestroy();
               break;
            case LogicNotify.SEEK_TO:
               this.onBarrageResume();
               this.onBarrageDestroy();
               break;
            case LogicNotify.VIDEO_REPLAY:
            case LogicNotify.VIDEO_RESUME:
               this.onBarrageResume();
               break;
            case BarrageNotify.BARRAGE_UPDATE:
               this.onBarrageUpdate();
               break;
            case BarrageNotify.BARRAGE_CLICK2DOWNLOAD:
               this.onClickToOpenBarrage();
               break;
            case LogicNotify.VIDEO_PAUSE:
               this.onBarragePause();
               break;
            case BarrageNotify.BARRAGE_PUSH:
               this.onBarragePush(param1.getBody());
               break;
            case LogicNotify.VIDEO_START:
               this.onVideoStart(param1.getBody());
               break;
            case LoadNotify.BARRAGE_UPLOAD_FAILED:
               this.onSendFail(null);
               break;
            case LoadNotify.BARRAGE_UPLOAD_COMPLETE:
               break;
            case LoadNotify.BARRAGE_DOWNLOAD_FAILED:
            case LoadNotify.BARRAGE_DOWNLOAD_COMPLETE:
               if((sdk.getBarrage()) && (R.skin.barrageSupport))
               {
                  R.dispatchEvent(new DisplayBarEvent(DisplayBarEvent.OPEN_BARRAGE));
               }
               else
               {
                  this.onBarrageUpdate();
               }
               break;
            case LoadNotify.BARRAGE_SEND_DONE:
               this.onSendDone(param1.getBody());
               break;
            case LoadNotify.BARRAGE_SEND_FAIL:
               this.onSendFail(InputTipState.INPUT_FAIL);
               break;
            case GlobalNofity.GLOBAL_RESIZE:
               this.onBarrageResize();
               break;
            case GlobalNofity.GLOBAL_HIDE_CURSOR:
               this.onBarrageHideInput();
               break;
            case GlobalNofity.GLOBAL_SHOW_CURSOR:
               this.onBarrageShowInput();
               break;
         }
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         viewComponent.mouseEnabled = false;
         this.barrage = new Barrage(R.displaybar.barrageemList);
         this.barrage.mouseEnabled = false;
         this.barrage.buttonMode = true;
      }
      
      protected function get opening() : Boolean
      {
         return main.getMsg(MyResource.BARRAGE) as Boolean;
      }
      
      protected function get dockheight() : uint
      {
         return uint(main.getMsg(MyResource.DOCK_HEIGHT));
      }
      
      private function onSendBarrageMsg(param1:Event) : void
      {
         this.sendBarrage(Barrage.TYPE_TXT,param1["dataProvider"]);
      }
      
      private function onInputSet(param1:Event) : void
      {
         sendNotification(AssistNotify.DISPLAY_POPUP,PopupState.FULLSCREEN_INPUT);
      }
      
      private function onSendBarrageEm(param1:Event) : void
      {
         this.sendBarrage(Barrage.TYPE_EM,param1["dataProvider"]);
      }
      
      private function onSendDone(param1:Object) : void
      {
         this.barrage.clearInput();
         this.barrage.append(param1);
         this.barrage.inputTip = InputTipState.INPUT_DONE;
      }
      
      private function onSendFail(param1:String = null) : void
      {
         this.barrage.inputTip = param1;
      }
      
      private function sendBarrage(param1:String, param2:Object) : void
      {
         var _loc4_:Object = null;
         var _loc3_:Object = sdk.getUserinfo();
         if(_loc3_.uid != null)
         {
            param2.time = sdk.getVideoTime();
            param2.start = param2.time;
            param2.self = true;
            param2.type = param1;
            _loc4_ = {
               "vid":sdk.getVideoSetting()["vid"],
               "cid":sdk.getVideoSetting()["cid"],
               "start":param2.start,
               "time":param2.time,
               "txt":param2.txt,
               "color":param2.color,
               "type":param2.type,
               "x":param2.x,
               "y":param2.y
            };
            sendNotification(LoadNotify.BARRAGE_LOAD,{
               "command":BarrageCommand.UPLOAD_BARRAGE,
               "value":_loc4_
            });
            sendNotification(LoadNotify.BARRAGE_LOAD,{
               "command":BarrageCommand.ADD_BARRAGE,
               "value":_loc4_
            });
            switch(param1)
            {
               case Barrage.TYPE_EM:
                  this.barrage.append(param2);
                  break;
               case Barrage.TYPE_TXT:
                  this.barrage.inputTip = InputTipState.INPUT_LOADING;
                  break;
            }
         }
         else
         {
            main.systemManager.setFullScreen(false);
            main.browserManager.callScript(JsAPI.DISPLAY_LOGIN);
         }
      }
      
      private function onVideoAuthValid(param1:Object) : void
      {
         R.skin.barrageSupport = param1["barrageSupport"];
         sendNotification(LoadNotify.BARRAGE_LOAD,{"command":BarrageCommand.INIT_BARRAGE});
      }
      
      private function onVideoStart(param1:Object) : void
      {
         var _loc2_:Object = null;
         R.dispatchEvent(new DisplayBarEvent(DisplayBarEvent.CLOSE_BARRAGE));
         this.onBarrageDataReset(true);
         if(sdk.getBarrage())
         {
            if(R.skin.barrageSupport)
            {
               _loc2_ = param1["vid"];
            }
            sendNotification(LoadNotify.BARRAGE_LOAD,{
               "command":BarrageCommand.DOWNLOAD_BARRAGE,
               "value":_loc2_
            });
            this.onBarrageResume();
            this._loaded = true;
         }
         else
         {
            this._loaded = false;
         }
      }
      
      private function onClickToOpenBarrage() : void
      {
         var _loc1_:Object = null;
         if(!this._loaded)
         {
            _loc1_ = (sdk.getIdInfo() || {})["vid"];
            sendNotification(LoadNotify.BARRAGE_LOAD,{
               "command":BarrageCommand.DOWNLOAD_BARRAGE,
               "value":_loc1_
            });
            this.onBarrageResume();
            this._loaded = true;
         }
      }
      
      private function onBarrageRemoved() : void
      {
         if(R.skin.barrageSupport)
         {
            this.barrage.destroy();
            this.onBarrageDataReset();
            R.dispatchEvent(new DisplayBarEvent(DisplayBarEvent.CLOSE_BARRAGE));
         }
      }
      
      private function onBarrageDestroy() : void
      {
         if(R.skin.barrageSupport)
         {
            this.barrage.destroy();
            this.onBarrageDataReset();
            sendNotification(LoadNotify.BARRAGE_LOAD,{"command":BarrageCommand.SHUTDOWN_BARRAGE});
         }
      }
      
      private function onBarrageResize() : void
      {
         if(R.skin.barrageSupport)
         {
            this.onBarrageInputTipUpdate();
            this.barrage.viewPort = new Rectangle(0,0,main.width,main.height - this.dockheight - R.controlbar.cHeight);
            this.barrage.showInput();
            if(Application.application.width < 500 || Application.application.height < 400)
            {
               this.onBarrageHideInput();
            }
            else
            {
               this.onBarrageShowInput();
            }
         }
      }
      
      private function onBarrageHideInput() : void
      {
         if((R.skin.barrageSupport) && !(this.barrage.stage == null))
         {
            this.barrage.hideInput();
         }
      }
      
      private function onBarrageShowInput() : void
      {
         if((R.skin.barrageSupport) && !(this.barrage == null) && !(this.barrage.stage == null))
         {
            if(Application.application.width >= 500 && Application.application.height >= 400)
            {
               this.barrage.showInput();
            }
         }
      }
      
      private function onBarrageUpdate(param1:DisplayBarEvent = null) : void
      {
         if((R.skin.barrageSupport) && (this.opening))
         {
            this.barrage.addEventListener(BarrageEvent.SEND_MSG,this.onSendBarrageMsg);
            this.barrage.addEventListener(BarrageEvent.INPUT_SET,this.onInputSet);
            this.barrage.addEventListener(BarrageEvent.IMAGE_STATE,this.onSendBarrageEm);
            viewComponent.addChild(this.barrage);
            this.barrage.y = this.dockheight;
            this.barrage.viewPort = new Rectangle(0,0,main.width,main.height - this.dockheight - R.controlbar.cHeight);
            sendNotification(AssistNotify.MOUSE_MOVE);
            this.barrage.showInput();
            this.onBarrageInputTipUpdate();
         }
         else
         {
            this.onBarrageDestroy();
            this.barrage.removeEventListener(BarrageEvent.SEND_MSG,this.onSendBarrageMsg);
            this.barrage.removeEventListener(BarrageEvent.INPUT_SET,this.onInputSet);
            this.barrage.removeEventListener(BarrageEvent.IMAGE_STATE,this.onSendBarrageEm);
            if(this.barrage.stage != null)
            {
               viewComponent.removeChild(this.barrage);
            }
         }
      }
      
      private function onBarrageInputTipUpdate() : void
      {
         if((this.opening) && !(this.barrage.stage == null))
         {
            if(main.fullscreen)
            {
               if(!PlayerVersion.supportFullscreenInput)
               {
                  this.barrage.inputTip = InputTipState.INPUT_VERSION_ERROR;
               }
               else if(!sdk.getFullscreenInput())
               {
                  this.barrage.inputTip = InputTipState.INPUT_SET;
               }
               else
               {
                  this.barrage.inputTip = null;
               }
               
            }
            else
            {
               this.barrage.inputTip = null;
            }
         }
      }
      
      private function onBarrageDataReset(param1:Boolean = false) : void
      {
         sendNotification(LoadNotify.BARRAGE_LOAD,{
            "command":BarrageCommand.RESET_BARRAGE,
            "value":param1
         });
      }
      
      private function onBarrageTimeLoop(param1:Object) : void
      {
         if((R.skin.barrageSupport) && (this.opening))
         {
            sendNotification(LoadNotify.BARRAGE_LOAD,{
               "command":BarrageCommand.LOOP_BARRAGE,
               "value":param1.videoTime
            });
         }
      }
      
      private function onBarragePush(param1:Object) : void
      {
         var _loc2_:* = 0;
         if(!(this.barrage.stage == null) && !(param1 == null))
         {
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               this.barrage.append(param1[_loc2_]);
               _loc2_++;
            }
         }
      }
      
      private function onBarrageResume() : void
      {
         if(R.skin.barrageSupport)
         {
            this.barrage.resume();
         }
      }
      
      private function onBarragePause() : void
      {
         if(R.skin.barrageSupport)
         {
            this.barrage.pause();
         }
      }
   }
}
