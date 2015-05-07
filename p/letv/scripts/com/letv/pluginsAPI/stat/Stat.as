package com.letv.pluginsAPI.stat
{
   public class Stat extends Object
   {
      
      public static const VERSION:String = "2.0";
      
      public static const OP_REFRESH_INFO:String = "refreshInfo";
      
      public static const OP_REFRESH_VV:String = "refreshVV";
      
      public static const OP_REFRESH_DEFINITION:String = "refreshDefinition";
      
      public static const OP_RESUME_PT:String = "resumePtTimer";
      
      public static const OP_PAUSE_PT:String = "pausePtTimer";
      
      public static const OP_RESUME_HEAD:String = "resumeHeadTimer";
      
      public static const OP_PAUSE_HEAD:String = "pauseHeadTimer";
      
      public static const LOG_PLAY:String = "pl";
      
      public static const LOG_ACTION:String = "op";
      
      public static const LOG_ENV:String = "env";
      
      public static const LOG_PGV:String = "pgv";
      
      public static const LOG_COMSCORE:String = "comscore";
      
      public static const LOG_IRS:String = "irs";
      
      public static const LOG_PLAY_CP:String = "cp";
      
      public static const LOG_PLAY_INIT:String = "init";
      
      public static const LOG_AD_BLOCK:String = "jump";
      
      public static const LOG_PLAY_GSLB:String = "gslb";
      
      public static const LOG_PLAY_CLOAD:String = "cload";
      
      public static const LOG_PLAY_PLAY:String = "play";
      
      public static const LOG_PLAY_HEAD:String = "time";
      
      public static const LOG_PLAY_EMPTY:String = "block";
      
      public static const LOG_PLAY_END:String = "end";
      
      public static const LOG_PLAY_DEBUG:String = "debug";
      
      public static const LOG_PLAY_DRAG:String = "drag";
      
      public static const LOG_STATE_DEBUG:String = "stateDebug";
      
      public static const LOG_ACTION_CLK:String = "0";
      
      public static const URL_STAT_PLAY:String = "http://dc.letv.com/pl/";
      
      public static const URL_STAT_ACT:String = "http://dc.letv.com/op/";
      
      public static const URL_STAT_ENV:String = "http://dc.letv.com/env/";
      
      public static const URL_STAT_PGV:String = "http://dc.letv.com/pgv/";
      
      public static const IRS_START:String = "start";
      
      public static const IRS_PLAY:String = "play";
      
      public static const IRS_PAUSE:String = "pause";
      
      public static const IRS_DRAG:String = "drag";
      
      public static const IRS_END:String = "end";
      
      public static const IRS_CLEAR:String = "clear";
      
      public function Stat()
      {
         super();
      }
   }
}
