package org.puremvc.as3.core
{
	import org.puremvc.as3.interfaces.IController;
	import org.puremvc.as3.interfaces.IView;
	import org.puremvc.as3.patterns.observer.Observer;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.interfaces.ICommand;
	
	public class Controller extends Object implements IController
	{
		
		protected static var instance:IController;
		
		protected var commandMap:Array;
		
		protected var view:IView;
		
		protected const SINGLETON_MSG:String = "Controller Singleton already constructed!";
		
		public function Controller()
		{
			super();
			if(instance != null)
			{
				throw Error(SINGLETON_MSG);
			}
			else
			{
				instance = this;
				commandMap = new Array();
				initializeController();
				return;
			}
		}
		
		public static function getInstance() : IController
		{
			if(instance == null)
			{
				instance = new Controller();
			}
			return instance;
		}
		
		public function removeCommand(param1:String) : void
		{
			if(hasCommand(param1))
			{
				view.removeObserver(param1,this);
				commandMap[param1] = null;
			}
		}
		
		public function registerCommand(param1:String, param2:Class) : void
		{
			if(commandMap[param1] == null)
			{
				view.registerObserver(param1,new Observer(executeCommand,this));
			}
			commandMap[param1] = param2;
		}
		
		protected function initializeController() : void
		{
			view = View.getInstance();
		}
		
		public function hasCommand(param1:String) : Boolean
		{
			return !(commandMap[param1] == null);
		}
		
		public function executeCommand(param1:INotification) : void
		{
			var _loc2:Class = commandMap[param1.getName()];
			if(_loc2 == null)
			{
				return;
			}
			var _loc3:ICommand = new _loc2();
			_loc3.execute(param1);
		}
	}
}
