package com.worlize.websocket
{
   public final class WebSocketState extends Object
   {
      
      public static const CONNECTING:int = 0;
      
      public static const OPEN:int = 1;
      
      public static const CLOSED:int = 2;
      
      public static const INIT:int = 3;
      
      public function WebSocketState()
      {
         super();
      }
   }
}
