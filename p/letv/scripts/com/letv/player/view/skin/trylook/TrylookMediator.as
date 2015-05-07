package com.letv.player.view.skin.trylook
{
   import com.letv.player.facade.MyMediator;
   import com.letv.player.notify.GlobalNofity;
   import com.letv.player.notify.LogicNotify;
   import com.letv.player.notify.AssistNotify;
   import org.puremvc.as3.interfaces.INotification;
   import com.letv.player.components.trylook.TryLookUI;
   import com.letv.player.components.trylook.TryLookEvent;
   import com.alex.utils.BrowserUtil;
   import com.letv.pluginsAPI.pay.Pay;
   
   public class TrylookMediator extends MyMediator
   {
      
      public static const NAME:String = "trylookMediator";
      
      private var trylook:TryLookUI;
      
      public function TrylookMediator(param1:Object)
      {
         super(NAME,param1);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [GlobalNofity.GLOBAL_RESIZE,LogicNotify.VIDEO_SLEEP,LogicNotify.VIDEO_AUTH_VALID,AssistNotify.DISPLAY_TRYLOOK,AssistNotify.BUY_VIDEO,LogicNotify.VIDEO_NEXT];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var notification:INotification = param1;
         try
         {
            switch(notification.getName())
            {
               case GlobalNofity.GLOBAL_RESIZE:
                  this.trylook.resize();
                  break;
               case LogicNotify.VIDEO_SLEEP:
               case LogicNotify.VIDEO_NEXT:
                  this.trylook.hide();
                  break;
               case LogicNotify.VIDEO_AUTH_VALID:
                  this.trylook.setBuyBtnStateByVip(sdk.getUserinfo());
                  break;
               case AssistNotify.DISPLAY_TRYLOOK:
                  this.trylook.show();
                  break;
               case AssistNotify.BUY_VIDEO:
                  this.onBuyVideo();
                  break;
            }
         }
         catch(e:Error)
         {
            if(viewComponent != null)
            {
               R.log.append("[UI V2]TrylookMediator.handleNotification " + notification.getName() + " " + e.message,"error");
            }
         }
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         this.trylook = new TryLookUI(R.skin.trylook);
         this.trylook.addEventListener(TryLookEvent.BUY_VIDEO,this.onBuyVideo);
         viewComponent.addElement(this.trylook);
      }
      
      private function onBuyVideo(param1:TryLookEvent = null) : void
      {
         var event:TryLookEvent = param1;
         try
         {
            switch(event.dataProvider.type)
            {
               case TryLookUI.BTN_USE_TICKET:
                  this.trylook.mouseChildren = false;
                  sdk.setUsePayTicket(this.onUsePayTicketSuccess,this.onUsePayTicketFailed);
                  break;
               case TryLookUI.BTN_BUY_VOD:
                  BrowserUtil.openBlankWindow(event.dataProvider.data,stage);
                  break;
               default:
                  BrowserUtil.openBlankWindow(Pay.PAY_TRYLOOK_URL + "&from=" + R.coops.typeFrom,stage);
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function onUsePayTicketSuccess() : void
      {
         this.trylook.usePayTicketCallBack(true);
         this.trylook.mouseChildren = true;
      }
      
      private function onUsePayTicketFailed() : void
      {
         this.trylook.usePayTicketCallBack(false);
         this.trylook.mouseChildren = true;
      }
   }
}
