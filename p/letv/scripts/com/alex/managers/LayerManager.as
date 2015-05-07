package com.alex.managers
{
   import com.alex.core.Container;
   import com.alex.surface.pc.ContainerSurface;
   import flash.display.MovieClip;
   
   public final class LayerManager extends Container
   {
      
      public function LayerManager()
      {
         super(new ContainerSurface(new MovieClip()));
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         mouseEnabled = false;
      }
   }
}
