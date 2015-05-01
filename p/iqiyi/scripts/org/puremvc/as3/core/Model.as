package org.puremvc.as3.core {
	import org.puremvc.as3.interfaces.IModel;
	import org.puremvc.as3.interfaces.IProxy;
	
	public class Model extends Object implements IModel {
		
		public function Model() {
			super();
			if(instance != null) {
				throw Error(SINGLETON_MSG);
			} else {
				instance = this;
				proxyMap = new Array();
				initializeModel();
				return;
			}
		}
		
		public static function getInstance() : IModel {
			if(instance == null) {
				instance = new Model();
			}
			return instance;
		}
		
		protected static var instance:IModel;
		
		protected function initializeModel() : void {
		}
		
		protected const SINGLETON_MSG:String = "Model Singleton already constructed!";
		
		protected var proxyMap:Array;
		
		public function removeProxy(param1:String) : IProxy {
			var _loc2_:IProxy = proxyMap[param1] as IProxy;
			if(_loc2_) {
				proxyMap[param1] = null;
				_loc2_.onRemove();
			}
			return _loc2_;
		}
		
		public function hasProxy(param1:String) : Boolean {
			return !(proxyMap[param1] == null);
		}
		
		public function retrieveProxy(param1:String) : IProxy {
			return proxyMap[param1];
		}
		
		public function registerProxy(param1:IProxy) : void {
			proxyMap[param1.getProxyName()] = param1;
			param1.onRegister();
		}
	}
}
