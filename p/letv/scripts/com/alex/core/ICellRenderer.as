package com.alex.core
{
   public interface ICellRenderer extends IUIComponent
   {
      
      function setSize(param1:Number, param2:Number) : void;
      
      function set selected(param1:Boolean) : void;
      
      function get selected() : Boolean;
   }
}
