package com.letv.plugins.kernel.statistics
{
   import flash.utils.getTimer;
   
   public class LetvParams extends Object
   {
      
      public static var sendENVFlag:Boolean;
      
      private var _lastTime:Number = 0;
      
      private var _pt:Number = 0;
      
      private var _gslbcount:int = 0;
      
      private var _uuid:String;
      
      private var _emptytime:int = 0;
      
      public function LetvParams()
      {
         super();
      }
      
      public function set pt(param1:Number) : void
      {
         this._pt = param1;
      }
      
      public function get pt() : Number
      {
         return this._pt;
      }
      
      public function set lastTime(param1:Number) : void
      {
         this._lastTime = param1;
      }
      
      public function get lastTime() : Number
      {
         return this._lastTime;
      }
      
      public function set gslbcount(param1:int) : void
      {
         this._gslbcount = param1;
      }
      
      public function get gslbcount() : int
      {
         return this._gslbcount;
      }
      
      public function set uuid(param1:String) : void
      {
         this._uuid = param1;
      }
      
      public function get uuid() : String
      {
         return this._uuid;
      }
      
      public function set emptytime(param1:int) : void
      {
         this._emptytime = param1;
      }
      
      public function get emptytime() : int
      {
         return this._emptytime;
      }
      
      public function get emptyutime() : int
      {
         var _loc1_:int = this.emptytime;
         this.emptytime = 0;
         if(_loc1_ > 0)
         {
            return getTimer() - _loc1_;
         }
         return 0;
      }
   }
}
