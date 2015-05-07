package com.letv.player.controller.command
{
   public class BarrageCommand extends Object
   {
      
      public static const SHUTDOWN_BARRAGE:int = -1;
      
      public static const INIT_BARRAGE:int = 0;
      
      public static const DOWNLOAD_BARRAGE:int = 1;
      
      public static const UPLOAD_BARRAGE:int = 2;
      
      public static const ADD_BARRAGE:int = 3;
      
      public static const RESET_BARRAGE:int = 4;
      
      public static const LOOP_BARRAGE:int = 5;
      
      public function BarrageCommand()
      {
         super();
      }
   }
}
