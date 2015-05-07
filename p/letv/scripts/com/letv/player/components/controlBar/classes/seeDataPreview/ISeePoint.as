package com.letv.player.components.controlBar.classes.seeDataPreview
{
   import flash.events.IEventDispatcher;
   
   public interface ISeePoint extends IEventDispatcher
   {
      
      function destroy() : void;
      
      function get type() : int;
      
      function get content() : String;
      
      function get time() : Number;
   }
}
