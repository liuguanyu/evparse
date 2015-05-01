package com.adobe.serialization.json {
	public class JSONTokenizer extends Object {
		
		public function JSONTokenizer(param1:String, param2:Boolean) {
			controlCharsRegExp = new RegExp("[\\x00-\\x1F]");
			super();
			jsonString = param1;
			this.strict = param2;
			loc = 0;
			nextChar();
		}
		
		private function skipComments() : void {
			if(ch == "/") {
				nextChar();
				switch(ch) {
					case "/":
						do {
							nextChar();
						}
						while(!(ch == "\n") && !(ch == ""));
						
						nextChar();
						break;
					case "*":
						nextChar();
						while(true) {
							if(ch == "*") {
								nextChar();
								if(ch == "/") {
									break;
								}
							} else {
								nextChar();
							}
							if(ch == "") {
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
		
		private function isDigit(param1:String) : Boolean {
			return param1 >= "0" && param1 <= "9";
		}
		
		private var ch:String;
		
		private function readNumber() : JSONToken {
			var _loc3_:JSONToken = null;
			var _loc1_:* = "";
			if(ch == "-") {
				_loc1_ = _loc1_ + "-";
				nextChar();
			}
			if(!isDigit(ch)) {
				parseError("Expecting a digit");
			}
			if(ch == "0") {
				_loc1_ = _loc1_ + ch;
				nextChar();
				if(isDigit(ch)) {
					parseError("A digit cannot immediately follow 0");
				} else if(!strict && ch == "x") {
					_loc1_ = _loc1_ + ch;
					nextChar();
					if(isHexDigit(ch)) {
						_loc1_ = _loc1_ + ch;
						nextChar();
					} else {
						parseError("Number in hex format require at least one hex digit after \"0x\"");
					}
					while(isHexDigit(ch)) {
						_loc1_ = _loc1_ + ch;
						nextChar();
					}
				}
				
			} else {
				while(isDigit(ch)) {
					_loc1_ = _loc1_ + ch;
					nextChar();
				}
			}
			if(ch == ".") {
				_loc1_ = _loc1_ + ".";
				nextChar();
				if(!isDigit(ch)) {
					parseError("Expecting a digit");
				}
				while(isDigit(ch)) {
					_loc1_ = _loc1_ + ch;
					nextChar();
				}
			}
			if(ch == "e" || ch == "E") {
				_loc1_ = _loc1_ + "e";
				nextChar();
				if(ch == "+" || ch == "-") {
					_loc1_ = _loc1_ + ch;
					nextChar();
				}
				if(!isDigit(ch)) {
					parseError("Scientific notation number needs exponent value");
				}
				while(isDigit(ch)) {
					_loc1_ = _loc1_ + ch;
					nextChar();
				}
			}
			var _loc2_:Number = Number(_loc1_);
			if((isFinite(_loc2_)) && !isNaN(_loc2_)) {
				_loc3_ = new JSONToken();
				_loc3_.type = JSONTokenType.NUMBER;
				_loc3_.value = _loc2_;
				return _loc3_;
			}
			parseError("Number " + _loc2_ + " is not valid!");
			return null;
		}
		
		private var loc:int;
		
		private var jsonString:String;
		
		private var strict:Boolean;
		
		public function unescapeString(param1:String) : String {
			var _loc6_:* = undefined;
			var _loc7_:* = undefined;
			var _loc8_:* = undefined;
			var _loc9_:* = undefined;
			var _loc10_:* = undefined;
			if((strict) && (controlCharsRegExp.test(param1))) {
				parseError("String contains unescaped control character (0x00-0x1F)");
			}
			var _loc2_:* = "";
			var _loc3_:* = 0;
			var _loc4_:* = 0;
			var _loc5_:int = param1.length;
			while(true) {
				_loc3_ = param1.indexOf("\\",_loc4_);
				if(_loc3_ >= 0) {
					_loc2_ = _loc2_ + param1.substr(_loc4_,_loc3_ - _loc4_);
					_loc4_ = _loc3_ + 2;
					_loc6_ = _loc3_ + 1;
					_loc7_ = param1.charAt(_loc6_);
					switch(_loc7_) {
						case "\"":
							_loc2_ = _loc2_ + "\"";
							break;
						case "\\":
							_loc2_ = _loc2_ + "\\";
							break;
						case "n":
							_loc2_ = _loc2_ + "\n";
							break;
						case "r":
							_loc2_ = _loc2_ + "\r";
							break;
						case "t":
							_loc2_ = _loc2_ + "\t";
							break;
						case "u":
							_loc8_ = "";
							if(_loc4_ + 4 > _loc5_) {
								parseError("Unexpected end of input.  Expecting 4 hex digits after \\u.");
							}
							_loc9_ = _loc4_;
							while(_loc9_ < _loc4_ + 4) {
								_loc10_ = param1.charAt(_loc9_);
								if(!isHexDigit(_loc10_)) {
									parseError("Excepted a hex digit, but found: " + _loc10_);
								}
								_loc8_ = _loc8_ + _loc10_;
								_loc9_++;
							}
							_loc2_ = _loc2_ + String.fromCharCode(parseInt(_loc8_,16));
							_loc4_ = _loc4_ + 4;
							break;
						case "f":
							_loc2_ = _loc2_ + "\f";
							break;
						case "/":
							_loc2_ = _loc2_ + "/";
							break;
						case "b":
							_loc2_ = _loc2_ + "\b";
							break;
						default:
							_loc2_ = _loc2_ + ("\\" + _loc7_);
					}
					if(_loc4_ >= _loc5_) {
						break;
					}
					continue;
				}
				_loc2_ = _loc2_ + param1.substr(_loc4_);
				break;
			}
			return _loc2_;
		}
		
		private var controlCharsRegExp:RegExp;
		
		private function skipWhite() : void {
			while(isWhiteSpace(ch)) {
				nextChar();
			}
		}
		
		private function isWhiteSpace(param1:String) : Boolean {
			if(param1 == " " || param1 == "\t" || param1 == "\n" || param1 == "\r") {
				return true;
			}
			if(!strict && param1.charCodeAt(0) == 160) {
				return true;
			}
			return false;
		}
		
		public function parseError(param1:String) : void {
			throw new JSONParseError(param1,loc,jsonString);
		}
		
		private function readString() : JSONToken {
			var _loc3_:* = undefined;
			var _loc4_:* = undefined;
			var _loc1_:int = loc;
			while(true) {
				_loc1_ = jsonString.indexOf("\"",_loc1_);
				if(_loc1_ >= 0) {
					_loc3_ = 0;
					_loc4_ = _loc1_ - 1;
					while(jsonString.charAt(_loc4_) == "\\") {
						_loc3_++;
						_loc4_--;
					}
					if(_loc3_ % 2 == 0) {
						break;
					}
					_loc1_++;
				} else {
					parseError("Unterminated string literal");
				}
			}
			var _loc2_:JSONToken = new JSONToken();
			_loc2_.type = JSONTokenType.STRING;
			_loc2_.value = unescapeString(jsonString.substr(loc,_loc1_ - loc));
			loc = _loc1_ + 1;
			nextChar();
			return _loc2_;
		}
		
		private var obj:Object;
		
		private function nextChar() : String {
			return ch = jsonString.charAt(loc++);
		}
		
		private function skipIgnored() : void {
			var _loc1_:* = 0;
			do {
				_loc1_ = loc;
				skipWhite();
				skipComments();
			}
			while(_loc1_ != loc);
			
		}
		
		private function isHexDigit(param1:String) : Boolean {
			return (isDigit(param1)) || param1 >= "A" && param1 <= "F" || param1 >= "a" && param1 <= "f";
		}
		
		public function getNextToken() : JSONToken {
			var _loc2_:String = null;
			var _loc3_:String = null;
			var _loc4_:String = null;
			var _loc5_:String = null;
			var _loc1_:JSONToken = new JSONToken();
			skipIgnored();
			switch(ch) {
				case "{":
					_loc1_.type = JSONTokenType.LEFT_BRACE;
					_loc1_.value = "{";
					nextChar();
					break;
				case "}":
					_loc1_.type = JSONTokenType.RIGHT_BRACE;
					_loc1_.value = "}";
					nextChar();
					break;
				case "[":
					_loc1_.type = JSONTokenType.LEFT_BRACKET;
					_loc1_.value = "[";
					nextChar();
					break;
				case "]":
					_loc1_.type = JSONTokenType.RIGHT_BRACKET;
					_loc1_.value = "]";
					nextChar();
					break;
				case ",":
					_loc1_.type = JSONTokenType.COMMA;
					_loc1_.value = ",";
					nextChar();
					break;
				case ":":
					_loc1_.type = JSONTokenType.COLON;
					_loc1_.value = ":";
					nextChar();
					break;
				case "t":
					_loc2_ = "t" + nextChar() + nextChar() + nextChar();
					if(_loc2_ == "true") {
						_loc1_.type = JSONTokenType.TRUE;
						_loc1_.value = true;
						nextChar();
					} else {
						parseError("Expecting \'true\' but found " + _loc2_);
					}
					break;
				case "f":
					_loc3_ = "f" + nextChar() + nextChar() + nextChar() + nextChar();
					if(_loc3_ == "false") {
						_loc1_.type = JSONTokenType.FALSE;
						_loc1_.value = false;
						nextChar();
					} else {
						parseError("Expecting \'false\' but found " + _loc3_);
					}
					break;
				case "n":
					_loc4_ = "n" + nextChar() + nextChar() + nextChar();
					if(_loc4_ == "null") {
						_loc1_.type = JSONTokenType.NULL;
						_loc1_.value = null;
						nextChar();
					} else {
						parseError("Expecting \'null\' but found " + _loc4_);
					}
					break;
				case "N":
					_loc5_ = "N" + nextChar() + nextChar();
					if(_loc5_ == "NaN") {
						_loc1_.type = JSONTokenType.NAN;
						_loc1_.value = NaN;
						nextChar();
					} else {
						parseError("Expecting \'NaN\' but found " + _loc5_);
					}
					break;
				case "\"":
					_loc1_ = readString();
					break;
				default:
					if((isDigit(ch)) || ch == "-") {
						_loc1_ = readNumber();
					} else {
						if(ch == "") {
							return null;
						}
						parseError("Unexpected " + ch + " encountered");
					}
			}
			return _loc1_;
		}
	}
}
