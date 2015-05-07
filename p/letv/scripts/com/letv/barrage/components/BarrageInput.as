package com.letv.barrage.components
{
   import flash.display.Sprite;
   import com.letv.barrage.components.image.LoadImage;
   import flash.events.Event;
   import flash.ui.Mouse;
   import flash.geom.Rectangle;
   import flash.events.MouseEvent;
   import flash.events.FocusEvent;
   import flash.events.TextEvent;
   import flash.events.KeyboardEvent;
   import com.greensock.TweenLite;
   import com.letv.barrage.state.InputTipState;
   import flash.utils.clearInterval;
   import com.alex.controls.RadioButtonGroup2;
   import flash.text.TextFormat;
   import flash.text.StyleSheet;
   import flash.text.TextFieldType;
   import flash.text.TextFieldAutoSize;
   import flash.utils.setTimeout;
   import flash.utils.clearTimeout;
   import com.alex.utils.RichStringUtil;
   import com.letv.barrage.BarrageEvent;
   import flash.ui.Keyboard;
   import flash.utils.setInterval;
   
   public class BarrageInput extends BaseComponent
   {
      
      private var _px:Number = 0.5;
      
      private var _py:Number = 0.9;
      
      private var CX:Number;
      
      private var CY:Number;
      
      private var notUI:Not;
      
      private var _recycle:Object;
      
      private var _id:String;
      
      private var _main:Sprite;
      
      private var loadImage:LoadImage;
      
      private var inputFastInter:int;
      
      private var opening:Boolean;
      
      private var colors:Array;
      
      private var panelTimer:uint;
      
      private var imageTimer:uint;
      
      private var colorGroup:RadioButtonGroup2;
      
      private var skin:BarrageInputUI;
      
      private const MAX_INPUT:uint = 20;
      
      private const MAX_WRITE:uint = 60;
      
      private const DEFAULT_TEXT:String = "等神马呢，还不来吐槽o(╯□╰)o";
      
      public function BarrageInput(param1:Sprite)
      {
         this.loadImage = LoadImage.getinstance();
         super();
         this._main = param1;
         this.notUI = new Not();
         this._main.addChild(this.notUI);
         this.notUI.visible = false;
         this.CX = this.width * 0.5;
         this.CY = this.height * 0.5;
      }
      
      private function dragHandler(param1:Event) : void
      {
         switch(param1.type)
         {
            case MouseEvent.ROLL_OVER:
               Mouse.cursor = "hand";
               break;
            case MouseEvent.ROLL_OUT:
               Mouse.cursor = "auto";
               break;
            case MouseEvent.MOUSE_DOWN:
               this.startDrag(false,new Rectangle(0,0,applicationWidth - 2 * this.CX,this.applicationHeight - 2 * this.CY));
               if(stage)
               {
                  stage.addEventListener(MouseEvent.MOUSE_UP,this.dragHandler);
               }
               break;
            case MouseEvent.MOUSE_UP:
               if(stage)
               {
                  stage.removeEventListener(MouseEvent.MOUSE_UP,this.dragHandler);
               }
               this.stopDrag();
               this.dragTo(this.x,this.y);
               break;
         }
      }
      
      override public function resize() : void
      {
         this._px = Math.max(0,Math.min(this._px,1));
         this._py = Math.max(0,Math.min(this._py,1));
         this.x = (applicationWidth - 2 * this.CX) * this._px;
         this.y = (applicationHeight - 2 * this.CY) * this._py;
      }
      
      protected function dragTo(param1:Number, param2:Number) : void
      {
         this._px = param1 / (applicationWidth - 2 * this.CX);
         this._py = param2 / (applicationHeight - 2 * this.CY);
      }
      
      override public function get width() : Number
      {
         return this.skin.back.width;
      }
      
      override public function get height() : Number
      {
         return this.skin.back.height;
      }
      
      override public function destroy() : void
      {
         if(stage)
         {
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.dragHandler);
         }
         this.hide();
      }
      
      public function clear() : void
      {
         this.skin.input.text = "";
         this.onInputing();
      }
      
      public function show() : void
      {
         this.colorGroup.addEventListener(Event.CHANGE,this.onColorChange);
         this.skin.setPanel.addEventListener(MouseEvent.ROLL_OVER,this.onSetPanelRollOver);
         this.skin.setPanel.addEventListener(MouseEvent.ROLL_OUT,this.onSetPanelRollOut);
         this.skin.sendImage.addEventListener(MouseEvent.ROLL_OVER,this.onSendImageRollOver);
         this.skin.sendImage.addEventListener(MouseEvent.ROLL_OUT,this.onSendImageRollOut);
         this.skin.sendBtn.addEventListener(MouseEvent.CLICK,this.onSend);
         this.skin.input.addEventListener(FocusEvent.FOCUS_IN,this.onInputFocusIn);
         this.skin.input.addEventListener(FocusEvent.FOCUS_OUT,this.onInputFocusOut);
         this.skin.input.addEventListener(TextEvent.TEXT_INPUT,this.onInputing);
         this.skin.input.addEventListener(Event.CHANGE,this.onInputing);
         this.skin.inputFast.label.addEventListener(TextEvent.LINK,this.onLabelLink);
         this.skin.addEventListener(KeyboardEvent.KEY_DOWN,this.onInputing);
         this.skin.addEventListener(KeyboardEvent.KEY_UP,this.onInputing);
         this.skin.back.addEventListener(MouseEvent.MOUSE_DOWN,this.dragHandler);
         this.skin.back.addEventListener(MouseEvent.ROLL_OVER,this.dragHandler);
         this.skin.back.addEventListener(MouseEvent.ROLL_OUT,this.dragHandler);
         if(!this.opening)
         {
            TweenLite.to(this,0.2,{"alpha":1});
         }
         this.opening = true;
      }
      
      public function hide() : void
      {
         this.colorGroup.removeEventListener(Event.CHANGE,this.onColorChange);
         this.skin.setPanel.removeEventListener(MouseEvent.ROLL_OVER,this.onSetPanelRollOver);
         this.skin.setPanel.removeEventListener(MouseEvent.ROLL_OUT,this.onSetPanelRollOut);
         this.skin.sendBtn.removeEventListener(MouseEvent.CLICK,this.onSend);
         this.skin.input.removeEventListener(FocusEvent.FOCUS_IN,this.onInputFocusIn);
         this.skin.input.removeEventListener(FocusEvent.FOCUS_OUT,this.onInputFocusOut);
         this.skin.input.removeEventListener(TextEvent.TEXT_INPUT,this.onInputing);
         this.skin.input.removeEventListener(Event.CHANGE,this.onInputing);
         this.skin.inputFast.label.removeEventListener(TextEvent.LINK,this.onLabelLink);
         this.skin.removeEventListener(KeyboardEvent.KEY_DOWN,this.onInputing);
         this.skin.removeEventListener(KeyboardEvent.KEY_UP,this.onInputing);
         this.skin.back.removeEventListener(MouseEvent.MOUSE_DOWN,this.dragHandler);
         this.skin.back.removeEventListener(MouseEvent.ROLL_OVER,this.dragHandler);
         this.skin.back.removeEventListener(MouseEvent.ROLL_OUT,this.dragHandler);
         Mouse.cursor = "auto";
         TweenLite.killTweensOf(this);
         if(stage != null)
         {
            if(this.opening)
            {
               TweenLite.to(this,0.2,{
                  "alpha":0,
                  "onComplete":this.onHideComplete
               });
            }
         }
         this.opening = false;
      }
      
      public function set inputTip(param1:String) : void
      {
         switch(param1)
         {
            case InputTipState.INPUT_SET:
               this.skin.inputFast.sendDone.visible = false;
               this.skin.inputFast.label.visible = true;
               this.skin.inputFast.label.htmlText = "<font face=\'Microsoft YaHei,微软雅黑,Arial,宋体\' size=\'12\' color=\'#000000\'>" + "<a href=\'event:inputset\'>点击退出全屏，设置允许全屏输入</a></font>";
               break;
            case InputTipState.INPUT_DONE:
            case InputTipState.INPUT_FAIL:
            case null:
               this.setInputFast(param1);
               return;
            case InputTipState.INPUT_VERSION_ERROR:
               this.skin.inputFast.sendDone.visible = false;
               this.skin.inputFast.label.visible = true;
               this.skin.inputFast.label.htmlText = "<font face=\'Microsoft YaHei,微软雅黑,Arial,宋体\' size=\'12\' color=\'#000000\'>" + "<a href=\'event:outscreen\'>FlashPlayer版本需要11.3才支持全屏输入,点击退出全屏</a></font>";
               break;
            case InputTipState.INPUT_LOADING:
               this.inputLoading();
               break;
            default:
               this.skin.inputFast.sendDone.visible = false;
               this.skin.inputFast.label.visible = true;
               this.skin.inputFast.label.htmlText = param1;
               return;
         }
         clearInterval(this.inputFastInter);
         this.skin.inputFast.visible = true;
         this.skin.sendBtn.mouseEnabled = false;
         this.skin.setPanel.mouseEnabled = false;
         this.skin.setPanel.mouseChildren = false;
         this.skin.sendBtn.alpha = 0.6;
         this.skin.setPanel.alpha = 0.6;
         if(stage != null)
         {
            stage.focus = null;
         }
      }
      
      protected function onHideComplete() : void
      {
         clearparent();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this.skin = new BarrageInputUI();
         addChild(this.skin);
         alpha = 0;
         this.colors = [this.skin.setPanel.panel.color_0xFFFFFF,this.skin.setPanel.panel.color_0xED1C24,this.skin.setPanel.panel.color_0xFF7F27,this.skin.setPanel.panel.color_0xFFF200,this.skin.setPanel.panel.color_0x22B14C,this.skin.setPanel.panel.color_0x00A2E8,this.skin.setPanel.panel.color_0xB97A57,this.skin.setPanel.panel.color_0xFFAEC9,this.skin.setPanel.panel.color_0xFFC90E,this.skin.setPanel.panel.color_0xEFE4B0,this.skin.setPanel.panel.color_0xB5E61D,this.skin.setPanel.panel.color_0x99D9EA];
         this.colorGroup = new RadioButtonGroup2(this.colors);
         this.colorGroup.level = 0;
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.font = "Microsoft YaHei,微软雅黑,Arial,宋体";
         this.skin.inputFast.visible = false;
         var _loc2_:StyleSheet = new StyleSheet();
         var _loc3_:* = "a{text-decoration:underline}a:hover{color:#FF0000;}";
         _loc2_.parseCSS(_loc3_);
         this.skin.inputFast.label.styleSheet = _loc2_;
         this.skin.input.setTextFormat(_loc1_);
         this.skin.input.defaultTextFormat = _loc1_;
         this.skin.input.type = TextFieldType.INPUT;
         this.skin.input.autoSize = TextFieldAutoSize.LEFT;
         this.skin.input.y = this.skin.inputBack.y + (this.skin.inputBack.height - this.skin.input.height) * 0.5;
         this.skin.input.autoSize = TextFieldAutoSize.NONE;
         this.skin.input.width = this.skin.inputBack.width - (this.skin.input.x - this.skin.inputBack.x) * 2;
         this.skin.input.maxChars = this.MAX_WRITE;
         this.skin.input.text = this.DEFAULT_TEXT;
         this.skin.prompt.mouseEnabled = false;
         this.skin.prompt.defaultTextFormat = _loc1_;
         this.skin.prompt.htmlText = "<font face=\'Microsoft YaHei,微软雅黑,Arial,宋体\'>0/20</font>";
         this.skin.prompt.autoSize = TextFieldAutoSize.LEFT;
         this.skin.prompt.y = (this.skin.back.height - this.skin.prompt.height) * 0.5;
         this.skin.sendImage.imagePanel.visible = false;
         this.skin.setPanel.panel.visible = false;
      }
      
      private function onSetPanelRollOver(param1:MouseEvent) : void
      {
         this.panelTimer = setTimeout(this.mouseOverShow,300,"panel");
      }
      
      private function onSetPanelRollOut(param1:MouseEvent) : void
      {
         this.skin.setPanel.panel.visible = false;
         clearTimeout(this.panelTimer);
      }
      
      private function onSendImageRollOver(param1:MouseEvent) : void
      {
         this.skin.sendImage.imagePanel.back.width = this.loadImage.width;
         this.skin.sendImage.imagePanel.back.height = this.loadImage.height;
         this.loadImage.x = -this.loadImage.width * 0.5;
         this.loadImage.y = -this.loadImage.height;
         this.skin.sendImage.imagePanel.addChild(this.loadImage);
         this.loadImage.mcPlay(true);
         this.loadImage.addEventListener(MouseEvent.MOUSE_DOWN,this.imageMouseClick);
         if(this.loadImage.isComplete)
         {
            this.imageTimer = setTimeout(this.mouseOverShow,300,"image");
         }
         else
         {
            this.skin.sendImage.imagePanel.visible = false;
            clearTimeout(this.imageTimer);
         }
      }
      
      private function onSendImageRollOut(param1:MouseEvent) : void
      {
         this.loadImage.mcPlay(false);
         this.skin.sendImage.imagePanel.visible = false;
         clearTimeout(this.imageTimer);
      }
      
      private function mouseOverShow(param1:String) : void
      {
         if(param1 == "panel")
         {
            this.skin.setPanel.panel.visible = true;
         }
         else if(param1 == "image")
         {
            this.skin.sendImage.imagePanel.visible = true;
         }
         
      }
      
      private function onSend(param1:MouseEvent = null) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc2_:String = RichStringUtil.trim(this.skin.input.text);
         if(!(_loc2_ == "") && !(_loc2_ == this.DEFAULT_TEXT) && _loc2_.length <= this.MAX_INPUT)
         {
            _loc3_ = this.colors[this.colorGroup.level].name;
            _loc4_ = _loc3_.split("color_0x")[1];
            dispatchEvent(new BarrageEvent(BarrageEvent.SEND_MSG,{
               "txt":_loc2_,
               "color":_loc4_
            }));
         }
      }
      
      private function imageDrop(param1:MouseEvent) : void
      {
         var _loc3_:* = NaN;
         var _loc2_:Number = this._main.mouseY / applicationHeight;
         if(_loc2_ < 0 || _loc2_ > 1)
         {
            return;
         }
         this.notUI.visible = false;
         if(stage)
         {
            stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.imageDrop);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.dragingHandler);
         }
         if(this._recycle[this._id])
         {
            _loc3_ = this._main.mouseX / applicationWidth;
            this._main.removeChild(this._recycle[this._id]);
            dispatchEvent(new BarrageEvent(BarrageEvent.IMAGE_STATE,{
               "txt":this._id,
               "x":_loc3_,
               "y":_loc2_,
               "sign":"user"
            }));
         }
      }
      
      private function onInputFocusIn(param1:FocusEvent = null) : void
      {
         var event:FocusEvent = param1;
         try
         {
            if(this.skin.input.text == this.DEFAULT_TEXT)
            {
               this.skin.input.text = "";
            }
            this.skin.inputBack.gotoAndStop("in");
            this.onInputing();
         }
         catch(e:Error)
         {
         }
      }
      
      private function imageMouseClick(param1:MouseEvent) : void
      {
         param1.preventDefault();
         param1.stopPropagation();
         this.skin.sendImage.imagePanel.visible = false;
         if(this._recycle)
         {
            if((this._recycle[this._id]) && (this._main.contains(this._recycle[this._id])))
            {
               this._main.removeChild(this._recycle[this._id]);
            }
         }
         else
         {
            this._recycle = new Object();
         }
         this._id = String(param1.target.name);
         if(!this._recycle[this._id])
         {
            this._recycle[this._id] = this.loadImage.getContent(this._id);
            this._recycle[this._id].scaleX = this._recycle[this._id].scaleY = LoadImage.SCALERATE;
         }
         this._recycle[this._id].x = this._main.mouseX;
         this._recycle[this._id].y = this._main.mouseY;
         this._main.addChildAt(this._recycle[this._id],0);
         if(stage)
         {
            stage.addEventListener(MouseEvent.MOUSE_DOWN,this.imageDrop);
            stage.addEventListener(MouseEvent.MOUSE_MOVE,this.dragingHandler);
         }
      }
      
      private function dragingHandler(param1:Event) : void
      {
         var _loc2_:* = NaN;
         if(this._recycle[this._id])
         {
            this._recycle[this._id].x = this._main.mouseX;
            this._recycle[this._id].y = this._main.mouseY;
            _loc2_ = this._main.mouseY / applicationHeight;
            if(_loc2_ < 0 || _loc2_ > 1)
            {
               this.notUI.visible = true;
               this.notUI.x = this._main.mouseX;
               this.notUI.y = this._main.mouseY;
            }
            else
            {
               this.notUI.visible = false;
            }
         }
      }
      
      private function onInputFocusOut(param1:FocusEvent = null) : void
      {
         var event:FocusEvent = param1;
         try
         {
            if(event != null)
            {
               if(this.skin.input.text == this.DEFAULT_TEXT || this.skin.input.text == "")
               {
                  this.skin.input.text = this.DEFAULT_TEXT;
               }
               this.skin.inputBack.gotoAndStop("out");
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function onInputing(param1:Event = null) : void
      {
         if(param1 != null)
         {
            if(param1 is KeyboardEvent)
            {
               param1.stopPropagation();
               param1.stopImmediatePropagation();
               if((param1 as KeyboardEvent).keyCode == Keyboard.ENTER)
               {
                  this.onSend();
                  return;
               }
            }
            else if(param1 is TextEvent)
            {
               if((param1 as TextEvent).text == "\n")
               {
                  param1.preventDefault();
               }
            }
            
         }
         if(this.skin.input.text == this.DEFAULT_TEXT)
         {
            this.skin.prompt.htmlText = "<font face=\'Microsoft YaHei,微软雅黑,Arial,宋体\'>0/20</font>";
            this.skin.inputBack.gotoAndStop("in");
         }
         else if(this.skin.input.text.length <= this.MAX_INPUT)
         {
            this.skin.prompt.htmlText = "<font face=\'Microsoft YaHei,微软雅黑,Arial,宋体\'>" + this.skin.input.text.length + "/" + this.MAX_INPUT + "</font>";
            this.skin.inputBack.gotoAndStop("in");
         }
         else
         {
            this.skin.prompt.htmlText = "<font face=\'Microsoft YaHei,微软雅黑,Arial,宋体\' color=\'#FF0000\'>" + this.skin.input.text.length + "</font>/<font face=\'Microsoft YaHei,微软雅黑,Arial,宋体\'>" + this.MAX_INPUT + "</font>";
            this.skin.inputBack.gotoAndStop("error");
         }
         
      }
      
      private function onColorChange(param1:Event) : void
      {
         this.skin.setPanel.panel.visible = false;
         if(stage != null)
         {
            stage.focus = this.skin.input;
         }
      }
      
      private function onLabelLink(param1:TextEvent) : void
      {
         switch(param1.text)
         {
            case "outscreen":
               stage.displayState = "normal";
               break;
            case "inputset":
               stage.displayState = "normal";
               dispatchEvent(new BarrageEvent(BarrageEvent.INPUT_SET));
               break;
         }
      }
      
      private function inputLoading() : void
      {
         this.skin.inputBack.visible = false;
         this.skin.inputFast.sendDone.visible = false;
         this.skin.inputFast.label.visible = true;
         this.skin.inputFast.label.htmlText = "加载中...";
      }
      
      private function setInputFast(param1:String = null) : void
      {
         clearInterval(this.inputFastInter);
         var _loc2_:Boolean = Boolean(param1);
         this.skin.inputFast.visible = _loc2_;
         if(_loc2_)
         {
            this.skin.inputBack.visible = false;
            this.skin.sendBtn.mouseEnabled = false;
            this.skin.setPanel.mouseEnabled = false;
            this.skin.setPanel.mouseChildren = false;
            this.skin.sendBtn.alpha = 0.6;
            this.skin.setPanel.alpha = 0.6;
            this.onCountInputFast(param1);
         }
         else
         {
            if(stage != null)
            {
               stage.focus = this.skin.input;
            }
            this.skin.inputFast.sendDone.visible = false;
            this.skin.inputFast.label.visible = false;
            this.skin.inputBack.visible = true;
            this.skin.sendBtn.mouseEnabled = true;
            this.skin.setPanel.mouseEnabled = true;
            this.skin.setPanel.mouseChildren = true;
            this.skin.sendBtn.alpha = 1;
            this.skin.setPanel.alpha = 1;
         }
      }
      
      private function onCountInputFast(param1:String) : void
      {
         switch(param1)
         {
            case InputTipState.INPUT_FAIL:
               this.skin.inputFast.sendDone.visible = false;
               this.skin.inputFast.label.visible = true;
               this.skin.inputFast.label.htmlText = "发布太频繁了亲，喝口水吧";
               break;
            case InputTipState.INPUT_DONE:
               this.skin.inputFast.sendDone.visible = true;
               this.skin.inputFast.label.visible = false;
               break;
         }
         this.skin.inputFast.label.autoSize = TextFieldAutoSize.LEFT;
         this.skin.inputFast.label.y = (this.skin.inputFast.back.height - this.skin.inputFast.label.height) * 0.5;
         this.inputFastInter = setInterval(this.setInputFast,1000);
      }
   }
}
