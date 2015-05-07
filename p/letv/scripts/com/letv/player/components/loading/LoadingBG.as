package com.letv.player.components.loading
{
   import flash.display.Sprite;
   import flash.display.BitmapData;
   import flash.display.Bitmap;
   import flash.display.BitmapDataChannel;
   
   public class LoadingBG extends Sprite
   {
      
      private var _mask:Sprite;
      
      private var _maskBG:MaskBG;
      
      private var _bmdItem:BitmapData;
      
      private var _bitmapItem:Bitmap;
      
      private var _itemArr:Array;
      
      public function LoadingBG()
      {
         this._itemArr = [];
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._bmdItem = new BitmapData(100,100,false,0);
         this._bmdItem.noise(1,32,41,BitmapDataChannel.BLUE | BitmapDataChannel.RED | BitmapDataChannel.GREEN,false);
         this._bitmapItem = new Bitmap(this._bmdItem);
         this._mask = new Sprite();
         this.mask = this._mask;
         this._maskBG = new MaskBG();
      }
      
      public function resize(param1:int, param2:int) : void
      {
         var _loc3_:int = Math.ceil(param1 / this._bitmapItem.width);
         var _loc4_:int = Math.ceil(param2 / this._bitmapItem.height);
         var _loc5_:* = 0;
         if(this._itemArr.length < _loc3_ * _loc4_)
         {
            while(_loc5_ < _loc3_ * _loc4_)
            {
               if(_loc5_ >= this._itemArr.length)
               {
                  this._itemArr.push(new Bitmap(this._bmdItem.clone()));
               }
               this._itemArr[_loc5_].x = _loc5_ % _loc3_ * this._bitmapItem.width;
               this._itemArr[_loc5_].y = int(_loc5_ / _loc3_) * this._bitmapItem.height;
               addChild(this._itemArr[_loc5_]);
               _loc5_++;
            }
         }
         else
         {
            while(_loc5_ < this._itemArr.length)
            {
               if(_loc5_ >= _loc3_ * _loc4_)
               {
                  if(this._itemArr[_loc5_].parent == this)
                  {
                     removeChild(this._itemArr[_loc5_]);
                  }
               }
               else
               {
                  this._itemArr[_loc5_].x = _loc5_ % _loc3_ * this._bitmapItem.width;
                  this._itemArr[_loc5_].y = int(_loc5_ / _loc3_) * this._bitmapItem.height;
                  addChild(this._itemArr[_loc5_]);
               }
               _loc5_++;
            }
         }
         this._maskBG.width = param1;
         this._maskBG.height = param2;
         addChild(this._maskBG);
         this._mask.graphics.clear();
         this._mask.graphics.beginFill(0,0);
         this._mask.graphics.drawRect(0,0,param1,param2);
         this._mask.graphics.endFill();
      }
   }
}
