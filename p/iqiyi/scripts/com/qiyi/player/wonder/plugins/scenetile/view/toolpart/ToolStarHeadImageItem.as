package com.qiyi.player.wonder.plugins.scenetile.view.toolpart {
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.display.Bitmap;
	import scenetile.BarrageStarHeadMC;
	import gs.TweenLite;
	import flash.display.BitmapData;
	import com.qiyi.player.wonder.plugins.scenetile.view.barragepart.BarrageStarHeadImage;
	import flash.events.Event;
	
	public class ToolStarHeadImageItem extends Sprite {
		
		public function ToolStarHeadImageItem(param1:String, param2:uint) {
			super();
			this._headUrl = param1;
			TweenLite.delayedCall(param2 * 0.1,this.init);
		}
		
		private static const HEAD_SIZE:Point = new Point(46,46);
		
		private var _headUrl:String;
		
		private var _starHeadImg:Bitmap;
		
		private var _starHeadMC:BarrageStarHeadMC;
		
		private function init() : void {
			TweenLite.killTweensOf(this.init);
			this._starHeadMC = new BarrageStarHeadMC();
			addChild(this._starHeadMC);
			this._starHeadImg = new Bitmap();
			var _loc1_:BitmapData = null;
			if(this._headUrl) {
				_loc1_ = BarrageStarHeadImage.instance.getHeadImageByUrl(this._headUrl);
			}
			if(_loc1_) {
				this._starHeadImg.bitmapData = _loc1_;
				this._starHeadImg.width = this._starHeadImg.height = HEAD_SIZE.x;
			} else {
				BarrageStarHeadImage.instance.addEventListener(BarrageStarHeadImage.COMPLETE,this.onHeadImgComplete);
			}
			this._starHeadMC.headContainer.addChild(this._starHeadImg);
		}
		
		private function onHeadImgComplete(param1:Event) : void {
			var _loc2_:BitmapData = null;
			if(this._headUrl) {
				_loc2_ = BarrageStarHeadImage.instance.getHeadImageByUrl(this._headUrl);
			}
			if(_loc2_) {
				BarrageStarHeadImage.instance.removeEventListener(BarrageStarHeadImage.COMPLETE,this.onHeadImgComplete);
				this._starHeadImg.bitmapData = _loc2_;
				this._starHeadImg.width = this._starHeadImg.height = HEAD_SIZE.x;
			}
		}
		
		public function destroy() : void {
			TweenLite.killTweensOf(this.init);
			BarrageStarHeadImage.instance.removeEventListener(BarrageStarHeadImage.COMPLETE,this.onHeadImgComplete);
			if(this._starHeadImg) {
				if(this._starHeadImg.parent) {
					this._starHeadImg.parent.removeChild(this._starHeadImg);
				}
				this._starHeadImg.bitmapData = null;
				this._starHeadImg = null;
			}
			if(this._starHeadMC) {
				this._starHeadMC.stop();
				if(this._starHeadMC.parent) {
					this._starHeadMC.parent.removeChild(this._starHeadMC);
				}
				this._starHeadMC = null;
			}
		}
	}
}
