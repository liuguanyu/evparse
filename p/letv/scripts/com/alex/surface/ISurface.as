package com.alex.surface
{
   import flash.display.MovieClip;
   
   public interface ISurface
   {
      
      function setSkin(param1:MovieClip) : void;
      
      function getSkinConfig() : XML;
      
      function getStyleName(param1:String) : String;
      
      function get skin() : MovieClip;
   }
}
