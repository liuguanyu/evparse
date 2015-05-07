package com.alex.surface.pc
{
   import com.alex.surface.BaseSurface;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class LabelSurface extends BaseSurface
   {
      
      private static const SKIN_CONFIG:Class = LabelSurface_SKIN_CONFIG;
      
      public var label:TextField;
      
      public function LabelSurface(param1:MovieClip = null)
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
      }
   }
}
