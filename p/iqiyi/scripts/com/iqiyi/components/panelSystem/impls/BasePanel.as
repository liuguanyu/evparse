package com.iqiyi.components.panelSystem.impls {
	import flash.display.Sprite;
	import com.iqiyi.components.panelSystem.interfaces.IPanel;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import flash.display.Stage;
	import flash.events.Event;
	
	public class BasePanel extends Sprite implements IPanel {
		
		public function BasePanel(param1:String, param2:DisplayObjectContainer) {
			super();
			this._name = param1;
			this._defaultContainer = param2;
			this._stage = stage;
			this._cover = this.createCover();
			addEventListener(Event.ADDED_TO_STAGE,this.onAddToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStageHandler);
		}
		
		private var _type:int;
		
		private var _name:String;
		
		private var _defaultContainer:DisplayObjectContainer;
		
		private var _hasCover:Boolean;
		
		private var _coverArea:Rectangle;
		
		private var _cover:Sprite;
		
		protected var _stage:Stage;
		
		public function get type() : int {
			return this._type;
		}
		
		public function set type(param1:int) : void {
			this._type = param1;
		}
		
		override public function get name() : String {
			return this._name;
		}
		
		public function get isOpen() : Boolean {
			return !(parent == null);
		}
		
		public function get isOnStage() : Boolean {
			return !(stage == null);
		}
		
		public function get hasCover() : Boolean {
			return this._hasCover;
		}
		
		public function set hasCover(param1:Boolean) : void {
			if(this._hasCover != param1) {
				this._hasCover = param1;
				if((this.isOpen) && (this._cover)) {
					if(this._hasCover) {
						parent.addChildAt(this._cover,parent.getChildIndex(this));
					} else {
						parent.removeChild(this._cover);
					}
				}
			}
		}
		
		public function open(param1:DisplayObjectContainer = null) : void {
			if(!this.isOpen) {
				if(param1) {
					if((this._hasCover) && (this._cover)) {
						param1.addChild(this._cover);
					}
					param1.addChild(this);
				} else {
					if((this._hasCover) && (this._cover)) {
						this._defaultContainer.addChild(this._cover);
					}
					this._defaultContainer.addChild(this);
				}
			}
		}
		
		public function close() : void {
			if(this.isOpen) {
				if((this._hasCover) && (this._cover)) {
					parent.removeChild(this._cover);
				}
				parent.removeChild(this);
			}
		}
		
		public function toTop() : void {
			if(parent) {
				if((this._hasCover) && (this._cover)) {
					parent.setChildIndex(this._cover,parent.numChildren - 1);
				}
				parent.setChildIndex(this,parent.numChildren - 1);
			}
		}
		
		public function toBottom() : void {
			if(parent) {
				parent.setChildIndex(this,0);
				if((this._hasCover) && (this._cover)) {
					parent.setChildIndex(this._cover,0);
				}
			}
		}
		
		public function setPosition(param1:int, param2:int) : void {
			x = param1;
			y = param2;
		}
		
		public function setSize(param1:int, param2:int) : void {
		}
		
		public function setCoverArea(param1:Rectangle) : void {
			if(param1) {
				this._coverArea = param1;
				if(this._cover) {
					this._cover.x = param1.x;
					this._cover.y = param1.y;
					this._cover.width = param1.width;
					this._cover.height = param1.height;
				}
			}
		}
		
		protected function createCover() : Sprite {
			var _loc1_:Sprite = new Sprite();
			_loc1_.graphics.beginFill(0,0.4);
			_loc1_.graphics.drawRect(0,0,1,1);
			_loc1_.graphics.endFill();
			return _loc1_;
		}
		
		protected function onAddToStage() : void {
		}
		
		protected function onRemoveFromStage() : void {
		}
		
		private function onAddToStageHandler(param1:Event) : void {
			this._stage = stage;
			this.onAddToStage();
		}
		
		private function onRemoveFromStageHandler(param1:Event) : void {
			this.onRemoveFromStage();
		}
		
		public function destroy() : void {
			removeEventListener(Event.ADDED_TO_STAGE,this.onAddToStageHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStageHandler);
			if(this.isOpen) {
				parent.removeChild(this);
			}
			if((this._cover) && (this._cover.parent)) {
				this._cover.parent.removeChild(this._cover);
			}
		}
	}
}
