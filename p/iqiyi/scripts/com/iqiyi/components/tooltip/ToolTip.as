package com.iqiyi.components.tooltip {
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import flash.utils.Timer;
	import flash.display.InteractiveObject;
	import flash.utils.Dictionary;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	
	public final class ToolTip extends Object {
		
		public function ToolTip(param1:SingletonClass) {
			super();
			this._timer = new Timer(0,1);
			this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeOnAction);
			this._table = new Dictionary();
			this._offest = new Point(4,20);
			this.setDefaultToolTip(new DefaultToolTip());
		}
		
		private static var _instance:ToolTip;
		
		public static function getInstance() : ToolTip {
			if(_instance == null) {
				_instance = new ToolTip(new SingletonClass());
			}
			return _instance;
		}
		
		private var _offest:Point;
		
		private var _toolTip:DisplayObject;
		
		private var _defaultToolTip:IDefaultToolTip;
		
		private var _timer:Timer;
		
		private var _targetedComponent:InteractiveObject;
		
		private var _table:Dictionary;
		
		private var _stage:Stage;
		
		public function init(param1:Stage) : Boolean {
			if(this._stage == null) {
				this._stage = param1;
				this._stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onCompRollOut);
				return true;
			}
			return false;
		}
		
		public function setDefaultToolTip(param1:IDefaultToolTip) : void {
			if((param1) && param1 is DisplayObject) {
				this._defaultToolTip = param1;
			}
		}
		
		public function setOffest(param1:int, param2:int) : void {
			this._offest.x = param1;
			this._offest.y = param2;
		}
		
		public function containsKey(param1:InteractiveObject) : Boolean {
			return !(this._table[param1] == undefined);
		}
		
		public function isOnStage() : Boolean {
			return (this._toolTip) && (this._toolTip.stage);
		}
		
		public function updateTips(param1:InteractiveObject) : void {
			if(!(param1 == null) && (this.isOnStage()) && this._targetedComponent == param1) {
				this.showTips();
			}
		}
		
		public function registerComponent(param1:InteractiveObject, param2:Object = null, param3:int = 400, param4:Point = null) : void {
			var _loc5_:Info = null;
			if(param1 != null) {
				if(param2 == null) {
					this.unregisterComponent(param1);
				} else if(!this.containsKey(param1)) {
					this.listenOwner(param1);
					this._table[param1] = new Info(param2,param3,param4);
				} else {
					_loc5_ = this._table[param1] as ToolTip;
					_loc5_.showObject = param2;
					_loc5_.timelag = param3;
					_loc5_.fixedOffestPosition = param4;
				}
				
			}
		}
		
		public function unregisterComponent(param1:InteractiveObject) : void {
			if((param1) && (this.containsKey(param1))) {
				this.unlistenOwner(param1);
				this._table[param1] = null;
				delete this._table[param1];
				true;
			}
		}
		
		public function updateFixedOffestPosition(param1:InteractiveObject, param2:Point = null) : void {
			var _loc3_:Info = null;
			if(param1 != null) {
				if(this.containsKey(param1)) {
					_loc3_ = this._table[param1] as ToolTip;
					_loc3_.fixedOffestPosition = param2;
				}
			}
		}
		
		private function unlistenOwner(param1:InteractiveObject) : void {
			param1.removeEventListener(MouseEvent.ROLL_OVER,this.onCompRollOver);
			param1.removeEventListener(MouseEvent.ROLL_OUT,this.onCompRollOut);
			param1.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoved);
		}
		
		private function listenOwner(param1:InteractiveObject) : void {
			param1.addEventListener(MouseEvent.ROLL_OVER,this.onCompRollOver);
			param1.addEventListener(MouseEvent.ROLL_OUT,this.onCompRollOut);
			param1.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoved);
		}
		
		private function onTimeOnAction(param1:TimerEvent) : void {
			this.showTips();
		}
		
		private function onCompRollOver(param1:MouseEvent) : void {
			var _loc2_:Info = null;
			if(this.containsKey(param1.target as InteractiveObject)) {
				this._targetedComponent = param1.target as InteractiveObject;
				_loc2_ = this._table[this._targetedComponent] as ToolTip;
				if(_loc2_.timelag > 0) {
					this._timer.delay = _loc2_.timelag;
					if(!this._timer.running) {
						this._timer.start();
					}
				} else {
					this.showTips();
				}
			}
		}
		
		private function onCompRollOut(param1:MouseEvent) : void {
			if(this._timer.running) {
				this._timer.stop();
			}
			if(this._toolTip) {
				if(this._stage.contains(this._toolTip)) {
					this._stage.removeChild(this._toolTip);
				}
				this._targetedComponent = null;
				this._toolTip = null;
			}
		}
		
		private function onMouseMoved(param1:MouseEvent) : void {
			if(this._toolTip) {
				this.updateCoord();
			}
		}
		
		private function updateCoord() : void {
			var _loc1_:Info = null;
			var _loc2_:Point = null;
			var _loc3_:* = NaN;
			var _loc4_:* = NaN;
			if((this.isOnStage()) && (this._targetedComponent)) {
				_loc1_ = this._table[this._targetedComponent] as ToolTip;
				_loc2_ = null;
				if((_loc1_) && (_loc1_.fixedOffestPosition) && (this._targetedComponent.parent)) {
					_loc2_ = new Point(_loc1_.fixedOffestPosition.x + this._targetedComponent.x,_loc1_.fixedOffestPosition.y + this._targetedComponent.y);
					_loc2_ = this._targetedComponent.parent.localToGlobal(_loc2_);
					this._toolTip.x = _loc2_.x;
					this._toolTip.y = _loc2_.y;
				} else {
					_loc3_ = this._stage.stageWidth;
					_loc4_ = this._stage.stageHeight;
					_loc2_ = new Point(this._stage.mouseX,this._stage.mouseY);
					_loc2_.x = _loc2_.x + this._offest.x;
					_loc2_.y = _loc2_.y + this._offest.y;
					if(_loc2_.x + this._toolTip.width > _loc3_) {
						_loc2_.x = _loc2_.x - (this._toolTip.width + this._offest.x * 2);
					}
					if(_loc2_.y + this._toolTip.height > _loc4_) {
						_loc2_.y = _loc2_.y - (this._toolTip.height + this._offest.y + this._offest.x);
					}
					if(_loc2_.x < 0) {
						_loc2_.x = 0;
					}
					if(_loc2_.y < 0) {
						_loc2_.y = 0;
					}
					_loc2_ = this._stage.globalToLocal(_loc2_);
					this._toolTip.x = _loc2_.x;
					this._toolTip.y = _loc2_.y;
				}
			}
		}
		
		private function showTips() : void {
			var _loc1_:Info = null;
			var _loc2_:Object = null;
			var _loc3_:Object = null;
			if((this._targetedComponent) && (this.containsKey(this._targetedComponent)) && (this._stage)) {
				_loc1_ = this._table[this._targetedComponent] as ToolTip;
				_loc2_ = _loc1_.showObject;
				_loc3_ = null;
				this._defaultToolTip.text = "";
				if(this._toolTip) {
					if(this._stage.contains(this._toolTip)) {
						this._stage.removeChild(this._toolTip);
					}
					this._toolTip = null;
				}
				if(_loc2_ is DisplayObject) {
					this._toolTip = _loc2_ as DisplayObject;
				} else {
					if(_loc2_ is String) {
						if(String(_loc2_) == "") {
							return;
						}
						this._defaultToolTip.htmlText = String(_loc2_);
					} else if(_loc2_ is Function) {
						_loc3_ = _loc2_();
						if(_loc3_ is DisplayObject) {
							this._toolTip = _loc3_ as DisplayObject;
						} else if(_loc3_ is String) {
							if(String(_loc3_) == "") {
								return;
							}
							this._defaultToolTip.htmlText = String(_loc3_);
						}
						
					}
					
					if(this._toolTip == null) {
						this._toolTip = this._defaultToolTip as DisplayObject;
					}
				}
				this._stage.addChild(this._toolTip);
				this.updateCoord();
			}
		}
	}
}
import flash.geom.Point;

class Info extends Object {
	
	function Info(param1:Object = null, param2:int = 400, param3:Point = null) {
		super();
		this.showObject = param1;
		this.timelag = param2;
		this.fixedOffestPosition = param3;
	}
	
	public var showObject:Object;
	
	public var timelag:int;
	
	public var fixedOffestPosition:Point;
}
class SingletonClass extends Object {
	
	function SingletonClass() {
		super();
	}
}
