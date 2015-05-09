package com.alex.media.interfaces
{
   import flash.events.IEventDispatcher;
   import flash.net.NetStream;
   
   public interface IVideoDisplay extends IEventDispatcher
   {
      
      function play(... rest) : void;
      
      function seek(param1:Number) : void;
      
      function close() : void;
      
      function pause() : void;
      
      function resume() : void;
      
      function replay() : void;
      
      function set cdnlist(param1:Array) : void;
      
      function set autoplay(param1:Boolean) : void;
      
      function get autoplay() : Boolean;
      
      function set mute(param1:Boolean) : void;
      
      function get mute() : Boolean;
      
      function set volume(param1:Number) : void;
      
      function get volume() : Number;
      
      function get time() : Number;
      
      function get stream() : NetStream;
      
      function get loadPercent() : Number;
      
      function get playPercent() : Number;
      
      function get duration() : Number;
   }
}
