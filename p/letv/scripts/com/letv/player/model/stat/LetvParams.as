package com.letv.player.model.stat
{
   public class LetvParams extends Object
   {
      
      private var _gslbcount:int = 0;
      
      private var _uuid:String;
      
      private var _ia:String = "-";
      
      public function LetvParams()
      {
         super();
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
      
      public function set ia(param1:String) : void
      {
         this._ia = param1;
      }
      
      public function get ia() : String
      {
         return this._ia;
      }
   }
}
