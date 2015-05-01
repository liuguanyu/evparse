package ebing.events {
	import flash.events.Event;
	
	public class MediaEvent extends Event {
		
		public function MediaEvent(param1:String) {
			super(param1);
		}
		
		public static const PLAY:String = "onPlay";
		
		public static const PAUSE:String = "onPause";
		
		public static const STOP:String = "onStop";
		
		public static const START:String = "onStart";
		
		public static const FULL:String = "onFull";
		
		public static const METADATA:String = "onMetaData";
		
		public static const BUFFER_EMPTY:String = "buffer_empty";
		
		public static const PLAY_PROGRESS:String = "play_progress";
		
		public static const LOAD_PROGRESS:String = "load_progress";
		
		public static const SEEKED:String = "seeked";
		
		public static const NOTFOUND:String = "stream_notfound";
		
		public static const PLAYED:String = "video_played";
		
		public static const FINISH:String = "video_finish";
		
		public static const FULL_SCREEN:String = "fullScreen";
		
		public static const EXIT_FULL_SCREEN:String = "normal";
		
		public static const CONNECTING:String = "connecting";
		
		public static const CONNECT_TIMEOUT:String = "connect_timeout";
		
		public static const RETRY_FAILED:String = "retry_failed";
		
		public static const NC_RETRY_FAILED:String = "nc_retry_failed";
		
		public static const LOAD_FILE_SUC:String = "load_file_suc";
		
		public static const REDIRECT_FAILED:String = "redirect_failed";
		
		public static const LOAD_INFO_SUC:String = "loadDataSuccess";
		
		public static const LOAD_INFO_FAILD:String = "loadDataFaild";
		
		public static const DRAG_START:String = "drag_start";
		
		public static const DRAG_END:String = "drag_end";
		
		public static const NC_CONNECT_SUCCESS:String = "nc_connect_success";
		
		public static const NC_CONNECT_CLOSED:String = "nc_connect_closed";
		
		public static const VOLUME_INIT_FINISH:String = "volume_init_finish";
		
		public static const SKIN_LOAD_TIMEOUT:String = "skin_load_timeout";
		
		public static const SKIN_LOAD_IOERROR:String = "skin_load_ioerror";
		
		public static const LOAD_ABEND:String = "load_abend";
		
		public static const PLAY_ABEND:String = "play_abend";
		
		public static const INIT_FINISH:String = "initfinish";
		
		private var K102606415927350AE742B492D4F1A00305E667373569K:Object;
		
		public function set obj(param1:Object) : void {
			this.K102606415927350AE742B492D4F1A00305E667373569K = param1;
		}
		
		public function get obj() : Object {
			return this.K102606415927350AE742B492D4F1A00305E667373569K;
		}
	}
}
