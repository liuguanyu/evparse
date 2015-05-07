package com.letv.player.log
{
   import com.alex.logging.ILogger;
   import com.letv.player.view.PlayerLayer;
   import com.alex.logging.Log;
   
   public class Logging extends Object
   {
      
      private var log:ILogger;
      
      private var layer:PlayerLayer;
      
      public function Logging()
      {
         this.log = Log.getLogger();
         this.layer = PlayerLayer.getInstance();
         super();
      }
      
      public function append(param1:String, param2:String = "info") : void
      {
         if(this.layer.sdk != null)
         {
            this.layer.sdk.sendLog(param1,param2);
         }
         else
         {
            this.log[param2](param1);
         }
      }
   }
}
