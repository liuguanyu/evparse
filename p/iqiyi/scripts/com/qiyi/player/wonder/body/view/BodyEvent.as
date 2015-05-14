package com.qiyi.player.wonder.body.view
{
	import com.qiyi.player.wonder.common.event.CommonEvent;
	
	public class BodyEvent extends CommonEvent
	{
		
		public static const Evt_StageResize:String = "evtStageResize";
		
		public static const Evt_FullScreen:String = "evtFullScreen";
		
		public static const Evt_LeaveStage:String = "evtLeaveStage";
		
		public static const Evt_MouseLayerClick:String = "evtMouseLayerClick";
		
		public static const Evt_MouseLayerDoubleClick:String = "evtMouseLayerDoubleClick";
		
		public function BodyEvent(param1:String, param2:Object = null)
		{
			super(param1,param2);
		}
	}
}
