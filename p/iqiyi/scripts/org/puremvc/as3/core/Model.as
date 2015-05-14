package org.puremvc.as3.core
{
	import org.puremvc.as3.interfaces.IModel;
	import org.puremvc.as3.interfaces.IProxy;
	
	public class Model extends Object implements IModel
	{
		
		protected static var instance:IModel;
		
		protected const SINGLETON_MSG:String = "Model Singleton already constructed!";
		
		protected var proxyMap:Array;
		
		public function Model()
		{
			super();
			if(instance != null)
			{
				throw Error(SINGLETON_MSG);
			}
			else
			{
				instance = this;
				proxyMap = new Array();
				initializeModel();
				return;
			}
		}
		
		public static function getInstance() : IModel
		{
			if(instance == null)
			{
				instance = new Model();
			}
			return instance;
		}
		
		protected function initializeModel() : void
		{
		}
		
		public function removeProxy(param1:String) : IProxy
		{
			var _loc2:IProxy = proxyMap[param1] as IProxy;
			if(_loc2)
			{
				proxyMap[param1] = null;
				_loc2.onRemove();
			}
			return _loc2;
		}
		
		public function hasProxy(param1:String) : Boolean
		{
			return !(proxyMap[param1] == null);
		}
		
		public function retrieveProxy(param1:String) : IProxy
		{
			return proxyMap[param1];
		}
		
		public function registerProxy(param1:IProxy) : void
		{
			proxyMap[param1.getProxyName()] = param1;
			param1.onRegister();
		}
	}
}
