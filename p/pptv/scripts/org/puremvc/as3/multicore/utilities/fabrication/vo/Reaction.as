package org.puremvc.as3.multicore.utilities.fabrication.vo
{
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
   import flash.events.IEventDispatcher;
   import flash.events.Event;
   
   public class Reaction extends Object implements IDisposable
   {
      
      public var source:IEventDispatcher;
      
      public var eventType:String;
      
      public var handler:Function;
      
      public var capture:Boolean = false;
      
      public function Reaction(param1:IEventDispatcher, param2:String, param3:Function, param4:Boolean = false)
      {
         super();
         this.source = param1;
         this.eventType = param2;
         this.handler = param3;
         this.capture = param4;
      }
      
      public function dispose() : void
      {
         this.stop();
         this.source = null;
         this.handler = null;
         this.eventType = null;
      }
      
      public function start() : void
      {
         this.source.addEventListener(this.eventType,this.fulfil,this.capture);
      }
      
      public function stop() : void
      {
         this.source.removeEventListener(this.eventType,this.fulfil,this.capture);
      }
      
      public function fulfil(param1:Event) : void
      {
         this.handler(param1);
      }
   }
}
