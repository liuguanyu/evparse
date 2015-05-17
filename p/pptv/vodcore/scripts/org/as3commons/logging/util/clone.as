package org.as3commons.logging.util
{
	public function clone(param1:*, param2:uint = 4.294967295E9, param3:Dictionary = null, param4:Boolean = true) : *
	{
		var nextDepth:uint = 0;
		var resultArr:Array = null;
		var arr:Array = null;
		var l:int = 0;
		var i:int = 0;
		var resultObj:Object = null;
		var props:Array = null;
		var prop:String = null;
		var object:* = param1;
		var introspectDepth:uint = param2;
		var storage:Dictionary = param3;
		var useByteArray:Boolean = param4;
		if(object is QName || object is String || object is Boolean || object is Namespace || object is Number || object == null || object is Function)
		{
			return object;
		}
		var theClone:* = null;
		if(storage)
		{
			theClone = storage[object];
		}
		if(!theClone)
		{
			if((object.hasOwnProperty("clone")) && object["clone"] is Function)
			{
				try
				{
					theClone = object["clone"]();
				}
				catch(e:Error)
				{
				}
			}
			if((!theClone) && (object.hasOwnProperty("copy")) && object["copy"] is Function)
			{
				try
				{
					theClone = object["copy"]();
				}
				catch(e1:Error)
				{
				}
			}
			if(!theClone)
			{
				if(object is Array)
				{
					resultArr = [];
					if(introspectDepth > 0)
					{
						nextDepth = introspectDepth - 1;
						arr = object;
						l = arr.length;
						i = 0;
						while(i < l)
						{
							resultArr[i] = clone(arr[i],nextDepth,storage || (storage = new Dictionary()),useByteArray);
							i++;
						}
					}
					theClone = resultArr;
				}
				else if(useByteArray)
				{
					try
					{
						BYTE_ARRAY.position = 0;
						BYTE_ARRAY.writeObject(object);
						BYTE_ARRAY.position = 0;
						theClone = BYTE_ARRAY.readObject();
					}
					catch(e2:Error)
					{
					}
				}
				
			}
			if(!theClone)
			{
				resultObj = {};
				props = allProperties(object);
				if(introspectDepth > 0)
				{
					nextDepth = introspectDepth - 1;
					for(prop in object)
					{
						resultObj[prop] = clone(object[prop],nextDepth,storage || (storage = new Dictionary()),useByteArray);
					}
				}
				theClone = resultObj;
			}
			if(storage)
			{
				storage[object] = theClone;
			}
		}
		return theClone;
	}
}

const BYTE_ARRAY:ByteArray;
