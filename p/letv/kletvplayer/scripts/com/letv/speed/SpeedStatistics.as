package com.letv.speed
{
   import flash.net.URLRequest;
   import flash.system.Capabilities;
   import flash.net.sendToURL;
   
   public class SpeedStatistics extends Object
   {
      
      private static var _instance:SpeedStatistics;
      
      private static const SUBMIT_SPEED_URL:String = "http://dc.letv.com/tsp/l";
      
      public var uuid:String;
      
      public function SpeedStatistics()
      {
         super();
      }
      
      public static function getInstance() : SpeedStatistics
      {
         if(_instance == null)
         {
            _instance = new SpeedStatistics();
         }
         return _instance;
      }
      
      public function sendSpeedInfo(param1:Object) : void
      {
         var url:String = null;
         var item:String = null;
         var request:URLRequest = null;
         var value:Object = param1;
         try
         {
            url = SUBMIT_SPEED_URL;
            url = url + ("?fv=" + Capabilities.version);
            url = url + ("&uuid=" + this.uuid);
            for(item in value)
            {
               url = url + ("&" + item + "=" + value[item]);
            }
            request = new URLRequest(url);
            sendToURL(request);
         }
         catch(e:Error)
         {
            trace("[Error 发送测速统计失败]");
         }
      }
   }
}
