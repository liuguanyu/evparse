package com.gridsum.VideoTracker
{
   import com.gridsum.VideoTracker.Core.PlayLogic;
   import com.gridsum.VideoTracker.Core.CmdType;
   
   public class ShiftPlay extends Play
   {
      
      public function ShiftPlay(param1:String, param2:String, param3:String, param4:VideoInfo, param5:IShiftInfoProvider)
      {
         var _loc6_:PlayLogic = new PlayLogic(param1,null,param2,param3,param4,param5,CmdType.shiftPlay);
         super(param1,null,param2,param3,param4,_loc6_);
      }
      
      public function endLoading(param1:Boolean, param2:ShiftMetaInfo) : void
      {
         super.generalEndLoading(param1,param2);
      }
      
      override public function onStateChanged(param1:String) : void
      {
         super.onStateChanged(param1);
      }
   }
}
