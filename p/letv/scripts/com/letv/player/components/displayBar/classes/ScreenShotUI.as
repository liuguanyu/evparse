package com.letv.player.components.displayBar.classes
{
   import com.letv.player.components.BaseRightDisplayPopup;
   import com.letv.player.components.displayBar.classes.screenshot.ScreenShotItem;
   import com.letv.player.components.displayBar.DisplayBarEvent;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.FocusEvent;
   import flash.events.TextEvent;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import com.letv.player.model.stat.LetvStatistics;
   import com.letv.pluginsAPI.api.JsAPI;
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   
   public class ScreenShotUI extends BaseRightDisplayPopup
   {
      
      private const MAX_INPUT:uint = 140;
      
      private var _index:int;
      
      private var _target:ScreenShotItem;
      
      private var _stack:Vector.<ScreenShotItem>;
      
      private var _container:Sprite;
      
      private var beforePlayingState:Boolean;
      
      private var timeline:TimelineLite;
      
      private const JS_API_LOGIN:String = "LETV.User.Logon.playerDlg";
      
      private const DEFAULT_TEXT:String = "说说赞当前剧情的理由吧。大家都能在评论区看到，可能会获得强烈共鸣哦。";
      
      public function ScreenShotUI(param1:Object = null)
      {
         super(param1);
      }
      
      override public function resize(param1:Boolean = false) : void
      {
         var GAP:uint = 0;
         var INPUT_MAX_HEIGHT:uint = 0;
         var leaveHeight:Number = NaN;
         var continuePosition:Number = NaN;
         var action:Boolean = param1;
         super.resize(action);
         if(stage != null)
         {
            if(skin.input == null)
            {
               return;
            }
            if(skin.inputBack == null)
            {
               return;
            }
            GAP = 10;
            INPUT_MAX_HEIGHT = 150;
            leaveHeight = applicationHeight - skin.inputBack.y;
            if(skin.sendBtn != null)
            {
               leaveHeight = leaveHeight - (skin.sendBtn.height + GAP + GAP * 0.5);
            }
            if(skin.inputTip != null)
            {
               leaveHeight = leaveHeight - (skin.inputTip.height + GAP * 0.5);
            }
            if(leaveHeight >= INPUT_MAX_HEIGHT)
            {
               leaveHeight = INPUT_MAX_HEIGHT;
            }
            skin.inputBack.height = leaveHeight;
            skin.input.height = skin.inputBack.height - (skin.input.y - skin.inputBack.y) * 2;
            continuePosition = skin.inputBack.y + skin.inputBack.height;
            try
            {
               skin.inputTip.y = continuePosition + GAP * 0.5;
               continuePosition = skin.inputTip.y + skin.inputTip.height + GAP;
            }
            catch(e:Error)
            {
            }
            try
            {
               skin.sendBtn.y = continuePosition;
               skin.sendLoading.y = skin.sendBtn.y + (skin.sendBtn.height - skin.sendLoading.height) * 0.5;
            }
            catch(e:Error)
            {
            }
         }
      }
      
      public function refresh(param1:Object) : void
      {
         var item:ScreenShotItem = null;
         var i:uint = 0;
         var value:Object = param1;
         if(stage == null || !visible)
         {
            return;
         }
         this.removeAllPics();
         var list:Array = value as Array;
         if(!(list == null) && list.length > 0)
         {
            this._index = 0;
            this._stack = new Vector.<ScreenShotItem>();
            i = 0;
            while(i < list.length)
            {
               item = new ScreenShotItem(list[i]);
               item.width = skin.videoShow.videoBoard.width;
               item.height = skin.videoShow.videoBoard.height;
               this._stack.push(item);
               i++;
            }
            this.displayCutPic(this._index);
         }
         try
         {
            if(this._stack == null || this._stack.length <= 1)
            {
               skin.left.visible = false;
               skin.right.visible = false;
            }
            else
            {
               skin.left.visible = true;
               skin.right.visible = true;
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public function setCommentBack(param1:Object) : void
      {
         var _loc2_:Object = null;
         this.setSendLoading(false);
         if(param1 != null)
         {
            this.setErrorTip(param1);
         }
         else if(opening)
         {
            _loc2_ = sdk.getVideoSetting();
            dispatchEvent(new DisplayBarEvent(DisplayBarEvent.OVER_COMMENT,{
               "content":this.getContent(),
               "url":_loc2_["url"],
               "title":_loc2_["title"],
               "pic":this.getPic()
            }));
         }
         
      }
      
      override public function show(param1:Object = null) : void
      {
         super.show();
         this.beforePlayingState = param1["playing"];
         if(skin.input != null)
         {
            skin.input.text = this.DEFAULT_TEXT;
         }
         if(skin.inputTip != null)
         {
            skin.inputTip.htmlText = "<font face=\'Microsoft YaHei,微软雅黑,Arial\'>评论最多可输入140字</font>";
            skin.inputTip.autoSize = TextFieldAutoSize.LEFT;
         }
         this.refresh(param1["info"]);
         if(this.beforePlayingState)
         {
            dispatchEvent(new DisplayBarEvent(DisplayBarEvent.SCREENSHOT_PAUSE_VIDEO));
         }
      }
      
      override public function hide(param1:Object = null) : void
      {
         if((opening) && !(stage == null))
         {
            super.hide();
            this.setSendLoading(false);
            if(this.beforePlayingState)
            {
               dispatchEvent(new DisplayBarEvent(DisplayBarEvent.SCREENSHOT_RESUME_VIDEO));
            }
         }
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         var format:TextFormat = new TextFormat();
         format.font = "Microsoft YaHei,微软雅黑,Arial";
         try
         {
            this._container = new Sprite();
            skin.videoShow.addChild(this._container);
            skin.videoShow.mouseEnabled = false;
            skin.videoShow.mouseChildren = false;
         }
         catch(e:Error)
         {
         }
         try
         {
            skin.input.restrict = "^ @#";
            skin.input.maxChars = this.MAX_INPUT;
            skin.input.defaultTextFormat = format;
         }
         catch(e:Error)
         {
         }
         try
         {
            skin.inputTip.defaultTextFormat = format;
            skin.inputTip.autoSize = TextFieldAutoSize.LEFT;
            skin.inputTip.mouseEnabled = false;
         }
         catch(e:Error)
         {
         }
         try
         {
            skin.sendError.visible = false;
            skin.sendError.mouseEnabled = false;
            skin.sendError.mouseChildren = false;
         }
         catch(e:Error)
         {
         }
         this.setSendLoading(false);
      }
      
      override protected function addListener() : void
      {
         super.addListener();
         try
         {
            skin.left.addEventListener(MouseEvent.CLICK,this.onPrevious);
            skin.right.addEventListener(MouseEvent.CLICK,this.onNext);
         }
         catch(e:Error)
         {
         }
         if(skin.input != null)
         {
            skin.input.addEventListener(FocusEvent.FOCUS_IN,this.onInputFocusIn);
            skin.input.addEventListener(FocusEvent.FOCUS_OUT,this.onInputFocusOut);
            skin.input.addEventListener(TextEvent.TEXT_INPUT,this.onInputing);
            skin.input.addEventListener(Event.CHANGE,this.onInputing);
         }
         if(skin.sendBtn != null)
         {
            skin.sendBtn.addEventListener(MouseEvent.CLICK,this.onSend);
         }
      }
      
      override protected function removeListener() : void
      {
         super.removeListener();
         try
         {
            skin.left.removeEventListener(MouseEvent.CLICK,this.onPrevious);
            skin.right.removeEventListener(MouseEvent.CLICK,this.onNext);
         }
         catch(e:Error)
         {
         }
         if(skin.input != null)
         {
            skin.input.removeEventListener(FocusEvent.FOCUS_IN,this.onInputFocusIn);
            skin.input.removeEventListener(FocusEvent.FOCUS_OUT,this.onInputFocusOut);
            skin.input.removeEventListener(TextEvent.TEXT_INPUT,this.onInputing);
            skin.input.removeEventListener(Event.CHANGE,this.onInputing);
         }
         if(skin.sendBtn != null)
         {
            skin.sendBtn.removeEventListener(MouseEvent.CLICK,this.onSend);
         }
         skin.removeEventListener(KeyboardEvent.KEY_DOWN,this.onInputing);
         skin.removeEventListener(KeyboardEvent.KEY_UP,this.onInputing);
      }
      
      private function onPrevious(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         try
         {
            skin.saveBtn.visible = false;
         }
         catch(e:Error)
         {
         }
         if(this._index == 0)
         {
            this._index = this._stack.length - 1;
         }
         else
         {
            this._index--;
         }
         this.displayCutPic(this._index);
      }
      
      private function onNext(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         try
         {
            skin.saveBtn.visible = false;
         }
         catch(e:Error)
         {
         }
         if(this._index == this._stack.length - 1)
         {
            this._index = 0;
         }
         else
         {
            this._index++;
         }
         this.displayCutPic(this._index);
      }
      
      private function onInputFocusIn(param1:FocusEvent) : void
      {
         var event:FocusEvent = param1;
         try
         {
            if(skin.input.text == this.DEFAULT_TEXT)
            {
               skin.input.text = "";
            }
            skin.inputBack.gotoAndStop("in");
            skin.addEventListener(KeyboardEvent.KEY_DOWN,this.onInputing);
            skin.addEventListener(KeyboardEvent.KEY_UP,this.onInputing);
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
            if(skin.input.text == "")
            {
               skin.input.text = this.DEFAULT_TEXT;
            }
            skin.inputBack.gotoAndStop("out");
            skin.removeEventListener(KeyboardEvent.KEY_DOWN,this.onInputing);
            skin.removeEventListener(KeyboardEvent.KEY_UP,this.onInputing);
         }
         catch(e:Error)
         {
         }
      }
      
      private function onInputing(param1:Event) : void
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
         
         var _loc2_:int = skin.input.text.length;
         if(_loc2_ >= this.MAX_INPUT)
         {
            skin.inputBack.gotoAndStop("error");
         }
         else
         {
            skin.inputBack.gotoAndStop("in");
         }
         if(skin.inputTip != null)
         {
            if(_loc2_ <= 0)
            {
               skin.inputTip.htmlText = "<font face=\'Microsoft YaHei,微软雅黑,Arial\'>评论最多可输入140字</font>";
            }
            else if(_loc2_ <= this.MAX_INPUT)
            {
               skin.inputTip.htmlText = "<font face=\'Microsoft YaHei,微软雅黑,Arial\'>还可以输入" + (this.MAX_INPUT - _loc2_) + "字</font>";
            }
            else
            {
               skin.inputTip.htmlText = "<font face=\'Microsoft YaHei,微软雅黑,Arial\'>已经超过</font><font color=\'#FF0000\'>" + (_loc2_ - this.MAX_INPUT) + "</font>字</font>";
            }
            
            skin.inputTip.autoSize = TextFieldAutoSize.LEFT;
         }
      }
      
      private function onSend(param1:MouseEvent) : void
      {
         R.stat.sendDocDebug(LetvStatistics.SCR_CMT_SEND);
         if(sdk != null)
         {
            if(sdk.getUserinfo()["uid"] != null)
            {
               this.setSendLoading(true);
               dispatchEvent(new DisplayBarEvent(DisplayBarEvent.ADD_COMMENT,{
                  "content":this.getContent(),
                  "pic":this.getPic()
               }));
            }
            else
            {
               systemManager.setFullScreen(false);
               browserManager.callScript(JsAPI.DISPLAY_LOGIN);
            }
         }
      }
      
      private function getContent() : String
      {
         if(!(skin.input.text == this.DEFAULT_TEXT) && !(skin.input.text == ""))
         {
            return skin.input.text;
         }
         var _loc1_:Array = ["这个视频有亮点哦！忍不住赞一下~","这里太赞了！","这一幕真精彩！幸亏没有错过~","哈哈，错过这个镜头的都会后悔吧~","亮瞎了好吗！！","镜头君，你这么亮你家人知道吗？","差点儿错过这里！好险~","我给你点32个赞！！！","怎么看都是这里最亮！"];
         return _loc1_[Math.round(Math.random() * (_loc1_.length - 1))];
      }
      
      private function getPic() : String
      {
         if(this._target != null)
         {
            return this._target.source;
         }
         return "";
      }
      
      private function setSendLoading(param1:Boolean) : void
      {
         var flag:Boolean = param1;
         try
         {
            if(flag)
            {
               skin.sendBtn.alpha = 0.8;
               skin.sendBtn.mouseEnabled = false;
               skin.sendLoading.visible = true;
               skin.sendLoading.play();
            }
            else
            {
               skin.sendBtn.alpha = 1;
               skin.sendBtn.mouseEnabled = true;
               skin.sendLoading.visible = false;
               skin.sendLoading.stop();
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function setErrorTip(param1:Object) : void
      {
         var value:Object = param1;
         try
         {
            skin.sendError.label.wordWrap = false;
            skin.sendError.label.text = value;
            skin.sendError.label.autoSize = TextFieldAutoSize.LEFT;
            if(skin.sendError.label.width > 150)
            {
               skin.sendError.label.width = 150;
               skin.sendError.label.wordWrap = true;
            }
            skin.sendError.back.height = skin.sendError.label.height + 20;
            skin.sendError.label.x = (skin.sendError.back.width - skin.sendError.label.width) * 0.5;
            skin.sendError.label.y = (skin.sendError.back.height - skin.sendError.label.height) * 0.5;
            skin.sendError.x = (skin.back.width - skin.sendError.width) * 0.5;
            skin.sendError.visible = true;
            skin.sendError.alpha = 0;
            if(this.timeline != null)
            {
               this.timeline.kill();
               this.timeline = null;
            }
            this.timeline = new TimelineLite({"onComplete":this.onErrorHideComplete});
            this.timeline.append(new TweenLite(skin.sendError,0.5,{"alpha":1}));
            this.timeline.append(new TweenLite(skin.sendError,0.5,{
               "alpha":0,
               "delay":1.5
            }));
            skin.sendError.y = skin.sendBtn.y - skin.sendError.height - 5;
         }
         catch(e:Error)
         {
         }
      }
      
      private function onErrorHideComplete() : void
      {
         skin.sendError.visible = false;
      }
      
      private function displayCutPic(param1:uint) : void
      {
         var value:uint = param1;
         try
         {
            this._container.removeChild(this._target.skin);
         }
         catch(e:Error)
         {
         }
         this._target = this._stack[value];
         this._target.display();
         this._container.addChild(this._target.skin);
      }
      
      private function removeAllPics() : void
      {
         var _loc1_:ScreenShotItem = null;
         if(this._stack != null)
         {
            while(this._stack.length > 0)
            {
               _loc1_ = this._stack.shift();
               _loc1_.destroy();
            }
            _loc1_ = null;
            this._stack = null;
         }
      }
      
      override protected function onClose(param1:MouseEvent = null) : void
      {
         super.onClose();
      }
   }
}
