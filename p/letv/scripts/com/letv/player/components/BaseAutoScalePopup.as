package com.letv.player.components
{
   import flash.display.MovieClip;
   
   public class BaseAutoScalePopup extends BaseConfigComponent
   {
      
      protected var marginLeft:Number = 0;
      
      protected var marginTop:Number = 0;
      
      protected var _opening:Boolean;
      
      protected var originalWidth:uint = 100;
      
      protected var originalHeight:uint = 100;
      
      public function BaseAutoScalePopup(param1:Object = null)
      {
         super(param1 as MovieClip);
      }
      
      override public function get applicationHeight() : Number
      {
         return super.applicationHeight;
      }
      
      public function resize(param1:Boolean = false) : void
      {
      }
      
      public function get opening() : Boolean
      {
         return this._opening;
      }
      
      public function display(param1:Object = null) : void
      {
         if(this.opening)
         {
            this.hide();
         }
         else
         {
            this.show(param1);
         }
      }
      
      public function show(param1:Object = null) : void
      {
         this._opening = true;
         visible = true;
         this.resize(true);
      }
      
      public function hide(param1:Object = true) : void
      {
         this._opening = false;
         visible = false;
      }
      
      public function backDefault() : void
      {
      }
      
      public function autoResize(param1:Number = 0) : void
      {
         var _loc2_:Object = null;
         if(stage != null)
         {
            _loc2_ = this.getAutoRect(param1);
            if(_loc2_ != null)
            {
               this.scaleX = _loc2_["changeScale"];
               this.scaleY = _loc2_["changeScale"];
               this.x = _loc2_["x"];
               this.y = _loc2_["y"];
            }
         }
      }
      
      protected function getAutoRect(param1:Number = 0) : Object
      {
         var _loc2_:* = NaN;
         var _loc3_:* = NaN;
         var _loc4_:* = NaN;
         var _loc5_:Object = null;
         if(stage != null)
         {
            _loc2_ = this.originalWidth / this.originalHeight;
            _loc3_ = applicationWidth / this.applicationHeight;
            _loc4_ = 1;
            if(param1 > 0)
            {
               _loc4_ = param1;
            }
            else if(applicationWidth < this.originalWidth || this.applicationHeight < this.originalHeight)
            {
               if(_loc2_ > _loc3_)
               {
                  _loc4_ = applicationWidth / this.originalWidth;
               }
               else
               {
                  _loc4_ = this.applicationHeight / this.originalHeight;
               }
            }
            
            _loc5_ = {"changeScale":_loc4_};
            _loc5_["x"] = int((applicationWidth - this.originalWidth * _loc4_) * 0.5 + this.marginLeft * _loc4_);
            _loc5_["y"] = int((this.applicationHeight - this.originalHeight * _loc4_) * 0.5 + this.marginTop * _loc4_);
            return _loc5_;
         }
         return null;
      }
      
      protected function get actionDuration() : Number
      {
         return 0.3;
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         if(skin.back != null)
         {
            this.originalWidth = skin.back.width;
            this.originalHeight = skin.back.height;
         }
         else
         {
            this.originalWidth = width;
            this.originalHeight = height;
         }
      }
   }
}
