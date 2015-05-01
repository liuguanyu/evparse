package com.qiyi.player.core.video.events {
	import flash.events.Event;
	
	public class EngineEvent extends Event {
		
		public function EngineEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false) {
			super(param1,param3,param4);
			this._data = param2;
		}
		
		public static const Evt_DefinitionSwitched:String = "definitionSwitched";
		
		public static const Evt_AudioTrackSwitched:String = "audioTrackSwitched";
		
		public static const Evt_Error:String = "error";
		
		public static const Evt_PreparePlayEnd:String = "preparePlayEnd";
		
		public static const Evt_SkipTrailer:String = "skipTrailer";
		
		public static const Evt_StartFromHistory:String = "startFromHistory";
		
		public static const Evt_SkipTitle:String = "skipTitle";
		
		public static const Evt_StatusChanged:String = "statusChanged";
		
		public static const Evt_Stuck:String = "engineStuck";
		
		public static const Evt_EnterPrepareSkipPoint:String = "enterPrepareSkipPoint";
		
		public static const Evt_OutPrepareSkipPoint:String = "outPrepareSkipPoint";
		
		public static const Evt_EnterSkipPoint:String = "enterSkipPoint";
		
		public static const Evt_OutSkipPoint:String = "outSkipPoint";
		
		public static const Evt_EnterPrepareLeaveSkipPoint:String = "enterPrepareLeaveSkipPoint";
		
		public static const Evt_OutPrepareLeaveSkipPoint:String = "outPrepareLeaveSkipPoint";
		
		private var _data:Object;
		
		public function get data() : Object {
			return this._data;
		}
	}
}
