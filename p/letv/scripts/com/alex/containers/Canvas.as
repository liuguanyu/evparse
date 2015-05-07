package com.alex.containers
{
   import com.alex.core.Container;
   import flash.display.MovieClip;
   import com.alex.surface.pc.ContainerSurface;
   
   public class Canvas extends Container
   {
      
      public function Canvas(param1:MovieClip = null, param2:Object = null)
      {
         if(param1 == null)
         {
            var param1:MovieClip = new MovieClip();
         }
         super(new ContainerSurface(param1),param2);
      }
   }
}
