package com.letv.plugins.kernel.media.http.m3u8
{
   import com.letv.plugins.kernel.media.BaseMedia;
   import com.letv.plugins.kernel.interfaces.IMedia;
   import com.letv.plugins.kernel.model.Model;
   import com.letv.plugins.kernel.media.PlayMode;
   import com.letv.plugins.kernel.Kernel;
   import com.alex.media.events.HTTPNetStreamingEvent;
   import com.letv.pluginsAPI.kernel.PlayerError;
   import com.letv.pluginsAPI.kernel.PlayerStateEvent;
   import com.alex.media.net.HTTPM3U8NetStreaming;
   import com.letv.plugins.kernel.components.VideoUI;
   import com.alex.media.net.BaseNetStreaming;
   
   public class HTTP_M3U8_VodMedia extends BaseMedia
   {
      
      private static var _instance:IMedia;
      
      private var stream:HTTPM3U8NetStreaming;
      
      private var playSpeed:int = 0;
      
      public function HTTP_M3U8_VodMedia()
      {
         super();
      }
      
      public static function getInstance() : IMedia
      {
         if(_instance == null)
         {
            _instance = new HTTP_M3U8_VodMedia();
         }
         return _instance;
      }
      
      override public function init(param1:Model, param2:Boolean = false) : void
      {
         var time:Number = NaN;
         var _model:Model = param1;
         var smooth:Boolean = param2;
         try
         {
            time = 0;
            if(!smooth)
            {
               time = super.initBase(_model,PlayMode.HTTP_M3U8_VOD);
               this.resetStream();
            }
            else
            {
               if(model.setting.setDefinitionRecordTime > 0)
               {
                  Kernel.sendLog(this + " Play Video ByDefinitionRecordTime " + model.setting.setDefinitionRecordTime);
                  model.setting.playStartType = "definition";
                  time = model.setting.setDefinitionRecordTime;
                  model.setting.setDefinitionRecordTime = 0;
               }
               this.stream.addEventListener(HTTPNetStreamingEvent.ALLOW_SMOOTH,this.allowSmoothHandler);
               this.stream.addEventListener(HTTPNetStreamingEvent.SWAP_COMPLETE,this.showDefinition);
            }
            this.stream.play(model.cdnlist,time,smooth,model.getDefinition());
         }
         catch(e:Error)
         {
            seekToFromError("HTTPDataFileError",PlayerError.PLAY_HTTP_TIMEOUT_ERROR,time);
         }
      }
      
      private function allowSmoothHandler(param1:HTTPNetStreamingEvent) : void
      {
         this.stream.removeEventListener(HTTPNetStreamingEvent.ALLOW_SMOOTH,this.allowSmoothHandler);
         if(!param1.dataProvider)
         {
            sendState(PlayerStateEvent.SWAP_DEFINITION_FAIL);
         }
      }
      
      private function showDefinition(param1:HTTPNetStreamingEvent) : void
      {
         if(param1.dataProvider.last)
         {
            this.stream.removeEventListener(HTTPNetStreamingEvent.SWAP_COMPLETE,this.showDefinition);
         }
         sendState(PlayerStateEvent.SWAP_COMPLETE,param1.dataProvider);
      }
      
      protected function resetStream() : void
      {
         this.destroyStream();
         if(this.stream == null)
         {
            this.stream = new HTTPM3U8NetStreaming();
         }
         this.stream.addEventListener(HTTPNetStreamingEvent.LOG,this.onHttpNetStreamingLog);
         this.stream.addEventListener(HTTPNetStreamingEvent.STATUS,this.onHttpNetStreamingStatus);
         VideoUI.attachNetStream(this.stream.stream);
         this.stream.autoplay = model.setting.autoPlay;
         this.setVolume(0);
      }
      
      protected function destroyStream() : void
      {
         if(this.stream != null)
         {
            this.stream.close();
            this.stream.removeEventListener(HTTPNetStreamingEvent.LOG,this.onHttpNetStreamingLog);
            this.stream.removeEventListener(HTTPNetStreamingEvent.STATUS,this.onHttpNetStreamingStatus);
            this.stream.removeEventListener(HTTPNetStreamingEvent.ALLOW_SMOOTH,this.allowSmoothHandler);
         }
      }
      
      protected function onHttpNetStreamingLog(param1:HTTPNetStreamingEvent) : void
      {
         Kernel.sendLog(param1.dataProvider + "",param1.status);
      }
      
      protected function onHttpNetStreamingStatus(param1:HTTPNetStreamingEvent) : void
      {
         switch(param1.status)
         {
            case BaseNetStreaming.VIDEO_ERROR:
            case BaseNetStreaming.FILE_READ_ERROR:
               if((model.cdnlist) && (model.cdnlist.length > 1) && !(this.stream == null))
               {
                  model.gslb.urlist.shift();
                  this.stream.play(model.cdnlist,this.getVideoTime());
               }
               else if(param1.status == BaseNetStreaming.VIDEO_ERROR)
               {
                  this.seekToFromError("HTTPDataFileError","48" + param1.errorCode,Number(param1.dataProvider));
               }
               else
               {
                  this.seekToFromError("HTTPDataFileError","49" + param1.errorCode,Number(param1.dataProvider));
               }
               
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
               this.playSpeed = param1.dataProvider as Number;
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
         super.onMeta(param1);
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
         Kernel.sendLog(this + " onBufferFull AutoPlay " + model.setting.autoPlay);
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
      
      private function playStop() : void
      {
         try
         {
            this.stream["pause"]();
         }
         catch(e:Error)
         {
         }
         var stopName:String = model.play.limitData.stopName;
         model.dispatchEvent(new PlayerStateEvent(PlayerStateEvent.CUT_PLAY_COMPLETE,model.play.limitData.stopName));
         super.watchStop(false);
         this.closeVideo();
      }
      
      override protected function watchStop(param1:Boolean = true) : void
      {
         if(this.stream != null)
         {
            this.stream.pause();
         }
         if((model.play.autoReplay) || (model.config.autoReplay))
         {
            watchStopAutoReplay();
            autoReplay();
         }
         else
         {
            super.watchStop();
         }
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
            Kernel.sendLog(this + " seekTo time: " + param1 + " duration: " + duration);
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
      
      override public function get streamValid() : Boolean
      {
         return !(this.stream == null);
      }
   }
}
