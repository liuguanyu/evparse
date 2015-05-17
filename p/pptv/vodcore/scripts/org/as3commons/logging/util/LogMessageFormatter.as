package org.as3commons.logging.util
{
	public final class LogMessageFormatter extends Object
	{
		
		private const STATIC_TYPE:int = 1;
		
		private const MESSAGE_TYPE:int = 2;
		
		private const MESSAGE_DQT_TYPE:int = 3;
		
		private const TIME_TYPE:int = 4;
		
		private const TIME_UTC_TYPE:int = 5;
		
		private const LOG_TIME_TYPE:int = 6;
		
		private const DATE_TYPE:int = 7;
		
		private const DATE_UTC_TYPE:int = 8;
		
		private const LOG_LEVEL_TYPE:int = 9;
		
		private const SWF_TYPE:int = 10;
		
		private const SHORT_SWF_TYPE:int = 11;
		
		private const NAME_TYPE:int = 12;
		
		private const SHORT_NAME_TYPE:int = 13;
		
		private const GMT_OFFSET_TYPE:int = 14;
		
		private const PERSON_TYPE:int = 15;
		
		private const AT_PERSON_TYPE:int = 16;
		
		private const TYPES:Object = {
			"message":this.MESSAGE_TYPE,
			"message_dqt":this.MESSAGE_DQT_TYPE,
			"time":this.TIME_TYPE,
			"timeUTC":this.TIME_UTC_TYPE,
			"logTime":this.LOG_TIME_TYPE,
			"date":this.DATE_TYPE,
			"dateUTC":this.DATE_UTC_TYPE,
			"logLevel":this.LOG_LEVEL_TYPE,
			"swf":this.SWF_TYPE,
			"shortSWF":this.SHORT_SWF_TYPE,
			"name":this.NAME_TYPE,
			"shortName":this.SHORT_NAME_TYPE,
			"gmt":this.GMT_OFFSET_TYPE,
			"person":this.PERSON_TYPE,
			"atPerson":this.AT_PERSON_TYPE
		};
		
		private const _now:Date = new Date();
		
		private const _braceRegexp:RegExp = new RegExp("{(?P<field>[a-zA-Z_]+)}","g");
		
		private var _firstNode:FormatNode;
		
		private var _hasMessageNode:Boolean = false;
		
		private var _hasTimeNode:Boolean = false;
		
		public function LogMessageFormatter(param1:String)
		{
			var _loc3:Object = null;
			var _loc4:FormatNode = null;
			var _loc5:FormatNode = null;
			var _loc6:String = null;
			var _loc7:* = 0;
			var _loc8:FormatNode = null;
			super();
			var _loc2:* = 0;
			while(_loc3 = this._braceRegexp.exec(param1))
			{
				if(_loc7 = this.TYPES[_loc3["field"]])
				{
					if(_loc2 != _loc3["index"])
					{
						_loc6 = param1.substring(_loc2,_loc3["index"]);
						_loc5 = new FormatNode();
						_loc5.type = this.STATIC_TYPE;
						_loc5.content = _loc6;
						if(_loc4)
						{
							_loc4.next = _loc5;
						}
						else
						{
							this._firstNode = _loc5;
						}
						_loc4 = _loc5;
					}
					_loc8 = new FormatNode();
					_loc8.type = _loc7;
					if(_loc7 == this.MESSAGE_TYPE || _loc7 == this.MESSAGE_DQT_TYPE)
					{
						this._hasMessageNode = true;
					}
					else if(_loc7 == this.TIME_TYPE || _loc7 == this.TIME_UTC_TYPE || _loc7 == this.DATE_TYPE || _loc7 == this.DATE_UTC_TYPE || _loc7 == this.LOG_TIME_TYPE)
					{
						this._hasTimeNode = true;
					}
					
					_loc2 = _loc3["index"] + _loc3[0]["length"];
					if(_loc4)
					{
						_loc4.next = _loc8;
					}
					else
					{
						this._firstNode = _loc8;
					}
					_loc4 = _loc8;
				}
			}
			if(_loc2 != param1.length)
			{
				_loc6 = param1.substring(_loc2);
				_loc5 = new FormatNode();
				_loc5.type = this.STATIC_TYPE;
				_loc5.content = _loc6;
				if(_loc4)
				{
					_loc4.next = _loc5;
				}
				else
				{
					this._firstNode = _loc5;
				}
			}
		}
		
		public function format(param1:String, param2:String, param3:int, param4:Number, param5:String, param6:Array, param7:String) : String
		{
			var _loc10:* = 0;
			var _loc11:* = 0;
			var _loc12:* = undefined;
			var _loc13:* = 0;
			var _loc14:String = null;
			var _loc15:String = null;
			var _loc16:String = null;
			var _loc17:String = null;
			var _loc8:* = "";
			var _loc9:FormatNode = this._firstNode;
			if((this._hasMessageNode) && (param5) && (param6))
			{
				_loc10 = param6.length;
				_loc11 = 0;
				while(_loc11 < _loc10)
				{
					_loc12 = param6[_loc11];
					var param5:String = param5.split("{" + _loc11 + "}").join(_loc12);
					_loc11++;
				}
			}
			if(this._hasTimeNode)
			{
				this._now.time = isNaN(param4)?0.0:START_TIME + param4;
			}
			while(_loc9)
			{
				_loc13 = _loc9.type;
				if(_loc13 < 7)
				{
					if(_loc13 < 4)
					{
						if(_loc13 == this.STATIC_TYPE)
						{
							_loc8 = _loc8 + _loc9.content;
						}
						else if(_loc13 == this.MESSAGE_TYPE)
						{
							_loc8 = _loc8 + param5;
						}
						else if(param5)
						{
							_loc8 = _loc8 + param5.split("\"").join("\\\"").split("\n").join("\\n");
						}
						else
						{
							_loc8 = _loc8 + param5;
						}
						
						
					}
					else if(_loc13 == this.TIME_TYPE)
					{
						_loc8 = _loc8 + (this._now.hours + ":" + this._now.minutes + ":" + this._now.seconds + "." + this._now.milliseconds);
					}
					else if(_loc13 == this.TIME_UTC_TYPE)
					{
						_loc8 = _loc8 + (this._now.hoursUTC + ":" + this._now.minutesUTC + ":" + this._now.secondsUTC + "." + this._now.millisecondsUTC);
					}
					else
					{
						_loc14 = this._now.hoursUTC.toString();
						if(_loc14.length == 1)
						{
							_loc14 = "0" + _loc14;
						}
						_loc15 = this._now.minutesUTC.toString();
						if(_loc15.length == 1)
						{
							_loc15 = "0" + _loc15;
						}
						_loc16 = this._now.secondsUTC.toString();
						if(_loc16.length == 1)
						{
							_loc16 = "0" + _loc16;
						}
						_loc17 = this._now.millisecondsUTC.toString();
						if(_loc17.length == 1)
						{
							_loc17 = "00" + _loc17;
						}
						else if(_loc17.length == 2)
						{
							_loc17 = "0" + _loc17;
						}
						
						_loc8 = _loc8 + (_loc14 + ":" + _loc15 + ":" + _loc16 + "." + _loc17);
					}
					
					
				}
				else if(_loc13 < 13)
				{
					if(_loc13 < 10)
					{
						if(_loc13 == this.DATE_TYPE)
						{
							_loc8 = _loc8 + (this._now.fullYear + "/" + (this._now.month + 1) + "/" + this._now.date);
						}
						else if(_loc13 == this.DATE_UTC_TYPE)
						{
							_loc8 = _loc8 + (this._now.fullYearUTC + "/" + (this._now.monthUTC + 1) + "/" + this._now.dateUTC);
						}
						else if(param3)
						{
							_loc8 = _loc8 + (LEVEL_NAMES[param3] || "FATAL");
						}
						
						
					}
					else if(_loc13 == this.SWF_TYPE)
					{
						_loc8 = _loc8 + SWF_URL;
					}
					else if(_loc13 == this.SHORT_SWF_TYPE)
					{
						_loc8 = _loc8 + SWF_SHORT_URL;
					}
					else
					{
						_loc8 = _loc8 + param1;
					}
					
					
				}
				else if(_loc13 == this.SHORT_NAME_TYPE)
				{
					_loc8 = _loc8 + param2;
				}
				else if(_loc13 == this.GMT_OFFSET_TYPE)
				{
					_loc8 = _loc8 + GMT;
				}
				else if(_loc13 == this.PERSON_TYPE)
				{
					if(param7)
					{
						_loc8 = _loc8 + param7;
					}
				}
				else if(param7)
				{
					_loc8 = _loc8 + ("@" + param7);
				}
				
				
				
				
				
				_loc9 = _loc9.next;
			}
			return _loc8;
		}
	}
}

final class FormatNode extends Object
{
	
	public var next:FormatNode;
	
	public var content:String;
	
	public var param:int;
	
	public var type:int;
	
	function FormatNode()
	{
		super();
	}
}
