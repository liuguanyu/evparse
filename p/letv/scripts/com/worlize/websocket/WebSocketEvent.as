package com.worlize.websocket
{
   import flash.events.Event;
   
   public class WebSocketEvent extends Event
   {
      
      public static const OPEN:String = "open";
      
      public static const CLOSED:String = "closed";
      
      public static const MESSAGE:String = "message";
      
      public static const FRAME:String = "frame";
      
      public static const PING:String = "ping";
      
      public static const PONG:String = "pong";
      
      public var message:WebSocketMessage;
      
      public var frame:WebSocketFrame;
      
      public var dataProvider:Object;
      
      public function WebSocketEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
