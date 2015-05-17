package org.as3commons.logging.util
{
	public function allProperties(param1:*) : Array
	{
		var xml:XML = null;
		var xmlProp:XMLList = null;
		var property:XML = null;
		var raw:Array = null;
		var i:String = null;
		var value:* = param1;
		var cls:String = getQualifiedClassName(value);
		var result:Array = storage[cls];
		var dyn:Boolean = isDynamic[cls];
		var l:int = 0;
		if(!result)
		{
			xml = describeType(value);
			result = [];
			xmlProp = xml["factory"]["accessor"] + xml["accessor"].(@access == "readwrite" || @access == "readonly") + xml["factory"]["variable"] + xml["variable"];
			for each(property in xmlProp)
			{
				result[l++] = XML(property.@name).toString();
			}
			result.sort();
			storage[cls] = result;
			isDynamic[cls] = dyn = xml.@isDynamic == "true";
		}
		if(dyn)
		{
			raw = result;
			result = [];
			for(i in value)
			{
				result.push(i);
			}
			for each(i in raw)
			{
				result.push(i);
			}
			result.sort();
			return result;
		}
		return result;
	}
}

const isDynamic:Object;

const storage:Object;
