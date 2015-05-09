package com.alex.rpc.events
{
   import flash.events.Event;
   
   public class AutoLoaderEvent extends Event
   {
      
      public static const LOAD_ERROR:String = "loadError";
      
      public static const LOAD_STATE_CHANGE:String = "loadStateChange";
      
      public static const LOAD_PROGRESS:String = "loadProgress";
      
      public static const LOAD_COMPLETE:String = "loadComplete";
      
      public static const WHOLE_COMPLETE:String = "wholeComplete";
      
      public var dataProvider:Object;
      
      public var errorCode:int = -1;
      
      public var index:int;
      
      public var total:int;
      
      public var sourceType:String;
      
      public var infoCode:String;
      
      public var retry:int;
      
      public function AutoLoaderEvent(param1:String, param2:String = null, param3:int = 0, param4:int = 0, param5:Boolean = false, param6:Boolean = false)
      {
         super(param1,param5,param6);
         if(param2 != null)
         {
            this.sourceType = param2;
         }
         this.index = param3;
         this.retry = param4;
      }
      
      override public function toString() : String
      {
         return "[AutoLoaderEvent type=" + type + " sourceType=" + this.sourceType + " index=" + this.index + "]";
      }
   }
}
