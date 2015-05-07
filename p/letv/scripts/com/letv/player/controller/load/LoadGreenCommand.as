package com.letv.player.controller.load
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.letv.player.model.proxy.FilterProxy;
   
   public class LoadGreenCommand extends SimpleCommand
   {
      
      public function LoadGreenCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         facade.registerProxy(new FilterProxy());
         var _loc2_:FilterProxy = facade.retrieveProxy(FilterProxy.NAME) as FilterProxy;
         _loc2_.load(param1.getBody());
      }
   }
}
