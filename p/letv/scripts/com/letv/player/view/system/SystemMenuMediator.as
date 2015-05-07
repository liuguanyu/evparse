package com.letv.player.view.system
{
   import com.letv.player.facade.MyMediator;
   import flash.ui.ContextMenuItem;
   import com.letv.player.notify.LogicNotify;
   import com.letv.player.notify.AssistNotify;
   import com.letv.player.notify.RecommendNotify;
   import org.puremvc.as3.interfaces.INotification;
   import flash.ui.ContextMenu;
   import flash.events.ContextMenuEvent;
   import flash.system.System;
   
   public class SystemMenuMediator extends MyMediator
   {
      
      public static const NAME:String = "systemMenuMediator";
      
      private var ITEM_VERSION:ContextMenuItem;
      
      private const ITEM_VIDEO_INFO:ContextMenuItem = new ContextMenuItem("视频信息",true);
      
      private const ITEM_COPY_INFO:ContextMenuItem = new ContextMenuItem("复制调试信息");
      
      public function SystemMenuMediator(param1:Object)
      {
         super(NAME,param1);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [LogicNotify.VIDEO_START,LogicNotify.VIDEO_REPLAY,LogicNotify.SEEK_TO,LogicNotify.VIDEO_SLEEP,LogicNotify.VIDEO_NEXT,LogicNotify.VIDEO_STOP,AssistNotify.DISPLAY_TRYLOOK,RecommendNotify.SHOW_RECOMMEND,LogicNotify.PLAYER_FIRSTLOOK,LogicNotify.PLAYER_LOGINLOOK];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         switch(param1.getName())
         {
            case LogicNotify.VIDEO_START:
            case LogicNotify.VIDEO_REPLAY:
            case LogicNotify.SEEK_TO:
               this.unlock();
               break;
            case LogicNotify.VIDEO_NEXT:
            case LogicNotify.VIDEO_SLEEP:
            case LogicNotify.VIDEO_STOP:
            case AssistNotify.DISPLAY_TRYLOOK:
            case RecommendNotify.SHOW_RECOMMEND:
            case LogicNotify.PLAYER_FIRSTLOOK:
            case LogicNotify.PLAYER_LOGINLOOK:
               this.lock();
               break;
         }
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         this.ITEM_VERSION = new ContextMenuItem(R.plugins.VERSION,true,false);
         var _loc1_:ContextMenu = new ContextMenu();
         _loc1_.hideBuiltInItems();
         _loc1_.customItems.push(this.ITEM_VERSION);
         _loc1_.customItems.push(this.ITEM_VIDEO_INFO);
         _loc1_.customItems.push(this.ITEM_COPY_INFO);
         this.ITEM_VIDEO_INFO.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,this.onVideoInfo);
         this.ITEM_COPY_INFO.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,this.onCopyInfo);
         viewComponent.contextMenu = _loc1_;
         R.log.append("[UI V3X Version] " + R.plugins.VERSION);
         this.lock();
      }
      
      private function lock() : void
      {
         this.ITEM_VIDEO_INFO.enabled = false;
         this.ITEM_COPY_INFO.enabled = false;
      }
      
      private function unlock() : void
      {
         this.ITEM_VIDEO_INFO.enabled = true;
         this.ITEM_COPY_INFO.enabled = true;
      }
      
      private function onVideoInfo(param1:ContextMenuEvent) : void
      {
         if(sdk != null)
         {
            sdk.displayDebug();
         }
      }
      
      private function onCopyInfo(param1:ContextMenuEvent) : void
      {
         var event:ContextMenuEvent = param1;
         if(sdk != null)
         {
            try
            {
               System.setClipboard(sdk.getHtmlLog());
            }
            catch(e:Error)
            {
            }
         }
      }
   }
}
