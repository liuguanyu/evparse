package com.letv.barrage.view
{
   import flash.display.Sprite;
   import com.letv.barrage.components.BarrageCanvas;
   import com.letv.barrage.components.BarrageInput;
   import flash.display.DisplayObject;
   import com.letv.barrage.components.image.ImageCanvas;
   import com.letv.barrage.BarrageEvent;
   import flash.geom.Rectangle;
   import com.letv.barrage.components.BaseComponent;
   import com.letv.barrage.Barrage;
   import flash.events.Event;
   import flash.display.StageScaleMode;
   import flash.display.StageAlign;
   
   public class View extends Object
   {
      
      private var main:Sprite;
      
      private var canvas:BarrageCanvas;
      
      private var input:BarrageInput;
      
      private var latestFrameRate:uint = 35;
      
      private var sp:DisplayObject;
      
      private var spArr:Array;
      
      private var delayTime:int;
      
      private var sendData:Object;
      
      private var imageCanvas:ImageCanvas;
      
      private var dragContainer:Sprite;
      
      public function View(param1:Sprite)
      {
         this.spArr = [];
         super();
         this.main = param1;
         this.initialize();
      }
      
      public function destroy() : void
      {
         if(this.canvas != null)
         {
            this.canvas.destroy();
         }
         if(this.imageCanvas != null)
         {
            this.imageCanvas.destroy();
         }
      }
      
      public function clearInput() : void
      {
         if(this.input != null)
         {
            this.input.clear();
         }
      }
      
      public function showInput() : void
      {
         if(this.input == null)
         {
            this.input = new BarrageInput(this.dragContainer);
         }
         this.input.addEventListener(BarrageEvent.SEND_MSG,this.onInput);
         this.input.addEventListener(BarrageEvent.INPUT_SET,this.onInput);
         this.input.addEventListener(BarrageEvent.IMAGE_STATE,this.onInput);
         this.main.addChild(this.input);
         this.input.resize();
         this.input.show();
      }
      
      public function hideInput() : void
      {
         if(this.input != null)
         {
            this.input.hide();
            this.input.removeEventListener(BarrageEvent.SEND_MSG,this.onInput);
            this.input.removeEventListener(BarrageEvent.INPUT_SET,this.onInput);
         }
      }
      
      public function set inputTip(param1:String) : void
      {
         if(this.input != null)
         {
            this.input.inputTip = param1;
         }
      }
      
      public function pause() : void
      {
         if(this.main.stage)
         {
            this.main.stage.frameRate = this.latestFrameRate;
         }
         if(this.canvas != null)
         {
            this.canvas.pause();
         }
         if(this.imageCanvas != null)
         {
            this.imageCanvas.pause();
         }
      }
      
      public function resume() : void
      {
         if(this.main.stage)
         {
            this.main.stage.frameRate = 60;
         }
         if(this.canvas != null)
         {
            this.canvas.resume();
         }
         if(this.imageCanvas != null)
         {
            this.imageCanvas.resume();
         }
      }
      
      public function set viewPort(param1:Rectangle) : void
      {
         if(param1 != null)
         {
            BaseComponent.rect = param1;
            this.appResize();
         }
      }
      
      public function append(param1:Object) : void
      {
         switch(param1.type)
         {
            case Barrage.TYPE_EM:
               this.imageCanvas.append(param1);
               break;
            case Barrage.TYPE_TXT:
               this.canvas.append(param1);
               break;
         }
      }
      
      private function initialize() : void
      {
         this.viewPort = new Rectangle(0,0,400,400);
         this.main.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.main.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         this.dragContainer = new Sprite();
         this.canvas = new BarrageCanvas();
         this.imageCanvas = new ImageCanvas();
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         this.main.stage.frameRate = 60;
         if(this.main.stage.scaleMode != StageScaleMode.NO_SCALE)
         {
            this.main.stage.align = StageAlign.TOP_LEFT;
            this.main.stage.scaleMode = StageScaleMode.NO_SCALE;
            this.main.stage.stageFocusRect = false;
         }
         if(this.input != null)
         {
            this.input.addEventListener(BarrageEvent.SEND_MSG,this.onInput);
            this.input.addEventListener(BarrageEvent.INPUT_SET,this.onInput);
            this.input.addEventListener(BarrageEvent.IMAGE_STATE,this.onInput);
         }
         this.main.addChild(this.imageCanvas);
         this.main.addChild(this.canvas);
         this.main.addChild(this.dragContainer);
         this.appResize();
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         this.main.stage.frameRate = this.latestFrameRate;
         if(this.input != null)
         {
            this.input.hide();
            this.input.removeEventListener(BarrageEvent.SEND_MSG,this.onInput);
            this.input.removeEventListener(BarrageEvent.INPUT_SET,this.onInput);
            this.input.removeEventListener(BarrageEvent.IMAGE_STATE,this.onInput);
         }
         this.canvas.destroy();
         this.imageCanvas.destroy();
         if(this.canvas.parent != null)
         {
            this.main.removeChild(this.canvas);
            this.main.removeChild(this.imageCanvas);
            this.main.removeChild(this.dragContainer);
         }
      }
      
      private function onInput(param1:BarrageEvent) : void
      {
         this.main.dispatchEvent(new BarrageEvent(param1.type,param1.dataProvider));
      }
      
      private function appResize() : void
      {
         if(this.canvas != null)
         {
            this.canvas.resize();
         }
         if(this.input != null)
         {
            this.input.resize();
         }
         if(this.imageCanvas != null)
         {
            this.imageCanvas.resize();
         }
      }
   }
}
