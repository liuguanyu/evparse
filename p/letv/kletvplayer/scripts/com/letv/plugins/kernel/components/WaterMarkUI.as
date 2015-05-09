package com.letv.plugins.kernel.components
{
   import flash.display.Sprite;
   import com.letv.plugins.kernel.controller.Controller;
   import flash.display.Loader;
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   import com.alex.rpc.AutoLoader;
   import com.alex.rpc.events.AutoLoaderEvent;
   import com.alex.rpc.type.ResourceType;
   
   public class WaterMarkUI extends Sprite
   {
      
      private var _controller:Controller;
      
      private var _main:Sprite;
      
      private var _image:Loader;
      
      private var _data:Array;
      
      private var _startTime:Number;
      
      private var _currentStopTime:Number;
      
      private var _totalTime:Number;
      
      private var _lastTimeArr:Array;
      
      private var _timer:Timer;
      
      private var _index:int = 0;
      
      private var _imageWidth:Number;
      
      private var _imageHeight:Number;
      
      private var _imagePool:Object;
      
      public function WaterMarkUI(param1:Controller)
      {
         this._imagePool = {};
         super();
         this.mouseChildren = false;
         this.mouseEnabled = false;
         this.visible = false;
         this._controller = param1;
         this._image = new Loader();
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.timerHandler);
      }
      
      public function start(param1:Number, param2:Array, param3:Sprite) : void
      {
         this._timer.stop();
         this._index = 0;
         this._totalTime = 0;
         this._lastTimeArr = [0];
         this._main = param3;
         this._startTime = param1;
         this._data = param2;
         var _loc4_:* = 0;
         while(_loc4_ < param2.length)
         {
            this._totalTime = this._totalTime + int(param2[_loc4_].lasttime);
            this._lastTimeArr.push(this._totalTime);
            _loc4_++;
         }
         if(this._data.length > 0)
         {
            this._lastTimeArr.push(this._totalTime + param2[0].lasttime);
            this.showMark();
            this._timer.start();
         }
         else
         {
            this.stop();
         }
      }
      
      public function stop() : void
      {
         this._timer.stop();
         this.visible = false;
      }
      
      private function timerHandler(param1:TimerEvent) : void
      {
         var _loc3_:* = 0;
         var _loc2_:Number = this._controller.getVideoTime() - this._startTime;
         if(this._lastTimeArr[this._index] <= _loc2_ && _loc2_ <= this._lastTimeArr[this._index + 1])
         {
            return;
         }
         if(this._lastTimeArr[this._index + 1] < _loc2_ && _loc2_ < this._lastTimeArr[this._index + 2])
         {
            this._index++;
            if(this._index == this._lastTimeArr.length - 2)
            {
               this._index = 0;
               this._startTime = this._startTime + this._totalTime;
            }
         }
         else
         {
            _loc3_ = this.getIndex(_loc2_);
            if(_loc3_ == this._index)
            {
               return;
            }
            this._index = _loc3_;
            this._startTime = this._startTime + int(_loc2_ / this._totalTime) * this._totalTime;
         }
         this.showMark();
      }
      
      private function getIndex(param1:Number) : int
      {
         var _loc3_:* = 0;
         var _loc2_:Number = param1 % this._totalTime;
         _loc2_ = _loc2_ < 0?this._totalTime + _loc2_:_loc2_;
         while(_loc3_ < this._data.length)
         {
            if(_loc2_ > this._data[_loc3_].lasttime)
            {
               _loc2_ = _loc2_ - this._data[_loc3_].lasttime;
               _loc3_++;
               continue;
            }
            break;
         }
         return _loc3_;
      }
      
      private function showMark() : void
      {
         var url:String = this._data[this._index].url100;
         try
         {
            this.removeChild(this._image);
         }
         catch(e:Error)
         {
         }
         if(url == null || url == "")
         {
            return;
         }
         if(this._imagePool[url] != null)
         {
            this._image = this._imagePool[url];
            this.setImageData();
            return;
         }
         var al:AutoLoader = new AutoLoader();
         al.addEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onLoadComplete);
         al.setup([{
            "url":url,
            "type":ResourceType.LOADER,
            "checkPolicy":true
         }]);
      }
      
      public function resize(param1:Sprite = null) : Boolean
      {
         if(param1 != null)
         {
            this._main = param1;
         }
         if(this._main.stage.stageWidth < 200)
         {
            this.visible = false;
            return false;
         }
         this.setRect();
         this.setPosition();
         return true;
      }
      
      private function setRect() : void
      {
         if(this._main.stage.stageHeight > 480)
         {
            this._image.height = this._main.stage.stageHeight / 24;
         }
         else
         {
            this._image.height = this._main.stage.stageHeight / 18;
         }
         this._image.width = this._image.height / this._imageHeight * this._imageWidth;
         this.visible = true;
      }
      
      private function setPosition() : void
      {
         if(this._data == null)
         {
            return;
         }
         switch(this._data[this._index].position)
         {
            case "1":
               this._image.x = this._main.stage.stageWidth * 0.03;
               this._image.y = this._main.stage.stageHeight * 0.03;
               break;
            case "2":
               this._image.x = this._main.stage.stageWidth * 0.97 - this._image.width;
               this._image.y = this._main.stage.stageHeight * 0.03;
               break;
            case "3":
               this._image.x = this._main.stage.stageWidth * 0.03;
               this._image.y = this._main.stage.stageHeight * 0.97 - this._image.height;
               break;
            case "4":
               this._image.x = this._main.stage.stageWidth * 0.97 - this._image.width;
               this._image.y = this._main.stage.stageHeight * 0.97 - this._image.height;
               break;
         }
         addChild(this._image);
      }
      
      private function onLoadComplete(param1:AutoLoaderEvent) : void
      {
         var event:AutoLoaderEvent = param1;
         var al:AutoLoader = event.currentTarget as AutoLoader;
         al.removeEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onLoadComplete);
         try
         {
            this._image = event.dataProvider.content as Loader;
            this._imagePool[event.dataProvider.url] = this._image;
            this.setImageData();
            this._image.content["smoothing"] = true;
         }
         catch(e:Error)
         {
         }
      }
      
      private function setImageData() : void
      {
         this._imageWidth = this._image.width;
         this._imageHeight = this._image.height;
         this.resize();
      }
   }
}
