package com.alex.controls
{
   import com.alex.core.UIComponent;
   import com.greensock.TweenLite;
   import com.alex.surface.ISurface;
   import com.alex.error.SkinError;
   import com.alex.surface.pc.ListSurface;
   import com.alex.core.ICellRenderer;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class VList extends UIComponent
   {
      
      protected var _width:Number = 200;
      
      protected var _height:Number = 200;
      
      protected var _containerHeight:Number = 0;
      
      protected var _gap:int = 0;
      
      protected var _sliderFlag:Boolean = true;
      
      protected var dragbar:VDragBar;
      
      protected var stack:Vector.<ICellRenderer>;
      
      protected var _visualBack:Shape;
      
      protected var s:ListSurface;
      
      protected var _overflow:Boolean = true;
      
      public function VList(param1:MovieClip = null, param2:Boolean = true, param3:uint = 0)
      {
         if(param1 == null)
         {
            var param1:MovieClip = new Framework_Default_Skin_VList();
         }
         this._gap = param3;
         this._sliderFlag = param2;
         super(new ListSurface(param1));
      }
      
      override public function destroy() : void
      {
         this.removeListener();
         if(this.s != null)
         {
            this.removeAll();
            TweenLite.killTweensOf(this.s.container);
            if(this.dragbar != null)
            {
               this.dragbar.destroy();
               this.dragbar = null;
            }
            this.s = null;
         }
         super.destroy();
      }
      
      override public function set surface(param1:ISurface) : void
      {
         if(this.s != null)
         {
            throw new SkinError("该组件不支持动态修改皮肤",SkinError.SKIN_SET_ERROR);
         }
         else
         {
            super.surface = param1;
            this.s = surface as ListSurface;
            this.renderer();
            return;
         }
      }
      
      override public function set width(param1:Number) : void
      {
         this._width = param1;
         this._visualBack.width = param1;
         this.s.masker.width = param1;
         this.dragbar.x = this.s.masker.width - this.dragbar.width;
         this.update();
      }
      
      override public function get width() : Number
      {
         return this._width;
      }
      
      override public function set height(param1:Number) : void
      {
         this._height = param1;
         this._visualBack.height = param1;
         this.s.masker.height = param1;
         this.dragbar.height = param1;
         this.update();
      }
      
      override public function get height() : Number
      {
         return this._height;
      }
      
      public function set gap(param1:uint) : void
      {
         this._gap = param1;
      }
      
      public function get gap() : uint
      {
         return this._gap;
      }
      
      public function set dataProvider(param1:Vector.<ICellRenderer>) : void
      {
         var _loc2_:* = 0;
         this.removeAll();
         this.s.container.x = 0;
         this.s.container.y = 0;
         if(!(param1 == null) && param1.length > 0)
         {
            this.stack = new Vector.<ICellRenderer>();
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               if(param1[_loc2_] != null)
               {
                  this.stack.push(param1[_loc2_]);
               }
               _loc2_++;
            }
         }
         this.update();
      }
      
      public function set displayIndex(param1:uint) : void
      {
         var _loc2_:* = NaN;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         if(param1 < 0)
         {
            var param1:uint = 0;
         }
         if(!(this.stack == null) && this.stack.length > 0 && param1 < this.stack.length)
         {
            if(this.containerHeight <= this.s.masker.height)
            {
               return;
            }
            TweenLite.killTweensOf(this.s.container);
            _loc2_ = 0;
            _loc3_ = this.stack.length;
            _loc4_ = 0;
            while(_loc4_ < this.stack.length)
            {
               if(_loc4_ == param1)
               {
                  break;
               }
               if(_loc4_ == _loc3_ - 1)
               {
                  _loc2_ = _loc2_ + this.stack[_loc4_].height;
               }
               else
               {
                  _loc2_ = _loc2_ + (this.stack[_loc4_].height + this.gap);
               }
               _loc4_++;
            }
            if(this.containerHeight - _loc2_ <= this.s.masker.height)
            {
               this.s.container.y = this.s.masker.height - this.containerHeight;
            }
            else
            {
               this.s.container.y = -_loc2_;
            }
            this.dragbar.percent = (this.s.masker.y - this.s.container.y) / (this.containerHeight - this.s.masker.height);
         }
      }
      
      public function update() : void
      {
         this.addItem(null);
      }
      
      public function addItem(param1:ICellRenderer) : void
      {
         var _loc4_:* = NaN;
         if(this.stack == null)
         {
            this.stack = new Vector.<ICellRenderer>();
         }
         if(param1 != null)
         {
            this.stack.push(param1);
         }
         var _loc2_:Number = this.dragbar.percent;
         var _loc3_:Number = this.containerHeight;
         this.sortFIFO();
         if(this.dragbar.visible)
         {
            if(_loc2_ > 0 && _loc2_ >= 0.6)
            {
               this.dragbar.percent = 1;
            }
            else
            {
               this.dragbar.percent = (this.s.masker.y - _loc3_) / (this.containerHeight - this.s.masker.height);
            }
            _loc4_ = this.s.masker.y - this.dragbar.percent * (this.containerHeight - this.s.masker.height);
            TweenLite.to(this.s.container,0.2,{"y":_loc4_});
         }
         else
         {
            TweenLite.killTweensOf(this.s.container);
            this.s.container.y = 0;
         }
      }
      
      public function removeItemAt(param1:int) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = NaN;
         var _loc4_:* = 0;
         if(this.stack[param1] != null)
         {
            this.s.container.removeChild(this.stack[param1].skin);
            this.stack[param1].destroy();
            this.stack.splice(param1,1);
            _loc2_ = this.stack.length;
            _loc3_ = 0;
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               this.stack[_loc4_].y = _loc3_;
               _loc3_ = _loc3_ + this.stack[_loc4_].height;
               _loc4_++;
            }
         }
         if(this.dragbar.visible)
         {
            if(this.containerHeight <= this.s.masker.height)
            {
               this.s.container.y = 0;
            }
            else
            {
               this.s.container.y = this.containerHeight - this.s.masker.height;
            }
         }
         this.update();
         this.updateDragbarPercent();
      }
      
      public function get overflow() : Boolean
      {
         return this._overflow;
      }
      
      public function set overflow(param1:Boolean) : void
      {
         this._overflow = param1;
         this.updateDragbarPercent();
      }
      
      override protected function renderer() : void
      {
         super.renderer();
         this.s.container.mask = this.s.masker;
         this.dragbar = new VDragBar(this.s.dragBar as MovieClip,this._sliderFlag);
         this.dragbar.visible = false;
         this._visualBack = new Shape();
         this._visualBack.graphics.beginFill(65280,0);
         this._visualBack.graphics.drawRect(0,0,100,100);
         this._visualBack.graphics.endFill();
         skin.addChild(this._visualBack);
         this.addListener();
         this.width = this._width;
         this.height = this._height;
         this.update();
      }
      
      protected function removeAll() : void
      {
         this.dragbar.visible = false;
         if(this.stack != null)
         {
            while(this.stack.length > 0)
            {
               if(this.stack[0] != null)
               {
                  this.stack[0].destroy();
                  this.stack[0] = null;
               }
               this.stack.shift();
            }
            this.stack = null;
         }
         this.dragbar.percent = 0;
         this.s.container.y = 0;
      }
      
      protected function get containerHeight() : Number
      {
         return this._containerHeight;
      }
      
      private function addListener() : void
      {
         this.dragbar.addEventListener(Event.CHANGE,this.onDragbarChange);
      }
      
      private function removeListener() : void
      {
         this.dragbar.removeEventListener(Event.CHANGE,this.onDragbarChange);
         removeEventListener(MouseEvent.MOUSE_WHEEL,this.onWheel);
      }
      
      private function onWheel(param1:MouseEvent) : void
      {
         var _loc5_:* = NaN;
         if(!this._overflow)
         {
            return;
         }
         var _loc2_:Number = this.dragbar.percent;
         var _loc3_:uint = 20;
         var _loc4_:Number = 0;
         if(param1.delta > 0)
         {
            _loc4_ = this.s.masker.y - this.s.container.y;
            if(_loc4_ < _loc3_)
            {
               this.s.container.y = this.s.masker.y;
            }
            else
            {
               this.s.container.y = this.s.container.y + _loc3_;
            }
         }
         else
         {
            _loc5_ = this.s.masker.height - this.containerHeight;
            _loc4_ = this.s.container.y - _loc5_;
            if(_loc4_ < _loc3_)
            {
               this.s.container.y = _loc5_;
            }
            else
            {
               this.s.container.y = this.s.container.y - _loc3_;
            }
         }
         this.dragbar.percent = (this.s.masker.y - this.s.container.y) / (this.containerHeight - this.s.masker.height);
         param1.stopPropagation();
         param1.stopImmediatePropagation();
      }
      
      private function onDragbarChange(param1:Event) : void
      {
         this.updateContainerPosition();
      }
      
      private function updateContainerPosition() : void
      {
         this.s.container.y = this.s.masker.y - this.dragbar.percent * (this.containerHeight - this.s.masker.height);
      }
      
      private function updateDragbarPercent() : void
      {
         if(this.containerHeight > this.s.masker.height)
         {
            this.dragbar.visible = this._overflow;
            this.dragbar.sliderPercent = 1 / ((this.containerHeight - this.s.masker.height) / this.s.masker.height + 1);
            this.dragbar.percent = (this.s.masker.y - this.s.container.y) / (this.containerHeight - this.s.masker.height);
            addEventListener(MouseEvent.MOUSE_WHEEL,this.onWheel);
         }
         else
         {
            this.dragbar.visible = false;
            this.s.container.y = 0;
            removeEventListener(MouseEvent.MOUSE_WHEEL,this.onWheel);
         }
      }
      
      private function sortFIFO() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         if(this.stack != null)
         {
            _loc1_ = this.stack.length;
            _loc2_ = 0;
            while(_loc3_ < _loc1_)
            {
               if(this.stack[_loc3_] != null)
               {
                  this.stack[_loc3_].x = 0;
                  this.stack[_loc3_].y = _loc2_;
                  this.s.container.addChild(this.stack[_loc3_].skin);
                  if(_loc3_ == _loc1_ - 1)
                  {
                     _loc2_ = _loc2_ + this.stack[_loc3_].height;
                  }
                  else
                  {
                     _loc2_ = _loc2_ + (this.stack[_loc3_].height + this.gap);
                  }
                  this.stack[_loc3_].setSize(this.dragbar.visible?this.s.masker.width - this.dragbar.width:this.s.masker.width,0);
               }
               _loc3_++;
            }
            this._containerHeight = _loc2_;
         }
         this.updateDragbarPercent();
      }
      
      private function sortFILO() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = NaN;
         var _loc3_:* = 0;
         if(this.stack != null)
         {
            _loc1_ = this.stack.length;
            _loc2_ = 0;
            _loc3_ = _loc1_ - 1;
            while(_loc3_ >= 0)
            {
               this.stack[_loc3_].x = 0;
               this.stack[_loc3_].y = _loc2_;
               this.s.container.addChild(this.stack[_loc3_].skin);
               if(_loc3_ == 0)
               {
                  _loc2_ = _loc2_ + this.stack[_loc3_].height;
               }
               else
               {
                  _loc2_ = _loc2_ + (this.stack[_loc3_].height + this.gap);
               }
               this.stack[_loc3_].setSize(this.dragbar.visible?this.s.masker.width - this.dragbar.width:this.s.masker.width,0);
               _loc3_--;
            }
            this._containerHeight = _loc2_;
         }
         this.updateDragbarPercent();
      }
      
      override protected function get stageChanged() : Boolean
      {
         return true;
      }
      
      override protected function onAddedToStage(param1:Event = null) : void
      {
         super.onAddedToStage(param1);
      }
      
      override protected function onRemovedFromStage(param1:Event = null) : void
      {
         super.onRemovedFromStage(param1);
         removeEventListener(MouseEvent.MOUSE_WHEEL,this.onWheel);
      }
   }
}
