package com.qiyi.player.wonder.plugins.continueplay.view.parts {
	import continueplay.LoadingTip;
	import flash.text.TextField;
	import common.CommonLoadingMC;
	import com.qiyi.player.wonder.common.ui.FastCreator;
	
	public class ContinueLoading extends LoadingTip {
		
		public function ContinueLoading() {
			this._loadingMC = new CommonLoadingMC();
			this._loadingMC.x = 6;
			this._loadingMC.y = 6;
			this._loadingMC.width = this._loadingMC.height = 15;
			addChild(this._loadingMC);
			this._loadingTF = FastCreator.createLabel(TEXT_LOADING,16777215);
			this._loadingTF.x = 24;
			this._loadingTF.y = 2;
			addChild(this._loadingTF);
			super();
		}
		
		private static const TEXT_LOADING:String = "数据加载中";
		
		private var _loadingTF:TextField;
		
		private var _loadingMC:CommonLoadingMC;
	}
}
