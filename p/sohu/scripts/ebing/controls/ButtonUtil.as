package ebing.controls {
	import flash.display.Sprite;
	import flash.display.InteractiveObject;
	import flash.text.TextField;
	import flash.display.MovieClip;
	import ebing.Utils;
	import flash.events.MouseEvent;
	import ebing.events.MouseEventUtil;
	
	public class ButtonUtil extends Sprite {
		
		public function ButtonUtil(param1:Object) {
			super();
			this.init(param1);
		}
		
		public static function register(param1:InteractiveObject, param2:Boolean = false) : void {
			new ButtonUtil({
				"label":"",
				"tip":null,
				"mouseTip":null,
				"skin":null,
				"target":param1
			});
		}
		
		public static function unregister(param1:InteractiveObject) : void {
		}
		
		protected var _label_txt:TextField;
		
		protected var _label_str:String;
		
		protected var _tip_str:String;
		
		protected var _mouseTip_mt:MouseTipUtil;
		
		protected var _skin_mc:MovieClip;
		
		protected var _releaseOutFlag_boo:Boolean;
		
		protected var _enabled_boo:Boolean = true;
		
		protected var _obj:Object;
		
		protected var _target;
		
		private var K10260394D5A06348D340989794B433A3AEDD61373566K:Sprite;
		
		public function init(param1:Object) : void {
			this._label_str = param1.label == null?"":param1.label;
			this._tip_str = param1.tip;
			this._mouseTip_mt = param1.mouseTip;
			this._target = param1.target != undefined?param1.target:this;
			this._skin_mc = param1.skin;
			if(!(this._skin_mc == null) && param1.showTip == true) {
				this.K10260394D5A06348D340989794B433A3AEDD61373566K = new Sprite();
				Utils.drawRect(this.K10260394D5A06348D340989794B433A3AEDD61373566K,0,0,this._skin_mc.width,this._skin_mc.height,0,0);
				this.hitArea = this.K10260394D5A06348D340989794B433A3AEDD61373566K;
			}
			this.sysInit();
			this.addEvent();
		}
		
		protected function sysInit() : void {
			if(this._skin_mc != null) {
				this._obj = new Object();
				this._skin_mc.gotoAndStop(1);
				this._skin_mc.x = this._skin_mc.y = 0;
				addChild(this._skin_mc);
				if(this.K10260394D5A06348D340989794B433A3AEDD61373566K != null) {
					addChild(this.K10260394D5A06348D340989794B433A3AEDD61373566K);
				}
			}
			this._target.buttonMode = true;
			this._target.mouseChildren = false;
			this._target.useHandCursor = true;
			this._target.doubleClickEnabled = true;
		}
		
		protected function addEvent() : void {
			this._target.addEventListener(MouseEvent.MOUSE_DOWN,this.downHandler);
			this._target.addEventListener(MouseEvent.MOUSE_OVER,this.overHandler);
			this._target.addEventListener(MouseEvent.MOUSE_UP,this.upHandler);
			this._target.addEventListener(MouseEvent.MOUSE_OUT,this.outHandler);
			this._target.addEventListener(MouseEvent.MOUSE_MOVE,this.moveHandler);
			this._target.addEventListener(MouseEvent.DOUBLE_CLICK,this.doubleHandler);
			this._target.addEventListener(MouseEvent.CLICK,this.clickHandler);
		}
		
		protected function removeEvent() : void {
			this._target.removeEventListener(MouseEvent.MOUSE_DOWN,this.downHandler);
			this._target.removeEventListener(MouseEvent.MOUSE_OVER,this.overHandler);
			this._target.removeEventListener(MouseEvent.MOUSE_UP,this.upHandler);
			this._target.removeEventListener(MouseEvent.MOUSE_OUT,this.outHandler);
			this._target.removeEventListener(MouseEvent.MOUSE_MOVE,this.moveHandler);
			this._target.removeEventListener(MouseEvent.DOUBLE_CLICK,this.doubleHandler);
			this._target.removeEventListener(MouseEvent.CLICK,this.clickHandler);
		}
		
		protected function clickHandler(param1:MouseEvent) : void {
			this.dispatch(MouseEventUtil.CLICK);
		}
		
		protected function overHandler(param1:MouseEvent) : void {
			if(this._skin_mc != null) {
				this._skin_mc.gotoAndStop(2);
			}
			this.dispatch(MouseEventUtil.MOUSE_OVER,{"data":"xxxxxxxx"});
			if(this._tip_str != null) {
				this._mouseTip_mt.showTip(this._tip_str);
				addChild(this._mouseTip_mt);
			}
		}
		
		protected function downHandler(param1:MouseEvent) : void {
			this._releaseOutFlag_boo = true;
			if(this._skin_mc != null) {
				this._skin_mc.gotoAndStop(3);
			}
			this.dispatch(MouseEventUtil.MOUSE_DOWN);
			this._target.stage.addEventListener(MouseEvent.MOUSE_UP,this.onStageMouseUp);
		}
		
		protected function upHandler(param1:MouseEvent) : void {
			this._target.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onStageMouseUp);
			this._releaseOutFlag_boo = false;
			if(this._skin_mc != null) {
				this._skin_mc.gotoAndStop(1);
			}
			Utils.debug("focus:" + param1.currentTarget);
			if(param1.currentTarget == this._target) {
				this.dispatch(MouseEventUtil.MOUSE_UP);
			}
		}
		
		protected function onStageMouseUp(param1:MouseEvent) : void {
			Utils.debug("onStageMouseUp:" + param1.currentTarget + " _releaseOutFlag_boo:" + this._releaseOutFlag_boo);
			param1.currentTarget.removeEventListener(MouseEvent.MOUSE_UP,this.onStageMouseUp);
			if((this._releaseOutFlag_boo) && !(param1.currentTarget == this._target)) {
				this._releaseOutFlag_boo = false;
				this.dispatch(MouseEventUtil.RELEASE_OUTSIDE);
				trace("evt:" + param1.currentTarget);
			}
		}
		
		protected function outHandler(param1:MouseEvent) : void {
			if(this._skin_mc != null) {
				this._skin_mc.gotoAndStop(1);
			}
			this.dispatch(MouseEventUtil.MOUSE_OUT);
			if(this._tip_str != null) {
				this._mouseTip_mt.removeTip();
				removeChild(this._mouseTip_mt);
			}
		}
		
		protected function moveHandler(param1:MouseEvent) : void {
		}
		
		protected function doubleHandler(param1:MouseEvent) : void {
			this.dispatch(MouseEventUtil.DOUBLE_CLICK);
		}
		
		public function set enabled(param1:Boolean) : void {
			if(this._enabled_boo != param1) {
				this._enabled_boo = param1;
				if(param1) {
					this._target.buttonMode = true;
					this._target.useHandCursor = true;
					if(this._skin_mc != null) {
						this._skin_mc.gotoAndStop(1);
					}
					this.addEvent();
				} else {
					this._target.buttonMode = false;
					this._target.useHandCursor = false;
					if(this._skin_mc != null) {
						this._skin_mc.gotoAndStop(4);
					}
					this.removeEvent();
				}
			}
		}
		
		public function get enabled() : Boolean {
			return this._enabled_boo;
		}
		
		override public function get width() : Number {
			var _loc1_:Number = super.width;
			if(this.K10260394D5A06348D340989794B433A3AEDD61373566K != null) {
				_loc1_ = this.K10260394D5A06348D340989794B433A3AEDD61373566K.width;
			}
			return _loc1_;
		}
		
		override public function get height() : Number {
			var _loc1_:Number = super.height;
			if(this.K10260394D5A06348D340989794B433A3AEDD61373566K != null) {
				_loc1_ = this.K10260394D5A06348D340989794B433A3AEDD61373566K.height;
			}
			return _loc1_;
		}
		
		public function get skin() : MovieClip {
			return this._skin_mc;
		}
		
		public function get obj() : Object {
			return this._obj;
		}
		
		public function set obj(param1:Object) : void {
			this._obj = param1;
		}
		
		public function dispatch(param1:String, param2:Object = null) : void {
			var _loc3_:MouseEventUtil = new MouseEventUtil(param1);
			_loc3_.obj = param2;
			this._target.dispatchEvent(_loc3_);
		}
	}
}
