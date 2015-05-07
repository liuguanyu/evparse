package com.letv.player.components.displayBar.classes
{
   import com.letv.player.components.BaseRightDisplayPopup;
   import flash.events.MouseEvent;
   import flash.system.System;
   import com.greensock.TweenLite;
   import com.letv.player.model.config.SkinDisplayBarConfig;
   
   public class ShareUI extends BaseRightDisplayPopup
   {
      
      private var timeout:int;
      
      private var videoInfo:Object;
      
      private var blogData:String = "";
      
      private var htmlData:String = "";
      
      private var flashData:String;
      
      public function ShareUI(param1:Object, param2:Array = null)
      {
         super(param1);
      }
      
      public function setData(param1:Object) : void
      {
         this.videoInfo = param1;
         this.blogData = "<object width=\'541\' height=\'450\'><param name=\'allowFullScreen\' value=\'true\'>" + "<param name=\'movie\' value=\'" + param1.shareSwf + "\'/>" + "<embed src=\'" + param1.shareSwf + "\' width=\'541\' height=\'450\' allowFullScreen=\'true\' type=\'application/x-shockwave-flash\'/>" + "</object>";
         if(skin.blogTxt != null)
         {
            skin.blogTxt.text = this.blogData;
         }
         this.htmlData = param1.url;
         if(skin.htmlTxt != null)
         {
            skin.htmlTxt.text = this.htmlData;
         }
         this.flashData = param1.shareSwf;
         if(skin.flashTxt != null)
         {
            skin.flashTxt.text = this.flashData;
         }
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         if(skin.tip != null)
         {
            skin.tip.alpha = 0;
         }
      }
      
      override protected function addListener() : void
      {
         super.addListener();
         if(skin.closeBtn != null)
         {
            skin.closeBtn.addEventListener(MouseEvent.CLICK,this.onCloseShare);
         }
         if(skin.copyBlog != null)
         {
            skin.copyBlog.addEventListener(MouseEvent.CLICK,this.onCopyContent);
         }
         if(skin.copyFlash != null)
         {
            skin.copyFlash.addEventListener(MouseEvent.CLICK,this.onCopyContent);
         }
         if(skin.copyHtml != null)
         {
            skin.copyHtml.addEventListener(MouseEvent.CLICK,this.onCopyContent);
         }
         if(skin.share_qqmb != null)
         {
            skin.share_qqmb.addEventListener(MouseEvent.CLICK,this.onShareQQmb);
         }
         if(skin.share_sinaminiblog != null)
         {
            skin.share_sinaminiblog.addEventListener(MouseEvent.CLICK,this.onShareSina);
         }
         if(skin.share_renren != null)
         {
            skin.share_renren.addEventListener(MouseEvent.CLICK,this.onShareRenren);
         }
         if(skin.share_qzone != null)
         {
            skin.share_qzone.addEventListener(MouseEvent.CLICK,this.onShareQzone);
         }
      }
      
      override protected function removeListener() : void
      {
         super.removeListener();
         if(skin.closeBtn != null)
         {
            skin.closeBtn.removeEventListener(MouseEvent.CLICK,this.onCloseShare);
         }
         if(skin.copyBlog != null)
         {
            skin.copyBlog.removeEventListener(MouseEvent.CLICK,this.onCopyContent);
         }
         if(skin.copyFlash != null)
         {
            skin.copyFlash.removeEventListener(MouseEvent.CLICK,this.onCopyContent);
         }
         if(skin.copyHtml != null)
         {
            skin.copyHtml.removeEventListener(MouseEvent.CLICK,this.onCopyContent);
         }
         if(skin.share_qqmb != null)
         {
            skin.share_qqmb.removeEventListener(MouseEvent.CLICK,this.onShareQQmb);
         }
         if(skin.share_sinaminiblog != null)
         {
            skin.share_sinaminiblog.removeEventListener(MouseEvent.CLICK,this.onShareSina);
         }
         if(skin.share_renren != null)
         {
            skin.share_renren.removeEventListener(MouseEvent.CLICK,this.onShareRenren);
         }
         if(skin.share_qzone != null)
         {
            skin.share_qzone.removeEventListener(MouseEvent.CLICK,this.onShareQzone);
         }
      }
      
      private function onCopyContent(param1:MouseEvent) : void
      {
         switch(param1.currentTarget)
         {
            case skin.copyBlog:
               System.setClipboard(this.blogData);
               break;
            case skin.copyFlash:
               System.setClipboard(this.flashData);
               break;
            case skin.copyHtml:
               System.setClipboard(this.htmlData);
               break;
         }
         if(skin.tip != null)
         {
            skin.tip.visible = true;
            skin.tip.alpha = 0;
            TweenLite.to(skin.tip,0.5,{
               "alpha":1,
               "onComplete":this.onTipHideComplete
            });
         }
      }
      
      private function onTipHideComplete() : void
      {
         skin.tip.visible = false;
      }
      
      private function onDelay() : void
      {
         TweenLite.to(skin.tip,0.3,{"alpha":0});
      }
      
      private function onShareQQmb(param1:MouseEvent) : void
      {
         systemManager.setFullScreen(false);
         SkinDisplayBarConfig.sendSharePic(SkinDisplayBarConfig.SHARE_QWEIBO,this.videoInfo.url,this.getTitle(this.videoInfo.title));
      }
      
      private function onShareSina(param1:MouseEvent) : void
      {
         systemManager.setFullScreen(false);
         SkinDisplayBarConfig.sendSharePic(SkinDisplayBarConfig.SHARE_WEIBO,this.videoInfo.url,this.getTitle(this.videoInfo.title));
      }
      
      private function onShareRenren(param1:MouseEvent) : void
      {
         systemManager.setFullScreen(false);
         SkinDisplayBarConfig.sendSharePic(SkinDisplayBarConfig.SHARE_RENREN,this.videoInfo.url,this.getTitle(this.videoInfo.title));
      }
      
      private function onShareQzone(param1:MouseEvent) : void
      {
         systemManager.setFullScreen(false);
         SkinDisplayBarConfig.sendSharePic(SkinDisplayBarConfig.SHARE_QZONE,this.videoInfo.url,this.getTitle(this.videoInfo.title));
      }
      
      private function getTitle(param1:String) : String
      {
         return "我在乐视网正在看 #" + param1 + "#";
      }
      
      private function onCloseShare(param1:MouseEvent) : void
      {
         hide();
      }
   }
}
