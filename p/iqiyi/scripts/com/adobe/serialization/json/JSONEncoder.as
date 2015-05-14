package com.adobe.serialization.json
{
	import flash.utils.describeType;
	
	public class JSONEncoder extends Object
	{
		
		private var jsonString:String;
		
		public function JSONEncoder(param1:*)
		{
			super();
			jsonString = convertToString(param1);
		}
		
		private function escapeString(param1:String) : String
		{
			var _loc3:String = null;
			var _loc6:String = null;
			var _loc7:String = null;
			var _loc2:* = "";
			var _loc4:Number = param1.length;
			var _loc5:* = 0;
			while(_loc5 < _loc4)
			{
				_loc3 = param1.charAt(_loc5);
				switch(_loc3)
				{
					case "\"":
						_loc2 = _loc2 + "\\\"";
						break;
					case "\\":
						_loc2 = _loc2 + "\\\\";
						break;
					case "\b":
						_loc2 = _loc2 + "\\b";
						break;
					case "\f":
						_loc2 = _loc2 + "\\f";
						break;
					case "\n":
						_loc2 = _loc2 + "\\n";
						break;
					case "\r":
						_loc2 = _loc2 + "\\r";
						break;
					case "\t":
						_loc2 = _loc2 + "\\t";
						break;
					default:
						if(_loc3 < " ")
						{
							_loc6 = _loc3.charCodeAt(0).toString(16);
							_loc7 = _loc6.length == 2?"00":"000";
							_loc2 = _loc2 + ("\\u" + _loc7 + _loc6);
						}
						else
						{
							_loc2 = _loc2 + _loc3;
						}
				}
				_loc5++;
			}
			return "\"" + _loc2 + "\"";
		}
		
		private function arrayToString(param1:Array) : String
		{
			var _loc2:* = "";
			var _loc3:* = 0;
			while(_loc3 < param1.length)
			{
				if(_loc2.length > 0)
				{
					_loc2 = _loc2 + ",";
				}
				_loc2 = _loc2 + convertToString(param1[_loc3]);
				_loc3++;
			}
			return "[" + _loc2 + "]";
		}
		
		public function getString() : String
		{
			return jsonString;
		}
		
		private function objectToString(param1:Object) : String
		{
			var value:Object = null;
			var key:String = null;
			var v:XML = null;
			var o:Object = param1;
			var s:String = "";
			var classInfo:XML = describeType(o);
			if(classInfo.@name.toString() == "Object")
			{
				for(key in o)
				{
					value = o[key];
					if(!(value is Function))
					{
						if(s.length > 0)
						{
							s = s + ",";
						}
						s = s + (escapeString(key) + ":" + convertToString(value));
					}
				}
			}
			else
			{
				for each(v in classInfo..*.(name() == "variable" || name() == "accessor" && attribute("access").charAt(0) == "r"))
				{
					if(!((v.metadata) && v.metadata.(@name == "Transient").length() > 0))
					{
						if(s.length > 0)
						{
							s = s + ",";
						}
						s = s + (escapeString(v.@name.toString()) + ":" + convertToString(o[v.@name]));
					}
				}
			}
			return "{" + s + "}";
		}
		
		private function convertToString(param1:*) : String
		{
			if(param1 is String)
			{
				return escapeString(param1 as String);
			}
			if(param1 is Number)
			{
				return isFinite(param1 as Number)?param1.toString():"null";
			}
			if(param1 is Boolean)
			{
				return param1?"true":"false";
			}
			if(param1 is Array)
			{
				return arrayToString(param1 as Array);
			}
			if(param1 is Object && !(param1 == null))
			{
				return objectToString(param1);
			}
			return "null";
		}
	}
}
