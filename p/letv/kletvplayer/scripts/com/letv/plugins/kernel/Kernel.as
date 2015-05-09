package com.letv.plugins.kernel
{
   import flash.display.Sprite;
   import com.letv.pluginsAPI.interfaces.IKernel;
   import com.letv.pluginsAPI.log.LogEvent;
   import com.letv.plugins.kernel.core.Facade;
   import flash.display.DisplayObject;
   import flash.system.Security;
   
   public class Kernel extends Sprite implements IKernel
   {
      
      private static var main:Sprite;
      
      private var facade:Facade;
      
      public function Kernel()
      {
         super();
         Security.allowDomain("*");
         Security.allowInsecureDomain("*");
         main = this;
         this.facade = new Facade(this);
      }
      
      public static function sendLog(param1:String, param2:String = "info") : void
      {
         var _loc3_:LogEvent = new LogEvent(LogEvent.LOG_4J,param1,param2);
         main.dispatchEvent(_loc3_);
      }
      
      public function destroy() : void
      {
         this.facade.destroy();
         this.facade = null;
         main = null;
      }
      
      public function get surface() : DisplayObject
      {
         return this;
      }
      
      public function getPlayRecord() : Object
      {
         return this.facade.model.getPlayRecord();
      }
      
      public function setAutoReplay(param1:Boolean) : void
      {
         this.facade.model.setAutoReplay(param1);
      }
      
      public function getCookie(param1:String) : Object
      {
         return this.facade.model.getCookie(param1);
      }
      
      public function getVideoVolume() : Number
      {
         return this.facade.model.getVideoVolume();
      }
      
      public function getVideoRect(param1:String = "xml") : Object
      {
         return this.facade.model.getVideoRect(param1);
      }
      
      public function getVideoRotation() : int
      {
         return this.facade.model.getVideoRotation();
      }
      
      public function getVideoScale() : Number
      {
         return this.facade.model.getVideoScale();
      }
      
      public function getVideoPercent() : Number
      {
         return this.facade.model.getVideoPercent();
      }
      
      public function getVideoColor() : Array
      {
         return this.facade.model.getVideoColor();
      }
      
      public function getDefinition() : String
      {
         return this.facade.model.getDefinition();
      }
      
      public function getDefaultDefinition() : String
      {
         return this.facade.model.getDefaultDefinition();
      }
      
      public function getDefinitionList(param1:String = "amf") : Object
      {
         return this.facade.model.getDefinitionList(param1);
      }
      
      public function getDefinitionMatchList() : Object
      {
         return this.facade.model.getDefinitionMatchList();
      }
      
      public function getPlayset() : Object
      {
         return this.facade.model.getPlayset();
      }
      
      public function getVideoSetting() : Object
      {
         return this.facade.model.getVideoSetting();
      }
      
      public function getSettingAsText() : void
      {
         this.facade.model.getSettingAsText();
      }
      
      public function getVersion() : Object
      {
         return this.facade.model.getVersion();
      }
      
      public function getIdInfo() : Object
      {
         return this.facade.model.getIdInfo();
      }
      
      public function getUserinfo() : Object
      {
         return this.facade.model.getUserInfo();
      }
      
      public function getFullscreenInput() : Boolean
      {
         return this.facade.model.setting.fullscreenInput;
      }
      
      public function getBarrage() : Boolean
      {
         return this.facade.model.setting.barrage;
      }
      
      public function sendStatistics(param1:Object) : void
      {
         this.facade.model.sendStatistics(param1);
      }
      
      public function sendInterface(param1:String, param2:Object = null) : Object
      {
         return this.facade.model.sendInterface(param1,param2);
      }
      
      public function setAssistData(param1:Object) : void
      {
         this.facade.model.setAssistData(param1);
      }
      
      public function setUsePayTicket(param1:Function, param2:Function) : void
      {
         this.facade.controller.setUsePayTicket(param1,param2);
      }
      
      public function setConfig(param1:XML = null, param2:Object = null, param3:Object = null) : void
      {
         this.facade.controller.setConfig(param1,param2,param3);
      }
      
      public function setAuth() : void
      {
         this.facade.controller.setAuth();
      }
      
      public function playNext(param1:Boolean = false, param2:Boolean = false) : Boolean
      {
         return this.facade.controller.playNext(param1,param2);
      }
      
      public function loadAndPlay(param1:Boolean = true, param2:String = null) : void
      {
         this.facade.controller.loadAndPlay(param1,param2);
      }
      
      public function seekTo(param1:Number) : void
      {
         this.facade.controller.seekTo(param1);
      }
      
      public function setDefinition(param1:String = null, param2:String = null, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false) : Boolean
      {
         return this.facade.controller.setDefinition(param1,param2,param3,param4,param5);
      }
      
      public function jumpVideo(param1:int = 0) : void
      {
         this.facade.controller.jumpVideo(param1);
      }
      
      public function closeVideo(param1:Boolean = true) : void
      {
         this.facade.controller.closeVideo(param1);
      }
      
      public function replayVideo() : void
      {
         this.facade.controller.replayVideo();
      }
      
      public function toggleVideo() : void
      {
         this.facade.controller.toggleVideo();
      }
      
      public function pauseVideo() : void
      {
         this.facade.controller.pauseVideo();
      }
      
      public function resumeVideo() : void
      {
         this.facade.controller.resumeVideo();
      }
      
      public function mute(param1:Boolean = true) : void
      {
         this.facade.controller.mute(param1);
      }
      
      public function setCookie(param1:String, param2:Object) : Boolean
      {
         return this.facade.model.setCookie(param1,param2);
      }
      
      public function setVolume(param1:Number) : void
      {
         this.facade.controller.setVolume(param1);
      }
      
      public function setJump(param1:Boolean) : void
      {
         this.facade.controller.setJump(param1);
      }
      
      public function setContinuePlay(param1:Boolean) : void
      {
         this.facade.model.setContinuePlay(param1);
      }
      
      public function setFullscreenInput(param1:Boolean) : void
      {
         this.facade.model.setFullscreenInput(param1);
      }
      
      public function setBarrage(param1:Boolean) : void
      {
         this.facade.model.setBarrage(param1);
      }
      
      public function getPlayState() : Object
      {
         return this.facade.controller.getPlayState();
      }
      
      public function getVideoTime() : Number
      {
         return this.facade.controller.getVideoTime();
      }
      
      public function getFPS() : int
      {
         return this.facade.controller.getFPS();
      }
      
      public function getLoadPercent() : Number
      {
         return this.facade.controller.getLoadPercent();
      }
      
      public function getBufferPercent() : Number
      {
         return this.facade.controller.getBufferPercent();
      }
      
      public function getP2PInfo() : Object
      {
         return this.facade.controller.getP2PInfo();
      }
      
      public function getSectionInfo() : String
      {
         return this.facade.controller.getSectionInfo();
      }
      
      public function get bufferDataSize() : Number
      {
         return this.facade.controller.bufferDataSize;
      }
      
      public function get bufferTime() : Number
      {
         return this.facade.controller.bufferTime;
      }
      
      public function get currentUrl() : String
      {
         return this.facade.controller.currentUrl;
      }
      
      public function get currentNode() : String
      {
         return this.facade.controller.currentNode;
      }
      
      public function setVIP() : void
      {
         this.facade.controller.setVIP();
      }
      
      public function getDownloadSpeed() : int
      {
         return this.facade.controller.getDownloadSpeed();
      }
      
      public function getScreenShot() : Object
      {
         return this.facade.view.getScreenShot();
      }
      
      public function setVisible(param1:Boolean) : void
      {
         this.facade.view.setVisible(param1);
      }
      
      public function setVideoColor(param1:* = 0, param2:* = 0, param3:* = 0, param4:* = 0) : Boolean
      {
         return this.facade.view.setVideoColor(param1,param2,param3,param4);
      }
      
      public function setVideoPercent(param1:Number, param2:Boolean = false) : Boolean
      {
         return this.facade.view.setVideoPercent(param1,param2);
      }
      
      public function setVideoRect(param1:Object) : void
      {
         this.facade.view.setVideoRect(param1);
      }
      
      public function setVideoRotation(param1:int) : Boolean
      {
         return this.facade.view.setVideoRotation(param1);
      }
      
      public function setVideoScale(param1:*) : Boolean
      {
         return this.facade.view.setVideoScale(param1);
      }
      
      public function resetVideoScale() : void
      {
         this.facade.view.resetVideoScale();
      }
      
      public function fullVideoScale() : void
      {
         this.facade.view.fullVideoScale();
      }
      
      public function colorAutoRender() : void
      {
      }
      
      public function adPreloadComplete() : void
      {
         this.facade.controller.adPreloadComplete();
      }
      
      public function getAdPreloadData() : Object
      {
         return this.facade.controller.getAdPreloadData();
      }
   }
}
