package com.pplive.mx
{
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	import flash.utils.describeType;
	
	public class DescribeTypeCache extends Object
	{
		
		private static var typeCache:Object = {};
		
		private static var cacheHandlers:Object = {};
		
		{
			registerCacheHandler("bindabilityInfo",bindabilityInfoHandler);
		}
		
		public function DescribeTypeCache()
		{
			super();
		}
		
		public static function describeType(param1:*) : DescribeTypeCacheRecord
		{
			var _loc2:String = null;
			var _loc3:String = null;
			var _loc4:XML = null;
			var _loc5:DescribeTypeCacheRecord = null;
			if(param1 is String)
			{
				_loc3 = _loc2 = param1;
			}
			else
			{
				_loc3 = _loc2 = getQualifiedClassName(param1);
			}
			if(param1 is Class)
			{
				_loc3 = _loc3 + "$";
			}
			if(_loc3 in typeCache)
			{
				return typeCache[_loc3];
			}
			if(param1 is String)
			{
				var param1:* = getDefinitionByName(param1);
			}
			_loc4 = flash.utils.describeType(param1);
			_loc5 = new DescribeTypeCacheRecord();
			_loc5.typeDescription = _loc4;
			_loc5.typeName = _loc2;
			typeCache[_loc3] = _loc5;
			return _loc5;
		}
		
		public static function registerCacheHandler(param1:String, param2:Function) : void
		{
			cacheHandlers[param1] = param2;
		}
		
		static function extractValue(param1:String, param2:DescribeTypeCacheRecord) : *
		{
			if(param1 in cacheHandlers)
			{
				return cacheHandlers[param1](param2);
			}
			return undefined;
		}
		
		private static function bindabilityInfoHandler(param1:DescribeTypeCacheRecord) : *
		{
			return new BindabilityInfo(param1.typeDescription);
		}
	}
}
