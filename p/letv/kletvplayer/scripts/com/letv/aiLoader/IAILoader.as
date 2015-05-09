package com.letv.aiLoader
{
   import flash.events.IEventDispatcher;
   
   public interface IAILoader extends IEventDispatcher
   {
      
      function setup(param1:Array) : void;
      
      function destroy() : void;
      
      function get loadOrderType() : String;
   }
}
