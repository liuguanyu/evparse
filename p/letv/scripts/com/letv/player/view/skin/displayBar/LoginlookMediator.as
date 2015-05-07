package com.letv.player.view.skin.displayBar
{
   import com.letv.player.facade.MyMediator;
   import com.letv.player.notify.GlobalNofity;
   import com.letv.player.notify.LogicNotify;
   import org.puremvc.as3.interfaces.INotification;
   import com.letv.player.model.stat.LetvStatistics;
   import com.letv.player.components.displayBar.LoginlookUI;
   
   public class LoginlookMediator extends MyMediator
   {
      
      public static const NAME:String = "LoginlookMediator";
      
      private var loginlook:LoginlookUI;
      
      public function LoginlookMediator(param1:Object)
      {
         super(NAME,param1);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [GlobalNofity.GLOBAL_RESIZE,LogicNotify.VIDEO_AUTH_VALID,LogicNotify.VIDEO_NEXT,LogicNotify.PLAYER_LOGINLOOK];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var notification:INotification = param1;
         try
         {
            switch(notification.getName())
            {
               case GlobalNofity.GLOBAL_RESIZE:
                  this.loginlook.resize();
                  break;
               case LogicNotify.VIDEO_AUTH_VALID:
               case LogicNotify.VIDEO_NEXT:
                  this.loginlook.visible = false;
                  break;
               case LogicNotify.PLAYER_LOGINLOOK:
                  this.loginlook.visible = true;
                  this.loginlook.stopTime = sdk.getVideoTime();
                  this.loginlook.show();
                  R.stat.sendDocDebug(LetvStatistics.LOGINLIMIT_SHOW_PANEL);
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
         this.loginlook = new LoginlookUI(R.skin.loginlook);
         viewComponent.addElement(this.loginlook);
      }
   }
}
