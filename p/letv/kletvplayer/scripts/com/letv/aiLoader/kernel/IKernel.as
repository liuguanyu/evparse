package com.letv.aiLoader.kernel
{
   import flash.events.IEventDispatcher;
   
   public interface IKernel extends IEventDispatcher
   {
      
      function destroy() : void;
      
      function start(param1:Array) : void;
   }
}
