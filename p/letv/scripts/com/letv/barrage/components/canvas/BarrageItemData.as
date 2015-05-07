package com.letv.barrage.components.canvas
{
   public class BarrageItemData extends Object
   {
      
      private var _size:int = 20;
      
      private var _color:Number = 16777215;
      
      private var _content:String = "";
      
      private var _self:Boolean = false;
      
      public function BarrageItemData(param1:Object)
      {
         super();
         if(param1 == null)
         {
            throw new Error("子弹内容不能为空");
         }
         else
         {
            if(param1.hasOwnProperty("size"))
            {
               this._size = int(param1["size"]);
            }
            if(param1.hasOwnProperty("color"))
            {
               this._color = Number("0x" + param1["color"]);
            }
            if(param1.hasOwnProperty("txt"))
            {
               this._content = param1["txt"];
            }
            if(param1.hasOwnProperty("self"))
            {
               this._self = param1["self"];
            }
            return;
         }
      }
      
      public function set color(param1:Number) : void
      {
         this._color = param1;
      }
      
      public function get size() : int
      {
         return this._size;
      }
      
      public function get color() : Number
      {
         return this._color;
      }
      
      public function get content() : String
      {
         return this._content;
      }
      
      public function get self() : Boolean
      {
         return this._self;
      }
   }
}
