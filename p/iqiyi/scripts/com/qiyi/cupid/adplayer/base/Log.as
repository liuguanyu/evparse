package com.qiyi.cupid.adplayer.base
{
	import flash.external.ExternalInterface;
	import com.adobe.serialization.json.JSON;
	
	public class Log extends Object
	{
		
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
		
		{
			init();
		}
		
		private var name:String;
		
		private var label:String;
		
		private var color:String;
		
		private var isEnabled:Boolean = false;
		
		public function Log(param1:String)
		{
			super();
			this.name = param1;
			this.isEnabled = shouldEnable(param1);
			if(this.isEnabled)
			{
				this.label = PREFIX + param1;
				this.color = getColor();
			}
		}
		
		private static function getColor() : String
		{
			return "color:" + COLORS[colorIndex++ % COLORS.length];
		}
		
		private static function shouldEnable(param1:String) : Boolean
		{
			var _loc2:* = 0;
			var _loc3:RegExp = null;
			_loc2 = 0;
			while(_loc3 = skips[_loc2++])
			{
				if(_loc3.test(param1))
				{
					return false;
				}
			}
			_loc2 = 0;
			while(_loc3 = names[_loc2++])
			{
				if(_loc3.test(param1))
				{
					return true;
				}
			}
			return false;
		}
		
		private static function getTime() : String
		{
			var _loc1:Date = new Date();
			var _loc2:String = _loc1.month + 1 + "-" + _loc1.date;
			return _loc2 + " " + [_loc1.hours,_loc1.minutes,_loc1.seconds,_loc1.milliseconds].join(":");
		}
		
		private static function saveLogs(param1:String, param2:Array) : void
		{
			var _loc3:Array = ["[" + getTime() + " " + param1 + "]"];
			_loc3.push.apply(_loc3,param2);
			logs.push(_loc3);
			if(logs.length > MAX_LOG_LEN)
			{
				logs.shift();
			}
		}
		
		private static function init() : void
		{
			var _loc4:String = null;
			var _loc1:String = getLocalStorage();
			if(!_loc1)
			{
				return;
			}
			var _loc2:Array = _loc1.split(new RegExp("[\\s,]+"));
			var _loc3:* = 0;
			while(_loc3 < _loc2.length)
			{
				_loc4 = _loc2[_loc3];
				if(_loc4)
				{
					_loc4 = _loc4.replace(new RegExp("\\*","g"),".*?");
					if("-" == _loc4.charAt(0))
					{
						skips.push(new RegExp("^" + _loc4.substr(1) + "$"));
					}
					else
					{
						names.push(new RegExp("^" + _loc4 + "$"));
					}
				}
				_loc3++;
			}
		}
		
		private static function getLocalStorage() : String
		{
			var _loc1:* = "function(arr) {" + "var ls = window.localStorage || {};" + "return ls." + LS_KEY + "}";
			return safeExec(_loc1) || "";
		}
		
		private static function safeExec(... rest) : *
		{
			var args:Array = rest;
			try
			{
				if(ExternalInterface.available)
				{
					return ExternalInterface.call.apply(ExternalInterface,args);
				}
			}
			catch(ignore:Error)
			{
			}
		}
		
		public function debug(... rest) : void
		{
			this.console("debug",rest);
		}
		
		public function error(... rest) : void
		{
			this.console("error",rest);
		}
		
		public function log(... rest) : void
		{
			this.console("log",rest);
		}
		
		public function info(... rest) : void
		{
			this.console("info",rest);
		}
		
		public function warn(... rest) : void
		{
			this.console("warn",rest);
		}
		
		private function console(param1:String, param2:Array) : void
		{
			var level:String = param1;
			var args:Array = param2;
			saveLogs(this.name,args);
			if(!this.isEnabled)
			{
				return;
			}
			curr = new Date().time;
			ms = curr - ((prev) || (curr));
			prev = curr;
			var main:String = "%c" + this.label + "%c";
			var arr:Array = [null,this.color,INHERIT];
			var i:int = 0;
			while(i < args.length)
			{
				arr.push(args[i]);
				main = main + " %o";
				i++;
			}
			arr.push(this.color);
			main = main + ("%c +" + ms + "ms");
			arr[0] = main;
			var jsonp:String = arr.map(function(param1:*, param2:*, param3:*):String
			{
				var item:* = param1;
				var i:* = param2;
				var arr:* = param3;
				try
				{
					return JSON.encode(item);
				}
				catch(ignore:Error)
				{
				}
				return "";
			}).join(", ");
			jsonp = "function(){console." + level + "(" + jsonp + ")}";
			safeExec(jsonp);
		}
	}
}
