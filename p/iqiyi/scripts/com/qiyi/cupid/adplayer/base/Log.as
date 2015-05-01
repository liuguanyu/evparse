package com.qiyi.cupid.adplayer.base {
	import flash.external.ExternalInterface;
	import com.adobe.serialization.json.JSON;
	
	public class Log extends Object {
		 {
			init();
		}
		
		public function Log(param1:String) {
			super();
			this.name = param1;
			this.isEnabled = shouldEnable(param1);
			if(this.isEnabled) {
				this.label = PREFIX + param1;
				this.color = getColor();
			}
		}
		
		public static var logs:Array = [];
		
		private static const INHERIT:String = "color:inherit";
		
		private static const PREFIX:String = "ad:flash:loader:";
		
		private static const LS_KEY:String = "addebug";
		
		private static const MAX_LOG_LEN:int = 3000;
		
		private static const COLORS:Array = "lightseagreen forestgreen goldenrod dodgerblue darkorchid crimson".split(" ").reverse();
		
		private static var colorIndex:int = 0;
		
		private static var names:Array = [];
		
		private static var skips:Array = [];
		
		private static var prev:Number;
		
		private static var curr:Number;
		
		private static var ms:Number;
		
		private static function getColor() : String {
			return "color:" + COLORS[colorIndex++ % COLORS.length];
		}
		
		private static function shouldEnable(param1:String) : Boolean {
			var _loc2_:* = 0;
			var _loc3_:RegExp = null;
			_loc2_ = 0;
			while(_loc3_ = skips[_loc2_++]) {
				if(_loc3_.test(param1)) {
					return false;
				}
			}
			_loc2_ = 0;
			while(_loc3_ = names[_loc2_++]) {
				if(_loc3_.test(param1)) {
					return true;
				}
			}
			return false;
		}
		
		private static function getTime() : String {
			var _loc1_:Date = new Date();
			var _loc2_:String = _loc1_.month + 1 + "-" + _loc1_.date;
			return _loc2_ + " " + [_loc1_.hours,_loc1_.minutes,_loc1_.seconds,_loc1_.milliseconds].join(":");
		}
		
		private static function saveLogs(param1:String, param2:Array) : void {
			var _loc3_:Array = ["[" + getTime() + " " + param1 + "]"];
			_loc3_.push.apply(_loc3_,param2);
			logs.push(_loc3_);
			if(logs.length > MAX_LOG_LEN) {
				logs.shift();
			}
		}
		
		private static function init() : void {
			var _loc4_:String = null;
			var _loc1_:String = getLocalStorage();
			if(!_loc1_) {
				return;
			}
			var _loc2_:Array = _loc1_.split(new RegExp("[\\s,]+"));
			var _loc3_:* = 0;
			while(_loc3_ < _loc2_.length) {
				_loc4_ = _loc2_[_loc3_];
				if(_loc4_) {
					_loc4_ = _loc4_.replace(new RegExp("\\*","g"),".*?");
					if("-" == _loc4_.charAt(0)) {
						skips.push(new RegExp("^" + _loc4_.substr(1) + "$"));
					} else {
						names.push(new RegExp("^" + _loc4_ + "$"));
					}
				}
				_loc3_++;
			}
		}
		
		private static function getLocalStorage() : String {
			var _loc1_:* = "function(arr) {" + "var ls = window.localStorage || {};" + "return ls." + LS_KEY + "}";
			return safeExec(_loc1_) || "";
		}
		
		private static function safeExec(... rest) : * {
			var args:Array = rest;
			try {
				if(ExternalInterface.available) {
					return ExternalInterface.call.apply(ExternalInterface,args);
				}
			}
			catch(ignore:Error) {
			}
		}
		
		private var name:String;
		
		private var label:String;
		
		private var color:String;
		
		private var isEnabled:Boolean = false;
		
		public function debug(... rest) : void {
			this.console("debug",rest);
		}
		
		public function error(... rest) : void {
			this.console("error",rest);
		}
		
		public function log(... rest) : void {
			this.console("log",rest);
		}
		
		public function info(... rest) : void {
			this.console("info",rest);
		}
		
		public function warn(... rest) : void {
			this.console("warn",rest);
		}
		
		private function console(param1:String, param2:Array) : void {
			var level:String = param1;
			var args:Array = param2;
			saveLogs(this.name,args);
			if(!this.isEnabled) {
				return;
			}
			curr = new Date().time;
			ms = curr - ((prev) || (curr));
			prev = curr;
			var main:String = "%c" + this.label + "%c";
			var arr:Array = [null,this.color,INHERIT];
			var i:int = 0;
			while(i < args.length) {
				arr.push(args[i]);
				main = main + " %o";
				i++;
			}
			arr.push(this.color);
			main = main + ("%c +" + ms + "ms");
			arr[0] = main;
			var jsonp:String = arr.map(function(param1:*, param2:*, param3:*):String {
				var item:* = param1;
				var i:* = param2;
				var arr:* = param3;
				try {
					return JSON.encode(item);
				}
				catch(ignore:Error) {
				}
				return "";
			}).join(", ");
			jsonp = "function(){console." + level + "(" + jsonp + ")}";
			safeExec(jsonp);
		}
	}
}
