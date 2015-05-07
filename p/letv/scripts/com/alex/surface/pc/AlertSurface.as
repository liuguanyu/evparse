package com.alex.surface.pc
{
   import com.alex.surface.BaseSurface;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.display.InteractiveObject;
   
   public class AlertSurface extends BaseSurface
   {
      
      private static const SKIN_CONFIG:Class = AlertSurface_SKIN_CONFIG;
      
      public var label:Sprite;
      
      public var ok:InteractiveObject;
      
      public var cancel:InteractiveObject;
      
      public var canvas:Sprite;
      
      public var background:Sprite;
      
      public function AlertSurface(param1:MovieClip = null)
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
         this.ok = skin[getStyleName("ok")];
         this.cancel = skin[getStyleName("cancel")];
         this.canvas = skin[getStyleName("canvas")];
         this.background = skin[getStyleName("background")];
      }
   }
}
