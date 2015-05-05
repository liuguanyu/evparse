package com.p2p.utils
{
   public class Utils extends Object
   {
      
      public function Utils()
      {
         super();
      }
      
      public function get40SizeUUID() : String
      {
         var _loc1_:String = this.getTime().toString(16);
         while(_loc1_.length < 40)
         {
            _loc1_ = _loc1_ + (Math.random() * 10000000).toString(16);
         }
         _loc1_ = _loc1_.substr(0,40);
         return _loc1_;
      }
      
      private function getTime() : Number
      {
         return Math.floor(new Date().time);
      }
   }
}
