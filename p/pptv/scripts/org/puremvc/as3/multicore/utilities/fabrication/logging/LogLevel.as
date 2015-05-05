package org.puremvc.as3.multicore.utilities.fabrication.logging
{
   public class LogLevel extends Object
   {
      
      public static const DEFAULT:LogLevel = new LogLevel(50,"DEBUG");
      
      public static const DEBUG:LogLevel = new LogLevel(50,"DEBUG");
      
      public static const INFO:LogLevel = new LogLevel(40,"INFO");
      
      public static const WARN:LogLevel = new LogLevel(30,"WARN");
      
      public static const ERROR:LogLevel = new LogLevel(20,"ERROR");
      
      public static const FATAL:LogLevel = new LogLevel(10,"FATAL");
      
      public static const NONE:LogLevel = new LogLevel(0,"NONE");
      
      private var _level:uint;
      
      private var _name:String;
      
      public function LogLevel(param1:uint = 50, param2:String = "DEBUG")
      {
         super();
         this._level = param1;
         this._name = param2;
      }
      
      public static function fromLogLevelName(param1:String) : LogLevel
      {
         var _loc2_:LogLevel = null;
         var param1:String = param1.toUpperCase();
         switch(param1)
         {
            case LogLevel.INFO.getName():
               _loc2_ = LogLevel.INFO;
               break;
            case LogLevel.DEBUG.getName():
               _loc2_ = LogLevel.DEBUG;
               break;
            case LogLevel.WARN.getName():
               _loc2_ = LogLevel.WARN;
               break;
            case LogLevel.ERROR.getName():
               _loc2_ = LogLevel.ERROR;
               break;
            case LogLevel.FATAL.getName():
               _loc2_ = LogLevel.FATAL;
               break;
            default:
               _loc2_ = LogLevel.DEFAULT;
         }
         return _loc2_;
      }
      
      public function isGreaterOrEqual(param1:LogLevel) : Boolean
      {
         return this._level >= param1._level;
      }
      
      public function getValue() : uint
      {
         return this._level;
      }
      
      public function getName() : String
      {
         return this._name;
      }
   }
}
