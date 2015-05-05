package com
{
   import flash.system.LoaderContext;
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.text.*;
   import com.utl.consolelog;
   import flash.system.ApplicationDomain;
   
   public class Skinloader extends Sprite
   {
      
      public var context:LoaderContext;
      
      public var skinPercentLoaded:Number = 0;
      
      public var playerObj:Object;
      
      public function Skinloader(param1:parmParse, param2:Object)
      {
         super();
         this.playerObj = param2;
         this.loadskin();
      }
      
      function getCurrentDomainUrl() : String
      {
         var _loc1_:String = this.playerObj.loaderInfo.url.slice(0,this.playerObj.loaderInfo.url.lastIndexOf(".swf") + 1);
         return _loc1_.slice(0,_loc1_.lastIndexOf("/") + 1);
      }
      
      public function loadskin() : *
      {
         var _loc1_:* = this.getCurrentDomainUrl() + "skin/liketudou.swf";
         trace("swfs:" + _loc1_);
         consolelog.log("swfs:" + _loc1_);
         var _loc2_:* = new Loader();
         this.context = new LoaderContext();
         this.context.applicationDomain = ApplicationDomain.currentDomain;
         _loc2_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.loadComplete);
         _loc2_.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
         _loc2_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
         _loc2_.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.loadProgress);
         _loc2_.load(new URLRequest(_loc1_),this.context);
      }
      
      function securityErrorHandler(param1:Event) : void
      {
         dispatchEvent(new playerEvents(playerEvents.SKIN_ERROR));
      }
      
      function ioErrorHandler(param1:Event) : void
      {
         dispatchEvent(new playerEvents(playerEvents.SKIN_ERROR));
      }
      
      function loadProgress(param1:ProgressEvent) : void
      {
         this.skinPercentLoaded = param1.bytesLoaded / param1.bytesTotal;
         this.skinPercentLoaded = Math.round(this.skinPercentLoaded * 100);
         dispatchEvent(new playerEvents(playerEvents.SKIN_PROGRESS));
      }
      
      function loadComplete(param1:Event) : void
      {
         dispatchEvent(new playerEvents(playerEvents.SKIN_LOADED));
      }
      
      public function getSkinMovieClipByClassName(param1:String) : MovieClip
      {
         var o:MovieClip = null;
         var c:Class = null;
         var className:String = param1;
         try
         {
            c = this.context.applicationDomain.getDefinition(className) as Class;
            o = new c() as MovieClip;
         }
         catch(err:Error)
         {
            dispatchEvent(new playerEvents(playerEvents.SKIN_ERROR));
         }
         return o;
      }
      
      public function getSkinObjectByClassName(param1:String) : Object
      {
         var o:Object = null;
         var c:Class = null;
         var className:String = param1;
         try
         {
            c = this.context.applicationDomain.getDefinition(className) as Class;
            o = new c() as Object;
         }
         catch(err:Error)
         {
            dispatchEvent(new playerEvents(playerEvents.SKIN_ERROR));
         }
         return o;
      }
      
      public function getSkinButtonByClassName(param1:String) : SimpleButton
      {
         var o:SimpleButton = null;
         var c:Class = null;
         var className:String = param1;
         try
         {
            c = this.context.applicationDomain.getDefinition(className) as Class;
            o = new c() as SimpleButton;
         }
         catch(err:Error)
         {
            dispatchEvent(new playerEvents(playerEvents.SKIN_ERROR));
         }
         return o;
      }
   }
}
