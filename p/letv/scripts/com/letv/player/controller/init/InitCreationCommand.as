package com.letv.player.controller.init
{
   import org.puremvc.as3.patterns.command.SimpleCommand;
   import org.puremvc.as3.interfaces.INotification;
   import com.letv.player.facade.MyResource;
   import com.letv.player.view.PlayerLayer;
   import com.letv.pluginsAPI.stat.PageDebugLog;
   import com.letv.player.notify.InitNotify;
   import com.letv.player.notify.LoadNotify;
   import com.letv.player.controller.load.LoadLetvConfigCommand;
   import com.letv.player.view.system.SystemMenuMediator;
   import com.letv.player.view.global.GlobalMediator;
   import com.letv.player.view.system.SystemWarnMediator;
   import com.letv.player.view.skin.loading.LoadingMediator;
   import com.alex.utils.PlayerVersion;
   import com.letv.player.notify.ErrorNotify;
   import com.letv.pluginsAPI.kernel.PlayerError;
   
   public class InitCreationCommand extends SimpleCommand
   {
      
      public function InitCreationCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:Object = param1.getBody();
         var _loc3_:MyResource = MyResource.getInstance();
         _loc3_.initFlashvars(_loc2_.info);
         var _loc4_:PlayerLayer = PlayerLayer.getInstance();
         _loc4_.init(_loc2_.main);
         if(_loc3_.flashvars.debugJs)
         {
            PageDebugLog.getInstance().callJsLog(PageDebugLog.STARTUP_PLAYER);
         }
         facade.registerCommand(InitNotify.INIT_PLUGIN,InitPluginCommand);
         facade.registerCommand(InitNotify.INIT_LAYER,InitLayerCommand);
         facade.registerCommand(LoadNotify.LOAD_LETV_CONFIG,LoadLetvConfigCommand);
         if(!facade.hasMediator(SystemMenuMediator.NAME))
         {
            facade.registerMediator(new SystemMenuMediator(_loc4_.main));
         }
         if(!facade.hasMediator(GlobalMediator.NAME))
         {
            facade.registerMediator(new GlobalMediator(_loc4_.main));
         }
         if(!facade.hasMediator(SystemWarnMediator.NAME))
         {
            facade.registerMediator(new SystemWarnMediator(_loc4_.warnLayer));
         }
         if(!facade.hasMediator(LoadingMediator.NAME))
         {
            facade.registerMediator(new LoadingMediator(_loc4_.loadingLayer));
         }
         if(!PlayerVersion.supportStageVideo)
         {
            sendNotification(ErrorNotify.ERROR_IN_CREATION,{"errorCode":PlayerError.FLASH_PLAYER_WARNING});
            return;
         }
         sendNotification(LoadNotify.LOAD_LETV_CONFIG);
      }
   }
}
