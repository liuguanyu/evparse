package com.cgi
{
   public class vodData extends Object
   {
      
      public var manufacturers:String = "imgo.tv";
      
      public var mac:String = "";
      
      public var model:String = "imgotv";
      
      public var apk_version:String = "1.0.0.0.0.IMGOTV.1_Release";
      
      public var system_version:String = "imgotvplayer 11.2";
      
      public var ip:String = "";
      
      public var user_id:String = "";
      
      public var play_url:String = "";
      
      public var play_session:String = "";
      
      public var play_start_time:String = "";
      
      public var play_end_time:String = "";
      
      public var play_range:Array;
      
      public var play_buffering:Array;
      
      public var play_pause:Array;
      
      public var play_pause_times:String = "";
      
      public var video_info:videoInfo;
      
      public function vodData()
      {
         this.play_range = new Array();
         this.play_buffering = new Array();
         this.play_pause = new Array();
         this.video_info = new videoInfo();
         super();
      }
   }
}
