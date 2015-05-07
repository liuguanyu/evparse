package com.letv.player.components.controlBar.events
{
   import flash.events.Event;
   
   public class ControlBarEvent extends Event
   {
      
      public static const VIDEO_START_FROM_SLEEP:String = "videoStartFromSleep";
      
      public static const VIDEO_REPLAY:String = "videoReplay";
      
      public static const VIDEO_PAUSE:String = "videoPause";
      
      public static const VIDEO_RESUME:String = "videoResume";
      
      public static const SEEK_TO:String = "seekTo";
      
      public static const JUMP_TAIL:String = "jumpTail";
      
      public static const PLAY_NEXT:String = "playNext";
      
      public static const DOCK_ZOOM_OUT:String = "dockZoomOut";
      
      public static const DOCK_ZOOM_IN:String = "dockZoomIn";
      
      public static const SET_VOLUME:String = "setVolume";
      
      public static const CONTROLBAR_MOVE:String = "controlbarMove";
      
      public static const SCALE_REGULATE:String = "scaleRegulate";
      
      public static const DEFINITION_REGULATE:String = "definitionRegulate";
      
      public static const DEFINITION_VIP:String = "definitionVip";
      
      public static const HIDESKIN:String = "hideSkin";
      
      public static const SHOWSKIN:String = "showSking";
      
      public var controlbarX:Number = 0;
      
      public var controlbarY:Number = 0;
      
      public var dataProvider:Object;
      
      public function ControlBarEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
