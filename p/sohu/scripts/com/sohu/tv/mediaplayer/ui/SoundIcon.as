package com.sohu.tv.mediaplayer.ui {
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	
	public class SoundIcon extends Sprite {
		
		public function SoundIcon() {
			super();
			this.init();
		}
		
		private var _soundIcon:Shape;
		
		private var _soundIconMute:Shape;
		
		private var _icon:Sprite;
		
		private var _soundState:Boolean;
		
		private function init() : void {
			this._soundIcon = new Shape();
			this._soundIcon.graphics.lineStyle(0,16777215,1);
			this._soundIcon.graphics.moveTo(1,4);
			this._soundIcon.graphics.beginFill(16777215,1);
			this._soundIcon.graphics.lineTo(5,4);
			this._soundIcon.graphics.lineTo(9,0.5);
			this._soundIcon.graphics.lineTo(9,12);
			this._soundIcon.graphics.lineTo(5,8);
			this._soundIcon.graphics.lineTo(1,8);
			this._soundIcon.graphics.lineTo(1,4);
			this._soundIcon.graphics.endFill();
			this._soundIcon.graphics.lineStyle(1.5,16777215,1);
			this._soundIcon.graphics.moveTo(13,5);
			this._soundIcon.graphics.lineTo(13,7);
			this._soundIcon.graphics.moveTo(15,2.5);
			this._soundIcon.graphics.curveTo(18,6,15,10);
			this._soundIconMute = new Shape();
			this._soundIconMute.graphics.lineStyle(0,16777215,1);
			this._soundIconMute.graphics.moveTo(1,4);
			this._soundIconMute.graphics.beginFill(16777215,1);
			this._soundIconMute.graphics.lineTo(5,4);
			this._soundIconMute.graphics.lineTo(9,0.5);
			this._soundIconMute.graphics.lineTo(9,12);
			this._soundIconMute.graphics.lineTo(5,8);
			this._soundIconMute.graphics.lineTo(1,8);
			this._soundIconMute.graphics.lineTo(1,4);
			this._soundIconMute.graphics.endFill();
			this._soundIconMute.graphics.lineStyle(1.5,16777215,1);
			this._soundIconMute.graphics.moveTo(12,3.5);
			this._soundIconMute.graphics.lineTo(17,8.5);
			this._soundIconMute.graphics.moveTo(12,8.5);
			this._soundIconMute.graphics.lineTo(17,3.5);
			this._icon = new Sprite();
			this._icon.graphics.beginFill(0,0);
			this._icon.graphics.drawRect(0,0,22,14);
			this._icon.graphics.endFill();
			this._icon.addChild(this._soundIcon);
			this._icon.addChild(this._soundIconMute);
			this._icon.buttonMode = true;
			addChild(this._icon);
			this._soundState = true;
			this.iconStatus();
			this._icon.addEventListener(MouseEvent.MOUSE_DOWN,this.iconClickHandler);
		}
		
		private function iconClickHandler(param1:MouseEvent) : void {
			this._soundState = !this._soundState;
			this.iconStatus();
		}
		
		private function iconStatus() : void {
			if(!this._soundState) {
				this._soundIcon.visible = false;
				this._soundIconMute.visible = true;
			} else {
				this._soundIconMute.visible = false;
				this._soundIcon.visible = true;
			}
		}
		
		public function get soundState() : Boolean {
			return this._soundState;
		}
		
		public function set soundState(param1:Boolean) : void {
			this._soundState = param1;
			this.iconStatus();
		}
	}
}
