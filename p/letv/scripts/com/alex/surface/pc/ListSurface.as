package com.alex.surface.pc
{
   import com.alex.surface.BaseSurface;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class ListSurface extends BaseSurface
   {
      
      private static const SKIN_CONFIG:Class = ListSurface_SKIN_CONFIG;
      
      public var masker:Sprite;
      
      public var container:Sprite;
      
      public var dragBar:Sprite;
      
      public function ListSurface(param1:MovieClip = null)
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
         this.dragBar = skin[getStyleName("dragbar")];
      }
   }
}
