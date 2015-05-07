package com.letv.player.controller.load
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.letv.player.model.proxy.PluginSetupProxy;
   
   public class LoadPluginCommand extends SimpleCommand
   {
      
      public function LoadPluginCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc3_:Object = null;
         if(!facade.hasProxy(PluginSetupProxy.NAME))
         {
            facade.registerProxy(new PluginSetupProxy());
         }
         var _loc2_:PluginSetupProxy = facade.retrieveProxy(PluginSetupProxy.NAME) as PluginSetupProxy;
         if(_loc2_)
         {
            _loc3_ = param1.getBody();
            if(_loc3_)
            {
               _loc2_.loadPlugin(_loc3_["name"],_loc3_["url"]);
            }
         }
      }
   }
}
