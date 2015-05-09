package com.alex.rpc.interfaces
{
   import flash.events.IEventDispatcher;
   
   public interface ILoader extends IEventDispatcher
   {
      
      function destroy() : void;
      
      function start(param1:Array) : void;
   }
}
