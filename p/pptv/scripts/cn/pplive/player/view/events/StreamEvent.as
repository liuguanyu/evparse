package cn.pplive.player.view.events
{
   public class StreamEvent extends Object
   {
      
      public static const STREAM_SUCCESS:String = "stream_success";
      
      public static const STREAM_FAILED:String = "stream_failed";
      
      public static const STREAM_NOLIVE:String = "stream_nolive";
      
      public static const STREAM_CLOSE:String = "stream_close";
      
      public static const STREAM_RETRY:String = "stream_retry";
      
      public static const STREAM_INTERRUPT:String = "stream_interrupt";
      
      public static const STREAM_SEEK:String = "stream_seek";
      
      public static const STREAM_STOP:String = "stream_stop";
      
      public static const STREAM_START:String = "stream_start";
      
      public static const STREAM_FULL:String = "stream_full";
      
      public static const STREAM_EMPTY:String = "stream_empty";
      
      public static const STREAM_UPDATE:String = "stream_update";
      
      public static const STREAM_SPEED:String = "stream_speed";
      
      public static const STREAM_REPLAY:String = "stream_replay";
      
      public static const STREAM_RESULT:String = "stream_result";
      
      public static const STREAM_P2PLOG:String = "stream_p2plog";
      
      public function StreamEvent()
      {
         super();
      }
   }
}
