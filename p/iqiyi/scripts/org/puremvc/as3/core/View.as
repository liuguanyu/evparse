package org.puremvc.as3.core
{
	import org.puremvc.as3.interfaces.IView;
	import org.puremvc.as3.patterns.observer.Observer;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.interfaces.IObserver;
	import org.puremvc.as3.interfaces.IMediator;
	
	public class View extends Object implements IView
	{
		
		protected static var instance:IView;
		
		protected const SINGLETON_MSG:String = "View Singleton already constructed!";
		
		protected var observerMap:Array;
		
		protected var mediatorMap:Array;
		
		public function View()
		{
			super();
			if(instance != null)
			{
				throw Error(SINGLETON_MSG);
			}
			else
			{
				instance = this;
				mediatorMap = new Array();
				observerMap = new Array();
				initializeView();
				return;
			}
		}
		
		public static function getInstance() : IView
		{
			if(instance == null)
			{
				instance = new View();
			}
			return instance;
		}
		
		public function removeObserver(param1:String, param2:Object) : void
		{
			var _loc3:Array = observerMap[param1] as Array;
			var _loc4:* = 0;
			while(_loc4 < _loc3.length)
			{
				if(Observer(_loc3[_loc4]).compareNotifyContext(param2) == true)
				{
					_loc3.splice(_loc4,1);
					break;
				}
				_loc4++;
			}
			if(_loc3.length == 0)
			{
				delete observerMap[param1];
				true;
			}
		}
		
		public function hasMediator(param1:String) : Boolean
		{
			return !(mediatorMap[param1] == null);
		}
		
		public function notifyObservers(param1:INotification) : void
		{
			var _loc2:Array = null;
			var _loc3:Array = null;
			var _loc4:IObserver = null;
			var _loc5:* = NaN;
			if(observerMap[param1.getName()] != null)
			{
				_loc2 = observerMap[param1.getName()] as Array;
				_loc3 = new Array();
				_loc5 = 0;
				while(_loc5 < _loc2.length)
				{
					_loc4 = _loc2[_loc5] as IObserver;
					_loc3.push(_loc4);
					_loc5++;
				}
				_loc5 = 0;
				while(_loc5 < _loc3.length)
				{
					_loc4 = _loc3[_loc5] as IObserver;
					_loc4.notifyObserver(param1);
					_loc5++;
				}
			}
		}
		
		protected function initializeView() : void
		{
		}
		
		public function registerMediator(param1:IMediator) : void
		{
			var _loc3:Observer = null;
			var _loc4:* = NaN;
			if(mediatorMap[param1.getMediatorName()] != null)
			{
				return;
			}
			mediatorMap[param1.getMediatorName()] = param1;
			var _loc2:Array = param1.listNotificationInterests();
			if(_loc2.length > 0)
			{
				_loc3 = new Observer(param1.handleNotification,param1);
				_loc4 = 0;
				while(_loc4 < _loc2.length)
				{
					registerObserver(_loc2[_loc4],_loc3);
					_loc4++;
				}
			}
			param1.onRegister();
		}
		
		public function removeMediator(param1:String) : IMediator
		{
			var _loc3:Array = null;
			var _loc4:* = NaN;
			var _loc2:IMediator = mediatorMap[param1] as IMediator;
			if(_loc2)
			{
				_loc3 = _loc2.listNotificationInterests();
				_loc4 = 0;
				while(_loc4 < _loc3.length)
				{
					removeObserver(_loc3[_loc4],_loc2);
					_loc4++;
				}
				delete mediatorMap[param1];
				true;
				_loc2.onRemove();
			}
			return _loc2;
		}
		
		public function registerObserver(param1:String, param2:IObserver) : void
		{
			var _loc3:Array = observerMap[param1];
			if(_loc3)
			{
				_loc3.push(param2);
			}
			else
			{
				observerMap[param1] = [param2];
			}
		}
		
		public function retrieveMediator(param1:String) : IMediator
		{
			return mediatorMap[param1];
		}
	}
}
