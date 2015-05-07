package com.letv.barrage.components.image
{
   import com.letv.barrage.components.BaseComponent;
   import flash.utils.Timer;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import com.letv.barrage.BarrageEvent;
   
   public class ImageCanvas extends BaseComponent
   {
      
      private var pausing:Boolean;
      
      public const IMAGE_NUM_MAX:uint = 15;
      
      private var _imageArr:Array;
      
      private var isPause:Boolean = false;
      
      private var _recycle:Object;
      
      private var _factory:Object;
      
      private var _timer:Timer;
      
      private var loadImage:LoadImage;
      
      public function ImageCanvas()
      {
         this._imageArr = [];
         this.loadImage = LoadImage.getinstance();
         super();
      }
      
      public function append(param1:Object) : Boolean
      {
         var _loc3_:MovieClip = null;
         if(param1 == null)
         {
            return false;
         }
         if(this._imageArr.length >= this.IMAGE_NUM_MAX)
         {
            _loc3_ = this._imageArr.splice(0,1)[0];
            if(_loc3_.parent)
            {
               _loc3_.parent.removeChild(_loc3_);
            }
         }
         var _loc2_:MovieClip = this.loadImage.getContent(param1.txt);
         if(_loc2_)
         {
            _loc2_.px = Math.max(0,Math.min(1,Number(param1.x)));
            _loc2_.py = Math.max(0,Math.min(1,Number(param1.y)));
            if(param1.sign == "user")
            {
               _loc2_.time = 10000;
            }
            else
            {
               _loc2_.time = 3000;
            }
            _loc2_.scaleX = _loc2_.scaleY = LoadImage.SCALERATE;
            this.resizeImage(_loc2_);
            addChild(_loc2_);
            this._imageArr.push(_loc2_);
            if(this._imageArr.length == 1 && !this.isPause)
            {
               this.resume();
            }
            return true;
         }
         return false;
      }
      
      private function timerHandler(param1:TimerEvent) : void
      {
         var _loc3_:MovieClip = null;
         var _loc2_:int = this._imageArr.length;
         while(_loc2_ > 0)
         {
            _loc2_--;
            _loc3_ = this._imageArr[_loc2_];
            _loc3_.time = _loc3_.time - 200;
            if(_loc3_.time < 0)
            {
               this._imageArr.splice(_loc2_,1);
               if(_loc3_.parent)
               {
                  _loc3_.parent.removeChild(_loc3_);
               }
            }
         }
      }
      
      public function pause() : void
      {
         this.isPause = true;
         if(this._timer)
         {
            this._timer.stop();
         }
      }
      
      public function resume() : void
      {
         this.isPause = false;
         if(!this._timer)
         {
            this._timer = new Timer(200);
            this._timer.addEventListener(TimerEvent.TIMER,this.timerHandler);
         }
         this._timer.start();
      }
      
      private function judgeImageType(param1:BarrageEvent) : void
      {
         var _loc2_:* = param1.currentTarget.content;
         if(_loc2_)
         {
            removeChild(_loc2_);
         }
      }
      
      private function resizeImage(param1:MovieClip) : void
      {
         param1.x = param1.px * applicationWidth;
         param1.y = param1.py * applicationHeight;
      }
      
      override public function resize() : void
      {
         var _loc3_:MovieClip = null;
         var _loc1_:int = this._imageArr.length;
         var _loc2_:* = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._imageArr[_loc2_] as MovieClip;
            this.resizeImage(_loc3_);
            _loc2_++;
         }
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      override public function destroy() : void
      {
         if(this._timer)
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
            this._timer = null;
         }
         while(this._imageArr.length)
         {
            this.removeChildAt(0);
            this._imageArr.shift();
         }
      }
   }
}
