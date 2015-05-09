package com.letv.pluginsAPI.log
{
   import flash.events.Event;
   
   public class LogEvent extends Event
   {
      
      public static const LOG_4J:String = "log4j";
      
      public var value:String = "";
      
      public var level:String = "info";
      
      public function LogEvent(param1:String, param2:String = "", param3:String = "info", param4:Boolean = false, param5:Boolean = false)
      {
         super(param1,param4,param5);
         this.value = param2;
         this.level = param3;
      }
   }
}
