package com.qiyi.player.base.logging.targets
{
	import com.qiyi.player.base.logging.LogEventLevel;
	
	public class DebugTarget extends LineFormattedTarget
	{
		
		private var _flag:String;
		
		public function DebugTarget(param1:String = "")
		{
			super();
			this._flag = param1;
		}
		
		override protected function internalLog(param1:int, param2:String) : void
		{
			switch(param1)
			{
				case LogEventLevel.WARN:
					DebugTarget.warning(param2);
					break;
				case LogEventLevel.ERROR:
				case LogEventLevel.FATAL:
					DebugTarget.error(param2);
					break;
				default:
					DebugTarget.log(param2);
			}
		}
	}
}

import flash.net.LocalConnection;
import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.display.Stage;
import flash.system.System;
import flash.events.StatusEvent;

class Debug extends Object
{
	
	public static const NAME:String = "com.qiyi.livePlayer.utils.Debug";
	
	public static const VERSION:String = "0.74";
	
	public static var password:String = "CDC309AF";
	
	public static var RED:uint = 13369344;
	
	public static var GREEN:uint = 52224;
	
	public static var BLUE:uint = 6710988;
	
	public static var PINK:uint = 13369548;
	
	public static var YELLOW:uint = 13421568;
	
	public static var LIGHT_BLUE:uint = 52428;
	
	public static var ignoreStatus:Boolean = true;
	
	public static var secure:Boolean = false;
	
	public static var secureDomain:String = "*";
	
	public static var allowLog:Boolean = true;
	
	private static const DOMAIN:String = "com.carlcalderon.Arthropod";
	
	private static const CHECK:String = ".161E714B6C1A76DE7B9865F88B32FCCE8FABA7B5.1";
	
	private static const TYPE:String = "app";
	
	private static const CONNECTION:String = "arthropod";
	
	private static const LOG_OPERATION:String = "debug";
	
	private static const ERROR_OPERATION:String = "debugError";
	
	private static const WARNING_OPERATION:String = "debugWarning";
	
	private static const ARRAY_OPERATION:String = "debugArray";
	
	private static const BITMAP_OPERATION:String = "debugBitmapData";
	
	private static const OBJECT_OPERATION:String = "debugObject";
	
	private static const MEMORY_OPERATION:String = "debugMemory";
	
	private static const CLEAR_OPERATION:String = "debugClear";
	
	private static var lc:LocalConnection = new LocalConnection();
	
	private static var hasEventListeners:Boolean = false;
	
	function Debug()
	{
		super();
	}
	
	public static function log(param1:*, param2:uint = 16711422) : Boolean
	{
		return send(LOG_OPERATION,String(param1),param2);
	}
	
	public static function logWP(param1:*, param2:uint = 16711422) : Boolean
	{
		return send(LOG_OPERATION,String(param1),param2);
	}
	
	public static function error(param1:*) : Boolean
	{
		return send(ERROR_OPERATION,String(param1),13369344);
	}
	
	public static function warning(param1:*) : Boolean
	{
		return send(WARNING_OPERATION,String(param1),13421568);
	}
	
	public static function clear() : Boolean
	{
		return send(CLEAR_OPERATION,0,0);
	}
	
	public static function array(param1:Array) : Boolean
	{
		return send(ARRAY_OPERATION,param1,null);
	}
	
	public static function bitmap(param1:*, param2:String = null) : Boolean
	{
		var _loc3:BitmapData = new BitmapData(100,100,true,16777215);
		var _loc4:Matrix = new Matrix();
		var _loc5:Number = 100 / (param1.width >= param1.height?param1.width:param1.height);
		_loc4.scale(_loc5,_loc5);
		_loc3.draw(param1,_loc4,null,null,null,true);
		var _loc6:Rectangle = new Rectangle(0,0,Math.floor(param1.width * _loc5),Math.floor(param1.height * _loc5));
		return send(BITMAP_OPERATION,_loc3.getPixels(_loc6),{
			"bounds":_loc6,
			"lbl":param2
		});
	}
	
	public static function snapshot(param1:Stage, param2:String = null) : Boolean
	{
		if(param1)
		{
			return bitmap(param1,param2);
		}
		return false;
	}
	
	public static function object(param1:*) : Boolean
	{
		return send(OBJECT_OPERATION,param1,null);
	}
	
	public static function memory() : Boolean
	{
		return send(MEMORY_OPERATION,System.totalMemory,null);
	}
	
	private static function send(param1:String, param2:*, param3:*) : Boolean
	{
		var operation:String = param1;
		var value:* = param2;
		var prop:* = param3;
		if(!secure)
		{
			lc.allowInsecureDomain("*");
		}
		else
		{
			lc.allowDomain(secureDomain);
		}
		if(!hasEventListeners)
		{
			if(ignoreStatus)
			{
				lc.addEventListener(StatusEvent.STATUS,ignore);
			}
			else
			{
				lc.addEventListener(StatusEvent.STATUS,status);
			}
			hasEventListeners = true;
		}
		if(allowLog)
		{
			try
			{
				lc.send(TYPE + "#" + DOMAIN + CHECK + ":" + CONNECTION,operation,password,value,prop);
				return true;
			}
			catch(e:*)
			{
				return false;
			}
			return false;
		}
		return false;
	}
	
	private static function status(param1:StatusEvent) : void
	{
		trace("Arthropod status:\n" + param1.toString());
	}
	
	private static function ignore(param1:StatusEvent) : void
	{
	}
}
