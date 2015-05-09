package com.letv.pluginsAPI.kernel
{
   import flash.events.Event;
   
   public class PlayerStateEvent extends Event
   {
      
      public static const USER_AUTH_VALID:String = "userAuthValid";
      
      public static const GSLB_SUCCESS:String = "gslbSuccess";
      
      public static const PLAYER_MEDIA_MODE:String = "playerMediaMode";
      
      public static const PLAYER_START_READY:String = "playerStartReady";
      
      public static const PLAYER_START:String = "playerStart";
      
      public static const PLAYER_EMPTY:String = "playerEmpty";
      
      public static const PLAYER_LOADING:String = "playerLoading";
      
      public static const PLAYER_FULL:String = "playerFull";
      
      public static const PLAYER_STOPPING:String = "playerStopping";
      
      public static const PLAYER_STOP:String = "playerStop";
      
      public static const PLAYER_REPLAY:String = "playerReplay";
      
      public static const PLAYER_LOCK:String = "playerLock";
      
      public static const PLAYER_NEXT:String = "playerNext";
      
      public static const PLAYER_DEFINITION:String = "playerDefinition";
      
      public static const MODE_TYPE:String = "modeType";
      
      public static const EXCUTE_P2P:String = "excuteP2P";
      
      public static const EXCUTE_STATISTICS:String = "excuteStatistics";
      
      public static const PLAYER_MUTE:String = "player_mute";
      
      public static const PLAYER_OVER:String = "LIVE_OVER";
      
      public static const ERROR:String = "ERROR";
      
      public static const PLAYER_SPEED:String = "playerSpeed";
      
      public static const VIDEO_RECT:String = "videoRect";
      
      public static const FIRSTLOOK_STOPPING:String = "firstlookStopping";
      
      public static const PLAYER_FIRSTLOOK:String = "playerFirstlook";
      
      public static const LOGINLOOK_STOPPING:String = "loginlookStopping";
      
      public static const PLAYER_LOGINLOOK:String = "playerLoginlook";
      
      public static const SWAP_DEFINITION_FAIL:String = "swapdefinitionfail";
      
      public static const SWAP_COMPLETE:String = "swapcomplete";
      
      public static const CUT_PLAY_COMPLETE:String = "cutPlayComplete";
      
      public static const STOP_PRELOAD:String = "stopPreload";
      
      public static const START_PRELOAD:String = "startPreload";
      
      public static const START_PRELOAD_AD:String = "startPreloadAD";
      
      public static const PLAY_PRELOAD:String = "playPreload";
      
      public var dataProvider:Object;
      
      public function PlayerStateEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.dataProvider = param2;
      }
   }
}
