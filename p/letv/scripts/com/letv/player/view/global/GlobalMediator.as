package com.letv.player.view.global
{
   import com.letv.player.facade.MyMediator;
   import com.letv.player.notify.LogicNotify;
   import com.letv.player.notify.AdNotify;
   import com.letv.player.notify.AssistNotify;
   import com.letv.player.notify.RecommendNotify;
   import org.puremvc.as3.interfaces.INotification;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.ui.Mouse;
   import flash.events.MouseEvent;
   import com.letv.player.notify.GlobalNofity;
   import flash.events.FullScreenEvent;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   import flash.display.StageDisplayState;
   
   public class GlobalMediator extends MyMediator
   {
      
      public static const NAME:String = "globalMediator";
      
      private var timeout:Timer;
      
      private var showing:Boolean;
      
      private var locked:Boolean = true;
      
      public function GlobalMediator(param1:Object)
      {
         super(NAME,param1);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [LogicNotify.SEEK_TO,LogicNotify.VIDEO_START,LogicNotify.VIDEO_REPLAY,LogicNotify.VIDEO_RESUME,LogicNotify.VIDEO_SLEEP,LogicNotify.VIDEO_NEXT,LogicNotify.VIDEO_STOP,AdNotify.AD_START,AssistNotify.DISPLAY_TRYLOOK,RecommendNotify.SHOW_RECOMMEND,LogicNotify.PLAYER_FIRSTLOOK,LogicNotify.PLAYER_LOGINLOOK,LogicNotify.CONTROLBAR_SHOW_COMPLETE,LogicNotify.CONTROLBAR_HIDE_COMPLETE];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var notification:INotification = param1;
         try
         {
            switch(notification.getName())
            {
               case LogicNotify.SEEK_TO:
               case LogicNotify.VIDEO_START:
               case LogicNotify.VIDEO_REPLAY:
               case LogicNotify.VIDEO_RESUME:
                  this.unlock();
                  break;
               case AdNotify.AD_START:
               case LogicNotify.VIDEO_NEXT:
               case LogicNotify.VIDEO_SLEEP:
               case LogicNotify.VIDEO_STOP:
               case AssistNotify.DISPLAY_TRYLOOK:
               case LogicNotify.PLAYER_FIRSTLOOK:
               case LogicNotify.PLAYER_LOGINLOOK:
                  this.lock();
                  break;
               case RecommendNotify.SHOW_RECOMMEND:
                  this.locked = false;
                  this.onStageMouseMove();
                  this.lock();
                  break;
               case LogicNotify.CONTROLBAR_SHOW_COMPLETE:
                  this.showing = true;
                  break;
               case LogicNotify.CONTROLBAR_HIDE_COMPLETE:
                  this.showing = false;
                  break;
            }
         }
         catch(e:Error)
         {
            R.log.append("[UI V2]GlobalMediator.handleNotification Error " + e.message,"error");
         }
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         R.log.append(R.plugins.pluginVersions);
         if(stage != null)
         {
            main.width = stage.stageWidth;
            main.height = stage.stageHeight;
            stage.addEventListener(Event.RESIZE,this.onResize);
            stage.addEventListener(Event.FULLSCREEN,this.onFullScreen);
            stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownVolume);
         }
      }
      
      private function lock() : void
      {
         Mouse.show();
         this.locked = true;
         viewComponent.removeEventListener(MouseEvent.ROLL_OUT,this.onStageMouseLeave);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onStageMouseMove);
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownSeek);
         stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         stage.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onStageMouseWheel);
         this.setDelay(false);
         this.showing = false;
      }
      
      private function unlock() : void
      {
         this.locked = false;
         viewComponent.addEventListener(MouseEvent.ROLL_OUT,this.onStageMouseLeave);
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onStageMouseMove);
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownSeek);
         stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.onStageMouseWheel);
         this.onStageMouseMove();
      }
      
      private function onResize(param1:Event) : void
      {
         if(stage != null)
         {
            main.width = stage.stageWidth;
            main.height = stage.stageHeight;
            sendNotification(GlobalNofity.GLOBAL_RESIZE);
            if(!this.locked)
            {
               this.onStageMouseMove();
            }
         }
      }
      
      private function onFullScreen(param1:FullScreenEvent) : void
      {
         sendNotification(GlobalNofity.GLOBAL_FULL_SCREEN,param1.fullScreen);
         sendNotification(GlobalNofity.GLOBAL_RESIZE);
         if(!this.locked)
         {
            this.onStageMouseMove();
         }
      }
      
      private function onKeyDownSeek(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.LEFT)
         {
            sendNotification(LogicNotify.KEYBOARD_SPEED_BACK);
            this.onStageMouseMove();
         }
         else if(param1.keyCode == Keyboard.RIGHT)
         {
            sendNotification(LogicNotify.KEYBOARD_SPEED_FORWARD);
            this.onStageMouseMove();
         }
         
      }
      
      private function onKeyDownVolume(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.UP)
         {
            sendNotification(GlobalNofity.GLOBAL_CHANGE_VOLUME,1);
         }
         else if(param1.keyCode == Keyboard.DOWN)
         {
            sendNotification(GlobalNofity.GLOBAL_CHANGE_VOLUME,-1);
         }
         
      }
      
      private function onKeyUp(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.LEFT || param1.keyCode == Keyboard.RIGHT)
         {
            sendNotification(LogicNotify.KEYBOARD_SPEED_GO);
         }
         else if(param1.keyCode == Keyboard.SPACE)
         {
            sendNotification(LogicNotify.VIDEO_TOGGLE);
         }
         
      }
      
      private function onStageMouseMove(param1:MouseEvent = null) : void
      {
         if(this.locked)
         {
            return;
         }
         if(param1 != null)
         {
            this.setDelay(param1.target == sdk.instance);
         }
         else
         {
            this.setDelay(true);
         }
         if(!this.showing)
         {
            this.setShowing(true);
         }
      }
      
      private function onStageMouseLeave(param1:Event) : void
      {
         this.setDelay(true);
      }
      
      private function setDelay(param1:Boolean, param2:uint = 2000.0) : void
      {
         if(param1)
         {
            if(this.timeout == null)
            {
               this.timeout = new Timer(param2,1);
            }
            this.timeout.delay = param2;
            this.timeout.addEventListener(TimerEvent.TIMER,this.onDelay);
            this.timeout.reset();
            this.timeout.start();
         }
         else if(this.timeout != null)
         {
            this.timeout.removeEventListener(TimerEvent.TIMER,this.onDelay);
            this.timeout.stop();
         }
         
      }
      
      private function onDelay(param1:TimerEvent = null) : void
      {
         this.setShowing(false);
      }
      
      private function onStageMouseWheel(param1:MouseEvent) : void
      {
         if(!(viewComponent.stage == null) && !(viewComponent.stage.displayState == StageDisplayState.NORMAL))
         {
            sendNotification(GlobalNofity.GLOBAL_MOUSE_WHEEL,param1.delta);
         }
      }
      
      private function setShowing(param1:Boolean) : void
      {
         if(param1)
         {
            Mouse.show();
            if(!this.locked)
            {
               sendNotification(GlobalNofity.GLOBAL_SHOW_CURSOR);
            }
         }
         else
         {
            if(main.fullscreen)
            {
               Mouse.hide();
            }
            sendNotification(GlobalNofity.GLOBAL_HIDE_CURSOR);
         }
      }
   }
}
