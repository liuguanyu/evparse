package com.alex.surface.pc
{
   import com.alex.surface.BaseSurface;
   import flash.display.MovieClip;
   import com.alex.error.SkinError;
   
   public class ContainerSurface extends BaseSurface
   {
      
      public function ContainerSurface(param1:MovieClip)
      {
         super(param1);
         if(param1 == null)
         {
            throw new SkinError(this + "皮肤校验抽取错误.",SkinError.SKIN_EXTRACT_ERROR);
         }
         else
         {
            return;
         }
      }
   }
}
