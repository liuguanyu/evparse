package com.worlize.websocket
{
   public final class WebSocketOpcode extends Object
   {
      
      public static const CONTINUATION:int = 0;
      
      public static const TEXT_FRAME:int = 1;
      
      public static const BINARY_FRAME:int = 2;
      
      public static const EXT_DATA:int = 3;
      
      public static const CONNECTION_CLOSE:int = 8;
      
      public static const PING:int = 9;
      
      public static const PONG:int = 10;
      
      public static const EXT_CONTROL:int = 11;
      
      public function WebSocketOpcode()
      {
         super();
      }
   }
}
