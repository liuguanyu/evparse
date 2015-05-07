package com.letv.player.controller.init
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.letv.player.model.proxy.PluginProxy;
   import com.letv.player.notify.LoadNotify;
   import com.letv.player.controller.load.LoadPluginCommand;
   import com.letv.player.facade.MyResource;
   import com.letv.player.view.PlayerLayer;
   import com.letv.player.view.plugin.ExtendMediator;
   import com.letv.player.view.skin.controlBar.ControlBarMediator;
   import com.letv.player.view.skin.trylook.TrylookMediator;
   import com.letv.player.view.skin.displayBar.FirstlookMediator;
   import com.letv.player.view.skin.displayBar.DisplayBarMediator;
   import com.letv.player.view.plugin.RecommendMediator;
   import com.letv.player.view.plugin.SdkMediator;
   import com.letv.player.view.skin.barrage.BarrageMediator;
   import com.letv.player.view.skin.displayBar.LoginlookMediator;
   import com.letv.player.view.skin.loading.LoadingMediator;
   import com.letv.player.notify.GlobalNofity;
   
   public class InitLayerCommand extends SimpleCommand
   {
      
      public function InitLayerCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         facade.removeProxy(PluginProxy.NAME);
         facade.registerCommand(LoadNotify.PLUGIN_LOAD,LoadPluginCommand);
         var _loc2_:MyResource = MyResource.getInstance();
         _loc2_.initSkin(param1.getBody());
         var _loc3_:PlayerLayer = PlayerLayer.getInstance();
         _loc3_.initPlugins(param1.getBody());
         facade.registerMediator(new ExtendMediator(_loc3_.extendLayer));
         facade.registerMediator(new ControlBarMediator(_loc3_.controlBarLayer));
         facade.registerMediator(new TrylookMediator(_loc3_.trylookLayer));
         facade.registerMediator(new FirstlookMediator(_loc3_.firstlookLayer));
         facade.registerMediator(new DisplayBarMediator(_loc3_.displayBarLayer));
         facade.registerMediator(new RecommendMediator(_loc3_.recommendLayer));
         facade.registerMediator(new SdkMediator(_loc3_.sdkLayer));
         facade.registerMediator(new BarrageMediator(_loc3_.barrageLayer));
         facade.registerMediator(new LoginlookMediator(_loc3_.firstlookLayer));
         var _loc4_:LoadingMediator = facade.retrieveMediator(LoadingMediator.NAME) as LoadingMediator;
         if(_loc4_ != null)
         {
            _loc4_.setData(_loc2_.skin.loading);
         }
         facade.sendNotification(GlobalNofity.GLOBAL_RESIZE);
      }
   }
}
