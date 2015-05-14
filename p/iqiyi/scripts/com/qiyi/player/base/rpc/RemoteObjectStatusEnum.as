package com.qiyi.player.base.rpc
{
	import com.qiyi.player.base.pub.EnumItem;
	
	public class RemoteObjectStatusEnum extends Object
	{
		
		public static var items:Array = [];
		
		public static var None:EnumItem = new EnumItem(0,"none",items);
		
		public static var Processing:EnumItem = new EnumItem(1,"processing",items);
		
		public static var Success:EnumItem = new EnumItem(2,"success",items);
		
		public static var Timeout:EnumItem = new EnumItem(3,"timeout",items);
		
		public static var ConnectError:EnumItem = new EnumItem(4,"connectError",items);
		
		public static var DataError:EnumItem = new EnumItem(5,"dataError",items);
		
		public static var SecurityError:EnumItem = new EnumItem(6,"securityError",items);
		
		public static var AuthenticationError:EnumItem = new EnumItem(7,"authenticationError",items);
		
		public static var UnknownError:EnumItem = new EnumItem(8,"unknownError",items);
		
		public function RemoteObjectStatusEnum()
		{
			super();
		}
	}
}
