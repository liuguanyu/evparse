package com.letv.pluginsAPI.interfaces
{
   import flash.events.IEventDispatcher;
   import flash.display.DisplayObject;
   
   public interface IRecommend extends IEventDispatcher
   {
      
      function get surface() : DisplayObject;
      
      function setVolume(param1:Number) : void;
      
      function stopvideo() : void;
      
      function startvideo(param1:Object) : void;
      
      function setRect(param1:Object = null, param2:Object = null) : void;
   }
}
