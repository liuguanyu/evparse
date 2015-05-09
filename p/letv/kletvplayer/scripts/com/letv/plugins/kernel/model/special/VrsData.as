package com.letv.plugins.kernel.model.special
{
   public class VrsData extends Object
   {
      
      private static var _instance:VrsData;
      
      public var headTime:Number = 0;
      
      public var tailTime:Number = 0;
      
      public var seeData:Object;
      
      public function VrsData()
      {
         super();
      }
      
      public static function getInstance() : VrsData
      {
         if(_instance == null)
         {
            _instance = new VrsData();
         }
         return _instance;
      }
      
      public function flush(param1:Object = null) : void
      {
         this.seeData = null;
         this.headTime = this.tailTime = 0;
         if(!param1)
         {
            return;
         }
         var _loc2_:Array = param1["skip"] as Array || [];
         if(_loc2_[0])
         {
            this.headTime = (parseInt(_loc2_[0])) || (0);
         }
         if(_loc2_[1])
         {
            this.tailTime = (parseInt(_loc2_[1])) || (0);
         }
         this.seeData = param1["hot"];
      }
   }
}
