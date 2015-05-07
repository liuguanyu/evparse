package com.alex.managers
{
   import flash.ui.Mouse;
   
   public final class CursorManager extends Object implements ICursorManager
   {
      
      public function CursorManager()
      {
         super();
      }
      
      public function show() : void
      {
         Mouse.show();
      }
      
      public function hide() : void
      {
         Mouse.hide();
      }
   }
}
