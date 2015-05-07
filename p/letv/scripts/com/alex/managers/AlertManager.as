package com.alex.managers
{
   import com.alex.core.Container;
   import com.alex.surface.ISurface;
   import com.alex.surface.pc.AlertSurface;
   import flash.events.MouseEvent;
   import com.alex.controls.Label;
   import flash.display.MovieClip;
   import com.alex.states.Screen;
   
   public final class AlertManager extends Container implements IAlertManager
   {
      
      private var _value:String;
      
      private var _okFunction:Function;
      
      private var _cancelFunction:Function;
      
      protected var _label:Label;
      
      protected var s:AlertSurface;
      
      public function AlertManager()
      {
         super(new AlertSurface(new Framework_Default_Skin_Alert()));
      }
      
      override public function set surface(param1:ISurface) : void
      {
         clearparent();
         super.surface = param1;
         this.s = surface as AlertSurface;
         this.renderer();
      }
      
      public function show(param1:String, param2:Function = null, param3:Function = null) : void
      {
         var _loc4_:uint = 10;
         visible = true;
         this._value = param1;
         this._okFunction = param2;
         this._cancelFunction = param3;
         this._label.text = param1;
         this._label.width = this.s.canvas.width - _loc4_ * 2;
         this.s.ok.addEventListener(MouseEvent.CLICK,this.onOK);
         if(param3 != null)
         {
            this.s.cancel.addEventListener(MouseEvent.CLICK,this.onCancel);
            this.s.cancel.visible = true;
            this.s.ok.x = int((applicationWidth - (this.s.ok.width + _loc4_ * 2 + this.s.cancel.width)) * 0.5);
            this.s.cancel.x = int(this.s.ok.x + this.s.ok.width + _loc4_ * 2);
         }
         else
         {
            this.s.cancel.removeEventListener(MouseEvent.CLICK,this.onCancel);
            this.s.cancel.visible = false;
            this.s.ok.x = int((applicationWidth - this.s.ok.width) * 0.5);
         }
         this.s.background.width = applicationWidth;
         this.s.background.height = applicationHeight;
         this.s.canvas.height = _loc4_ + this._label.height + _loc4_ + this.s.ok.height + _loc4_;
         this.s.canvas.x = (applicationWidth - this.s.canvas.width) * 0.5;
         this.s.canvas.y = (applicationHeight - this.s.canvas.height) * 0.5;
         this._label.x = this.s.canvas.x + (this.s.canvas.width - this._label.width) * 0.5;
         this._label.y = this.s.canvas.y + _loc4_;
         this.s.ok.y = int(this.s.canvas.y + this.s.canvas.height - 10 - this.s.ok.height);
         this.s.cancel.y = int(this.s.canvas.y + this.s.canvas.height - 10 - this.s.cancel.height);
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         mouseEnabled = false;
         addAppResize(this.onResize);
      }
      
      override protected function renderer() : void
      {
         super.renderer();
         this._label = new Label(this.s.label as MovieClip);
         this._label.mouseEnabled = false;
         this._label.mouseChildren = false;
         this._label.wordWrap = true;
         this.onResize();
      }
      
      private function onResize(param1:Screen = null) : void
      {
         if((visible) && !(this._value == null))
         {
            this.show(this._value,this._okFunction,this._cancelFunction);
         }
         else
         {
            visible = false;
         }
      }
      
      private function onOK(param1:MouseEvent) : void
      {
         visible = false;
         if(this._okFunction != null)
         {
            this._okFunction();
         }
         this._value = null;
         this._okFunction = null;
         this._cancelFunction = null;
      }
      
      private function onCancel(param1:MouseEvent) : void
      {
         visible = false;
         this._cancelFunction();
         this._value = null;
         this._okFunction = null;
         this._cancelFunction = null;
      }
   }
}
