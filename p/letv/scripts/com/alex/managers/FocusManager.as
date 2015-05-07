package com.alex.managers
{
   import flash.display.Stage;
   import com.alex.core.IUIComponent;
   
   public final class FocusManager extends Object implements IFocusManager
   {
      
      protected var _stage:Stage;
      
      public function FocusManager()
      {
         super();
      }
      
      public function setStage(param1:Stage) : void
      {
         this._stage = param1;
      }
      
      public function setFocus(param1:IUIComponent) : void
      {
         if(this._stage != null)
         {
            this._stage.focus = param1.skin;
         }
      }
   }
}
