package com.letv.player.components.displayBar.classes
{
   import com.letv.player.components.BaseCenterDisplayPopup;
   import flash.text.TextFormat;
   import flash.text.StyleSheet;
   import flash.text.TextFieldAutoSize;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import com.alex.utils.BrowserUtil;
   import com.letv.pluginsAPI.pay.Pay;
   import com.letv.pluginsAPI.api.JsAPI;
   
   public class VipVideoUI extends BaseCenterDisplayPopup
   {
      
      private var btnBack:uint = 130;
      
      private const CSS:String = "a{font-size:12px;color:#009FE9;font-family:Microsoft YaHei,微软雅黑}a:hover{color:#FF9900;text-decoration:underline}";
      
      public function VipVideoUI(param1:Object = null)
      {
         super(param1);
      }
      
      override public function display(param1:Object = null) : void
      {
         this.show(param1);
      }
      
      override public function show(param1:Object = null) : void
      {
         var userinfo:Object = null;
         var value:Object = param1;
         if(skin != null)
         {
            super.show();
            visible = true;
            resize(true);
            if(skin.panel_1080 != null)
            {
               skin.panel_1080.visible = true;
            }
            try
            {
               skin.btn.label.text = "立即开通会员";
               skin.btn.back.width = this.btnBack;
               skin.btn.label.x = (skin.btn.back.width - skin.btn.label.width) / 2;
               skin.btn.label.y = (skin.btn.back.height - skin.btn.label.height) / 2;
               skin.btn.x = (skin.back.width - skin.btn.back.width) / 2;
            }
            catch(e:Error)
            {
            }
            userinfo = value["userinfo"];
            try
            {
               if(userinfo.uid != null)
               {
                  skin.vipLabel.visible = false;
               }
               else
               {
                  skin.vipLabel.visible = true;
                  skin.vipLabel.htmlText = "<font face=\'Microsoft YaHei,微软雅黑\'>如果您已是乐视会员,<a href=\'event:login\'>请登录</a></font>";
                  skin.vipLabel.x = (skin.back.width - skin.vipLabel.width) / 2;
               }
            }
            catch(e:Error)
            {
            }
         }
         if(skin != null)
         {
            return;
         }
      }
      
      override public function hide(param1:Object = null) : void
      {
         super.hide();
      }
      
      override protected function initialize() : void
      {
         var format:TextFormat = null;
         var css:StyleSheet = null;
         super.initialize();
         try
         {
            this.btnBack = skin.btn.back.width;
            skin.btn.buttonMode = true;
            skin.btn.mouseChildren = false;
            skin.btn.label.autoSize = TextFieldAutoSize.LEFT;
            format = new TextFormat();
            format.font = "Microsoft YaHei,微软雅黑,Arial";
            skin.btn.label.defaultTextFormat = format;
         }
         catch(e:Error)
         {
         }
         try
         {
            skin.vipLabel.autoSize = TextFieldAutoSize.LEFT;
            css = new StyleSheet();
            css.parseCSS(this.CSS);
            skin.vipLabel.styleSheet = css;
         }
         catch(e:Error)
         {
         }
      }
      
      override protected function addListener() : void
      {
         if(skin.closeBtn != null)
         {
            skin.closeBtn.addEventListener(MouseEvent.CLICK,this.onClose);
         }
         if(skin.btn != null)
         {
            skin.btn.addEventListener(MouseEvent.CLICK,this.onJoin);
         }
         if(skin.vipLabel != null)
         {
            skin.vipLabel.addEventListener(TextEvent.LINK,this.onVipLabelLink);
         }
      }
      
      override protected function removeListener() : void
      {
         if(skin.closeBtn != null)
         {
            skin.closeBtn.removeEventListener(MouseEvent.CLICK,this.onClose);
         }
         if(skin.btn != null)
         {
            skin.btn.removeEventListener(MouseEvent.CLICK,this.onJoin);
         }
         if(skin.vipLabel != null)
         {
            skin.vipLabel.removeEventListener(TextEvent.LINK,this.onVipLabelLink);
         }
      }
      
      private function onClose(param1:MouseEvent = null) : void
      {
         this.hide();
      }
      
      private function onJoin(param1:MouseEvent = null) : void
      {
         var event:MouseEvent = param1;
         try
         {
            if(skin.btn.label.text == "立即开通会员")
            {
               skin.btn.label.text = "开通会员后点击刷新";
               skin.btn.back.width = skin.btn.label.width + 20;
               skin.btn.label.x = (skin.btn.back.width - skin.btn.label.width) / 2;
               skin.btn.label.y = (skin.btn.back.height - skin.btn.label.height) / 2;
               skin.btn.x = (skin.back.width - skin.btn.back.width) / 2;
               BrowserUtil.openBlankWindow(Pay.PAY_DEF_URL + "&from=" + R.coops.typeFrom,stage);
            }
            else
            {
               BrowserUtil.openSelfWindow(BrowserUtil.url,stage);
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function onVipLabelLink(param1:TextEvent) : void
      {
         switch(param1.text)
         {
            case "login":
               systemManager.setFullScreen(false);
               browserManager.callScript(JsAPI.DISPLAY_LOGIN,BrowserUtil.url);
               break;
         }
      }
   }
}
