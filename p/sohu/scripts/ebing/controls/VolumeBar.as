package ebing.controls {
	import flash.display.Sprite;
	import ebing.controls.s1.*;
	import flash.utils.*;
	import ebing.Utils;
	import ebing.events.MouseEventUtil;
	import ebing.events.SliderEventUtil;
	
	public class VolumeBar extends Sprite {
		
		public function VolumeBar(param1:Object) {
			super();
			this.init(param1);
		}
		
		protected var _muteVol_btn:ButtonUtil;
		
		protected var _comebackVol_btn:ButtonUtil;
		
		protected var _volume_num:Number = 0;
		
		protected var _slider:SliderUtil;
		
		protected var _par:Object;
		
		private var _width:Number = 0;
		
		private var _height:Number = 0;
		
		public function init(param1:Object) : void {
			this._muteVol_btn = param1.skin.muteBtn;
			this._comebackVol_btn = param1.skin.comebackBtn;
			this._par = param1;
			this.sysInit("start");
		}
		
		protected function sysInit(param1:String) : void {
			if(param1 == "start") {
				this.newFunc();
				this.drawSkin();
				this.addEvent();
			}
		}
		
		protected function newFunc() : void {
			this._slider = new SliderUtil(this._par);
		}
		
		protected function drawSkin() : void {
			var _loc1_:Number = Utils.getMaxWidth([this._comebackVol_btn,this._muteVol_btn,this._slider]);
			var _loc2_:Number = Utils.getMaxHeight([this._comebackVol_btn,this._muteVol_btn,this._slider]);
			addChild(this._comebackVol_btn);
			addChild(this._muteVol_btn);
			addChild(this._slider);
			Utils.setCenterByNumber(this._comebackVol_btn,_loc1_,_loc2_);
			Utils.setCenterByNumber(this._muteVol_btn,_loc1_,_loc2_);
			Utils.setCenterByNumber(this._slider,_loc1_,_loc2_);
			this._comebackVol_btn.x = this._comebackVol_btn.y = this._muteVol_btn.x = this._muteVol_btn.y = 0;
			this._slider.x = this._comebackVol_btn.width;
			this._width = this._slider.x + this._slider.width - this._comebackVol_btn.x;
			this._height = _loc2_;
			this._slider.middleRate = 1;
		}
		
		protected function addEvent() : void {
			this._muteVol_btn.addEventListener(MouseEventUtil.CLICK,this.muteVolume);
			this._comebackVol_btn.addEventListener(MouseEventUtil.CLICK,this.comebackVolume);
			this._slider.addEventListener(SliderEventUtil.SLIDER_RATE,this.checkRate);
		}
		
		protected function muteVolume(param1:MouseEventUtil) : void {
			this._volume_num = this._slider.topRate;
			this._slider.topRate = 0;
			this._slider.dispatch(SliderEventUtil.SLIDER_RATE,{"rate":this._slider.topRate});
			this._slider.dispatch(SliderEventUtil.SLIDE_END,{"sign":1});
			param1.target.visible = false;
			this._comebackVol_btn.visible = true;
		}
		
		protected function comebackVolume(param1:MouseEventUtil) : void {
			this._volume_num = this._volume_num > 0?this._volume_num:0.8;
			this._slider.topRate = this._volume_num;
			this._slider.dispatch(SliderEventUtil.SLIDER_RATE,{"rate":this._slider.topRate});
			this._slider.dispatch(SliderEventUtil.SLIDE_END,{"sign":1});
			param1.target.visible = false;
			this._muteVol_btn.visible = true;
		}
		
		protected function checkRate(param1:SliderEventUtil = null) : void {
			if(this._slider.topRate <= 0) {
				this._comebackVol_btn.visible = true;
				this._muteVol_btn.visible = false;
			} else if(this._slider.topRate > 0 && this._slider.topRate <= 1) {
				this._comebackVol_btn.visible = false;
				this._muteVol_btn.visible = true;
			}
			
		}
		
		override public function get width() : Number {
			return this._width;
		}
		
		override public function get height() : Number {
			return this._height;
		}
		
		public function set enabled(param1:Boolean) : void {
			this._slider.enabled = this._muteVol_btn.enabled = this._comebackVol_btn.enabled = param1;
		}
		
		public function get slider() : SliderUtil {
			return this._slider;
		}
		
		public function set rate(param1:Number) : void {
			this._slider.topRate = param1;
			this.checkRate();
		}
	}
}
