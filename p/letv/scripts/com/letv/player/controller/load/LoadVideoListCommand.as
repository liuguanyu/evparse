package com.letv.player.controller.load
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.letv.player.model.proxy.ListNewProxy;
   
   public class LoadVideoListCommand extends SimpleCommand
   {
      
      public function LoadVideoListCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         if(!facade.hasProxy(ListNewProxy.NAME))
         {
            facade.registerProxy(new ListNewProxy());
         }
         var _loc2_:ListNewProxy = facade.retrieveProxy(ListNewProxy.NAME) as ListNewProxy;
         if(_loc2_ != null)
         {
            _loc2_.load(param1.getBody());
         }
      }
   }
}
