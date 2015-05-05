package org.puremvc.as3.multicore.utilities.fabrication.interfaces
{
   import org.puremvc.as3.multicore.interfaces.INotifier;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.interceptor.NotificationProcessor;
   
   public interface IInterceptor extends INotifier, IDisposable
   {
      
      function get notification() : INotification;
      
      function set notification(param1:INotification) : void;
      
      function get processor() : NotificationProcessor;
      
      function set processor(param1:NotificationProcessor) : void;
      
      function get parameters() : Object;
      
      function set parameters(param1:Object) : void;
      
      function intercept() : void;
      
      function proceed(param1:INotification = null) : void;
      
      function abort() : void;
      
      function skip() : void;
   }
}
