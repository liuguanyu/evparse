package com.hls_p2p.events
{
   import flash.events.EventDispatcher;
   
   public class EventWithData extends EventDispatcher
   {
      
      private static var var_267:EventWithData = null;
      
      {
         var_267 = null;
      }
      
      public function EventWithData(param1:Singleton)
      {
         super();
      }
      
      public static function method_261() : EventWithData
      {
         if(var_267 == null)
         {
            var_267 = new EventWithData(new Singleton());
         }
         return var_267;
      }
      
      public function method_77(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false) : void
      {
         dispatchEvent(new EventExtensions(param1,param2,param3,param4));
      }
   }
}

class Singleton extends Object
{
   
   function Singleton()
   {
      super();
   }
}
