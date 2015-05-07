package com.letv.player.controller.load
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.letv.player.model.proxy.PushProxy;
   
   public class LoadPushCommand extends SimpleCommand
   {
      
      public function LoadPushCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         if(!facade.hasProxy(PushProxy.NAME))
         {
            facade.registerProxy(new PushProxy());
         }
         var _loc2_:PushProxy = facade.retrieveProxy(PushProxy.NAME) as PushProxy;
         _loc2_.start();
      }
   }
}
