package com.letv.plugins.kernel.interfaces
{
   import flash.events.IEventDispatcher;
   
   public interface IAuth extends IEventDispatcher, IDestroy
   {
      
      function checkVip() : void;
      
      function start(param1:Object = null) : void;
   }
}
