package com.gridsum.VideoTracker
{
   public class GSVideoState extends Object
   {
      
      public static const BUFFERING:String = "buffering";
      
      public static const CONNECTION_ERROR:String = "connectionError";
      
      public static const DISCONNECTED:String = "disconnected";
      
      public static const LOADING:String = "loading";
      
      public static const PAUSED:String = "paused";
      
      public static const PLAYING:String = "playing";
      
      public static const REWINDING:String = "rewinding";
      
      public static const SEEKING:String = "seeking";
      
      public static const STOPPED:String = "stopped";
      
      public static const NO_PLAYING_BUFFERING:String = "else";
      
      public function GSVideoState()
      {
         super();
      }
   }
}
