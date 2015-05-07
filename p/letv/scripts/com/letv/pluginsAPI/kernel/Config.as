package com.letv.pluginsAPI.kernel
{
   import flash.geom.Rectangle;
   
   public class Config extends Object
   {
      
      public static const TEST_SPEED_RATE:uint = 3000;
      
      public static const MEMORY_LIMIT:uint = 629145600;
      
      public static const ATTACH_TIME:uint = 60;
      
      public static const RECORD_VCS_RATE:uint = 120000;
      
      public static const RECORD_TIME_RATE:uint = 3000;
      
      public static const RECORD_DURATION_LIMIT:uint = 15;
      
      public static const JUMP_TAIL_INFO:uint = 15;
      
      public static const RECORD_PLAYER_MAX:uint = 20;
      
      public static const RECORD_SPEED_MAX:uint = 5;
      
      public static const AUTO_TO_P1080:uint = 390;
      
      public static const AUTO_TO_P720:uint = 230;
      
      public static const AUTO_TO_K4:uint = 1024;
      
      public static const AUTO_TO_YH:uint = 256;
      
      public static const AUTO_TO_HD:uint = 170;
      
      public static const AUTO_TO_SD:uint = 100;
      
      public static const VIDEO_SCALE_MIN:Number = 0.1;
      
      public static const VIDEO_SCALE_MAX:Number = 5;
      
      public static const LOOP_ON_KERNEL:uint = 100;
      
      public static const CLK_DELAY_TIME:uint = 300;
      
      public static const MOUSE_HIDE_TIME:uint = 2000;
      
      public static const VOLUME_MAX:Number = 1;
      
      public static const VOLUME_TOTAL:Number = 5;
      
      public static const MIN_SIZE:Rectangle = new Rectangle(0,0,530,280);
      
      public function Config()
      {
         super();
      }
   }
}
