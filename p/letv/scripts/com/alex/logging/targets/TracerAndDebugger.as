package com.alex.logging.targets
{
   import com.alex.logging.Logger;
   
   public class TracerAndDebugger extends Logger
   {
      
      private const INFO_COLOR:uint = 16777215;
      
      private const WARN_COLOR:uint = 39423;
      
      private const ERROR_COLOR:uint = 16750848;
      
      private const FAULT_COLOR:uint = 16711680;
      
      public function TracerAndDebugger()
      {
         super();
      }
      
      override protected function sendLog(param1:String, param2:int = 16777215) : void
      {
         super.sendLog(param1,param2);
      }
      
      override public function info(param1:String) : void
      {
         var param1:String = getTimeStr() + "info] " + param1;
         this.sendLog(param1,this.INFO_COLOR);
      }
      
      override public function warn(param1:String) : void
      {
         var param1:String = getTimeStr() + "warn] " + param1;
         this.sendLog(param1,this.WARN_COLOR);
      }
      
      override public function error(param1:String) : void
      {
         var param1:String = getTimeStr() + "error] " + param1;
         this.sendLog(param1,this.ERROR_COLOR);
      }
      
      override public function fault(param1:String) : void
      {
         var param1:String = getTimeStr() + "fault] " + param1;
         this.sendLog(param1,this.FAULT_COLOR);
      }
   }
}
