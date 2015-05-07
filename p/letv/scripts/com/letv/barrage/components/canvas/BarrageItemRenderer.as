package com.letv.barrage.components.canvas
{
   import flash.text.TextField;
   import com.greensock.TweenLite;
   import flash.text.TextFormat;
   import flash.filters.GlowFilter;
   import flash.text.TextFieldAutoSize;
   
   public class BarrageItemRenderer extends TextField
   {
      
      public var lite:TweenLite;
      
      public function BarrageItemRenderer(param1:BarrageItemData)
      {
         super();
         var _loc2_:TextFormat = new TextFormat();
         _loc2_.size = param1.size;
         _loc2_.color = param1.color;
         _loc2_.font = "Microsoft YaHei,微软雅黑,Arial,宋体";
         if(param1.self)
         {
            this.filters = [new GlowFilter(0,1,4,4,4)];
         }
         else
         {
            this.filters = [new GlowFilter(0,1,3,3,2)];
         }
         this.defaultTextFormat = _loc2_;
         this.text = param1.content;
         this.autoSize = TextFieldAutoSize.LEFT;
         this.mouseEnabled = false;
         this.cacheAsBitmap = true;
      }
      
      public function destroy() : void
      {
         if(this.lite != null)
         {
            TweenLite.killTweensOf(this);
            this.lite.kill();
            this.lite = null;
         }
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }
   }
}
