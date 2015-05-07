package com.letv.player
{
   import com.alex.core.Application;
   import flash.events.Event;
   import com.letv.player.facade.MyFacade;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import flash.system.Security;
   
   public class Player extends Application
   {
      
      private var loop:int;
      
      public function Player()
      {
         Security.allowDomain("*");
         Security.allowInsecureDomain("*");
         super();
         if(stage != null)
         {
            this.onInit();
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,this.onInit);
         }
      }
      
      private function onInit(param1:Event = null) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onInit);
         if(stage.stageWidth > 0)
         {
            MyFacade.getInstance().startup(this);
         }
         else
         {
            this.setLoop(true);
         }
      }
      
      private function setLoop(param1:Boolean) : void
      {
         clearInterval(this.loop);
         if(param1)
         {
            this.loop = setInterval(this.onLoop,10);
         }
      }
      
      private function onLoop() : void
      {
         if(stage.stageWidth > 0)
         {
            this.setLoop(false);
            MyFacade.getInstance().startup(this);
         }
      }
   }
}
