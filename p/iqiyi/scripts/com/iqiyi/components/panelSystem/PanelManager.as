package com.iqiyi.components.panelSystem
{
	import flash.utils.Dictionary;
	import com.iqiyi.components.panelSystem.interfaces.IPanel;
	import flash.display.DisplayObjectContainer;
	
	public class PanelManager extends Object
	{
		
		private static var _instance:PanelManager;
		
		private var _panels:Dictionary;
		
		public function PanelManager(param1:SingletonClass)
		{
			super();
			if(param1 == null)
			{
				throw new Error("PanelManager is Singleton Class!");
			}
			else
			{
				this._panels = new Dictionary();
				return;
			}
		}
		
		public static function getInstance() : PanelManager
		{
			if(_instance == null)
			{
				_instance = new PanelManager(new SingletonClass());
			}
			return _instance;
		}
		
		public function register(param1:IPanel) : void
		{
			if(this._panels[param1.name] == null)
			{
				this._panels[param1.name] = param1;
			}
		}
		
		public function unregister(param1:String) : void
		{
			var _loc2:IPanel = this._panels[param1];
			if(_loc2)
			{
				_loc2.destroy();
				delete this._panels[param1];
				true;
			}
		}
		
		public function getPanel(param1:String) : IPanel
		{
			return this._panels[param1];
		}
		
		public function open(param1:String, param2:DisplayObjectContainer = null) : IPanel
		{
			var _loc3:IPanel = this._panels[param1];
			if(_loc3)
			{
				_loc3.open(param2);
			}
			return _loc3;
		}
		
		public function close(param1:String) : IPanel
		{
			var _loc2:IPanel = this._panels[param1];
			if(_loc2)
			{
				_loc2.close();
			}
			return _loc2;
		}
		
		public function closeAll() : void
		{
			var _loc1:IPanel = null;
			for each(_loc1 in this._panels)
			{
				if(_loc1.isOpen)
				{
					_loc1.close();
				}
			}
		}
		
		public function closeByType(param1:int) : void
		{
			var _loc2:IPanel = null;
			for each(_loc2 in this._panels)
			{
				if((_loc2.isOpen) && _loc2.type == param1)
				{
					_loc2.close();
				}
			}
		}
	}
}

class SingletonClass extends Object
{
	
	function SingletonClass()
	{
		super();
	}
}
