package com.pplive.mx
{
	import flash.utils.Dictionary;
	import flash.utils.ByteArray;
	import flash.xml.XMLNode;
	import flash.utils.getQualifiedClassName;
	
	public class ObjectUtil extends Object
	{
		
		private static var defaultToStringExcludes:Array = ["password","credentials"];
		
		private static var refCount:int = 0;
		
		private static var CLASS_INFO_CACHE:Object = {};
		
		public function ObjectUtil()
		{
			super();
		}
		
		public static function compare(param1:Object, param2:Object, param3:int = -1) : int
		{
			return internalCompare(param1,param2,0,param3,new Dictionary(true));
		}
		
		public static function copy(param1:Object) : Object
		{
			var _loc2:ByteArray = new ByteArray();
			_loc2.writeObject(param1);
			_loc2.position = 0;
			var _loc3:Object = _loc2.readObject();
			return _loc3;
		}
		
		public static function clone(param1:Object) : Object
		{
			var _loc2:Object = copy(param1);
			cloneInternal(_loc2,param1);
			return _loc2;
		}
		
		private static function cloneInternal(param1:Object, param2:Object) : void
		{
			var _loc4:Object = null;
			var _loc5:* = undefined;
			param1.uid = param2.uid;
			var _loc3:Object = getClassInfo(param2);
			for each(_loc5 in _loc3.properties)
			{
				_loc4 = param2[_loc5];
				if((_loc4) && (_loc4.hasOwnProperty("uid")))
				{
					cloneInternal(param1[_loc5],_loc4);
				}
			}
		}
		
		public static function isSimple(param1:Object) : Boolean
		{
			var _loc2:* = typeof param1;
			switch(_loc2)
			{
				case "number":
				case "string":
				case "boolean":
					return true;
				case "object":
					return param1 is Date || param1 is Array;
				default:
					return false;
			}
		}
		
		public static function numericCompare(param1:Number, param2:Number) : int
		{
			if((isNaN(param1)) && (isNaN(param2)))
			{
				return 0;
			}
			if(isNaN(param1))
			{
				return 1;
			}
			if(isNaN(param2))
			{
				return -1;
			}
			if(param1 < param2)
			{
				return -1;
			}
			if(param1 > param2)
			{
				return 1;
			}
			return 0;
		}
		
		public static function stringCompare(param1:String, param2:String, param3:Boolean = false) : int
		{
			if(param1 == null && param2 == null)
			{
				return 0;
			}
			if(param1 == null)
			{
				return 1;
			}
			if(param2 == null)
			{
				return -1;
			}
			if(param3)
			{
				var param1:String = param1.toLocaleLowerCase();
				var param2:String = param2.toLocaleLowerCase();
			}
			var _loc4:int = param1.localeCompare(param2);
			if(_loc4 < -1)
			{
				_loc4 = -1;
			}
			else if(_loc4 > 1)
			{
				_loc4 = 1;
			}
			
			return _loc4;
		}
		
		public static function dateCompare(param1:Date, param2:Date) : int
		{
			if(param1 == null && param2 == null)
			{
				return 0;
			}
			if(param1 == null)
			{
				return 1;
			}
			if(param2 == null)
			{
				return -1;
			}
			var _loc3:Number = param1.getTime();
			var _loc4:Number = param2.getTime();
			if(_loc3 < _loc4)
			{
				return -1;
			}
			if(_loc3 > _loc4)
			{
				return 1;
			}
			return 0;
		}
		
		public static function toString(param1:Object, param2:Array = null, param3:Array = null) : String
		{
			if(param3 == null)
			{
				var param3:Array = defaultToStringExcludes;
			}
			refCount = 0;
			return internalToString(param1,0,null,param2,param3);
		}
		
		private static function internalToString(param1:Object, param2:int = 0, param3:Dictionary = null, param4:Array = null, param5:Array = null) : String
		{
			var str:String = null;
			var classInfo:Object = null;
			var properties:Array = null;
			var isArray:Boolean = false;
			var isDict:Boolean = false;
			var prop:* = undefined;
			var j:int = 0;
			var id:Object = null;
			var value:Object = param1;
			var indent:int = param2;
			var refs:Dictionary = param3;
			var namespaceURIs:Array = param4;
			var exclude:Array = param5;
			var type:String = value == null?"null":typeof value;
			switch(type)
			{
				case "boolean":
				case "number":
					return value.toString();
				case "string":
					return "\"" + value.toString() + "\"";
				case "object":
					if(value is Date)
					{
						return value.toString();
					}
					if(value is XMLNode)
					{
						return value.toString();
					}
					if(value is Class)
					{
						return "(" + getQualifiedClassName(value) + ")";
					}
					classInfo = getClassInfo(value,exclude,{
						"includeReadOnly":true,
						"uris":namespaceURIs
					});
					properties = classInfo.properties;
					str = "(" + classInfo.name + ")";
					if(refs == null)
					{
						refs = new Dictionary(true);
					}
					try
					{
						id = refs[value];
						if(id != null)
						{
							str = str + ("#" + int(id));
							return str;
						}
					}
					catch(e:Error)
					{
						return String(value);
					}
					if(value != null)
					{
						str = str + ("#" + refCount.toString());
						refs[value] = refCount;
						refCount++;
					}
					isArray = value is Array;
					isDict = value is Dictionary;
					indent = indent + 2;
					j = 0;
					while(j < properties.length)
					{
						str = newline(str,indent);
						prop = properties[j];
						if(isArray)
						{
							str = str + "[";
						}
						else if(isDict)
						{
							str = str + "{";
						}
						
						if(isDict)
						{
							str = str + internalToString(prop,indent,refs,namespaceURIs,exclude);
						}
						else
						{
							str = str + prop.toString();
						}
						if(isArray)
						{
							str = str + "] ";
						}
						else if(isDict)
						{
							str = str + "} = ";
						}
						else
						{
							str = str + " = ";
						}
						
						try
						{
							str = str + internalToString(value[prop],indent,refs,namespaceURIs,exclude);
						}
						catch(e:Error)
						{
							str = str + "?";
						}
						j++;
					}
					indent = indent - 2;
					return str;
				case "xml":
					return value.toXMLString();
				default:
					return "(" + type + ")";
			}
		}
		
		private static function newline(param1:String, param2:int = 0) : String
		{
			var _loc3:String = param1;
			_loc3 = _loc3 + "\n";
			var _loc4:* = 0;
			while(_loc4 < param2)
			{
				_loc3 = _loc3 + " ";
				_loc4++;
			}
			return _loc3;
		}
		
		private static function internalCompare(param1:Object, param2:Object, param3:int, param4:int, param5:Dictionary) : int
		{
			var _loc9:* = 0;
			var _loc10:Object = null;
			var _loc11:Object = null;
			var _loc12:Array = null;
			var _loc13:Array = null;
			var _loc14:* = false;
			var _loc15:QName = null;
			var _loc16:Object = null;
			var _loc17:Object = null;
			var _loc18:* = 0;
			if(param1 == null && param2 == null)
			{
				return 0;
			}
			if(param1 == null)
			{
				return 1;
			}
			if(param2 == null)
			{
				return -1;
			}
			var _loc6:* = typeof param1;
			var _loc7:* = typeof param2;
			var _loc8:* = 0;
			if(_loc6 == _loc7)
			{
				switch(_loc6)
				{
					case "boolean":
						_loc8 = numericCompare(Number(param1),Number(param2));
						break;
					case "number":
						_loc8 = numericCompare(param1 as Number,param2 as Number);
						break;
					case "string":
						_loc8 = stringCompare(param1 as String,param2 as String);
						break;
					case "object":
						_loc9 = param4 > 0?param4 - 1:param4;
						_loc10 = getRef(param1,param5);
						_loc11 = getRef(param2,param5);
						if(_loc10 == _loc11)
						{
							return 0;
						}
						param5[_loc11] = _loc10;
						if(!(param4 == -1) && param3 > param4)
						{
							_loc8 = stringCompare(param1.toString(),param2.toString());
						}
						else if(param1 is Array && param2 is Array)
						{
							_loc8 = arrayCompare(param1 as Array,param2 as Array,param3,param4,param5);
						}
						else if(param1 is Date && param2 is Date)
						{
							_loc8 = dateCompare(param1 as Date,param2 as Date);
						}
						else if(param1 is IList && param2 is IList)
						{
							_loc8 = listCompare(param1 as IList,param2 as IList,param3,param4,param5);
						}
						else if(param1 is ByteArray && param2 is ByteArray)
						{
							_loc8 = byteArrayCompare(param1 as ByteArray,param2 as ByteArray);
						}
						else if(getQualifiedClassName(param1) == getQualifiedClassName(param2))
						{
							_loc12 = getClassInfo(param1).properties;
							_loc14 = isDynamicObject(param1);
							if(_loc14)
							{
								_loc13 = getClassInfo(param2).properties;
								_loc8 = arrayCompare(_loc12,_loc13,param3,_loc9,param5);
								if(_loc8 != 0)
								{
									return _loc8;
								}
							}
							_loc18 = 0;
							while(_loc18 < _loc12.length)
							{
								_loc15 = _loc12[_loc18];
								_loc16 = param1[_loc15];
								_loc17 = param2[_loc15];
								_loc8 = internalCompare(_loc16,_loc17,param3 + 1,_loc9,param5);
								if(_loc8 != 0)
								{
									return _loc8;
								}
								_loc18++;
							}
						}
						else
						{
							return 1;
						}
						
						
						
						
						
						break;
				}
				return _loc8;
			}
			return stringCompare(_loc6,_loc7);
		}
		
		public static function getClassInfo(param1:Object, param2:Array = null, param3:Object = null) : Object
		{
			var n:int = 0;
			var i:int = 0;
			var result:Object = null;
			var cacheKey:String = null;
			var className:String = null;
			var classAlias:String = null;
			var properties:XMLList = null;
			var prop:XML = null;
			var metadataInfo:Object = null;
			var classInfo:XML = null;
			var numericIndex:Boolean = false;
			var key:* = undefined;
			var p:String = null;
			var pi:Number = NaN;
			var uris:Array = null;
			var uri:String = null;
			var qName:QName = null;
			var j:int = 0;
			var obj:Object = param1;
			var excludes:Array = param2;
			var options:Object = param3;
			if(options == null)
			{
				options = {
					"includeReadOnly":true,
					"uris":null,
					"includeTransient":true
				};
			}
			var propertyNames:Array = [];
			var var_1:Boolean = false;
			if(typeof obj == "xml")
			{
				className = "XML";
				properties = obj.text();
				if(properties.length())
				{
					propertyNames.push("*");
				}
				properties = obj.attributes();
			}
			else
			{
				classInfo = DescribeTypeCache.describeType(obj).typeDescription;
				className = classInfo.@name.toString();
				classAlias = classInfo.@alias.toString();
				var_1 = classInfo.@isDynamic.toString() == "true";
				if(options.includeReadOnly)
				{
					properties = classInfo..accessor.(@access != "writeonly") + classInfo..variable;
				}
				else
				{
					properties = classInfo..accessor.(@access == "readwrite") + classInfo..variable;
				}
				numericIndex = false;
			}
			if(!var_1)
			{
				cacheKey = getCacheKey(obj,excludes,options);
				result = CLASS_INFO_CACHE[cacheKey];
				if(result != null)
				{
					return result;
				}
			}
			result = {};
			result["name"] = className;
			result["alias"] = classAlias;
			result["properties"] = propertyNames;
			result["dynamic"] = var_1;
			result["metadata"] = metadataInfo = recordMetadata(properties);
			var excludeObject:Object = {};
			if(excludes)
			{
				n = excludes.length;
				i = 0;
				while(i < n)
				{
					excludeObject[excludes[i]] = 1;
					i++;
				}
			}
			var isArray:Boolean = className == "Array";
			var isDict:Boolean = className == "flash.utils::Dictionary";
			if(isDict)
			{
				for(key in obj)
				{
					propertyNames.push(key);
				}
			}
			else if(var_1)
			{
				for(p in obj)
				{
					if(excludeObject[p] != 1)
					{
						if(isArray)
						{
							pi = parseInt(p);
							if(isNaN(pi))
							{
								propertyNames.push(new QName("",p));
							}
							else
							{
								propertyNames.push(pi);
							}
						}
						else
						{
							propertyNames.push(new QName("",p));
						}
					}
				}
				numericIndex = (isArray) && !isNaN(Number(p));
			}
			
			if(!((isArray) || (isDict) || className == "Object"))
			{
				if(className == "XML")
				{
					n = properties.length();
					i = 0;
					while(i < n)
					{
						p = properties[i].name();
						if(excludeObject[p] != 1)
						{
							propertyNames.push(new QName("","@" + p));
						}
						i++;
					}
				}
				else
				{
					n = properties.length();
					uris = options.uris;
					i = 0;
					while(i < n)
					{
						prop = properties[i];
						p = prop.@name.toString();
						uri = prop.@uri.toString();
						if(excludeObject[p] != 1)
						{
							if(!(!options.includeTransient && (internalHasMetadata(metadataInfo,p,"Transient"))))
							{
								if(uris != null)
								{
									if(uris.length == 1 && uris[0] == "*")
									{
										qName = new QName(uri,p);
										try
										{
											obj[qName];
											propertyNames.push();
										}
										catch(e:Error)
										{
										}
									}
									else
									{
										j = 0;
										while(j < uris.length)
										{
											uri = uris[j];
											if(prop.@uri.toString() == uri)
											{
												qName = new QName(uri,p);
												try
												{
													obj[qName];
													propertyNames.push(qName);
												}
												catch(e:Error)
												{
												}
											}
											j++;
										}
									}
								}
								else if(uri.length == 0)
								{
									qName = new QName(uri,p);
									try
									{
										obj[qName];
										propertyNames.push(qName);
									}
									catch(e:Error)
									{
									}
								}
								
							}
						}
						i++;
					}
				}
			}
			propertyNames.sort(Array.CASEINSENSITIVE | (numericIndex?Array.NUMERIC:0));
			if(!isDict)
			{
				i = 0;
				while(i < propertyNames.length - 1)
				{
					if(propertyNames[i].toString() == propertyNames[i + 1].toString())
					{
						propertyNames.splice(i,1);
						i--;
					}
					i++;
				}
			}
			if(!var_1)
			{
				cacheKey = getCacheKey(obj,excludes,options);
				CLASS_INFO_CACHE[cacheKey] = result;
			}
			return result;
		}
		
		public static function hasMetadata(param1:Object, param2:String, param3:String, param4:Array = null, param5:Object = null) : Boolean
		{
			var _loc6:Object = getClassInfo(param1,param4,param5);
			var _loc7:Object = _loc6["metadata"];
			return internalHasMetadata(_loc7,param2,param3);
		}
		
		public static function isDynamicObject(param1:Object) : Boolean
		{
			var obj:Object = param1;
			try
			{
				obj["wootHackwoot"];
			}
			catch(e:Error)
			{
				return false;
			}
			return true;
		}
		
		private static function internalHasMetadata(param1:Object, param2:String, param3:String) : Boolean
		{
			var _loc4:Object = null;
			if(param1 != null)
			{
				_loc4 = param1[param2];
				if(_loc4 != null)
				{
					if(_loc4[param3] != null)
					{
						return true;
					}
				}
			}
			return false;
		}
		
		private static function recordMetadata(param1:XMLList) : Object
		{
			var prop:XML = null;
			var propName:String = null;
			var metadataList:XMLList = null;
			var metadata:Object = null;
			var md:XML = null;
			var mdName:String = null;
			var argsList:XMLList = null;
			var value:Object = null;
			var arg:XML = null;
			var existing:Object = null;
			var argKey:String = null;
			var argValue:String = null;
			var existingArray:Array = null;
			var properties:XMLList = param1;
			var result:Object = null;
			try
			{
				for each(prop in properties)
				{
					propName = prop.attribute("name").toString();
					metadataList = prop.metadata;
					if(metadataList.length() > 0)
					{
						if(result == null)
						{
							result = {};
						}
						metadata = {};
						result[propName] = metadata;
						for each(md in metadataList)
						{
							mdName = md.attribute("name").toString();
							argsList = md.arg;
							value = {};
							for each(arg in argsList)
							{
								argKey = arg.attribute("key").toString();
								if(argKey != null)
								{
									argValue = arg.attribute("value").toString();
									value[argKey] = argValue;
								}
							}
							existing = metadata[mdName];
							if(existing != null)
							{
								if(existing is Array)
								{
									existingArray = existing as Array;
								}
								else
								{
									existingArray = [existing];
									delete metadata[mdName];
									true;
								}
								existingArray.push(value);
								existing = existingArray;
							}
							else
							{
								existing = value;
							}
							metadata[mdName] = existing;
						}
					}
				}
			}
			catch(e:Error)
			{
			}
			return result;
		}
		
		private static function getCacheKey(param1:Object, param2:Array = null, param3:Object = null) : String
		{
			var _loc5:uint = 0;
			var _loc6:String = null;
			var _loc7:String = null;
			var _loc8:String = null;
			var _loc4:String = getQualifiedClassName(param1);
			if(param2 != null)
			{
				_loc5 = 0;
				while(_loc5 < param2.length)
				{
					_loc6 = param2[_loc5] as String;
					if(_loc6 != null)
					{
						_loc4 = _loc4 + _loc6;
					}
					_loc5++;
				}
			}
			if(param3 != null)
			{
				for(_loc7 in param3)
				{
					_loc4 = _loc4 + _loc7;
					_loc8 = param3[_loc7] as String;
					if(_loc8 != null)
					{
						_loc4 = _loc4 + _loc8;
					}
				}
			}
			return _loc4;
		}
		
		private static function arrayCompare(param1:Array, param2:Array, param3:int, param4:int, param5:Dictionary) : int
		{
			var _loc7:Object = null;
			var _loc6:* = 0;
			if(param1.length != param2.length)
			{
				if(param1.length < param2.length)
				{
					_loc6 = -1;
				}
				else
				{
					_loc6 = 1;
				}
			}
			else
			{
				for(_loc7 in param1)
				{
					if(param2.hasOwnProperty(_loc7))
					{
						_loc6 = internalCompare(param1[_loc7],param2[_loc7],param3,param4,param5);
						if(_loc6 != 0)
						{
							return _loc6;
						}
						continue;
					}
					return -1;
				}
				for(_loc7 in param2)
				{
					if(!param1.hasOwnProperty(_loc7))
					{
						return 1;
					}
				}
			}
			return _loc6;
		}
		
		private static function byteArrayCompare(param1:ByteArray, param2:ByteArray) : int
		{
			var _loc4:* = 0;
			var _loc3:* = 0;
			if(param1 == param2)
			{
				return _loc3;
			}
			if(param1.length != param2.length)
			{
				if(param1.length < param2.length)
				{
					_loc3 = -1;
				}
				else
				{
					_loc3 = 1;
				}
			}
			else
			{
				_loc4 = 0;
				while(_loc4 < param1.length)
				{
					_loc3 = numericCompare(param1[_loc4],param2[_loc4]);
					if(_loc3 != 0)
					{
						_loc4 = param1.length;
					}
					_loc4++;
				}
			}
			return _loc3;
		}
		
		private static function listCompare(param1:IList, param2:IList, param3:int, param4:int, param5:Dictionary) : int
		{
			var _loc7:* = 0;
			var _loc6:* = 0;
			if(param1.length != param2.length)
			{
				if(param1.length < param2.length)
				{
					_loc6 = -1;
				}
				else
				{
					_loc6 = 1;
				}
			}
			else
			{
				_loc7 = 0;
				while(_loc7 < param1.length)
				{
					_loc6 = internalCompare(param1.getItemAt(_loc7),param2.getItemAt(_loc7),param3 + 1,param4,param5);
					if(_loc6 != 0)
					{
						_loc7 = param1.length;
					}
					_loc7++;
				}
			}
			return _loc6;
		}
		
		private static function getRef(param1:Object, param2:Dictionary) : Object
		{
			var _loc3:Object = param2[param1];
			while((_loc3) && !(_loc3 == param2[_loc3]))
			{
				_loc3 = param2[_loc3];
			}
			if(!_loc3)
			{
				_loc3 = param1;
			}
			if(_loc3 != param2[param1])
			{
				param2[param1] = _loc3;
			}
			return _loc3;
		}
	}
}
