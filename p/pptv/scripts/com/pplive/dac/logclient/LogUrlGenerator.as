package com.pplive.dac.logclient
{
   import cn.pplive.player.utils.PrintDebug;
   
   class LogUrlGenerator extends Object
   {
      
      private var _logSource:DataLogSource;
      
      function LogUrlGenerator(param1:DataLogSource)
      {
         super();
         this._logSource = param1;
      }
      
      public function getLogSource() : DataLogSource
      {
         return this._logSource;
      }
      
      public function getLogUrl(param1:Vector.<DataLogItem>, param2:Vector.<DataLogItem>) : String
      {
         return this._logSource.getBaseUrl();
      }
      
      protected function appendUrlParam(param1:String, param2:Vector.<DataLogItem>) : String
      {
         var item:DataLogItem = null;
         var urlParams:String = param1;
         var items:Vector.<DataLogItem> = param2;
         for each(item in items)
         {
            try
            {
               urlParams = this.appendUrlParamImpl(urlParams,item.Name,item.Value);
            }
            catch(e:Error)
            {
               PrintDebug.Trace("错误 urlParams, item.Name|Value ",urlParams,item.Name,item.Value);
               continue;
            }
         }
         return urlParams;
      }
      
      protected function appendUrlParamImpl(param1:String, param2:String, param3:String) : String
      {
         if(param1.indexOf("&" + param2 + "=") > 0)
         {
            return param1;
         }
         if(param3.indexOf("%") >= 0 || param3.indexOf("&") >= 0 || param3.indexOf("=") >= 0)
         {
            var param3:String = encodeURIComponent(param3);
         }
         return param1 + param2 + "=" + param3 + "&";
      }
   }
}
