package com.alex.controls
{
   import com.alex.core.UIComponent;
   import com.alex.surface.ISurface;
   import com.alex.error.SkinError;
   import com.alex.surface.pc.LabelSurface;
   import flash.text.TextFormat;
   import flash.text.TextFieldAutoSize;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.display.MovieClip;
   
   public class Label extends UIComponent
   {
      
      private static const ASSIST:String = "...";
      
      protected var _autoSize:String;
      
      protected var s:LabelSurface;
      
      protected var content:String = "label";
      
      protected var _wordWrap:Boolean = false;
      
      protected var _width:Number = 0;
      
      protected var _height:Number = 0;
      
      protected var _tooltipEnabled:Boolean;
      
      public function Label(param1:MovieClip = null)
      {
         if(param1 == null)
         {
            var param1:MovieClip = new Framework_Default_Skin_Label();
         }
         super(new LabelSurface(param1));
      }
      
      override public function destroy() : void
      {
         this.s = null;
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
            this.s = surface as LabelSurface;
            this.renderer();
            return;
         }
      }
      
      public function appendText(param1:String) : void
      {
         this.s.label.appendText(param1);
         this.update();
      }
      
      public function setTextFormat(param1:TextFormat, param2:int = -1, param3:int = -1) : void
      {
         this.s.label.setTextFormat(param1,param2,param3);
         this.update();
      }
      
      public function set defaultTextFormat(param1:TextFormat) : void
      {
         this.s.label.defaultTextFormat = param1;
         this.update();
      }
      
      public function set autoSize(param1:String) : void
      {
         this.s.label.autoSize = this._autoSize = param1;
      }
      
      public function get autoSize() : String
      {
         return this._autoSize || TextFieldAutoSize.LEFT;
      }
      
      public function set text(param1:String) : void
      {
         this.content = param1;
         this.width = this._width;
         this.height = this._height;
      }
      
      public function get text() : String
      {
         return this.content;
      }
      
      public function set wordWrap(param1:Boolean) : void
      {
         this._wordWrap = param1;
         if((this._wordWrap) && this._width <= 0)
         {
            this._width = 150;
         }
         this.width = this._width;
         this.height = this._height;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get wordWrap() : Boolean
      {
         return this._wordWrap;
      }
      
      public function set selectable(param1:Boolean) : void
      {
         this.s.label.selectable = param1;
      }
      
      public function get selectable() : Boolean
      {
         return this.s.label.selectable;
      }
      
      public function set tooltipEnabled(param1:Boolean) : void
      {
         this._tooltipEnabled = param1;
         this.update();
      }
      
      public function get tooltipEnabled() : Boolean
      {
         return this._tooltipEnabled;
      }
      
      override public function set width(param1:Number) : void
      {
         this._width = param1;
         this.update();
      }
      
      override public function set height(param1:Number) : void
      {
         this._height = param1;
         this.update();
      }
      
      override protected function renderer() : void
      {
         super.renderer();
         this.s.label.x = this.s.label.y = 0;
         this.update();
      }
      
      protected function update() : void
      {
         var _loc2_:Rectangle = null;
         var _loc5_:* = 0;
         var _loc1_:String = this.autoSize;
         this.s.label.wordWrap = false;
         if(!(this.content == null) && !(this.content == ""))
         {
            this.s.label.text = this.content;
            this.s.label.x = 0;
            this.s.label.autoSize = _loc1_;
            var _loc3_:* = false;
            var _loc4_:int = this.s.label.text.length - 1;
            if(this.wordWrap)
            {
               if(this._width > 0 && this.s.label.width > this._width)
               {
                  this.s.label.wordWrap = true;
                  this.s.label.width = this._width;
                  this.s.label.height = this.s.label.textHeight;
                  this.s.label.autoSize = _loc1_;
                  if(this._height > 0)
                  {
                     _loc2_ = this.s.label.getCharBoundaries(_loc4_);
                     while(!(_loc2_ == null) && _loc2_.y + _loc2_.height > this._height)
                     {
                        _loc4_--;
                        if(!_loc3_)
                        {
                           _loc3_ = true;
                        }
                        if(_loc4_ < 0)
                        {
                           break;
                        }
                        _loc2_ = this.s.label.getCharBoundaries(_loc4_);
                     }
                  }
               }
            }
            else if(this._width > 0)
            {
               this.s.label.height = this.s.label.textHeight;
               _loc5_ = 0;
               while(_loc5_ <= _loc4_)
               {
                  if(this.s.label.getLineIndexOfChar(_loc5_) == 0)
                  {
                     _loc2_ = this.s.label.getCharBoundaries(_loc5_);
                     if(_loc2_ == null)
                     {
                        break;
                     }
                     if(_loc2_.x + _loc2_.width > this._width)
                     {
                        _loc3_ = true;
                        break;
                     }
                     _loc5_++;
                     continue;
                  }
                  break;
               }
               _loc4_ = _loc5_;
            }
            
            if(_loc3_)
            {
               if(_loc4_ <= 0)
               {
                  this.s.label.text = "";
               }
               else if(_loc4_ + 1 > ASSIST.length)
               {
                  this.s.label.text = this.content.substr(0,_loc4_ + 1 - ASSIST.length) + ASSIST;
               }
               else
               {
                  this.s.label.text = this.content.substr(0,_loc4_ + 1);
               }
               
               if(this.s.label.numLines == 1)
               {
                  this.s.label.wordWrap = false;
               }
               this.s.label.autoSize = _loc1_;
               if((this.tooltipEnabled) && tooltip == null)
               {
                  this.tooltip = this.content;
               }
            }
            else if((this.tooltipEnabled) && !(tooltip == null))
            {
               this.tooltip = null;
            }
            
            if(_loc1_ == TextFieldAutoSize.RIGHT)
            {
               this.s.label.x = this._width - this.s.label.width;
            }
            return;
         }
         this.s.label.text = "";
         this.s.label.autoSize = _loc1_;
      }
   }
}
