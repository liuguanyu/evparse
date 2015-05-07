package com.letv.barrage.components
{
   import com.letv.barrage.components.canvas.BarrageItemData;
   import com.letv.barrage.components.canvas.BarrageItemRenderer;
   import com.letv.barrage.components.canvas.BarrageLine;
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   
   public class BarrageCanvas extends BaseComponent
   {
      
      private var playStack:Vector.<BarrageLine>;
      
      private var bufferStack:Vector.<BarrageItemData>;
      
      private var bufferTimer:Timer;
      
      private var pausing:Boolean;
      
      public var LINE_NUM_MAX:uint = 6;
      
      public var LINE_HGAP:uint = 60;
      
      public var LINE_VGAP:uint = 20;
      
      public var BUFFER_MAX:uint = 5;
      
      public function BarrageCanvas()
      {
         super();
      }
      
      override public function resize() : void
      {
         if(applicationHeight <= 350)
         {
            this.LINE_VGAP = 1;
         }
         else if(applicationHeight <= 370)
         {
            this.LINE_VGAP = 5;
         }
         else if(applicationHeight <= 400)
         {
            this.LINE_VGAP = 10;
         }
         else if(applicationHeight <= 450)
         {
            this.LINE_VGAP = 15;
         }
         else
         {
            this.LINE_VGAP = 20;
         }
         
         
         
         var _loc1_:* = 0;
         while(_loc1_ < this.LINE_NUM_MAX)
         {
            this.playStack[_loc1_].width = applicationWidth;
            if(this.playStack[_loc1_].height > 0)
            {
               this.playStack[_loc1_].y = this.LINE_VGAP + _loc1_ * (this.playStack[_loc1_].height + this.LINE_VGAP);
            }
            _loc1_++;
         }
      }
      
      override public function destroy() : void
      {
         var _loc1_:* = 0;
         while(_loc1_ < this.LINE_NUM_MAX)
         {
            this.playStack[_loc1_].destroy();
            _loc1_++;
         }
      }
      
      public function pause() : void
      {
         this.pausing = true;
         this.setBufferTimer(false);
         var _loc1_:* = 0;
         while(_loc1_ < this.LINE_NUM_MAX)
         {
            this.playStack[_loc1_].pause();
            _loc1_++;
         }
      }
      
      public function resume() : void
      {
         this.pausing = false;
         var _loc1_:* = 0;
         while(_loc1_ < this.LINE_NUM_MAX)
         {
            this.playStack[_loc1_].resume();
            _loc1_++;
         }
         if(this.bufferStack.length > 0)
         {
            this.setBufferTimer(true);
         }
      }
      
      public function append(param1:Object) : Boolean
      {
         var _loc2_:BarrageItemData = null;
         var _loc3_:* = false;
         var _loc7_:* = NaN;
         var _loc8_:BarrageItemRenderer = null;
         if(param1 == null)
         {
            return false;
         }
         if(param1 is BarrageItemData)
         {
            _loc3_ = true;
            _loc2_ = param1 as BarrageItemData;
         }
         else
         {
            _loc2_ = new BarrageItemData(param1);
         }
         var _loc4_:* = -1;
         var _loc5_:Array = [];
         var _loc6_:* = 0;
         while(_loc6_ < this.LINE_NUM_MAX)
         {
            if(this.playStack[_loc6_].sum + this.LINE_HGAP < applicationWidth)
            {
               _loc5_.push(_loc6_);
            }
            _loc6_++;
         }
         if(_loc5_.length > 0)
         {
            _loc4_ = _loc5_[0];
            _loc7_ = this.playStack[_loc4_].sum;
            while(_loc5_.length > 0)
            {
               if(this.playStack[_loc5_[0]].sum < _loc7_)
               {
                  _loc7_ = this.playStack[_loc5_[0]].sum;
                  _loc4_ = _loc5_.shift();
               }
               else
               {
                  _loc5_.shift();
               }
            }
         }
         if(_loc4_ >= 0 && !this.pausing)
         {
            _loc8_ = this.playStack[_loc4_].append(_loc2_);
            _loc8_.y = this.LINE_VGAP + _loc4_ * (_loc8_.height + this.LINE_VGAP);
            addChild(_loc8_);
            return true;
         }
         if(!_loc3_)
         {
            if(this.bufferStack.length >= this.BUFFER_MAX)
            {
               this.bufferStack.shift();
            }
            this.bufferStack.push(_loc2_);
            if((this.bufferTimer == null || !this.bufferTimer.running) && !this.pausing)
            {
               this.setBufferTimer(true);
            }
         }
         return false;
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         mouseEnabled = false;
         mouseChildren = false;
         this.playStack = new Vector.<BarrageLine>();
         this.bufferStack = new Vector.<BarrageItemData>();
         var _loc1_:* = 0;
         while(_loc1_ < this.LINE_NUM_MAX)
         {
            this.playStack.push(new BarrageLine(this.LINE_VGAP,this.LINE_HGAP,_loc1_));
            _loc1_++;
         }
      }
      
      private function setBufferTimer(param1:Boolean) : void
      {
         if(param1)
         {
            if(this.bufferTimer == null)
            {
               this.bufferTimer = new Timer(200);
            }
            this.bufferTimer.addEventListener(TimerEvent.TIMER,this.onBufferTimer);
            this.bufferTimer.start();
         }
         else if(this.bufferTimer != null)
         {
            this.bufferTimer.stop();
            this.bufferTimer.removeEventListener(TimerEvent.TIMER,this.onBufferTimer);
         }
         
      }
      
      private function onBufferTimer(param1:TimerEvent) : void
      {
         if(this.bufferStack.length > 0)
         {
            if(this.append(this.bufferStack[0]))
            {
               this.bufferStack.shift();
            }
            if(this.bufferStack.length == 0)
            {
               this.setBufferTimer(false);
            }
         }
      }
   }
}
