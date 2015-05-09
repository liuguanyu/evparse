package com.letv.plugins.kernel.components
{
   import flash.display.Sprite;
   import flash.net.NetStream;
   import com.letv.plugins.kernel.model.Model;
   import flash.media.Video;
   import flash.events.Event;
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   
   public class VideoUI extends Sprite
   {
      
      private static var _softwareVideo:Video;
      
      private static var _embedStream:NetStream;
      
      public static var video:Object;
      
      private var model:Model;
      
      public function VideoUI(param1:Model)
      {
         super();
         this.model = param1;
         this.init();
      }
      
      public static function clear() : void
      {
         try
         {
            _softwareVideo.clear();
         }
         catch(e:Error)
         {
         }
         try
         {
            video.clear();
         }
         catch(e:Error)
         {
         }
      }
      
      public static function attachNetStream(param1:NetStream) : void
      {
         var ns:NetStream = param1;
         _embedStream = ns;
         try
         {
            video.attachNetStream(_embedStream);
         }
         catch(e:Error)
         {
         }
      }
      
      public static function filters(param1:Array, param2:Model) : Boolean
      {
         var arr:Array = param1;
         var model:Model = param2;
         try
         {
            video.filters = arr;
            return true;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function render() : void
      {
         try
         {
            removeChild(_softwareVideo);
         }
         catch(e:Error)
         {
         }
         scaleX = scaleY = 1;
         _softwareVideo.width = this.model.metadata.width;
         _softwareVideo.height = this.model.metadata.height;
         _softwareVideo.x = -_softwareVideo.width / 2;
         _softwareVideo.y = -_softwareVideo.height / 2;
         addChildAt(_softwareVideo,0);
      }
      
      private function onAdded(param1:Event) : void
      {
         if(stage != null)
         {
            this.useVideo();
         }
      }
      
      public function useVideo() : void
      {
         video = _softwareVideo;
         _softwareVideo.visible = true;
         addChildAt(video as DisplayObject,0);
         video.attachNetStream(_embedStream);
      }
      
      private function init() : void
      {
         _softwareVideo = new Video();
         _softwareVideo.smoothing = true;
         _softwareVideo.x = -_softwareVideo.width / 2;
         _softwareVideo.y = -_softwareVideo.height / 2;
         this.useVideo();
         addEventListener(Event.ADDED_TO_STAGE,this.onAdded);
      }
      
      public function get rect() : Rectangle
      {
         try
         {
            return new Rectangle(video.x,video.y,video.width,video.height);
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      public function get isVideo() : Boolean
      {
         try
         {
            return video is Video;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function get oneVideo() : Object
      {
         return VideoUI.video;
      }
   }
}
