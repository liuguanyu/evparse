package com.gs
{
   import com.gridsum.VideoTracker.IVodInfoProvider;
   import com.playerCoreGs;
   
   public class NetStreamVodInfoProvider extends Object implements IVodInfoProvider
   {
      
      private var playcore:playerCoreGs = null;
      
      public function NetStreamVodInfoProvider(param1:playerCoreGs)
      {
         super();
         this.playcore = param1;
      }
      
      public function getBitrate() : Number
      {
         return this.playcore.videoMeta.videodatarate;
      }
      
      public function getPosition() : Number
      {
         if(this.playcore.stream != null)
         {
            return this.playcore.stream.time;
         }
         return 0;
      }
      
      public function getFramesPerSecond() : Number
      {
         return 25;
      }
   }
}
