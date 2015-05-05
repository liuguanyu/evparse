package com.worlize.websocket
{
   import flash.events.ErrorEvent;
   
   public class WebSocketErrorEvent extends ErrorEvent
   {
      
      public static const CONNECTION_FAIL:String = "connectionFail";
      
      public static const ABNORMAL_CLOSE:String = "abnormalClose";
      
      public function WebSocketErrorEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:String = "")
      {
         super(param1,param2,param3,param4);
      }
   }
}
