package com.adobe.serialization.json
{
	public class JSONTokenizer extends Object
	{
		
		private var ch:String;
		
		private var loc:int;
		
		private var jsonString:String;
		
		private var strict:Boolean;
		
		private var controlCharsRegExp:RegExp;
		
		private var obj:Object;
		
		public function JSONTokenizer(param1:String, param2:Boolean)
		{
			controlCharsRegExp = new RegExp("[\\x00-\\x1F]");
			super();
			jsonString = param1;
			this.strict = param2;
			loc = 0;
			nextChar();
		}
		
		private function skipComments() : void
		{
			if(ch == "/")
			{
				nextChar();
				switch(ch)
				{
					case "/":
						do
						{
							nextChar();
						}
						while(!(ch == "\n") && !(ch == ""));
						
						nextChar();
						break;
					case "*":
						nextChar();
						while(true)
						{
							if(ch == "*")
							{
								nextChar();
								if(ch == "/")
								{
									break;
								}
							}
							else
							{
								nextChar();
							}
							if(ch == "")
							{
								parseError("Multi-line comment not closed");
							}
						}
						nextChar();
						break;
					default:
						parseError("Unexpected " + ch + " encountered (expecting \'/\' or \'*\' )");
				}
			}
		}
		
		private function isDigit(param1:String) : Boolean
		{
			return param1 >= "0" && param1 <= "9";
		}
		
		private function readNumber() : JSONToken
		{
			var _loc3:JSONToken = null;
			var _loc1:* = "";
			if(ch == "-")
			{
				_loc1 = _loc1 + "-";
				nextChar();
			}
			if(!isDigit(ch))
			{
				parseError("Expecting a digit");
			}
			if(ch == "0")
			{
				_loc1 = _loc1 + ch;
				nextChar();
				if(isDigit(ch))
				{
					parseError("A digit cannot immediately follow 0");
				}
				else if(!strict && ch == "x")
				{
					_loc1 = _loc1 + ch;
					nextChar();
					if(isHexDigit(ch))
					{
						_loc1 = _loc1 + ch;
						nextChar();
					}
					else
					{
						parseError("Number in hex format require at least one hex digit after \"0x\"");
					}
					while(isHexDigit(ch))
					{
						_loc1 = _loc1 + ch;
						nextChar();
					}
				}
				
			}
			else
			{
				while(isDigit(ch))
				{
					_loc1 = _loc1 + ch;
					nextChar();
				}
			}
			if(ch == ".")
			{
				_loc1 = _loc1 + ".";
				nextChar();
				if(!isDigit(ch))
				{
					parseError("Expecting a digit");
				}
				while(isDigit(ch))
				{
					_loc1 = _loc1 + ch;
					nextChar();
				}
			}
			if(ch == "e" || ch == "E")
			{
				_loc1 = _loc1 + "e";
				nextChar();
				if(ch == "+" || ch == "-")
				{
					_loc1 = _loc1 + ch;
					nextChar();
				}
				if(!isDigit(ch))
				{
					parseError("Scientific notation number needs exponent value");
				}
				while(isDigit(ch))
				{
					_loc1 = _loc1 + ch;
					nextChar();
				}
			}
			var _loc2:Number = Number(_loc1);
			if((isFinite(_loc2)) && !isNaN(_loc2))
			{
				_loc3 = new JSONToken();
				_loc3.type = JSONTokenType.NUMBER;
				_loc3.value = _loc2;
				return _loc3;
			}
			parseError("Number " + _loc2 + " is not valid!");
			return null;
		}
		
		public function unescapeString(param1:String) : String
		{
			var _loc6:* = undefined;
			var _loc7:* = undefined;
			var _loc8:* = undefined;
			var _loc9:* = undefined;
			var _loc10:* = undefined;
			if((strict) && (controlCharsRegExp.test(param1)))
			{
				parseError("String contains unescaped control character (0x00-0x1F)");
			}
			var _loc2:* = "";
			var _loc3:* = 0;
			var _loc4:* = 0;
			var _loc5:int = param1.length;
			while(true)
			{
				_loc3 = param1.indexOf("\\",_loc4);
				if(_loc3 >= 0)
				{
					_loc2 = _loc2 + param1.substr(_loc4,_loc3 - _loc4);
					_loc4 = _loc3 + 2;
					_loc6 = _loc3 + 1;
					_loc7 = param1.charAt(_loc6);
					switch(_loc7)
					{
						case "\"":
							_loc2 = _loc2 + "\"";
							break;
						case "\\":
							_loc2 = _loc2 + "\\";
							break;
						case "n":
							_loc2 = _loc2 + "\n";
							break;
						case "r":
							_loc2 = _loc2 + "\r";
							break;
						case "t":
							_loc2 = _loc2 + "\t";
							break;
						case "u":
							_loc8 = "";
							if(_loc4 + 4 > _loc5)
							{
								parseError("Unexpected end of input.  Expecting 4 hex digits after \\u.");
							}
							_loc9 = _loc4;
							while(_loc9 < _loc4 + 4)
							{
								_loc10 = param1.charAt(_loc9);
								if(!isHexDigit(_loc10))
								{
									parseError("Excepted a hex digit, but found: " + _loc10);
								}
								_loc8 = _loc8 + _loc10;
								_loc9++;
							}
							_loc2 = _loc2 + String.fromCharCode(parseInt(_loc8,16));
							_loc4 = _loc4 + 4;
							break;
						case "f":
							_loc2 = _loc2 + "\f";
							break;
						case "/":
							_loc2 = _loc2 + "/";
							break;
						case "b":
							_loc2 = _loc2 + "\b";
							break;
						default:
							_loc2 = _loc2 + ("\\" + _loc7);
					}
					if(_loc4 >= _loc5)
					{
						break;
					}
					continue;
				}
				_loc2 = _loc2 + param1.substr(_loc4);
				break;
			}
			return _loc2;
		}
		
		private function skipWhite() : void
		{
			while(isWhiteSpace(ch))
			{
				nextChar();
			}
		}
		
		private function isWhiteSpace(param1:String) : Boolean
		{
			if(param1 == " " || param1 == "\t" || param1 == "\n" || param1 == "\r")
			{
				return true;
			}
			if(!strict && param1.charCodeAt(0) == 160)
			{
				return true;
			}
			return false;
		}
		
		public function parseError(param1:String) : void
		{
			throw new JSONParseError(param1,loc,jsonString);
		}
		
		private function readString() : JSONToken
		{
			var _loc3:* = undefined;
			var _loc4:* = undefined;
			var _loc1:int = loc;
			while(true)
			{
				_loc1 = jsonString.indexOf("\"",_loc1);
				if(_loc1 >= 0)
				{
					_loc3 = 0;
					_loc4 = _loc1 - 1;
					while(jsonString.charAt(_loc4) == "\\")
					{
						_loc3++;
						_loc4--;
					}
					if(_loc3 % 2 == 0)
					{
						break;
					}
					_loc1++;
				}
				else
				{
					parseError("Unterminated string literal");
				}
			}
			var _loc2:JSONToken = new JSONToken();
			_loc2.type = JSONTokenType.STRING;
			_loc2.value = unescapeString(jsonString.substr(loc,_loc1 - loc));
			loc = _loc1 + 1;
			nextChar();
			return _loc2;
		}
		
		private function nextChar() : String
		{
			return ch = jsonString.charAt(loc++);
		}
		
		private function skipIgnored() : void
		{
			var _loc1:* = 0;
			do
			{
				_loc1 = loc;
				skipWhite();
				skipComments();
			}
			while(_loc1 != loc);
			
		}
		
		private function isHexDigit(param1:String) : Boolean
		{
			return (isDigit(param1)) || param1 >= "A" && param1 <= "F" || param1 >= "a" && param1 <= "f";
		}
		
		public function getNextToken() : JSONToken
		{
			var _loc2:String = null;
			var _loc3:String = null;
			var _loc4:String = null;
			var _loc5:String = null;
			var _loc1:JSONToken = new JSONToken();
			skipIgnored();
			switch(ch)
			{
				case "{":
					_loc1.type = JSONTokenType.LEFT_BRACE;
					_loc1.value = "{";
					nextChar();
					break;
				case "}":
					_loc1.type = JSONTokenType.RIGHT_BRACE;
					_loc1.value = "}";
					nextChar();
					break;
				case "[":
					_loc1.type = JSONTokenType.LEFT_BRACKET;
					_loc1.value = "[";
					nextChar();
					break;
				case "]":
					_loc1.type = JSONTokenType.RIGHT_BRACKET;
					_loc1.value = "]";
					nextChar();
					break;
				case ",":
					_loc1.type = JSONTokenType.COMMA;
					_loc1.value = ",";
					nextChar();
					break;
				case ":":
					_loc1.type = JSONTokenType.COLON;
					_loc1.value = ":";
					nextChar();
					break;
				case "t":
					_loc2 = "t" + nextChar() + nextChar() + nextChar();
					if(_loc2 == "true")
					{
						_loc1.type = JSONTokenType.TRUE;
						_loc1.value = true;
						nextChar();
					}
					else
					{
						parseError("Expecting \'true\' but found " + _loc2);
					}
					break;
				case "f":
					_loc3 = "f" + nextChar() + nextChar() + nextChar() + nextChar();
					if(_loc3 == "false")
					{
						_loc1.type = JSONTokenType.FALSE;
						_loc1.value = false;
						nextChar();
					}
					else
					{
						parseError("Expecting \'false\' but found " + _loc3);
					}
					break;
				case "n":
					_loc4 = "n" + nextChar() + nextChar() + nextChar();
					if(_loc4 == "null")
					{
						_loc1.type = JSONTokenType.NULL;
						_loc1.value = null;
						nextChar();
					}
					else
					{
						parseError("Expecting \'null\' but found " + _loc4);
					}
					break;
				case "N":
					_loc5 = "N" + nextChar() + nextChar();
					if(_loc5 == "NaN")
					{
						_loc1.type = JSONTokenType.NAN;
						_loc1.value = NaN;
						nextChar();
					}
					else
					{
						parseError("Expecting \'NaN\' but found " + _loc5);
					}
					break;
				case "\"":
					_loc1 = readString();
					break;
				default:
					if((isDigit(ch)) || ch == "-")
					{
						_loc1 = readNumber();
					}
					else
					{
						if(ch == "")
						{
							return null;
						}
						parseError("Unexpected " + ch + " encountered");
					}
			}
			return _loc1;
		}
	}
}
