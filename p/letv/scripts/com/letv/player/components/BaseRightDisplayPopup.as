package com.letv.player.components
{
   import com.greensock.TweenLite;
   import flash.events.Event;
   import com.letv.player.notify.AssistNotify;
   import flash.events.MouseEvent;
   import flash.display.Sprite;
   
   public class BaseRightDisplayPopup extends BaseAutoScalePopup
   {
      
      protected var _clkLayer:Sprite;
      
      private var _isShowParent:Boolean;
      
      private var _parentName:String;
      
      public function BaseRightDisplayPopup(param1:Object = null, param2:String = "")
      {
         super(param1);
         this._parentName = param2;
      }
      
      override public function resize(param1:Boolean = false) : void
      {
         if(stage != null)
         {
            TweenLite.killTweensOf(this);
            if(applicationWidth < 500 || applicationHeight < 400)
            {
               this.onHideComplete();
               return;
            }
            if(!opening)
            {
               this.onHideComplete();
               return;
            }
            if(skin.back != null)
            {
               skin.back.height = applicationHeight;
            }
            if(skin.closeBtn != null)
            {
               skin.closeBtn.y = (applicationHeight - skin.closeBtn.height) / 2;
            }
            if(param1)
            {
               TweenLite.to(this,actionDuration,{
                  "x":applicationWidth - originalWidth,
                  "onComplete":this.onShowComplete
               });
            }
            else
            {
               this.x = applicationWidth - originalWidth;
            }
            this.renderClkLayer();
         }
      }
      
      override public function show(param1:Object = null) : void
      {
         if(!_opening && !(stage == null))
         {
            this.x = applicationWidth;
            super.show();
            this.addListener();
            this.addClkLayer();
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      override public function hide(param1:Object = true) : void
      {
         if(_opening)
         {
            _opening = false;
            this.removeListener();
            TweenLite.to(this,actionDuration,{
               "x":applicationWidth,
               "onComplete":this.onHideComplete
            });
         }
      }
      
      protected function onShowComplete() : void
      {
      }
      
      protected function onHideComplete() : void
      {
         if(visible)
         {
            try
            {
               removeChild(this.clkLayer);
            }
            catch(e:Error)
            {
            }
            visible = false;
            _opening = false;
            this.removeListener();
         }
         dispatchEvent(new Event(Event.CHANGE));
         if((this._isShowParent) && !(this._parentName == ""))
         {
            sendNotification(AssistNotify.DISPLAY_POPUP,this._parentName);
         }
      }
      
      protected function addListener() : void
      {
         if(skin.closeBtn != null)
         {
            skin.closeBtn.addEventListener(MouseEvent.CLICK,this.onClose);
         }
         if(skin.goback != null)
         {
            skin.goback.addEventListener(MouseEvent.CLICK,this.onGoBack);
         }
      }
      
      protected function removeListener() : void
      {
         if(skin.closeBtn != null)
         {
            skin.closeBtn.removeEventListener(MouseEvent.CLICK,this.onClose);
         }
         if(skin.goback != null)
         {
            skin.goback.removeEventListener(MouseEvent.CLICK,this.onGoBack);
         }
      }
      
      protected function onGoBack(param1:MouseEvent) : void
      {
         this._isShowParent = true;
         this.hide();
      }
      
      protected function onClose(param1:MouseEvent = null) : void
      {
         this._isShowParent = false;
         this.hide();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         visible = false;
         this.y = 0;
      }
      
      protected function get clkLayer() : Sprite
      {
         if(this._clkLayer == null)
         {
            this._clkLayer = new Sprite();
            this._clkLayer.graphics.beginFill(16777215,0);
            this._clkLayer.graphics.drawRect(0,0,skin.stage.stageWidth,skin.stage.stageHeight);
            this._clkLayer.graphics.endFill();
         }
         return this._clkLayer;
      }
      
      protected function renderClkLayer() : void
      {
         if(!(this.clkLayer == null) && !(this.clkLayer.parent == null))
         {
            this.clkLayer.width = applicationWidth;
            this.clkLayer.height = applicationHeight;
            this.clkLayer.x = originalWidth - this.clkLayer.width;
         }
      }
      
      protected function addClkLayer() : void
      {
         addChildAt(this.clkLayer,0);
         this.renderClkLayer();
         this.clkLayer.addEventListener(MouseEvent.CLICK,this.onClkEvent);
      }
      
      private function onClkEvent(param1:MouseEvent) : void
      {
         this.onClose();
      }
   }
}
