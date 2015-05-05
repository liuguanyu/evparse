package com.p2p.utils
{
   import flash.net.Socket;
   import com.p2p.utils.json.JSONEncoder;
   import flash.errors.IOError;
   import flash.external.ExternalInterface;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.ProgressEvent;
   
   public class console extends Object
   {
      
      private static var _date:Date = null;
      
      private static var _browserParams:Object = null;
      
      private static var _allowOutputMsg:int = -1;
      
      private static var _preparedSocketStr:String = "";
      
      private static var _sendStr:String = "";
      
      private static var sket:Socket = new Socket();
      
      private static var _connectSuccess:Boolean = false;
      
      private static var _debugUser:String = "";
      
      private static var _title:String = "";
      
      private static var _log:Boolean;
      
      private static var _trc:Boolean;
      
      public static var _csl:Boolean;
      
      private static var count:int = 0;
      
      {
         _date = null;
         _browserParams = null;
         _allowOutputMsg = -1;
         _preparedSocketStr = "";
         _sendStr = "";
         sket = new Socket();
         _connectSuccess = false;
         _debugUser = "";
         _title = "";
         count = 0;
      }
      
      public function console()
      {
         super();
      }
      
      public static function setDirectDebug(... rest) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < rest.length)
         {
            if("log" == rest[_loc2_])
            {
               socket();
               _log = true;
            }
            else if("trace" == rest[_loc2_])
            {
               _trc = true;
            }
            else if("console" == rest[_loc2_])
            {
               _csl = true;
            }
            
            
            _loc2_++;
         }
         _allowOutputMsg = 1;
      }
      
      public static function info() : void
      {
      }
      
      public static function log(... rest) : void
      {
         var _loc3_:* = 0;
         if(0 == _allowOutputMsg)
         {
            return;
         }
         var _loc2_:* = false;
         if((rest[0]) && (rest[0].hasOwnProperty("isDebug")) && (rest[0].isDebug))
         {
            _loc2_ = true;
            if(_loc2_)
            {
               rest[0] = rest[0].toString().replace("object ","");
            }
            if(_browserParams == null)
            {
               _browserParams = GetLocationParam.GetBrowseLocationParams();
               if(_browserParams == null)
               {
                  _browserParams = {};
                  _allowOutputMsg = 0;
                  _preparedSocketStr = "";
                  return;
               }
               _title = _browserParams.title;
               if(_title.length > 10)
               {
                  _title = _title.substr(0,10);
               }
            }
            if(1 == _allowOutputMsg)
            {
               _sendStr = "";
               _sendStr = _sendStr + (rest[0] + " ");
               _loc3_ = 1;
               while(_loc3_ < rest.length)
               {
                  if(rest[_loc3_])
                  {
                     _sendStr = _sendStr + new JSONEncoder(rest[_loc3_]).getString();
                  }
                  _loc3_++;
               }
               sendMessage(_sendStr);
               return;
            }
            if(-1 == _allowOutputMsg)
            {
               if((_browserParams) && (_browserParams.hasOwnProperty("location")))
               {
                  _log = ParseUrl.getParam(_browserParams.location,"debug") == "log" || ParseUrl.getParam(_browserParams.location,"debug") == "true";
                  _trc = ParseUrl.getParam(_browserParams.location,"debug") == "trace";
                  _csl = ParseUrl.getParam(_browserParams.location,"debug") == "console";
                  if((_log) || (_trc) || (_csl))
                  {
                     _allowOutputMsg = 1;
                     _debugUser = ParseUrl.getParam(_browserParams.location,"debugUser");
                     _sendStr = "";
                     _sendStr = _sendStr + (rest[0] + " ");
                     _loc3_ = 1;
                     while(_loc3_ < rest.length)
                     {
                        _sendStr = _sendStr + new JSONEncoder(rest[_loc3_]).getString();
                        _loc3_++;
                     }
                     socket();
                     sendMessage(_sendStr);
                  }
                  else
                  {
                     _allowOutputMsg = 0;
                     _preparedSocketStr = "";
                  }
               }
            }
            return;
         }
      }
      
      protected static function sendMessage(param1:String) : void
      {
         var msg:String = param1;
         if(_log)
         {
            if(_connectSuccess == false)
            {
               _preparedSocketStr = _preparedSocketStr + (msg + "\n");
               return;
            }
            try
            {
               _date = new Date();
               msg = "[" + formatDate(_date) + "] " + msg;
               sket.writeObject({
                  "log":msg,
                  "fileName":_debugUser + _title + _browserParams.type
               });
               sket.flush();
            }
            catch(err:Error)
            {
               _connectSuccess = false;
               try
               {
                  sket.close();
               }
               catch(err:IOError)
               {
               }
            }
         }
         if(_trc)
         {
            try
            {
               _date = new Date();
               msg = "[" + formatDate(_date) + "] " + msg;
               trace(msg);
            }
            catch(err:Error)
            {
            }
         }
         if(_csl)
         {
            try
            {
               _date = new Date();
               msg = "[" + formatDate(_date) + "] " + msg;
               ExternalInterface.call("console.log",msg);
            }
            catch(err:Error)
            {
            }
         }
      }
      
      protected static function formatDate(param1:Date) : String
      {
         var _loc2_:* = "";
         _loc2_ = _loc2_ + (String(_date.getHours()).length == 1?"0" + _date.getHours():String(_date.getHours()));
         _loc2_ = _loc2_ + ":";
         _loc2_ = _loc2_ + (String(_date.getMinutes()).length == 1?"0" + _date.getMinutes():String(_date.getMinutes()));
         _loc2_ = _loc2_ + ":";
         _loc2_ = _loc2_ + (String(_date.getSeconds()).length == 1?"0" + _date.getSeconds():String(_date.getSeconds()));
         _loc2_ = _loc2_ + ":";
         var _loc3_:String = String(_date.milliseconds);
         while(_loc3_.length < 3)
         {
            _loc3_ = "0" + _loc3_;
         }
         _loc2_ = _loc2_ + _loc3_;
         return _loc2_;
      }
      
      protected static function socket() : void
      {
         if(_connectSuccess)
         {
            return;
         }
         if(!sket.hasEventListener(Event.CLOSE))
         {
            sket.addEventListener(Event.CLOSE,closeHandler);
            sket.addEventListener(Event.CONNECT,connectHandler);
            sket.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
            sket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
            sket.addEventListener(ProgressEvent.SOCKET_DATA,socketDataHandler);
         }
         sket.connect("10.58.132.242",23456);
      }
      
      protected static function connectHandler(param1:Event) : void
      {
         trace("连接成功22");
         _connectSuccess = true;
         _allowOutputMsg = 1;
         if(_preparedSocketStr != "")
         {
            sendMessage(_browserParams.location + "\n" + _preparedSocketStr);
            _preparedSocketStr = "";
         }
      }
      
      protected static function closeHandler(param1:Event) : void
      {
         _connectSuccess = false;
         _allowOutputMsg = 0;
      }
      
      protected static function ioErrorHandler(param1:IOErrorEvent) : void
      {
         _connectSuccess = false;
         _allowOutputMsg = 0;
      }
      
      protected static function securityErrorHandler(param1:SecurityErrorEvent) : void
      {
         _connectSuccess = false;
         _allowOutputMsg = 0;
      }
      
      protected static function socketDataHandler(param1:ProgressEvent) : void
      {
      }
   }
}
