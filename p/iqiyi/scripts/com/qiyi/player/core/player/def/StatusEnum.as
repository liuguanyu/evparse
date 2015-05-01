package com.qiyi.player.core.player.def {
	public class StatusEnum extends Object {
		
		public function StatusEnum() {
			super();
		}
		
		private static var begin:int = 0;
		
		public static const BEGIN:int = begin;
		
		public static const IDLE:int = begin;
		
		public static const ALREADY_LOAD_MOVIE:int = ++begin;
		
		public static const ALREADY_READY:int = ++begin;
		
		public static const ALREADY_START_LOAD:int = ++begin;
		
		public static const ALREADY_PLAY:int = ++begin;
		
		public static const PLAYING:int = ++begin;
		
		public static const PAUSED:int = ++begin;
		
		public static const SEEKING:int = ++begin;
		
		public static const WAITING:int = ++begin;
		
		public static const STOPPING:int = ++begin;
		
		public static const STOPED:int = ++begin;
		
		public static const FAILED:int = ++begin;
		
		public static const WAITING_START_LOAD:int = ++begin;
		
		public static const WAITING_PLAY:int = ++begin;
		
		public static const META_START_LOAD_CALLED:int = ++begin;
		
		public static const HISTORY_START_LOAD_CALLED:int = ++begin;
		
		public static const P2P_CORE_START_LOAD_CALLED:int = ++begin;
		
		public static const END:int = ++begin;
		
		public static const COUNT:int = END - BEGIN;
	}
}
