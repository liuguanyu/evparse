package org.puremvc.as3.multicore.utilities.fabrication.events
{
   import flash.events.Event;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterMessage;
   
   public class RouterFirewallEvent extends Event implements IDisposable
   {
      
      public static const ALLOWED_MESSAGE:String = "allowedMessage";
      
      public static const BLOCKED_MESSAGE:String = "blockedMessage";
      
      public var message:IRouterMessage;
      
      public function RouterFirewallEvent(param1:String, param2:IRouterMessage)
      {
         super(param1,false,false);
         this.message = param2;
      }
      
      public function dispose() : void
      {
         this.message = null;
      }
   }
}
