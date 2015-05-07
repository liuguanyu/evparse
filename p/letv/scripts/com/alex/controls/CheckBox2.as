package com.alex.controls
{
   import com.alex.core.UIComponent;
   import com.alex.surface.ISurface;
   import com.alex.error.SkinError;
   import flash.events.MouseEvent;
   import flash.events.Event;
   import flash.display.MovieClip;
   import com.alex.surface.pc.ContainerSurface;
   
   public class CheckBox2 extends UIComponent
   {
      
      protected var _selected:Boolean;
      
      public function CheckBox2(param1:MovieClip = null)
      {
         super(new ContainerSurface(param1));
      }
      
      override public function destroy() : void
      {
         this.removeListener();
         super.destroy();
      }
      
      override public function set surface(param1:ISurface) : void
      {
         if(surface != null)
         {
            throw new SkinError("该组件不支持动态修改皮肤",SkinError.SKIN_SET_ERROR);
         }
         else
         {
            super.surface = param1;
            this.renderer();
            return;
         }
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._selected = param1;
         if(param1)
         {
            this.inCheckedState();
         }
         else
         {
            this.inUncheckedState();
         }
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      override protected function renderer() : void
      {
         super.renderer();
         buttonMode = true;
         this.selected = this._selected;
         this.addListener();
      }
      
      protected function inCheckedState() : void
      {
         if(skin.totalFrames > 1)
         {
            skin.gotoAndStop(2);
         }
      }
      
      protected function inUncheckedState() : void
      {
         if(skin.totalFrames > 1)
         {
            skin.gotoAndStop(1);
         }
      }
      
      private function addListener() : void
      {
         addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function removeListener() : void
      {
         removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      protected function onClick(param1:MouseEvent) : void
      {
         this.selected = !this.selected;
         dispatchEvent(new Event(Event.CHANGE));
      }
   }
}
