package com.letv.player.components.displayBar.classes
{
   import com.letv.player.components.BaseRightDisplayPopup;
   import flash.events.MouseEvent;
   import com.letv.player.model.stat.LetvStatistics;
   import com.alex.utils.BrowserUtil;
   import com.letv.player.model.config.SkinDisplayBarConfig;
   import com.letv.player.components.displayBar.DisplayBarEvent;
   
   public class ZanUI extends BaseRightDisplayPopup
   {
      
      private var info:Object;
      
      public function ZanUI(param1:Object = null)
      {
         super(param1);
      }
      
      override public function show(param1:Object = null) : void
      {
         super.show(param1);
         this.info = param1;
      }
      
      override protected function addListener() : void
      {
         super.addListener();
         if(skin.zanLink != null)
         {
            skin.zanLink.addEventListener(MouseEvent.CLICK,this.onZanLink);
         }
         if(skin.zanPage != null)
         {
            skin.zanPage.addEventListener(MouseEvent.CLICK,this.onZanPage);
         }
         if(skin.share_sinaminiblog != null)
         {
            skin.share_sinaminiblog.addEventListener(MouseEvent.CLICK,this.onShareToSinaBlog);
         }
      }
      
      override protected function removeListener() : void
      {
         super.removeListener();
         if(skin.zanLink != null)
         {
            skin.zanLink.removeEventListener(MouseEvent.CLICK,this.onZanLink);
         }
         if(skin.zanPage != null)
         {
            skin.zanPage.removeEventListener(MouseEvent.CLICK,this.onZanPage);
         }
         if(skin.share_sinaminiblog != null)
         {
            skin.share_sinaminiblog.removeEventListener(MouseEvent.CLICK,this.onShareToSinaBlog);
         }
      }
      
      private function onZanLink(param1:MouseEvent) : void
      {
         R.stat.sendDocDebug(LetvStatistics.SCR_CMT_MORE);
         systemManager.setFullScreen(false);
         browserManager.callScript("LETV.Utils.gotoAnchor",".Comment");
      }
      
      private function onZanPage(param1:MouseEvent) : void
      {
         BrowserUtil.openBlankWindow("http://pinglun.letv.com",stage);
      }
      
      private function onShareToSinaBlog(param1:MouseEvent) : void
      {
         var title:String = null;
         var content:String = null;
         var event:MouseEvent = param1;
         R.stat.sendDocDebug(LetvStatistics.SHARE_SCR_CMT);
         systemManager.setFullScreen(false);
         try
         {
            title = this.info.title;
            if(title.length > 20)
            {
               title = title.substr(0,20) + "...";
            }
            content = this.info.content;
            if(content.length > 100)
            {
               content = content.substr(0,100) + "...";
            }
            SkinDisplayBarConfig.sendSharePic(SkinDisplayBarConfig.SHARE_WEIBO,this.info.url,"《" + title + "》惊现亮点：" + content,this.info.pic);
         }
         catch(e:Error)
         {
         }
      }
      
      override protected function onClose(param1:MouseEvent = null) : void
      {
         super.onClose();
         dispatchEvent(new DisplayBarEvent(DisplayBarEvent.SCREENSHOT_RESUME_VIDEO));
      }
   }
}
