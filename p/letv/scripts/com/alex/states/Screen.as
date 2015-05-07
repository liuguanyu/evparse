package com.alex.states
{
   public class Screen extends Object
   {
      
      public static const APP_MIN_WIDTH_PIXEL:uint = 100;
      
      public static const APP_MIN_HEIGHT_PIXEL:uint = 100;
      
      private var _width:Number = 0;
      
      private var _height:Number = 0;
      
      public function Screen(param1:Number, param2:Number)
      {
         super();
         this._width = param1;
         this._height = param2;
      }
      
      public function set width(param1:Number) : void
      {
         this._width = param1;
      }
      
      public function get width() : Number
      {
         return this._width;
      }
      
      public function set height(param1:Number) : void
      {
         this._height = param1;
      }
      
      public function get height() : Number
      {
         return this._height;
      }
   }
}
