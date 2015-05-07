package com.alex.surface.pc
{
   import com.alex.surface.BaseSurface;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class ToolTipSurface extends BaseSurface
   {
      
      private static const SKIN_CONFIG:Class = ToolTipSurface_SKIN_CONFIG;
      
      public var label:Sprite;
      
      public var background:Sprite;
      
      public function ToolTipSurface(param1:MovieClip = null)
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
         this.label = skin[getStyleName("label")];
         this.background = skin[getStyleName("background")];
      }
   }
}
