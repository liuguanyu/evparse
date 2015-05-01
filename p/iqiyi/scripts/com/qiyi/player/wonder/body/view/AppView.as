package com.qiyi.player.wonder.body.view {
	import flash.display.Sprite;
	import com.iqiyi.components.global.GlobalStage;
	import com.qiyi.player.wonder.common.config.FlashVarConfig;
	import flash.events.MouseEvent;
	import gs.TweenLite;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	
	public class AppView extends Sprite {
		
		public function AppView() {
			super();
			this.initLayer();
			GlobalStage.stage.addEventListener(Event.RESIZE,this.onStageResize);
			GlobalStage.stage.addEventListener(FullScreenEvent.FULL_SCREEN,this.onFullScreen);
			GlobalStage.stage.addEventListener(Event.MOUSE_LEAVE,this.onMouseLeaveStage);
		}
		
		private var _curVideoLayer:Sprite;
		
		private var _preVideoLayer:Sprite;
		
		private var _mouseClickLayer:Sprite;
		
		private var _barrageLayer:Sprite;
		
		private var _ADLayer:Sprite;
		
		private var _fixLayer:Sprite;
		
		private var _fixSub1Layer:Sprite;
		
		private var _sceneTileToolLayer:Sprite;
		
		private var _popupLayer:Sprite;
		
		public function get curVideoLayer() : Sprite {
			return this._curVideoLayer;
		}
		
		public function get preVideoLayer() : Sprite {
			return this._preVideoLayer;
		}
		
		public function get barrageLayer() : Sprite {
			return this._barrageLayer;
		}
		
		public function get ADLayer() : Sprite {
			return this._ADLayer;
		}
		
		public function get fixLayer() : Sprite {
			return this._fixLayer;
		}
		
		public function get fixSub1Layer() : Sprite {
			return this._fixSub1Layer;
		}
		
		public function get sceneTileToolLayer() : Sprite {
			return this._sceneTileToolLayer;
		}
		
		public function get popupLayer() : Sprite {
			return this._popupLayer;
		}
		
		public function switchPreLayer() : void {
			removeChild(this._curVideoLayer);
			addChildAt(this._preVideoLayer,0);
			var _loc1_:Sprite = this._curVideoLayer;
			this._curVideoLayer = this._preVideoLayer;
			this._preVideoLayer = _loc1_;
		}
		
		private function initLayer() : void {
			this._curVideoLayer = new Sprite();
			addChildAt(this._curVideoLayer,0);
			this._preVideoLayer = new Sprite();
			this._mouseClickLayer = new Sprite();
			this._mouseClickLayer.graphics.beginFill(0,0);
			this._mouseClickLayer.graphics.drawRect(0,0,1,1);
			this._mouseClickLayer.graphics.endFill();
			this._mouseClickLayer.width = GlobalStage.stage.stageWidth;
			this._mouseClickLayer.height = GlobalStage.stage.stageHeight;
			this._mouseClickLayer.doubleClickEnabled = true;
			if(FlashVarConfig.owner == FlashVarConfig.OWNER_CLIENT) {
				GlobalStage.stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseLayerClick);
			} else {
				this._mouseClickLayer.addEventListener(MouseEvent.CLICK,this.onMouseLayerClick);
			}
			this._mouseClickLayer.addEventListener(MouseEvent.DOUBLE_CLICK,this.onMouseLayerDoubleClick);
			addChild(this._mouseClickLayer);
			this._barrageLayer = new Sprite();
			addChild(this._barrageLayer);
			this._ADLayer = new Sprite();
			addChild(this._ADLayer);
			this._fixLayer = new Sprite();
			addChild(this._fixLayer);
			this._fixSub1Layer = new Sprite();
			this._fixLayer.addChild(this._fixSub1Layer);
			this._sceneTileToolLayer = new Sprite();
			addChild(this._sceneTileToolLayer);
			this._popupLayer = new Sprite();
			addChild(this._popupLayer);
		}
		
		private function onMouseLayerClick(param1:MouseEvent) : void {
			if(FlashVarConfig.owner == FlashVarConfig.OWNER_CLIENT) {
				if(param1.target == GlobalStage.stage && param1.delta == 1) {
					TweenLite.killTweensOf(this.onMouseLayerClickHandler);
					TweenLite.delayedCall(0.35,this.onMouseLayerClickHandler);
				}
			} else {
				TweenLite.killTweensOf(this.onMouseLayerClickHandler);
				TweenLite.delayedCall(0.35,this.onMouseLayerClickHandler);
			}
		}
		
		private function onMouseLayerClickHandler() : void {
			dispatchEvent(new BodyEvent(BodyEvent.Evt_MouseLayerClick));
		}
		
		private function onMouseLayerDoubleClick(param1:MouseEvent) : void {
			TweenLite.killTweensOf(this.onMouseLayerClickHandler);
			dispatchEvent(new BodyEvent(BodyEvent.Evt_MouseLayerDoubleClick));
		}
		
		private function onStageResize(param1:Event) : void {
			this._mouseClickLayer.width = GlobalStage.stage.stageWidth;
			this._mouseClickLayer.height = GlobalStage.stage.stageHeight;
			dispatchEvent(new BodyEvent(BodyEvent.Evt_StageResize));
		}
		
		private function onFullScreen(param1:FullScreenEvent) : void {
			dispatchEvent(new BodyEvent(BodyEvent.Evt_FullScreen,param1.fullScreen));
		}
		
		private function onMouseLeaveStage(param1:Event) : void {
			dispatchEvent(new BodyEvent(BodyEvent.Evt_LeaveStage));
		}
	}
}
