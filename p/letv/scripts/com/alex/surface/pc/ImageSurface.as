package com.alex.surface.pc
{
   import com.alex.surface.BaseSurface;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class ImageSurface extends BaseSurface
   {
      
      private static const SKIN_CONFIG:Class = ImageSurface_SKIN_CONFIG;
      
      public var masker:Sprite;
      
      public var container:Sprite;
      
      public var background:Sprite;
      
      public function ImageSurface(param1:MovieClip)
      {
         super(param1);
      }
      
      override public function getSkinConfig() : XML
      {
         return XML(new SKIN_CONFIG());
      }
      
      override public function setSkin(param1:MovieClip) : void
      {
         super.setSkin(param1);
         this.masker = skin[getStyleName("masker")];
         this.container = skin[getStyleName("container")];
         this.background = skin[getStyleName("background")];
      }
   }
}
