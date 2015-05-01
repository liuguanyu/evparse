package com.qiyi.player.wonder.plugins.feedback.view.parts.copyrightlimited {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class TriangleBtn extends Sprite {
		
		public function TriangleBtn(param1:Number, param2:int = 2, param3:Boolean = true) {
			super();
			buttonMode = true;
			this._hypotenuse = param1;
			switch(param2) {
				case FACE_UP:
					this._vertices = Vector.<Number>([0,this._hypotenuse / 2,this._hypotenuse,this._hypotenuse / 2,this._hypotenuse / 2,0]);
					break;
				case FACE_DOWN:
					this._vertices = Vector.<Number>([0,0,0,this._hypotenuse,this._hypotenuse / 2,this._hypotenuse / 2]);
					break;
				case FACE_LEFT:
					this._vertices = Vector.<Number>([0,this._hypotenuse / 2,this._hypotenuse / 2,0,this._hypotenuse / 2,this._hypotenuse]);
					break;
				case FACE_RIGHT:
					this._vertices = Vector.<Number>([0,0,this._hypotenuse / 2,this._hypotenuse / 2,0,this._hypotenuse]);
					break;
			}
			this.enable = param3;
		}
		
		public static const FACE_UP:int = 0;
		
		public static const FACE_DOWN:int = 1;
		
		public static const FACE_LEFT:int = 2;
		
		public static const FACE_RIGHT:int = 3;
		
		private var _hypotenuse:Number;
		
		private var _enable:Boolean;
		
		private var _vertices:Vector.<Number>;
		
		private var _color:uint;
		
		public function get enable() : Boolean {
			return this._enable;
		}
		
		public function set enable(param1:Boolean) : void {
			this._enable = param1;
			if(this._enable) {
				addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
				addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
				this._color = 16777215;
				this.drawUI(16777215);
			} else {
				removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
				removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
				this._color = 10066329;
				this.drawUI(10066329);
			}
		}
		
		private function drawUI(param1:uint) : void {
			graphics.clear();
			graphics.beginFill(param1);
			graphics.drawTriangles(this._vertices);
			graphics.endFill();
		}
		
		private function onMouseOver(param1:MouseEvent) : void {
			this._color = 10066329;
			this.drawUI(8562957);
		}
		
		private function onMouseOut(param1:MouseEvent) : void {
			if(this._color != 16777215) {
				this.drawUI(16777215);
			}
		}
	}
}
