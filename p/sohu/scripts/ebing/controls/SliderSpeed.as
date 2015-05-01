package ebing.controls {
	import ebing.controls.s1.*;
	import flash.events.*;
	import flash.utils.*;
	import ebing.Utils;
	import ebing.events.MouseEventUtil;
	import ebing.events.SliderEventUtil;
	
	public class SliderSpeed extends SliderUtil {
		
		public function SliderSpeed(param1:Object) {
			super(param1);
		}
		
		protected var _forward_btn:ButtonUtil;
		
		protected var _back_btn:ButtonUtil;
		
		protected var _exeId:Number;
		
		protected var _seekNum:Number = -1;
		
		private var _width:Number = 0;
		
		private var _height:Number = 0;
		
		protected var _mouseDownId:Number = 0;
		
		protected var _ttt:Boolean = false;
		
		private var K102603F25C07E72E7B457A86E55A433967646C373566K:Number = 0;
		
		override public function init(param1:Object) : void {
			this._forward_btn = param1.skin.forwardBtn;
			this._back_btn = param1.skin.backBtn;
			super.init(param1);
		}
		
		override protected function drawSkin() : void {
			var _loc1_:* = NaN;
			var _loc2_:* = NaN;
			super.drawSkin();
			if(this._forward_btn != null) {
				_loc1_ = Utils.getMaxWidth([this._back_btn,this._forward_btn,_container]);
				_loc2_ = Utils.getMaxHeight([this._back_btn,this._forward_btn,_container]);
				addChild(this._forward_btn);
				addChild(this._back_btn);
				Utils.setCenterByNumber(this._back_btn,_loc1_,_loc2_);
				Utils.setCenterByNumber(this._forward_btn,_loc1_,_loc2_);
				Utils.setCenterByNumber(_container,_loc1_,_loc2_);
				this._back_btn.x = 0;
				_container.x = this._back_btn.width;
				this._forward_btn.x = _container.x + _container.width;
				this._width = this._forward_btn.x + this._forward_btn.width - this._back_btn.x;
				this._height = _loc2_;
			}
		}
		
		override public function resize(param1:Number) : void {
			this._width = param1;
			super.resize(param1 - (this._forward_btn.width + this._back_btn.width));
			this._forward_btn.x = _container.x + _container.width;
		}
		
		override protected function addEvent() : void {
			super.addEvent();
			if(this._forward_btn != null) {
				this._forward_btn.addEventListener(MouseEventUtil.MOUSE_DOWN,this.downHandler);
				this._forward_btn.addEventListener(MouseEventUtil.MOUSE_UP,this.upHandler);
				this._forward_btn.addEventListener(MouseEventUtil.RELEASE_OUTSIDE,this.upHandler);
				this._back_btn.addEventListener(MouseEventUtil.MOUSE_DOWN,this.downHandler);
				this._back_btn.addEventListener(MouseEventUtil.MOUSE_UP,this.upHandler);
				this._back_btn.addEventListener(MouseEventUtil.RELEASE_OUTSIDE,this.upHandler);
			}
		}
		
		private function onAddStage(param1:Event) : void {
		}
		
		public function backward() : void {
			this._back_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.MOUSE_DOWN));
		}
		
		public function forward() : void {
			this._forward_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.MOUSE_DOWN));
		}
		
		public function stopForward() : void {
			this._forward_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.MOUSE_UP));
		}
		
		public function stopBackward() : void {
			this._back_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.MOUSE_UP));
		}
		
		override protected function downHandler(param1:MouseEventUtil) : void {
			var evt:MouseEventUtil = param1;
			super.downHandler(evt);
			switch(evt.target) {
				case this._forward_btn:
					clearTimeout(this._mouseDownId);
					this._mouseDownId = setTimeout(function():void {
						_ttt = true;
						dispatch(SliderEventUtil.SLIDE_START);
						clearInterval(_exeId);
						_exeId = setInterval(speedForward,20);
					},300);
					break;
				case this._back_btn:
					clearTimeout(this._mouseDownId);
					this._mouseDownId = setTimeout(function():void {
						_ttt = true;
						dispatch(SliderEventUtil.SLIDE_START);
						clearInterval(_exeId);
						_exeId = setInterval(speedBack,20);
					},300);
					break;
			}
		}
		
		override protected function upHandler(param1:MouseEventUtil) : void {
			super.upHandler(param1);
			switch(param1.target) {
				case this._forward_btn:
					clearTimeout(this._mouseDownId);
					clearInterval(this._exeId);
					this._seekNum = -1;
					if(!this._ttt) {
						this.speedForward(true);
					} else {
						this._ttt = false;
					}
					dispatch(SliderEventUtil.SLIDE_END,{
						"sign":0,
						"rate":_topRate_num
					});
					break;
				case this._back_btn:
					clearTimeout(this._mouseDownId);
					clearInterval(this._exeId);
					this._seekNum = -1;
					if(!this._ttt) {
						this.speedBack(true);
					} else {
						this._ttt = false;
					}
					dispatch(SliderEventUtil.SLIDE_END,{
						"sign":0,
						"rate":_topRate_num
					});
					break;
			}
		}
		
		protected function speedForward(param1:Boolean = false) : void {
			trace("speedForward");
			if(this._seekNum == -1) {
				this._seekNum = _dollop_btn.x + _dollop_btn.width / 2;
			}
			this._seekNum = param1?this._seekNum + 3:this._seekNum + 1;
			doSlide(this._seekNum,0);
		}
		
		protected function speedBack(param1:Boolean = false) : void {
			trace("speedBack");
			if(this._seekNum == -1) {
				this._seekNum = _dollop_btn.x + _dollop_btn.width / 2;
			}
			this._seekNum = param1?this._seekNum - 3:this._seekNum - 1;
			doSlide(this._seekNum,0);
		}
		
		override public function get width() : Number {
			return this._width;
		}
		
		override public function get height() : Number {
			trace("SliderSpeed height");
			return this._height;
		}
		
		override public function set enabled(param1:Boolean) : void {
			super.enabled = this._forward_btn.enabled = this._back_btn.enabled = param1;
		}
	}
}
