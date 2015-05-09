package com.alex.media.events
{
   import flash.events.Event;
   
   public class HTTPNetStreamingEvent extends Event
   {
      
      public static const LOG:String = "log";
      
      public static const STATUS:String = "httpNetStreamingStatus";
      
      public static const ALLOW_SMOOTH:String = "allowsmooth";
      
      public static const SWAP_COMPLETE:String = "swapcomplete";
      
      public static const M3U8_ERROR:String = "m3u8error";
      
      public var status:String;
      
      public var errorCode:int = 0;
      
      public var dataProvider:Object;
      
      public function HTTPNetStreamingEvent(param1:String, param2:String, param3:int = 0, param4:Object = null, param5:Boolean = false, param6:Boolean = false)
      {
         super(param1,param5,param6);
         this.status = param2;
         this.errorCode = param3;
         this.dataProvider = param4;
      }
   }
}
