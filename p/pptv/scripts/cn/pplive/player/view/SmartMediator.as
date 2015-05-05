package cn.pplive.player.view
{
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlashMediator;
   import flash.display.Stage;
   import flash.display.MovieClip;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import flash.ui.ContextMenu;
   import cn.pplive.player.common.VodPlay;
   import cn.pplive.player.manager.ViewManager;
   import cn.pplive.player.common.VodCommon;
   import cn.pplive.player.utils.hash.Global;
   import flash.ui.ContextMenuItem;
   import flash.events.Event;
   
   public class SmartMediator extends FlashMediator
   {
      
      public static const NAME:String = "smart_mediator";
      
      private var $content = null;
      
      public function SmartMediator(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      public function get stage() : Stage
      {
         return this.view.stage;
      }
      
      public function get view() : MovieClip
      {
         return viewComponent as MovieClip;
      }
      
      public function get content() : *
      {
         return this.$content;
      }
      
      override public function onRegister() : void
      {
      }
      
      public function respondToVodSmart(param1:INotification) : void
      {
         var _loc3_:ContextMenu = null;
         this.$content = param1.getBody();
         this.view.addChild(this.$content);
         var _loc2_:Object = {
            "dur":VodPlay.duration,
            "controlH":40
         };
         try
         {
            _loc2_["controlH"] = ViewManager.getInstance().getMediator("skin").skin.disH;
         }
         catch(evt:Error)
         {
         }
         this.$content.dataInfo = _loc2_;
         this.setSize(VodCommon.playerWidth,VodCommon.playerHeight);
         this.$content.addEventListener("_seekvideo_",this.onSmartHandler);
         try
         {
            if(Global.getInstance()["root"])
            {
               _loc3_ = Global.getInstance()["root"].contextMenu;
               _loc3_.customItems.push(new ContextMenuItem("smartClick " + this.$content["smartVersion"]));
               Global.getInstance()["root"].contextMenu = _loc3_;
            }
         }
         catch(evt:Error)
         {
         }
      }
      
      private function onSmartHandler(param1:Event) : void
      {
         switch(param1.type)
         {
            case "_seekvideo_":
               try
               {
                  Global.getInstance()["seekVideo"](this.$content["headTime"]);
               }
               catch(evt:Error)
               {
               }
               break;
         }
      }
      
      public function set headTime(param1:Number) : void
      {
         try
         {
            this.$content.headTime = param1;
         }
         catch(evt:Error)
         {
         }
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
         try
         {
            this.$content.setSize(param1,param2,Global.getInstance()["rect"]);
         }
         catch(evt:Error)
         {
         }
      }
   }
}
