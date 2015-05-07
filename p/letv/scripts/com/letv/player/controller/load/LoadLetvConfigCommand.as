package com.letv.player.controller.load
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.letv.player.model.proxy.ConfigProxy;
   
   public class LoadLetvConfigCommand extends SimpleCommand
   {
      
      public function LoadLetvConfigCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         facade.registerProxy(new ConfigProxy());
         var _loc2_:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
         _loc2_.load(param1.getBody());
      }
   }
}
