package com.alex.surface.pc
{
   import com.alex.surface.BaseSurface;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class DragBarSurface extends BaseSurface
   {
      
      private static const SKIN_CONFIG:Class = DragBarSurface_SKIN_CONFIG;
      
      public var slider:Sprite;
      
      public var sliderOver:Sprite;
      
      public var maskTrack:Sprite;
      
      public var track:Sprite;
      
      public var label:TextField;
      
      public function DragBarSurface(param1:MovieClip = null)
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
         this.slider = skin[getStyleName("slider")];
         this.sliderOver = skin[getStyleName("sliderOver")];
         this.maskTrack = skin[getStyleName("maskTrack")];
         this.track = skin[getStyleName("track")];
         this.label = skin[getStyleName("label")];
         if(this.label == null)
         {
            this.label = skin[getStyleName("txt")];
         }
      }
   }
}
