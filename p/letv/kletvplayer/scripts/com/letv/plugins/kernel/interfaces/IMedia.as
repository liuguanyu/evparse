package com.letv.plugins.kernel.interfaces
{
   import com.letv.plugins.kernel.model.Model;
   
   public interface IMedia
   {
      
      function init(param1:Model, param2:Boolean = false) : void;
      
      function replayVideo() : void;
      
      function toggleVideo() : void;
      
      function pauseVideo() : void;
      
      function resumeVideo() : void;
      
      function closeVideo(param1:Boolean = true) : void;
      
      function jumpVideo(param1:int = 0) : void;
      
      function seekTo(param1:Number, param2:Boolean = false) : void;
      
      function setVolume(param1:Number) : void;
      
      function getPlayState() : Object;
      
      function getVideoTime() : Number;
      
      function getFPS() : int;
      
      function getLoadPercent() : Number;
      
      function getBufferPercent() : Number;
      
      function getSessionDuration() : Number;
      
      function get bufferDataSize() : Number;
      
      function get bufferTime() : Number;
      
      function get currentUrl() : String;
      
      function get currentNode() : String;
      
      function get p2pInfo() : Object;
      
      function get sectionInfo() : String;
      
      function get getDownloadSpeed() : int;
      
      function get streamValid() : Boolean;
      
      function startPreload() : void;
      
      function clearPreloadData() : void;
   }
}
