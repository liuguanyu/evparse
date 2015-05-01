package com.iqiyi.components.panelSystem {
	import flash.utils.Dictionary;
	import com.iqiyi.components.panelSystem.interfaces.IPanel;
	import flash.display.DisplayObjectContainer;
	
	public class PanelManager extends Object {
		
		public function PanelManager(param1:SingletonClass) {
			super();
			if(param1 == null) {
				throw new Error("PanelManager is Singleton Class!");
			} else {
				this._panels = new Dictionary();
				return;
			}
		}
		
		private static var _instance:PanelManager;
		
		public static function getInstance() : PanelManager {
			if(_instance == null) {
				_instance = new PanelManager(new SingletonClass());
			}
			return _instance;
		}
		
		private var _panels:Dictionary;
		
		public function register(param1:IPanel) : void {
			if(this._panels[param1.name] == null) {
				this._panels[param1.name] = param1;
			}
		}
		
		public function unregister(param1:String) : void {
			var _loc2_:IPanel = this._panels[param1];
			if(_loc2_) {
				_loc2_.destroy();
				delete this._panels[param1];
				true;
			}
		}
		
		public function getPanel(param1:String) : IPanel {
			return this._panels[param1];
		}
		
		public function open(param1:String, param2:DisplayObjectContainer = null) : IPanel {
			var _loc3_:IPanel = this._panels[param1];
			if(_loc3_) {
				_loc3_.open(param2);
			}
			return _loc3_;
		}
		
		public function close(param1:String) : IPanel {
			var _loc2_:IPanel = this._panels[param1];
			if(_loc2_) {
				_loc2_.close();
			}
			return _loc2_;
		}
		
		public function closeAll() : void {
			var _loc1_:IPanel = null;
			for each(_loc1_ in this._panels) {
				if(_loc1_.isOpen) {
					_loc1_.close();
				}
			}
		}
		
		public function closeByType(param1:int) : void {
			var _loc2_:IPanel = null;
			for each(_loc2_ in this._panels) {
				if((_loc2_.isOpen) && _loc2_.type == param1) {
					_loc2_.close();
				}
			}
		}
	}
}
class SingletonClass extends Object {
	
	function SingletonClass() {
		super();
	}
}
