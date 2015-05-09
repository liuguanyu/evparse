package com.letv.plugins.kernel.model.special
{
   public class AdData extends Object
   {
      
      private static var _instance:AdData;
      
      private var _adRemainingTime:Number = 0;
      
      public function AdData()
      {
         super();
      }
      
      public static function getInstance() : AdData
      {
         if(_instance == null)
         {
            _instance = new AdData();
         }
         return _instance;
      }
      
      public function get adRemainingTime() : Number
      {
         var _loc1_:Number = this._adRemainingTime;
         this._adRemainingTime = 0;
         return _loc1_;
      }
      
      public function set adRemainingTime(param1:Number) : void
      {
         this._adRemainingTime = param1;
      }
      
      public function flush(param1:Object) : void
      {
         if(param1 != null)
         {
            if(param1.hasOwnProperty("adRemainingTime"))
            {
               this._adRemainingTime = Number(param1["adRemainingTime"]);
            }
         }
      }
   }
}
