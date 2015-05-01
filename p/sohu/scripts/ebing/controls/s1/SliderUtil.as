package ebing.controls.s1 {
	import flash.display.Sprite;
	import ebing.controls.*;
	import flash.events.*;
	import ebing.Utils;
	import ebing.events.MouseEventUtil;
	import ebing.events.SliderEventUtil;
	
	public class SliderUtil extends Sprite {
		
		public function SliderUtil(param1:Object) {
			super();
			this.init(param1);
		}
		
		protected var _skin_spr;
		
		protected var _dollop_btn:ButtonUtil;
		
		protected var _top_mc;
		
		protected var _middle_mc;
		
		protected var _bottom_mc;
		
		protected var _mouseTip_obj:Object;
		
		protected var _btn_mt:MouseTipUtil;
		
		protected var _btnMt_str:String;
		
		protected var _topRate_num:Number = 0;
		
		protected var _middleRate_num:Number = 0;
		
		protected var _isSliderEnd:Boolean = false;
		
		protected var _hit_spr:Sprite;
		
		protected var _container:Sprite;
		
		private var _width:Number = 0;
		
		private var _height:Number = 0;
		
		private var _enabled_boo:Boolean = true;
		
		protected var _isDrag:Boolean = true;
		
		public function init(param1:Object) : void {
			this._dollop_btn = param1.skin.dollop;
			this._top_mc = param1.skin.top;
			this._middle_mc = param1.skin.middle;
			this._bottom_mc = param1.skin.bottom;
			this._isDrag = param1.isDrag;
			this.sysInit("start");
		}
		
		public function set isDrag(param1:Boolean) : void {
			this._isDrag = param1;
		}
		
		public function resize(param1:Number) : void {
			this._width = this._bottom_mc.width = param1;
			this.topRate = this.topRate;
			this.middleRate = this.middleRate;
		}
		
		protected function sysInit(param1:String) : void {
			if(param1 == "start") {
				this._hit_spr = new Sprite();
				Utils.drawRect(this._hit_spr,0,0,1,this._middle_mc.height,16777215,0);
				this.newFunc();
				this.drawSkin();
				this.addEvent();
				this._hit_spr.buttonMode = true;
			}
		}
		
		protected function drawSkin() : void {
			this._container = new Sprite();
			var _loc1_:Number = Utils.getMaxWidth([this._top_mc,this._middle_mc,this._bottom_mc,this._dollop_btn,this._hit_spr]);
			var _loc2_:Number = Utils.getMaxHeight([this._top_mc,this._middle_mc,this._bottom_mc,this._dollop_btn,this._hit_spr]);
			this._width = this._bottom_mc.width;
			this._height = _loc2_;
			this._container.addChild(this._bottom_mc);
			this._container.addChild(this._middle_mc);
			this._container.addChild(this._top_mc);
			this._container.addChild(this._hit_spr);
			this._container.addChild(this._dollop_btn);
			Utils.setCenterByNumber(this._bottom_mc,_loc1_,_loc2_);
			Utils.setCenterByNumber(this._middle_mc,_loc1_,_loc2_);
			Utils.setCenterByNumber(this._dollop_btn,_loc1_,_loc2_);
			Utils.setCenterByNumber(this._top_mc,_loc1_,_loc2_);
			Utils.setCenterByNumber(this._hit_spr,_loc1_,_loc2_);
			this._bottom_mc.x = this._middle_mc.x = this._top_mc.x = this._dollop_btn.x = this._hit_spr.x = 0;
			this._top_mc.width = this._middle_mc.width = 0;
			addChild(this._container);
			this._container.x = this._container.y = 0;
		}
		
		protected function newFunc() : void {
		}
		
		protected function addEvent() : void {
			ButtonUtil.register(this._hit_spr);
			this._dollop_btn.addEventListener(MouseEventUtil.MOUSE_DOWN,this.downHandler);
			this._dollop_btn.addEventListener(MouseEventUtil.MOUSE_UP,this.upHandler);
			this._dollop_btn.addEventListener(MouseEventUtil.RELEASE_OUTSIDE,this.upHandler);
			this._hit_spr.addEventListener(MouseEventUtil.MOUSE_DOWN,this.downHandler);
		}
		
		protected function enabledHandler(param1:MouseEventUtil) : void {
			trace("stop1");
			if(!this._enabled_boo) {
				trace("stop");
				param1.stopImmediatePropagation();
			}
		}
		
		protected function moveHandler(param1:MouseEvent) : void {
			trace("evt.buttonDown:" + param1.buttonDown);
			if(param1.buttonDown) {
				this.doSlide(this._container.mouseX,0);
			}
		}
		
		protected function doSlide(param1:Number, param2:Number) : void {
			this._topRate_num = this.getTopRate(param1);
			this._dollop_btn.x = this._topRate_num * (this._bottom_mc.width - this._dollop_btn.width);
			this._top_mc.width = this._dollop_btn.x + this._dollop_btn.width / 2;
			if(this._topRate_num == 0) {
				this._top_mc.visible = false;
			} else {
				this._top_mc.visible = true;
			}
			this.dispatch(SliderEventUtil.SLIDER_RATE,{
				"rate":this._topRate_num,
				"sign":param2
			});
		}
		
		protected function getTopRate(param1:Number) : Number {
			var _loc2_:Number = param1;
			var _loc3_:Number = this._dollop_btn.width / 2;
			var _loc4_:* = this._isDrag?this._bottom_mc:this._middle_mc;
			if(_loc2_ <= _loc3_) {
				_loc2_ = _loc3_;
			} else if(_loc2_ >= _loc4_.width - _loc3_) {
				_loc2_ = _loc4_.width - _loc3_;
			}
			
			return (_loc2_ - _loc3_) / (this._bottom_mc.width - this._dollop_btn.width);
		}
		
		protected function downHandler(param1:MouseEventUtil) : void {
			var _loc2_:MouseEvent = null;
			switch(param1.target) {
				case this._dollop_btn:
					this.dispatch(SliderEventUtil.SLIDE_START);
					this._isSliderEnd = false;
					trace("-------------stage:" + stage,"MOUSE_MOVE:" + MouseEvent.MOUSE_MOVE,"moveHandler:" + this.moveHandler);
					stage.addEventListener(MouseEvent.MOUSE_MOVE,this.moveHandler);
					_loc2_ = new MouseEvent(MouseEvent.MOUSE_MOVE);
					_loc2_.buttonDown = true;
					this.moveHandler(_loc2_);
					break;
				case this._hit_spr:
					this.doSlide(this._container.mouseX,1);
					this.dispatch(SliderEventUtil.SLIDE_END,{"sign":1});
					this._isSliderEnd = true;
					break;
			}
		}
		
		protected function upHandler(param1:MouseEventUtil) : void {
			trace("--------:" + param1.target);
			switch(param1.target) {
				case this._dollop_btn:
					if(!this._isSliderEnd) {
						this.dispatch(SliderEventUtil.SLIDE_END,{
							"sign":0,
							"rate":this._topRate_num
						});
					}
					stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.moveHandler);
					break;
			}
			param1.target.stopDrag();
		}
		
		public function get topRate() : Number {
			return this._topRate_num;
		}
		
		public function get middleRate() : Number {
			return this._middleRate_num;
		}
		
		public function set topRate(param1:Number) : void {
			if(param1 >= 0 && param1 <= 1) {
				this._topRate_num = param1;
				this._top_mc.width = this._topRate_num * (this._bottom_mc.width - this._dollop_btn.width) + this._dollop_btn.width / 2;
				this._dollop_btn.x = Math.floor(this._top_mc.width - this._dollop_btn.width / 2);
				if(this._topRate_num == 0) {
					this._top_mc.visible = false;
				} else {
					this._top_mc.visible = true;
				}
			}
		}
		
		public function set enabled(param1:Boolean) : void {
			if(this._enabled_boo != param1) {
				this._enabled_boo = param1;
				this._dollop_btn.enabled = param1;
				if(param1) {
					this._hit_spr.buttonMode = true;
					if(!this._hit_spr.hasEventListener(MouseEventUtil.MOUSE_DOWN)) {
						this._hit_spr.addEventListener(MouseEventUtil.MOUSE_DOWN,this.downHandler);
					}
					if(!this._dollop_btn.hasEventListener(MouseEventUtil.MOUSE_DOWN) && !this._dollop_btn.hasEventListener(MouseEventUtil.MOUSE_UP) && !this._dollop_btn.hasEventListener(MouseEventUtil.RELEASE_OUTSIDE)) {
						this._dollop_btn.addEventListener(MouseEventUtil.MOUSE_DOWN,this.downHandler);
						this._dollop_btn.addEventListener(MouseEventUtil.MOUSE_UP,this.upHandler);
						this._dollop_btn.addEventListener(MouseEventUtil.RELEASE_OUTSIDE,this.upHandler);
					}
				} else {
					this._hit_spr.buttonMode = false;
					this._hit_spr.removeEventListener(MouseEventUtil.MOUSE_DOWN,this.downHandler);
					this._dollop_btn.removeEventListener(MouseEventUtil.MOUSE_DOWN,this.downHandler);
					this._dollop_btn.removeEventListener(MouseEventUtil.MOUSE_UP,this.upHandler);
					this._dollop_btn.removeEventListener(MouseEventUtil.RELEASE_OUTSIDE,this.upHandler);
				}
			}
		}
		
		public function get enabled() : Boolean {
			return this._enabled_boo;
		}
		
		override public function get width() : Number {
			trace("SliderUtil width");
			return this._width;
		}
		
		override public function get height() : Number {
			trace("SliderUtil height");
			return this._height;
		}
		
		public function set middleRate(param1:Number) : void {
			if(param1 >= 0 && param1 <= 1) {
				this._middleRate_num = param1;
				if(this._isDrag) {
					this._hit_spr.width = this._bottom_mc.width;
				} else {
					this._hit_spr.width = this._middle_mc.width = this._bottom_mc.width * this._middleRate_num;
				}
				this._middle_mc.width = this._bottom_mc.width * this._middleRate_num;
			}
		}
		
		public function dispatch(param1:String, param2:Object = null) : void {
			var _loc3_:SliderEventUtil = new SliderEventUtil(param1);
			_loc3_.obj = param2;
			dispatchEvent(_loc3_);
		}
	}
}
