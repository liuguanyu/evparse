package com.letv.barrage
{
   import flash.events.Event;
   
   public class BarrageEvent extends Event
   {
      
      public static const SEND_MSG:String = "sendMsg";
      
      public static const INPUT_SET:String = "inputSet";
      
      public static const SEND_XML:String = "sendXml";
      
      public static const IMAGE_STATE:String = "imageState";
      
      public static const IMAGE_MOUSE_UP:String = "imageMouseUp";
      
      public static const IMAGE_LOAD_FAIL:String = "imageLoadFail";
      
      public var dataProvider:Object;
      
      public function BarrageEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.dataProvider = param2;
      }
   }
}
