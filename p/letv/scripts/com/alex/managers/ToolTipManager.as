package com.alex.managers
{
   import com.alex.core.Container;
   import com.alex.surface.ISurface;
   import com.alex.surface.pc.ToolTipSurface;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import com.alex.controls.Label;
   import flash.display.MovieClip;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public final class ToolTipManager extends Container implements IToolTipManager
   {
      
      protected var _timeout:int;
      
      protected var _hoster:DisplayObject;
      
      protected var _stack:Vector.<Object>;
      
      protected var _gap:uint = 2;
      
      protected var _label:Label;
      
      protected var s:ToolTipSurface;
      
      protected var _maxWidth:uint = 400;
      
      protected var _maxHeight:uint = 400;
      
      public function ToolTipManager()
      {
         this._stack = new Vector.<Object>();
         super(new ToolTipSurface(new Framework_Default_Skin_ToolTip()));
      }
      
      override public function set surface(param1:ISurface) : void
      {
         clearparent();
         super.surface = param1;
         this.s = surface as ToolTipSurface;
         this.renderer();
      }
      
      public function regist(param1:DisplayObject, param2:String, param3:Boolean = false) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc4_:int = this._stack.length;
         var _loc5_:* = 0;
         while(_loc5_ < _loc4_)
         {
            if(this._stack[_loc5_].target == param1)
            {
               this._stack[_loc5_].tooltip = param2;
               this._stack[_loc5_].follow = param3;
               return;
            }
            _loc5_++;
         }
         param1.addEventListener(MouseEvent.MOUSE_OVER,this.onTooltipShow,false,0,true);
         param1.addEventListener(MouseEvent.MOUSE_OUT,this.onTooltipHide,false,0,true);
         this._stack.push({
            "target":param1,
            "tooltip":param2,
            "follow":param3
         });
      }
      
      public function remove(param1:DisplayObject) : void
      {
         var len:int = 0;
         var i:int = 0;
         var target:DisplayObject = param1;
         if(target == null)
         {
            return;
         }
         try
         {
            if(this._hoster == target)
            {
               visible = false;
            }
            target.removeEventListener(MouseEvent.MOUSE_MOVE,this.onTooltipMove);
            target.removeEventListener(MouseEvent.MOUSE_OVER,this.onTooltipShow);
            target.removeEventListener(MouseEvent.MOUSE_OUT,this.onTooltipHide);
            len = this._stack.length;
            i = 0;
            while(i < len)
            {
               if(this._stack[i].target == target)
               {
                  this._stack.splice(i,1);
                  break;
               }
               i++;
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public function getContent(param1:DisplayObject) : String
      {
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:int = this._stack.length;
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_)
         {
            if(this._stack[_loc3_].target == param1)
            {
               return this._stack[_loc3_].tooltip;
            }
            _loc3_++;
         }
         return null;
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         mouseEnabled = false;
      }
      
      override protected function renderer() : void
      {
         super.renderer();
         this.remove(this._hoster);
         this._label = new Label(this.s.label as MovieClip);
         this._label.wordWrap = true;
         mouseEnabled = false;
         mouseChildren = false;
         visible = false;
      }
      
      private function onTooltipShow(param1:MouseEvent) : void
      {
         var _loc3_:String = null;
         var _loc4_:* = false;
         visible = true;
         this.setDelay(false);
         if(param1.currentTarget == param1.target)
         {
            param1.stopPropagation();
            param1.stopImmediatePropagation();
         }
         var _loc2_:Object = param1.currentTarget;
         var _loc5_:* = 0;
         while(_loc5_ < this._stack.length)
         {
            if(this._stack[_loc5_].target == _loc2_)
            {
               _loc3_ = this._stack[_loc5_].tooltip;
               _loc4_ = this._stack[_loc5_].follow;
               break;
            }
            _loc5_++;
         }
         this._label.text = _loc3_;
         this._hoster = _loc2_ as DisplayObject;
         if(_loc4_)
         {
            visible = true;
            this.tooltipRender(application.mouseX,application.mouseY);
            _loc2_.addEventListener(MouseEvent.MOUSE_MOVE,this.onTooltipMove,false,0,true);
         }
         else
         {
            visible = false;
            this.setDelay(true);
         }
      }
      
      private function onTooltipHide(param1:MouseEvent) : void
      {
         this.setDelay(false);
         this._hoster = null;
         visible = false;
         param1.currentTarget.removeEventListener(MouseEvent.MOUSE_MOVE,this.onTooltipMove);
      }
      
      private function onTooltipMove(param1:MouseEvent) : void
      {
         if(param1.currentTarget == param1.target)
         {
            param1.stopPropagation();
            param1.stopImmediatePropagation();
         }
         this.tooltipRender(application.mouseX,application.mouseY);
      }
      
      private function tooltipRender(param1:Number, param2:Number) : void
      {
         this._label.x = this._gap;
         this._label.y = this._gap;
         var _loc3_:uint = applicationWidth - 4 * this._gap;
         this._label.width = _loc3_ > this._maxWidth?this._maxWidth:_loc3_;
         this.s.background.width = this._label.width + 4 * this._gap;
         if(param1 > applicationWidth * 0.5)
         {
            x = param1 - this.s.background.width;
         }
         else
         {
            x = param1;
         }
         var _loc4_:uint = applicationHeight - 2 * this._gap;
         this._label.height = _loc4_ > this._maxHeight?this._maxHeight:_loc4_;
         this.s.background.height = this._label.height + 2 * this._gap;
         if(param2 > applicationHeight * 0.5)
         {
            y = param2 - this.s.background.height;
         }
         else
         {
            y = param2;
         }
      }
      
      private function setDelay(param1:Boolean) : void
      {
         clearTimeout(this._timeout);
         if(param1)
         {
            this._timeout = setTimeout(this.onDelay,300);
         }
      }
      
      private function onDelay() : void
      {
         visible = true;
         this.tooltipRender(application.mouseX,application.mouseY);
      }
   }
}
