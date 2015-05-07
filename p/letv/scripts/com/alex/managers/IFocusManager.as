package com.alex.managers
{
   import flash.display.Stage;
   import com.alex.core.IUIComponent;
   
   public interface IFocusManager
   {
      
      function setStage(param1:Stage) : void;
      
      function setFocus(param1:IUIComponent) : void;
   }
}
