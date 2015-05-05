package cn.pplive.player.events
{
   import flash.events.Event;
   
   public class PPLiveEvent extends Event
   {
      
      public static var VOD_ONNOTIFICATION:String = "onNotification";
      
      public static var VOD_ONINIT:String = "onInit";
      
      public static var VOD_ONREADY:String = "onReady";
      
      public static var VOD_ONLOGOUT:String = "onLogout";
      
      public static var VOD_ONVIDEO_READY:String = "onVideoReady";
      
      public static var VOD_ONPLAYSTATE_CHANGED:String = "onPlayStateChanged";
      
      public static var VOD_ONMODE_CHANGED:String = "onModeChanged";
      
      public static var VOD_ONVOLUME_CHANGED:String = "onVolumeChanged";
      
      public static var VOD_ONPROGRESS_CHANGED:String = "onProgressChanged";
      
      public static var VOD_ONERROR:String = "onError";
      
      public static var VOD_ONREFERENCE:String = "onReference";
      
      public static var VOD_ONSTREAM_CHANGED:String = "onStreamChanged";
      
      public static var VOD_ONADEVENT:String = "onAdEvent";
      
      public static var VOD_ONVIP_VALIDATE:String = "onVipValidate";
      
      protected var $param = null;
      
      public function PPLiveEvent(param1:String, param2:* = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.$param = param2;
      }
      
      public function get param() : *
      {
         return this.$param;
      }
      
      public function set param(param1:*) : void
      {
         this.$param = param1;
      }
   }
}
