package com.p2p.utils
{
   import flash.net.SharedObject;
   
   public class GetLocalID extends Object
   {
      
      private var so:SharedObject;
      
      public function GetLocalID()
      {
         super();
      }
      
      public function getCDEID() : String
      {
         var _loc1_:* = "";
         this.so = SharedObject.getLocal("p2pKernel","/");
         if(this.so.data.hasOwnProperty("cdeid"))
         {
            _loc1_ = this.so.data["cdeid"];
         }
         else
         {
            _loc1_ = this.so.data["cdeid"] = GUID.create();
            this.so.flush();
         }
         return _loc1_;
      }
   }
}
