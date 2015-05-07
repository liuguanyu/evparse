package com.letv.player.components.controlBar.classes
{
   import com.letv.player.components.BaseConfigComponent;
   import flash.events.MouseEvent;
   import com.alex.controls.RadioButtonGroup2;
   import flash.events.Event;
   import com.greensock.TweenLite;
   
   public class ScaleUI extends BaseConfigComponent
   {
      
      private var _opening:Boolean;
      
      private var _group:RadioButtonGroup2;
      
      public function ScaleUI(param1:Object)
      {
         super(param1);
      }
      
      override public function get width() : Number
      {
         if(skin.select != null)
         {
            return skin.select.width;
         }
         return super.width;
      }
      
      public function get opening() : Boolean
      {
         return this._opening;
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         _enabled = param1;
         if(param1)
         {
            addEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOver);
         }
         else
         {
            this.onMouseRollOut();
            skin.removeEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOver);
         }
      }
      
      public function setData(param1:Object) : void
      {
         if(param1 != null)
         {
            if(param1.fullScale == true)
            {
               this._group.level = 3;
            }
            else if(param1.resetScale == true)
            {
               this._group.level = 0;
            }
            else if(param1.scale == 4 / 3)
            {
               this._group.level = 1;
            }
            else if(param1.scale == 16 / 9)
            {
               this._group.level = 2;
            }
            else
            {
               this._group.level = 3;
            }
            
            
            
         }
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         if(skin.panel != null)
         {
            this._group = new RadioButtonGroup2([skin.panel.scaleDefault,skin.panel.scale43,skin.panel.scale169,skin.panel.scaleFull]);
            this._group.addEventListener(Event.CHANGE,this.onGroupChange);
         }
         this.onMouseRollOut();
         if(skin.icon != null)
         {
            skin.icon.addEventListener(MouseEvent.CLICK,this.onScreen);
         }
         addAppResize(this.onStageResize);
      }
      
      protected function onStageResize(param1:Object = null) : void
      {
         if(!fullscreen)
         {
            if(skin.icon.currentFrame != 1)
            {
               skin.icon.gotoAndStop(1);
               this.onMouseRollOut();
            }
         }
         else if(skin.icon.currentFrame != 2)
         {
            skin.icon.gotoAndStop(2);
            this.onMouseRollOut();
         }
         
      }
      
      private function onScreen(param1:MouseEvent) : void
      {
         if(skin.icon.currentFrame == 1)
         {
            systemManager.setFullScreen(true,sdk.getFullscreenInput());
         }
         else
         {
            systemManager.setFullScreen(false);
         }
      }
      
      private function onMouseRollOver(param1:MouseEvent = null) : void
      {
         if(skin.panel != null)
         {
            this.setOpen(true,!(param1 == null));
         }
         if(skin.select != null)
         {
            skin.select.visible = true;
         }
         if(skin.visualBack != null)
         {
            skin.visualBack.visible = true;
         }
         var _loc2_:Object = sdk.getPlayset();
         _loc2_.scale = sdk.getVideoScale();
         this.setData(_loc2_);
         skin.removeEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOver);
         if(_enabled)
         {
            skin.addEventListener(MouseEvent.ROLL_OUT,this.onMouseRollOut);
         }
      }
      
      private function onMouseRollOut(param1:MouseEvent = null) : void
      {
         if(skin.panel != null)
         {
            this.setOpen(false,!(param1 == null));
         }
         if(skin.select != null)
         {
            skin.select.visible = false;
         }
         if(skin.visualBack != null)
         {
            skin.visualBack.visible = false;
         }
         skin.removeEventListener(MouseEvent.ROLL_OUT,this.onMouseRollOut);
         if(_enabled)
         {
            skin.addEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOver);
         }
      }
      
      private function onGroupChange(param1:Event) : void
      {
         switch(this._group.level)
         {
            case 0:
               sdk.resetVideoScale();
               break;
            case 1:
               sdk.setVideoScale(4 / 3);
               break;
            case 2:
               sdk.setVideoScale(16 / 9);
               break;
            case 3:
               sdk.fullVideoScale();
               break;
         }
      }
      
      private function setOpen(param1:Boolean, param2:Boolean = true) : void
      {
         this._opening = param1;
         if(param1)
         {
            skin.panel.visible = true;
            if(param2)
            {
               skin.panel.alpha = 0;
               TweenLite.to(skin.panel,0.2,{"alpha":1});
            }
         }
         else if(param2)
         {
            TweenLite.to(skin.panel,0.2,{
               "alpha":0,
               "onComplete":this.onHideComplete
            });
         }
         else
         {
            this.onHideComplete();
         }
         
      }
      
      private function onHideComplete() : void
      {
         if(skin.panel != null)
         {
            skin.panel.visible = false;
         }
      }
   }
}
