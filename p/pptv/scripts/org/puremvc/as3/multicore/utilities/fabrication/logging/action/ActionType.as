package org.puremvc.as3.multicore.utilities.fabrication.logging.action
{
   public class ActionType extends Object
   {
      
      public static const COMMAND_REGISTERED:String = "Command registered";
      
      public static const INTERCEPTOR_REGISTERED:String = "Interceptor registered";
      
      public static const PROXY_REGISTERD:String = "Proxy registered";
      
      public static const MEDIATOR_REGISTERED:String = "Mediator registered";
      
      public static const NOTIFICATION_SENT:String = "Notification sent";
      
      public static const NOTIFICATION_ROUTE:String = "Notification routed";
      
      public static const FABRICATION_START:String = "Fabrication start";
      
      public static const SERVICE_CALL:String = "Service call";
      
      public function ActionType()
      {
         super();
      }
   }
}
