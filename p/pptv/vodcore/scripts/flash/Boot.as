package flash
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.Stage;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getQualifiedClassName;
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	public dynamic class Boot extends MovieClip
	{
		
		public static var tf:TextField;
		
		public static var lines:Array;
		
		public static var lastError:Error;
		
		public static var skip_constructor:Boolean;
		
		public function Boot()
		{
			if(Boot.skip_constructor)
			{
				return;
			}
			super();
		}
		
		public static function enum_to_string(param1:Object) : String
		{
			var _loc5:* = null;
			if(param1.params == null)
			{
				return param1.tag;
			}
			var _loc2:Array = [];
			var _loc3:* = 0;
			var _loc4:Array = param1.params;
			while(_loc3 < (_loc4.length))
			{
				_loc5 = _loc4[_loc3];
				_loc3++;
				_loc2.push(Boot.__string_rec(_loc5,""));
			}
			return param1.tag + "(" + _loc2.join(",") + ")";
		}
		
		public static function __instanceof(param1:*, param2:*) : Boolean
		{
			var _loc4:* = null;
			try
			{
				if(param2 == Dynamic)
				{
					return true;
				}
				return param1 is param2;
			}
		}
		
		public static function __clear_trace() : void
		{
			if(Boot.tf == null)
			{
				return;
			}
			Boot.tf.parent.removeChild(Boot.tf);
			Boot.tf = null;
			Boot.lines = null;
		}
		
		public static function __set_trace_color(param1:uint) : void
		{
			Boot.getTrace().textColor = param1;
		}
		
		public static function getTrace() : TextField
		{
			var _loc2:* = null as TextFormat;
			var _loc1:MovieClip = Lib.current;
			if(Boot.tf == null)
			{
				Boot.tf = new TextField();
				_loc2 = Boot.tf.getTextFormat();
				_loc2.font = "_sans";
				Boot.tf.defaultTextFormat = _loc2;
				Boot.tf.selectable = false;
				Boot.tf.width = _loc1.stage == null?800:_loc1.stage.stageWidth;
				Boot.tf.autoSize = TextFieldAutoSize.LEFT;
				Boot.tf.mouseEnabled = false;
			}
			if(_loc1.stage == null)
			{
				_loc1.addChild(Boot.tf);
			}
			else
			{
				_loc1.stage.addChild(Boot.tf);
			}
			return Boot.tf;
		}
		
		public static function __trace(param1:*, param2:Object) : void
		{
			var _loc3:TextField = Boot.getTrace();
			var _loc4:String = param2 == null?"(null)":param2.fileName + ":" + (param2.lineNumber);
			if(Boot.lines == null)
			{
				Boot.lines = [];
			}
			Boot.lines = Boot.lines.concat((_loc4 + ": " + Boot.__string_rec(param1,"")).split("\n"));
			_loc3.text = Boot.lines.join("\n");
			var _loc5:Stage = Lib.current.stage;
			if(_loc5 == null)
			{
				return;
			}
			while(true)
			{
				if((Boot.lines.length) > 1)
				{
					false;
				}
				if(!false)
				{
					break;
				}
				Boot.lines.shift();
				_loc3.text = Boot.lines.join("\n");
			}
		}
		
		public static function __string_rec(param1:*, param2:String) : String
		{
			var _loc4:* = null as String;
			var _loc5:* = null as Array;
			var _loc6:* = null as Array;
			var _loc7:* = 0;
			var _loc8:* = null;
			var _loc9:* = null as String;
			var _loc10:* = false;
			var _loc11:* = 0;
			var _loc12:* = 0;
			var _loc13:* = null as String;
			var _loc3:String = getQualifiedClassName(param1);
			_loc4 = _loc3;
			if(_loc4 == "Object")
			{
				_loc7 = 0;
				_loc6 = [];
				_loc8 = param1;
				while(param1 hasNext _loc7)
				{
					_loc6.push(nextName(_loc7,_loc8));
				}
				_loc5 = _loc6;
				_loc9 = "{";
				_loc10 = true;
				_loc7 = 0;
				_loc11 = _loc5.length;
				while(_loc7 < _loc11)
				{
					_loc7++;
					_loc12 = _loc7;
					_loc13 = _loc5[_loc12];
					if(_loc10)
					{
						_loc10 = false;
					}
					else
					{
						_loc9 = _loc9 + ",";
					}
					_loc9 = _loc9 + (" " + _loc13 + " : " + Boot.__string_rec(param1[_loc13],param2));
				}
				if(!_loc10)
				{
					_loc9 = _loc9 + " ";
				}
				_loc9 = _loc9 + "}";
				return _loc9;
			}
			if(_loc4 == "Array")
			{
				if(param1 == Array)
				{
					return "#Array";
				}
				_loc9 = "[";
				_loc10 = true;
				_loc5 = param1;
				_loc7 = 0;
				_loc11 = _loc5.length;
				while(_loc7 < _loc11)
				{
					_loc7++;
					_loc12 = _loc7;
					if(_loc10)
					{
						_loc10 = false;
					}
					else
					{
						_loc9 = _loc9 + ",";
					}
					_loc9 = _loc9 + Boot.__string_rec(_loc5[_loc12],param2);
				}
				return _loc9 + "]";
			}
			_loc4 = typeof param1;
			if(_loc4 == "function")
			{
				return "<function>";
			}
			return new String(param1);
		}
		
		public static function __unprotect__(param1:String) : String
		{
			return param1;
		}
		
		public function start() : void
		{
			var _loc3:* = null;
			var _loc2:MovieClip = Lib.current;
			try
			{
				if(_loc2 == this)
				{
					false;
				}
				if(false)
				{
					false;
				}
				if(false)
				{
					_loc2.stage.align = "TOP_LEFT";
				}
			}
		}
		
		public function init() : void
		{
			Boot.lastError = new Error();
			throw "assert";
		}
		
		public function doInitDelay(param1:*) : void
		{
			Lib.current.removeEventListener(Event.ADDED_TO_STAGE,doInitDelay);
			start();
		}
	}
}
