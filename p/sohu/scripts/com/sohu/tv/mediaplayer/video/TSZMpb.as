package com.sohu.tv.mediaplayer.video {
	import com.sohu.tv.mediaplayer.ui.TvSohuButton;
	import flash.display.MovieClip;
	import com.sohu.tv.mediaplayer.PlayerConfig;
	
	public class TSZMpb extends TvSohuMediaPlayback {
		
		public function TSZMpb() {
			super();
		}
		
		private static var singleton:TSZMpb;
		
		public static function getInstance() : TSZMpb {
			if(singleton == null) {
				singleton = new TSZMpb();
			}
			return singleton;
		}
		
		private var _share2_btn:TvSohuButton;
		
		private var _delete_btn:TvSohuButton;
		
		private var _collect_btn:TvSohuButton;
		
		private var _jsNext_btn:TvSohuButton;
		
		private var _collectTipMc:MovieClip;
		
		private var _closeTimeNum:Number = 0;
		
		private var _hasCollect:Boolean = false;
		
		private var _isAllowDelete:Boolean = true;
		
		override protected function loadSkin(param1:String = "") : void {
			var param1:* = PlayerConfig.swfHost + "skins/s9.swf";
			super.loadSkin(param1);
			PlayerConfig.topBarNor = false;
			PlayerConfig.showRecommend = false;
			PlayerConfig.showShareBtn = false;
			PlayerConfig.isListPlay = false;
		}
	}
}
