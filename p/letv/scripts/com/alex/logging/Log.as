package com.alex.logging
{
   import flash.net.FileReference;
   import com.alex.logging.targets.TracerAndDebugger;
   import com.alex.logging.types.LogType;
   
   public class Log extends Object
   {
      
      private static var logCount:int = 0;
      
      private static var logs:Vector.<String> = new Vector.<String>();
      
      public static const MAX_LOG_NUM:uint = 500;
      
      public static const VERSION:String = "2.0.1";
      
      public static var traceDebug:Boolean = false;
      
      public function Log()
      {
         super();
      }
      
      private static function get logString() : String
      {
         var _loc1_:* = "";
         var _loc2_:int = logs.length;
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = _loc1_ + logs[_loc3_];
            _loc3_++;
         }
         return _loc1_;
      }
      
      public static function appendLog(param1:String, param2:Number) : void
      {
         var param1:String = "[" + logCount + " " + param1;
         if(traceDebug)
         {
            trace(param1);
         }
         if(logs.length >= MAX_LOG_NUM)
         {
            logs.shift();
         }
         logs.push("<div class=\'item\'><div class=\'item-value\'><span style=\'color:#fefefe\' >" + param1 + "</span></div></div><br />");
         logCount++;
      }
      
      public static function clearLocalLog() : void
      {
         while(logs.length > 0)
         {
            logs.shift();
         }
      }
      
      public static function getLocalLog() : void
      {
         var _loc1_:FileReference = new FileReference();
         _loc1_.save(getHtmlLog(),"letv_log.html");
      }
      
      public static function getHtmlLog() : String
      {
         var _loc1_:Date = new Date();
         var _loc2_:* = _loc1_.fullYear + "-" + String(_loc1_.month + 1) + "-" + _loc1_.date + " ";
         _loc2_ = _loc2_ + (_loc1_.hours + ":" + _loc1_.minutes + ":" + _loc1_.seconds + " ");
         var _loc3_:* = "<!DOCTYPE html PUBLIC \'-//W3C//DTD XHTML 1.0 Transitional//EN\' \'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\'><html xmlns=\'http://www.w3.org/1999/xhtml\'>";
         _loc3_ = _loc3_ + "<head><meta http-equiv=\'Content-Type\' content=\'text/html; charset=utf-8\'/>";
         _loc3_ = _loc3_ + "<title>Arthropod Log</title><style type=\'text/css\'>";
         _loc3_ = _loc3_ + "body {background: #151515;font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 15px;color: #fefefe;}";
         _loc3_ = _loc3_ + "#main-container{margin: 10px;clear: both;}";
         _loc3_ = _loc3_ + "#container{background: #252525;border: 1px solid #000;padding: 20px;}";
         _loc3_ = _loc3_ + "#header {font-family: \'Trebuchet MS\', Verdana, Arial, Helvetica, sans-serif;font-size: 25px;font-weight: bold;color: #fefefe;height: 85px;padding: 10px;}";
         _loc3_ = _loc3_ + "</style>";
         _loc3_ = _loc3_ + ("</head><body><div id=\'main-container\'><div id=\'header\'>Letv Log(乐视播放器日志)<br /> Date:" + _loc2_ + "</div>");
         _loc3_ = _loc3_ + "<div id=\'container\'>";
         _loc3_ = _loc3_ + (logString + "</div></div>");
         _loc3_ = _loc3_ + "Author : LinYang 微博:<a href=\'http://weibo.com/opensourceplatform\' target=\'_blank\'>Adobe洋仔</a></body></html>";
         return _loc3_;
      }
      
      public static function getLogger(param1:String = "trace") : ILogger
      {
         var _loc2_:ILogger = null;
         switch(param1)
         {
            case LogType.TRACE:
               _loc2_ = new TracerAndDebugger();
               break;
         }
         return _loc2_;
      }
   }
}
