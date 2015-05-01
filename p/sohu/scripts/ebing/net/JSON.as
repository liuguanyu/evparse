package ebing.net {
	public class JSON extends Object {
		
		public function JSON() {
			super();
		}
		
		public var at:Number = 0;
		
		public var ch:String = " ";
		
		public var text:String;
		
		public function parse(param1:String) : Object {
			this.text = param1;
			return this.value();
		}
		
		public function value() : * {
			this.white();
			switch(this.ch) {
				case "{":
					return this.object();
				case "[":
					return this.array();
				case "\"":
					return this.string();
				case "-":
					return this.number();
				default:
					return this.ch >= "0" && this.ch <= "9"?this.number():this.word();
			}
		}
		
		public function error(param1:*) : void {
			throw {
				"name":"JSONError",
				"message":param1,
				"at":this.at - 1,
				"text":this.text
			};
		}
		
		public function next() : * {
			this.ch = this.text.charAt(this.at);
			this.at = this.at + 1;
			return this.ch;
		}
		
		public function white() : * {
			while(this.ch) {
				if(this.ch <= " ") {
					this.next();
					continue;
				}
				if(this.ch == "/") {
					switch(this.next()) {
						case "/":
							while((this.next()) && (!(this.ch == "\n")) && !(this.ch == "\r")) {
							}
							break;
						case "*":
							this.next();
							while(true) {
								if(this.ch) {
									if(this.ch == "*") {
										if(this.next() == "/") {
											break;
										}
									} else {
										this.next();
									}
								} else {
									this.error("Unterminated comment");
								}
							}
							this.next();
							break;
						default:
							this.error("Syntax error");
					}
					continue;
				}
				break;
			}
		}
		
		public function string() : * {
			var _loc1_:* = undefined;
			var _loc3_:* = undefined;
			var _loc4_:* = undefined;
			var _loc2_:* = "";
			var _loc5_:* = false;
			if(this.ch == "\"") {
				while(this.next()) {
					if(this.ch == "\"") {
						this.next();
						return _loc2_;
					}
					if(this.ch == "\\") {
						switch(this.next()) {
							case "b":
								_loc2_ = _loc2_ + "\b";
								break;
							case "f":
								_loc2_ = _loc2_ + "\f";
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
								_loc4_ = 0;
								_loc1_ = 0;
								while(_loc1_ < 4) {
									_loc3_ = parseInt(this.next(),16);
									if(!isFinite(_loc3_)) {
										_loc5_ = true;
										break;
									}
									_loc4_ = _loc4_ * 16 + _loc3_;
									_loc1_ = _loc1_ + 1;
								}
								if(_loc5_) {
									_loc5_ = false;
									break;
								}
								_loc2_ = _loc2_ + String.fromCharCode(_loc4_);
								break;
							default:
								_loc2_ = _loc2_ + this.ch;
						}
					} else {
						_loc2_ = _loc2_ + this.ch;
					}
				}
			}
			this.error("Bad string");
		}
		
		public function array() : * {
			var _loc1_:Array = [];
			if(this.ch == "[") {
				this.next();
				this.white();
				if(this.ch == "]") {
					this.next();
					return _loc1_;
				}
				while(this.ch) {
					_loc1_.push(this.value());
					this.white();
					if(this.ch == "]") {
						this.next();
						return _loc1_;
					}
					if(this.ch != ",") {
						break;
					}
					this.next();
					this.white();
				}
			}
			this.error("Bad array");
		}
		
		public function object() : * {
			var _loc1_:Object = null;
			var _loc2_:Object = {};
			if(this.ch == "{") {
				this.next();
				this.white();
				if(this.ch == "}") {
					this.next();
					return _loc2_;
				}
				while(this.ch) {
					_loc1_ = this.string();
					this.white();
					if(this.ch != ":") {
						break;
					}
					this.next();
					_loc2_[_loc1_] = this.value();
					this.white();
					if(this.ch == "}") {
						this.next();
						return _loc2_;
					}
					if(this.ch != ",") {
						break;
					}
					this.next();
					this.white();
				}
			}
			this.error("Bad object");
		}
		
		public function number() : * {
			var _loc2_:* = undefined;
			var _loc1_:* = "";
			if(this.ch == "-") {
				_loc1_ = "-";
				this.next();
			}
			while(this.ch >= "0" && this.ch <= "9") {
				_loc1_ = _loc1_ + this.ch;
				this.next();
			}
			if(this.ch == ".") {
				_loc1_ = _loc1_ + ".";
				while((this.next()) && (this.ch >= "0") && this.ch <= "9") {
					_loc1_ = _loc1_ + this.ch;
				}
			}
			_loc2_ = _loc1_;
			if(!isFinite(_loc2_)) {
				this.error("Bad number");
				return;
			}
			return _loc2_;
		}
		
		public function word() : * {
			switch(this.ch) {
				case "t":
					if(this.next() == "r" && this.next() == "u" && this.next() == "e") {
						this.next();
						return true;
					}
					break;
				case "f":
					if(this.next() == "a" && this.next() == "l" && this.next() == "s" && this.next() == "e") {
						this.next();
						return false;
					}
					break;
				case "n":
					if(this.next() == "u" && this.next() == "l" && this.next() == "l") {
						this.next();
						return null;
					}
					break;
			}
			this.error("Syntax error");
		}
	}
}
