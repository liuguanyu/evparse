package com.letv.player.components
{
   import com.greensock.TweenLite;
   
   public class BaseCenterDisplayPopup extends BaseAutoScalePopup
   {
      
      public function BaseCenterDisplayPopup(param1:Object = null)
      {
         super(param1);
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this.visible = false;
         if(skin.closeBtn != null)
         {
            skin.closeBtn.x = originalWidth - skin.closeBtn.width * 0.5;
            skin.closeBtn.y = -skin.closeBtn.height * 0.5;
            originalWidth = originalWidth + skin.closeBtn.width * 0.5;
            originalHeight = originalHeight + skin.closeBtn.height * 0.5;
            marginTop = skin.closeBtn.height * 0.5;
         }
      }
      
      override public function resize(param1:Boolean = false) : void
      {
         var _loc2_:Object = null;
         if(stage != null)
         {
            TweenLite.killTweensOf(this);
            if(!opening)
            {
               this.onHideComplete();
               return;
            }
            if(param1)
            {
               this.alpha = 0;
               this.cacheAsBitmap = true;
               _loc2_ = getAutoRect();
               this.autoResize(_loc2_.changeScale * 0.8);
               TweenLite.to(this,actionDuration,{
                  "x":_loc2_.x,
                  "y":_loc2_.y,
                  "scaleX":_loc2_.changeScale,
                  "scaleY":_loc2_.changeScale,
                  "alpha":1,
                  "onComplete":this.onShowComplete
               });
            }
            else
            {
               this.alpha = 1;
               this.autoResize();
            }
         }
      }
      
      override public function show(param1:Object = true) : void
      {
         super.show(param1);
         this.addListener();
      }
      
      override public function hide(param1:Object = true) : void
      {
         var _loc2_:* = NaN;
         var _loc3_:Object = null;
         _opening = false;
         if((param1) && !(stage == null))
         {
            this.removeListener();
            cacheAsBitmap = true;
            _loc2_ = this.scaleX * 0.8;
            _loc3_ = this.getAutoRect(_loc2_);
            TweenLite.to(this,actionDuration,{
               "x":_loc3_.x,
               "y":_loc3_.y,
               "scaleX":_loc2_,
               "scaleY":_loc2_,
               "alpha":0,
               "onComplete":this.onHideComplete
            });
         }
      }
      
      protected function onShowComplete() : void
      {
         this.cacheAsBitmap = false;
      }
      
      protected function onHideComplete() : void
      {
         this.visible = false;
      }
      
      protected function addListener() : void
      {
      }
      
      protected function removeListener() : void
      {
      }
   }
}
