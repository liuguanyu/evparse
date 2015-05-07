package com.letv.barrage.components.canvas
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   
   public class BarrageLine extends Object
   {
      
      private var _index:int = 0;
      
      private var _vgap:int = 30;
      
      private var _width:int = 320;
      
      private var _actionDuration:Number = 10;
      
      private var _hgap:int = 60;
      
      private var _vector:Vector.<BarrageItemRenderer>;
      
      public function BarrageLine(param1:uint, param2:uint, param3:uint)
      {
         super();
         this._vgap = param2;
         this._hgap = param1;
         this._index = param3;
         this._vector = new Vector.<BarrageItemRenderer>();
      }
      
      public function destroy() : void
      {
         while(this._vector.length > 0)
         {
            this._vector.shift().destroy();
         }
      }
      
      public function set width(param1:int) : void
      {
         this._width = param1;
      }
      
      public function set y(param1:int) : void
      {
         var _loc2_:* = 0;
         while(_loc2_ < this._vector.length)
         {
            if(this._vector[_loc2_] != null)
            {
               this._vector[_loc2_].y = param1;
            }
            _loc2_++;
         }
      }
      
      public function set actionDuration(param1:Number) : void
      {
         this._actionDuration = param1;
      }
      
      public function get index() : uint
      {
         return this._index;
      }
      
      public function get total() : int
      {
         return this._vector.length;
      }
      
      public function get height() : uint
      {
         if(this._vector.length > 0)
         {
            return this._vector[0].height;
         }
         return 0;
      }
      
      public function get sum() : int
      {
         var _loc1_:BarrageItemRenderer = null;
         if(this._vector.length > 0)
         {
            _loc1_ = this._vector[this._vector.length - 1];
            return _loc1_.x + _loc1_.width + this._hgap;
         }
         return 0;
      }
      
      public function pause() : void
      {
         var _loc1_:* = 0;
         while(_loc1_ < this._vector.length)
         {
            if(this._vector[_loc1_] != null)
            {
               this._vector[_loc1_].lite.pause();
            }
            _loc1_++;
         }
      }
      
      public function resume() : void
      {
         var _loc1_:* = 0;
         while(_loc1_ < this._vector.length)
         {
            if(this._vector[_loc1_] != null)
            {
               this._vector[_loc1_].lite.resume();
            }
            _loc1_++;
         }
      }
      
      public function append(param1:BarrageItemData) : BarrageItemRenderer
      {
         var _loc2_:BarrageItemRenderer = new BarrageItemRenderer(param1);
         this._vector.push(_loc2_);
         _loc2_.x = this._width;
         _loc2_.lite = new TweenLite(_loc2_,this._actionDuration,{
            "ease":Linear.easeNone,
            "x":-_loc2_.width,
            "onComplete":this.onBarrageItemMoveComplete,
            "onCompleteParams":[_loc2_]
         });
         return _loc2_;
      }
      
      private function onBarrageItemMoveComplete(param1:BarrageItemRenderer) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         if(param1 != null)
         {
            _loc2_ = this._vector.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               if(this._vector[_loc3_] == param1)
               {
                  this._vector.splice(_loc3_,1)[0].destroy();
                  break;
               }
               _loc3_++;
            }
         }
      }
   }
}
