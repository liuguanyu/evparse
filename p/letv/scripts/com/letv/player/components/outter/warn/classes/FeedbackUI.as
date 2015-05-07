package com.letv.player.components.outter.warn.classes
{
   import com.letv.player.components.outter.warn.BaseWarnPopup;
   import flash.display.MovieClip;
   import com.alex.controls.RadioButtonGroup2;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import com.letv.player.components.outter.warn.OutterWarnEvent;
   import com.alex.utils.RichStringUtil;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class FeedbackUI extends BaseWarnPopup
   {
      
      private var layer:MovieClip;
      
      private var delay:int;
      
      private var defaultGroup:RadioButtonGroup2;
      
      private var defaultText:Array;
      
      private var backgroundStack:Object;
      
      private const MAX_INPUT:uint = 100;
      
      public function FeedbackUI(param1:Object = null)
      {
         super(param1);
      }
      
      override protected function initialize() : void
      {
         var item:Object = null;
         super.initialize();
         this.layer = skin.feedbacklayer;
         this.layer.visible = true;
         this.marginTop = this.layer.closeBtn.height / 2;
         this.originalWidth = this.originalWidth + this.layer.closeBtn.width / 2;
         this.originalHeight = this.originalHeight + this.layer.closeBtn.height / 2;
         this.backgroundStack = {};
         skin.feedbacksuccess.visible = false;
         if(this.layer.phoneInput != null)
         {
            this.backgroundStack[this.layer.phoneInput.name] = this.layer.phoneBackground;
            this.layer.phoneInput.restrict = "0-9";
            this.layer.phoneInput.maxChars = 11;
         }
         if(this.layer.mailInput != null)
         {
            this.backgroundStack[this.layer.mailInput.name] = this.layer.mailBackground;
            this.layer.mailInput.restrict = "^ ";
            this.layer.mailInput.maxChars = 50;
         }
         if(this.layer.contentInput != null)
         {
            this.backgroundStack[this.layer.contentInput.name] = this.layer.contentBackground;
            this.layer.contentInput.maxChars = 100;
         }
         if(this.layer.closeBtn != null)
         {
            this.layer.closeBtn.tabEnabled = false;
         }
         for each(item in this.backgroundStack)
         {
            item["mouseEnabled"] = false;
            item["mouseChildren"] = false;
         }
         try
         {
            this.defaultGroup = new RadioButtonGroup2([this.layer.videoBlock,this.layer.videoBlack,this.layer.videoDumb,this.layer.videoOther]);
            this.defaultText = ["视频卡顿","视频黑屏","视频无声音/图像","其他"];
            this.defaultGroup.level = 0;
         }
         catch(e:Error)
         {
         }
      }
      
      override protected function onAddedToStage(param1:Event = null) : void
      {
         this.clearInput();
         if(this.layer.submitBtn != null)
         {
            this.layer.submitBtn.addEventListener(MouseEvent.CLICK,this.onSend);
         }
         if(this.layer.returnBtn != null)
         {
            this.layer.returnBtn.addEventListener(MouseEvent.CLICK,this.onReturn);
         }
         if(this.layer.faq != null)
         {
            this.layer.faq.addEventListener(MouseEvent.CLICK,this.onFAQ);
         }
         if(this.layer.closeBtn != null)
         {
            this.layer.closeBtn.addEventListener(MouseEvent.CLICK,this.onReturn);
         }
         if(this.layer.contentInput != null)
         {
            this.layer.contentInput.addEventListener(TextEvent.TEXT_INPUT,this.onContentInputing);
            this.layer.contentInput.addEventListener(FocusEvent.FOCUS_IN,this.onInputFocusIn);
            this.layer.contentInput.addEventListener(FocusEvent.FOCUS_OUT,this.onInputFocusOut);
            this.layer.stage.focus = skin;
            this.layer.stage.focus = this.layer.contentInput;
         }
         if(this.layer.phoneInput != null)
         {
            this.layer.phoneInput.addEventListener(TextEvent.TEXT_INPUT,this.onPhoneInputing);
            this.layer.phoneInput.addEventListener(FocusEvent.FOCUS_IN,this.onInputFocusIn);
            this.layer.phoneInput.addEventListener(FocusEvent.FOCUS_OUT,this.onInputFocusOut);
         }
         if(this.layer.mailInput != null)
         {
            this.layer.mailInput.addEventListener(TextEvent.TEXT_INPUT,this.onMailInputing);
            this.layer.mailInput.addEventListener(FocusEvent.FOCUS_IN,this.onInputFocusIn);
            this.layer.mailInput.addEventListener(FocusEvent.FOCUS_OUT,this.onInputFocusOut);
         }
      }
      
      override protected function onRemovedFromStage(param1:Event = null) : void
      {
         if(this.layer.submitBtn != null)
         {
            this.layer.submitBtn.removeEventListener(MouseEvent.CLICK,this.onSend);
         }
         if(this.layer.returnBtn != null)
         {
            this.layer.returnBtn.removeEventListener(MouseEvent.CLICK,this.onReturn);
         }
         if(this.layer.faq != null)
         {
            this.layer.faq.removeEventListener(MouseEvent.CLICK,this.onFAQ);
         }
         if(this.layer.closeBtn != null)
         {
            this.layer.closeBtn.removeEventListener(MouseEvent.CLICK,this.onReturn);
         }
         if(this.layer.contentInput != null)
         {
            this.layer.contentInput.removeEventListener(TextEvent.TEXT_INPUT,this.onContentInputing);
            this.layer.contentInput.removeEventListener(FocusEvent.FOCUS_IN,this.onInputFocusIn);
            this.layer.contentInput.removeEventListener(FocusEvent.FOCUS_OUT,this.onInputFocusOut);
         }
         if(this.layer.phoneInput != null)
         {
            this.layer.phoneInput.removeEventListener(TextEvent.TEXT_INPUT,this.onPhoneInputing);
            this.layer.phoneInput.removeEventListener(FocusEvent.FOCUS_IN,this.onInputFocusIn);
            this.layer.phoneInput.removeEventListener(FocusEvent.FOCUS_OUT,this.onInputFocusOut);
         }
         if(this.layer.mailInput != null)
         {
            this.layer.mailInput.removeEventListener(TextEvent.TEXT_INPUT,this.onMailInputing);
            this.layer.mailInput.removeEventListener(FocusEvent.FOCUS_IN,this.onInputFocusIn);
            this.layer.mailInput.removeEventListener(FocusEvent.FOCUS_OUT,this.onInputFocusOut);
         }
         this.layer.removeEventListener(KeyboardEvent.KEY_DOWN,this.onContentInputing);
         this.layer.removeEventListener(KeyboardEvent.KEY_UP,this.onContentInputing);
         this.layer.removeEventListener(KeyboardEvent.KEY_DOWN,this.onPhoneInputing);
         this.layer.removeEventListener(KeyboardEvent.KEY_UP,this.onPhoneInputing);
         this.layer.removeEventListener(KeyboardEvent.KEY_DOWN,this.onMailInputing);
         this.layer.removeEventListener(KeyboardEvent.KEY_UP,this.onMailInputing);
      }
      
      private function clearInput() : void
      {
         if(this.layer.contentInput != null)
         {
            this.layer.contentInput.text = "";
         }
         if(this.layer.phoneInput != null)
         {
            this.layer.phoneInput.text = "";
         }
         if(this.layer.mailInput != null)
         {
            this.layer.mailInput.text = "";
         }
         if(this.layer.tip != null)
         {
            this.layer.tip.text = "留下联系方式，以便您的问题更快被解决。";
         }
         if(this.layer)
         {
            this.layer.visible = true;
         }
         if(skin.feedbacksuccess)
         {
            skin.feedbacksuccess.visible = false;
         }
      }
      
      private function onInputFocusIn(param1:FocusEvent) : void
      {
         var event:FocusEvent = param1;
         try
         {
            this.backgroundStack[event.target.name].gotoAndStop("in");
            this.layer.removeEventListener(KeyboardEvent.KEY_DOWN,this.onContentInputing);
            this.layer.removeEventListener(KeyboardEvent.KEY_UP,this.onContentInputing);
            this.layer.removeEventListener(KeyboardEvent.KEY_DOWN,this.onPhoneInputing);
            this.layer.removeEventListener(KeyboardEvent.KEY_UP,this.onPhoneInputing);
            this.layer.removeEventListener(KeyboardEvent.KEY_DOWN,this.onMailInputing);
            this.layer.removeEventListener(KeyboardEvent.KEY_UP,this.onMailInputing);
            switch(event.target)
            {
               case this.layer.contentInput:
                  if(event.target.text == "内容不能为空哦~")
                  {
                     event.target.text = "";
                  }
                  this.layer.addEventListener(KeyboardEvent.KEY_DOWN,this.onContentInputing);
                  this.layer.addEventListener(KeyboardEvent.KEY_UP,this.onContentInputing);
                  break;
               case this.layer.phoneInput:
                  this.layer.addEventListener(KeyboardEvent.KEY_DOWN,this.onPhoneInputing);
                  this.layer.addEventListener(KeyboardEvent.KEY_UP,this.onPhoneInputing);
                  break;
               case this.layer.mailInput:
                  this.layer.addEventListener(KeyboardEvent.KEY_DOWN,this.onMailInputing);
                  this.layer.addEventListener(KeyboardEvent.KEY_UP,this.onMailInputing);
                  break;
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function onInputFocusOut(param1:FocusEvent) : void
      {
         var event:FocusEvent = param1;
         try
         {
            this.backgroundStack[event.target.name].gotoAndStop("out");
            this.layer.removeEventListener(KeyboardEvent.KEY_DOWN,this.onContentInputing);
            this.layer.removeEventListener(KeyboardEvent.KEY_UP,this.onContentInputing);
            this.layer.removeEventListener(KeyboardEvent.KEY_DOWN,this.onPhoneInputing);
            this.layer.removeEventListener(KeyboardEvent.KEY_UP,this.onPhoneInputing);
            this.layer.removeEventListener(KeyboardEvent.KEY_DOWN,this.onMailInputing);
            this.layer.removeEventListener(KeyboardEvent.KEY_UP,this.onMailInputing);
         }
         catch(e:Error)
         {
         }
      }
      
      private function onContentInputing(param1:Event) : void
      {
         if(param1 is KeyboardEvent)
         {
            param1.stopPropagation();
            param1.stopImmediatePropagation();
         }
         else if(param1 is TextEvent)
         {
            if((param1 as TextEvent).text == "\n")
            {
               param1.preventDefault();
            }
         }
         
         if(this.layer.contentInput.text.length >= this.MAX_INPUT)
         {
            this.layer.contentBackground.gotoAndStop("error");
         }
         else
         {
            this.layer.contentBackground.gotoAndStop("in");
         }
      }
      
      private function onPhoneInputing(param1:Event) : void
      {
         if(this.layer.phoneInput.text.length > 11)
         {
            this.layer.phoneBackground.gotoAndStop("error");
         }
         else
         {
            this.layer.phoneBackground.gotoAndStop("in");
         }
      }
      
      private function onMailInputing(param1:Event) : void
      {
         if(this.layer.mailInput.text.length >= 50)
         {
            this.layer.mailBackground.gotoAndStop("error");
         }
         else
         {
            this.layer.mailBackground.gotoAndStop("in");
         }
      }
      
      private function onSend(param1:MouseEvent) : void
      {
         var phoneFlag:Boolean = false;
         var mailFlag:Boolean = false;
         var obj:Object = null;
         var e:OutterWarnEvent = null;
         var event:MouseEvent = param1;
         try
         {
            phoneFlag = this.layer.phoneInput.text == "" || this.layer.phoneInput.text.length < 6;
            mailFlag = this.layer.mailInput.text == "";
            if(this.layer.contentInput.text == "" || this.layer.contentInput.text == "内容不能为空哦~")
            {
               this.layer.contentInput.htmlText = "<font face=\'Microsoft YaHei,微软雅黑,Arial\' color=\'#CCCCCC\'>内容不能为空哦~</font>";
               return;
            }
            if(!mailFlag && !RichStringUtil.isEmail(this.layer.mailInput.text))
            {
               this.layer.mailBackground.gotoAndStop("error");
               return;
            }
            if((phoneFlag) && (mailFlag))
            {
               this.layer.phoneBackground.gotoAndStop("error");
               return;
            }
            obj = {
               "content":null,
               "phone":null,
               "mail":null
            };
            if(this.layer.contentInput != null)
            {
               obj["content"] = this.defaultText[this.defaultGroup.level] + "-" + this.layer.contentInput.text;
            }
            if(this.layer.phoneInput != null)
            {
               obj["phone"] = this.layer.phoneInput.text;
            }
            if(this.layer.mailInput != null)
            {
               obj["email"] = this.layer.mailInput.text;
            }
            this.layer.visible = false;
            skin.feedbacksuccess.visible = true;
            e = new OutterWarnEvent(OutterWarnEvent.FEEDBACK);
            e.dataProvider = obj;
            dispatchEvent(e);
            this.setDelay(true);
         }
         catch(e:Error)
         {
         }
      }
      
      private function onReturn(param1:MouseEvent = null) : void
      {
         dispatchEvent(new OutterWarnEvent(OutterWarnEvent.RETURN_BACK));
      }
      
      private function onFAQ(param1:MouseEvent) : void
      {
         dispatchEvent(new OutterWarnEvent(OutterWarnEvent.FAQ_PAGE));
      }
      
      private function setDelay(param1:Boolean) : void
      {
         clearTimeout(this.delay);
         if(param1)
         {
            this.layer.submitBtn.alpha = 0.5;
            this.layer.submitBtn.mouseEnabled = false;
            this.delay = setTimeout(this.onDelay,30000);
         }
      }
      
      private function onDelay() : void
      {
         try
         {
            this.layer.submitBtn.alpha = 1;
            this.layer.submitBtn.mouseEnabled = true;
         }
         catch(e:Error)
         {
         }
      }
   }
}
