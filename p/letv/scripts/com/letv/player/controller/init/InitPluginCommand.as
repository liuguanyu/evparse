package com.letv.player.controller.init
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.letv.player.facade.MyResource;
   import com.letv.player.view.skin.loading.LoadingMediator;
   import com.letv.player.model.proxy.ConfigProxy;
   import com.letv.player.notify.LoadNotify;
   import com.letv.player.controller.load.LoadVideoListCommand;
   import com.letv.player.controller.load.LoadCommentCommand;
   import com.letv.player.controller.load.LoadGreenCommand;
   import com.letv.player.controller.load.LoadBarrageCommand;
   import com.letv.player.controller.load.LoadPushCommand;
   import com.letv.player.model.proxy.PluginProxy;
   
   public class InitPluginCommand extends SimpleCommand
   {
      
      public function InitPluginCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:Object = param1.getBody();
         var _loc3_:MyResource = MyResource.getInstance();
         _loc3_.initPCCS(_loc2_.pccs);
         var _loc4_:LoadingMediator = facade.retrieveMediator(LoadingMediator.NAME) as LoadingMediator;
         if(_loc4_ != null)
         {
            _loc4_.setMainLoading(_loc2_);
         }
         facade.removeProxy(ConfigProxy.NAME);
         facade.registerCommand(LoadNotify.VIDEO_LIST_GET,LoadVideoListCommand);
         facade.registerCommand(LoadNotify.COMMENT_ADD,LoadCommentCommand);
         facade.registerCommand(LoadNotify.FILTER_DATA_GET,LoadGreenCommand);
         facade.registerCommand(LoadNotify.BARRAGE_LOAD,LoadBarrageCommand);
         facade.registerCommand(LoadNotify.PUSH_START,LoadPushCommand);
         facade.registerProxy(new PluginProxy());
         var _loc5_:PluginProxy = facade.retrieveProxy(PluginProxy.NAME) as PluginProxy;
         if(_loc5_ != null)
         {
            _loc5_.loadPlugin();
         }
      }
   }
}
