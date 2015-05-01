package com.qiyi.player.wonder.plugins.dock {
	public class DockDef extends Object {
		
		public function DockDef() {
			super();
		}
		
		private static var statusBegin:int = 0;
		
		public static const STATUS_BEGIN:int = statusBegin;
		
		public static const STATUS_VIEW_INIT:int = statusBegin;
		
		public static const STATUS_OPEN:int = ++statusBegin;
		
		public static const STATUS_SHOW:int = ++statusBegin;
		
		public static const STATUS_SHARE_SHOW:int = ++statusBegin;
		
		public static const STATUS_LIGHT_SHOW:int = ++statusBegin;
		
		public static const STATUS_LIGHT_ON:int = ++statusBegin;
		
		public static const STATUS_OFFLINE_WATCH_SHOW:int = ++statusBegin;
		
		public static const STATUS_OFFLINE_WATCH_ENABLE:int = ++statusBegin;
		
		public static const STATUS_END:int = ++statusBegin;
		
		public static const STATUS_COUNT:int = STATUS_END - STATUS_BEGIN;
		
		public static const NOTIFIC_ADD_STATUS:String = "dockAddStatus";
		
		public static const NOTIFIC_REMOVE_STATUS:String = "dockRemoveStatus";
		
		public static const DOCK_HIND_DELAY:int = 3000;
	}
}
