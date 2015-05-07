package com.letv.pluginsAPI.recommend
{
   import flash.events.Event;
   
   public class RecommendEvent extends Event
   {
      
      public static const RECOMMEND_REPLAY:String = "recommendReplay";
      
      public static const RECOMMEND_SHARE:String = "recommendShare";
      
      public static const RECOMMEND_COMMENT:String = "recommendComment";
      
      public static const RECOMMEND_ZHUIJU:String = "recommendZhuiju";
      
      public static const RECOMMEND_LOCK_TRACK:String = "recommendLockTrack";
      
      public static const RECOMMEND_STATISTICS:String = "recommendStatistics";
      
      public var dataProvider:Object;
      
      public function RecommendEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,cancelable);
      }
   }
}
