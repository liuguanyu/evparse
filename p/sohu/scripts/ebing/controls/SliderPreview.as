package ebing.controls {
	import flash.events.*;
	import flash.utils.*;
	import ebing.events.SliderEventUtil;
	import flash.display.MovieClip;
	
	public class SliderPreview extends SliderSpeed {
		
		public function SliderPreview(param1:Object) {
			super(param1);
		}
		
		protected var _previewTip_mc;
		
		private var _enabled_boo:Boolean = false;
		
		private var K1026033AA2253713C54411AA0DDBFDB90B7389373566K:Number = 0;
		
		override public function init(param1:Object) : void {
			this._previewTip_mc = param1.skin.previewTip;
			super.init(param1);
		}
		
		override protected function drawSkin() : void {
			super.drawSkin();
			if(this._previewTip_mc != null) {
				addChild(this._previewTip_mc);
				this._previewTip_mc.visible = false;
				this._previewTip_mc.x = this._previewTip_mc.y = 0;
			}
		}
		
		override protected function addEvent() : void {
			super.addEvent();
			_container.addEventListener(MouseEvent.MOUSE_OVER,this.sliderOverHandler);
		}
		
		protected function sliderOverHandler(param1:MouseEvent) : void {
			var evt:MouseEvent = param1;
			this.K1026033AA2253713C54411AA0DDBFDB90B7389373566K = setTimeout(function():void {
				if(!(_previewTip_mc == null) && (_enabled_boo) && (_isDrag)) {
					stage.addEventListener(MouseEvent.MOUSE_MOVE,sliderMoveHandler);
					stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_MOVE));
				}
			},100);
		}
		
		protected function sliderMoveHandler(param1:MouseEvent) : void {
			var _loc2_:Number = _container.mouseX;
			this._previewTip_mc.x = this.mouseX;
			this._previewTip_mc.y = _hit_spr.y;
			if(_container.hitTestPoint(stage.mouseX,stage.mouseY)) {
				this._previewTip_mc.visible = true;
			} else {
				stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.sliderMoveHandler);
				this._previewTip_mc.visible = false;
			}
			dispatch(SliderEventUtil.SLIDER_PREVIEW_RATE,{"rate":getTopRate(_loc2_)});
		}
		
		public function set previewTip(param1:String) : void {
			if(this._previewTip_mc != null) {
				this._previewTip_mc.time_txt.text = param1;
			}
		}
		
		public function get previewSlip() : MovieClip {
			return this._previewTip_mc;
		}
		
		override public function set enabled(param1:Boolean) : void {
			super.enabled = this._enabled_boo = param1;
			if(_forward_btn != null) {
				_forward_btn.enabled = _back_btn.enabled = param1;
			}
		}
	}
}
