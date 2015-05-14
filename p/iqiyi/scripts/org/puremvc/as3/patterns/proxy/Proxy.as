package org.puremvc.as3.patterns.proxy
{
	import org.puremvc.as3.patterns.observer.Notifier;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.interfaces.INotifier;
	
	public class Proxy extends Notifier implements IProxy, INotifier
	{
		
		public static var NAME:String = "Proxy";
		
		protected var data:Object;
		
		protected var proxyName:String;
		
		public function Proxy(param1:String = null, param2:Object = null)
		{
			super();
			this.proxyName = param1 != null?param1:NAME;
			if(param2 != null)
			{
				setData(param2);
			}
		}
		
		public function getData() : Object
		{
			return data;
		}
		
		public function setData(param1:Object) : void
		{
			this.data = param1;
		}
		
		public function onRegister() : void
		{
		}
		
		public function getProxyName() : String
		{
			return proxyName;
		}
		
		public function onRemove() : void
		{
		}
	}
}
