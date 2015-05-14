package com.qiyi.cupid.adplayer.utils
{
	import flash.net.SharedObject;
	import flash.external.ExternalInterface;
	
	public class CupidAdPlayerUtils extends Object
	{
		
		public function CupidAdPlayerUtils()
		{
			super();
		}
		
		public static function saveBaseCookie(param1:String, param2:String, param3:Object) : void
		{
			var so:SharedObject = null;
			var file:String = param1;
			var field:String = param2;
			var data:Object = param3;
			try
			{
				so = SharedObject.getLocal(file,"/");
				so.data[field] = data;
				so.flush();
			}
			catch(e:Error)
			{
			}
		}
		
		public static function getBaseCookie(param1:String, param2:String) : Object
		{
			var so:SharedObject = null;
			var file:String = param1;
			var field:String = param2;
			var data:Object = null;
			try
			{
				so = SharedObject.getLocal(file,"/");
				data = so.data[field];
			}
			catch(e:Error)
			{
			}
			return data;
		}
		
		public static function getDefaultBlackScreenDuration(param1:String) : int
		{
			var _loc2:* = 15;
			var _loc3:Array = ["qc_100001_100014","qc_100001_100015","qc_100001_100016","qc_100001_100041","qc_100001_100042","qc_100001_100044"];
			var _loc4:Array = ["qc_100001_100002","qc_100001_100012","qc_100001_100018","qc_100001_100071","qc_100001_100089"];
			if(_loc3.indexOf(param1) != -1)
			{
				_loc2 = 45;
			}
			else if(_loc4.indexOf(param1) != -1)
			{
				_loc2 = 30;
			}
			
			return _loc2;
		}
		
		public static function getUserAgent() : String
		{
			var agent:String = "";
			try
			{
				if(ExternalInterface.available)
				{
					agent = ExternalInterface.call("function(){return navigator.userAgent.toLocaleLowerCase();}") as String;
				}
			}
			catch(e:Error)
			{
			}
			return agent;
		}
		
		public static function getLocation() : String
		{
			var location:String = null;
			try
			{
				if(ExternalInterface.available)
				{
					location = ExternalInterface.call("function(){" + "if(top.location.href){" + "return top.location.href;" + "}" + "return document.location.href;" + "}") as String;
				}
			}
			catch(e:Error)
			{
			}
			return location?location:"";
		}
		
		public static function getReferrer() : String
		{
			var referrer:String = null;
			try
			{
				if(ExternalInterface.available)
				{
					referrer = ExternalInterface.call("function(){return document.referrer;}") as String;
				}
			}
			catch(e:Error)
			{
			}
			return referrer?referrer:"";
		}
	}
}
