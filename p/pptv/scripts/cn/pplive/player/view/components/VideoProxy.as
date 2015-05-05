package cn.pplive.player.view.components
{
   import flash.events.EventDispatcher;
   import flash.media.Camera;
   import flash.media.Video;
   import flash.media.StageVideo;
   import flash.net.NetStream;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.events.VideoEvent;
   import flash.events.StageVideoEvent;
   import flash.events.Event;
   import cn.pplive.player.utils.PrintDebug;
   import flash.media.VideoStatus;
   import flash.utils.setTimeout;
   import cn.pplive.player.utils.hash.Global;
   
   public class VideoProxy extends EventDispatcher
   {
      
      protected var $camera:Camera;
      
      protected var $v:Video = null;
      
      protected var $sv:StageVideo = null;
      
      protected var $ns:NetStream;
      
      protected var $isSV:Boolean;
      
      protected var $con:Sprite;
      
      private var $isNS:Boolean = false;
      
      private var $svInUse:Boolean;
      
      private var $vInUse:Boolean;
      
      private var $hardwareEncoding:Boolean;
      
      private var $hardwareDecoding:Boolean;
      
      private var $available:Boolean;
      
      private var $w:Number = NaN;
      
      private var $h:Number = NaN;
      
      private var $ratio:Number = NaN;
      
      protected var $ow:Number = 0;
      
      protected var $oh:Number = 0;
      
      public function VideoProxy(param1:Sprite, param2:Boolean)
      {
         super();
         this.$con = param1;
         this.$isSV = param2;
      }
      
      public function attachNetStream(param1:NetStream = null) : void
      {
         this.$ns = param1;
         this.setup(this.$isNS?this.$available:this.$isSV);
      }
      
      public function clearStream() : void
      {
         try
         {
            if(this.$sv)
            {
               this.$sv.viewPort = new Rectangle(0,0,0,0);
               this.$sv.attachNetStream(null);
            }
            else if(this.$v)
            {
               this.$v.attachCamera(null);
               this.$v.attachNetStream(null);
               this.$v.clear();
            }
            
         }
         catch(evt:Error)
         {
         }
      }
      
      protected function setupVideo() : void
      {
         if(this.$svInUse)
         {
            this.$svInUse = false;
         }
         this.$vInUse = true;
         if(this.$v == null)
         {
            this.$v = new Video();
            this.$v.smoothing = true;
            this.$v.deblocking = 2;
            this.$v.addEventListener(VideoEvent.RENDER_STATE,this.onRenderStateHandler);
         }
         this.$con.addChild(this.$v);
         if(this.$camera)
         {
            this.$v.attachCamera(this.$camera);
         }
         if(this.$ns)
         {
            this.$v.attachNetStream(this.$ns);
         }
         if(this.$sv)
         {
            this.$sv.removeEventListener(StageVideoEvent.RENDER_STATE,this.onRenderStateHandler);
            this.$sv = null;
         }
      }
      
      protected function setupStageVideo() : void
      {
         this.$svInUse = true;
         if(this.$sv == null && this.$con.stage.stageVideos.length > 0)
         {
            this.$sv = this.$con.stage.stageVideos[0];
            this.$sv.addEventListener(StageVideoEvent.RENDER_STATE,this.onRenderStateHandler);
         }
         if(this.$ns)
         {
            this.$sv.attachNetStream(this.$ns);
         }
         if(this.$vInUse)
         {
            this.$vInUse = false;
            if(this.$v)
            {
               this.$v.removeEventListener(VideoEvent.RENDER_STATE,this.onRenderStateHandler);
               this.$con.removeChild(this.$v);
               this.$v = null;
            }
         }
      }
      
      public function get hardwareEncoding() : Boolean
      {
         return this.$hardwareEncoding;
      }
      
      public function get hardwareDecoding() : Boolean
      {
         return this.$hardwareDecoding;
      }
      
      private function onRenderStateHandler(param1:Event) : void
      {
         if(param1 is StageVideoEvent)
         {
            PrintDebug.Trace("当前 StageVideoEvent 视频渲染状态   =====>>>>>   ",(param1 as StageVideoEvent).status);
            this.$hardwareDecoding = (param1 as StageVideoEvent).status == VideoStatus.ACCELERATED;
            this.$hardwareEncoding = false;
         }
         else if(param1 is VideoEvent)
         {
            PrintDebug.Trace("当前 VideoEvent 视频渲染状态   =====>>>>>   ",(param1 as VideoEvent).status);
            this.$hardwareDecoding = (param1 as VideoEvent).status == VideoStatus.ACCELERATED;
            this.$hardwareEncoding = true;
         }
         
         dispatchEvent(new Event("_video_status_"));
      }
      
      public function get available() : Boolean
      {
         return this.$available;
      }
      
      public function setup(param1:Boolean) : void
      {
         var on:Boolean = param1;
         this.clearStream();
         this.$isNS = true;
         this.$available = on;
         if(on)
         {
            PrintDebug.Trace("可以采用 stageVideo 渲染视频 ......");
            this.setupStageVideo();
         }
         else
         {
            PrintDebug.Trace("目前采用 video 对象渲染 ......");
            this.setupVideo();
         }
         if(!isNaN(this.$w) && !isNaN(this.$h))
         {
            this.resize(this.$w,this.$h,this.$ratio);
         }
         setTimeout(function():void
         {
            dispatchEvent(new Event("_video_change_"));
         },0);
      }
      
      public function resize(param1:Number, param2:Number, param3:Number) : void
      {
         this.$w = param1;
         this.$h = param2;
         this.$ratio = param3;
         this.$con.graphics.clear();
         this.$con.graphics.beginFill(0,1);
         var _loc4_:Rectangle = this.getVideoRect(param1,param2,param3);
         if(this.$available)
         {
            this.$sv.viewPort = _loc4_;
            this.$con.graphics.moveTo(0,0);
            this.$con.graphics.lineTo(param1,0);
            this.$con.graphics.lineTo(param1,param2);
            this.$con.graphics.lineTo(0,param2);
            this.$con.graphics.lineTo(0,0);
            this.$con.graphics.lineTo(_loc4_.x,_loc4_.y);
            this.$con.graphics.lineTo(_loc4_.x + _loc4_.width,_loc4_.y);
            this.$con.graphics.lineTo(_loc4_.x + _loc4_.width,_loc4_.y + _loc4_.height);
            this.$con.graphics.lineTo(_loc4_.x,_loc4_.y + _loc4_.height);
            this.$con.graphics.lineTo(_loc4_.x,_loc4_.y);
            this.$con.graphics.beginFill(0,0);
            this.$con.graphics.moveTo(_loc4_.x,_loc4_.y);
            this.$con.graphics.lineTo(_loc4_.x + _loc4_.width,_loc4_.y);
            this.$con.graphics.lineTo(_loc4_.x + _loc4_.width,_loc4_.y + _loc4_.height);
            this.$con.graphics.lineTo(_loc4_.x,_loc4_.y + _loc4_.height);
            this.$con.graphics.lineTo(_loc4_.x,_loc4_.y);
         }
         else
         {
            this.$v.x = _loc4_.x;
            this.$v.y = _loc4_.y;
            this.$v.width = _loc4_.width;
            this.$v.height = _loc4_.height;
            this.$con.graphics.drawRect(0,0,param1,param2);
         }
         Global.getInstance()["rect"] = _loc4_;
         this.$con.graphics.endFill();
      }
      
      private function getVideoRect(param1:uint, param2:uint, param3:Number) : Rectangle
      {
         var _loc4_:uint = this.$ow;
         var _loc5_:uint = this.$oh;
         var _loc6_:Number = Math.min(param1 / _loc4_,param2 / _loc5_);
         _loc4_ = _loc4_ * _loc6_;
         _loc5_ = _loc5_ * _loc6_;
         if(!isNaN(param3))
         {
            _loc4_ = _loc4_ * param3;
            _loc5_ = _loc5_ * param3;
         }
         var _loc7_:uint = param1 - _loc4_ >> 1;
         var _loc8_:uint = param2 - _loc5_ >> 1;
         var _loc9_:Rectangle = new Rectangle(_loc7_,_loc8_,_loc4_,_loc5_);
         return _loc9_;
      }
      
      public function set camera(param1:Camera) : void
      {
         this.$camera = param1;
      }
      
      public function get v() : *
      {
         return this.$sv?this.$sv:this.$v;
      }
      
      public function get ow() : Number
      {
         return this.$ow;
      }
      
      public function set ow(param1:Number) : void
      {
         this.$ow = param1;
      }
      
      public function get oh() : Number
      {
         return this.$oh;
      }
      
      public function set oh(param1:Number) : void
      {
         this.$oh = param1;
      }
   }
}
