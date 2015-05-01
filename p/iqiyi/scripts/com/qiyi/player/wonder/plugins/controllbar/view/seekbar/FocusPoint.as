package com.qiyi.player.wonder.plugins.controllbar.view.seekbar {
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.filters.GlowFilter;
	import flash.events.MouseEvent;
	
	public class FocusPoint extends Sprite {
		
		public function FocusPoint() {
			super();
			this._circleFilter = new GlowFilter(16777215,1,4,4,5);
			this._circleSprite = new Sprite();
			addChild(this._circleSprite);
			this._mouseShape = new Shape();
			addChild(this._mouseShape);
			addEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOver);
			addEventListener(MouseEvent.ROLL_OUT,this.onMouseRollOut);
		}
		
		public var time:Number = 0;
		
		public var content:String = "";
		
		public var imgUrl:String = "";
		
		public var goodsUrl:String = "";
		
		private var _mouseShape:Shape;
		
		private var _circleSprite:Sprite;
		
		private var _circleFilter:GlowFilter;
		
		public function resize(param1:Number) : void {
			this._circleSprite.graphics.clear();
			this._circleSprite.graphics.lineStyle(0,0,0);
			this._circleSprite.graphics.beginFill(16777215,0.7);
			this._circleSprite.graphics.drawCircle(param1,8,param1);
			this._circleSprite.graphics.endFill();
			this._mouseShape.graphics.clear();
			this._mouseShape.graphics.beginFill(0,0);
			this._mouseShape.graphics.drawRect(-2,0,8,16);
			this._mouseShape.graphics.endFill();
		}
		
		private function onMouseRollOver(param1:MouseEvent) : void {
			this._circleSprite.filters = [this._circleFilter];
		}
		
		private function onMouseRollOut(param1:MouseEvent) : void {
			this._circleSprite.filters = null;
		}
	}
}
