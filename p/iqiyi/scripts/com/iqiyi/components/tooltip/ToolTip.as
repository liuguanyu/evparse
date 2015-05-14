package com.iqiyi.components.tooltip
{
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import flash.utils.Timer;
	import flash.display.InteractiveObject;
	import flash.utils.Dictionary;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	
	public final class ToolTip extends Object
	{
		
		private static var _instance:ToolTip;
		
		private var _offest:Point;
		
		private var _toolTip:DisplayObject;
		
		private var _defaultToolTip:IDefaultToolTip;
		
		private var _timer:Timer;
		
		private var _targetedComponent:InteractiveObject;
		
		private var _table:Dictionary;
		
		private var _stage:Stage;
		
		public function ToolTip(param1:SingletonClass)
		{
			super();
			this._timer = new Timer(0,1);
			this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeOnAction);
			this._table = new Dictionary();
			this._offest = new Point(4,20);
			this.setDefaultToolTip(new DefaultToolTip());
		}
		
		public static function getInstance() : ToolTip
		{
			if(_instance == null)
			{
				_instance = new ToolTip(new SingletonClass());
			}
			return _instance;
		}
		
		public function init(param1:Stage) : Boolean
		{
			if(this._stage == null)
			{
				this._stage = param1;
				this._stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onCompRollOut);
				return true;
			}
			return false;
		}
		
		public function setDefaultToolTip(param1:IDefaultToolTip) : void
		{
			if((param1) && param1 is DisplayObject)
			{
				this._defaultToolTip = param1;
			}
		}
		
		public function setOffest(param1:int, param2:int) : void
		{
			this._offest.x = param1;
			this._offest.y = param2;
		}
		
		public function containsKey(param1:InteractiveObject) : Boolean
		{
			return !(this._table[param1] == undefined);
		}
		
		public function isOnStage() : Boolean
		{
			return (this._toolTip) && (this._toolTip.stage);
		}
		
		public function updateTips(param1:InteractiveObject) : void
		{
			if(!(param1 == null) && (this.isOnStage()) && this._targetedComponent == param1)
			{
				this.showTips();
			}
		}
		
		public function registerComponent(param1:InteractiveObject, param2:Object = null, param3:int = 400, param4:Point = null) : void
		{
			var _loc5:Info = null;
			if(param1 != null)
			{
				if(param2 == null)
				{
					this.unregisterComponent(param1);
				}
				else if(!this.containsKey(param1))
				{
					this.listenOwner(param1);
					this._table[param1] = new Info(param2,param3,param4);
				}
				else
				{
					_loc5 = this._table[param1] as ToolTip;
					_loc5.showObject = param2;
					_loc5.timelag = param3;
					_loc5.fixedOffestPosition = param4;
				}
				
			}
		}
		
		public function unregisterComponent(param1:InteractiveObject) : void
		{
			if((param1) && (this.containsKey(param1)))
			{
				this.unlistenOwner(param1);
				this._table[param1] = null;
				delete this._table[param1];
				true;
			}
		}
		
		public function updateFixedOffestPosition(param1:InteractiveObject, param2:Point = null) : void
		{
			var _loc3:Info = null;
			if(param1 != null)
			{
				if(this.containsKey(param1))
				{
					_loc3 = this._table[param1] as ToolTip;
					_loc3.fixedOffestPosition = param2;
				}
			}
		}
		
		private function unlistenOwner(param1:InteractiveObject) : void
		{
			param1.removeEventListener(MouseEvent.ROLL_OVER,this.onCompRollOver);
			param1.removeEventListener(MouseEvent.ROLL_OUT,this.onCompRollOut);
			param1.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoved);
		}
		
		private function listenOwner(param1:InteractiveObject) : void
		{
			param1.addEventListener(MouseEvent.ROLL_OVER,this.onCompRollOver);
			param1.addEventListener(MouseEvent.ROLL_OUT,this.onCompRollOut);
			param1.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoved);
		}
		
		private function onTimeOnAction(param1:TimerEvent) : void
		{
			this.showTips();
		}
		
		private function onCompRollOver(param1:MouseEvent) : void
		{
			var _loc2:Info = null;
			if(this.containsKey(param1.target as InteractiveObject))
			{
				this._targetedComponent = param1.target as InteractiveObject;
				_loc2 = this._table[this._targetedComponent] as ToolTip;
				if(_loc2.timelag > 0)
				{
					this._timer.delay = _loc2.timelag;
					if(!this._timer.running)
					{
						this._timer.start();
					}
				}
				else
				{
					this.showTips();
				}
			}
		}
		
		private function onCompRollOut(param1:MouseEvent) : void
		{
			if(this._timer.running)
			{
				this._timer.stop();
			}
			if(this._toolTip)
			{
				if(this._stage.contains(this._toolTip))
				{
					this._stage.removeChild(this._toolTip);
				}
				this._targetedComponent = null;
				this._toolTip = null;
			}
		}
		
		private function onMouseMoved(param1:MouseEvent) : void
		{
			if(this._toolTip)
			{
				this.updateCoord();
			}
		}
		
		private function updateCoord() : void
		{
			var _loc1:Info = null;
			var _loc2:Point = null;
			var _loc3:* = NaN;
			var _loc4:* = NaN;
			if((this.isOnStage()) && (this._targetedComponent))
			{
				_loc1 = this._table[this._targetedComponent] as ToolTip;
				_loc2 = null;
				if((_loc1) && (_loc1.fixedOffestPosition) && (this._targetedComponent.parent))
				{
					_loc2 = new Point(_loc1.fixedOffestPosition.x + this._targetedComponent.x,_loc1.fixedOffestPosition.y + this._targetedComponent.y);
					_loc2 = this._targetedComponent.parent.localToGlobal(_loc2);
					this._toolTip.x = _loc2.x;
					this._toolTip.y = _loc2.y;
				}
				else
				{
					_loc3 = this._stage.stageWidth;
					_loc4 = this._stage.stageHeight;
					_loc2 = new Point(this._stage.mouseX,this._stage.mouseY);
					_loc2.x = _loc2.x + this._offest.x;
					_loc2.y = _loc2.y + this._offest.y;
					if(_loc2.x + this._toolTip.width > _loc3)
					{
						_loc2.x = _loc2.x - (this._toolTip.width + this._offest.x * 2);
					}
					if(_loc2.y + this._toolTip.height > _loc4)
					{
						_loc2.y = _loc2.y - (this._toolTip.height + this._offest.y + this._offest.x);
					}
					if(_loc2.x < 0)
					{
						_loc2.x = 0;
					}
					if(_loc2.y < 0)
					{
						_loc2.y = 0;
					}
					_loc2 = this._stage.globalToLocal(_loc2);
					this._toolTip.x = _loc2.x;
					this._toolTip.y = _loc2.y;
				}
			}
		}
		
		private function showTips() : void
		{
			var _loc1:Info = null;
			var _loc2:Object = null;
			var _loc3:Object = null;
			if((this._targetedComponent) && (this.containsKey(this._targetedComponent)) && (this._stage))
			{
				_loc1 = this._table[this._targetedComponent] as ToolTip;
				_loc2 = _loc1.showObject;
				_loc3 = null;
				this._defaultToolTip.text = "";
				if(this._toolTip)
				{
					if(this._stage.contains(this._toolTip))
					{
						this._stage.removeChild(this._toolTip);
					}
					this._toolTip = null;
				}
				if(_loc2 is DisplayObject)
				{
					this._toolTip = _loc2 as DisplayObject;
				}
				else
				{
					if(_loc2 is String)
					{
						if(String(_loc2) == "")
						{
							return;
						}
						this._defaultToolTip.htmlText = String(_loc2);
					}
					else if(_loc2 is Function)
					{
						_loc3 = _loc2();
						if(_loc3 is DisplayObject)
						{
							this._toolTip = _loc3 as DisplayObject;
						}
						else if(_loc3 is String)
						{
							if(String(_loc3) == "")
							{
								return;
							}
							this._defaultToolTip.htmlText = String(_loc3);
						}
						
					}
					
					if(this._toolTip == null)
					{
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

class Info extends Object
{
	
	public var showObject:Object;
	
	public var timelag:int;
	
	public var fixedOffestPosition:Point;
	
	function Info(param1:Object = null, param2:int = 400, param3:Point = null)
	{
		super();
		this.showObject = param1;
		this.timelag = param2;
		this.fixedOffestPosition = param3;
	}
}

class SingletonClass extends Object
{
	
	function SingletonClass()
	{
		super();
	}
}
