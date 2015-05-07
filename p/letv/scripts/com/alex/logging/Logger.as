package com.alex.logging
{
   public class Logger extends Object implements ILogger
   {
      
      public function Logger()
      {
         super();
      }
      
      protected function sendLog(param1:String, param2:int = 16777215) : void
      {
         Log.appendLog(param1,param2);
      }
      
      protected function getTimeStr() : String
      {
         var _loc1_:Date = new Date();
         var _loc2_:* = _loc1_.fullYear + "-" + String(_loc1_.month + 1) + "-" + _loc1_.date + " ";
         _loc2_ = _loc2_ + (_loc1_.hours + ":" + _loc1_.minutes + ":" + _loc1_.seconds + " ");
         return _loc2_;
      }
      
      public function info(param1:String) : void
      {
      }
      
      public function warn(param1:String) : void
      {
      }
      
      public function error(param1:String) : void
      {
      }
      
      public function fault(param1:String) : void
      {
      }
   }
}
