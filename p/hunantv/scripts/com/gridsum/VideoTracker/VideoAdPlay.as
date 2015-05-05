package com.gridsum.VideoTracker
{
   import com.gridsum.VideoTracker.Core.PlayLogic;
   import com.gridsum.VideoTracker.Core.CmdType;
   
   public class VideoAdPlay extends Play
   {
      
      public function VideoAdPlay(param1:String, param2:String, param3:String, param4:String, param5:VideoInfo, param6:IVodInfoProvider)
      {
         var _loc7_:PlayLogic = new PlayLogic(param1,param2,param3,param4,param5,param6,CmdType.videoAdPlay);
         super(param1,param2,param3,param4,param5,_loc7_);
      }
      
      public function endLoading(param1:Boolean, param2:VodMetaInfo) : void
      {
         super.generalEndLoading(param1,param2);
      }
      
      override public function onStateChanged(param1:String) : void
      {
         super.onStateChanged(param1);
      }
   }
}
