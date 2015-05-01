package com.qiyi.player.core.player.def {
	public class PauseTypeEnum extends Object {
		
		public function PauseTypeEnum() {
			super();
		}
		
		private static var begin:int = 0;
		
		public static var USER:int = 1 << ++begin;
	}
}
