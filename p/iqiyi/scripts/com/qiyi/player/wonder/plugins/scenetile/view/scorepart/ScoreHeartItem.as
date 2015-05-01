package com.qiyi.player.wonder.plugins.scenetile.view.scorepart {
	import flash.display.Sprite;
	import scenetile.ScoreHeart;
	
	public class ScoreHeartItem extends Sprite {
		
		public function ScoreHeartItem(param1:uint) {
			super();
			this._index = param1;
			this._mcScoreHeart = new ScoreHeart();
			addChild(this._mcScoreHeart);
			this.useHandCursor = this.buttonMode = true;
		}
		
		private var _mcScoreHeart:ScoreHeart;
		
		private var _index:uint = 0;
		
		public function get index() : uint {
			return this._index;
		}
		
		public function heartState(param1:String) : void {
			this._mcScoreHeart.gotoAndStop(param1);
		}
		
		public function destory() : void {
			this._mcScoreHeart.stop();
			if(this._mcScoreHeart.parent) {
				this._mcScoreHeart.parent.removeChild(this._mcScoreHeart);
			}
			this._mcScoreHeart = null;
		}
	}
}
