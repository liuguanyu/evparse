package com.letv.pluginsAPI.interfaces
{
   import flash.events.IEventDispatcher;
   
   public interface ISDK extends IEventDispatcher
   {
      
      function setFlashvars(param1:Object) : void;
      
      function getVersion() : Object;
      
      function resetVideoScale() : void;
      
      function fullVideoScale() : void;
      
      function setVideoScale(param1:*) : Boolean;
      
      function setVideoColor(param1:* = 0, param2:* = 0, param3:* = 0, param4:* = 0) : Boolean;
      
      function setVideoPercent(param1:Number, param2:Boolean = false) : Boolean;
      
      function setAutoReplay(param1:Boolean) : void;
      
      function setVideoRect(param1:Object) : void;
      
      function setVideoRotation(param1:int) : void;
      
      function setJump(param1:Boolean) : void;
      
      function setContinuePlay(param1:Boolean) : void;
      
      function getVideoTime() : Number;
      
      function getUserinfo() : Object;
      
      function getIdInfo() : Object;
      
      function getVideoSetting() : Object;
      
      function getLoadPercent() : Number;
      
      function getBufferPercent() : Number;
      
      function getPlayRecord() : Object;
      
      function getVideoColor() : Array;
      
      function getDefinition() : String;
      
      function getDefaultDefinition() : String;
      
      function getDefinitionList() : Object;
      
      function getDefinitionMatchList() : Object;
      
      function getPlayState() : Object;
      
      function setDefinition(param1:String = null, param2:String = null, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false) : void;
      
      function playNewId(param1:* = null) : void;
      
      function pauseVideo() : void;
      
      function resumeVideo() : void;
      
      function replayVideo() : void;
      
      function resumeAd() : void;
      
      function pauseAd() : void;
      
      function closeVideo(param1:Boolean = true) : void;
      
      function shutDown(param1:* = null) : void;
      
      function lightTurnOn(param1:* = null) : void;
      
      function lightTurnOff(param1:* = null) : void;
      
      function seekTo(param1:Number) : void;
      
      function setVolume(param1:Number) : void;
      
      function startUp() : void;
      
      function getPlayset() : Object;
      
      function jumpVideo(param1:int = 0) : void;
      
      function getVideoRotation() : int;
      
      function getVideoScale() : Number;
      
      function getVideoPercent() : Number;
      
      function pauseVideoNoAd() : void;
      
      function setFullscreenInput(param1:Boolean) : void;
      
      function setBarrage(param1:Boolean) : void;
      
      function setVIP() : void;
      
      function playNext(param1:Boolean = false, param2:Boolean = false) : Boolean;
      
      function sendStatistics(param1:Object) : void;
      
      function sendInterface(param1:String, param2:Object = null) : Object;
      
      function getFullscreenInput() : Boolean;
      
      function getBarrage() : Boolean;
      
      function getScreenShot() : Object;
      
      function getHtmlLog() : String;
      
      function getDownloadSpeed() : int;
      
      function displayDebug() : void;
      
      function setUsePayTicket(param1:Function, param2:Function) : void;
      
      function sendLog(param1:String, param2:String = "info") : void;
      
      function sendFeedback(param1:Object) : void;
      
      function hidePauseAd() : void;
   }
}
