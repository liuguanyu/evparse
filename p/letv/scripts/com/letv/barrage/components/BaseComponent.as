package com.letv.barrage.components
{
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   
   public class BaseComponent extends Sprite
   {
      
      public static var rect:Rectangle = new Rectangle(0,0,400,400);
      
      public function BaseComponent()
      {
         super();
         this.initialize();
      }
      
      public function destroy() : void
      {
      }
      
      public function resize() : void
      {
      }
      
      protected function get applicationWidth() : uint
      {
         return rect.width;
      }
      
      protected function get applicationHeight() : uint
      {
         return rect.height;
      }
      
      protected function initialize() : void
      {
      }
      
      protected function clearparent() : void
      {
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }
   }
}
