package com.letv.plugins.kernel.media
{
   import flash.events.Event;
   
   public class MediaEvent extends Event
   {
      
      public static const META_DATA:String = "getMetaData";
      
      public static const PLAY_START:String = "playStart";
      
      public static const BUFFER_FULL:String = "bufferFull";
      
      public static const BUFFER_EMPTY:String = "bufferEmpty";
      
      public static const FILE_ERROR:String = "fileError";
      
      public static const LOAD_COMPLETE:String = "loadComplete";
      
      public static const PLAY_STOP:String = "playStop";
      
      public static const GET_DATA:String = "getData";
      
      public static const MODE_CHANGE:String = "modeChange";
      
      public var dataProvider:Object;
      
      public var errorCode:String;
      
      public var testSpeed:Boolean;
      
      public function MediaEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.dataProvider = param2;
      }
   }
}
