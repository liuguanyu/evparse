package com.qiyi.cupid.adplayer.base {
	public class PingbackConst extends Object {
		
		public function PingbackConst() {
			super();
		}
		
		public static const TYPE_VISIT:String = "v";
		
		public static const TYPE_PLAYER:String = "pl";
		
		public static const TYPE_STATISTICS:String = "st";
		
		public static const SUBTYPE_SUCCESS:String = "s";
		
		public static const SUBTYPE_ERROR:String = "e";
		
		public static const SUBTYPE_ADBLOCK:String = "adb";
		
		public static const CODE_PL_HTTP_ERROR:int = 101;
		
		public static const CODE_PL_TIMEOUT:int = 102;
		
		public static const CODE_PL_INIT_ERROR:int = 103;
		
		public static const CODE_PL_RUNTIME_ERROR:int = 104;
		
		public static const CODE_VP_ILLEGAL:int = 1001;
		
		public static const ENCODE_FIELDS:Array = ["x","lc","em"];
		
		public static const SERVICE_URL:String = "http://msg.71.am/cp2.gif?";
	}
}
