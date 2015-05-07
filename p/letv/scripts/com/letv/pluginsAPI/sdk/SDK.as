package com.letv.pluginsAPI.sdk
{
   import flash.events.EventDispatcher;
   import com.letv.pluginsAPI.interfaces.ISDK;
   import flash.events.Event;
   import com.letv.pluginsAPI.PlayerEvent;
   import com.letv.pluginsAPI.kernel.DefinitionType;
   
   public class SDK extends EventDispatcher implements ISDK
   {
      
      private var sdk:Object;
      
      public function SDK(param1:Object)
      {
         super();
         if(!(param1 == null) && (param1.hasOwnProperty("api")))
         {
            this.sdk = param1.api;
            this.sdk.addEventListener(PlayerEvent.PLAY_STATE,this.onSdkState);
         }
      }
      
      public function get instance() : Object
      {
         return this.sdk;
      }
      
      protected function onSdkState(param1:Event) : void
      {
         var _loc2_:PlayerEvent = new PlayerEvent(PlayerEvent.PLAY_STATE);
         _loc2_.state = param1["state"];
         _loc2_.dataProvider = param1["dataProvider"];
         dispatchEvent(_loc2_);
      }
      
      public function setFlashvars(param1:Object) : void
      {
         if(this.sdk != null)
         {
            this.sdk.setFlashvars(param1);
            return;
         }
         throw new Error("No SDK Plugin");
      }
      
      public function getPlayRecord() : Object
      {
         if(this.sdk != null)
         {
            return this.sdk.getPlayRecord();
         }
         return null;
      }
      
      public function getVersion() : Object
      {
         if(this.sdk != null)
         {
            return this.sdk.getVersion();
         }
         return {};
      }
      
      public function resetVideoScale() : void
      {
         if(this.sdk != null)
         {
            this.sdk.resetVideoScale();
         }
      }
      
      public function fullVideoScale() : void
      {
         if(this.sdk != null)
         {
            this.sdk.fullVideoScale();
         }
      }
      
      public function setVideoScale(param1:*) : Boolean
      {
         if(this.sdk)
         {
            return this.sdk.setVideoScale(param1);
         }
         return false;
      }
      
      public function setVideoColor(param1:* = 0, param2:* = 0, param3:* = 0, param4:* = 0) : Boolean
      {
         if(this.sdk != null)
         {
            return this.sdk.setVideoColor(param1,param2,param3,param4);
         }
         return false;
      }
      
      public function setVideoPercent(param1:Number, param2:Boolean = false) : Boolean
      {
         if(this.sdk != null)
         {
            return this.sdk.setVideoPercent(param1,param2);
         }
         return false;
      }
      
      public function setAutoReplay(param1:Boolean) : void
      {
         if(this.sdk != null)
         {
            this.sdk.setAutoReplay(param1);
         }
      }
      
      public function setVideoRect(param1:Object) : void
      {
         if(this.sdk != null)
         {
            this.sdk.setVideoRect(param1);
         }
      }
      
      public function setVideoRotation(param1:int) : void
      {
         if(this.sdk)
         {
            this.sdk.setVideoRotation(param1);
         }
      }
      
      public function setJump(param1:Boolean) : void
      {
         if(this.sdk != null)
         {
            this.sdk.setJump(param1);
         }
      }
      
      public function setContinuePlay(param1:Boolean) : void
      {
         if(this.sdk != null)
         {
            this.sdk.setContinuePlay(param1);
         }
      }
      
      public function setFullscreenInput(param1:Boolean) : void
      {
         if(this.sdk != null)
         {
            this.sdk.setFullscreenInput(param1);
         }
      }
      
      public function setBarrage(param1:Boolean) : void
      {
         if(this.sdk != null)
         {
            this.sdk.setBarrage(param1);
         }
      }
      
      public function setVIP() : void
      {
         if(this.sdk != null)
         {
            this.sdk.setVIP();
         }
      }
      
      public function getVideoTime() : Number
      {
         if(this.sdk != null)
         {
            return this.sdk.getVideoTime();
         }
         return 0;
      }
      
      public function getUserinfo() : Object
      {
         if(this.sdk != null)
         {
            return this.sdk.getUserinfo();
         }
         return null;
      }
      
      public function getVideoSetting() : Object
      {
         if(this.sdk != null)
         {
            return this.sdk.getVideoSetting();
         }
         return null;
      }
      
      public function getLoadPercent() : Number
      {
         if(this.sdk != null)
         {
            return this.sdk.getLoadPercent();
         }
         return 0;
      }
      
      public function getBufferPercent() : Number
      {
         if(this.sdk != null)
         {
            return this.sdk.getBufferPercent();
         }
         return 0;
      }
      
      public function getVideoColor() : Array
      {
         if(this.sdk != null)
         {
            return this.sdk.getVideoColor();
         }
         return null;
      }
      
      public function getDefinition() : String
      {
         if(this.sdk != null)
         {
            return this.sdk.getDefinition();
         }
         return DefinitionType.SD;
      }
      
      public function getDefaultDefinition() : String
      {
         if(this.sdk != null)
         {
            return this.sdk.getDefaultDefinition();
         }
         return DefinitionType.AUTO;
      }
      
      public function getDefinitionList() : Object
      {
         if(this.sdk != null)
         {
            return this.sdk.getDefinitionList();
         }
         return null;
      }
      
      public function getDefinitionMatchList() : Object
      {
         if(this.sdk != null)
         {
            return this.sdk.getDefinitionMatchList();
         }
         return null;
      }
      
      public function getPlayState() : Object
      {
         if(this.sdk)
         {
            return this.sdk.getPlayState();
         }
         return null;
      }
      
      public function getFullscreenInput() : Boolean
      {
         if(!(this.sdk == null) && (this.sdk.hasOwnProperty("getFullscreenInput")))
         {
            return this.sdk.getFullscreenInput();
         }
         return false;
      }
      
      public function getBarrage() : Boolean
      {
         if(!(this.sdk == null) && (this.sdk.hasOwnProperty("getBarrage")))
         {
            return this.sdk.getBarrage();
         }
         return false;
      }
      
      public function setDefinition(param1:String = null, param2:String = null, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false) : void
      {
         if(this.sdk)
         {
            this.sdk.setDefinition(param1,param2,param3,param4,param5);
         }
      }
      
      public function playNewId(param1:* = null) : void
      {
         if(this.sdk != null)
         {
            this.sdk.playNewId(param1);
         }
      }
      
      public function pauseAd() : void
      {
         if(this.sdk != null)
         {
            this.sdk.pauseAd();
         }
      }
      
      public function resumeAd() : void
      {
         if(this.sdk != null)
         {
            this.sdk.resumeAd();
         }
      }
      
      public function pauseVideo() : void
      {
         if(this.sdk != null)
         {
            this.sdk.pauseVideo();
         }
      }
      
      public function pauseVideoNoAd() : void
      {
         if(this.sdk != null)
         {
            this.sdk.pauseVideoNoAd();
         }
      }
      
      public function resumeVideo() : void
      {
         if(this.sdk != null)
         {
            this.sdk.resumeVideo();
         }
      }
      
      public function replayVideo() : void
      {
         if(this.sdk != null)
         {
            this.sdk.replayVideo();
         }
      }
      
      public function closeVideo(param1:Boolean = true) : void
      {
         if(this.sdk != null)
         {
            this.sdk.closeVideo(param1);
         }
      }
      
      public function shutDown(param1:* = null) : void
      {
         if(this.sdk != null)
         {
            this.sdk.shutDown();
         }
      }
      
      public function lightTurnOn(param1:* = null) : void
      {
      }
      
      public function lightTurnOff(param1:* = null) : void
      {
      }
      
      public function seekTo(param1:Number) : void
      {
         if(this.sdk != null)
         {
            this.sdk.seekTo(param1);
         }
      }
      
      public function setVolume(param1:Number) : void
      {
         if(this.sdk != null)
         {
            this.sdk.setVolume(param1);
         }
      }
      
      public function startUp() : void
      {
         if(this.sdk != null)
         {
            this.sdk.startUp();
         }
      }
      
      public function playNext(param1:Boolean = false, param2:Boolean = false) : Boolean
      {
         if(this.sdk != null)
         {
            return this.sdk.playNext(param1,param2);
         }
         return false;
      }
      
      public function getInfotip(param1:String) : Object
      {
         if(this.sdk != null)
         {
            return this.sdk.getInfotip(param1);
         }
         return "";
      }
      
      public function getPlayset() : Object
      {
         if(this.sdk != null)
         {
            return this.sdk.getPlayset();
         }
         return {};
      }
      
      public function sendStatistics(param1:Object) : void
      {
         if(this.sdk != null)
         {
            this.sdk.sendStatistics(param1);
         }
      }
      
      public function sendInterface(param1:String, param2:Object = null) : Object
      {
         if(this.sdk != null)
         {
            return this.sdk.sendInterface(param1,param2);
         }
         return null;
      }
      
      public function jumpVideo(param1:int = 0) : void
      {
         if(this.sdk != null)
         {
            this.sdk.jumpVideo(param1);
         }
      }
      
      public function getScreenShot() : Object
      {
         if(this.sdk != null)
         {
            return this.sdk.getScreenShot();
         }
         return null;
      }
      
      public function getDownloadSpeed() : int
      {
         if(this.sdk != null)
         {
            return this.sdk.getDownloadSpeed();
         }
         return 0;
      }
      
      public function getVideoRotation() : int
      {
         if(this.sdk != null)
         {
            return this.sdk.getVideoRotation();
         }
         return 0;
      }
      
      public function getVideoScale() : Number
      {
         if(this.sdk != null)
         {
            return this.sdk.getVideoScale();
         }
         return 16 / 9;
      }
      
      public function getVideoPercent() : Number
      {
         if(this.sdk != null)
         {
            return this.sdk.getVideoPercent();
         }
         return 1;
      }
      
      public function getHtmlLog() : String
      {
         if(this.sdk != null)
         {
            return this.sdk.getHtmlLog();
         }
         return null;
      }
      
      public function displayDebug() : void
      {
         if(this.sdk != null)
         {
            this.sdk.displayDebug();
         }
      }
      
      public function setUsePayTicket(param1:Function, param2:Function) : void
      {
         if(this.sdk != null)
         {
            this.sdk.setUsePayTicket(param1,param2);
         }
      }
      
      public function sendLog(param1:String, param2:String = "info") : void
      {
         if(!(this.sdk == null) && (this.sdk.hasOwnProperty("sendLog")))
         {
            this.sdk.sendLog(param1,param2);
         }
      }
      
      public function sendFeedback(param1:Object) : void
      {
         if(!(this.sdk == null) && (this.sdk.hasOwnProperty("sendFeedback")))
         {
            this.sdk.sendFeedback(param1);
         }
      }
      
      public function hidePauseAd() : void
      {
         if(!(this.sdk == null) && (this.sdk.hasOwnProperty("hidePauseAd")))
         {
            this.sdk.hidePauseAd();
         }
      }
      
      public function getIdInfo() : Object
      {
         if(this.sdk != null)
         {
            return this.sdk.getIdInfo();
         }
         return null;
      }
      
      public function get x() : Number
      {
         if(this.sdk != null)
         {
            return this.sdk.x;
         }
         return 0;
      }
      
      public function get y() : Number
      {
         if(this.sdk != null)
         {
            return this.sdk.y;
         }
         return 0;
      }
      
      public function get width() : Number
      {
         if(this.sdk != null)
         {
            return this.sdk.width;
         }
         return 0;
      }
      
      public function get height() : Number
      {
         if(this.sdk != null)
         {
            return this.sdk.height;
         }
         return 0;
      }
   }
}
