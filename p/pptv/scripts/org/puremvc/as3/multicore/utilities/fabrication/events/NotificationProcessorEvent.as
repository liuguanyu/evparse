package org.puremvc.as3.multicore.utilities.fabrication.events
{
   import flash.events.Event;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class NotificationProcessorEvent extends Event implements IDisposable
   {
      
      public static const PROCEED:String = "proceed";
      
      public static const ABORT:String = "abort";
      
      public static const FINISH:String = "skip";
      
      public var notification:INotification;
      
      public function NotificationProcessorEvent(param1:String, param2:INotification = null)
      {
         super(param1);
         this.notification = param2;
      }
      
      public function dispose() : void
      {
         this.notification = null;
      }
   }
}
