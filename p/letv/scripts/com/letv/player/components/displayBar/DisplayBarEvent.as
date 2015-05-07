package com.letv.player.components.displayBar
{
   import flash.events.Event;
   
   public class DisplayBarEvent extends Event
   {
      
      public static const SCREENSHOT_RESUME_VIDEO:String = "screenshotResumeVideo";
      
      public static const SCREENSHOT_PAUSE_VIDEO:String = "screenshotPauseVideo";
      
      public static const DOCK_SHARE:String = "dockShare";
      
      public static const DOCK_CAMERA_SHARE:String = "dockCameraShare";
      
      public static const DOCK_VIDEO_LIST:String = "dockVideoList";
      
      public static const DOCK_MORE:String = "dockMore";
      
      public static const DOCK_GREEN:String = "dockGreen";
      
      public static const VIP_AD_CLOSE:String = "vipAdClose";
      
      public static const GET_VIDEO_LIST:String = "getVideoList";
      
      public static const CHANGE_PAGE:String = "changePage";
      
      public static const CHANGE_PLAY:String = "changePlay";
      
      public static const CHANGE_FUNCTION:String = "changeFunction";
      
      public static const ADD_COMMENT:String = "addComment";
      
      public static const OVER_COMMENT:String = "overComment";
      
      public static const OPEN_BARRAGE:String = "openBarrage";
      
      public static const CLOSE_BARRAGE:String = "closeBarrage";
      
      public static const LOOP_PLAY_VIDEO:String = "loopPlayVideo";
      
      public var dataProvider:Object;
      
      public function DisplayBarEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.dataProvider = param2;
      }
      
      override public function clone() : Event
      {
         return new DisplayBarEvent(type,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("DisplayBarEvent",type);
      }
   }
}
