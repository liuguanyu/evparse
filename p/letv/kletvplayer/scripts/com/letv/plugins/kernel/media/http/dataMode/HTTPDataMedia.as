package com.letv.plugins.kernel.media.http.dataMode
{
   import com.letv.plugins.kernel.media.BaseMedia;
   import com.letv.plugins.kernel.interfaces.IMedia;
   import com.letv.plugins.kernel.model.Model;
   import com.letv.plugins.kernel.media.PlayMode;
   import com.alex.media.net.HTTPDataNetStreaming;
   import com.alex.media.events.HTTPNetStreamingEvent;
   import com.letv.plugins.kernel.components.VideoUI;
   import com.letv.pluginsAPI.kernel.PlayerStateEvent;
   import com.letv.plugins.kernel.Kernel;
   import com.alex.media.net.BaseNetStreaming;
   import com.letv.pluginsAPI.kernel.PlayerError;
   import com.letv.plugins.kernel.controller.gslb.GslbEvent;
   
   public class HTTPDataMedia extends BaseMedia
   {
      
      private static var _instance:IMedia;
      
      private var stream:HTTPDataNetStreaming;
      
      private var playSpeed:int = 0;
      
      public function HTTPDataMedia()
      {
         super();
      }
      
      public static function getInstance() : IMedia
      {
         if(_instance == null)
         {
            _instance = new HTTPDataMedia();
         }
         return _instance;
      }
      
      override public function init(param1:Model, param2:Boolean = false) : void
      {
         var _loc3_:Number = super.initBase(param1,PlayMode.HTTP_DATA);
         this.destroyStream();
         if(this.stream == null)
         {
            this.stream = new HTTPDataNetStreaming();
         }
         this.stream.addEventListener(HTTPNetStreamingEvent.LOG,this.onHttpNetStreamingLog);
         this.stream.addEventListener(HTTPNetStreamingEvent.STATUS,this.onHttpNetStreamingStatus);
         VideoUI.attachNetStream(this.stream.stream);
         this.stream.autoplay = model.setting.autoPlay;
         this.setVolume(0);
         this.stream.play(model.cdnlist,_loc3_);
         if(param2)
         {
            sendState(PlayerStateEvent.SWAP_COMPLETE,{
               "last":true,
               "definition":model.getDefinition()
            });
         }
      }
      
      protected function destroyStream() : void
      {
         if(this.stream != null)
         {
            this.stream.close();
            this.stream.removeEventListener(HTTPNetStreamingEvent.LOG,this.onHttpNetStreamingLog);
            this.stream.removeEventListener(HTTPNetStreamingEvent.STATUS,this.onHttpNetStreamingStatus);
         }
      }
      
      protected function onHttpNetStreamingLog(param1:HTTPNetStreamingEvent) : void
      {
         Kernel.sendLog(String(param1.dataProvider),param1.status);
      }
      
      protected function onHttpNetStreamingStatus(param1:HTTPNetStreamingEvent) : void
      {
         switch(param1.status)
         {
            case BaseNetStreaming.VIDEO_ERROR:
               this.seekToFromError("HTTPDataFileError","48" + param1.errorCode,Number(param1.dataProvider));
               break;
            case BaseNetStreaming.FILE_READ_ERROR:
               this.seekToFromError("HTTPDataFileError","49" + param1.errorCode,Number(param1.dataProvider));
               break;
            case BaseNetStreaming.VIDEO_BUFFER_FULL:
               this.onBufferFull();
               break;
            case BaseNetStreaming.VIDEO_BUFFER_EMPTY:
               this.onBufferEmpty();
               break;
            case BaseNetStreaming.VIDEO_BUFFER_LOADING:
               sendState(PlayerStateEvent.PLAYER_LOADING);
               break;
            case BaseNetStreaming.VIDEO_START:
               this.onPlayStart();
               break;
            case BaseNetStreaming.VIDEO_STOP:
               this.onPlayStop();
               break;
            case BaseNetStreaming.FILE_READ_COMPLETE:
               this.onMetaData(param1.dataProvider);
               break;
            case BaseNetStreaming.VIDEO_SPEED:
               this.playSpeed = int(param1.dataProvider);
               super.speed = {"speed":param1.dataProvider};
               break;
         }
      }
      
      protected function seekToFromError(param1:String, param2:String, param3:Number) : void
      {
         sendPlayStat(param2,utime,1);
         Kernel.sendLog(this + " seekToFromError " + param1 + " retryOnce: " + retryOnce + " retry: " + retry + " retryMax: " + retryMax + " errorTime: " + param3);
         this.closeVideo(false);
         sendError(param2,param3);
      }
      
      protected function onGetData(param1:Object) : void
      {
         super.speed = param1;
      }
      
      protected function onMetaData(param1:Object) : void
      {
         if(!startPlay)
         {
            super.onMeta(param1);
         }
      }
      
      protected function onPlayStart() : void
      {
         Kernel.sendLog(this + " onPlayStart");
         canPlay = true;
         sendState(PlayerStateEvent.PLAYER_START_READY);
         if(model.setting.autoPlay)
         {
            this.watchStart();
         }
      }
      
      protected function onBufferFull(param1:Object = null) : void
      {
         Kernel.sendLog(this + " onBufferFull");
         if(model.setting.autoPlay)
         {
            super.onFull();
            setLoop(true);
         }
         else
         {
            this.pauseVideo();
         }
      }
      
      protected function onBufferEmpty(param1:Object = null) : void
      {
         Kernel.sendLog(this + " onBufferEmpty");
         super.onEmpty();
      }
      
      protected function onPlayStop() : void
      {
         Kernel.sendLog(this + " onPlayStop");
         this.watchStop();
      }
      
      override protected function onDelay() : void
      {
         if(this.stream != null)
         {
            Kernel.sendLog(this + " Timeout Error " + this.stream.bytesLoaded);
            this.seekToFromError("timeout",PlayerError.PLAY_HTTP_TIMEOUT_ERROR,this.stream.time);
         }
      }
      
      override protected function onLoop() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = NaN;
         var _loc3_:* = NaN;
         if(this.stream == null)
         {
            return;
         }
         super.onLoop();
         if(!model.play.limitData.limitPlay)
         {
            return;
         }
         if(!stopPlay)
         {
            _loc1_ = Math.round(this.getVideoTime());
            _loc2_ = model.play.limitData.stopTime;
            _loc3_ = _loc2_ > duration?duration:_loc2_;
            if(_loc1_ >= _loc3_)
            {
               this.playStop();
            }
         }
      }
      
      override protected function watchStart() : void
      {
         this.setVolume(model.setting.volume);
         super.watchStart();
      }
      
      override protected function watchStop(param1:Boolean = true) : void
      {
         if(this.stream != null)
         {
            this.stream.pause();
         }
         super.watchStop();
         if((model.play.autoReplay) || (model.config.autoReplay))
         {
            super.watchStopAutoReplay();
            autoReplay();
         }
         else
         {
            super.watchStop();
         }
      }
      
      override protected function onLoadLoopGslbSuccess(param1:GslbEvent) : Boolean
      {
         if(this.stream != null)
         {
            this.stream.cdnlist = model.cdnlist;
         }
         return true;
      }
      
      override public function seekTo(param1:Number, param2:Boolean = false) : void
      {
         var _loc3_:* = NaN;
         var _loc4_:* = NaN;
         if(this.stream != null)
         {
            var param1:Number = param1 >= duration?int(duration - 10):int(param1);
            if((startPlay) && (model.play.limitData.limitPlay))
            {
               _loc3_ = model.play.limitData.stopTime;
               _loc4_ = _loc3_ > duration?duration:_loc3_;
               if(param1 >= _loc4_)
               {
                  this.playStop();
                  return;
               }
            }
            super.seekTo(param1,param2);
            Kernel.sendLog(this + " seekTo: " + param1 + " duration: " + duration);
            this.stream.seek(param1);
            this.setVolume(model.setting.volume);
            this.resumeVideo();
         }
      }
      
      override public function pauseVideo() : void
      {
         super.pauseVideo();
         if(this.stream != null)
         {
            this.stream.pause();
         }
      }
      
      override public function resumeVideo() : void
      {
         if(this.stream != null)
         {
            this.stream.resume();
         }
         super.resumeVideo();
      }
      
      private function playStop() : void
      {
         try
         {
            this.stream["pause"]();
         }
         catch(e:Error)
         {
         }
         model.dispatchEvent(new PlayerStateEvent(PlayerStateEvent.CUT_PLAY_COMPLETE,model.play.limitData.stopName));
         super.watchStop(false);
         this.closeVideo();
      }
      
      override public function replayVideo() : void
      {
         super.replayVideo();
         if((model.setting.jump) && model.vrs.headTime > 0)
         {
            this.seekTo(model.vrs.headTime);
         }
         else
         {
            this.seekTo(0);
         }
      }
      
      override public function closeVideo(param1:Boolean = true) : void
      {
         super.closeVideo(param1);
         if(this.stream != null)
         {
            this.stream.close();
         }
      }
      
      override public function jumpVideo(param1:int = 0) : void
      {
         var _loc2_:* = NaN;
         var _loc3_:* = NaN;
         super.jumpVideo(param1);
         if(!model.play.limitData.limitPlay)
         {
            return;
         }
         if(duration > 0)
         {
            _loc2_ = model.play.limitData.stopTime;
            _loc3_ = _loc2_ > duration?duration:_loc2_;
            if(param1 == 0 && model.vrs.headTime >= _loc3_)
            {
               this.playStop();
            }
            else if(param1 == 1 && model.vrs.tailTime >= _loc3_)
            {
               this.playStop();
            }
            
         }
      }
      
      override public function setVolume(param1:Number) : void
      {
         if(this.stream != null)
         {
            this.stream.volume = param1;
         }
      }
      
      override public function getVideoTime() : Number
      {
         if(this.stream != null)
         {
            return this.stream.time;
         }
         return 0;
      }
      
      override public function getFPS() : int
      {
         if(!(this.stream == null) && !(this.stream.stream == null))
         {
            return this.stream.stream.currentFPS;
         }
         return 0;
      }
      
      override public function getLoadPercent() : Number
      {
         if(this.stream != null)
         {
            return this.stream.loadPercent;
         }
         return 0;
      }
      
      override public function getBufferPercent() : Number
      {
         if(this.stream != null)
         {
            return this.stream.bufferPercent;
         }
         return 0;
      }
      
      override public function get bufferDataSize() : Number
      {
         if(this.stream != null)
         {
            return this.stream.bytesLoaded;
         }
         return 0;
      }
      
      override public function get sectionInfo() : String
      {
         if(this.stream != null)
         {
            return this.stream.videoinfo;
         }
         return "1/1";
      }
      
      override public function get getDownloadSpeed() : int
      {
         return this.playSpeed;
      }
   }
}
