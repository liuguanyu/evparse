package com.letv.pluginsAPI.interfaces
{
   import flash.events.IEventDispatcher;
   import flash.display.DisplayObject;
   
   public interface IKernel extends IEventDispatcher
   {
      
      function get surface() : DisplayObject;
      
      function getPlayRecord() : Object;
      
      function setAutoReplay(param1:Boolean) : void;
      
      function getCookie(param1:String) : Object;
      
      function getVideoVolume() : Number;
      
      function getVideoRect(param1:String = "xml") : Object;
      
      function getVideoRotation() : int;
      
      function getVideoScale() : Number;
      
      function getVideoPercent() : Number;
      
      function getVideoColor() : Array;
      
      function getVideoSetting() : Object;
      
      function getDefinition() : String;
      
      function getDefaultDefinition() : String;
      
      function getDefinitionList(param1:String = "amf") : Object;
      
      function getDefinitionMatchList() : Object;
      
      function getPlayset() : Object;
      
      function getSettingAsText() : void;
      
      function getVersion() : Object;
      
      function getIdInfo() : Object;
      
      function getUserinfo() : Object;
      
      function getFullscreenInput() : Boolean;
      
      function getBarrage() : Boolean;
      
      function sendStatistics(param1:Object) : void;
      
      function sendInterface(param1:String, param2:Object = null) : Object;
      
      function setAssistData(param1:Object) : void;
      
      function setUsePayTicket(param1:Function, param2:Function) : void;
      
      function setConfig(param1:XML = null, param2:Object = null, param3:Object = null) : void;
      
      function setAuth() : void;
      
      function playNext(param1:Boolean = false, param2:Boolean = false) : Boolean;
      
      function loadAndPlay(param1:Boolean = true, param2:String = null) : void;
      
      function seekTo(param1:Number) : void;
      
      function setDefinition(param1:String = null, param2:String = null, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false) : Boolean;
      
      function jumpVideo(param1:int = 0) : void;
      
      function closeVideo(param1:Boolean = true) : void;
      
      function replayVideo() : void;
      
      function toggleVideo() : void;
      
      function pauseVideo() : void;
      
      function resumeVideo() : void;
      
      function mute(param1:Boolean = true) : void;
      
      function setCookie(param1:String, param2:Object) : Boolean;
      
      function setVolume(param1:Number) : void;
      
      function setJump(param1:Boolean) : void;
      
      function setContinuePlay(param1:Boolean) : void;
      
      function setFullscreenInput(param1:Boolean) : void;
      
      function setBarrage(param1:Boolean) : void;
      
      function getPlayState() : Object;
      
      function getVideoTime() : Number;
      
      function getFPS() : int;
      
      function getLoadPercent() : Number;
      
      function getBufferPercent() : Number;
      
      function getP2PInfo() : Object;
      
      function getSectionInfo() : String;
      
      function get bufferDataSize() : Number;
      
      function get bufferTime() : Number;
      
      function get currentUrl() : String;
      
      function get currentNode() : String;
      
      function setVIP() : void;
      
      function getScreenShot() : Object;
      
      function setVisible(param1:Boolean) : void;
      
      function setVideoColor(param1:* = 0, param2:* = 0, param3:* = 0, param4:* = 0) : Boolean;
      
      function setVideoPercent(param1:Number, param2:Boolean = false) : Boolean;
      
      function setVideoRect(param1:Object) : void;
      
      function setVideoRotation(param1:int) : Boolean;
      
      function setVideoScale(param1:*) : Boolean;
      
      function resetVideoScale() : void;
      
      function fullVideoScale() : void;
      
      function colorAutoRender() : void;
      
      function getDownloadSpeed() : int;
      
      function adPreloadComplete() : void;
      
      function getAdPreloadData() : Object;
   }
}
