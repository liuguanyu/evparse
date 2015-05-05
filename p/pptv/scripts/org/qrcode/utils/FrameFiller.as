package org.qrcode.utils
{
   import flash.geom.Point;
   
   public class FrameFiller extends Object
   {
      
      public var width:int;
      
      public var frame:Array;
      
      public var x:int;
      
      public var y:int;
      
      public var dir:int;
      
      public var bit:int;
      
      public function FrameFiller(param1:int, param2:Array)
      {
         super();
         this.width = param1;
         this.frame = param2;
         this.x = param1 - 1;
         this.y = param1 - 1;
         this.dir = -1;
         this.bit = -1;
      }
      
      public function setFrameAt(param1:Point, param2:Object) : void
      {
         this.frame[param1.y][param1.x] = param2;
      }
      
      public function getFrameAt(param1:Point) : Object
      {
         return this.frame[param1.y][param1.x];
      }
      
      public function next() : Point
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         while(this.bit != -1)
         {
            _loc1_ = this.x;
            _loc2_ = this.y;
            _loc3_ = this.width;
            if(this.bit == 0)
            {
               _loc1_--;
               this.bit++;
            }
            else
            {
               _loc1_++;
               _loc2_ = _loc2_ + this.dir;
               this.bit--;
            }
            if(this.dir < 0)
            {
               if(_loc2_ < 0)
               {
                  _loc2_ = 0;
                  _loc1_ = _loc1_ - 2;
                  this.dir = 1;
                  if(_loc1_ == 6)
                  {
                     _loc1_--;
                     _loc2_ = 9;
                  }
               }
            }
            else if(_loc2_ == _loc3_)
            {
               _loc2_ = _loc3_ - 1;
               _loc1_ = _loc1_ - 2;
               this.dir = -1;
               if(_loc1_ == 6)
               {
                  _loc1_--;
                  _loc2_ = _loc2_ - 8;
               }
            }
            
            if(_loc1_ < 0 || _loc2_ < 0)
            {
               return null;
            }
            this.x = _loc1_;
            this.y = _loc2_;
            if(!(this.frame[this.y][this.x] & 128))
            {
               return new Point(this.x,this.y);
            }
         }
         this.bit = 0;
         return new Point(this.x,this.y);
      }
   }
}
