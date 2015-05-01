package com.qiyi.player.core.player.events {
	import flash.events.Event;
	
	public class PlayerEvent extends Event {
		
		public function PlayerEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false) {
			super(param1,param3,param4);
			this._data = param2;
		}
		
		public static const Evt_Error:String = "corePlayerError";
		
		public static const Evt_DefinitionSwitched:String = "corePlayerDefinitionSwitched";
		
		public static const Evt_AudioTrackSwitched:String = "corePlayerAudioTrackSwitched";
		
		public static const Evt_MovieInfoReady:String = "corePlayerMovieInfoReady";
		
		public static const Evt_RenderAreaChanged:String = "corePlayerRenderAreaChanged";
		
		public static const Evt_RenderADAreaChanged:String = "corePlayerRenderADAreaChanged";
		
		public static const Evt_GPUChanged:String = "corePlayerGPUChanged";
		
		public static const Evt_PreparePlayEnd:String = "corePlayerPreparePlayEnd";
		
		public static const Evt_SkipTrailer:String = "corePlayerSkipTrailer";
		
		public static const Evt_StartFromHistory:String = "corePlayerStartFromHistory";
		
		public static const Evt_SkipTitle:String = "corePlayerSkipTitle";
		
		public static const Evt_Capture:String = "corePlayerCapture";
		
		public static const Evt_StatusChanged:String = "corePlayerStatusChanged";
		
		public static const Evt_Stuck:String = "corePlayerStuck";
		
		public static const Evt_EnterPrepareSkipPoint:String = "corePlayerEnterPrepareSkipPoint";
		
		public static const Evt_OutPrepareSkipPoint:String = "corePlayerOutPrepareSkipPoint";
		
		public static const Evt_EnterSkipPoint:String = "corePlayerEnterSkipPoint";
		
		public static const Evt_OutSkipPoint:String = "corePlayerOutSkipPoint";
		
		public static const Evt_FreshedSkipPoints:String = "corePlayerFreshedSkipPoints";
		
		public static const Evt_EnterPrepareLeaveSkipPoint:String = "corePlayerEnterPrepareLeaveSkipPoint";
		
		public static const Evt_OutPrepareLeaveSkipPoint:String = "corePlayerOutPrepareLeaveSkipPoint";
		
		public static const Evt_EnjoyableSubTypeChanged:String = "corePlayerEnjoyableSubTypeChanged";
		
		public static const Evt_EnjoyableSubTypeInited:String = "corePlayerEnjoyableSubTypeInited";
		
		private var _data:Object;
		
		public function get data() : Object {
			return this._data;
		}
	}
}
