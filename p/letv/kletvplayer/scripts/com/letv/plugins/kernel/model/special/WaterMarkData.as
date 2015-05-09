package com.letv.plugins.kernel.model.special
{
   public class WaterMarkData extends Object
   {
      
      private var _dataArr:Array;
      
      private var _lastCid:String = "";
      
      private var _lastPid:String = "";
      
      public function WaterMarkData()
      {
         this._dataArr = [];
         super();
      }
      
      public function setData(param1:Object) : void
      {
         if(!(param1 == null) && !(param1["imgs"] == null))
         {
            this._dataArr = param1["imgs"];
         }
         else
         {
            this._dataArr = [];
         }
      }
      
      public function setId(param1:String, param2:String) : void
      {
         this._lastCid = param1;
         this._lastPid = param2;
      }
      
      public function get data() : Array
      {
         return this._dataArr;
      }
   }
}
