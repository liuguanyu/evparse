package cn.pplive.player.manager
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   import flash.geom.Matrix;
   import flash.geom.Point;
   
   public class DrawBmpManager extends Object
   {
      
      public function DrawBmpManager()
      {
         super();
      }
      
      public static function draw(param1:DisplayObject, param2:Rectangle) : BitmapData
      {
         var _loc3_:Matrix = new Matrix(1,0,0,1,-param2.x,-param2.y);
         param2.x = param2.y = 0;
         var _loc4_:BitmapData = getBmpData(param2);
         _loc4_.draw(param1,_loc3_,null,null,param2,true);
         return _loc4_;
      }
      
      public static function copy(param1:BitmapData, param2:Rectangle) : BitmapData
      {
         var _loc3_:BitmapData = getBmpData(param2);
         _loc3_.copyPixels(param1,param2,new Point(0,0));
         return _loc3_;
      }
      
      private static function getBmpData(param1:Rectangle) : BitmapData
      {
         return new BitmapData(param1.width,param1.height,true,4.27819008E9);
      }
   }
}
