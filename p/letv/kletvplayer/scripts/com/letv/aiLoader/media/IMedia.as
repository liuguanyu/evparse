package com.letv.aiLoader.media
{
   import flash.events.IEventDispatcher;
   import flash.system.ApplicationDomain;
   import flash.geom.Rectangle;
   
   public interface IMedia extends IEventDispatcher
   {
      
      function destroy() : void;
      
      function start(param1:String = null) : void;
      
      function get domain() : ApplicationDomain;
      
      function get index() : int;
      
      function get rect() : Rectangle;
      
      function get url() : String;
      
      function get size() : int;
      
      function get speed() : int;
      
      function get utime() : int;
      
      function get resourceType() : String;
      
      function get content() : Object;
      
      function get hadError() : Boolean;
      
      function mute(param1:Number = 1) : void;
      
      function pause() : Boolean;
      
      function resume() : Boolean;
      
      function set visible(param1:Boolean) : void;
   }
}
