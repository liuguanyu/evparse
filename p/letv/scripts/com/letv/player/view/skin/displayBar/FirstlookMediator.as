package com.letv.player.view.skin.displayBar
{
   import com.letv.player.facade.MyMediator;
   import com.letv.player.notify.GlobalNofity;
   import com.letv.player.notify.LogicNotify;
   import com.letv.player.notify.AssistNotify;
   import org.puremvc.as3.interfaces.INotification;
   import com.letv.player.components.displayBar.FirstlookUI;
   
   public class FirstlookMediator extends MyMediator
   {
      
      public static const NAME:String = "tryTVMediator";
      
      private var firstlook:FirstlookUI;
      
      public function FirstlookMediator(param1:Object)
      {
         super(NAME,param1);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [GlobalNofity.GLOBAL_RESIZE,LogicNotify.PLAYER_FIRSTLOOK,AssistNotify.FIRSTLOOK,LogicNotify.VIDEO_AUTH_VALID,LogicNotify.VIDEO_NEXT,LogicNotify.SEEK_TO];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var notification:INotification = param1;
         try
         {
            switch(notification.getName())
            {
               case GlobalNofity.GLOBAL_RESIZE:
                  this.firstlook.resize();
                  break;
               case LogicNotify.VIDEO_AUTH_VALID:
               case LogicNotify.VIDEO_NEXT:
               case LogicNotify.SEEK_TO:
                  this.firstlook.visible = false;
                  break;
               case LogicNotify.PLAYER_FIRSTLOOK:
                  this.firstlook.visible = true;
                  this.firstlook.showFirstlook(1,notification.getBody().toString());
                  break;
               case AssistNotify.FIRSTLOOK:
                  if(notification.getBody().istip)
                  {
                     this.firstlook.visible = true;
                     this.firstlook.showFirstlook(2,notification.getBody().ref);
                  }
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
         this.firstlook = new FirstlookUI(R.skin.firstlook);
         viewComponent.addElement(this.firstlook);
      }
   }
}
