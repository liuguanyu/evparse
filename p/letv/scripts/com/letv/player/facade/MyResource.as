package com.letv.player.facade
{
   import flash.events.EventDispatcher;
   import com.letv.player.model.config.InfoFlashvarsConfig;
   import com.letv.player.model.config.InfoCoopConfig;
   import com.letv.player.model.config.SkinConfig;
   import flash.display.DisplayObjectContainer;
   import com.letv.player.model.config.SkinControlBarConfig;
   import com.letv.player.model.config.SkinDisplayBarConfig;
   import com.letv.player.model.config.AssistConfig;
   import com.letv.player.model.config.InfoExtendConfig;
   import com.letv.player.log.Logging;
   import com.letv.player.model.stat.LetvStatistics;
   import com.letv.player.model.config.InfoPluginConfig;
   
   public class MyResource extends EventDispatcher
   {
      
      private static var _instance:MyResource;
      
      public static const R:String = "0x000001";
      
      public static const SDK:String = "0x000002";
      
      public static const RECOMMEND:String = "0x000003";
      
      public static const SKIN:String = "0x000004";
      
      public static const SKIN_DOMAIN:String = "0x000005";
      
      public static const DOCK_HEIGHT:String = "0x000006";
      
      public static const BARRAGE:String = "0x000007";
      
      public static const POPUP:String = "0x000008";
      
      public static const FACADE:String = "0x000009";
      
      public static const UISTATE:String = "0x000010";
      
      public var log:Logging;
      
      public var stat:LetvStatistics;
      
      public var skin:SkinConfig;
      
      public var controlbar:SkinControlBarConfig;
      
      public var displaybar:SkinDisplayBarConfig;
      
      public var coops:InfoCoopConfig;
      
      public var assists:AssistConfig;
      
      public var flashvars:InfoFlashvarsConfig;
      
      public var plugins:InfoPluginConfig;
      
      public var extension:InfoExtendConfig;
      
      public function MyResource()
      {
         super();
         this.log = new Logging();
         this.stat = new LetvStatistics(this);
         this.plugins = new InfoPluginConfig();
      }
      
      public static function getInstance() : MyResource
      {
         if(_instance == null)
         {
            _instance = new MyResource();
         }
         return _instance;
      }
      
      public function initFlashvars(param1:Object) : void
      {
         if(this.flashvars == null)
         {
            this.flashvars = new InfoFlashvarsConfig();
            this.flashvars.init(param1);
            this.coops = new InfoCoopConfig(this.flashvars,null);
         }
      }
      
      public function initSkin(param1:Object) : void
      {
         if(param1 != null)
         {
            this.skin = new SkinConfig(param1[MyResource.SKIN] as DisplayObjectContainer);
         }
      }
      
      public function initPCCS(param1:XML) : void
      {
         var _loc2_:Object = this.flashvars.flashvars;
         this.controlbar = new SkinControlBarConfig(_loc2_,param1);
         this.displaybar = new SkinDisplayBarConfig(_loc2_,param1);
         this.coops = new InfoCoopConfig(_loc2_,param1);
         this.assists = new AssistConfig(_loc2_,param1);
         this.extension = new InfoExtendConfig(param1);
         this.plugins.init(_loc2_,param1);
      }
   }
}
