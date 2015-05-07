package com.letv.player.components.displayBar.classes
{
   import com.letv.player.components.BaseCenterDisplayPopup;
   import com.letv.player.components.displayBar.DisplayBarEvent;
   import com.alex.rpc.AutoLoader;
   import com.alex.rpc.events.AutoLoaderEvent;
   import com.alex.rpc.type.ResourceType;
   import com.alex.utils.JSONUtil;
   import com.alex.controls.Image;
   import com.alex.states.BitmapFillMode;
   import flash.events.IOErrorEvent;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import com.alex.utils.BrowserUtil;
   import flash.net.sendToURL;
   import flash.net.URLRequest;
   import com.letv.pluginsAPI.api.JsAPI;
   import flash.events.TextEvent;
   import flash.text.StyleSheet;
   import flash.text.TextFieldAutoSize;
   
   public class VipAdUI extends BaseCenterDisplayPopup
   {
      
      private var _oRectWidth:Number;
      
      private var _oRectHeight:Number;
      
      private const GAP:uint = 10;
      
      private var vipStatus:Object;
      
      private var image:Image;
      
      private var _vipadImageLink:String = "";
      
      private var _vipadImage:String = "";
      
      private const URL:String = "http://www.letv.com/cmsdata/block/2270.json";
      
      public function VipAdUI(param1:Object = null)
      {
         super(param1);
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         if(skin.back != null)
         {
            this.resetOriginal(skin.back.width,skin.back.height);
         }
         else
         {
            this.resetOriginal(width,height);
         }
         this.onShowDefault(false);
         this.onShowLoading(false);
      }
      
      override public function show(param1:Object = null) : void
      {
         this.getImageData();
         this.vipStatus = param1.status;
         this.reset(false,true);
         super.show();
      }
      
      override public function hide(param1:Object = null) : void
      {
         if(!(stage == null) && (opening))
         {
            super.hide();
            dispatchEvent(new DisplayBarEvent(DisplayBarEvent.VIP_AD_CLOSE));
         }
      }
      
      private function getImageData() : void
      {
         var _loc1_:AutoLoader = new AutoLoader();
         _loc1_.addEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.completeHandler);
         _loc1_.addEventListener(AutoLoaderEvent.LOAD_ERROR,this.errorHandler);
         _loc1_.setup([{
            "type":ResourceType.TEXT,
            "url":this.URL
         }]);
      }
      
      private function errorHandler(param1:AutoLoaderEvent) : void
      {
         param1.target.removeEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.completeHandler);
         param1.target.removeEventListener(AutoLoaderEvent.LOAD_ERROR,this.errorHandler);
         this.onImageError();
      }
      
      private function completeHandler(param1:AutoLoaderEvent) : void
      {
         var obj:Object = null;
         var event:AutoLoaderEvent = param1;
         try
         {
            event.target.removeEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.completeHandler);
            event.target.removeEventListener(AutoLoaderEvent.LOAD_ERROR,this.errorHandler);
            obj = JSONUtil.decode(String(event.dataProvider.content));
            if(obj.blockContent[0].url != null)
            {
               this._vipadImageLink = obj.blockContent[0].url;
            }
            if(!(obj.blockContent[0].pic1 == null) && !(obj.blockContent[0].pic1 == ""))
            {
               if(this.image == null)
               {
                  this.image = new Image();
                  this.image.fillMode = BitmapFillMode.ORIGINAL;
                  this.image.smoothing = true;
                  this.image.backgroundAlpha = 0;
                  this.image.buttonMode = !(this._vipadImageLink == "");
                  this.image.x = this.GAP;
                  this.image.y = this.GAP;
                  this.image.addEventListener(IOErrorEvent.IO_ERROR,this.onImageError);
                  this.image.addEventListener(Event.COMPLETE,this.onImageComplete);
                  this.image.source = obj.blockContent[0].pic1;
                  addElement(this.image);
               }
               else
               {
                  addElement(this.image);
                  this.onImageComplete();
               }
            }
            else
            {
               this.onImageError();
            }
         }
         catch(e:Error)
         {
            onImageError();
         }
      }
      
      private function onImageError(param1:Event = null) : void
      {
         if(this.image != null)
         {
            this.image.removeEventListener(IOErrorEvent.IO_ERROR,this.onImageError);
            this.image.removeEventListener(Event.COMPLETE,this.onImageComplete);
         }
         this.reset(true,false);
         this.onImageDestroy();
      }
      
      private function onImageComplete(param1:Event = null) : void
      {
         var _loc2_:* = NaN;
         var _loc3_:* = NaN;
         this.image.removeEventListener(IOErrorEvent.IO_ERROR,this.onImageError);
         this.image.removeEventListener(Event.COMPLETE,this.onImageComplete);
         if(this.image.width > 0 && this.image.height > 0)
         {
            _loc2_ = this.image.width + 2 * this.GAP;
            _loc3_ = this.image.height + 2 * this.GAP;
            this.resetOriginal(_loc2_,_loc3_);
            this.reset(false,false);
            super.show();
         }
         else
         {
            this.onImageError();
         }
      }
      
      private function onImageDestroy() : void
      {
         if(this.image != null)
         {
            this.image.removeEventListener(IOErrorEvent.IO_ERROR,this.onImageError);
            this.image.removeEventListener(Event.COMPLETE,this.onImageComplete);
            this.image.destroy();
            if(this.image.parent)
            {
               removeElement(this.image);
            }
            this.image = null;
         }
      }
      
      private function reset(param1:Boolean, param2:Boolean) : void
      {
         if(skin.login != null)
         {
            skin.login.x = this._oRectWidth - this.GAP - skin.login.width;
            skin.login.y = this.GAP;
            skin.login.visible = true;
            addChild(skin.login);
         }
         if(skin.closeBtn)
         {
            skin.closeBtn.x = this._oRectWidth - skin.closeBtn.width / 2;
            skin.closeBtn.y = -skin.closeBtn.height / 2;
            skin.closeBtn.visible = true;
            addChild(skin.closeBtn);
         }
         this.onShowDefault(param1);
         this.onShowLoading(param2);
      }
      
      private function resetOriginal(param1:Number, param2:Number) : void
      {
         originalWidth = this._oRectWidth = param1;
         originalHeight = this._oRectHeight = param2;
         if(skin.back)
         {
            skin.back.width = param1;
            skin.back.height = param2;
         }
         if(skin.closeBtn)
         {
            originalWidth = originalWidth + skin.closeBtn.width / 2;
            originalHeight = originalHeight + skin.closeBtn.height / 2;
            marginTop = skin.closeBtn.height * 0.5;
         }
      }
      
      private function onClose(param1:MouseEvent = null) : void
      {
         this.hide("action");
      }
      
      private function onJoin(param1:MouseEvent = null) : void
      {
         if(this._vipadImageLink != null)
         {
            BrowserUtil.openBlankWindow(this._vipadImageLink,stage);
            sendToURL(new URLRequest("http://dc.letv.com/s/?k=sumtmp;qadfc"));
         }
      }
      
      private function onIsVip(param1:MouseEvent = null) : void
      {
         systemManager.setFullScreen(false);
         browserManager.callScript(JsAPI.DISPLAY_LOGIN,BrowserUtil.url);
      }
      
      private function onDefaultLabelLink(param1:TextEvent) : void
      {
         switch(param1.text)
         {
            case "login":
               this.onIsVip();
               break;
         }
      }
      
      private function onShowDefault(param1:Boolean) : void
      {
         var _loc2_:StyleSheet = null;
         var _loc3_:String = null;
         if(skin.defaultLabel != null)
         {
            if(param1)
            {
               skin.defaultLabel.visible = true;
               if(skin.defaultLabel.htmlText == "")
               {
                  _loc2_ = new StyleSheet();
                  _loc2_.parseCSS("a:hover{color:#00A0E9;text-decoration:underline}");
                  skin.defaultLabel.styleSheet = _loc2_;
                  _loc3_ = "<font face=\'Microsoft YaHei,微软雅黑,Arial\' size=\'20\'>加入乐视会员,享受100%无广告</font>\n\n";
                  _loc3_ = _loc3_ + "<font face=\'Microsoft YaHei,微软雅黑,Arial\' size=\'12\' color=\'#CCCCCC\'><a class=\'login\' href=\'event:login\'>如果您已经是会员请点击登录</a></font>";
                  skin.defaultLabel.htmlText = _loc3_;
               }
               skin.defaultLabel.autoSize = TextFieldAutoSize.LEFT;
               skin.defaultLabel.x = (this._oRectWidth - skin.defaultLabel.width) * 0.5;
               skin.defaultLabel.y = (this._oRectHeight - skin.defaultLabel.height) * 0.5;
            }
            else
            {
               skin.defaultLabel.visible = false;
            }
         }
      }
      
      private function onShowLoading(param1:Boolean) : void
      {
         var value:Boolean = param1;
         try
         {
            if(skin.loading.mouseEnabled)
            {
               skin.loading.mouseEnabeld = false;
               skin.loading.mouseChildren = false;
            }
            if(value)
            {
               skin.loading.play();
               skin.loading.visible = true;
               skin.loading.x = (this._oRectWidth - skin.loading.width) * 0.5;
               skin.loading.y = (this._oRectHeight - skin.loading.height) * 0.5;
            }
            else
            {
               skin.loading.stop();
               skin.loading.visible = false;
            }
         }
         catch(e:Error)
         {
         }
      }
      
      override protected function addListener() : void
      {
         super.addListener();
         if(skin.closeBtn != null)
         {
            skin.closeBtn.addEventListener(MouseEvent.CLICK,this.onClose);
         }
         if(!(this.image == null) && (this.image.buttonMode))
         {
            this.image.addEventListener(MouseEvent.CLICK,this.onJoin);
         }
         if(!(skin.login == null) && (skin.login.visible))
         {
            skin.login.addEventListener(MouseEvent.CLICK,this.onIsVip);
         }
         if(!(skin.defaultLabel == null) && (skin.defaultLabel.visible))
         {
            skin.defaultLabel.addEventListener(TextEvent.LINK,this.onDefaultLabelLink);
         }
      }
      
      override protected function removeListener() : void
      {
         super.removeListener();
         if(skin.closeBtn != null)
         {
            skin.closeBtn.removeEventListener(MouseEvent.CLICK,this.onClose);
         }
         if(this.image != null)
         {
            this.image.removeEventListener(MouseEvent.CLICK,this.onJoin);
         }
         if(skin.login != null)
         {
            skin.login.removeEventListener(MouseEvent.CLICK,this.onIsVip);
         }
         if(skin.defaultLabel != null)
         {
            skin.defaultLabel.removeEventListener(TextEvent.LINK,this.onDefaultLabelLink);
         }
      }
   }
}
