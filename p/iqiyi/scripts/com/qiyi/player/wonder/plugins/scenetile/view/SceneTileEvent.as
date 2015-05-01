package com.qiyi.player.wonder.plugins.scenetile.view {
	import com.qiyi.player.wonder.common.event.CommonEvent;
	
	public class SceneTileEvent extends CommonEvent {
		
		public function SceneTileEvent(param1:String, param2:Object = null) {
			super(param1,param2);
		}
		
		public static const Evt_ToolOpen:String = "evtSceneTileToolOpen";
		
		public static const Evt_ToolClose:String = "evtSceneTileToolClose";
		
		public static const Evt_ScoreOpen:String = "evtSceneTileScoreOpen";
		
		public static const Evt_ScoreSuccessOpen:String = "evtSceneTileScoreSuccessOpen";
		
		public static const Evt_ScoreClose:String = "evtSceneTileScoreClose";
		
		public static const Evt_DefinitLimitOpen:String = "evtSceneTileDefinitLimitOpen";
		
		public static const Evt_DefinitLimitClose:String = "evtSceneTileDefinitLimitClose";
		
		public static const Evt_ScoreHeartClick:String = "evtScoreHeartClick";
		
		public static const Evt_TipCloseBtnClick:String = "evtTipCloseBtnClick";
		
		public static const Evt_BarrageDeleteInfo:String = "evtBarrageDeleteInfo";
		
		public static const Evt_BarrageItemClick:String = "evtBarrageItemClick";
	}
}
